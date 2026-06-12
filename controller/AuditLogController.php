<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../services/AuditLogService.php';

class AuditLogController extends BaseController {
    private AuditLogService $service;

    public function __construct() {
        $this->service = new AuditLogService();
    }

    public function handle(string $method, ?int $id, array $body, array $query): void {
        if ($method !== 'GET') { $this->respond(['error' => 'Method not allowed'], 405); return; }

        // GET /api/audit_logs?users=1  — return distinct user list
        if (isset($query['users'])) {
            $this->respond(['success' => true, 'data' => $this->service->getUsers()]);
            return;
        }

        $page    = max(1, (int)($query['page']     ?? 1));
        $perPage = max(1, (int)($query['per_page'] ?? 20));

        $filters = array_filter([
            'action'  => $query['action']  ?? '',
            'user'    => $query['user']    ?? '',
            'entity'  => $query['entity']  ?? '',
            'search'  => $query['search']  ?? '',
            'period'  => $query['period']  ?? '',
            'from'    => $query['from']    ?? '',
            'to'      => $query['to']      ?? '',
        ]);

        $result = $this->service->getAll($filters, $page, $perPage);
        $this->respond([
            'success' => true,
            'data'    => $result['items'],
            'meta'    => [
                'total'    => $result['total'],
                'page'     => $page,
                'per_page' => $perPage,
                'pages'    => (int) ceil($result['total'] / $perPage),
            ],
        ]);
    }

}
