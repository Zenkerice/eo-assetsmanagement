<?php
require_once __DIR__ . '/../config/database.php';

class AuditLogModel {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
    }

    public function log(array $data): int {
        // Silently map any action not in the original ENUM to a safe fallback
        // so existing logs aren't broken if the migration hasn't run yet.
        // Once migration runs, all values are valid.
        $validActions = [
            'created','updated','deleted','assigned','returned',
            'imported','received','disposed','reported',
            'approved','rejected','pending',
        ];
        $action = in_array($data['action'], $validActions, true) ? $data['action'] : 'updated';

        $stmt = $this->db->prepare(
            'INSERT INTO audit_logs (user_id, user_name, action, entity_type, entity_id, entity_name, description, meta)
             VALUES (:user_id, :user_name, :action, :entity_type, :entity_id, :entity_name, :description, :meta)'
        );
        $stmt->execute([
            ':user_id'     => $data['user_id']     ?? null,
            ':user_name'   => $data['user_name']   ?? 'System',
            ':action'      => $action,
            ':entity_type' => $data['entity_type'],
            ':entity_id'   => $data['entity_id']   ?? null,
            ':entity_name' => $data['entity_name'] ?? null,
            ':description' => $data['description'] ?? null,
            ':meta'        => isset($data['meta']) ? json_encode($data['meta']) : null,
        ]);
        return (int) $this->db->lastInsertId();
    }

    public function findAll(array $filters = [], int $page = 1, int $perPage = 20): array {
        [$where, $params] = $this->buildWhere($filters);
        $offset = ($page - 1) * $perPage;
        $stmt = $this->db->prepare(
            "SELECT * FROM audit_logs $where ORDER BY created_at DESC LIMIT :limit OFFSET :offset"
        );
        foreach ($params as $k => $v) $stmt->bindValue($k, $v);
        $stmt->bindValue(':limit',  $perPage, PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset,  PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function count(array $filters = []): int {
        [$where, $params] = $this->buildWhere($filters);
        $stmt = $this->db->prepare("SELECT COUNT(*) FROM audit_logs $where");
        $stmt->execute($params);
        return (int) $stmt->fetchColumn();
    }

    public function getUsers(): array {
        $stmt = $this->db->query('SELECT DISTINCT user_name FROM audit_logs ORDER BY user_name ASC');
        return $stmt->fetchAll(PDO::FETCH_COLUMN);
    }

    private function buildWhere(array $f): array {
        $conds = []; $params = [];
        if (!empty($f['action']))  { $conds[] = 'action = :action';       $params[':action']  = $f['action']; }
        if (!empty($f['user']))    { $conds[] = 'user_name = :user';       $params[':user']    = $f['user']; }
        if (!empty($f['entity']))  { $conds[] = 'entity_type = :entity';   $params[':entity']  = $f['entity']; }
        if (!empty($f['search']))  {
            $conds[] = '(user_name LIKE :s OR entity_name LIKE :s2 OR description LIKE :s3)';
            $params[':s']  = '%' . $f['search'] . '%';
            $params[':s2'] = '%' . $f['search'] . '%';
            $params[':s3'] = '%' . $f['search'] . '%';
        }
        if (!empty($f['from']))    {
            // If the value already includes a time component, use it as-is; otherwise add midnight
            $fromVal = (strlen($f['from']) > 10) ? $f['from'] : $f['from'] . ' 00:00:00';
            $conds[] = 'created_at >= :from';
            $params[':from'] = $fromVal;
        }
        if (!empty($f['to']))      {
            // If the value already includes a time component, use it as-is; otherwise add end-of-day
            $toVal = (strlen($f['to']) > 10) ? $f['to'] : $f['to'] . ' 23:59:59';
            $conds[] = 'created_at <= :to';
            $params[':to'] = $toVal;
        }
        if (!empty($f['period'])) {
            $p = $f['period'];
            if ($p === 'today') {
                $conds[] = 'DATE(created_at) = CURDATE()';
            } elseif ($p === '1day') {
                $conds[] = 'created_at >= DATE_SUB(NOW(), INTERVAL 1 DAY)';
            } elseif ($p === '2days') {
                $conds[] = 'created_at >= DATE_SUB(NOW(), INTERVAL 2 DAY)';
            } elseif ($p === 'week') {
                $conds[] = 'created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)';
            } elseif ($p === 'month') {
                $conds[] = 'created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)';
            }
        }
        $where = $conds ? 'WHERE ' . implode(' AND ', $conds) : '';
        return [$where, $params];
    }
}
