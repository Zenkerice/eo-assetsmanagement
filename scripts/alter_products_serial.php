<?php
require __DIR__ . '/../config/database.php';
$db = Database::getConnection();
$stmts = [
    "ALTER TABLE products ADD COLUMN IF NOT EXISTS serial_number VARCHAR(150) DEFAULT NULL",
    "ALTER TABLE products ADD COLUMN IF NOT EXISTS po_id INT DEFAULT NULL",
    "ALTER TABLE products ADD COLUMN IF NOT EXISTS po_item_id INT DEFAULT NULL",
];
foreach ($stmts as $sql) {
    try { $db->exec($sql); echo "OK: $sql\n"; }
    catch (PDOException $e) { echo "Skip: " . $e->getMessage() . "\n"; }
}
$cols = $db->query("SHOW COLUMNS FROM products")->fetchAll(PDO::FETCH_COLUMN);
echo "\nproducts columns: " . implode(', ', $cols) . "\n";
