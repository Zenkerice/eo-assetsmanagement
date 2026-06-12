<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../services/DamageService.php';

class DamageController extends BaseController {
    private DamageService $service;

    public function __construct() {
        $this->service = new DamageService();
    }

    public function handle(string $method, ?int $id, array $body, array $query): void {
        if ($method === 'GET' && isset($query['category_id'])) {
            $this->respond(['success' => true, 'data' => $this->service->getByCategory((int)$query['category_id'])]);
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
        $damage = $this->service->create($body);
        $this->respond(['success' => true, 'data' => $damage], 201);
    }

    private function update(?int $id, array $body): void {
        if (!$id) { $this->respond(['error' => 'ID required'], 400); return; }
        if (!empty($_POST)) $body = array_merge($body, $_POST);
        $damage = $this->service->update($id, $body);
        $this->respond(['success' => true, 'data' => $damage]);
    }

    private function destroy(?int $id): void {
        if (!$id) { $this->respond(['error' => 'ID required'], 400); return; }
        $this->service->delete($id);
        $this->respond(['success' => true, 'message' => 'Damage report deleted']);
    }

}
