<?php
require_once __DIR__ . '/../config/database.php';

class SupplierModel {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    // ── Suppliers ─────────────────────────────────────────────────────────────

    public function getAll(int $page, int $perPage, ?string $search = null): array {
        [$where, $params] = $this->supplierWhere($search);
        $offset = ($page - 1) * $perPage;
        $stmt = $this->db->prepare(
            "SELECT * FROM suppliers $where ORDER BY name ASC LIMIT :limit OFFSET :offset"
        );
        foreach ($params as $k => $v) $stmt->bindValue($k, $v);
        $stmt->bindValue(':limit',  $perPage, PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset,  PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function count(?string $search = null): int {
        [$where, $params] = $this->supplierWhere($search);
        $stmt = $this->db->prepare("SELECT COUNT(*) FROM suppliers $where");
        $stmt->execute($params);
        return (int) $stmt->fetchColumn();
    }

    private function supplierWhere(?string $search): array {
        $where  = "WHERE status = 'active'";
        $params = [];
        if ($search) {
            $where .= " AND (name LIKE :s OR contact_name LIKE :s2)";
            $params[':s']  = "%$search%";
            $params[':s2'] = "%$search%";
        }
        return [$where, $params];
    }

    public function findById(int $id): array|false {
        $stmt = $this->db->prepare('SELECT * FROM suppliers WHERE id = ? LIMIT 1');
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function findByName(string $name): array|false {
        $stmt = $this->db->prepare("SELECT * FROM suppliers WHERE name = ? AND status = 'active' LIMIT 1");
        $stmt->execute([$name]);
        return $stmt->fetch();
    }

    public function create(array $fields): int {
        $stmt = $this->db->prepare(
            'INSERT INTO suppliers (name, contact_name, email, phone, address, status)
             VALUES (:name, :contact_name, :email, :phone, :address, :status)'
        );
        $stmt->execute([
            ':name'         => $fields['name'],
            ':contact_name' => $fields['contact_name'] ?? null,
            ':email'        => $fields['email']        ?? null,
            ':phone'        => $fields['phone']        ?? null,
            ':address'      => $fields['address']      ?? null,
            ':status'       => $fields['status']       ?? 'active',
        ]);
        return (int) $this->db->lastInsertId();
    }

    public function update(int $id, array $fields): bool {
        $set  = implode(', ', array_map(fn($k) => "$k = ?", array_keys($fields)));
        $stmt = $this->db->prepare("UPDATE suppliers SET $set WHERE id = ?");
        return $stmt->execute([...array_values($fields), $id]);
    }

    /** Soft delete — sets status = inactive */
    public function deactivate(int $id): bool {
        $stmt = $this->db->prepare("UPDATE suppliers SET status = 'inactive' WHERE id = ?");
        $stmt->execute([$id]);
        return $stmt->rowCount() > 0;
    }

    public function countProducts(int $id): int {
        $stmt = $this->db->prepare('SELECT COUNT(*) FROM products WHERE supplier_id = ?');
        $stmt->execute([$id]);
        return (int) $stmt->fetchColumn();
    }

    // ── Purchase Orders ───────────────────────────────────────────────────────

    public function getPurchaseOrders(int $page, int $perPage, ?int $supplierId = null, ?string $status = null): array {
        [$where, $params] = $this->poWhere($supplierId, $status);
        $offset = ($page - 1) * $perPage;
        $stmt = $this->db->prepare(
            "SELECT po.*, s.name AS supplier_name, l.name AS location_name
             FROM purchase_orders po
             LEFT JOIN suppliers s ON po.supplier_id = s.id
             LEFT JOIN locations l ON po.location_id = l.id
             $where
             ORDER BY po.order_date DESC, po.id DESC
             LIMIT :limit OFFSET :offset"
        );
        foreach ($params as $k => $v) $stmt->bindValue($k, $v);
        $stmt->bindValue(':limit',  $perPage, PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset,  PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function countPurchaseOrders(?int $supplierId = null, ?string $status = null): int {
        [$where, $params] = $this->poWhere($supplierId, $status);
        $stmt = $this->db->prepare("SELECT COUNT(*) FROM purchase_orders po $where");
        $stmt->execute($params);
        return (int) $stmt->fetchColumn();
    }

    private function poWhere(?int $supplierId, ?string $status = null): array {
        $conditions = [];
        $params     = [];
        if ($supplierId) { $conditions[] = 'po.supplier_id = :sid'; $params[':sid'] = $supplierId; }
        if ($status)     { $conditions[] = 'po.status = :st';       $params[':st']  = $status; }
        $where = $conditions ? 'WHERE ' . implode(' AND ', $conditions) : '';
        return [$where, $params];
    }

    public function findPurchaseOrderById(int $id): array|false {
        $stmt = $this->db->prepare(
            'SELECT po.*, s.name AS supplier_name, l.name AS location_name
             FROM purchase_orders po
             LEFT JOIN suppliers s ON po.supplier_id = s.id
             LEFT JOIN locations l ON po.location_id = l.id
             WHERE po.id = ? LIMIT 1'
        );
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function findByPoNumber(string $poNumber): array|false {
        $stmt = $this->db->prepare('SELECT * FROM purchase_orders WHERE po_number = ?');
        $stmt->execute([$poNumber]);
        return $stmt->fetch();
    }

    public function getPurchaseOrderItems(int $poId): array {
        $stmt = $this->db->prepare('SELECT * FROM purchase_order_items WHERE po_id = ? ORDER BY id ASC');
        $stmt->execute([$poId]);
        return $stmt->fetchAll();
    }

    /** Create PO + items in a transaction */
    public function createPurchaseOrder(array $po, array $items): int {
        $this->db->beginTransaction();
        try {
            $stmt = $this->db->prepare(
                'INSERT INTO purchase_orders
                   (po_number, supplier_id, order_date, expected_date, total_amount, status, notes, location_id, created_by)
                 VALUES
                   (:po_number, :supplier_id, :order_date, :expected_date, :total_amount, :status, :notes, :location_id, :created_by)'
            );
            $stmt->execute([
                ':po_number'     => $po['po_number'],
                ':supplier_id'   => $po['supplier_id'],
                ':order_date'    => $po['order_date']    ?? date('Y-m-d'),
                ':expected_date' => $po['expected_date'] ?? null,
                ':total_amount'  => $po['total_amount'],
                ':status'        => $po['status']        ?? 'pending',
                ':notes'         => $po['notes']         ?? null,
                ':location_id'   => $po['location_id']   ?? null,
                ':created_by'    => $po['created_by']    ?? null,
            ]);
            $poId = (int) $this->db->lastInsertId();

            $itemStmt = $this->db->prepare(
                'INSERT INTO purchase_order_items (po_id, product_name, sku, quantity, unit_price, total_price, category_id)
                 VALUES (:po_id, :product_name, :sku, :quantity, :unit_price, :total_price, :category_id)'
            );
            foreach ($items as $item) {
                $qty   = (int)   $item['quantity'];
                $price = (float) $item['unit_price'];
                $itemStmt->execute([
                    ':po_id'        => $poId,
                    ':product_name' => $item['product_name'],
                    ':sku'          => $item['sku']          ?? null,
                    ':quantity'     => $qty,
                    ':unit_price'   => $price,
                    ':total_price'  => $qty * $price,
                    ':category_id'  => !empty($item['category_id']) ? (int)$item['category_id'] : null,
                ]);
            }

            $this->db->commit();
            return $poId;
        } catch (\Throwable $e) {
            $this->db->rollBack();
            throw $e;
        }
    }

    public function updatePurchaseOrder(int $id, array $fields): bool {
        $set  = implode(', ', array_map(fn($k) => "$k = ?", array_keys($fields)));
        $stmt = $this->db->prepare("UPDATE purchase_orders SET $set WHERE id = ?");
        return $stmt->execute([...array_values($fields), $id]);
    }

    /** Mark PO as received */
    public function receivePurchaseOrder(int $id, string $receivedBy): bool {
        $stmt = $this->db->prepare(
            "UPDATE purchase_orders
             SET status = 'received', received_by = ?, received_date = NOW()
             WHERE id = ? AND status IN ('pending','pending_receive')"
        );
        $stmt->execute([$receivedBy, $id]);
        return $stmt->rowCount() > 0;
    }

    public function deletePurchaseOrder(int $id): bool {
        $stmt = $this->db->prepare('DELETE FROM purchase_orders WHERE id = ?');
        return $stmt->execute([$id]);
    }

    /** Count received units per day for last N days, optionally by location */
    public function countReceivedByDay(int $days = 7, ?int $locationId = null): array {
        // Count products created per day (covers all intake methods)
        $where  = 'WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)';
        $params = [$days];
        if ($locationId) {
            $where .= ' AND location_id = ?';
            $params[] = $locationId;
        }
        $stmt = $this->db->prepare(
            "SELECT DATE(created_at) AS day, COUNT(*) AS count
             FROM products
             $where
             GROUP BY DATE(created_at)
             ORDER BY day ASC"
        );
        $stmt->execute($params);
        $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        // Fill missing days with 0
        $result = [];
        for ($i = $days - 1; $i >= 0; $i--) {
            $result[date('Y-m-d', strtotime("-$i days"))] = 0;
        }
        foreach ($rows as $row) {
            $result[$row['day']] = (int)$row['count'];
        }
        return array_map(fn($day, $count) => ['day' => $day, 'count' => $count],
                         array_keys($result), array_values($result));
    }

    public function generatePoNumber(): string {
        $date   = date('Ymd');
        $prefix = 'PO-' . $date . '-';
        $stmt   = $this->db->prepare(
            "SELECT po_number FROM purchase_orders WHERE po_number LIKE ? ORDER BY id DESC LIMIT 1"
        );
        $stmt->execute([$prefix . '%']);
        $last = $stmt->fetchColumn();
        $seq  = $last ? ((int) substr($last, -4) + 1) : 1;
        return $prefix . str_pad($seq, 4, '0', STR_PAD_LEFT);
    }

    /** Count received units per category for last N days, optionally by location */
    public function countReceivedByCategoryByDays(int $days, ?int $locationId = null): array {
        // Count products created in the period (covers PO receives, imports, manual adds)
        $where  = 'WHERE p.created_at >= DATE_SUB(NOW(), INTERVAL ? DAY)';
        $params = [$days];
        if ($locationId) {
            $where .= ' AND p.location_id = ?';
            $params[] = $locationId;
        }
        $stmt = $this->db->prepare(
            "SELECT c.id AS category_id, c.name AS category_name, COUNT(*) AS count
             FROM products p
             LEFT JOIN categories c ON p.category_id = c.id
             $where
             GROUP BY c.id, c.name
             ORDER BY c.name ASC"
        );
        $stmt->execute($params);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }
}