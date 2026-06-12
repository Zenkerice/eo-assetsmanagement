<?php
require __DIR__ . '/../config/database.php';
$db = Database::getConnection();
try {
    $db->exec("ALTER TABLE users MODIFY COLUMN role ENUM('admin','staff','viewer') NOT NULL DEFAULT 'staff'");
    echo "OK: role enum updated\n";
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
$col = $db->query("SHOW COLUMNS FROM users LIKE 'role'")->fetch();
echo "Role column: " . $col['Type'] . "\n";
