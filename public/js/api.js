/**
 * API client — all fetch calls to the PHP backend.
 */
const API_BASE = resolveProjectRoot() + '/api';

async function request(method, endpoint, body = null) {
  const opts = { method, credentials: 'include' };
  if (body instanceof FormData) {
    opts.body = body;
  } else if (body) {
    opts.headers = { 'Content-Type': 'application/json' };
    opts.body = JSON.stringify(body);
  } else {
    opts.headers = { 'Content-Type': 'application/json' };
  }
  const res  = await fetch(`${API_BASE}/${endpoint}`, opts);
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || data.message || 'Request failed');
  return data;
}

const api = {
  // ── Products ────────────────────────────────────────────────────────────────
  getProducts:      ()       => request('GET',    'products'),
  getProduct:       (id)     => request('GET',    `products/${id}`),
  getProductsByPo:  (poId)   => request('GET',    `products?po_id=${poId}`),
  getProductsByName:(name)   => request('GET',    `products?name=${encodeURIComponent(name)}`),
  getLowStock:      ()       => request('GET',    'products?low_stock=1'),
  createProduct:    (data)   => request('POST',   'products', data),
  updateProduct:    (id, d)  => {
    if (d instanceof FormData) {
      d.append('_method', 'PUT');
      return request('POST', `products/${id}`, d);
    }
    return request('PUT', `products/${id}`, d);
  },
  deleteProduct:    (id)     => request('DELETE', `products/${id}`),

  // ── Suppliers ────────────────────────────────────────────────────────────────
  getSuppliers:     (params) => request('GET',    'suppliers' + (params ? '?' + new URLSearchParams(params) : '')),
  getSupplier:      (id)     => request('GET',    `suppliers/${id}`),
  createSupplier:   (data)   => request('POST',   'suppliers', data),
  updateSupplier:   (id, d)  => request('PUT',    `suppliers/${id}`, d),
  deleteSupplier:   (id)     => request('DELETE', `suppliers/${id}`),

  // ── Purchase Orders ──────────────────────────────────────────────────────────
  getPurchaseOrders:           (params) => request('GET',    'purchase_orders' + (params ? '?' + new URLSearchParams(params) : '')),
  getPurchaseOrdersBySupplier: (suppId) => request('GET',    `purchase_orders?supplier_id=${suppId}`),
  getPurchaseOrder:            (id)     => request('GET',    `purchase_orders/${id}`),
  getPendingPurchaseOrders:    ()       => request('GET',    'purchase_orders?status=pending_receive'),
  markForReceive:              (id)     => request('POST',   `purchase_orders/${id}?action=mark_receive`, {}),
  receivePurchaseOrder:        (id, serials, locationId) => request('POST', `purchase_orders/${id}?action=receive`, { serials: serials || {}, location_id: locationId || null }),
  partialReceivePO:            (id, serials, locationId) => request('POST', `purchase_orders/${id}?action=partial_receive`, { serials: serials || {}, location_id: locationId || null }),
  generatePoNumber:            ()       => request('GET',    'purchase_orders?generate_number=1'),
  getStockReceived:            (days=7, locationId=null) => request('GET', `purchase_orders?stock=1&days=${days}${locationId ? '&location_id=' + locationId : ''}`),
  getStockReceivedByCategory:  (days=7, locationId=null) => request('GET', `purchase_orders?cat_stock=1&days=${days}${locationId ? '&location_id=' + locationId : ''}`),
  getDeployedByCategory:       (days=7, locationId=null) => request('GET', `assignments?cat_deployed=1&days=${days}${locationId ? '&location_id=' + locationId : ''}`),
  createPurchaseOrder:         (data)   => request('POST',   'purchase_orders', data),
  updatePurchaseOrder:         (id, d)  => request('PUT',    `purchase_orders/${id}`, d),
  deletePurchaseOrder:         (id)     => request('DELETE', `purchase_orders/${id}`),

  // ── Categories ───────────────────────────────────────────────────────────────
  getCategories:    ()       => request('GET',    'categories'),
  createCategory:   (data)   => request('POST',   'categories', data),
  updateCategory:   (id, d)  => request('PUT',    `categories/${id}`, d),
  deleteCategory:   (id)     => request('DELETE', `categories/${id}`),

  // ── Damages / Issues ─────────────────────────────────────────────────────────
  getDamages:           ()       => request('GET',    'damages'),
  getDamagesByCategory: (catId)  => request('GET',    `damages?category_id=${catId}`),
  createDamage:         (data)   => request('POST',   'damages', data),
  updateDamage:         (id, d)  => request('PUT',    `damages/${id}`, d),
  deleteDamage:         (id)     => request('DELETE', `damages/${id}`),

  // ── Audit Log ────────────────────────────────────────────────────────────────
  getAuditLogs:   (params) => request('GET', 'audit_logs' + (params ? '?' + new URLSearchParams(params) : '')),
  getAuditUsers:  ()       => request('GET', 'audit_logs?users=1'),

  // ── Locations ────────────────────────────────────────────────────────────────
  getLocations:     ()       => request('GET',    'locations'),
  createLocation:   (data)   => request('POST',   'locations', data),
  updateLocation:   (id, d)  => request('PUT',    `locations/${id}`, d),
  deleteLocation:   (id)     => request('DELETE', `locations/${id}`),
  getAssignments:          ()       => request('GET',  'assignments'),
  getActiveAssignments:    ()       => request('GET',  'assignments?active=1'),
  getAssignmentsByProduct: (pid)    => request('GET',  `assignments?product_id=${pid}`),
  getAssignmentsByAssignee:(name)   => request('GET',  `assignments?assignee=${encodeURIComponent(name)}`),
  getAssignmentStats:      ()       => request('GET',  'assignments?stats=1'),
  getRecentActivity:       (n = 10) => request('GET',  `assignments?recent=1&limit=${n}`),
  getDailyAssignments:     (days=7, locationId=null) => request('GET',  `assignments?daily=1&days=${days}${locationId ? '&location_id=' + locationId : ''}`),
  createAssignment:        (data)   => request('POST', 'assignments', data),
  updateAssignment:        (id, d)  => request('PUT',  `assignments/${id}`, d),
  returnAsset:             (id)     => request('POST', `assignments/${id}?action=return`, {}),
  deleteAssignment:        (id)     => request('DELETE',`assignments/${id}`),

  // ── Approvals ─────────────────────────────────────────────────────────────
  getApprovals:        (params) => request('GET',  'approvals' + (params ? '?' + new URLSearchParams(params) : '')),
  getPendingCount:     ()       => request('GET',  'approvals?pending=1'),
  getApproval:         (id)     => request('GET',  `approvals/${id}`),
  submitApproval:      (data)   => request('POST', 'approvals', data),
  reviewApproval:      (id, d)  => request('PUT',  `approvals/${id}`, d),
  cancelApproval:      (id)     => request('DELETE', `approvals/${id}`),
  confirmApproval:     (id)     => request('POST', `approvals/${id}?action=confirm`, {}),

  // ── Notifications ──────────────────────────────────────────────────────────
  getNotifications:    ()       => request('GET', 'notifications'),
  getUnreadCount:      ()       => request('GET', 'notifications?unread=1'),
  markNotifRead:       (id)     => request('PUT', `notifications/${id}`, {}),
  markAllNotifsRead:   ()       => request('PUT', 'notifications?all=1', {}),
  clearAllNotifs:      ()       => request('DELETE', 'notifications?all=1'),

  // ── Employees ─────────────────────────────────────────────────────────────
  getEmployees:       (station) => request('GET', 'employees' + (station ? '?station=' + encodeURIComponent(station) : '')),
  getEmployeeStations:()        => request('GET', 'employees?stations=1'),
  createEmployee:     (data)    => request('POST', 'employees', data),
  updateEmployee:     (id, d)   => request('PUT',  `employees/${id}`, d),
  deleteEmployee:     (id)      => request('DELETE',`employees/${id}`),
  importEmployees:    (file)    => {
    const fd = new FormData();
    fd.append('file', file);
    return request('POST', 'employees?action=import', fd);
  },

  // ── Team Structure ────────────────────────────────────────────────────────
  getTeamStructure:      ()              => request('GET',    'team_structure'),
  getTeamByUser:         (userId)        => request('GET',    `team_structure?user_id=${userId}`),
  getAssignedEmployeeIds:()              => request('GET',    'team_structure?unassigned=1'),
  assignAgents:          (userId, empIds)=> request('POST',   'team_structure', { user_id: userId, employee_ids: empIds }),
  unassignAgent:         (rowId)         => request('DELETE', `team_structure/${rowId}`),
  clearUserTeam:         (userId)        => request('DELETE', `team_structure?user_id=${userId}`),

  async getAssignees() {
    // Fetch all assignments to keep the person list stable even when they have 0 active assets
    const [allRes, activeRes] = await Promise.all([
      request('GET', 'assignments'),
      request('GET', 'assignments?active=1'),
    ]);
    const all    = allRes.data    || [];
    const active = activeRes.data || [];

    const _station = (a) => {
      let station = a.location_name || a.station || '';
      if (!station && a.notes) {
        const m = a.notes.match(/^Station:\s*(.+)/i);
        if (m) station = m[1].trim();
      }
      return station;
    };

    const map = new Map();

    for (const a of all) {
      const key = a.assignee_name;
      if (map.has(key)) continue;
      map.set(key, { name: a.assignee_name, station: _station(a), assets: [] });
    }

    for (const a of active) {
      const key = a.assignee_name;
      const station = _station(a);
      if (!map.has(key)) map.set(key, { name: a.assignee_name, station, assets: [] });
      if (station && !map.get(key).station) map.get(key).station = station;
      map.get(key).assets.push(a);
    }

    return Array.from(map.values()).sort((a, b) => a.name.localeCompare(b.name));
  },
};

// Expose for sidebar badge polling and other scripts that use window.api
window.api = api;
