<?php
require __DIR__ . '/../config/database.php';
$db = Database::getConnection();
try {
    $db->exec('ALTER TABLE purchase_order_items ADD COLUMN IF NOT EXISTS category_id INT DEFAULT NULL');
    echo "OK: category_id added to purchase_order_items\n";
} catch (PDOException $e) {
    echo "Skip: " . $e->getMessage() . "\n";
}
$cols = $db->query("SHOW COLUMNS FROM purchase_order_items")->fetchAll(PDO::FETCH_COLUMN);
echo "Columns: " . implode(', ', $cols) . "\n";
