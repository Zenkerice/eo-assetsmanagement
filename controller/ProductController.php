<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../services/ProductService.php';

class ProductController extends BaseController {
    private ProductService $service;

    public function __construct() {
        $this->service = new ProductService();
    }

    public function handle(string $method, ?int $id, array $body, array $query): void {
        if ($method === 'GET' && isset($query['low_stock'])) {
            $this->respond(['success' => true, 'data' => $this->service->getLowStock()]);
            return;
        }
        if ($method === 'GET' && isset($query['po_id'])) {
            $this->respond(['success' => true, 'data' => $this->service->getByPoId((int)$query['po_id'])]);
            return;
        }
        if ($method === 'GET' && isset($query['name'])) {
            $this->respond(['success' => true, 'data' => $this->service->getByName($query['name'])]);
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
        // Merge multipart fields and file
        if (!empty($_POST))           $body = array_merge($body, $_POST);
        if (!empty($_FILES['image'])) $body['image'] = $_FILES['image'];

        $product = $this->service->create($body);
        $this->respond(['success' => true, 'data' => $product], 201);
    }

    private function update(?int $id, array $body): void {
        if (!$id) { $this->respond(['error' => 'ID required'], 400); return; }

        // Merge multipart fields and file
        if (!empty($_POST))           $body = array_merge($body, $_POST);
        if (!empty($_FILES['image'])) $body['image'] = $_FILES['image'];

        $product = $this->service->update($id, $body);
        $this->respond(['success' => true, 'data' => $product]);
    }

    private function destroy(?int $id): void {
        if (!$id) { $this->respond(['error' => 'ID required'], 400); return; }
        $this->service->delete($id);
        $this->respond(['success' => true, 'message' => 'Product deleted']);
    }

}
