<?php
require_once __DIR__ . '/../config/database.php';

class EmployeeModel {
    private PDO $db;

    public function __construct() {
        $this->db = Database::getConnection();
        $this->ensureTable();
    }

    /** Auto-create the employees table if it doesn't exist yet */
    private function ensureTable(): void {
        $this->db->exec("
            CREATE TABLE IF NOT EXISTS `employees` (
              `id`          INT(11)      NOT NULL AUTO_INCREMENT,
              `employee_id` VARCHAR(100) NOT NULL DEFAULT '',
              `name`        VARCHAR(150) NOT NULL,
              `station`     VARCHAR(150) NOT NULL DEFAULT '',
              `seat_number` VARCHAR(50)  NOT NULL DEFAULT '',
              `location_id` INT(11)      DEFAULT NULL,
              `created_at`  DATETIME     NOT NULL DEFAULT current_timestamp(),
              `updated_at`  DATETIME     NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
              PRIMARY KEY (`id`),
              KEY `idx_employee_id`  (`employee_id`),
              KEY `idx_station`      (`station`),
              KEY `idx_seat_number`  (`seat_number`),
              KEY `idx_location_id`  (`location_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        ");
        // Add columns if the table already exists without them
        try {
            $this->db->exec("ALTER TABLE `employees` ADD COLUMN IF NOT EXISTS `employee_id` VARCHAR(100) NOT NULL DEFAULT '' AFTER `id`");
            $this->db->exec("ALTER TABLE `employees` ADD KEY IF NOT EXISTS `idx_employee_id` (`employee_id`)");
        } catch (\PDOException $e) { /* column already exists — ignore */ }
        try {
            $this->db->exec("ALTER TABLE `employees` ADD COLUMN IF NOT EXISTS `location_id` INT(11) DEFAULT NULL");
            $this->db->exec("ALTER TABLE `employees` ADD KEY IF NOT EXISTS `idx_location_id` (`location_id`)");
        } catch (\PDOException $e) { /* column already exists — ignore */ }
    }

    public function findAll(string $station = ''): array {
        if ($station !== '') {
            $stmt = $this->db->prepare(
                'SELECT e.*, l.name AS location_name
                 FROM employees e
                 LEFT JOIN locations l ON e.location_id = l.id
                 WHERE e.station = ?
                 ORDER BY e.seat_number ASC, e.name ASC'
            );
            $stmt->execute([$station]);
        } else {
            $stmt = $this->db->query(
                'SELECT e.*, l.name AS location_name
                 FROM employees e
                 LEFT JOIN locations l ON e.location_id = l.id
                 ORDER BY e.seat_number ASC, e.name ASC'
            );
        }
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    public function findById(int $id): array|false {
        $stmt = $this->db->prepare(
            'SELECT e.*, l.name AS location_name
             FROM employees e
             LEFT JOIN locations l ON e.location_id = l.id
             WHERE e.id = ?'
        );
        $stmt->execute([$id]);
        return $stmt->fetch(\PDO::FETCH_ASSOC);
    }

    public function findByName(string $name): array|false {
        $stmt = $this->db->prepare('SELECT * FROM employees WHERE name = ? LIMIT 1');
        $stmt->execute([$name]);
        return $stmt->fetch(\PDO::FETCH_ASSOC);
    }

    public function getStations(): array {
        $stmt = $this->db->query(
            "SELECT DISTINCT station FROM employees WHERE station != '' ORDER BY station ASC"
        );
        return $stmt->fetchAll(\PDO::FETCH_COLUMN);
    }

    public function create(array $data): int {
        $stmt = $this->db->prepare(
            'INSERT INTO employees (employee_id, name, station, seat_number, location_id)
             VALUES (:employee_id, :name, :station, :seat_number, :location_id)'
        );
        $stmt->execute([
            ':employee_id' => trim($data['employee_id'] ?? ''),
            ':name'        => trim($data['name']),
            ':station'     => trim($data['station']     ?? ''),
            ':seat_number' => trim($data['seat_number'] ?? ''),
            ':location_id' => !empty($data['location_id']) ? (int)$data['location_id'] : null,
        ]);
        return (int) $this->db->lastInsertId();
    }

    public function update(int $id, array $data): bool {
        $fields = [];
        $params = [];
        foreach (['employee_id', 'name', 'station', 'seat_number'] as $f) {
            if (array_key_exists($f, $data)) {
                $fields[] = "$f = ?";
                $params[] = trim($data[$f]);
            }
        }
        if (array_key_exists('location_id', $data)) {
            $fields[] = 'location_id = ?';
            $params[] = !empty($data['location_id']) ? (int)$data['location_id'] : null;
        }
        if (!$fields) return false;
        $params[] = $id;
        $stmt = $this->db->prepare('UPDATE employees SET ' . implode(', ', $fields) . ' WHERE id = ?');
        return $stmt->execute($params);
    }

    public function delete(int $id): bool {
        $stmt = $this->db->prepare('DELETE FROM employees WHERE id = ?');
        return $stmt->execute([$id]);
    }

    /**
     * Bulk upsert from imported rows.
     * Each row: ['name', 'station', 'seat_number', 'location_name']
     * Resolves location_name to location_id. Creates location if not found.
     * Matches employees on name — updates if exists, inserts if not.
     */
    public function bulkUpsert(array $rows): array {
        $inserted = 0; $updated = 0; $skipped = 0;

        // Build a location name → id cache to avoid repeated queries
        $locationCache = [];
        $resolveLocation = function(string $name) use (&$locationCache): ?int {
            $name = trim($name);
            if ($name === '') return null;
            if (isset($locationCache[$name])) return $locationCache[$name];

            // Try to find existing location (case-insensitive)
            $stmt = $this->db->prepare('SELECT id FROM locations WHERE LOWER(name) = LOWER(?) LIMIT 1');
            $stmt->execute([$name]);
            $row = $stmt->fetch(\PDO::FETCH_ASSOC);
            if ($row) {
                $locationCache[$name] = (int)$row['id'];
                return $locationCache[$name];
            }

            // Create it if it doesn't exist
            $ins = $this->db->prepare('INSERT INTO locations (name) VALUES (?)');
            $ins->execute([$name]);
            $id = (int)$this->db->lastInsertId();
            $locationCache[$name] = $id;
            return $id;
        };

        foreach ($rows as $row) {
            $name = trim($row['name'] ?? '');
            if ($name === '') { $skipped++; continue; }

            $locationId = $resolveLocation($row['location_name'] ?? '');

            $existing = $this->findByName($name);
            if ($existing) {
                $update = [
                    'station'     => trim($row['station']     ?? $existing['station']),
                    'seat_number' => trim($row['seat_number'] ?? $existing['seat_number']),
                ];
                // Only overwrite location if a value was provided in the import
                if (trim($row['location_name'] ?? '') !== '') {
                    $update['location_id'] = $locationId;
                }
                $this->update($existing['id'], $update);
                $updated++;
            } else {
                $this->create([
                    'name'        => $name,
                    'station'     => trim($row['station']     ?? ''),
                    'seat_number' => trim($row['seat_number'] ?? ''),
                    'location_id' => $locationId,
                ]);
                $inserted++;
            }
        }
        return compact('inserted', 'updated', 'skipped');
    }
}
