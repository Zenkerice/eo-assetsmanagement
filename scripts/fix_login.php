<?php
$path = __DIR__ . '/../public/login.html';
$content = file_get_contents($path);

$fixes = [
    // — (U+2014) triple-encoded
    "\xC3\xA2\xE2\x82\xAC\xE2\x80\x9D" => '&mdash;',
    // 📦 (U+1F4E6) — F0 9F 93 A6 triple-encoded: C3 B0 C5 B8 E2 80\x99 C2\xA6
    "\xC3\xB0\xC5\xB8\xE2\x80\x99\xC2\xA6" => '&#128230;',
    // 👤 (U+1F464) — F0 9F 91 A4 triple-encoded
    "\xC3\xB0\xC5\xB8\xE2\x80\x98\xC2\xA4" => '&#128100;',
    // 🔑 (U+1F511) — F0 9F 94 91 triple-encoded
    "\xC3\xB0\xC5\xB8\xE2\x80\x9C\xC2\x91" => '&#128273;',
    // ⚠️ (U+26A0 + U+FE0F) triple-encoded
    "\xC3\xA2\xC5\xA1\xC2\xA0\xC3\xAF\xC2\xB8\xC2\x8F" => '&#9888;&#65039;',
    // 401 comment — (same em-dash pattern)
    "\xC3\xA2\xE2\x82\xAC\xE2\x80\x9C" => '&ndash;',
];

foreach ($fixes as $bad => $good) {
    $content = str_replace($bad, $good, $content);
}

file_put_contents($path, $content);
echo "Done.\n";

// Verify key spots
$t = file_get_contents($path);
echo "title: " . substr($t, strpos($t, '<title>'), 40) . "\n";
echo "brand-icon: " . substr($t, strpos($t, 'brand-icon">'), 25) . "\n";
echo "username icon: " . substr($t, strpos($t, 'input-icon">'), 25) . "\n";
