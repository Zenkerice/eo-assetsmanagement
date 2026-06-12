<?php
require_once __DIR__ . '/../config/database.php';

class DamageModel {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    public function findAll(): array {
        $stmt = $this->db->query(
            'SELECT d.*,
                    COALESCE(p.name, d.product_name_cache) AS product_name,
                    COALESCE(p.sku,  d.product_sku_cache)  AS product_sku,
                    c.name AS category_name,
                    COALESCE(d.location_id, p.location_id) AS location_id,
                    l.name AS location_name
             FROM damages d
             LEFT JOIN products   p ON d.product_id   = p.id
             LEFT JOIN categories c ON p.category_id  = c.id
             LEFT JOIN locations  l ON COALESCE(d.location_id, p.location_id) = l.id
             ORDER BY d.created_at DESC'
        );
        return $stmt->fetchAll();
    }

    public function findById(int $id): array|false {
        $stmt = $this->db->prepare(
            'SELECT d.*,
                    COALESCE(p.name, d.product_name_cache) AS product_name,
                    COALESCE(p.sku,  d.product_sku_cache)  AS product_sku,
                    c.name AS category_name,
                    COALESCE(d.location_id, p.location_id) AS location_id,
                    l.name AS location_name
             FROM damages d
             LEFT JOIN products   p ON d.product_id   = p.id
             LEFT JOIN categories c ON p.category_id  = c.id
             LEFT JOIN locations  l ON COALESCE(d.location_id, p.location_id) = l.id
             WHERE d.id = ?'
        );
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function findByCategory(int $categoryId): array {
        $stmt = $this->db->prepare(
            'SELECT d.*,
                    COALESCE(p.name, d.product_name_cache) AS product_name,
                    COALESCE(p.sku,  d.product_sku_cache)  AS product_sku,
                    c.name AS category_name,
                    COALESCE(d.location_id, p.location_id) AS location_id,
                    l.name AS location_name
             FROM damages d
             LEFT JOIN products   p ON d.product_id  = p.id
             LEFT JOIN categories c ON p.category_id = c.id
             LEFT JOIN locations  l ON COALESCE(d.location_id, p.location_id) = l.id
             WHERE p.category_id = ?
             ORDER BY d.created_at DESC'
        );
        $stmt->execute([$categoryId]);
        return $stmt->fetchAll();
    }

    public function create(array $data): int {
        $stmt = $this->db->prepare(
            'INSERT INTO damages
               (product_id, category_id, location_id, reported_by, issue, status,
                product_name_cache, product_sku_cache)
             VALUES
               (:product_id, :category_id, :location_id, :reported_by, :issue, :status,
                :product_name_cache, :product_sku_cache)'
        );
        $stmt->execute([
            ':product_id'         => $data['product_id'],
            ':category_id'        => $data['category_id']  ?? null,
            ':location_id'        => $data['location_id']  ?? null,
            ':reported_by'        => $data['reported_by'],
            ':issue'              => $data['issue'],
            ':status'             => $data['status'] ?? 'damaged',
            ':product_name_cache' => $data['product_name_cache'] ?? null,
            ':product_sku_cache'  => $data['product_sku_cache']  ?? null,
        ]);
        return (int) $this->db->lastInsertId();
    }

    public function update(int $id, array $fields): bool {
        $set  = implode(', ', array_map(fn($k) => "$k = ?", array_keys($fields)));
        $stmt = $this->db->prepare("UPDATE damages SET $set WHERE id = ?");
        return $stmt->execute([...array_values($fields), $id]);
    }

    public function delete(int $id): bool {
        $stmt = $this->db->prepare('DELETE FROM damages WHERE id = ?');
        return $stmt->execute([$id]);
    }
}
