<?php
$file = __DIR__ . '/../public/index.html';
$content = file_get_contents($file);

// Fix stat card icons - replace any broken emoji sequences with HTML entities
// Total Assets icon (📦 = box)
$content = preg_replace('/<div class="stat-icon">[^<]*<\/div>\s*<div class="stat-label">Total Assets/s',
    '<div class="stat-icon">&#128246;</div>' . "\n        " . '<div class="stat-label">Total Assets', $content);

// Categories icon (🏷 = label)
$content = preg_replace('/<div class="stat-icon">[^<]*<\/div>\s*<div class="stat-label">Categories/s',
    '<div class="stat-icon">&#127991;</div>' . "\n        " . '<div class="stat-label">Categories', $content);

// Available icon (✅ = check)
$content = preg_replace('/<div class="stat-icon">[^<]*<\/div>\s*<div class="stat-label">Available/s',
    '<div class="stat-icon">&#9989;</div>' . "\n        " . '<div class="stat-label">Available', $content);

// Open Issues icon (⚠ = warning)
$content = preg_replace('/<div class="stat-icon">[^<]*<\/div>\s*<div class="stat-label">Open Issues/s',
    '<div class="stat-icon">&#9888;</div>' . "\n        " . '<div class="stat-label">Open Issues', $content);

// Fix broken em dash in stat values (â€" = –)
$content = str_replace("\xe2\x80\x93", '&ndash;', $content);
$content = str_replace('â€"', '&ndash;', $content);

// Fix category mini-card icons in JS (📦🖥️🏷️⌨️🖱️🎧📝🔧)
$content = str_replace(
    "'📦','🖥️','🏷️','⌨️','🖱️','🎧','📝','🔧'",
    "'&#128246;','&#128421;','&#127991;','&#9000;','&#128433;','&#127911;','&#128221;','&#128295;'",
    $content
);

file_put_contents($file, $content);
echo "Done. Size: " . strlen($content) . "\n";

// Verify
$checks = ['&#128246;', '&#127991;', '&#9989;', '&#9888;'];
foreach ($checks as $c) {
    echo (strpos($content, $c) !== false ? "OK" : "MISSING") . " $c\n";
}
