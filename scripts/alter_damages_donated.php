<?php
require __DIR__ . '/../config/database.php';
$db = Database::getConnection();
try {
    $db->exec("ALTER TABLE damages MODIFY COLUMN status ENUM('damaged','resolved','disposed','donated') NOT NULL DEFAULT 'damaged'");
    echo "OK: donated status added\n";
    $db->exec("ALTER TABLE damages ADD COLUMN IF NOT EXISTS donated_to VARCHAR(255) DEFAULT NULL");
    echo "OK: donated_to column added\n";
    $db->exec("ALTER TABLE damages ADD COLUMN IF NOT EXISTS donated_at DATETIME DEFAULT NULL");
    echo "OK: donated_at column added\n";
} catch (PDOException $e) { echo "Error: " . $e->getMessage() . "\n"; }
$col = $db->query("SHOW COLUMNS FROM damages LIKE 'status'")->fetch();
echo "Status: " . $col['Type'] . "\n";
