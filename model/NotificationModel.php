<?php
require_once __DIR__ . '/../config/database.php';

class NotificationModel {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
        $this->ensureTable();
    }

    private function ensureTable(): void {
        $this->db->exec("
            CREATE TABLE IF NOT EXISTS `notifications` (
              `id`          INT(11)       NOT NULL AUTO_INCREMENT,
              `for_role`    ENUM('admin','staff','all') NOT NULL DEFAULT 'admin',
              `for_user_id` INT(11)       DEFAULT NULL,
              `type`        VARCHAR(80)   NOT NULL DEFAULT 'info',
              `title`       VARCHAR(255)  NOT NULL,
              `body`        TEXT          DEFAULT NULL,
              `link`        VARCHAR(255)  DEFAULT NULL,
              `is_read`     TINYINT(1)    NOT NULL DEFAULT 0,
              `meta`        JSON          DEFAULT NULL,
              `created_at`  DATETIME      DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (`id`),
              KEY `idx_for_role`    (`for_role`),
              KEY `idx_for_user_id` (`for_user_id`),
              KEY `idx_is_read`     (`is_read`),
              KEY `idx_created_at`  (`created_at`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        ");
    }

    /** Create a notification */
    public function create(array $data): int {
        $stmt = $this->db->prepare(
            'INSERT INTO notifications (for_role, for_user_id, type, title, body, link, meta)
             VALUES (:for_role, :for_user_id, :type, :title, :body, :link, :meta)'
        );
        $stmt->execute([
            ':for_role'    => $data['for_role']    ?? 'admin',
            ':for_user_id' => $data['for_user_id'] ?? null,
            ':type'        => $data['type']        ?? 'info',
            ':title'       => $data['title'],
            ':body'        => $data['body']        ?? null,
            ':link'        => $data['link']        ?? null,
            ':meta'        => isset($data['meta'])  ? json_encode($data['meta']) : null,
        ]);
        return (int) $this->db->lastInsertId();
    }

    /**
     * Fetch notifications visible to the given user.
     * Admin sees notifications for_role='admin' or for_user_id=their id.
     * Staff sees notifications for_user_id=their id.
     */
    public function findForUser(int $userId, string $role, int $limit = 50): array {
        if ($role === 'admin') {
            $stmt = $this->db->prepare(
                "SELECT * FROM notifications
                 WHERE for_role = 'admin' OR for_user_id = :uid
                 ORDER BY created_at DESC LIMIT :lim"
            );
        } else {
            $stmt = $this->db->prepare(
                "SELECT * FROM notifications
                 WHERE for_user_id = :uid
                 ORDER BY created_at DESC LIMIT :lim"
            );
        }
        $stmt->bindValue(':uid', $userId, PDO::PARAM_INT);
        $stmt->bindValue(':lim', $limit,  PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function countUnread(int $userId, string $role): int {
        if ($role === 'admin') {
            $stmt = $this->db->prepare(
                "SELECT COUNT(*) FROM notifications
                 WHERE COALESCE(is_read, 0) = 0 AND (for_role = 'admin' OR for_user_id = :uid)"
            );
        } else {
            $stmt = $this->db->prepare(
                "SELECT COUNT(*) FROM notifications
                 WHERE COALESCE(is_read, 0) = 0 AND for_user_id = :uid"
            );
        }
        $stmt->execute([':uid' => $userId]);
        return (int) $stmt->fetchColumn();
    }

    public function markRead(int $id): void {
        $this->db->prepare('UPDATE notifications SET is_read = 1 WHERE id = ?')->execute([$id]);
    }

    public function markAllRead(int $userId, string $role): void {
        if ($role === 'admin') {
            $stmt = $this->db->prepare(
                "UPDATE notifications SET is_read = 1
                 WHERE is_read = 0 AND (for_role = 'admin' OR for_user_id = :uid)"
            );
        } else {
            $stmt = $this->db->prepare(
                "UPDATE notifications SET is_read = 1
                 WHERE is_read = 0 AND for_user_id = :uid"
            );
        }
        $stmt->execute([':uid' => $userId]);
    }

    public function deleteAll(int $userId, string $role): void {
        if ($role === 'admin') {
            $stmt = $this->db->prepare(
                "DELETE FROM notifications
                 WHERE for_role = 'admin' OR for_user_id = :uid"
            );
        } else {
            $stmt = $this->db->prepare(
                "DELETE FROM notifications
                 WHERE for_user_id = :uid"
            );
        }
        $stmt->execute([':uid' => $userId]);
    }
}
