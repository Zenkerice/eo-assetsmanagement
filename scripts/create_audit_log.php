<?php
require __DIR__ . '/../config/database.php';
$db = Database::getConnection();
$db->exec("
CREATE TABLE IF NOT EXISTS audit_logs (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  user_id     INT          DEFAULT NULL,
  user_name   VARCHAR(150) NOT NULL DEFAULT 'System',
  action      ENUM('created','updated','deleted','assigned','returned','imported','received','disposed','reported') NOT NULL,
  entity_type VARCHAR(50)  NOT NULL,
  entity_id   INT          DEFAULT NULL,
  entity_name VARCHAR(255) DEFAULT NULL,
  description TEXT         DEFAULT NULL,
  meta        JSON         DEFAULT NULL,
  created_at  DATETIME     DEFAULT CURRENT_TIMESTAMP,
  KEY idx_user_id   (user_id),
  KEY idx_action    (action),
  KEY idx_entity    (entity_type),
  KEY idx_created   (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
");
echo "audit_logs table created.\n";
$cols = $db->query("SHOW COLUMNS FROM audit_logs")->fetchAll(PDO::FETCH_COLUMN);
echo "Columns: " . implode(', ', $cols) . "\n";
