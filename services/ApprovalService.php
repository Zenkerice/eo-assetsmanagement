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

    // ── Staff confirms a forwarded request ────────────────────────────────────

    public function confirm(int $id, string $userName): array {
        $req = $this->getById($id);

        if ($req['status'] !== 'forwarded') {
            throw new RuntimeException('Only forwarded requests can be confirmed', 409);
        }
        if ($req['requested_by'] !== $userName) {
            throw new RuntimeException('Access denied', 403);
        }

        // Mark as confirmed — asset is NOT deployed yet.
        // Admin must fill serial numbers and re-forward before the asset is assigned.
        $this->model->review($id, 'confirmed', $userName, 'Assets confirmed by requestor — awaiting serial release');

        AuditLogService::log(
            'updated',
            $req['resource_type'],
            $req['resource_id'] ?? null,
            $req['resource_name'] ?? null,
            'Assets confirmed by ' . $userName . ' — pending admin serial release'
        );

        // Notify all admins: staff confirmed, add serials and re-forward
        $this->notif->create([
            'for_role' => 'admin',
            'type'     => 'asset_confirmed',
            'title'    => '✅ Assets confirmed — release serial',
            'body'     => $userName . ' has confirmed the assets for "' . ($req['resource_name'] ?? 'Asset') . '". Assets confirmed, you may now release serial.',
            'link'     => 'approvals.html',
            'meta'     => ['approval_id' => $id, 'confirmed_by' => $userName],
        ]);

        // Notify the requestor that their confirmation was received
        $this->notif->create([
            'for_role'    => 'staff',
            'for_user_id' => $req['user_id'] ?? null,
            'type'        => 'approval_forwarded',
            'title'       => '⏳ Waiting for admin approval',
            'body'        => 'Your confirmation for "' . ($req['resource_name'] ?? 'Asset') . '" has been received. Waiting for the admin to release the serial number.',
            'link'        => 'requests.html',
            'meta'        => ['approval_id' => $id],
        ]);

        return [
            'request' => $this->model->findById($id),
        ];
    }

    /**
     * Handle a forwarded Asset/asset_request approval confirmation by the staff member.
     * Finds the best matching available product and creates an assignment.
     */
    private function executeForwardedAssetRequest(array $req, array $payload, string $assigneeName): array {
        require_once __DIR__ . '/AssignmentService.php';
        require_once __DIR__ . '/../model/ProductModel.php';

        $assignSvc    = new AssignmentService();
        $productModel = new ProductModel();
        $assignedBy   = $req['reviewed_by'] ?? 'Admin';
        $created      = [];

        // Resolve assignee name — prefer explicit payload field, fall back to session user
        $resolvedAssignee = trim(
            $payload['requestor_name'] ?? $payload['assignee_name'] ?? $payload['assignee'] ?? $assigneeName
        );
        if ($resolvedAssignee === '') $resolvedAssignee = $assigneeName;

        // Collect assets list — either explicit assets array or single item from payload fields
        $assets = $payload['assets'] ?? [];
        if (empty($assets)) {
            // Single-asset request built from brand/model/category fields
            $assets = [[
                'name'  => $payload['resource_name'] ?? $req['resource_name'] ?? '',
                'brand' => $payload['brand']  ?? '',
                'tag'   => $payload['serial_number'] ?? $payload['sku'] ?? '',
            ]];
        }

        // Build a set of product_ids already actively assigned to this person so we
        // never re-deploy a pre-filled row that represents an existing assignment.
        $existingProductIds = [];
        foreach ($assignSvc->getByAssigneeName($resolvedAssignee) as $er) {
            $existingProductIds[(int)$er['product_id']] = true;
        }

        foreach ($assets as $asset) {
            $assetName  = trim($asset['name']  ?? $req['resource_name'] ?? '');
            $assetTag   = trim($asset['tag']   ?? $payload['serial_number'] ?? $payload['sku'] ?? '');
            $assetBrand = trim($asset['brand'] ?? $payload['brand'] ?? '');

            // Skip rows with no identifying information — empty rows from the
            // accountability form that the admin left blank.
            if ($assetTag === '' && $assetBrand === '') continue;

            $product = null;

            // Helper: PDO fetch() returns false on no match; ?? only skips null,
            // so we normalise false → null before assigning.
            $fetch = static function($result) {
                return ($result !== false && $result !== null) ? $result : null;
            };

            // 1. Try serial / SKU tag (explicit tag takes highest priority)
            if ($assetTag !== '') {
                $product = $fetch($productModel->findBySku($assetTag))
                        ?? $fetch($productModel->findBySerial($assetTag));
            }

            // 2. Brand field as a serial — only when it has no spaces (i.e. looks
            // like a SKU/serial code, not a descriptive brand name).
            if (!$product && $assetBrand !== '' && strpos($assetBrand, ' ') === false) {
                $product = $fetch($productModel->findBySku($assetBrand))
                        ?? $fetch($productModel->findBySerial($assetBrand));
            }

            // 3. Exact name match — available products only to avoid phantom deployments.
            if (!$product && $assetName !== '') {
                foreach ($productModel->findByName($assetName) as $m) {
                    if ($m['asset_status'] === 'available') { $product = $m; break; }
                }
                // Allow any status only when an explicit tag was also provided
                if (!$product && $assetTag !== '') {
                    $matches = $productModel->findByName($assetName);
                    if (!empty($matches)) $product = $matches[0];
                }
            }

            // 4. Category-filtered search — last resort, available units only.
            if (!$product) {
                $catId = !empty($asset['category_id'])
                    ? (int)$asset['category_id']
                    : (!empty($payload['category_id']) ? (int)$payload['category_id'] : null);
                if ($catId) {
                    $candidates = $productModel->findAvailableByCategory($catId);
                    $product = $candidates[0] ?? null;
                }
            }

            // 5. Partial name match — available units only.
            if (!$product && $assetName !== '') {
                $candidate = $fetch($productModel->findByPartialName($assetName));
                if ($candidate && ($candidate['asset_status'] === 'available' || $assetTag !== '')) {
                    $product = $candidate;
                }
            }

            if (!$product) continue; // no matching product — skip

            // Skip products already actively assigned to this person — these are
            // pre-filled rows from existing assignments and must not be re-deployed.
            if (isset($existingProductIds[(int)$product['id']])) continue;

            try {
                $assignment = $assignSvc->create([
                    'product_id'    => (int)$product['id'],
                    'assignee_name' => $resolvedAssignee,
                    'assigned_by'   => $assignedBy,
                    'due_back'      => null,
                    'notes'         => trim($payload['description'] ?? $payload['purpose'] ?? $req['notes'] ?? '') ?: null,
                    'location_id'   => $product['location_id'] ?? null,
                ], skipAvailabilityCheck: true);
                $created[] = $assignment['id'];
            } catch (\Exception $e) {
                // Non-fatal — continue with remaining assets
            }
        }

        return ['assignments_created' => $created];
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
            // Re-forward path: admin fills serials on a confirmed request and forwards to staff
            if ($decision === 'forwarded' && $req['status'] === 'confirmed') {
                $this->model->review($id, 'forwarded', $reviewedBy, $reviewNotes ?? 'Serial added by admin');
                AuditLogService::log('forwarded', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                    'Re-forwarded with serial numbers by ' . $reviewedBy);
                $this->notif->create([
                    'for_role'    => 'staff',
                    'for_user_id' => $req['user_id'] ?? null,
                    'type'        => 'approval_forwarded',
                    'title'       => '📦 Assets Ready — Please Receive',
                    'body'        => 'The serial number of your assets for "' . ($req['resource_name'] ?? 'Asset') . '" is released. Please receive the assets.',
                    'link'        => 'requests.html?tab=myrequests',
                    'meta'        => ['approval_id' => $id],
                ]);
                return [
                    'request' => $this->model->findById($id),
                    'message' => 'Forwarded with serial numbers',
                ];
            }
            // Update-and-re-forward path: admin updates serials on an already-forwarded request
            if ($decision === 'forwarded' && $req['status'] === 'forwarded') {
                $this->model->review($id, 'forwarded', $reviewedBy, $reviewNotes ?? 'Serial updated by admin');
                AuditLogService::log('forwarded', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                    'Serial numbers updated and re-forwarded by ' . $reviewedBy);
                $this->notif->create([
                    'for_role'    => 'staff',
                    'for_user_id' => $req['user_id'] ?? null,
                    'type'        => 'approval_forwarded',
                    'title'       => '📦 Assets Ready — Please Receive',
                    'body'        => 'The serial number of your assets for "' . ($req['resource_name'] ?? 'Asset') . '" is released. Please receive the assets.',
                    'link'        => 'requests.html?tab=myrequests',
                    'meta'        => ['approval_id' => $id],
                ]);
                return [
                    'request' => $this->model->findById($id),
                    'message' => 'Re-forwarded with updated serial numbers',
                ];
            }
            // Release path: admin releases assets from a forwarded request directly → deploy
            if ($decision === 'approved' && $req['status'] === 'forwarded') {
                $payload = is_string($req['payload']) ? json_decode($req['payload'], true) : ($req['payload'] ?? []);
                $assigneeName = trim($payload['admin_assignee'] ?? $payload['requestor_name'] ?? $req['requested_by'] ?? '');
                $result = $this->executeForwardedAssetRequest($req, $payload, $assigneeName);
                $this->model->review($id, 'approved', $reviewedBy, $reviewNotes ?? 'Assets released by admin');
                AuditLogService::log('approved', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                    'Assets released and deployed by ' . $reviewedBy);
                $this->notif->create([
                    'for_role'    => 'staff',
                    'for_user_id' => $req['user_id'] ?? null,
                    'type'        => 'approval_approved',
                    'title'       => '✅ Asset assigned to you',
                    'body'        => '"' . ($req['resource_name'] ?? 'Asset') . '" has been released by the admin and is now assigned to you.',
                    'link'        => 'requests.html?tab=myassets',
                    'meta'        => ['approval_id' => $id],
                ]);
                return [
                    'request' => $this->model->findById($id),
                    'result'  => $result,
                    'message' => 'Assets released and deployed',
                ];
            }
            // Release path: admin approves a staff-confirmed request (serial release → deploy)
            if ($decision === 'approved' && $req['status'] === 'confirmed') {
                $payload = is_string($req['payload']) ? json_decode($req['payload'], true) : ($req['payload'] ?? []);
                $assigneeName = trim($payload['admin_assignee'] ?? $payload['requestor_name'] ?? $req['requested_by'] ?? '');
                $result = $this->executeForwardedAssetRequest($req, $payload, $assigneeName);
                $this->model->review($id, 'approved', $reviewedBy, $reviewNotes ?? 'Serial released by admin');
                AuditLogService::log('approved', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                    'Serial released and asset deployed by ' . $reviewedBy);
                $this->notif->create([
                    'for_role'    => 'staff',
                    'for_user_id' => $req['user_id'] ?? null,
                    'type'        => 'approval_approved',
                    'title'       => '✅ Asset assigned to you',
                    'body'        => '"' . ($req['resource_name'] ?? 'Asset') . '" has been released by the admin and is now assigned to you.',
                    'link'        => 'requests.html?tab=myassets',
                    'meta'        => ['approval_id' => $id],
                ]);
                return [
                    'request' => $this->model->findById($id),
                    'result'  => $result,
                    'message' => 'Serial released and asset deployed',
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
                    $assetName      = trim($asset['name']       ?? '');
                    $assetTag       = trim($asset['tag']        ?? '');
                    $assetBrand     = trim($asset['brand']      ?? '');
                    $assetModel     = trim($asset['model']      ?? '');
                    $assetCatName   = trim($asset['category_name'] ?? '');
                    $assetBrandModel = trim($asset['brand_model'] ?? '');

                    // Reconstruct brand_model if stored split
                    if ($assetBrandModel === '' && $assetBrand !== '' && $assetModel !== '') {
                        $assetBrandModel = $assetBrand . ' ' . $assetModel;
                    }

                    // Skip rows that carry no identifying data.
                    if ($assetTag === '' && $assetBrand === '' && $assetName === '' && $assetCatName === '') continue;

                    // PDO fetch() returns false on no match; normalise to null.
                    $fetch = static function($r) { return ($r !== false && $r !== null) ? $r : null; };

                    // 1. Try serial / SKU tag (explicit tag takes highest priority)
                    $product = null;
                    if ($assetTag !== '') {
                        $product = $fetch($productModel->findBySku($assetTag))
                                ?? $fetch($productModel->findBySerial($assetTag));
                    }

                    // 2. Brand field as serial — only when it has no spaces.
                    if (!$product && $assetBrand !== '' && strpos($assetBrand, ' ') === false) {
                        $product = $fetch($productModel->findBySku($assetBrand))
                                ?? $fetch($productModel->findBySerial($assetBrand));
                    }

                    // 3. Exact name match — available products only.
                    if (!$product && $assetName !== '') {
                        $matches = $productModel->findByName($assetName);
                        foreach ($matches as $m) {
                            if ($m['asset_status'] === 'available') { $product = $m; break; }
                        }
                        if (!$product && $assetTag !== '' && !empty($matches)) {
                            $product = $matches[0];
                        }
                    }

                    // 4. Match by brand_model combined string (e.g. "Apple MacBook Neo")
                    if (!$product && $assetBrandModel !== '') {
                        $bmMatches = $productModel->findByBrandModel($assetBrandModel);
                        foreach ($bmMatches as $m) {
                            if ($m['asset_status'] === 'available') { $product = $m; break; }
                        }
                        if (!$product && !empty($bmMatches)) $product = $bmMatches[0];
                    }

                    // 5. Partial name match — available units only
                    if (!$product && $assetName !== '') {
                        $product = $productModel->findByPartialName($assetName);
                        if ($product && $product['asset_status'] !== 'available' && $assetTag === '') {
                            $product = null;
                        }
                    }

                    // 6. Category name fallback — first available product in that category
                    if (!$product && $assetCatName !== '') {
                        $catMatches = $productModel->findAvailableByCategoryName($assetCatName);
                        if (!empty($catMatches)) $product = $catMatches[0];
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
