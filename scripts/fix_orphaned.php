<?php
require __DIR__ . '/../config/database.php';
$db = Database::getConnection();

// Mark as returned any active assignments whose product no longer exists
$n = $db->exec(
    "UPDATE assignments a
     LEFT JOIN products p ON a.product_id = p.id
     SET a.status = 'returned', a.returned_at = NOW()
     WHERE a.status = 'active' AND p.id IS NULL"
);
echo "Fixed $n orphaned active assignments (product deleted).\n";

// Also fix products that are still under_repair but have a disposed/donated damage record
$n2 = $db->exec(
    "UPDATE products p
     JOIN damages d ON d.product_id = p.id
     SET p.asset_status = 'available'
     WHERE d.status IN ('disposed','donated') AND p.asset_status = 'under_repair'"
);
echo "Reset $n2 products stuck in under_repair after dispose/donate.\n";

echo "\n=== ACTIVE ASSIGNMENTS AFTER FIX ===\n";
$rows = $db->query('SELECT a.id, a.assignee_name, a.product_id, a.status, p.name AS pname FROM assignments a LEFT JOIN products p ON a.product_id = p.id WHERE a.status = "active"')->fetchAll(PDO::FETCH_ASSOC);
foreach ($rows as $r) echo "id={$r['id']} assignee={$r['assignee_name']} product_id={$r['product_id']} product={$r['pname']}\n";
