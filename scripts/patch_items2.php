<?php
$f = file_get_contents(__DIR__ . '/../public/items.html');

// 1. Add Supplier + Qty cells in renderTable rows (after brand_model td, before col-assigned td)
// Find the brand_model td and col-assigned td pattern
$brandTd = '<td style="color:var(--text);font-size:14px;">${esc(p.brand_model || \'';
$pos = strpos($f, $brandTd);
if ($pos !== false) {
    // Find end of the sku td
    $skuEnd = strpos($f, '</td>', strpos($f, 'skuHtml', $pos)) + 5;
    // Find start of col-assigned td
    $colAssignedStart = strpos($f, '<td class="col-assigned">', $skuEnd);
    // Replace the gap between skuEnd and colAssignedStart
    $insert = "\n        <td style=\"font-size:13px;color:var(--muted2);\">\${esc(p.supplier_name || '\u2013')}</td>\n        <td style=\"text-align:center;\">\n          <span style=\"display:inline-flex;align-items:center;justify-content:center;min-width:28px;height:28px;border-radius:20px;background:var(--bg3);border:1px solid var(--border2);font-size:12px;font-weight:700;color:var(--muted2);font-family:'DM Mono',monospace;padding:0 8px;\">\${p.quantity ?? 0}</span>\n        </td>\n        ";
    $f = substr($f, 0, $skuEnd) . $insert . substr($f, $colAssignedStart);
    echo "Row cells inserted\n";
} else {
    echo "brand_model td not found\n";
}

// 2. Populate supplier dropdown in populateDropdowns()
// Find the closing of populateDropdowns function — look for the last catSel.innerHTML = html; block
$pdEnd = strpos($f, 'catSel.innerHTML = html;', strpos($f, 'function populateDropdowns'));
// Find the last occurrence inside populateDropdowns
$lastCatHtml = $pdEnd;
while (($next = strpos($f, 'catSel.innerHTML = html;', $lastCatHtml + 1)) !== false && $next < strpos($f, 'function closeModal', $pdEnd)) {
    $lastCatHtml = $next;
}
// Insert supplier population after the last catSel.innerHTML = html; line
$afterLastCat = strpos($f, "\n", $lastCatHtml) + 1;
$supplierPopulate = "
    // Populate supplier dropdown
    try {
      const supRes = await api.getSuppliers();
      const supSel = document.getElementById('item-supplier');
      if (supSel) {
        supSel.innerHTML = '<option value=\"\">\u2014 None \u2014</option>' +
          (supRes.data || []).map(s => '<option value=\"' + s.id + '\">' + esc(s.name) + '</option>').join('');
      }
    } catch (_) {}
";
$f = substr($f, 0, $afterLastCat) . $supplierPopulate . substr($f, $afterLastCat);
echo "Supplier populate added\n";

// 3. Set supplier_id value when editing (in openModal after form.category_id.value = ...)
$catIdSet = "form.category_id.value = p.category_id || '';";
$pos = strpos($f, $catIdSet);
if ($pos !== false) {
    $afterCatId = strpos($f, "\n", $pos) + 1;
    $supplierSet = "        const supSel = document.getElementById('item-supplier');\n        if (supSel) supSel.value = p.supplier_id || '';\n";
    $f = substr($f, 0, $afterCatId) . $supplierSet . substr($f, $afterCatId);
    echo "Supplier value set in openModal\n";
} else {
    echo "category_id set line not found\n";
}

// 4. Append supplier_id to FormData in submitForm
$fdCatLine = "fd.append('category_id', catId || '');";
$pos = strpos($f, $fdCatLine);
if ($pos !== false) {
    $afterFdCat = strpos($f, "\n", $pos) + 1;
    $fdSupplier = "    fd.append('supplier_id', document.getElementById('item-supplier') ? document.getElementById('item-supplier').value : '');\n    fd.append('quantity',    form.quantity.value);\n";
    $f = substr($f, 0, $afterFdCat) . $fdSupplier . substr($f, $afterFdCat);
    echo "supplier_id + quantity appended to FormData\n";
} else {
    echo "fd.append category_id not found\n";
}

// 5. Show qty-group in populateDropdowns (remove the display:none)
// Replace all qtyGrp.style.display = 'none'; with qtyGrp.style.display = '';
$f = str_replace("qtyGrp.style.display   = 'none';", "qtyGrp.style.display   = '';", $f);
$f = str_replace("qtyGrp.style.display    = 'none';", "qtyGrp.style.display   = '';", $f);
echo "qty-group always shown\n";

// 6. Add supplier + quantity to viewItem()
$viewDescLine = "document.getElementById('view-description').textContent = p.description || '\u2013';";
$pos = strpos($f, $viewDescLine);
if ($pos !== false) {
    $afterViewDesc = strpos($f, "\n", $pos) + 1;
    $viewExtra = "    const viewSup = document.getElementById('view-supplier');\n    if (viewSup) viewSup.textContent = p.supplier_name || '\u2013';\n    const viewQty = document.getElementById('view-quantity');\n    if (viewQty) viewQty.textContent = p.quantity ?? 0;\n";
    $f = substr($f, 0, $afterViewDesc) . $viewExtra . substr($f, $afterViewDesc);
    echo "viewItem supplier+qty added\n";
} else {
    echo "view-description line not found\n";
}

file_put_contents(__DIR__ . '/../public/items.html', $f);
echo "Done. File size: " . strlen($f) . "\n";
