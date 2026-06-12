<?php
require __DIR__ . '/../config/database.php';
$db  = Database::getConnection();
$sql = file_get_contents(__DIR__ . '/../config/supplier_v2_migration.sql');
// Run each statement separately
foreach (array_filter(array_map('trim', explode(';', $sql))) as $stmt) {
    try { $db->exec($stmt); echo "OK: " . substr($stmt, 0, 60) . "\n"; }
    catch (PDOException $e) { echo "SKIP: " . $e->getMessage() . "\n"; }
}
echo "Done\n";
