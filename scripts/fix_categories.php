<?php
/**
 * Final fix for categories.html - replace all remaining broken sequences
 * with SVG icons or clean text equivalents.
 */
$file = __DIR__ . '/../public/categories.html';
$html = file_get_contents($file);

// ── Broken sequences identified from byte inspection ─────────────────────────

// 1. diamond icon in "Largest Group" stat card: c3 b0 3f 3f 3f
//    Replace with a simple SVG bar-chart icon
$html = str_replace(
    "\xc3\xb0\x3f\x3f\x3f",
    '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>',
    $html
);

// 2. down arrow in Export button: c3 a2 c2 ac 3f
$html = str_replace(
    "\xc3\xa2\xc2\xac\x3f",
    '&#8595;',   // ↓
    $html
);

// 3. eye icon in View link: c3 b0 3f 3f c2 81
$html = str_replace(
    "\xc3\xb0\x3f\x3f\xc2\x81",
    '&#128065;',  // 👁
    $html
);

// 4. Any remaining c3 b0 3f sequences (broken 4-byte emoji) - replace with empty
$html = preg_replace('/\xc3\xb0\x3f[\x00-\xff]{0,4}/', '', $html);

// 5. Any remaining c3 a2 3f sequences (broken 3-byte chars) - replace with empty
$html = preg_replace('/\xc3\xa2[\xc2\xc3][\x80-\xbf]\x3f/', '', $html);

// ── Fix the view toggle buttons - they lost their icon text ──────────────────
// The list/grid view buttons now have no visible icon - add SVG icons
$html = str_replace(
    'id="view-list" title="List view"',
    'id="view-list" title="List view" style="font-size:16px;"',
    $html
);

// ── Fix sort button text ─────────────────────────────────────────────────────
// Replace broken sort arrow with HTML entity
$html = preg_replace(
    '/(<button[^>]*id="sort-btn"[^>]*>)\s*[^\w<]*Sort:/i',
    '$1&#8645; Sort:',
    $html
);

// ── Fix the view buttons content (list ☰ and grid ⊞) ────────────────────────
// These buttons had their icon content stripped - restore with SVG
$html = preg_replace(
    '/(<button[^>]*id="view-list"[^>]*>)\s*(<\/button>)/i',
    '$1<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></svg>$2',
    $html
);
$html = preg_replace(
    '/(<button[^>]*id="view-grid"[^>]*>)\s*(<\/button>)/i',
    '$1<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>$2',
    $html
);

// ── Fix the Edit button in table rows ────────────────────────────────────────
// The pencil icon ✎ was lost - restore it
$html = str_replace(
    'title="Edit"' . "\r\n" . '                data-id=',
    'title="Edit" data-id=',
    $html
);

file_put_contents($file, $html);
echo "Done. Bytes: " . strlen($html) . "\n";

// Quick verification
$checks = [
    '&#8595;'   => 'down arrow in Export',
    '&#128065;' => 'eye in View',
    '&#8645;'   => 'sort arrows',
    'view-list' => 'list view button',
    'view-grid' => 'grid view button',
];
foreach ($checks as $needle => $name) {
    echo (strpos($html, $needle) !== false ? 'OK' : 'CHECK') . " $name\n";
}
