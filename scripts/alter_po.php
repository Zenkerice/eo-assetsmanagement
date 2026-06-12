<?php
require __DIR__ . '/../config/database.php';
$db = Database::getConnection();

// Also check/add purchase_order_items columns needed
$stmts = [
    "ALTER TABLE purchase_orders ADD COLUMN IF NOT EXISTS received_by VARCHAR(150) DEFAULT NULL",
    "ALTER TABLE purchase_orders ADD COLUMN IF NOT EXISTS received_date DATETIME DEFAULT NULL",
    // Ensure purchase_order_items has product_name and sku (the service uses these)
    "ALTER TABLE purchase_order_items ADD COLUMN IF NOT EXISTS product_name VARCHAR(255) NOT NULL DEFAULT ''",
    "ALTER TABLE purchase_order_items ADD COLUMN IF NOT EXISTS sku VARCHAR(100) DEFAULT NULL",
    // Rename description -> product_name if description exists but product_name doesn't
];

foreach ($stmts as $sql) {
    try {
        $db->exec($sql);
        echo "OK: $sql\n";
    } catch (PDOException $e) {
        echo "Skip: " . $e->getMessage() . "\n";
    }
}

// Show final columns
$cols = $db->query("SHOW COLUMNS FROM purchase_orders")->fetchAll(PDO::FETCH_COLUMN);
echo "\npurchase_orders columns: " . implode(', ', $cols) . "\n";
$cols2 = $db->query("SHOW COLUMNS FROM purchase_order_items")->fetchAll(PDO::FETCH_COLUMN);
echo "purchase_order_items columns: " . implode(', ', $cols2) . "\n";
