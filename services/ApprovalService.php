<?php
require_once __DIR__ . '/../model/ApprovalModel.php';
require_once __DIR__ . '/../model/ProductModel.php';
require_once __DIR__ . '/../model/CategoryModel.php';
require_once __DIR__ . '/../model/NotificationModel.php';
require_once __DIR__ . '/../services/AuditLogService.php';

/**
 * Handles the approval workflow for staff-initiated mutations.
 */
class ApprovalService {
    private ApprovalModel      $model;
    private NotificationModel  $notif;

    public function __construct() {
        $this->model = new ApprovalModel();
        $this->notif = new NotificationModel();
    }

    // ── Queue a request ───────────────────────────────────────────────────────

    public function queue(array $data): array {
        $id = $this->model->create($data);

        AuditLogService::log(
            'pending',
            $data['resource_type'],
            $data['resource_id'] ?? null,
            $data['resource_name'] ?? null,
            ucfirst($data['action_type']) . ' request submitted by ' . $data['requested_by'] . ' — awaiting approval'
        );

        // Notify all admins
        $action   = ucfirst($data['action_type']);
        $resource = $data['resource_name'] ?? $data['resource_type'];
        $this->notif->create([
            'for_role' => 'admin',
            'type'     => 'approval_submitted',
            'title'    => "New approval request from {$data['requested_by']}",
            'body'     => "{$action} {$data['resource_type']}: {$resource}",
            'link'     => 'approvals.html',
            'meta'     => ['approval_id' => $id, 'action_type' => $data['action_type']],
        ]);

        return $this->model->findById($id);
    }

    // ── Count pending ─────────────────────────────────────────────────────────

    public function countPending(): int {
        return $this->model->countPending();
    }

    // ── List ──────────────────────────────────────────────────────────────────

    public function getAll(array $filters = []): array {
        return $this->model->findAll($filters);
    }

    public function getById(int $id): array {
        $row = $this->model->findById($id);
        if (!$row) throw new RuntimeException('Approval request not found', 404);
        return $row;
    }

    public function cancel(int $id, string $userName): void {
        $req = $this->getById($id);
        if ($req['status'] !== 'pending') {
            throw new RuntimeException('Only pending requests can be cancelled', 409);
        }
        if ($req['requested_by'] !== $userName) {
            throw new RuntimeException('Access denied', 403);
        }
        if (!$this->model->deletePending($id)) {
            throw new RuntimeException('Could not cancel request', 500);
        }
        AuditLogService::log(
            'cancelled',
            $req['resource_type'],
            $req['resource_id'] ?? null,
            $req['resource_name'] ?? null,
            'Request cancelled by ' . $userName
        );
    }

    // ── Review (admin only) ───────────────────────────────────────────────────

    public function review(int $id, string $decision, string $reviewedBy, ?string $reviewNotes = null): array {
        $req = $this->getById($id);

        if ($req['status'] !== 'pending') {
            // Recovery path: older bug marked approved before execute ran
            if ($decision === 'approved' && $req['status'] === 'approved'
                && strtolower($req['resource_type']) === 'assignment'
                && $req['action_type'] === 'create') {
                $result = $this->execute($req, $reviewedBy);
                return [
                    'request' => $this->model->findById($id),
                    'result'  => $result,
                    'message' => 'Deployment completed',
                ];
            }
            throw new RuntimeException('Request has already been reviewed', 409);
        }
        if (!in_array($decision, ['approved', 'rejected', 'forwarded'], true)) {
            throw new InvalidArgumentException('Decision must be "approved", "rejected", or "forwarded"');
        }

        $result   = null;
        $resource = $req['resource_name'] ?? $req['resource_type'];
        $action   = ucfirst($req['action_type']);

        // Asset-type requests from the request form are "forwarded to requestor" —
        // skip execute() since the payload is a request form, not a product creation payload.
        $isAssetForward = $req['resource_type'] === 'Asset' && $decision === 'forwarded';

        if ($decision === 'approved') {
            $result = $this->execute($req, $reviewedBy);
            $this->model->review($id, 'approved', $reviewedBy, $reviewNotes);
            AuditLogService::log('approved', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                'Approved by ' . $reviewedBy . ': ' . $req['action_type'] . ' on ' . $req['resource_type']);
        } elseif ($decision === 'forwarded') {
            $this->model->review($id, 'forwarded', $reviewedBy, $reviewNotes);
            AuditLogService::log('forwarded', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                'Forwarded to requestor by ' . $reviewedBy);
        } else {
            $this->model->review($id, 'rejected', $reviewedBy, $reviewNotes);
            AuditLogService::log('rejected', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                'Rejected by ' . $reviewedBy . ': ' . ($reviewNotes ?: 'No reason given'));
        }

        // Notify the staff member who submitted the request
        $isAssetForward = $decision === 'forwarded';
        $notifType  = match($decision) {
            'approved'  => 'approval_approved',
            'rejected'  => 'approval_rejected',
            'forwarded' => 'approval_forwarded',
            default     => 'approval_approved',
        };
        $notifTitle = $isAssetForward
            ? "📋 Asset Form Confirmation"
            : ($decision === 'approved' ? "✅ Your request was approved" : "✖ Your request was rejected");

        $friendlyType = $req['resource_type'] === 'asset_request' ? 'Asset Request' : $req['resource_type'];
        $notifBody  = $isAssetForward
            ? "Your asset request for \"{$resource}\" requires your confirmation. Please review and sign the accountability form."
            : ("{$action} {$friendlyType}: {$resource}" . ($reviewNotes ? " — \"{$reviewNotes}\"" : ''));

        $this->notif->create([
            'for_role'    => 'staff',
            'for_user_id' => $req['user_id'] ?? null,
            'type'        => $notifType,
            'title'       => $notifTitle,
            'body'        => $notifBody,
            'link'        => $isAssetForward ? 'requests.html?tab=myrequests' : 'requests.html',
            'meta'        => ['approval_id' => $id, 'decision' => $decision],
        ]);

        return [
            'request' => $this->model->findById($id),
            'result'  => $result,
        ];
    }

