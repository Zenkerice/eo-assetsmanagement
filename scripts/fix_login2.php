<?php
$path = __DIR__ . '/../public/login.html';
$content = file_get_contents($path);

// Get full brand-icon sequence (📦 U+1F4E6, UTF-8: F0 9F 93 A6)
// Triple-encoded: C3 B0 C5 B8 E2 80 9C C2 A6  (9F->C5B8, 93->E2809C, A6->C2A6)
// Wait — let me check what's actually there by finding the closing </div>
$i = strpos($content, 'brand-icon">') + 12;
$end = strpos($content, '</div>', $i);
$brandRaw = substr($content, $i, $end - $i);
echo "brand raw hex: " . bin2hex($brandRaw) . "\n";

// Get password icon sequence
$i1 = strpos($content, 'input-icon">');
$i2 = strpos($content, 'input-icon">', $i1 + 1);
$end2 = strpos($content, '</span>', $i2);
$passRaw = substr($content, $i2 + 12, $end2 - ($i2 + 12));
echo "pass raw hex: " . bin2hex($passRaw) . "\n";

// Now do replacements
$content = str_replace($brandRaw, '&#128230;', $content);  // 📦
$content = str_replace($passRaw,  '&#128273;', $content);  // 🔑

file_put_contents($path, $content);
echo "Fixed.\n";

// Verify
$t = file_get_contents($path);
$i = strpos($t, 'brand-icon">') + 12;
echo "brand-icon now: " . substr($t, $i, 15) . "\n";
