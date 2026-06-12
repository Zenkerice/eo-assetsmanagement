<?php
require_once __DIR__ . '/../config/database.php';

class UserModel {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    public function findByUsername(string $username): array|false {
        $stmt = $this->db->prepare('SELECT * FROM users WHERE username = ?');
        $stmt->execute([$username]);
        return $stmt->fetch();
    }

    public function findById(int $id): array|false {
        $stmt = $this->db->prepare('SELECT id, name, username, role, created_at FROM users WHERE id = ?');
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function findAll(): array {
        $stmt = $this->db->query('SELECT id, name, username, role, created_at FROM users ORDER BY name ASC');
        return $stmt->fetchAll();
    }

    public function create(array $data): int {
        $stmt = $this->db->prepare(
            'INSERT INTO users (name, username, password, role) VALUES (:name, :username, :password, :role)'
        );
        $stmt->execute([
            ':name'     => $data['name'],
            ':username' => $data['username'],
            ':password' => password_hash($data['password'], PASSWORD_BCRYPT, ['cost' => 12]),
            ':role'     => $data['role'] ?? 'staff',
        ]);
        return (int) $this->db->lastInsertId();
    }

    public function update(int $id, array $fields): bool {
        // Hash password if being updated
        if (isset($fields['password'])) {
            $fields['password'] = password_hash($fields['password'], PASSWORD_BCRYPT, ['cost' => 12]);
        }
        $set  = implode(', ', array_map(fn($k) => "$k = ?", array_keys($fields)));
        $stmt = $this->db->prepare("UPDATE users SET $set WHERE id = ?");
        return $stmt->execute([...array_values($fields), $id]);
    }

    public function delete(int $id): bool {
        $stmt = $this->db->prepare('DELETE FROM users WHERE id = ?');
        return $stmt->execute([$id]);
    }

    public function usernameExists(string $username, ?int $excludeId = null): bool {
        if ($excludeId) {
            $stmt = $this->db->prepare('SELECT id FROM users WHERE username = ? AND id != ?');
            $stmt->execute([$username, $excludeId]);
        } else {
            $stmt = $this->db->prepare('SELECT id FROM users WHERE username = ?');
            $stmt->execute([$username]);
        }
        return (bool) $stmt->fetch();
    }
}
