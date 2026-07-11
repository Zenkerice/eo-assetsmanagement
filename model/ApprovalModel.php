<?php
require_once __DIR__ . '/../config/database.php';

class ApprovalModel {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
        $this->ensureTable();
    }

    private function ensureTable(): void {
        $this->db->exec("
            CREATE TABLE IF NOT EXISTS `approval_requests` (
              `id`            INT(11)       NOT NULL AUTO_INCREMENT,
              `requested_by`  VARCHAR(150)  NOT NULL,
              `user_id`       INT(11)       DEFAULT NULL,
              `action_type`   ENUM('create','update','delete') NOT NULL,
              `resource_type` VARCHAR(50)   NOT NULL,
              `resource_id`   INT(11)       DEFAULT NULL,
              `resource_name` VARCHAR(255)  DEFAULT NULL,
              `payload`       JSON          DEFAULT NULL,
              `notes`         TEXT          DEFAULT NULL,
              `status`        ENUM('pending','approved','rejected','forwarded') NOT NULL DEFAULT 'pending',
              `reviewed_by`   VARCHAR(150)  DEFAULT NULL,
              `review_notes`  TEXT          DEFAULT NULL,
              `reviewed_at`   DATETIME      DEFAULT NULL,
              `created_at`    DATETIME      DEFAULT CURRENT_TIMESTAMP,
              `updated_at`    DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
              PRIMARY KEY (`id`),
              KEY `idx_status`        (`status`),
              KEY `idx_resource_type` (`resource_type`),
              KEY `idx_requested_by`  (`requested_by`),
              KEY `idx_created_at`    (`created_at`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        ");
        // Ensure 'forwarded' is in the enum for existing tables
        try {
            $this->db->exec("ALTER TABLE approval_requests MODIFY COLUMN status ENUM('pending','approved','rejected','forwarded') NOT NULL DEFAULT 'pending'");
        } catch (\PDOException $e) { /* already updated */ }
    }

    public function create(array $data): int {
        $stmt = $this->db->prepare(
            'INSERT INTO approval_requests
               (requested_by, user_id, action_type, resource_type, resource_id, resource_name, payload, notes)
             VALUES
               (:requested_by, :user_id, :action_type, :resource_type, :resource_id, :resource_name, :payload, :notes)'
        );
        $stmt->execute([
            ':requested_by'  => $data['requested_by'],
            ':user_id'       => $data['user_id']       ?? null,
            ':action_type'   => $data['action_type'],
            ':resource_type' => $data['resource_type'],
            ':resource_id'   => $data['resource_id']   ?? null,
            ':resource_name' => $data['resource_name'] ?? null,
            ':payload'       => isset($data['payload']) ? json_encode($data['payload']) : null,
            ':notes'         => $data['notes']          ?? null,
        ]);
        return (int) $this->db->lastInsertId();
    }

    public function findById(int $id): array|false {
        $stmt = $this->db->prepare('SELECT * FROM approval_requests WHERE id = ?');
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function findAll(array $filters = []): array {
        $conds = []; $params = [];
        if (!empty($filters['status'])) {
            $conds[] = 'status = :status';
            $params[':status'] = $filters['status'];
        }
        if (!empty($filters['resource_type'])) {
            $conds[] = 'resource_type = :rtype';
            $params[':rtype'] = $filters['resource_type'];
        }
        $where = $conds ? 'WHERE ' . implode(' AND ', $conds) : '';
        $stmt  = $this->db->prepare("SELECT * FROM approval_requests $where ORDER BY created_at DESC");
        $stmt->execute($params);
        return $stmt->fetchAll();
    }

    public function countPending(): int {
        $stmt = $this->db->query("SELECT COUNT(*) FROM approval_requests WHERE status = 'pending'");
        return (int) $stmt->fetchColumn();
    }

    public function review(int $id, string $status, string $reviewedBy, ?string $reviewNotes = null): bool {
        $stmt = $this->db->prepare(
            'UPDATE approval_requests
             SET status = :status, reviewed_by = :reviewed_by, review_notes = :review_notes, reviewed_at = NOW()
             WHERE id = :id'
        );
        return $stmt->execute([
            ':status'       => $status,
            ':reviewed_by'  => $reviewedBy,
            ':review_notes' => $reviewNotes,
            ':id'           => $id,
        ]);
    }

    public function deletePending(int $id): bool {
        $stmt = $this->db->prepare("DELETE FROM approval_requests WHERE id = ? AND status = 'pending'");
        $stmt->execute([$id]);
        return $stmt->rowCount() > 0;
    }
}
