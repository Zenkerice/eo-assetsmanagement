<?php
$path = __DIR__ . '/../public/assignees2.html';
$content = file_get_contents($path);

// The JS comment dashes: â"€ = U+2500 (BOX DRAWINGS LIGHT HORIZONTAL)
// Triple-encoded bytes: C3 A2 E2 80 9D E2 82 AC  (for â€") and C3 A2 E2 80 9C E2 82 AC (for â€")
// The box-drawing char â"€ = bytes C3 A2 E2 80 9C E2 82 AC ... let's find exact bytes

// Find "Utilities" comment area
$idx = strpos($content, 'Utilities');
$raw = substr($content, $idx - 5, 30);
echo "Raw hex: " . bin2hex($raw) . "\n";
echo "Raw text: " . $raw . "\n";

// The pattern â"€ in triple-encoding:
// U+2500 = E2 94 80 in UTF-8
// Triple-encoded: C3 A2 E2 80 9C E2 80 9C ... let me check actual bytes
$patterns = [];
// Scan for all non-ASCII sequences
preg_match_all('/[\xC0-\xFF][\x80-\xFF]+/', $content, $m);
$unique = array_unique($m[0]);
foreach ($unique as $seq) {
    if (strlen($seq) >= 3) {
        echo bin2hex($seq) . " => " . $seq . "\n";
    }
}
