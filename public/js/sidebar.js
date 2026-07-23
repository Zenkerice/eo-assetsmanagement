/**
 * Sidebar — renders immediately from cache, validates auth async.
 * Call window.refreshSidebar() to re-render after category changes.
 */

const _sidebarPage   = window.location.pathname.split('/').pop() || 'index.html';
const _sidebarParams = new URLSearchParams(window.location.search);
const _activeCatId   = _sidebarParams.get('category_id') ? parseInt(_sidebarParams.get('category_id')) : null;

const _isHome    = ['index.html', 'dashboard.html', ''].includes(_sidebarPage);
const _isItems   = _sidebarPage === 'items.html';
const _isCats    = _sidebarPage === 'categories.html';
const _isDamages = _sidebarPage === 'damages.html';
const _isUsers   = _sidebarPage === 'users.html';
const _isAssignees = _sidebarPage === 'assignees2.html';
const _isTeamStructure = _sidebarPage === 'team-structure.html';
const _isSuppliers = _sidebarPage === 'suppliers.html';
const _isReceive   = _sidebarPage === 'receive.html';
const _isAudit     = _sidebarPage === 'audit.html';
const _isSettings  = _sidebarPage === 'settings.html';
const _isImport    = _sidebarPage === 'import.html';
const _isApprovals   = _sidebarPage === 'approvals.html';
const _isCubicleMap  = _sidebarPage === 'cubicle-map.html';
const _folderOpen  = _isCats || (_isItems && _activeCatId);

/* ── Session cache helpers ──────────────────────────────────────────────────
   Store the last known user + categories so the sidebar can render
   synchronously on every page load — eliminating the auth-wait blink.
   The real auth check still runs async; if it fails the cache is cleared
   and the user is redirected to login.
─────────────────────────────────────────────────────────────────────────── */
const _CACHE_USER = '_sb_user';
const _CACHE_CATS = '_sb_cats';

function _cacheWrite(user, cats) {
  try {
    sessionStorage.setItem(_CACHE_USER, JSON.stringify(user));
    sessionStorage.setItem(_CACHE_CATS, JSON.stringify(cats));
  } catch (_) {}
}

function _cacheRead() {
  try {
    const u = sessionStorage.getItem(_CACHE_USER);
    const c = sessionStorage.getItem(_CACHE_CATS);
    if (!u) return null;
    return { user: JSON.parse(u), cats: c ? JSON.parse(c) : [] };
  } catch (_) { return null; }
}

function _cacheClear() {
  try {
    sessionStorage.removeItem(_CACHE_USER);
    sessionStorage.removeItem(_CACHE_CATS);
  } catch (_) {}
}

/* ── Instant render from cache (synchronous, before auth) ─────────────── */
(function _instantRender() {
  const cached = _cacheRead();
  if (!cached) return;                         // first visit — wait for auth
  if (cached.user.role === 'staff' || cached.user.role === 'viewer' || cached.user.role === 'manager') return; // no sidebar for staff/viewer/manager

  // Temporarily set currentUser so _renderSidebar can use it
  if (typeof auth !== 'undefined' && !auth.currentUser) {
    auth.currentUser = cached.user;
  }
  _renderSidebar(cached.cats);
  // Mark ready immediately — sidebar is fully populated from cache
  const aside = document.querySelector('aside.sidebar');
  if (aside) aside.classList.add('ready');
})();

function _renderSidebar(categories) {
  const asideEl = document.querySelector('aside.sidebar');
  if (!asideEl) return;
  const catLinks = categories.map(c => `
    <a href="items.html?category_id=${c.id}"
       class="nav-item nav-cat-link ${_activeCatId === c.id ? 'active' : ''}"
       data-id="${c.id}">
      <span class="nav-dot"></span>
      <span>${esc(c.name)}</span>
    </a>`).join('');

  const emptyHint = categories.length === 0
    ? `<span class="nav-item nav-empty">No categories yet</span>`
    : '';

  const openIssuesBadge = `<span class="nav-badge" id="nav-badge"></span>`;

  // Current user info (populated by auth.js if available)
  const user        = (typeof auth !== 'undefined' && auth.currentUser) ? auth.currentUser : null;
  const userName    = user ? esc(user.name) : '';
  const roleLabels  = { admin: 'Admin', manager: 'Manager', staff: 'Staff', viewer: 'Supervisor' };
  const userRole    = user ? (roleLabels[user.role] || user.role) : '';
  const userInitial = user ? user.name.charAt(0).toUpperCase() : '';
  const isAdmin      = user && user.role === 'admin';
  const isPrivileged = user && (user.role === 'admin' || user.role === 'manager');

  const adminLinks = isAdmin ? `
    <div class="nav-section">Admin</div>
    <a href="approvals.html" class="nav-item ${_isApprovals ? 'active' : ''}" data-label="Approvals">
      <span class="nav-icon"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg></span>
      <span>Approvals</span>
      <span class="nav-badge" id="nav-approval-badge"></span>
    </a>
    <a href="cubicle-map.html" class="nav-item ${_isCubicleMap ? 'active' : ''}" data-label="Cubicle Map">
      <span class="nav-icon"><svg viewBox="0 0 24 24"><rect x="2" y="2" width="9" height="9" rx="1"/><rect x="13" y="2" width="9" height="9" rx="1"/><rect x="2" y="13" width="9" height="9" rx="1"/><rect x="13" y="13" width="9" height="4" rx="1"/><line x1="13" y1="20" x2="22" y2="20"/></svg></span>
      <span>Cubicle Map</span>
    </a>
    <a href="users.html" class="nav-item ${_isUsers ? 'active' : ''}" data-label="Users">
      <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></span>
      <span>Users</span>
    </a>` : '';

  asideEl.innerHTML = `
    <div class="sidebar-brand">
      <a href="index.html" class="brand-wordmark">
        <img src="logo.png" alt="EmpireOne" class="sidebar-logo" />
      </a>
      <button class="sb-toggle-btn" onclick="_sbToggle()" aria-label="Toggle sidebar" title="Collapse sidebar">
        <span class="sb-toggle-line"></span>
        <span class="sb-toggle-line"></span>
        <span class="sb-toggle-line"></span>
      </button>
    </div>

    <nav class="sidebar-nav">
      <div class="nav-section">Overview</div>

      <a href="index.html" class="nav-item ${_isHome ? 'active' : ''}" data-label="Dashboard">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg></span>
        <span>Dashboard</span>
      </a>

      <div class="nav-section">Manage</div>

      <a href="items.html" class="nav-item ${_isItems && !_activeCatId ? 'active' : ''}" data-label="Assets">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg></span>
        <span>Assets</span>
      </a>

      <div class="sidebar-folder">
        <div class="sidebar-folder-header nav-item ${_folderOpen ? 'open' : ''}"
             onclick="_toggleSidebarFolder(this)">
          <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/></svg></span>
          <span>Categories</span>
          <span class="folder-arrow ${_folderOpen ? 'open' : ''}">›</span>
        </div>
        <div class="sidebar-folder-body ${_folderOpen ? 'open' : ''}">
          <a href="categories.html" class="nav-item nav-sub ${_isCats ? 'active' : ''}">
            <span class="nav-dot"></span>
            <span>Manage categories</span>
          </a>
          ${catLinks}
          ${emptyHint}
        </div>
      </div>

      <a href="damages.html" class="nav-item ${_isDamages ? 'active' : ''}" data-label="Asset Status">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg></span>
        <span>Asset Status</span>
        ${openIssuesBadge}
      </a>

      <a href="team-structure.html" class="nav-item ${_isTeamStructure ? 'active' : ''}" data-label="Team Structure">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><rect x="2" y="3" width="6" height="5" rx="1"/><rect x="16" y="3" width="6" height="5" rx="1"/><rect x="9" y="16" width="6" height="5" rx="1"/><path d="M5 8v4h14V8"/><line x1="12" y1="12" x2="12" y2="16"/></svg></span>
        <span>Team Structure</span>
      </a>

      <a href="accountability.html" class="nav-item ${_sidebarPage === 'accountability.html' ? 'active' : ''}" data-label="Accountability">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg></span>
        <span>Accountability</span>
      </a>
      <a href="suppliers.html" class="nav-item ${_isSuppliers ? 'active' : ''}" data-label="Suppliers">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13" rx="1"/><path d="M16 8h4l3 5v3h-7V8z"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg></span>
        <span>Suppliers</span>
      </a>

      ${isPrivileged ? `
      <a href="receive.html" class="nav-item ${_isReceive ? 'active' : ''}" data-label="Receive">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg></span>
        <span>Receive</span>
        <span class="nav-badge" id="nav-po-badge"></span>
      </a>` : ''}

      ${adminLinks}

      <div class="nav-section">Preferences</div>
      <a href="audit.html" class="nav-item ${_isAudit ? 'active' : ''}" data-label="Audit Log">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="8" y1="13" x2="16" y2="13"/><line x1="8" y1="17" x2="16" y2="17"/><line x1="8" y1="9" x2="10" y2="9"/></svg></span>
        <span>Audit Log</span>
      </a>
      <a href="import.html" class="nav-item ${_isImport ? 'active' : ''}" data-label="Import">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg></span>
        <span>Import</span>
      </a>
      <a href="settings.html" class="nav-item ${_isSettings ? 'active' : ''}" data-label="Settings">
        <span class="nav-icon"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg></span>
        <span>Settings</span>
      </a>
    </nav>

    <div class="sidebar-footer">
      <div class="user-row">
        <div class="avatar">${userInitial}</div>
        <div class="user-info">
          <div class="user-name">${userName}</div>
          <div class="user-role">${userRole}</div>
        </div>
        <button class="theme-toggle-btn" id="sidebar-theme-btn" title="Toggle theme" onclick="_sidebarToggleTheme()"><svg viewBox="0 0 24 24" width="17" height="17" stroke="currentColor" fill="none" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg></button>
        <button class="logout-btn" title="Logout" onclick="_sidebarLogout()"><svg viewBox="0 0 24 24" width="17" height="17" stroke="currentColor" fill="none" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M18.36 6.64a9 9 0 1 1-12.73 0"/><line x1="12" y1="2" x2="12" y2="12"/></svg></button>
      </div>
    </div>
  `;

  // Populate the open issues badge if api is available
  if (window.api && window.api.getDamages) {
    api.getDamages()
      .then(res => {
        const count = (res.data || []).filter(d => d.status === 'damaged').length;
        const badge = document.getElementById('nav-badge');
        if (badge) badge.textContent = count > 0 ? count : '';
      })
      .catch(() => {});
  }

  // Populate pending PO badge — admin and manager
  if (isPrivileged && window.api && window.api.getPendingPurchaseOrders) {
    api.getPendingPurchaseOrders()
      .then(res => {
        const count = (res.data || []).length;
        const badge = document.getElementById('nav-po-badge');
        if (badge) badge.textContent = count > 0 ? count : '';
      })
      .catch(() => {});
  }

  // Populate pending approvals badge (admin only)
  if (window.api && window.api.getPendingCount) {
    api.getPendingCount()
      .then(res => {
        const count = res.data?.count || 0;
        const badge = document.getElementById('nav-approval-badge');
        if (badge) badge.textContent = count > 0 ? count : '';
      })
      .catch(() => {});
  }

  // Reveal sidebar only once we have real user data — prevents placeholder flash
  if (user) {
    asideEl.classList.add('ready');
  }

  // Sync theme button icon now that the button exists in the DOM
  _syncThemeBtn();

}

