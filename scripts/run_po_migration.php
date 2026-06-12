<?php
require __DIR__ . '/../config/database.php';
$db  = Database::getConnection();
$sql = file_get_contents(__DIR__ . '/../config/purchase_orders_migration.sql');
$db->exec($sql);
echo "Migration done\n";
