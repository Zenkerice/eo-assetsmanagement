<?php
require __DIR__ . '/../config/database.php';
$db = Database::getConnection();

$tables = $db->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
$out = [];
$out[] = "-- ============================================================";
$out[] = "-- Inventory System — Full Database Schema";
$out[] = "-- Generated: " . date('Y-m-d H:i:s');
$out[] = "-- ============================================================";
$out[] = "";
$out[] = "SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';";
$out[] = "SET FOREIGN_KEY_CHECKS = 0;";
$out[] = "SET NAMES utf8mb4;";
$out[] = "";
$out[] = "CREATE DATABASE IF NOT EXISTS \`inventory_db\`";
$out[] = "  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;";
$out[] = "USE \`inventory_db\`;";
$out[] = "";

foreach ($tables as $table) {
    $row = $db->query("SHOW CREATE TABLE `$table`")->fetch(PDO::FETCH_NUM);
    $out[] = "-- ------------------------------------------------------------";
    $out[] = "-- $table";
    $out[] = "-- ------------------------------------------------------------";
    $out[] = "DROP TABLE IF EXISTS \`$table\`;";
    $out[] = $row[1] . ";";
    $out[] = "";
}

$out[] = "SET FOREIGN_KEY_CHECKS = 1;";

$sql = implode("\n", $out);
file_put_contents(__DIR__ . '/../config/inventory_db_full_schema.sql', $sql);
echo "Done. Tables: " . implode(', ', $tables) . "\n";
echo "File: config/inventory_db_full_schema.sql\n";
