<?php
require_once __DIR__ . '/config/database.php';
$db = Database::getConnection();

// Fix transactions — add PK then AUTO_INCREMENT
try {
    $col = $db->query("SHOW COLUMNS FROM transactions WHERE Field = 'id'")->fetch(PDO::FETCH_ASSOC);
    if (strpos($col['Extra'], 'auto_increment') === false) {
        // Check if PK existshkhkhgit push
        $pk = $db->query("SHOW KEYS FROM transactions WHERE Key_name = 'PRIMARY'")->fetch();
        if (!$pk) {
            $db->exec("ALTER TABLE transactions ADD PRIMARY KEY (id)");
            file_put_contents('C:/xampp/htdocs/inventory/_fix_log.txt', "Added PK to transactions\n", FILE_APPEND);
        }
        $nextAI = (int)$db->query("SELECT IFNULL(MAX(id),0)+1 FROM transactions")->fetchColumn();
        $db->exec("ALTER TABLE transactions MODIFY id INT(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT = $nextAI");
        file_put_contents('C:/xampp/htdocs/inventory/_fix_log.txt', "Fixed transactions AUTO_INCREMENT, next=$nextAI\n", FILE_APPEND);
    } else {
        file_put_contents('C:/xampp/htdocs/inventory/_fix_log.txt', "transactions already OK\n", FILE_APPEND);
    }
} catch (Exception $e) {
    file_put_contents('C:/xampp/htdocs/inventory/_fix_log.txt', "ERROR transactions: " . $e->getMessage() . "\n", FILE_APPEND);
}

// Final check — all tables
$out = "\n=== All table id column status ===\n";
$tables = $db->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
foreach ($tables as $table) {
    $col = $db->query("SHOW COLUMNS FROM `$table` WHERE Field = 'id'")->fetch(PDO::FETCH_ASSOC);
    if (!$col) continue;
    $ai = $db->query("SHOW TABLE STATUS LIKE '$table'")->fetch(PDO::FETCH_ASSOC)['Auto_increment'];
    $ok = strpos($col['Extra'], 'auto_increment') !== false;
    $out .= ($ok ? "OK" : "MISSING") . " $table Auto_increment=$ai\n";
}
file_put_contents('C:/xampp/htdocs/inventory/_fix_log.txt', $out, FILE_APPEND);
echo "Done. See _fix_log.txt\n";