// Inject global light-mode content overrides — runs after inline <style> blocks so always wins
if (!document.getElementById('_global-light-styles')) {
  const gs = document.createElement('style');
  gs.id = '_global-light-styles';
  gs.textContent = `
    /* ── Light mode headings: dark blue ── */
    html[data-theme="light"] h1,
    html[data-theme="light"] h2,
    html[data-theme="light"] h3,
    html[data-theme="light"] h4,
    html[data-theme="light"] .topbar h1,
    html[data-theme="light"] .topbar-title,
    html[data-theme="light"] .section-heading h2,
    html[data-theme="light"] .chart-card-header h3,
    html[data-theme="light"] .card-title,
    html[data-theme="light"] .section-title,
    html[data-theme="light"] .detail-name,
    html[data-theme="light"] .panel-header h2,
    html[data-theme="light"] .stat-value { color: #1e40af !important; }
    html[data-theme="light"] body,
    html[data-theme="light"] .main { background: #f4f6fb !important; }
    /* Light mode: make cards pop */
    html[data-theme="light"] .stat-card,
    html[data-theme="light"] .chart-card,
    html[data-theme="light"] .cat-card {
      background: #ffffff !important;
      border: 2px solid #93c5fd !important;
      box-shadow: 0 6px 24px rgba(37,99,235,0.18), 0 1px 4px rgba(37,99,235,0.10) !important;
    }
    html[data-theme="light"] .stat-card:hover,
    html[data-theme="light"] .chart-card:hover,
    html[data-theme="light"] .cat-card:hover {
      border-color: #3b82f6 !important;
      box-shadow: 0 12px 36px rgba(37,99,235,0.28), 0 2px 8px rgba(37,99,235,0.14) !important;
      transform: translateY(-3px);
    }

    /* ── Dark mode headings: bright blue ── */
    html[data-theme="dark"] h1,
    html[data-theme="dark"] h2,
    html[data-theme="dark"] h3,
    html[data-theme="dark"] h4,
    html[data-theme="dark"] .topbar h1,
    html[data-theme="dark"] .topbar-title,
    html[data-theme="dark"] .section-heading h2,
    html[data-theme="dark"] .chart-card-header h3,
    html[data-theme="dark"] .card-title,
    html[data-theme="dark"] .section-title,
    html[data-theme="dark"] .detail-name,
    html[data-theme="dark"] .panel-header h2,
    html[data-theme="dark"] .stat-value { color: #60a5fa !important; }
  `;
  document.head.appendChild(gs);
}

