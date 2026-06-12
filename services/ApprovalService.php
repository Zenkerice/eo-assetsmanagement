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
                $result = $this->execute($req);
                return [
                    'request' => $this->model->findById($id),
                    'result'  => $result,
                    'message' => 'Deployment completed',
                ];
            }
            throw new RuntimeException('Request has already been reviewed', 409);
        }
        if (!in_array($decision, ['approved', 'rejected'], true)) {
            throw new InvalidArgumentException('Decision must be "approved" or "rejected"');
        }

        $result   = null;
        $resource = $req['resource_name'] ?? $req['resource_type'];
        $action   = ucfirst($req['action_type']);

        if ($decision === 'approved') {
            $result = $this->execute($req);
            $this->model->review($id, $decision, $reviewedBy, $reviewNotes);
            AuditLogService::log('approved', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                'Approved by ' . $reviewedBy . ': ' . $req['action_type'] . ' on ' . $req['resource_type']);
        } else {
            $this->model->review($id, $decision, $reviewedBy, $reviewNotes);
            AuditLogService::log('rejected', $req['resource_type'], $req['resource_id'], $req['resource_name'],
                'Rejected by ' . $reviewedBy . ': ' . ($reviewNotes ?: 'No reason given'));
        }

        // Notify the staff member who submitted the request
        $notifType  = $decision === 'approved' ? 'approval_approved' : 'approval_rejected';
        $notifTitle = $decision === 'approved'
            ? "✅ Your request was approved"
            : "✖ Your request was rejected";
        $notifBody  = "{$action} {$req['resource_type']}: {$resource}"
            . ($reviewNotes ? " — \"{$reviewNotes}\"" : '');

        $this->notif->create([
            'for_role'    => 'staff',
            'for_user_id' => $req['user_id'] ?? null,
            'type'        => $notifType,
            'title'       => $notifTitle,
            'body'        => $notifBody,
            'link'        => 'requests.html',
            'meta'        => ['approval_id' => $id, 'decision' => $decision],
        ]);

        return [
            'request' => $this->model->findById($id),
            'result'  => $result,
        ];
    }

    // ── Execute approved action ───────────────────────────────────────────────

    private function execute(array $req): mixed {
        $payload      = is_string($req['payload']) ? json_decode($req['payload'], true) : ($req['payload'] ?? []);
        $resourceType = $req['resource_type'];
        $resourceId   = $req['resource_id'] ? (int)$req['resource_id'] : null;
        $actionType   = $req['action_type'];

        switch ($resourceType) {
            case 'Asset': case 'product': case 'products':
                require_once __DIR__ . '/ProductService.php';
                $svc = new ProductService();
                return match($actionType) {
                    'create' => $svc->create($payload),
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
                $svc = new AssignmentService();
                $assignmentPayload = $this->normalizeAssignmentPayload($payload, $req);
                return match($actionType) {
                    'create' => $svc->create($assignmentPayload),
                    'update' => $svc->update($resourceId, $assignmentPayload),
                    'delete' => $svc->delete($resourceId),
                    default  => null,
                };
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
