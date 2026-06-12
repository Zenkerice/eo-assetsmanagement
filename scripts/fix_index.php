<?php
$path = __DIR__ . '/../public/index.html';
$content = file_get_contents($path);

// Fix "Manage →" — triple-encoded → (U+2192, E2 86 92)
// Current bytes: 4d616e61676520 c3a2 e280a0 e28099
// Replace with: Manage &#8594;
$bad_arrow = "\xC3\xA2\xE2\x80\xA0\xE2\x80\x99";
$content = str_replace('Manage ' . $bad_arrow, 'Manage &#8594;', $content);

// Also fix title — (U+2013 en-dash) if still broken
// "Dashboard – Inventory" — check if – is correct (E2 80 93)
// The file shows it as – which looks correct already

file_put_contents($path, $content);
echo "Done.\n";

// Verify
$t = file_get_contents($path);
$i = strpos($t, 'Manage');
echo "Manage area: " . bin2hex(substr($t, $i, 15)) . "\n";
