<?php
require_once __DIR__ . '/../config/database.php';

class LocationModel {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    public function findAll(): array {
        return $this->db->query('SELECT * FROM locations ORDER BY name ASC')->fetchAll();
    }

    public function findById(int $id): array|false {
        $stmt = $this->db->prepare('SELECT * FROM locations WHERE id = ?');
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function create(array $data): int {
        $stmt = $this->db->prepare(
            'INSERT INTO locations (name, building, floor, room)
             VALUES (:name, :building, :floor, :room)'
        );
        $stmt->execute([
            ':name'     => $data['name'],
            ':building' => $data['building'] ?? null,
            ':floor'    => $data['floor']    ?? null,
            ':room'     => $data['room']     ?? null,
        ]);
        return (int) $this->db->lastInsertId();
    }

    public function update(int $id, array $fields): bool {
        $set  = implode(', ', array_map(fn($k) => "$k = ?", array_keys($fields)));
        $stmt = $this->db->prepare("UPDATE locations SET $set WHERE id = ?");
        return $stmt->execute([...array_values($fields), $id]);
    }

    public function delete(int $id): bool {
        $stmt = $this->db->prepare('DELETE FROM locations WHERE id = ?');
        return $stmt->execute([$id]);
    }
}
