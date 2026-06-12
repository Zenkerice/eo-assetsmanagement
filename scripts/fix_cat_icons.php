<?php
$file = __DIR__ . '/../public/index.html';
$content = file_get_contents($file);

// Fix the category icons array in JS - replace the whole broken line
$content = preg_replace(
    "/const icons\s*=\s*\[[^\]]+\];/",
    "const icons = ['&#128246;','&#128421;','&#127991;','&#9000;','&#128433;','&#127911;','&#128221;','&#128295;'];",
    $content
);

// Fix remaining broken em-dash in stat values (the â€" that wasn't caught)
$content = preg_replace('/id="stat-products">[^<]*</', 'id="stat-products">&ndash;<', $content);
$content = preg_replace('/id="stat-categories">[^<]*</', 'id="stat-categories">&ndash;<', $content);
$content = preg_replace('/id="stat-assigned">[^<]*</', 'id="stat-assigned">&ndash;<', $content);
$content = preg_replace('/id="stat-damages">[^<]*</', 'id="stat-damages">&ndash;<', $content);

file_put_contents($file, $content);
echo "Done. Size: " . strlen($content) . "\n";

// Verify icons array
if (preg_match("/const icons\s*=\s*\[([^\]]+)\]/", $content, $m)) {
    echo "Icons array: " . $m[1] . "\n";
}
