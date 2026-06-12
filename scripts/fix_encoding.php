<?php
/**
 * Fix triple/double-encoded UTF-8 characters in HTML files.
 * Replaces all known corrupted sequences with correct UTF-8.
 */

$files = [
    __DIR__ . '/../public/damages.html',
    __DIR__ . '/../public/index.html',
];

// Map of corrupted byte sequences (as raw strings) => correct UTF-8 string
// Each corrupted sequence was produced by encoding UTF-8 bytes as Latin-1 multiple times.
// We detect them by scanning for non-ASCII sequences and mapping known patterns.
$replacements = [
    // — (U+2014, E2 80 94) various corruption forms
    "\xC3\xA2\xE2\x82\xAC\xE2\x80\x9D" => "\xE2\x80\x94",  // triple-encoded
    "\xC3\xA2\xE2\x82\xAC\xC2\x9D"     => "\xE2\x80\x94",  // double-encoded variant
    "\xE2\x80\x9C\xE2\x80\x94"         => "\xE2\x80\x94",  // partial
    "\xC3\x83\xE2\x80\x94"             => "\xC3\x97",       // × (U+00D7) partial fix -> correct
    // … (U+2026, E2 80 A6)
    "\xC3\xA2\xE2\x82\xAC\xC2\xA6"     => "\xE2\x80\xA6",  // triple-encoded
    // × (U+00D7, C3 97)
    "\xC3\x83\xC2\x97"                 => "\xC3\x97",
    // ↻ (U+21BB, E2 86 BB)
    "\xC3\xA2\xE2\x80\xA0\xC2\xBB"     => "\xE2\x86\xBB",
    // ✅ (U+2705, E2 9C 85)
    "\xC3\xA2\xC5\x93\xC2\x85"         => "\xE2\x9C\x85",
    // – (U+2013, E2 80 93)
    "\xC3\xA2\xE2\x82\xAC\xE2\x80\x9C" => "\xE2\x80\x93",
];

foreach ($files as $path) {
    if (!file_exists($path)) { echo "Not found: $path\n"; continue; }
    $content = file_get_contents($path);
    $original = $content;
    foreach ($replacements as $bad => $good) {
        $content = str_replace($bad, $good, $content);
    }
    if ($content !== $original) {
        file_put_contents($path, $content);
        echo "Fixed: " . basename($path) . "\n";
    } else {
        echo "No changes: " . basename($path) . "\n";
    }
}
echo "Done.\n";