// Inject sidebar CSS (only once)
if (!document.getElementById('_sidebar-styles-v3')) {
  // Remove any stale version
  ['_sidebar-styles', '_sidebar-styles-v2'].forEach(id => {
    const old = document.getElementById(id);
    if (old) old.remove();
  });
  const style = document.createElement('style');
  style.id = '_sidebar-styles-v3';
  style.textContent = `
    /* ── Sidebar entrance ── */
    @keyframes badgePop {
      0%   { transform: scale(0.4); opacity: 0; }
      70%  { transform: scale(1.2); opacity: 1; }
      100% { transform: scale(1);   opacity: 1; }
    }
    @keyframes activeGlow {
      0%, 100% { box-shadow: inset 3px 0 0 rgba(41,182,232,0.8); }
      50%       { box-shadow: inset 3px 0 0 rgba(41,182,232,1), 2px 0 12px rgba(41,182,232,0.25); }
    }

    /* ── Dark mode: deep navy sidebar ── */
    .sidebar {
      width: 260px;
      background: #0f2057;
      border-right: 1px solid rgba(255,255,255,0.06);
      display: flex;
      flex-direction: column;
      position: fixed;
      top: 0; left: 0; bottom: 0;
      z-index: 100;
    }
    /* Light mode: match page background */
    html[data-theme="light"] .sidebar {
      background: #f4f6fb !important;
      border-right: 1px solid #d0d8ee !important;
    }
    html[data-theme="light"] .sidebar-brand    { border-bottom: 1px solid rgba(0,0,0,0.08) !important; background: #ffffff !important; }
    html[data-theme="light"] .nav-section      { color: #7a8ab0 !important; }
    html[data-theme="light"] .nav-item         { color: #2d3a5e !important; }
    html[data-theme="light"] .nav-item:hover   { background: rgba(41,182,232,0.12) !important; color: #1a2a6e !important; }
    html[data-theme="light"] .nav-item.active  { background: rgba(41,182,232,0.18) !important; color: #1a2a6e !important; font-weight: 600; }
    html[data-theme="light"] .nav-item.active::before { background: #29b6e8 !important; }
    html[data-theme="light"] .folder-arrow     { color: #7a8ab0 !important; }
    html[data-theme="light"] .nav-empty        { color: #9aa0b2 !important; }
    html[data-theme="light"] .sidebar-footer   { border-top-color: #d0d8ee !important; background: #e8edf8 !important; }
    html[data-theme="light"] .user-name        { color: #1a2a6e !important; }
    html[data-theme="light"] .user-role        { color: #7a8ab0 !important; }
    html[data-theme="light"] .logout-btn       { color: #7a8ab0 !important; }
    html[data-theme="light"] .logout-btn:hover { background: rgba(244,91,105,0.15) !important; color: #f45b69 !important; }
    html[data-theme="light"] .theme-toggle-btn { color: #7a8ab0 !important; }
    html[data-theme="light"] .theme-toggle-btn:hover { background: rgba(41,182,232,0.12) !important; color: #1a2a6e !important; }
    html[data-theme="light"] .nav-badge        { background: #29b6e8 !important; color: #fff !important; }
    html[data-theme="light"] .sidebar-folder-body { background: rgba(0,0,0,0.04) !important; }
    html[data-theme="light"] .nav-dot          { background: #9aa0b2 !important; }
    html[data-theme="light"] .nav-item.active .nav-dot { background: #29b6e8 !important; }
    html[data-theme="light"] .sb-toggle-line   { background: #2d3a5e !important; }
    html[data-theme="light"] .avatar           { background: linear-gradient(135deg, #29b6e8, #1a3a8a) !important; }
    html[data-theme="light"] .nav-icon svg     { stroke: currentColor !important; }

    /* ── Brand ── */
    .sidebar-brand {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 18px 16px;
      border-bottom: 1px solid rgba(255,255,255,0.10);
      flex-shrink: 0;
      position: relative;
      height: 98px;
    }

    /* ── Sidebar collapse toggle button (hamburger ↔ X) ── */
    .sb-toggle-btn {
      position: absolute;
      right: 4px;
      top: 50%;
      transform: translateY(-50%);
      width: 36px;
      height: 36px;
      flex-shrink: 0;
      background: transparent;
      border: none;
      border-radius: 0;
      cursor: pointer;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 5px;
      padding: 0;
      transition: transform 0.2s cubic-bezier(0.34,1.56,0.64,1);
    }
    .sb-toggle-btn:hover {
      transform: translateY(-50%) scale(1.12);
    }
    .sb-toggle-btn:active {
      transform: translateY(-50%) scale(0.94);
    }
    html[data-theme="light"] .sb-toggle-btn {
      background: transparent;
      border: none;
    }

    /* The three lines */
    .sb-toggle-line {
      display: block;
      width: 18px;
      height: 3px;
      background: rgba(255,255,255,0.85);
      border-radius: 2px;
      transform-origin: center;
      transition: transform 0.35s cubic-bezier(0.4,0,0.2,1),
                  opacity   0.3s  cubic-bezier(0.4,0,0.2,1),
                  width     0.3s  cubic-bezier(0.4,0,0.2,1),
                  background 0.15s ease;
    }
    .sb-toggle-btn:hover .sb-toggle-line {
      background: #fff;
    }

    /* middle line */
    .sb-toggle-line:nth-child(2) {
      width: 12px;
      transition: transform 0.35s cubic-bezier(0.4,0,0.2,1),
                  opacity   0.2s  cubic-bezier(0.4,0,0.2,1),
                  width     0.3s  cubic-bezier(0.4,0,0.2,1),
                  background 0.15s ease;
    }
    .sb-toggle-btn:hover .sb-toggle-line:nth-child(2) {
      width: 18px;
    }

    /* X state when sidebar is expanded */
    aside.sidebar:not(.sb-collapsed) .sb-toggle-line:nth-child(1) {
      transform: translateY(7px) rotate(45deg);
      width: 18px;
    }
    aside.sidebar:not(.sb-collapsed) .sb-toggle-line:nth-child(2) {
      opacity: 0;
      width: 0;
      transform: scaleX(0);
    }
    aside.sidebar:not(.sb-collapsed) .sb-toggle-line:nth-child(3) {
      transform: translateY(-7px) rotate(-45deg);
      width: 18px;
    }
    .brand-wordmark {
      display: inline-flex;
      align-items: center;
      text-decoration: none;
      line-height: 1;
      gap: 0;
      transition: opacity 0.15s ease, transform 0.2s cubic-bezier(0.34,1.56,0.64,1);
    }
    .brand-wordmark:hover {
      opacity: 0.85;
      transform: scale(1.04);
    }
    .sidebar-logo {
      height: 52px;
      width: auto;
      display: block;
      mix-blend-mode: screen;
    }
    html[data-theme="light"] .sidebar-logo {
      mix-blend-mode: multiply;
    }
    .sidebar .brand-empire {
      font-family: 'DM Sans', sans-serif;
      font-size: 30px;
      font-weight: 800;
      letter-spacing: 0.5px;
      color: #ffffff;
      -webkit-text-stroke: 0.4px #ffffff;
    }
    .sidebar .brand-one {
      font-family: 'DM Sans', sans-serif;
      font-size: 30px;
      font-weight: 800;
      letter-spacing: 0.5px;
      color: #29b6e8;
      -webkit-text-stroke: 0.4px #29b6e8;
    }
    html[data-theme="light"] .sidebar .brand-empire {
      color: #ffffff !important;
      -webkit-text-stroke: 0.5px #ffffff !important;
    }
    html[data-theme="light"] .sidebar .brand-one {
      color: #29b6e8 !important;
      -webkit-text-stroke: 0.5px #29b6e8 !important;
    }

    /* ── Nav ── */
    .sidebar-nav {
      padding: 20px 14px;
      flex: 1;
      min-height: 0;
      overflow-y: auto;
    }
    .sidebar-nav::-webkit-scrollbar { width: 4px; }
    .sidebar-nav::-webkit-scrollbar-track { background: transparent; }
    .sidebar-nav::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.15); border-radius: 4px; }

    .nav-section {
      font-size: 11px;
      font-weight: 600;
      letter-spacing: 1.2px;
      text-transform: uppercase;
      color: rgba(255,255,255,0.38);
      padding: 0 8px;
      margin: 16px 0 6px;
    }
    .nav-section:first-child { margin-top: 0; }

    /* Nav items — staggered entrance + hover effects */
    .nav-item {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 11px 12px;
      border-radius: 8px;
      color: rgba(255,255,255,0.70);
      text-decoration: none;
      font-size: 15px;
      font-weight: 400;
      cursor: pointer;
      width: 100%;
      border: none;
      background: none;
      position: relative;
      overflow: hidden;
      /* Transitions */
      transition: background 0.18s ease, color 0.18s ease,
                  transform 0.18s cubic-bezier(0.34,1.56,0.64,1),
                  box-shadow 0.18s ease;
    }
    /* Ripple pseudo-element on hover */
    .nav-item::before {
      content: '';
      position: absolute;
      left: 0; top: 0; bottom: 0;
      width: 3px;
      border-radius: 0 3px 3px 0;
      background: #29b6e8;
      transform: scaleY(0);
      transition: transform 0.2s cubic-bezier(0.34,1.56,0.64,1);
      transform-origin: center;
    }
    .nav-item:hover::before { transform: scaleY(1); }
    .nav-item.active::before {
      transform: scaleY(1);
      background: #29b6e8;
      animation: activeGlow 2.5s ease-in-out infinite;
    }
    .nav-item:hover {
      background: rgba(255,255,255,0.09);
      color: #ffffff;
      transform: translateX(3px);
    }
    .nav-item:active {
      transform: translateX(3px) scale(0.98);
    }
    .nav-item.active {
      background: rgba(41,182,232,0.22);
      color: #ffffff;
      font-weight: 500;
      transform: translateX(3px);
    }

    /* Stagger delays removed — no entrance animation */
    .sidebar-folder { }

    /* Nav icon — lifts on hover */
    .nav-icon {
      font-size: 18px;
      width: 22px;
      text-align: center;
      opacity: 0.85;
      flex-shrink: 0;
      transition: transform 0.2s cubic-bezier(0.34,1.56,0.64,1), opacity 0.15s;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }
    .nav-icon svg {
      width: 17px;
      height: 17px;
      stroke: currentColor;
      fill: none;
      stroke-width: 1.75;
      stroke-linecap: round;
      stroke-linejoin: round;
    }
    .nav-item:hover .nav-icon {
      transform: translateY(-2px) scale(1.15);
      opacity: 1;
    }
    .nav-item.active .nav-icon {
      opacity: 1;
      transform: scale(1.1);
    }

    .nav-dot {
      width: 5px; height: 5px;
      border-radius: 50%;
      background: rgba(255,255,255,0.45);
      flex-shrink: 0;
      margin-left: 7px;
      transition: background 0.15s, transform 0.2s cubic-bezier(0.34,1.56,0.64,1);
    }
    .nav-item:hover .nav-dot { transform: scale(1.4); background: rgba(255,255,255,0.7); }
    .nav-item.active .nav-dot { background: #ffffff; opacity: 1; transform: scale(1.3); }

    /* Badge — pops in when it has content */
    .nav-badge {
      margin-left: auto;
      background: #29b6e8;
      color: #fff;
      font-size: 11px;
      font-weight: 600;
      padding: 2px 7px;
      border-radius: 20px;
      min-width: 18px;
      text-align: center;
      transition: transform 0.2s cubic-bezier(0.34,1.56,0.64,1);
      animation: badgePop 0.35s cubic-bezier(0.34,1.56,0.64,1) both;
    }
    .nav-badge:empty { display: none; }
    .nav-item:hover .nav-badge { transform: scale(1.12); }

    .nav-empty {
      font-size: 12px;
      color: rgba(255,255,255,0.35);
      font-style: italic;
      padding-left: 28px;
      cursor: default;
    }
    .nav-empty:hover { background: none; }

    /* ── Folder ── */
    .sidebar-folder-header { user-select: none; justify-content: flex-start; }
    .folder-arrow {
      margin-left: auto;
      font-size: 16px;
      color: rgba(255,255,255,0.38);
      transition: transform 0.25s cubic-bezier(0.34,1.56,0.64,1), color 0.15s;
      line-height: 1;
      display: inline-block;
    }
    .folder-arrow.open,
    .sidebar-folder-header.open .folder-arrow { transform: rotate(90deg); }
    .sidebar-folder-header:hover .folder-arrow { color: rgba(255,255,255,0.7); }

    /* Folder body — smooth expand */
    .sidebar-folder-body {
      display: none;
      flex-direction: column;
      padding-left: 8px;
      margin-top: 2px;
      background: rgba(0,0,0,0.18);
      border-radius: 6px;
      overflow: hidden;
    }
    .sidebar-folder-body.open {
      display: flex;
    }

    .nav-cat-link { font-size: 13px; }

    /* ── Footer ── */
    .sidebar-footer {
      padding: 18px;
      border-top: 1px solid rgba(255,255,255,0.10);
      flex-shrink: 0;
    }

    .user-row { display: flex; align-items: center; gap: 10px; }

    /* Avatar — pulse in on load */
    .avatar {
      width: 36px; height: 36px;
      background: linear-gradient(135deg, #29b6e8, #1a3a8a);
      border-radius: 50%;
      display: grid;
      place-items: center;
      font-weight: 700;
      font-size: 13px;
      color: #fff;
      flex-shrink: 0;
      transition: transform 0.2s cubic-bezier(0.34,1.56,0.64,1), box-shadow 0.2s;
    }
    .user-row:hover .avatar {
      transform: scale(1.1);
      box-shadow: 0 0 0 3px rgba(41,182,232,0.35);
    }

    .user-name { font-size: 14px; font-weight: 500; color: #ffffff; }
    .user-role { font-size: 12px; color: rgba(255,255,255,0.48); }

    /* Logout + theme buttons — spring press */
    .logout-btn {
      margin-left: auto;
      background: none;
      border: none;
      color: #9aa0b2;
      font-size: 18px;
      cursor: pointer;
      padding: 4px 6px;
      border-radius: 6px;
      transition: background 0.15s, color 0.15s, transform 0.15s cubic-bezier(0.34,1.56,0.64,1);
      line-height: 1;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }
    .logout-btn svg {
      stroke: currentColor;
      display: block;
    }
    .logout-btn:hover { background: rgba(244,91,105,0.22); color: #f45b69; transform: scale(1.15); }
    .logout-btn:active { transform: scale(0.9); }

    .theme-toggle-btn {
      background: none;
      border: none;
      color: #9aa0b2;
      font-size: 16px;
      cursor: pointer;
      padding: 4px 6px;
      border-radius: 6px;
      transition: background 0.15s, color 0.15s, transform 0.2s cubic-bezier(0.34,1.56,0.64,1);
      line-height: 1;
      margin-left: auto;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }
    .theme-toggle-btn svg {
      stroke: currentColor;
      display: block;
    }
    .theme-toggle-btn:hover { background: rgba(255,255,255,0.10); color: #ffffff; transform: rotate(20deg) scale(1.15); }
    .theme-toggle-btn:active { transform: rotate(-10deg) scale(0.9); }

    /* ── Reduced motion ── */
    @media (prefers-reduced-motion: reduce) {
      .nav-item:hover,
      .nav-item.active { transform: none !important; }
      .nav-item:hover .nav-icon,
      .nav-item.active .nav-icon { transform: none !important; }
      .nav-item::before { transition: none !important; }
      .folder-arrow { transition: transform 0.15s !important; }
      .logout-btn:hover,
      .theme-toggle-btn:hover { transform: none !important; }
    }
  `;
  document.head.appendChild(style);
}

