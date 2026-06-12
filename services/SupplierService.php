<?php
require_once __DIR__ . '/../model/SupplierModel.php';
require_once __DIR__ . '/../model/ProductModel.php';
require_once __DIR__ . '/../model/NotificationModel.php';

class SupplierService {
    private SupplierModel     $model;
    private ProductModel      $productModel;
    private NotificationModel $notifModel;

    public function __construct() {
        $this->model        = new SupplierModel();
        $this->productModel = new ProductModel();
        $this->notifModel   = new NotificationModel();
    }

    // ── Suppliers ─────────────────────────────────────────────────────────────

    public function list(int $page, int $perPage, ?string $search): array {
        return [
            'items' => $this->model->getAll($page, $perPage, $search),
            'total' => $this->model->count($search),
        ];
    }

    public function getById(int $id): array {
        $supplier = $this->model->findById($id);
        if (!$supplier) throw new RuntimeException("Supplier not found", 404);
        return $supplier;
    }

    public function create(array $data): array {
        $name = trim($data['name'] ?? '');
        if ($name === '') throw new InvalidArgumentException("Supplier name is required", 422);

        if ($this->model->findByName($name)) {
            throw new RuntimeException("Supplier '$name' already exists", 409);
        }

        $id = $this->model->create([
            'name'         => $name,
            'contact_name' => trim($data['contact_name'] ?? ''),
            'email'        => trim($data['email']        ?? ''),
            'phone'        => trim($data['phone']        ?? ''),
            'address'      => trim($data['address']      ?? ''),
            'status'       => 'active',
        ]);
        return $this->getById($id);
    }

    public function update(int $id, array $data): array {
        $this->getById($id);

        $fields = [];
        if (isset($data['name'])) {
            $name = trim($data['name']);
            if ($name === '') throw new InvalidArgumentException("Supplier name is required", 422);
            $existing = $this->model->findByName($name);
            if ($existing && (int)$existing['id'] !== $id) {
                throw new RuntimeException("Supplier '$name' already exists", 409);
            }
            $fields['name'] = $name;
        }
        foreach (['contact_name', 'email', 'phone', 'address', 'status'] as $f) {
            if (array_key_exists($f, $data)) $fields[$f] = trim($data[$f] ?? '');
        }

        if (!empty($fields)) $this->model->update($id, $fields);
        return $this->getById($id);
    }

    /** Soft-delete: sets status = inactive. Blocks if supplier has linked assets. */
    public function delete(int $id): void {
        $this->getById($id);
        if ($this->model->countProducts($id) > 0) {
            throw new RuntimeException(
                "Cannot deactivate supplier with linked assets. Reassign or remove them first.", 409
            );
        }
        $this->model->deactivate($id);
    }

    // ── Purchase Orders ───────────────────────────────────────────────────────

    public function listPurchaseOrders(int $page, int $perPage, ?int $supplierId, ?string $status = null): array {
        $items = $this->model->getPurchaseOrders($page, $perPage, $supplierId, $status);
        // Attach line items to each PO
        foreach ($items as &$po) {
            $po['items'] = $this->model->getPurchaseOrderItems((int)$po['id']);
        }
        return [
            'items' => $items,
            'total' => $this->model->countPurchaseOrders($supplierId, $status),
        ];
    }

    public function getPurchaseOrder(int $id): array {
        $po = $this->model->findPurchaseOrderById($id);
        if (!$po) throw new RuntimeException("Purchase order not found", 404);
        $po['items'] = $this->model->getPurchaseOrderItems($id);
        return $po;
    }
    public function generatePoNumber(): string {
        return $this->model->generatePoNumber();
    }

