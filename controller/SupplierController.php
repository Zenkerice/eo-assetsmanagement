<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../services/SupplierService.php';

class SupplierController extends BaseController {
    private SupplierService $service;

    public function __construct() {
        $this->service = new SupplierService();
    }

    public function handle(string $method, ?int $id, array $body, array $query): void {
        try {
            match (true) {
                // GET /api/suppliers
                $method === 'GET'  && !$id => $this->index($query),
                // GET /api/suppliers/{id}
                $method === 'GET'  &&  $id => $this->show($id),
                // POST /api/suppliers
                $method === 'POST' && !$id => $this->store($body),
                // PUT /api/suppliers/{id}
                $method === 'PUT'  &&  $id => $this->update($id, $body),
                // DELETE /api/suppliers/{id}
                $method === 'DELETE' && $id => $this->destroy($id),
                default => $this->respond(['error' => 'Method not allowed'], 405),
            };
        } catch (InvalidArgumentException $e) {
            $this->respond(['success' => false, 'error' => $e->getMessage()], 422);
        } catch (RuntimeException $e) {
            $this->respond(['success' => false, 'error' => $e->getMessage()], $e->getCode() ?: 400);
        }
    }

    /** GET /api/suppliers[?page=1&per_page=15&search=...] */
    private function index(array $query): void {
        $page    = max(1, (int) ($query['page']     ?? 1));
        $perPage = max(1, (int) ($query['per_page'] ?? 50));
        $search  = $query['search'] ?? null;

        $result = $this->service->list($page, $perPage, $search);
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

    /** GET /api/suppliers/{id} */
    private function show(int $id): void {
        $this->respond(['success' => true, 'data' => $this->service->getById($id)]);
    }

    /** POST /api/suppliers */
    private function store(array $body): void {
        $supplier = $this->service->create($body);
        $this->respond(['success' => true, 'data' => $supplier], 201);
    }

    /** PUT /api/suppliers/{id} */
    private function update(int $id, array $body): void {
        $supplier = $this->service->update($id, $body);
        $this->respond(['success' => true, 'data' => $supplier]);
    }

    /** DELETE /api/suppliers/{id} — soft delete (sets status = inactive) */
    private function destroy(int $id): void {
        $this->service->delete($id);
        $this->respond(['success' => true, 'message' => 'Supplier deactivated']);
    }

}
