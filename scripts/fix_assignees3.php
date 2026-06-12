<?php
$path = __DIR__ . '/../public/assignees2.html';
$content = file_get_contents($path);

// Triple-encoded ─ (U+2500, E2 94 80): C3 A2 E2 80 9D E2 82 AC
$bad_dash = "\xC3\xA2\xE2\x80\x9D\xE2\x82\xAC";
// Replace sequences of these (used as comment separators like ── Load Page ──)
// Replace each occurrence with a simple ASCII dash
$content = str_replace($bad_dash, '-', $content);

// Also fix any remaining â€" (em dash in option text)
// Check for remaining non-ASCII
preg_match_all('/[\xC0-\xFF][\x80-\xFF]+/', $content, $m);
$remaining = array_unique($m[0]);
echo "Remaining sequences: " . count($remaining) . "\n";
foreach (array_slice($remaining, 0, 10) as $seq) {
    echo bin2hex($seq) . " => " . $seq . "\n";
}

file_put_contents($path, $content);
echo "Saved.\n";
