<?php
$f = file_get_contents(__DIR__ . '/../public/items.html');

// Add supplier + quantity after the view-description line in viewItem()
$marker = "document.getElementById('image-modal').classList.add('open');";
$pos = strpos($f, $marker);
if ($pos !== false) {
    $insert = "    const viewSup = document.getElementById('view-supplier');\n    if (viewSup) viewSup.textContent = p.supplier_name || '\u2013';\n    const viewQty = document.getElementById('view-quantity');\n    if (viewQty) viewQty.textContent = p.quantity ?? 0;\n    ";
    $f = substr($f, 0, $pos) . $insert . substr($f, $pos);
    echo "viewItem supplier+qty added\n";
} else {
    echo "marker not found\n";
}

file_put_contents(__DIR__ . '/../public/items.html', $f);
echo "Done. File size: " . strlen($f) . "\n";
