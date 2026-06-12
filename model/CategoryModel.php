<?php
require_once __DIR__ . '/../config/database.php';

class CategoryModel {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    public function findAll(): array {
        $stmt = $this->db->query('SELECT * FROM categories ORDER BY name ASC');
        return $stmt->fetchAll();
    }

    public function findById(int $id): array|false {
        $stmt = $this->db->prepare('SELECT * FROM categories WHERE id = ?');
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function findByName(string $name): array|false {
        $stmt = $this->db->prepare('SELECT * FROM categories WHERE name = ?');
        $stmt->execute([$name]);
        return $stmt->fetch();
    }

    public function create(string $name, string $description = ''): int {
        $stmt = $this->db->prepare('INSERT INTO categories (name, description) VALUES (?, ?)');
        $stmt->execute([$name, $description]);
        return (int) $this->db->lastInsertId();
    }

    public function update(int $id, array $fields): bool {
        $set = implode(', ', array_map(fn($k) => "$k = ?", array_keys($fields)));
        $stmt = $this->db->prepare("UPDATE categories SET $set WHERE id = ?");
        return $stmt->execute([...array_values($fields), $id]);
    }

    public function delete(int $id): bool {
        $stmt = $this->db->prepare('DELETE FROM categories WHERE id = ?');
        return $stmt->execute([$id]);
    }

    public function hasProducts(int $id): bool {
        $stmt = $this->db->prepare('SELECT COUNT(*) FROM products WHERE category_id = ?');
        $stmt->execute([$id]);
        return (int) $stmt->fetchColumn() > 0;
    }
}
