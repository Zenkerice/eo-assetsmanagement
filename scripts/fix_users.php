<?php
$path = __DIR__ . '/../public/users.html';
$content = file_get_contents($path);

// Fix corrupted characters
$fixes = [
    "\xC3\xA2\xE2\x82\xAC\xE2\x80\x9D" => '&mdash;',  // —
    "\xC3\xA2\xE2\x82\xAC\xC2\xA6"     => '&hellip;', // …
    "\xC3\xA2\xE2\x82\xAC\xE2\x80\x9C" => '&ndash;',  // –
    "\xC3\xB0\xC5\xB8\x91\xC2\xA5"     => '&#128101;', // 👥
    "\xC3\xB0\xC5\xB8\x91\xC2\xA5"     => '&#128101;',
    "\xC3\xA2\xE2\x80\xA0\xC2\xBB"     => '&#8635;',  // ↻
    "\xC3\x83\xE2\x80\x94"             => '&times;',  // ×
];
foreach ($fixes as $bad => $good) {
    $content = str_replace($bad, $good, $content);
}

// Fix role select
$content = str_replace(
    '<option value="staff">Staff',
    '<option value="viewer">Viewer &mdash; read-only access</option>' . "\n          " . '<option value="staff">Staff',
    $content
);

// Fix role dropdown descriptions using regex
$content = preg_replace('/Staff\s*[^\-<]*\s*can add/', 'Staff &mdash; can add', $content);
$content = preg_replace('/Admin\s*[^\-<]*\s*full control/', 'Admin &mdash; full control', $content);

file_put_contents($path, $content);
echo "Done.\n";

// Verify role select
$t = file_get_contents($path);
$i = strpos($t, 'f-role');
echo substr($t, $i, 300) . "\n";