    public function createPurchaseOrder(array $data): array {
        if (empty($data['supplier_id'])) {
            throw new InvalidArgumentException("supplier_id is required", 422);
        }
        if (!$this->model->findById((int)$data['supplier_id'])) {
            throw new RuntimeException("Supplier not found", 404);
        }

        $items = $data['items'] ?? [];
        if (empty($items)) {
            throw new InvalidArgumentException("At least one item is required", 422);
        }

        // Validate items
        foreach ($items as $i => $item) {
            if (empty($item['product_name'])) {
                throw new InvalidArgumentException("Item #" . ($i + 1) . ": product_name is required", 422);
            }
            if (empty($item['quantity']) || (int)$item['quantity'] < 1) {
                throw new InvalidArgumentException("Item #" . ($i + 1) . ": quantity must be >= 1", 422);
            }
            if (!isset($item['unit_price']) || (float)$item['unit_price'] < 0) {
                throw new InvalidArgumentException("Item #" . ($i + 1) . ": unit_price is required", 422);
            }
        }

        $totalAmount = array_sum(
            array_map(fn($i) => (int)$i['quantity'] * (float)$i['unit_price'], $items)
        );

        $po = [
            'po_number'     => !empty($data['po_number']) ? $data['po_number'] : $this->model->generatePoNumber(),
            'supplier_id'   => (int) $data['supplier_id'],
            'order_date'    => $data['order_date']    ?? date('Y-m-d'),
            'expected_date' => $data['expected_date'] ?? null,
            'total_amount'  => $totalAmount,
            'status'        => 'pending',
            'notes'         => $data['notes']         ?? null,
            'location_id'   => !empty($data['location_id']) ? (int)$data['location_id'] : null,
            'created_by'    => $data['created_by']    ?? null,
        ];

        if (!empty($po['po_number']) && $this->model->findByPoNumber($po['po_number'])) {
            throw new RuntimeException("PO number '{$po['po_number']}' already exists", 409);
        }

        $this->validateDates($po);

        $poId = $this->model->createPurchaseOrder($po, $items);

        // Notify admins when a staff user creates a PO
        $createdByRole = $_SESSION['user']['role'] ?? 'staff';
        if ($createdByRole !== 'admin') {
            $staffName   = $_SESSION['user']['name'] ?? ($po['created_by'] ?? 'Staff');
            $supplier    = $this->model->findById((int)$po['supplier_id']);
            $supplierName = $supplier['name'] ?? 'Unknown Supplier';
            $itemCount   = array_sum(array_column($items, 'quantity'));
            $this->notifModel->create([
                'for_role' => 'admin',
                'type'     => 'po_created',
                'title'    => "New PO created by {$staffName}",
                'body'     => "PO {$po['po_number']} — {$supplierName} · {$itemCount} item(s) · ₱" .
                              number_format($po['total_amount'], 2),
                'link'     => 'suppliers.html',
                'meta'     => ['po_id' => $poId, 'created_by' => $staffName],
            ]);
        }

        return $this->getPurchaseOrder($poId);
    }

    public function updatePurchaseOrder(int $id, array $data): array {
        $po = $this->getPurchaseOrder($id);
        if ($po['status'] === 'received') {
            throw new RuntimeException("Cannot edit a received purchase order", 409);
        }

        $allowed = ['supplier_id', 'order_date', 'expected_date', 'total_amount', 'status', 'notes', 'location_id'];
        $fields  = array_intersect_key($data, array_flip($allowed));

        if (!empty($fields['supplier_id']) && !$this->model->findById((int)$fields['supplier_id'])) {
            throw new RuntimeException("Supplier not found", 404);
        }

        $this->validateDates($fields);

        if (!empty($fields)) $this->model->updatePurchaseOrder($id, $fields);
        return $this->getPurchaseOrder($id);
    }

    /**
     * Move PO to "pending_receive" — queued in the Receive page.
     */
    public function markForReceive(int $id): array {
        $po = $this->getPurchaseOrder($id);
        if ($po['status'] !== 'pending') {
            throw new RuntimeException("Only pending orders can be sent to receive", 422);
        }
        $this->model->updatePurchaseOrder($id, ['status' => 'pending_receive']);
        return $this->getPurchaseOrder($id);
    }