// ─── Sidebar CSS: add visibility rule for the aside ─────────────────────────
// The aside starts hidden in HTML (via inline style) and is revealed after the
// first real render so the user never sees a "User / blank" placeholder flash.
// Inject this before the main sidebar CSS block so specificity works correctly.
if (!document.getElementById('_sidebar-hide-style')) {
  const hs = document.createElement('style');
  hs.id = '_sidebar-hide-style';
  hs.textContent = `
    aside.sidebar { visibility: hidden; }
    aside.sidebar.ready { visibility: visible; }
    /* Suppress all entrance animations on the sidebar — it reveals atomically */
    aside.sidebar, aside.sidebar * { animation: none !important; }
    /* Re-allow only specific interactive animations after reveal */
    aside.sidebar.ready .nav-badge { animation: badgePop 0.35s cubic-bezier(0.34,1.56,0.64,1) both; }
  `;
  document.head.appendChild(hs);
}

// Fetch categories, render, and write to cache so next page load is instant.
function _loadSidebar() {
  return api.getCategories()
    .then(res => {
      const cats = res.data || [];
      _renderSidebar(cats);
      // Cache user + categories for instant render on next navigation
      if (typeof auth !== 'undefined' && auth.currentUser) {
        _cacheWrite(auth.currentUser, cats);
      }
    })
    .catch(() => {
      _renderSidebar([]);
    });
}

// Don't render immediately on load — wait until auth resolves so we
// do exactly ONE render with both user + categories populated.
// The sidebar stays hidden (visibility:hidden) until that render fires.

// Pages that non-admin users are allowed to access (staff/viewer only)
const _staffAllowedPages = ['requests.html', 'accountability.html', 'assets-available.html'];

// Re-render after auth resolves so auth.currentUser is populated
if (typeof auth !== 'undefined') {
  const _origRequireAuth = auth.requireAuth.bind(auth);
  auth.requireAuth = async function () {
    const user = await _origRequireAuth();
    if (!user) {
      _cacheClear(); // session expired — wipe cache so stale sidebar won't show
      return null;
    }

    // Non-admin/manager users have no sidebar — redirect them immediately before any render
    if (user.role === 'staff' || user.role === 'viewer' || user.role === 'manager') {
      if (!_staffAllowedPages.includes(_sidebarPage)) {
        window.location.replace('requests.html');
        return null;
      }
      // Allowed page for staff/viewer/manager — skip sidebar render entirely
      return user;
    }

    // Admin: always fetch fresh categories and update cache
    // (re-render only updates badges & any dynamic content)
    await _loadSidebar();
    if (window.refreshNotifDot) refreshNotifDot();
    return user;
  };
}

// Safety net: if auth.currentUser is already set (page loaded fast),
// render immediately with real data — but only for admin
if (typeof auth !== 'undefined' && auth.currentUser) {
  const _u = auth.currentUser;
  if (_u.role !== 'staff' && _u.role !== 'viewer' && _u.role !== 'manager') {
    _loadSidebar();
  }
} else {
  // Poll once after a short delay as a fallback
  setTimeout(() => {
    if (typeof auth !== 'undefined' && auth.currentUser) {
      const _u = auth.currentUser;
      if (_u.role !== 'staff' && _u.role !== 'viewer' && _u.role !== 'manager') {
        _loadSidebar();
      }
    }
  }, 300);
}

window.refreshSidebar = _loadSidebar;

/** True when a notification row is unread (handles int/string from MySQL JSON) */
function _isNotifUnread(n) {
  return Number(n?.is_read ?? 0) === 0;
}

/** Move badge inside the bell button so it is never clipped by the topbar */
function _initNotifBell() {
  const btn = document.getElementById('notif-bell-btn');
  const dot = document.getElementById('notif-dot');
  if (!btn || !dot) return;
  if (dot.parentElement !== btn) btn.appendChild(dot);
}

/** Helper — show/hide the red dot badge on the notification bell */
function _setNotifDot(count) {
  _initNotifBell();
  const dot = document.getElementById('notif-dot');
  if (!dot) return;
  const n = Number(count) || 0;
  if (n > 0) {
    dot.textContent = n > 99 ? '99+' : String(n);
    dot.className   = 'notif-dot has-notif';
  } else {
    dot.textContent = '';
    dot.className   = 'notif-dot';
  }
}

/** Fetch unread notification count only */
async function _fetchBellCount() {
  if (!window.api) return 0;

  let count = 0;

  try {
    if (window.api.getUnreadCount) {
      const res = await api.getUnreadCount();
      count = Number(res.data?.count ?? res.count ?? 0) || 0;
    }
  } catch (_) {}

  // Fallback — count unread rows from the notification list
  if (count === 0) {
    try {
      if (window.api.getNotifications) {
        const res = await api.getNotifications();
        count = (res.data || []).filter(_isNotifUnread).length;
      }
    } catch (_) {}
  }

  return count;
}

/** Refresh the notification unread dot */
window.refreshNotifDot = function() {
  return _fetchBellCount().then(count => _setNotifDot(count));
};

/** Ring the bell when new notifications arrive */
let _lastNotifCount = 0;
function _ringBellIfNew(count) {
  if (count > _lastNotifCount && _lastNotifCount >= 0) {
    const bell = document.getElementById('notif-bell-btn');
    if (bell) {
      bell.classList.remove('ringing');
      // Force reflow to restart animation
      bell.getBoundingClientRect();
      bell.classList.add('ringing');
      bell.addEventListener('animationend', () => bell.classList.remove('ringing'), { once: true });
    }
  }
  _lastNotifCount = count;
}

// Clear the active location filter and reload current page
window.clearLocation = function() {
  localStorage.removeItem('emp_location_id');
  localStorage.removeItem('emp_location_name');
  window.location.reload();
};

function _sidebarToggleTheme() {
  if (typeof theme === 'undefined') return;
  theme.toggle();
  _syncThemeBtn();
}

