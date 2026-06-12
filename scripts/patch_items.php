<?php
$f = file_get_contents(__DIR__ . '/../public/items.html');

// 1. Replace thead: add Supplier + Qty columns, remove NEW badge from Assigned To
$pos = strpos($f, 'col-assigned');
if ($pos !== false) {
    // Find the <th class="col-assigned"> block start
    $thStart = strrpos(substr($f, 0, $pos), '<th');
    // Find the closing </th> after Actions
    $actionsEnd = strpos($f, '</th>', strpos($f, 'Actions', $pos)) + 5;
    $original = substr($f, $thStart, $actionsEnd - $thStart);
    $replacement = '<th>Supplier</th>
              <th style="text-align:center;">Qty</th>
              <th class="col-assigned">
                <span style="display:inline-flex;align-items:center;gap:6px;">
                  &#128100; Assigned To
                </span>
              </th>
              <th>Actions</th>';
    $f = substr($f, 0, $thStart) . $replacement . substr($f, $actionsEnd);
    echo "Header replaced\n";
} else {
    echo "col-assigned not found\n";
}

// 2. Add supplier_id select to the form (after category_id group)
$catGroupEnd = strpos($f, '</div>', strpos($f, 'id="cat-group"')) + 6;
$supplierField = '
          <div class="form-group" id="supplier-group">
            <label for="item-supplier">Supplier</label>
            <select id="item-supplier" name="supplier_id">
              <option value="">&#8212; None &#8212;</option>
            </select>
          </div>';
$f = substr($f, 0, $catGroupEnd) . $supplierField . substr($f, $catGroupEnd);
echo "Supplier field added\n";

// 3. Show qty-group always (remove the display:none hiding logic) — done in JS
// 4. Add Supplier + Qty to the view modal detail table
$viewDescEnd = strpos($f, '</div>', strpos($f, 'id="view-description"')) + 6;
$viewRows = '
        <div class="view-detail-row">
          <div class="view-detail-key">Supplier</div>
          <div class="view-detail-val" id="view-supplier"></div>
        </div>
        <div class="view-detail-row">
          <div class="view-detail-key">Quantity</div>
          <div class="view-detail-val" id="view-quantity"></div>
        </div>';
$f = substr($f, 0, $viewDescEnd) . $viewRows . substr($f, $viewDescEnd);
echo "View rows added\n";

file_put_contents(__DIR__ . '/../public/items.html', $f);
echo "Done. File size: " . strlen($f) . "\n";
