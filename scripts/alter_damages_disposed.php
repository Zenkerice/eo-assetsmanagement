<?php
require __DIR__ . '/../config/database.php';
$db = Database::getConnection();
try {
    $db->exec("ALTER TABLE damages MODIFY COLUMN status ENUM('damaged','resolved','disposed') NOT NULL DEFAULT 'damaged'");
    echo "OK: status enum updated\n";
    $db->exec("ALTER TABLE damages ADD COLUMN IF NOT EXISTS disposed_at DATETIME DEFAULT NULL");
    echo "OK: disposed_at added\n";
    $db->exec("ALTER TABLE damages ADD COLUMN IF NOT EXISTS disposal_reason TEXT DEFAULT NULL");
    echo "OK: disposal_reason added\n";
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
$col = $db->query("SHOW COLUMNS FROM damages LIKE 'status'")->fetch();
echo "Status: " . $col['Type'] . "\n";