function _syncThemeBtn() {
  const btn = document.getElementById('sidebar-theme-btn');
  if (!btn || typeof theme === 'undefined') return;
  const isDark = theme.current() === 'dark';
  const moonSvg = `<svg viewBox="0 0 24 24" width="17" height="17" stroke="currentColor" fill="none" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>`;
  const sunSvg  = `<svg viewBox="0 0 24 24" width="17" height="17" stroke="currentColor" fill="none" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></svg>`;
  btn.innerHTML = isDark ? moonSvg : sunSvg;
  btn.title = isDark ? 'Switch to Light mode' : 'Switch to Dark mode';
}

// Sync button icon after sidebar renders and after any theme change
document.addEventListener('themechange', _syncThemeBtn);
// Also sync once DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', _syncThemeBtn);
} else {
  setTimeout(_syncThemeBtn, 0);
}

function _sidebarLogout() {
  _showLogoutModal();
}

/**
 * Toggle the categories folder open/closed.
 * Drives child animations entirely via JS so they always re-run on open.
 */
function _toggleSidebarFolder(header) {
  const body = header.nextElementSibling;
  if (!body) return;

  const isOpen = body.classList.contains('open');
  header.classList.toggle('open');
  const arrow = header.querySelector('.folder-arrow');
  if (arrow) arrow.classList.toggle('open');

  if (isOpen) {
    body.classList.remove('open');
  } else {
    body.classList.add('open');
    // Animate each child with JS — stagger 45ms per item
    Array.from(body.children).forEach((el, i) => {
      el.style.opacity   = '0';
      el.style.transform = 'translateX(-12px)';
      el.style.transition = 'none';
      // Small initial timeout lets display:flex paint first
      setTimeout(() => {
        el.style.transition = `opacity 0.22s ease ${i * 45}ms, transform 0.25s cubic-bezier(0.22,1,0.36,1) ${i * 45}ms`;
        el.style.opacity   = '1';
        el.style.transform = 'translateX(0)';
      }, 16);
    });
  }
}

function _showLogoutModal() {
  // Remove any existing modal
  const existing = document.getElementById('_logout-modal');
  if (existing) existing.remove();

  const overlay = document.createElement('div');
  overlay.id = '_logout-modal';
  overlay.innerHTML = `
    <div class="_lm-backdrop"></div>
    <div class="_lm-box" role="dialog" aria-modal="true" aria-labelledby="_lm-title">
      <div class="_lm-icon">⏻</div>
      <h2 class="_lm-title" id="_lm-title">Sign out?</h2>
      <p class="_lm-body">You'll need to sign in again to access the system.</p>
      <div class="_lm-actions">
        <button class="_lm-btn-cancel" id="_lm-cancel">Cancel</button>
        <button class="_lm-btn-confirm" id="_lm-confirm">Sign out</button>
      </div>
    </div>
  `;
  document.body.appendChild(overlay);

  // Animate in
  requestAnimationFrame(() => overlay.classList.add('_lm-visible'));

  function closeModal() {
    overlay.classList.remove('_lm-visible');
    overlay.addEventListener('transitionend', () => overlay.remove(), { once: true });
  }

  document.getElementById('_lm-cancel').addEventListener('click', closeModal);
  overlay.querySelector('._lm-backdrop').addEventListener('click', closeModal);

  document.getElementById('_lm-confirm').addEventListener('click', () => {
    const btn = document.getElementById('_lm-confirm');
    btn.disabled = true;
    btn.textContent = 'Signing out…';
    if (typeof auth !== 'undefined') {
      auth.logout();
    } else {
      window.location.href = 'login.html';
    }
  });

  // Close on Escape
  function onKey(e) {
    if (e.key === 'Escape') { closeModal(); document.removeEventListener('keydown', onKey); }
  }
  document.addEventListener('keydown', onKey);
}

// Inject logout modal styles (only once)
if (!document.getElementById('_logout-modal-styles')) {
  const s = document.createElement('style');
  s.id = '_logout-modal-styles';
  s.textContent = `
    #_logout-modal {
      position: fixed;
      inset: 0;
      z-index: 9999;
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0;
      transition: opacity 0.2s ease;
    }
    #_logout-modal._lm-visible { opacity: 1; }

    ._lm-backdrop {
      position: absolute;
      inset: 0;
      background: rgba(0, 0, 0, 0.55);
      backdrop-filter: blur(4px);
    }

    ._lm-box {
      position: relative;
      background: #0f1729;
      border: 1px solid rgba(255,255,255,0.10);
      border-radius: 16px;
      padding: 40px 36px 32px;
      width: 100%;
      max-width: 360px;
      text-align: center;
      box-shadow: 0 32px 80px rgba(0,0,0,0.6);
      transform: translateY(12px) scale(0.97);
      transition: transform 0.2s ease;
    }
    #_logout-modal._lm-visible ._lm-box {
      transform: translateY(0) scale(1);
    }

    ._lm-icon {
      width: 56px; height: 56px;
      background: rgba(244,91,105,0.12);
      border-radius: 50%;
      display: grid;
      place-items: center;
      font-size: 24px;
      margin: 0 auto 20px;
      color: #f45b69;
    }

    ._lm-title {
      font-family: 'Syne', sans-serif;
      font-size: 22px;
      font-weight: 800;
      color: #e8eaf0;
      margin-bottom: 10px;
      letter-spacing: -0.3px;
    }

    ._lm-body {
      font-size: 14px;
      color: #9aa0b2;
      line-height: 1.6;
      margin-bottom: 28px;
    }

    ._lm-actions { display: flex; gap: 10px; }

    ._lm-btn-cancel,
    ._lm-btn-confirm {
      flex: 1;
      padding: 12px;
      border-radius: 8px;
      font-family: 'DM Sans', sans-serif;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      border: none;
      transition: background 0.15s, opacity 0.15s;
    }

    ._lm-btn-cancel {
      background: rgba(255,255,255,0.07);
      color: #9aa0b2;
    }
    ._lm-btn-cancel:hover { background: rgba(255,255,255,0.12); color: #e8eaf0; }

    ._lm-btn-confirm { background: #f45b69; color: #fff; }
    ._lm-btn-confirm:hover:not(:disabled) { background: #f57380; }
    ._lm-btn-confirm:disabled { opacity: 0.6; cursor: not-allowed; }

    /* ── Light mode overrides ── */
    html[data-theme="light"] ._lm-box {
      background: #ffffff;
      border-color: rgba(0,0,0,0.10);
      box-shadow: 0 16px 48px rgba(0,0,0,0.15);
    }
    html[data-theme="light"] ._lm-title { color: #0f172a; }
    html[data-theme="light"] ._lm-body  { color: #64748b; }
    html[data-theme="light"] ._lm-btn-cancel {
      background: #f1f5f9;
      color: #334155;
    }
    html[data-theme="light"] ._lm-btn-cancel:hover {
      background: #e2e8f0;
      color: #0f172a;
    }
  `;
  document.head.appendChild(s);
}

// ── Notification bell + panel ─────────────────────────────────────────────────

// ── Notification bell + panel ─────────────────────────────────────────────────
// Bell + badge styles are in theme.css. This block only injects the dropdown panel styles.

