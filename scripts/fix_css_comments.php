<?php
$file = __DIR__ . '/../public/categories.html';
$content = file_get_contents($file);

// Replace CSS comment dashes: /* &#8211;&#8211; Section &#8211;... */
// with clean: /* ── Section ─────────────────── */
$content = preg_replace_callback(
    '/\/\*\s*((?:&#8211;)+)\s*([^*]+?)\s*((?:&#8211;)*)\s*\*\//',
    function($m) {
        $label = trim($m[2]);
        return '/* ── ' . $label . ' ' . str_repeat('─', max(0, 40 - strlen($label))) . ' */';
    },
    $content
);

file_put_contents($file, $content);
echo "Done. Size: " . strlen($content) . "\n";

// Verify no more &#8211; in CSS comments
$lines = explode("\n", $content);
$found = 0;
foreach ($lines as $i => $line) {
    if (strpos($line, '&#8211;') !== false && strpos($line, '/*') !== false) {
        echo "Still broken line " . ($i+1) . ": " . trim($line) . "\n";
        $found++;
    }
}
if (!$found) echo "All CSS comments clean!\n";
