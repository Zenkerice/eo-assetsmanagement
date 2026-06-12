<?php
require __DIR__ . '/../config/database.php';
$db = Database::getConnection();
try {
    $db->exec('ALTER TABLE products DROP COLUMN price');
    echo "Dropped price column from products\n";
} catch (PDOException $e) {
    echo "Skip: " . $e->getMessage() . "\n";
}