if (!document.getElementById('_notif-panel-styles')) {
  // Remove any stale injected style blocks from old versions
  ['_notif-styles','_notif-styles-v2','_notif-styles-v3'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.remove();
  });
  const ns = document.createElement('style');
  ns.id = '_notif-panel-styles';
  ns.textContent = `
    /* ── Panel container ── */
    .notif-panel {
      position: fixed;
      top: 68px;
      right: 48px;
      width: 320px;
      background: var(--bg2, #0f1729);
      border: 1px solid var(--border2, rgba(255,255,255,0.12));
      border-radius: var(--radius, 14px);
      z-index: 500;
      box-shadow: 0 20px 60px rgba(0,0,0,.6), 0 0 0 1px rgba(255,255,255,0.04);
      overflow: hidden;
      /* Panel open animation */
      opacity: 0;
      transform: translateY(-8px) scale(0.97);
      transform-origin: top right;
      transition: opacity 0.2s cubic-bezier(0.22,1,0.36,1),
                  transform 0.2s cubic-bezier(0.22,1,0.36,1);
      pointer-events: none;
    }
    .notif-panel.open {
      opacity: 1;
      transform: translateY(0) scale(1);
      pointer-events: auto;
    }
    html[data-theme="light"] .notif-panel {
      background: #ffffff;
      border-color: rgba(0,0,0,.10);
      box-shadow: 0 8px 32px rgba(0,0,0,.15), 0 0 0 1px rgba(0,0,0,0.04);
    }

    /* ── Panel header ── */
    .notif-panel-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 14px 16px 12px;
      border-bottom: 1px solid var(--border, rgba(255,255,255,.07));
    }
    .notif-panel-header span { font-size:14px; font-weight:700; color:var(--text,#e8eaf0); }
    html[data-theme="light"] .notif-panel-header span { color:#0f172a; }

    .notif-header-btn {
      font-size: 12px;
      color: var(--muted2, #9aa0b2);
      background: none;
      border: 1px solid var(--border2, rgba(255,255,255,0.12));
      cursor: pointer;
      padding: 5px 12px;
      border-radius: 8px;
      transition: background .12s, color .12s, border-color .12s, transform .1s;
      font-family: 'DM Sans', sans-serif;
      font-weight: 600;
    }
    .notif-header-btn:hover { background: rgba(255,255,255,.08); color: var(--text, #e8eaf0); border-color: rgba(255,255,255,.25); }
    .notif-header-btn:active { transform: scale(0.96); }
    .notif-header-btn-clear:hover { background: rgba(244,91,105,.15); color: #f45b69; }
    html[data-theme="light"] .notif-header-btn { border-color: rgba(0,0,0,0.15); color: #334155; }
    html[data-theme="light"] .notif-header-btn:hover { background: #f1f5f9; color: #0f172a; border-color: rgba(0,0,0,0.25); }
    html[data-theme="light"] .notif-header-btn-clear:hover { background: rgba(244,91,105,.10); color: #f45b69; }

    /* ── Notification items ── */
    .notif-item {
      display: flex;
      flex-direction: row;
      align-items: flex-start;
      gap: 12px;
      padding: 12px 16px;
      border-bottom: 1px solid var(--border, rgba(255,255,255,.05));
      cursor: pointer;
      transition: background .15s ease, transform .15s ease, opacity .15s ease;
      text-decoration: none;
      position: relative;
      /* Staggered entrance — delay set via inline style */
      opacity: 0;
      transform: translateX(-10px);
      animation: notifItemIn 0.28s cubic-bezier(0.22,1,0.36,1) forwards;
    }
    @keyframes notifItemIn {
      from { opacity: 0; transform: translateX(-10px); }
      to   { opacity: 1; transform: translateX(0); }
    }
    .notif-item:last-child { border-bottom: none; }
    .notif-item:hover {
      background: rgba(255,255,255,.06);
      transform: translateX(3px);
    }
    .notif-item.unread { background: rgba(41,182,232,.08); }
    .notif-item.unread:hover { background: rgba(41,182,232,.14); }
    html[data-theme="light"] .notif-item:hover { background: #f8fafc; }
    html[data-theme="light"] .notif-item.unread { background: #eff6ff; }
    html[data-theme="light"] .notif-item.unread:hover { background: #dbeafe; }

    /* Unread indicator dot on left edge */
    .notif-unread-dot {
      position: absolute;
      left: 4px;
      top: 50%;
      transform: translateY(-50%);
      width: 6px; height: 6px;
      border-radius: 50%;
      background: #29b6e8;
      flex-shrink: 0;
      animation: notifDotPulse 2s ease-in-out infinite;
    }
    @keyframes notifDotPulse {
      0%, 100% { box-shadow: 0 0 0 0 rgba(41,182,232,0.5); }
      50%       { box-shadow: 0 0 0 5px rgba(41,182,232,0); }
    }

    /* ── Icon box ── */
    .notif-icon-box {
      width: 40px; height: 40px;
      border-radius: 10px;
      background: #1a3a8a;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      flex-shrink: 0;
      line-height: 1;
      transition: transform 0.2s ease;
    }
    .notif-item:hover .notif-icon-box { transform: scale(1.08) rotate(-4deg); }
    .notif-icon-box.type-submitted { background: rgba(245,166,35,0.18); }
    .notif-icon-box.type-approved  { background: rgba(62,207,142,0.18); }
    .notif-icon-box.type-rejected  { background: rgba(244,91,105,0.18); }
    html[data-theme="light"] .notif-icon-box { background: #1e40af; }

    /* ── Content column ── */
    .notif-content {
      display: flex;
      flex-direction: column;
      gap: 3px;
      min-width: 0;
      flex: 1;
    }
    .notif-title { font-size:12px; font-weight:700; color:var(--text,#e8eaf0); line-height:1.35; }
    .notif-body  { font-size:11px; color:var(--muted2,#9aa0b2); line-height:1.4; }
    .notif-time  { font-size:10px; color:var(--muted,#6b7080); margin-top:2px; }
    .notif-empty {
      padding: 28px 16px;
      font-size: 12px;
      color: var(--muted,#6b7080);
      text-align: center;
      animation: fadeIn 0.3s ease both;
    }
    @keyframes fadeIn { from { opacity:0; } to { opacity:1; } }
    html[data-theme="light"] .notif-title { color:#0f172a; }
    html[data-theme="light"] .notif-body  { color:#64748b; }
    html[data-theme="light"] .notif-time  { color:#94a3b8; }

    .notif-icon-submitted { color: #f5a623; }
    .notif-icon-approved  { color: #3ecf8e; }
    .notif-icon-rejected  { color: #f45b69; }

    /* ── Panel footer ── */
    .notif-panel-footer {
      padding: 10px 16px;
      border-top: 1px solid var(--border, rgba(255,255,255,.07));
    }
    .notif-footer-clear-btn {
      display: flex;
      align-items: center;
      gap: 10px;
      width: 100%;
      background: none;
      border: none;
      color: #f45b69;
      font-size: 12px;
      font-weight: 600;
      font-family: 'DM Sans', sans-serif;
      cursor: pointer;
      padding: 4px 0;
      transition: opacity .15s, transform .1s;
    }
    .notif-footer-clear-btn::before,
    .notif-footer-clear-btn::after {
      content: '';
      flex: 1;
      height: 1px;
      background: rgba(244,91,105,0.35);
    }
    .notif-footer-clear-btn:hover { opacity: 0.75; }
    .notif-footer-clear-btn:active { transform: scale(0.97); }
    html[data-theme="light"] .notif-footer-clear-btn::before,
    html[data-theme="light"] .notif-footer-clear-btn::after {
      background: rgba(244,91,105,0.25);
    }

    /* ── Bell active press + open state ── */
    .notif-bell {
      transition: background .15s ease, color .15s ease,
                  transform .15s cubic-bezier(0.34,1.56,0.64,1),
                  box-shadow .2s ease;
    }
    .notif-bell:active {
      transform: scale(0.88);
    }
    .notif-bell.panel-open {
      background: rgba(41,182,232,0.18) !important;
      border-color: rgba(41,182,232,0.45) !important;
      color: #29b6e8 !important;
      box-shadow: 0 0 0 4px rgba(41,182,232,0.12), 0 0 18px rgba(41,182,232,0.2);
    }
    html[data-theme="light"] .notif-bell.panel-open {
      background: rgba(37,99,235,0.12) !important;
      border-color: rgba(37,99,235,0.40) !important;
      color: #2563eb !important;
      box-shadow: 0 0 0 4px rgba(37,99,235,0.10), 0 0 18px rgba(37,99,235,0.15);
    }

    /* Bell icon bounce when opening */
    @keyframes bellBounce {
      0%   { transform: scale(1) rotate(0deg); }
      25%  { transform: scale(1.22) rotate(-12deg); }
      50%  { transform: scale(1.15) rotate(10deg); }
      75%  { transform: scale(1.08) rotate(-5deg); }
      100% { transform: scale(1) rotate(0deg); }
    }
    .notif-bell.bouncing .notif-bell-icon {
      animation: bellBounce 0.45s cubic-bezier(0.34,1.56,0.64,1);
      transform-origin: center bottom;
    }

    /* ── Clear all — items fly out ── */
    @keyframes notifItemOut {
      0%   { opacity: 1; transform: translateX(0) scale(1); }
      60%  { opacity: 0.4; transform: translateX(40px) scale(0.97); }
      100% { opacity: 0; transform: translateX(60px) scale(0.95); max-height: 0; padding: 0; }
    }
    .notif-item.clearing {
      animation: notifItemOut 0.3s cubic-bezier(0.4,0,1,1) forwards;
      pointer-events: none;
    }

    /* ── Cleared empty state pop-in ── */
    @keyframes clearedIn {
      0%   { opacity: 0; transform: scale(0.7); }
      60%  { opacity: 1; transform: scale(1.08); }
      100% { opacity: 1; transform: scale(1); }
    }
    .notif-empty.cleared {
      animation: clearedIn 0.4s cubic-bezier(0.34,1.56,0.64,1) both;
      font-size: 13px;
      padding: 32px 16px;
    }
    .notif-empty.cleared .notif-cleared-icon {
      font-size: 32px;
      display: block;
      margin-bottom: 8px;
    }

    /* ── Mark all read — green flash ── */
    @keyframes notifReadFlash {
      0%   { background: rgba(62,207,142,0); }
      30%  { background: rgba(62,207,142,0.18); }
      100% { background: rgba(62,207,142,0); opacity: 0.5; }
    }
    .notif-item.marking-read {
      animation: notifReadFlash 0.45s ease forwards;
      pointer-events: none;
    }
    @keyframes bellRing {
      0%         { transform: rotate(0deg); }
      10%, 50%   { transform: rotate(14deg); }
      20%, 40%   { transform: rotate(-10deg); }
      30%        { transform: rotate(12deg); }
      60%, 100%  { transform: rotate(0deg); }
    }
    .notif-bell.ringing { animation: bellRing 0.7s cubic-bezier(0.36,0.07,0.19,0.97); }
    .notif-bell.ringing .notif-bell-icon { transform-origin: top center; }

    /* ── Reduced motion overrides ── */
    @media (prefers-reduced-motion: reduce) {
      .notif-panel  { transition: none !important; }
      .notif-item   { animation: none !important; opacity: 1 !important; transform: none !important; }
      .notif-item:hover { transform: none !important; }
      .notif-item:hover .notif-icon-box { transform: none !important; }
      .notif-unread-dot { animation: none !important; }
      .notif-bell.ringing   { animation: none !important; }
      .notif-bell.bouncing .notif-bell-icon { animation: none !important; }
      .notif-bell { transition: none !important; }
      .notif-item.clearing  { animation: none !important; opacity: 0 !important; }
      .notif-item.marking-read { animation: none !important; }
      .notif-empty.cleared  { animation: none !important; }
    }
  `;
  document.head.appendChild(ns);
}

