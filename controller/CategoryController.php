<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../services/CategoryService.php';

class CategoryController extends BaseController {
    private CategoryService $service;

    public function __construct() {
        $this->service = new CategoryService();
    }

    public function handle(string $method, ?int $id, array $body): void {
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
        $category = $this->service->create($body);
        $this->respond(['success' => true, 'data' => $category], 201);
    }

    private function update(?int $id, array $body): void {
        if (!$id) { $this->respond(['error' => 'ID required'], 400); return; }
        $category = $this->service->update($id, $body);
        $this->respond(['success' => true, 'data' => $category]);
    }

    private function destroy(?int $id): void {
        if (!$id) { $this->respond(['error' => 'ID required'], 400); return; }
        $this->service->delete($id);
        $this->respond(['success' => true, 'message' => 'Category deleted']);
    }

}