    // ── Execute approved action ───────────────────────────────────────────────

    private function execute(array $req, string $reviewedBy = 'Admin'): mixed {
        $payload      = is_string($req['payload']) ? json_decode($req['payload'], true) : ($req['payload'] ?? []);
        $resourceType = $req['resource_type'];
        $resourceId   = $req['resource_id'] ? (int)$req['resource_id'] : null;
        $actionType   = $req['action_type'];

        switch ($resourceType) {
            case 'Asset': case 'product': case 'products':
                require_once __DIR__ . '/ProductService.php';
                require_once __DIR__ . '/AssignmentService.php';
                $svc = new ProductService();
                if ($actionType === 'create') {
                    $product = $svc->create($payload);
                    // If the asset was created with an assigned employee, also create
                    // an assignment record so it appears in the employee's "My Assets".
                    $assigneeName = trim($payload['assigned_employee'] ?? '');
                    if ($assigneeName !== '' && !empty($product['id'])) {
                        try {
                            $assignSvc = new AssignmentService();
                            // Use deployed_date from the payload as assigned_at if provided
                            $deployedAt = !empty($payload['deployed_date'])
                                ? (new \DateTime($payload['deployed_date']))->format('Y-m-d H:i:s')
                                : null;
                            $assignSvc->create([
                                'product_id'    => (int)$product['id'],
                                'assignee_name' => $assigneeName,
                                'assigned_by'   => $reviewedBy,
                                'location_id'   => !empty($payload['location_id']) ? (int)$payload['location_id'] : null,
                                'notes'         => null,
                                ...($deployedAt ? ['assigned_at' => $deployedAt] : []),
                            ], skipAvailabilityCheck: true);
                        } catch (\Exception $e) {
                            // Non-fatal — the product was created; assignment is best-effort.
                        }
                    }
                    return $product;
                }
                return match($actionType) {
                    'update' => $svc->update($resourceId, $payload),
                    'delete' => $svc->delete($resourceId),
                    default  => null,
                };
            case 'Category': case 'category': case 'categories':
                require_once __DIR__ . '/../services/CategoryService.php';
                $svc = new CategoryService();
                return match($actionType) {
                    'create' => $svc->create($payload),
                    'update' => $svc->update($resourceId, $payload),
                    'delete' => $svc->delete($resourceId),
                    default  => null,
                };
            case 'Assignment': case 'assignment': case 'assignments':
                require_once __DIR__ . '/AssignmentService.php';
                require_once __DIR__ . '/../model/AssignmentModel.php';
                $svc = new AssignmentService();
                $assignmentPayload = $this->normalizeAssignmentPayload($payload, $req);

                // For delete (return), read the assignment BEFORE deleting so we keep product_id
                $preDeleteAssignment = null;
                if ($actionType === 'delete' && $resourceId) {
                    $am = new AssignmentModel();
                    $preDeleteAssignment = $am->findById($resourceId);
                }

                $result = match($actionType) {
                    'create' => $svc->create($assignmentPayload, skipAvailabilityCheck: true),
                    'update' => $svc->update($resourceId, $assignmentPayload),
                    'delete' => $svc->delete($resourceId),
                    default  => null,
                };

                // After a return approval: if condition is damaged/broken, auto-create damage record
                if ($actionType === 'delete') {
                    $condition = strtolower(trim($payload['condition'] ?? ''));
                    if (in_array($condition, ['damaged', 'broken'], true)) {
                        // Resolve product_id: prefer payload, fallback to pre-delete snapshot
                        $productId = (int)($payload['product_id'] ?? 0);
                        if (!$productId && $preDeleteAssignment) {
                            $productId = (int)($preDeleteAssignment['product_id'] ?? 0);
                        }
                        if ($productId) {
                            require_once __DIR__ . '/DamageService.php';
                            $dmgSvc     = new DamageService();
                            $issueLabel = $condition === 'broken' ? 'Broken / non-functional' : 'Damaged — needs repair';
                            $issueNote  = $payload['notes'] ?? '';
                            try {
                                $dmgSvc->create([
                                    'product_id'  => $productId,
                                    'reported_by' => $req['requested_by'] ?? 'System',
                                    'issue'       => $issueLabel . ($issueNote ? ': ' . $issueNote : ''),
                                    'status'      => 'damaged',
                                ]);
                            } catch (\Exception $e) {
                                // Non-fatal — return was already processed
                            }
                        }
                    }
                }
                return $result;
            case 'Damage': case 'damage': case 'damages':
                require_once __DIR__ . '/DamageService.php';
                $svc = new DamageService();
                return match($actionType) {
                    'create' => $svc->create($payload),
                    'update' => $svc->update($resourceId, $payload),
                    'delete' => $svc->delete($resourceId),
                    default  => null,
                };
            case 'Supplier': case 'supplier': case 'suppliers':
                require_once __DIR__ . '/SupplierService.php';
                $svc = new SupplierService();
                return match($actionType) {
                    'create' => $svc->createSupplier($payload),
                    'update' => $svc->updateSupplier($resourceId, $payload),
                    'delete' => $svc->deleteSupplier($resourceId),
                    default  => null,
                };
            case 'asset_request':
                // Request Form submission — create assignments for each requested asset.
                require_once __DIR__ . '/AssignmentService.php';
                require_once __DIR__ . '/../model/ProductModel.php';
                $assignSvc   = new AssignmentService();
                $productModel = new ProductModel();
                $assigneeName = trim($payload['assignee'] ?? $req['requested_by'] ?? 'Unknown');
                $assignedBy   = $req['reviewed_by'] ?? 'Admin';
                $dueBack      = null;
                if (!empty($payload['expected_return'])) {
                    // Normalise various date formats to Y-m-d
                    $parsed = date_create($payload['expected_return']);
                    $dueBack = $parsed ? date_format($parsed, 'Y-m-d') : null;
                }
                $notes    = trim($payload['purpose'] ?? $req['notes'] ?? '');
                $assets   = $payload['assets'] ?? [];
                $created  = [];

                foreach ($assets as $asset) {
                    $assetName = trim($asset['name'] ?? '');
                    $assetTag  = trim($asset['tag']  ?? '');
                    if ($assetName === '') continue;

                    // Try to find the product by serial number first, then by name
                    $product = null;
                    if ($assetTag !== '') {
                        $product = $productModel->findBySku($assetTag);
                        if (!$product) {
                            $product = $productModel->findBySerial($assetTag);
                        }
                    }
                    // Also try to parse a serial/SKU out of the brand field
                    // (the accountability form puts brand+serial together, e.g. "SY SY-202")
                    if (!$product) {
                        $assetBrand = trim($asset['brand'] ?? '');
                        if ($assetBrand !== '') {
                            // Each space-delimited token could be a serial number or SKU
                            foreach (explode(' ', $assetBrand) as $token) {
                                $token = trim($token);
                                if ($token === '') continue;
                                $product = $productModel->findBySku($token);
                                if (!$product) $product = $productModel->findBySerial($token);
                                if ($product) break;
                            }
                        }
                    }
                    if (!$product) {
                        $matches = $productModel->findByName($assetName);
                        $product = $matches[0] ?? null;
                    }
                    // Last resort: partial name match (e.g. "Headsets" → "SY Headset")
                    if (!$product) {
                        $product = $productModel->findByPartialName($assetName);
                    }
                    if (!$product) continue; // product not found in inventory — skip

                    try {
                        $assignment = $assignSvc->create([
                            'product_id'    => (int)$product['id'],
                            'assignee_name' => $assigneeName,
                            'assigned_by'   => $assignedBy,
                            'due_back'      => $dueBack,
                            'notes'         => $notes ?: null,
                            'location_id'   => $product['location_id'] ?? null,
                        ], skipAvailabilityCheck: true);
                        $created[] = $assignment['id'];
                    } catch (\Exception $e) {
                        // Non-fatal — continue with remaining assets
                    }
                }
                return ['assignments_created' => $created];
            default:
                throw new RuntimeException("Cannot execute action for resource type: $resourceType");
        }
    }

    /** Map approval payload fields to assignment create/update input */
    private function normalizeAssignmentPayload(array $payload, array $req): array {
        $due = $payload['due_back'] ?? $payload['date_needed'] ?? null;
        $notes = $payload['notes'] ?? $payload['reason'] ?? null;
        if (!empty($payload['station'])) {
            $stationNote = 'Station: ' . $payload['station'];
            $notes = $notes ? ($notes . ' | ' . $stationNote) : $stationNote;
        }

        return [
            'product_id'    => (int) ($payload['product_id'] ?? 0),
            'assignee_name' => trim($payload['assignee_name'] ?? ''),
            'assigned_by'   => trim($payload['assigned_by'] ?? $req['requested_by'] ?? 'Admin'),
            'due_back'      => $due ?: null,
            'notes'         => $notes,
            'location_id'   => $payload['location_id'] ?? null,
        ];
    }
}