function _bellIconSvg() {
  return '<svg class="notif-bell-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>';
}

/** Bell panel is now created lazily when first opened */
function _ensureNotifPanel() {
  if (document.getElementById('notif-panel')) return;
  const panel = document.createElement('div');
  panel.id = 'notif-panel';
  panel.className = 'notif-panel';
  panel.style.display = 'none';
  panel.innerHTML = `
    <div class="notif-panel-header">
      <span>Notifications</span>
      <button onclick="_markAllRead()" class="notif-header-btn">Mark all read</button>
    </div>
    <div id="notif-list" style="max-height:320px;overflow-y:auto;"></div>
    <div class="notif-panel-footer">
      <button onclick="_clearAllNotifs()" class="notif-footer-clear-btn">
        Clear all
      </button>
    </div>`;
  document.body.appendChild(panel);
}

/** Inject the notification bell into .topbar-actions when not already present. */
function _injectNotifBell() {
  if (document.getElementById('notif-bell-btn')) return;
  const target = document.querySelector('.topbar-actions') || document.querySelector('.req-header-right');
  if (!target) return;

  const wrap = document.createElement('div');
  wrap.className = 'notif-bell-wrap';

  const btn = document.createElement('button');
  btn.id          = 'notif-bell-btn';
  btn.className   = 'notif-bell';
  btn.title       = 'Notifications';
  btn.setAttribute('aria-label', 'Notifications');
  btn.onclick     = _toggleNotifPanel;
  btn.innerHTML   = _bellIconSvg();

  const dot = document.createElement('span');
  dot.id        = 'notif-dot';
  dot.className = 'notif-dot';

  btn.appendChild(dot);
  wrap.appendChild(btn);

  const userChip = target.querySelector('.user-chip');
  if (userChip) target.insertBefore(wrap, userChip);
  else target.appendChild(wrap);
}

// Also run on DOMContentLoaded as a safety net
function _bootNotifBell() {
  _injectNotifBell();
  _initNotifBell();
}
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', _bootNotifBell);
} else {
  setTimeout(_bootNotifBell, 0);
}

// Toggle panel open/closed
function _toggleNotifPanel() {
  _ensureNotifPanel();
  const panel = document.getElementById('notif-panel');
  const bell  = document.getElementById('notif-bell-btn');
  if (!panel) return;
  const isOpen = panel.classList.contains('open');

  if (isOpen) {
    panel.classList.remove('open');
    bell?.classList.remove('panel-open');
    panel.addEventListener('transitionend', () => {
      if (!panel.classList.contains('open')) panel.style.display = 'none';
    }, { once: true });
    return;
  }

  // Position panel below the bell button
  if (bell) {
    const rect   = bell.getBoundingClientRect();
    const panelW = 320;
    let   left   = rect.right - panelW;
    if (left < 8) left = 8;
    panel.style.top   = (rect.bottom + 8) + 'px';
    panel.style.left  = left + 'px';
    panel.style.right = 'auto';

    // Bounce the bell icon on open
    bell.classList.remove('bouncing');
    bell.getBoundingClientRect(); // reflow
    bell.classList.add('bouncing');
    bell.addEventListener('animationend', () => bell.classList.remove('bouncing'), { once: true });

    // Glow the bell while panel is open
    bell.classList.add('panel-open');
  }

  panel.style.display = '';
  panel.getBoundingClientRect(); // force reflow
  panel.classList.add('open');
  _loadNotifications();
}

// Close panel when clicking outside
document.addEventListener('click', e => {
  const panel = document.getElementById('notif-panel');
  const bell  = document.getElementById('notif-bell-btn');
  if (!panel || !panel.classList.contains('open')) return;
  if (!panel.contains(e.target) && !bell?.contains(e.target)) {
    panel.classList.remove('open');
    bell?.classList.remove('panel-open');
    panel.addEventListener('transitionend', () => {
      if (!panel.classList.contains('open')) panel.style.display = 'none';
    }, { once: true });
  }
});

// Load and render notifications
async function _loadNotifications() {
  const list = document.getElementById('notif-list');
  if (!list) return;
  list.innerHTML = '<div class="notif-empty">Loading…</div>';
  try {
    const res   = await api.getNotifications();
    const items = res.data || [];
    _setNotifDot(items.filter(_isNotifUnread).length);

    if (!items.length) {
      list.innerHTML = '<div class="notif-empty">No notifications yet.</div>';
      return;
    }
    const iconMap = {
      approval_submitted: { emoji: '📋', cls: 'type-submitted' },
      approval_approved:  { emoji: '✅', cls: 'type-approved'  },
      approval_rejected:  { emoji: '✖',  cls: 'type-rejected'  },
      po_created:         { emoji: '🛒', cls: 'type-submitted'  },
    };
    list.innerHTML = items.map((n, i) => {
      const icon    = iconMap[n.type] || { emoji: '🔔', cls: '' };
      const timeAgo = _timeAgo(n.created_at);
      const link    = n.link || '#';
      const unread  = _isNotifUnread(n);
      // Stagger each item: 40ms increments up to ~400ms max
      const delay   = Math.min(i * 40, 400);
      return `<a class="notif-item ${unread ? 'unread' : ''}" href="${link}"
                 style="animation-delay:${delay}ms"
                 onclick="_onNotifClick(event, ${n.id}, '${link}')">
        ${unread ? '<span class="notif-unread-dot"></span>' : ''}
        <div class="notif-icon-box ${icon.cls}">${icon.emoji}</div>
        <div class="notif-content">
          <div class="notif-title">${esc(n.title)}</div>
          ${n.body ? `<div class="notif-body">${esc(n.body)}</div>` : ''}
          <div class="notif-time">${timeAgo}</div>
        </div>
      </a>`;
    }).join('');
  } catch (e) {
    list.innerHTML = '<div class="notif-empty">Could not load notifications.</div>';
  }
}

async function _onNotifClick(e, id, link) {
  e.preventDefault();
  try { await api.markNotifRead(id); } catch (_) {}
  // Navigate immediately — the destination page will refresh the dot on load
  if (link && link !== '#') window.location.href = link;
}

async function _markAllRead() {
  const list  = document.getElementById('notif-list');
  const items = list ? Array.from(list.querySelectorAll('.notif-item.unread')) : [];

  // Flash unread items green with stagger
  items.forEach((el, i) => {
    el.style.animationDelay = `${i * 35}ms`;
    el.classList.add('marking-read');
  });

  const waitTime = items.length ? items.length * 35 + 460 : 0;

  try {
    await api.markAllNotifsRead();
  } catch (_) {}

  setTimeout(() => {
    _setNotifDot(0);
    _loadNotifications();
  }, waitTime);
}

async function _clearAllNotifs() {
  const list = document.getElementById('notif-list');
  const items = list ? Array.from(list.querySelectorAll('.notif-item')) : [];

  // Animate each item flying out with stagger
  items.forEach((el, i) => {
    el.style.animationDelay = `${i * 45}ms`;
    el.classList.add('clearing');
  });

  const waitTime = items.length ? items.length * 45 + 320 : 0;

  try {
    await api.clearAllNotifs();
  } catch (_) {}

  setTimeout(() => {
    _setNotifDot(0);
    if (list) {
      list.innerHTML = `
        <div class="notif-empty cleared">
          <span class="notif-cleared-icon">✨</span>
          All clear!
        </div>`;
    }
  }, waitTime);
}

// Human-friendly relative time
function _timeAgo(dateStr) {
  if (!dateStr) return '';
  const secs = Math.floor((Date.now() - new Date(dateStr).getTime()) / 1000);
  if (secs < 60)   return 'just now';
  if (secs < 3600) return Math.floor(secs / 60) + ' min ago';
  if (secs < 86400)return Math.floor(secs / 3600) + ' hr ago';
  return Math.floor(secs / 86400) + ' days ago';
}

