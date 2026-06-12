<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../services/AssignmentService.php';

class AssignmentController extends BaseController {
    private AssignmentService $service;

    public function __construct() {
        $this->service = new AssignmentService();
    }

    public function handle(string $method, ?int $id, array $body, array $query): void {
        // GET /api/assignments?active=1
        if ($method === 'GET' && !$id && isset($query['active'])) {
            $this->respond(['success' => true, 'data' => $this->service->getActive()]);
            return;
        }
        // GET /api/assignments?product_id=X
        if ($method === 'GET' && !$id && isset($query['product_id'])) {
            $this->respond(['success' => true, 'data' => $this->service->getByProduct((int)$query['product_id'])]);
            return;
        }
        // GET /api/assignments?stats=1
        if ($method === 'GET' && !$id && isset($query['stats'])) {
            $this->respond(['success' => true, 'data' => $this->service->getStats()]);
            return;
        }
        // GET /api/assignments?recent=1
        if ($method === 'GET' && !$id && isset($query['recent'])) {
            $limit = isset($query['limit']) ? (int)$query['limit'] : 10;
            $this->respond(['success' => true, 'data' => $this->service->getRecent($limit)]);
            return;
        }
        // GET /api/assignments?daily=1&days=7
        if ($method === 'GET' && !$id && isset($query['daily'])) {
            $days       = isset($query['days'])        ? (int)$query['days']        : 7;
            $locationId = isset($query['location_id']) ? (int)$query['location_id'] : null;
            $this->respond(['success' => true, 'data' => $this->service->getDailyCount($days, $locationId)]);
            return;
        }
        // GET /api/assignments?cat_deployed=1&days=7&location_id=1
        if ($method === 'GET' && !$id && isset($query['cat_deployed'])) {
            $days       = isset($query['days'])        ? (int)$query['days']        : 7;
            $locationId = isset($query['location_id']) ? (int)$query['location_id'] : null;
            $this->respond(['success' => true, 'data' => $this->service->getDeployedByCategoryByDays($days, $locationId)]);
            return;
        }
        // POST /api/assignments/{id}/return
        if ($method === 'POST' && $id && isset($query['action']) && $query['action'] === 'return') {
            $assignment = $this->service->returnAsset($id);
            $this->respond(['success' => true, 'data' => $assignment]);
            return;
        }

        match ($method) {
            'GET'    => $id ? $this->show($id) : $this->index(),
            'POST'   => $this->store($body),
            'PUT'    => $this->update($id, $body),
            'DELETE' => $this->destroy($id),
            default  => $this->respond(['error' => 'Method not allowed'], 405),
        };
    }

    private function index(): void {
        $this->respond(['success' => true, 'data' => $this->service->getAll()]);
    }

    private function show(int $id): void {
        $this->respond(['success' => true, 'data' => $this->service->getById($id)]);
    }

    private function store(array $body): void {
        if (!empty($_POST)) $body = array_merge($body, $_POST);
        $assignment = $this->service->create($body);
        $this->respond(['success' => true, 'data' => $assignment], 201);
    }

    private function update(?int $id, array $body): void {
        if (!$id) { $this->respond(['error' => 'ID required'], 400); return; }
        if (!empty($_POST)) $body = array_merge($body, $_POST);
        $assignment = $this->service->update($id, $body);
        $this->respond(['success' => true, 'data' => $assignment]);
    }

    private function destroy(?int $id): void {
        if (!$id) { $this->respond(['error' => 'ID required'], 400); return; }
        $this->service->delete($id);
        $this->respond(['success' => true, 'message' => 'Assignment deleted']);
    }

}
