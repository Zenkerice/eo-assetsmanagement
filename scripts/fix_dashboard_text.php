<?php
$file = __DIR__ . '/../public/index.html';
$content = file_get_contents($file);
$content = str_replace('Dashboard â€" Inventory System', 'Dashboard &ndash; Inventory System', $content);
$content = str_replace('Loadingâ€¦', 'Loading&hellip;', $content);
file_put_contents($file, $content);
echo "Done\n";