// Poll every 10 s — refresh both the notif dot and the approvals badge
async function _pollBadges() {
  if (!window.api) return;
  try {
    const count = await _fetchBellCount();
    _ringBellIfNew(count);
    _setNotifDot(count);

    const user = (typeof auth !== 'undefined' && auth.currentUser) ? auth.currentUser : null;
    if (user && user.role === 'admin' && window.api.getPendingCount) {
      const res = await api.getPendingCount();
      const pending = res.data?.count ?? 0;
      const badge = document.getElementById('nav-approval-badge');
      if (badge) badge.textContent = pending > 0 ? pending : '';
    }
  } catch (_) {}
}

setInterval(_pollBadges, 10000);
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => setTimeout(_pollBadges, 500));
} else {
  setTimeout(_pollBadges, 500);
}



/* ══════════════════════════════════════════════════════════════════════
   SIDEBAR HAMBURGER TOGGLE
   Injects a ☰ button into the topbar left side.
   Desktop: collapses/expands the sidebar, state saved in localStorage.
   Mobile:  slides sidebar in/out with a backdrop overlay.
══════════════════════════════════════════════════════════════════════ */

// ── CSS ───────────────────────────────────────────────────────────────────────
if (!document.getElementById('_hamburger-styles')) {
  const hs = document.createElement('style');
  hs.id = '_hamburger-styles';
  hs.textContent = `
    /* ── Sidebar width transition (mini rail: 260px → 64px) ── */
    aside.sidebar {
      transition: width 0.28s cubic-bezier(0.22,1,0.36,1);
      width: 260px;
    }
    aside.sidebar.sb-collapsed {
      width: 64px;
    }

    /* ── Main content margin adjusts ── */
    .main {
      transition: margin-left 0.28s cubic-bezier(0.22,1,0.36,1);
    }
    body.sb-collapsed .main {
      margin-left: 64px !important;
    }

    /* ── Hide text when collapsed ── */
    aside.sidebar.sb-collapsed .nav-item > span:not(.nav-icon),
    aside.sidebar.sb-collapsed .nav-section,
    aside.sidebar.sb-collapsed .folder-arrow,
    aside.sidebar.sb-collapsed .nav-badge,
    aside.sidebar.sb-collapsed .brand-wordmark,
    aside.sidebar.sb-collapsed .user-info,
    aside.sidebar.sb-collapsed .sidebar-folder-body,
    aside.sidebar.sb-collapsed .sidebar-folder-header {
      display: none;
    }

    /* ── Collapsed: centre everything ── */
    aside.sidebar.sb-collapsed .sidebar-brand,
    aside.sidebar.sb-collapsed .nav-item,
    aside.sidebar.sb-collapsed .sidebar-footer .user-row {
      justify-content: center;
    }

    /* ── Collapsed brand: smaller padding ── */
    aside.sidebar.sb-collapsed .sidebar-brand {
      padding: 16px 0;
    }

    /* ── Collapsed: center the toggle button ── */
    aside.sidebar.sb-collapsed .sb-toggle-btn {
      position: static;
      transform: none;
    }
    aside.sidebar.sb-collapsed .sb-toggle-btn:hover {
      transform: scale(1.12);
    }
    aside.sidebar.sb-collapsed .sb-toggle-btn:active {
      transform: scale(0.94);
    }

    /* ── Nav items: tighten padding when collapsed ── */
    aside.sidebar.sb-collapsed .nav-item {
      padding: 10px 0;
      gap: 0;
    }

    /* ── Footer: stack avatar+buttons vertically ── */
    aside.sidebar.sb-collapsed .sidebar-footer .user-row {
      flex-direction: column;
      gap: 8px;
    }
    aside.sidebar.sb-collapsed .logout-btn,
    aside.sidebar.sb-collapsed .theme-toggle-btn {
      margin-left: 0;
    }

    /* ── Tooltip on hover (collapsed only) ── */
    aside.sidebar.sb-collapsed .nav-item {
      position: relative;
    }
    aside.sidebar.sb-collapsed .nav-item::after {
      content: attr(data-label);
      position: absolute;
      left: calc(100% + 12px);
      top: 50%;
      transform: translateY(-50%);
      background: #1a3a8a;
      color: #fff;
      font-size: 13px;
      font-weight: 500;
      padding: 6px 12px;
      border-radius: 8px;
      white-space: nowrap;
      pointer-events: none;
      opacity: 0;
      transition: opacity 0.18s ease;
      z-index: 300;
      box-shadow: 0 4px 16px rgba(0,0,0,0.5);
    }
    aside.sidebar.sb-collapsed .nav-item:hover::after {
      opacity: 1;
    }
    html[data-theme="light"] aside.sidebar.sb-collapsed .nav-item::after {
      background: #1e40af;
    }

    /* ── Mobile overlay ── */
    .sidebar-overlay {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(0,0,0,0.55);
      backdrop-filter: blur(3px);
      z-index: 99;
      opacity: 0;
      transition: opacity 0.25s ease;
    }
    .sidebar-overlay.visible {
      display: block;
      opacity: 1;
    }

    /* ── Mobile: sidebar off-screen by default ── */
    @media (max-width: 768px) {
      aside.sidebar {
        transform: translateX(-260px);
        width: 260px !important;
        z-index: 150;
        transition: transform 0.28s cubic-bezier(0.22,1,0.36,1) !important;
      }
      aside.sidebar.sb-mobile-open {
        transform: translateX(0);
      }
      aside.sidebar.sb-collapsed {
        transform: translateX(-260px) !important;
        width: 260px !important;
      }
      .main { margin-left: 0 !important; }
    }
    @media (min-width: 769px) {
      .sidebar-overlay { display: none !important; }
    }

    @media (prefers-reduced-motion: reduce) {
      aside.sidebar, .main { transition: none !important; }
    }
  `;
  document.head.appendChild(hs);
}

// ── Inject overlay (once) ─────────────────────────────────────────────────────
if (!document.getElementById('_sb-overlay')) {
  const ov = document.createElement('div');
  ov.id = '_sb-overlay';
  ov.className = 'sidebar-overlay';
  document.body.appendChild(ov);
  ov.addEventListener('click', _sbClose);
}

// ── Hamburger lives inside sidebar-brand (rendered by _renderSidebar) ─────────
// No topbar injection needed.

// ── Core toggle / open / close ────────────────────────────────────────────────
const _SB_KEY = '_sb_collapsed';

function _sbToggle() {
  if (window.innerWidth <= 768) {
    // Mobile: slide in/out with overlay
    const sidebar = document.querySelector('aside.sidebar');
    if (!sidebar) return;
    if (sidebar.classList.contains('sb-mobile-open')) {
      _sbClose();
    } else {
      sidebar.classList.add('sb-mobile-open');
      document.getElementById('_sb-overlay')?.classList.add('visible');
      document.body.style.overflow = 'hidden';
    }
  } else {
    // Desktop: collapse/expand + persist
    const sidebar = document.querySelector('aside.sidebar');
    if (!sidebar) return;
    const nowCollapsed = !sidebar.classList.contains('sb-collapsed');
    _sbApply(nowCollapsed, true);
    localStorage.setItem(_SB_KEY, nowCollapsed ? '1' : '0');
  }
}

function _sbClose() {
  const sidebar = document.querySelector('aside.sidebar');
  sidebar?.classList.remove('sb-mobile-open');
  document.getElementById('_sb-overlay')?.classList.remove('visible');
  document.body.style.overflow = '';
}

function _sbApply(collapsed, animate) {
  const sidebar = document.querySelector('aside.sidebar');
  if (!sidebar) return;
  if (!animate) {
    sidebar.style.transition = 'none';
    const main = document.querySelector('.main');
    if (main) main.style.transition = 'none';
  }
  if (collapsed) {
    sidebar.classList.add('sb-collapsed');
    document.body.classList.add('sb-collapsed');
    const btn = sidebar.querySelector('.sb-toggle-btn');
    if (btn) { btn.classList.add('is-collapsed'); btn.title = 'Expand sidebar'; }
  } else {
    sidebar.classList.remove('sb-collapsed');
    document.body.classList.remove('sb-collapsed');
    const btn = sidebar.querySelector('.sb-toggle-btn');
    if (btn) { btn.classList.remove('is-collapsed'); btn.title = 'Collapse sidebar'; }
  }
  if (!animate) {
    requestAnimationFrame(() => {
      sidebar.style.transition = '';
      const main = document.querySelector('.main');
      if (main) main.style.transition = '';
    });
  }
}

// Restore saved collapsed state on load (no animation to avoid flash)
(function _sbRestoreState() {
  const saved = localStorage.getItem(_SB_KEY) === '1';
  if (!saved) return;
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => _sbApply(true, false));
  } else {
    _sbApply(true, false);
  }
})();

// Close mobile sidebar when a nav link is tapped
document.addEventListener('click', function(e) {
  if (e.target.closest('.nav-item') && window.innerWidth <= 768) _sbClose();
});

// Clean up mobile state on resize to desktop
window.addEventListener('resize', function() {
  if (window.innerWidth > 768) _sbClose();
});
