<?php
$file = __DIR__ . '/../public/categories.html';
$content = file_get_contents($file);

$content = str_replace('â?¦',        '&hellip;',  $content);
$content = str_replace('Loadingâ?¦', 'Loading&hellip;', $content);

file_put_contents($file, $content);
echo "Done. Size: " . strlen($content) . "\n";
echo (strpos($content, '&hellip;') !== false ? "OK hellip\n" : "MISSING hellip\n");
