<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../services/ApprovalService.php';

/**
 * Handles /api/approvals
 *
 * GET  /api/approvals              — list all (admin sees all; staff sees own)
 * GET  /api/approvals?pending=1    — count pending (for badge)
 * GET  /api/approvals/{id}         — single request
 * POST /api/approvals              — queue a new request (staff)
 * PUT  /api/approvals/{id}         — review (approve/reject, admin only)
 */
class ApprovalController extends BaseController {
    private ApprovalService $service;

    public function __construct() {
        $this->service = new ApprovalService();
    }

    public function handle(string $method, ?int $id, array $body, array $query): void {
        try {
            // Badge count — GET /api/approvals?pending=1
            if ($method === 'GET' && isset($query['pending'])) {
                $this->respond(['success' => true, 'data' => ['count' => $this->service->countPending()]]);
                return;
            }

            match (true) {
                $method === 'GET'  && !$id => $this->index($query),
                $method === 'GET'  &&  $id => $this->show($id),
                $method === 'POST' && !$id => $this->store($body),
                $method === 'PUT'  &&  $id => $this->review($id, $body),
                $method === 'DELETE' && $id => $this->cancel($id),
                default => $this->respond(['error' => 'Method not allowed'], 405),
            };
        } catch (InvalidArgumentException $e) {
            $this->respond(['success' => false, 'error' => $e->getMessage()], 400);
        } catch (RuntimeException $e) {
            $this->respond(['success' => false, 'error' => $e->getMessage()], $e->getCode() ?: 500);
        }
    }

    private function index(array $query): void {
        $role  = $_SESSION['user']['role'] ?? 'staff';
        $filters = [];

        if (!empty($query['status']))        $filters['status']        = $query['status'];
        if (!empty($query['resource_type'])) $filters['resource_type'] = $query['resource_type'];

        $all = $this->service->getAll($filters);

        // Staff only see their own requests
        if ($role !== 'admin') {
            $userName = $_SESSION['user']['name'] ?? '';
            $all = array_values(array_filter($all, fn($r) => $r['requested_by'] === $userName));
        }

        $this->respond(['success' => true, 'data' => $all]);
    }

    private function show(int $id): void {
        $req  = $this->service->getById($id);
        $role = $_SESSION['user']['role'] ?? 'staff';
        if ($role !== 'admin' && $req['requested_by'] !== ($_SESSION['user']['name'] ?? '')) {
            $this->respond(['success' => false, 'error' => 'Access denied'], 403);
            return;
        }
        $this->respond(['success' => true, 'data' => $req]);
    }

    private function store(array $body): void {
        $user  = $_SESSION['user'] ?? [];
        $data  = [
            'requested_by'  => $user['name']      ?? 'Unknown',
            'user_id'       => $user['id']         ?? null,
            'action_type'   => $body['action_type']   ?? 'create',
            'resource_type' => $body['resource_type'] ?? '',
            'resource_id'   => !empty($body['resource_id']) ? (int)$body['resource_id'] : null,
            'resource_name' => $body['resource_name'] ?? null,
            'payload'       => $body['payload']        ?? [],
            'notes'         => $body['notes']           ?? null,
        ];

        if (empty($data['resource_type'])) {
            $this->respond(['success' => false, 'error' => 'resource_type is required'], 400);
            return;
        }

        $req = $this->service->queue($data);
        $this->respond(['success' => true, 'data' => $req, 'message' => 'Request submitted for admin approval'], 201);
    }

    private function review(int $id, array $body): void {
        // Admin only
        $role = $_SESSION['user']['role'] ?? 'staff';
        if ($role !== 'admin') {
            $this->respond(['success' => false, 'error' => 'Admin access required'], 403);
            return;
        }

        $decision    = $body['decision']     ?? '';
        $reviewNotes = $body['review_notes'] ?? null;
        $reviewedBy  = $_SESSION['user']['name'] ?? 'Admin';

        $result = $this->service->review($id, $decision, $reviewedBy, $reviewNotes);
        $this->respond([
            'success' => true,
            'data'    => $result,
            'message' => 'Request ' . $decision,
        ]);
    }

    private function cancel(int $id): void {
        $role = $_SESSION['user']['role'] ?? 'staff';
        if ($role === 'admin') {
            $this->respond(['success' => false, 'error' => 'Use the approvals page to manage requests'], 403);
            return;
        }
        $userName = $_SESSION['user']['name'] ?? '';
        $this->service->cancel($id, $userName);
        $this->respond(['success' => true, 'message' => 'Request cancelled']);
    }

}
