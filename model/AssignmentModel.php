<?php
require_once __DIR__ . '/../config/database.php';

class AssignmentModel {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    /** All assignments (active + returned), newest first */
    public function findAll(): array {
        $stmt = $this->db->query(
            'SELECT a.*,
                    p.name        AS product_name,
                    p.sku         AS product_sku,
                    p.image_path  AS product_image,
                    p.asset_status,
                    c.name        AS category_name,
                    l.name        AS location_name
             FROM assignments a
             LEFT JOIN products   p ON a.product_id  = p.id
             LEFT JOIN categories c ON p.category_id = c.id
             LEFT JOIN locations  l ON a.location_id = l.id
             ORDER BY a.assigned_at DESC'
        );
        return $stmt->fetchAll();
    }

    /** Only active (not yet returned) assignments */
    public function findActive(): array {
        $stmt = $this->db->query(
            'SELECT a.*,
                    p.name        AS product_name,
                    p.sku         AS product_sku,
                    p.image_path  AS product_image,
                    p.asset_status,
                    c.name        AS category_name,
                    l.name        AS location_name
             FROM assignments a
             LEFT JOIN products   p ON a.product_id  = p.id
             LEFT JOIN categories c ON p.category_id = c.id
             LEFT JOIN locations  l ON a.location_id = l.id
             WHERE a.status = \'active\'
             ORDER BY a.assigned_at DESC'
        );
        return $stmt->fetchAll();
    }

    /** Assignments for a specific product */
    public function findByProduct(int $productId): array {
        $stmt = $this->db->prepare(
            'SELECT a.*,
                    p.name        AS product_name,
                    p.sku         AS product_sku,
                    p.image_path  AS product_image,
                    p.asset_status,
                    c.name        AS category_name,
                    l.name        AS location_name
             FROM assignments a
             LEFT JOIN products   p ON a.product_id  = p.id
             LEFT JOIN categories c ON p.category_id = c.id
             LEFT JOIN locations  l ON a.location_id = l.id
             WHERE a.product_id = ?
             ORDER BY a.assigned_at DESC'
        );
        $stmt->execute([$productId]);
        return $stmt->fetchAll();
    }

    public function findById(int $id): array|false {
        $stmt = $this->db->prepare(
            'SELECT a.*,
                    p.name        AS product_name,
                    p.sku         AS product_sku,
                    p.image_path  AS product_image,
                    p.asset_status,
                    c.name        AS category_name,
                    l.name        AS location_name
             FROM assignments a
             LEFT JOIN products   p ON a.product_id  = p.id
             LEFT JOIN categories c ON p.category_id = c.id
             LEFT JOIN locations  l ON a.location_id = l.id
             WHERE a.id = ?'
        );
        $stmt->execute([$id]);
        return $stmt->fetch();
    }

    public function create(array $data): int {
        $stmt = $this->db->prepare(
            'INSERT INTO assignments
               (product_id, assignee_name, assigned_by, assigned_at, due_back, notes, location_id, status)
             VALUES
               (:product_id, :assignee_name, :assigned_by, :assigned_at, :due_back, :notes, :location_id, \'active\')'
        );
        $stmt->execute([
            ':product_id'    => $data['product_id'],
            ':assignee_name' => $data['assignee_name'],
            ':assigned_by'   => $data['assigned_by'],
            ':assigned_at'   => $data['assigned_at'] ?? date('Y-m-d H:i:s'),
            ':due_back'      => $data['due_back'] ?? null,
            ':notes'         => $data['notes'] ?? null,
            ':location_id'   => !empty($data['location_id']) ? (int)$data['location_id'] : null,
        ]);
        return (int) $this->db->lastInsertId();
    }

    public function update(int $id, array $fields): bool {
        $set  = implode(', ', array_map(fn($k) => "$k = ?", array_keys($fields)));
        $stmt = $this->db->prepare("UPDATE assignments SET $set WHERE id = ?");
        return $stmt->execute([...array_values($fields), $id]);
    }

    /** Mark returned: set returned_at, status=returned */
    public function markReturned(int $id): bool {
        $stmt = $this->db->prepare(
            'UPDATE assignments SET status = \'returned\', returned_at = NOW() WHERE id = ?'
        );
        return $stmt->execute([$id]);
    }

    public function delete(int $id): bool {
        $stmt = $this->db->prepare('DELETE FROM assignments WHERE id = ?');
        return $stmt->execute([$id]);
    }

    /** Count active assignments (for dashboard) */
    public function countActive(): int {
        return (int) $this->db->query(
            'SELECT COUNT(*) FROM assignments WHERE status = \'active\''
        )->fetchColumn();
    }

    /** Count overdue (active, due_back < today) */
    public function countOverdue(): int {
        return (int) $this->db->query(
            'SELECT COUNT(*) FROM assignments
             WHERE status = \'active\' AND due_back IS NOT NULL AND due_back < CURDATE()'
        )->fetchColumn();
    }

    /** Recent activity — last N assignment events */
    public function findRecent(int $limit = 10): array {
        $stmt = $this->db->prepare(
            'SELECT a.*,
                    p.name AS product_name,
                    p.sku  AS product_sku
             FROM assignments a
             LEFT JOIN products p ON a.product_id = p.id
             ORDER BY a.updated_at DESC
             LIMIT ?'
        );
        $stmt->execute([$limit]);
        return $stmt->fetchAll();
    }

    /** Count new assignments per day for the last N days, optionally filtered by location */
    public function countByDay(int $days = 7, ?int $locationId = null): array {
        $where = 'WHERE assigned_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)';
        $params = [$days];
        if ($locationId) {
            $where .= ' AND location_id = ?';
            $params[] = $locationId;
        }
        $stmt = $this->db->prepare(
            "SELECT DATE(assigned_at) AS day, COUNT(*) AS count
             FROM assignments
             $where
             GROUP BY DATE(assigned_at)
             ORDER BY day ASC"
        );
        $stmt->execute($params);
        $rows = $stmt->fetchAll();

        // Fill in missing days with 0
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

    /** Count deployed assets per category for last N days, optionally by location */
    public function countDeployedByCategoryByDays(int $days, ?int $locationId = null): array {
        $where  = 'WHERE a.status = \'active\' AND a.assigned_at >= DATE_SUB(NOW(), INTERVAL ? DAY)';
        $params = [$days];
        if ($locationId) { $where .= ' AND a.location_id = ?'; $params[] = $locationId; }
        $stmt = $this->db->prepare(
            "SELECT c.id AS category_id, c.name AS category_name, COUNT(*) AS count
             FROM assignments a
             LEFT JOIN products   p ON a.product_id  = p.id
             LEFT JOIN categories c ON p.category_id = c.id
             $where
             GROUP BY c.id, c.name
             ORDER BY c.name ASC"
        );
        $stmt->execute($params);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }
}