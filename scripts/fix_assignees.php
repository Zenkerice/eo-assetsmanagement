<?php
$path = __DIR__ . '/../public/assignees2.html';
$content = file_get_contents($path);

$fixes = [
    // — (em dash, U+2014) triple-encoded
    "\xC3\xA2\xE2\x82\xAC\xE2\x80\x9D" => '&mdash;',
    // – (en dash, U+2013)
    "\xC3\xA2\xE2\x82\xAC\xE2\x80\x9C" => '&ndash;',
    // … (ellipsis, U+2026)
    "\xC3\xA2\xE2\x82\xAC\xC2\xA6"     => '&hellip;',
    // ─ (box drawing, U+2500) used in JS comments
    "\xC3\xA2\xE2\x80\x9C\xE2\x80\x94" => '\u2500',
    // × (multiply, U+00D7)
    "\xC3\x83\xC2\x97"                 => '&times;',
    // Assignees title — (em dash in title)
    "\xC3\xA2\xE2\x82\xAC\xE2\x80\x9D" => '&mdash;',
];

foreach ($fixes as $bad => $good) {
    $content = str_replace($bad, $good, $content);
}

// Fix the title
$content = str_replace('Assignees â€" Inventory System', 'Assignees &mdash; Inventory System', $content);

// Fix select option placeholders: â€" Select category â€"
$content = preg_replace('/â€["\x{201C}\x{201D}]/u', '&mdash;', $content);

// Fix JS comment dashes: â"€â"€
$content = str_replace('â"€', '─', $content);

file_put_contents($path, $content);
echo "Done.\n";

// Verify title
$t = file_get_contents($path);
echo "Title: " . substr($t, strpos($t, '<title>'), 50) . "\n";
echo "Select option: " . substr($t, strpos($t, 'Select category'), 30) . "\n";
