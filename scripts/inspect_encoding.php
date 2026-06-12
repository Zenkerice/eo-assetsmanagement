<?php
$file = __DIR__ . '/../public/categories.html';
$html = file_get_contents($file);

// Find and dump bytes around specific known broken strings
$targets = [
    'hexagon'     => 'â¬¡',
    'diamond'     => 'â—ˆ',
    'grid'        => 'âŠž',
    'hamburger'   => 'â˜°',
    'pencil'      => 'âœŽ',
    'sort'        => 'â‡…',
    'down arrow'  => 'â¬‡',
    'bar chart'   => 'ðŸ"Š',
    'circle'      => 'â—‹',
    'eye'         => "ðŸ'",
];

// Instead, search for known surrounding context
$contexts = [
    'hexagon'    => 'Total Assets',
    'diamond'    => 'Largest Group',
    'grid'       => 'view-grid',
    'hamburger'  => 'view-list',
    'pencil'     => 'title="Edit"',
    'sort'       => 'sort-btn',
    'down arrow' => 'exportCSV',
    'bar chart'  => 'stat-largest',
    'circle'     => 'stat-empty',
    'eye'        => 'View</a>',
];

foreach ($contexts as $name => $ctx) {
    $pos = strpos($html, $ctx);
    if ($pos === false) { echo "NOT FOUND: $ctx\n"; continue; }
    // Show 40 bytes before the context
    $start = max(0, $pos - 40);
    $snip  = substr($html, $start, 80);
    echo "\n=== $name (near '$ctx') ===\n";
    echo "Text: $snip\n";
    echo "Hex:  ";
    for ($i = 0; $i < strlen($snip); $i++) {
        echo sprintf('%02x ', ord($snip[$i]));
    }
    echo "\n";
}
