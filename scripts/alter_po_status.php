<?php
require __DIR__ . '/../config/database.php';
$db = Database::getConnection();
try {
    $db->exec("ALTER TABLE purchase_orders MODIFY COLUMN status ENUM('pending','pending_receive','received','cancelled') NOT NULL DEFAULT 'pending'");
    echo "Status enum updated.\n";
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
$cols = $db->query("SHOW COLUMNS FROM purchase_orders LIKE 'status'")->fetch();
echo "Status column: " . $cols['Type'] . "\n";
