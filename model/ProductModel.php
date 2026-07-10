<?php
require_once __DIR__ . '/../config/database.php';

class ProductModel {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    public function findAll(): array {
        $stmt = $this->db->query(
            'SELECT p.*, c.name AS category_name,
                    COALESCE(s.name, p.supplier_name) AS supplier_name,
                    l.name AS location_name
             FROM products p
             LEFT JOIN categories c ON p.category_id = c.id
             LEFT JOIN suppliers  s ON p.supplier_id  = s.id
             LEFT JOIN locations  l ON p.location_id  = l.id
             ORDER BY p.name ASC'
        );
        return $stmt->fetchAll();
    }

    public function findById(int $id): array|false {
        $stmt = $this->db->prepare(
            'SELECT p.*, c.name AS category_name,
                    COALESCE(s.name, p.supplier_name) AS supplier_name,
                    l.name AS location_name
             FROM products p
             LEFT JOIN categories c ON p.category_id = c.id
             LEFT JOIN suppliers  s ON p.supplier_id  = s.id
             LEFT JOIN locations  l ON p.location_id  = l.id
             WHERE p.id = ?'
        );
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function findBySku(string $sku): array|false {
        $stmt = $this->db->prepare('SELECT * FROM products WHERE sku = ?');
        $stmt->execute([$sku]);
        return $stmt->fetch();
    }

    public function findBySerial(string $serial): array|false {
        $stmt = $this->db->prepare('SELECT * FROM products WHERE serial_number = ? LIMIT 1');
        $stmt->execute([$serial]);
        return $stmt->fetch() ?: false;
    }

    public function findLowStock(int $threshold): array {
        $stmt = $this->db->prepare(
            'SELECT p.*, c.name AS category_name, s.name AS supplier_name
             FROM products p
             LEFT JOIN categories c ON p.category_id = c.id
             LEFT JOIN suppliers  s ON p.supplier_id  = s.id
             WHERE p.quantity <= ?
             ORDER BY p.quantity ASC'
        );
        $stmt->execute([$threshold]);
        return $stmt->fetchAll();
    }

    public function create(array $data): int {
        $stmt = $this->db->prepare(
            'INSERT INTO products (name, sku, brand_model, brand, model, description, category_id, supplier_id, supplier_name, location_id, quantity, image_path, serial_number, po_id, po_item_id, assigned_employee, assigned_employee_id, purchase_date, deployed_date)
             VALUES (:name, :sku, :brand_model, :brand, :model, :description, :category_id, :supplier_id, :supplier_name, :location_id, :quantity, :image_path, :serial_number, :po_id, :po_item_id, :assigned_employee, :assigned_employee_id, :purchase_date, :deployed_date)'
        );
        $stmt->execute([
            ':name'                 => $data['name'],
            ':sku'                  => $data['sku'],
            ':brand_model'          => $data['brand_model'] ?? null,
            ':brand'                => $data['brand'] ?? null,
            ':model'                => $data['model'] ?? null,
            ':description'          => $data['description'] ?? '',
            ':category_id'          => !empty($data['category_id'])  ? (int)$data['category_id']  : null,
            ':supplier_id'          => !empty($data['supplier_id'])   ? (int)$data['supplier_id']   : null,
            ':supplier_name'        => $data['supplier_name'] ?? null,
            ':location_id'          => !empty($data['location_id'])   ? (int)$data['location_id']   : null,
            ':quantity'             => $data['quantity'] ?? 1,
            ':image_path'           => $data['image_path'] ?? null,
            ':serial_number'        => $data['serial_number'] ?? null,
            ':po_id'                => !empty($data['po_id'])         ? (int)$data['po_id']         : null,
            ':po_item_id'           => !empty($data['po_item_id'])    ? (int)$data['po_item_id']    : null,
            ':assigned_employee'    => $data['assigned_employee'] ?? null,
            ':assigned_employee_id' => $data['assigned_employee_id'] ?? null,
            ':purchase_date'        => !empty($data['purchase_date']) ? $data['purchase_date'] : null,
            ':deployed_date'        => !empty($data['deployed_date']) ? $data['deployed_date'] : null,
        ]);
        return (int) $this->db->lastInsertId();
    }

    /** Find all products with the same name (for group editing) */
    public function findByName(string $name): array {
        $stmt = $this->db->prepare(
            'SELECT p.*, c.name AS category_name,
                    COALESCE(s.name, p.supplier_name) AS supplier_name
             FROM products p
             LEFT JOIN categories c ON p.category_id = c.id
             LEFT JOIN suppliers  s ON p.supplier_id  = s.id
             WHERE p.name = ?
             ORDER BY p.id ASC'
        );
        $stmt->execute([$name]);
        return $stmt->fetchAll();
    }

    /** Find all products created from a specific PO */
    public function findByPoId(int $poId): array {        $stmt = $this->db->prepare(
            'SELECT p.*, c.name AS category_name,
                    COALESCE(s.name, p.supplier_name) AS supplier_name
             FROM products p
             LEFT JOIN categories c ON p.category_id = c.id
             LEFT JOIN suppliers  s ON p.supplier_id  = s.id
             WHERE p.po_id = ?
             ORDER BY p.po_item_id ASC, p.id ASC'
        );
        $stmt->execute([$poId]);
        return $stmt->fetchAll();
    }

    public function update(int $id, array $fields): bool {
        $set = implode(', ', array_map(fn($k) => "$k = ?", array_keys($fields)));
        $stmt = $this->db->prepare("UPDATE products SET $set WHERE id = ?");
        return $stmt->execute([...array_values($fields), $id]);
    }

    public function adjustQuantity(int $id, int $delta): bool {
        $stmt = $this->db->prepare('UPDATE products SET quantity = quantity + ? WHERE id = ?');
        return $stmt->execute([$delta, $id]);
    }

    public function delete(int $id): bool {
        $stmt = $this->db->prepare('DELETE FROM products WHERE id = ?');
        return $stmt->execute([$id]);
    }
}
