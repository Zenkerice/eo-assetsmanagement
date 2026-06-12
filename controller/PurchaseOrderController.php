<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../services/SupplierService.php';

class PurchaseOrderController extends BaseController {
    private SupplierService $service;

    public function __construct() {
        $this->service = new SupplierService();
    }

    public function handle(string $method, ?int $id, array $body, array $query): void {
        try {
            $action = $query['action'] ?? '';

            // POST /api/purchase_orders/{id}?action=mark_receive
            if ($method === 'POST' && $id && $action === 'mark_receive') {
                $this->markForReceive($id);
                return;
            }

            // POST /api/purchase_orders/{id}?action=receive
            if ($method === 'POST' && $id && $action === 'receive') {
                $this->receive($id, $body);
                return;
            }

            // POST /api/purchase_orders/{id}?action=partial_receive
            if ($method === 'POST' && $id && $action === 'partial_receive') {
                $this->partialReceive($id, $body);
                return;
            }

            // GET /api/purchase_orders?generate_number=1
            if ($method === 'GET' && !$id && isset($query['generate_number'])) {
                $this->respond(['success'=>true,'data'=>['po_number'=>$this->service->generatePoNumber()]]);
                return;
            }

            // GET /api/purchase_orders?stock=1&days=7&location_id=1
            if ($method === 'GET' && !$id && isset($query['stock'])) {
                $days       = isset($query['days'])        ? (int)$query['days']        : 7;
                $locationId = isset($query['location_id']) ? (int)$query['location_id'] : null;
                $this->respond(['success'=>true,'data'=>$this->service->getReceivedByDay($days, $locationId)]);
                return;
            }

            // GET /api/purchase_orders?cat_stock=1&days=7&location_id=1
            if ($method === 'GET' && !$id && isset($query['cat_stock'])) {
                $days       = isset($query['days'])        ? (int)$query['days']        : 7;
                $locationId = isset($query['location_id']) ? (int)$query['location_id'] : null;
                $this->respond(['success'=>true,'data'=>$this->service->getReceivedByCategoryByDays($days, $locationId)]);
                return;
            }

            match (true) {
                $method === 'GET'    && !$id => $this->index($query),
                $method === 'GET'    &&  $id => $this->show($id),
                $method === 'POST'   && !$id => $this->store($body),
                $method === 'PUT'    &&  $id => $this->update($id, $body),
                $method === 'DELETE' &&  $id => $this->destroy($id),
                default => $this->respond(['error'=>'Method not allowed'], 405),
            };
        } catch (InvalidArgumentException $e) {
            $this->respond(['success'=>false,'error'=>$e->getMessage()], 422);
        } catch (RuntimeException $e) {
            $this->respond(['success'=>false,'error'=>$e->getMessage()], $e->getCode() ?: 400);
        }
    }

    private function index(array $query): void {
        $page       = max(1, (int)($query['page']        ?? 1));
        $perPage    = max(1, (int)($query['per_page']    ?? 100));
        $supplierId = isset($query['supplier_id']) ? (int)$query['supplier_id'] : null;
        $status     = $query['status'] ?? null;

        $result = $this->service->listPurchaseOrders($page, $perPage, $supplierId, $status);
        $this->respond(['success'=>true,'data'=>$result['items'],'meta'=>[
            'total'    => $result['total'],
            'page'     => $page,
            'per_page' => $perPage,
        ]]);
    }

    private function show(int $id): void {
        $this->respond(['success'=>true,'data'=>$this->service->getPurchaseOrder($id)]);
    }

    private function store(array $body): void {
        if (!empty($_SESSION['user']['name'])) $body['created_by'] = $_SESSION['user']['name'];
        $po = $this->service->createPurchaseOrder($body);
        $this->respond(['success'=>true,'data'=>$po], 201);
    }

    private function update(int $id, array $body): void {
        $po = $this->service->updatePurchaseOrder($id, $body);
        $this->respond(['success'=>true,'data'=>$po]);
    }

    private function markForReceive(int $id): void {
        $po = $this->service->markForReceive($id);
        $this->respond(['success' => true, 'data' => $po, 'message' => 'PO sent to Receive queue']);
    }

    private function receive(int $id, array $body): void {
        $receivedBy = $_SESSION['user']['name'] ?? 'Admin';
        $serials    = $body['serials'] ?? [];
        $locationId = !empty($body['location_id']) ? (int)$body['location_id'] : null;
        $po = $this->service->receivePurchaseOrder($id, $receivedBy, $serials, $locationId);
        $this->respond(['success'=>true,'data'=>$po,'message'=>'Purchase order received']);
    }

    private function partialReceive(int $id, array $body): void {
        $receivedBy = $_SESSION['user']['name'] ?? 'Admin';
        $serials    = $body['serials'] ?? [];
        $locationId = !empty($body['location_id']) ? (int)$body['location_id'] : null;
        $result = $this->service->partialReceivePurchaseOrder($id, $receivedBy, $serials, $locationId);
        $this->respond(['success'=>true,'data'=>$result,'message'=>'Assets added to inventory']);
    }

    private function destroy(int $id): void {
        $this->service->deletePurchaseOrder($id);
        $this->respond(['success'=>true,'message'=>'Purchase order deleted']);
    }

}