    /**
     * Finalize receipt with serial numbers per unit.
     * $serials = [ po_item_id => ['SN-001', 'SN-002', ...], ... ]
     */
    public function receivePurchaseOrder(int $id, string $receivedBy, array $serials = [], ?int $locationId = null): array {
        $po = $this->getPurchaseOrder($id);
        if (!in_array($po['status'], ['pending', 'pending_receive'])) {
            throw new RuntimeException("Only pending orders can be received", 422);
        }

        // Use location passed from modal; fall back to the PO's own location_id
        $effectiveLocationId = $locationId ?? (!empty($po['location_id']) ? (int)$po['location_id'] : null);

        $this->model->receivePurchaseOrder($id, $receivedBy);

        // Update inventory for each line item
        foreach ($po['items'] as $item) {
            $itemId  = (int)$item['id'];
            $qty     = (int)$item['quantity'];
            $sku     = trim($item['sku'] ?? '');
            $name    = $item['product_name'];
            $unitSerials = $serials[$itemId] ?? [];

            // Create one product record per unit with its serial number
            for ($u = 0; $u < $qty; $u++) {
                $serial = $unitSerials[$u] ?? null;
                // Build a unique SKU: base SKU + serial, or auto-generate
                $unitSku = $serial
                    ? ($sku ? $sku . '-' . $serial : $serial)
                    : ($sku ? $sku . '-' . ($u + 1) : 'PO' . $id . '-' . $itemId . '-' . ($u + 1));

                // Check if SKU already exists — update qty instead
                $existing = $this->productModel->findBySku($unitSku);
                if ($existing) {
                    $this->productModel->adjustQuantity((int)$existing['id'], 1);
                } else {
                    $this->productModel->create([
                        'name'          => $name,
                        'sku'           => $unitSku,
                        'brand_model'   => $item['brand_model'] ?? null,
                        'quantity'      => 1,
                        'supplier_id'   => $po['supplier_id'],
                        'category_id'   => !empty($item['category_id']) ? (int)$item['category_id'] : null,
                        'location_id'   => $effectiveLocationId,
                        'serial_number' => $serial,
                        'po_id'         => $id,
                        'po_item_id'    => $itemId,
                    ]);
                }
            }
        }

        return $this->getPurchaseOrder($id);
    }

    public function deletePurchaseOrder(int $id): void {
        $this->getPurchaseOrder($id);
        $this->model->deletePurchaseOrder($id);
    }

    public function getReceivedByDay(int $days = 7, ?int $locationId = null): array {
        return $this->model->countReceivedByDay($days, $locationId);
    }

    public function getReceivedByCategoryByDays(int $days = 7, ?int $locationId = null): array {
        return $this->model->countReceivedByCategoryByDays($days, $locationId);
    }

    /**
     * Partial receive — creates product records for only the provided serials.
     * The PO stays in its current status (pending / pending_receive) so more
     * batches can be received later. Call the full receivePurchaseOrder() when
     * the last batch is done.
     */
    public function partialReceivePurchaseOrder(int $id, string $receivedBy, array $serials = [], ?int $locationId = null): array {
        $po = $this->getPurchaseOrder($id);
        if (!in_array($po['status'], ['pending', 'pending_receive'])) {
            throw new RuntimeException("Only pending orders can be received", 422);
        }

        $effectiveLocationId = $locationId ?? (!empty($po['location_id']) ? (int)$po['location_id'] : null);
        $created = 0;

        foreach ($po['items'] as $item) {
            $itemId      = (int)$item['id'];
            $name        = $item['product_name'];
            $sku         = trim($item['sku'] ?? '');
            $unitSerials = $serials[$itemId] ?? [];

            foreach ($unitSerials as $u => $serial) {
                if (!$serial) continue;
                $unitSku = $serial
                    ? ($sku ? $sku . '-' . $serial : $serial)
                    : ($sku ? $sku . '-' . ($u + 1) : 'PO' . $id . '-' . $itemId . '-' . ($u + 1));

                $existing = $this->productModel->findBySku($unitSku);
                if ($existing) {
                    $this->productModel->adjustQuantity((int)$existing['id'], 1);
                } else {
                    $this->productModel->create([
                        'name'          => $name,
                        'sku'           => $unitSku,
                        'brand_model'   => $item['brand_model'] ?? null,
                        'quantity'      => 1,
                        'supplier_id'   => $po['supplier_id'],
                        'category_id'   => !empty($item['category_id']) ? (int)$item['category_id'] : null,
                        'location_id'   => $effectiveLocationId,
                        'serial_number' => $serial,
                        'po_id'         => $id,
                        'po_item_id'    => $itemId,
                    ]);
                    $created++;
                }
            }
        }

        AuditLogService::log('received', 'PurchaseOrder', $id,
            $po['po_number'] ?? null,
            "Partial receive: $created asset(s) added by $receivedBy");

        return ['created' => $created, 'po' => $this->getPurchaseOrder($id)];
    }

    private function validateDates(array $data): void {
        foreach (['order_date', 'expected_date'] as $f) {
            if (!empty($data[$f])) {
                $d = \DateTime::createFromFormat('Y-m-d', $data[$f]);
                if (!$d) throw new InvalidArgumentException("Invalid date format for $f (expected YYYY-MM-DD)", 422);
            }
        }
    }
}
