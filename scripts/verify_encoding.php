<?php
$files = ['public/damages.html', 'public/index.html'];
foreach ($files as $f) {
    $t = file_get_contents(__DIR__ . '/../' . $f);
    echo "$f:\n";

    // Check stat-open placeholder
    $i = strpos($t, 'stat-open">');
    if ($i !== false) {
        $bytes = bin2hex(substr($t, $i + 11, 6));
        echo "  stat-open bytes: $bytes\n";
        // E2 80 94 = — correct
        // 3c2f = </  means empty (already replaced with nothing)
    }

    // Check close button
    $j = strpos($t, 'closeModal()">');
    if ($j !== false) {
        $bytes = bin2hex(substr($t, $j + 14, 4));
        echo "  close btn bytes: $bytes (expect c397 = ×)\n";
    }

    // Check refresh button (index only)
    $k = strpos($t, 'Refresh');
    if ($k !== false) {
        $bytes = bin2hex(substr($t, $k - 5, 8));
        echo "  refresh bytes: $bytes (expect e286bb = ↻)\n";
    }

    // Check ✅ in empty state
    $m = strpos($t, 'empty-icon">');
    if ($m !== false) {
        $bytes = bin2hex(substr($t, $m + 12, 6));
        echo "  empty-icon bytes: $bytes (expect e29c85 = ✅ or 26 = &)\n";
    }
    echo "\n";
}
