<?php
require_once __DIR__ . '/../config/database.php';

class UserModel {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
        $this->ensureStatusColumn();
    }

    public function findByUsername(string $username): array|false {
        $stmt = $this->db->prepare('SELECT * FROM users WHERE username = ?');
        $stmt->execute([$username]);
        return $stmt->fetch();
    }

    public function findById(int $id): array|false {
        $stmt = $this->db->prepare('SELECT id, name, employee_id, username, role, status, position, email, contact_number, created_at FROM users WHERE id = ?');
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function findAll(): array {
        $stmt = $this->db->query('SELECT id, name, employee_id, username, role, status, position, email, contact_number, created_at FROM users ORDER BY name ASC');
        return $stmt->fetchAll();
    }

    public function create(array $data): int {
        $stmt = $this->db->prepare(
            'INSERT INTO users (name, employee_id, username, password, role, status, position, email, contact_number)
             VALUES (:name, :employee_id, :username, :password, :role, :status, :position, :email, :contact_number)'
        );
        $stmt->execute([
            ':name'           => $data['name'],
            ':employee_id'    => $data['employee_id'] ?? null,
            ':username'       => $data['username'],
            ':password'       => password_hash($data['password'], PASSWORD_BCRYPT, ['cost' => 12]),
            ':role'           => $data['role'] ?? 'staff',
            ':status'         => $data['status'] ?? 'active',
            ':position'       => $data['position'] ?? null,
            ':email'          => $data['email'] ?? null,
            ':contact_number' => $data['contact_number'] ?? null,
        ]);
        return (int) $this->db->lastInsertId();
    }

    public function updateStatus(int $id, string $status): bool {
        $stmt = $this->db->prepare('UPDATE users SET status = ? WHERE id = ?');
        return $stmt->execute([$status, $id]);
    }

    private function ensureStatusColumn(): void {
        try {
            $this->db->query('SELECT status FROM users LIMIT 1');
            // Ensure 'suspended' is in the enum — safe to run repeatedly
            try {
                $this->db->exec("ALTER TABLE users MODIFY COLUMN status ENUM('pending','active','rejected','suspended') NOT NULL DEFAULT 'active'");
            } catch (\PDOException $e) { /* already has the value */ }
        } catch (\PDOException $e) {
            $this->db->exec("ALTER TABLE users ADD COLUMN status ENUM('pending','active','rejected','suspended') NOT NULL DEFAULT 'active' AFTER role");
            $this->db->exec("UPDATE users SET status = 'active' WHERE status IS NULL OR status = ''");
        }
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
