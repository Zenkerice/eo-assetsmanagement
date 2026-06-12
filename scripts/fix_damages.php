<?php
$file = __DIR__ . '/../public/damages.html';
$content = file_get_contents($file);

// All replacements use hex byte sequences to avoid encoding issues in the script itself
// â€" (en dash mojibake: c3 a2 e2 80 93 in double-encoded UTF-8)
$endash  = "\xc3\xa2\xe2\x80\x93";   // â€"
$hellip  = "\xc3\xa2\xe2\x80\xa6";   // â€¦
$warning = "\xc3\xa2\xc5\xa1\xc2\xa0\xc3\xaf\xc2\xb8\xc2\x8f"; // âš ï¸
$times   = "\xc3\x83\xc2\x97";       // Ã—
$search  = "\xc3\xb0\xc5\xb8\xe2\x80\x9c";  // ðŸ" (magnifying glass mojibake prefix)

// Read raw bytes and do replacements
$raw = file_get_contents($file);

// Fix title dash
$raw = str_replace('Damages &amp; Issues ' . $endash . ' Inventory System',
                   'Damages &amp; Issues &ndash; Inventory System', $raw);

// Fix warning icon in stat card
$raw = str_replace($warning, '&#9888;', $raw);

// Fix modal close button
$raw = str_replace($times, '&times;', $raw);

// Fix all en-dashes
$raw = str_replace($endash, '&ndash;', $raw);

// Fix all ellipses
$raw = str_replace($hellip, '&hellip;', $raw);

// Fix search icon prefix + text (magnifying glass emoji mojibake)
// The search placeholder starts with broken emoji bytes
$raw = preg_replace('/placeholder="[^\x20-\x7E]*\s*Search by/', 'placeholder="&#128269; Search by', $raw);

// Fix any remaining Ã— (times sign)
$raw = str_replace("\xc3\x83\xc2\x97", '&times;', $raw);

file_put_contents($file, $raw);
echo "Done. Size: " . strlen($raw) . "\n";

// Verify - check for high bytes that shouldn't be there (outside normal ASCII + HTML entities)
$lines = explode("\n", $raw);
$issues = 0;
foreach ($lines as $i => $line) {
    // Check for multi-byte sequences that look like mojibake (c3 followed by non-standard)
    if (preg_match('/\xc3[\xa2\xb0\xaf\x83]/', $line)) {
        echo "Line " . ($i+1) . ": " . trim(substr($line, 0, 100)) . "\n";
        $issues++;
    }
}
echo "Lines with potential issues: $issues\n";
