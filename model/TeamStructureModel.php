<?php
require_once __DIR__ . '/../config/database.php';

class TeamStructureModel {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
        $this->ensureTable();
    }

    private function ensureTable(): void {
        $this->db->exec("
            CREATE TABLE IF NOT EXISTS `team_structure` (
              `id`          INT(11)   NOT NULL AUTO_INCREMENT,
              `user_id`     INT(11)   NOT NULL,
              `employee_id` INT(11)   NOT NULL,
              `created_at`  DATETIME  NOT NULL DEFAULT current_timestamp(),
              PRIMARY KEY (`id`),
              UNIQUE KEY `uq_user_emp` (`user_id`, `employee_id`),
              KEY `idx_user_id`     (`user_id`),
              KEY `idx_employee_id` (`employee_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        ");
    }

    /** All assignments: each row has user info + employee info */
    public function getAll(): array {
        $stmt = $this->db->query(
            'SELECT ts.id, ts.user_id, ts.employee_id,
                    u.name AS user_name, u.role AS user_role,
                    e.name AS employee_name, e.station AS employee_station,
                    e.seat_number, l.name AS location_name
             FROM team_structure ts
             JOIN users     u ON ts.user_id     = u.id
             JOIN employees e ON ts.employee_id = e.id
             LEFT JOIN locations l ON e.location_id = l.id
             ORDER BY u.role ASC, u.name ASC, e.name ASC'
        );
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /** All assignments for a specific user */
    public function getByUser(int $userId): array {
        $stmt = $this->db->prepare(
            'SELECT ts.id, ts.user_id, ts.employee_id,
                    e.name AS employee_name, e.station AS employee_station,
                    e.seat_number, l.name AS location_name
             FROM team_structure ts
             JOIN employees e ON ts.employee_id = e.id
             LEFT JOIN locations l ON e.location_id = l.id
             WHERE ts.user_id = ?
             ORDER BY e.name ASC'
        );
        $stmt->execute([$userId]);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /** Employee IDs already assigned to any user */
    public function getAssignedEmployeeIds(): array {
        $stmt = $this->db->query('SELECT DISTINCT employee_id FROM team_structure');
        return $stmt->fetchAll(\PDO::FETCH_COLUMN);
    }

    /** Assign one or many employees to a user */
    public function assign(int $userId, array $employeeIds): int {
        $stmt    = $this->db->prepare(
            'INSERT IGNORE INTO team_structure (user_id, employee_id) VALUES (?, ?)'
        );
        $count = 0;
        foreach ($employeeIds as $empId) {
            $stmt->execute([$userId, (int)$empId]);
            $count += $stmt->rowCount();
        }
        return $count;
    }

    /** Remove a specific assignment by its id */
    public function unassign(int $id): bool {
        $stmt = $this->db->prepare('DELETE FROM team_structure WHERE id = ?');
        return $stmt->execute([$id]);
    }

    /** Remove all assignments for a user */
    public function clearUser(int $userId): bool {
        $stmt = $this->db->prepare('DELETE FROM team_structure WHERE user_id = ?');
        return $stmt->execute([$userId]);
    }
}
