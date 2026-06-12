/**
 * Sidebar — renders immediately then fills categories async.
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
const _isSuppliers = _sidebarPage === 'suppliers.html';
const _isReceive   = _sidebarPage === 'receive.html';
const _isAudit     = _sidebarPage === 'audit.html';
const _isSettings  = _sidebarPage === 'settings.html';
const _isImport    = _sidebarPage === 'import.html';
const _isApprovals = _sidebarPage === 'approvals.html';
const _folderOpen  = _isCats || (_isItems && _activeCatId);

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
  const requestPages = ['accountability.html'];
  if (user && (user.role === 'staff' || user.role === 'viewer') && !requestPages.includes(_sidebarPage)) {
    window.location.href = 'requests.html';
    return;
  }
  const userName    = user ? esc(user.name) : 'User';
  const roleLabels  = { admin: 'System Manager', staff: 'HR', viewer: 'TL' };
  const userRole    = user ? (roleLabels[user.role] || user.role) : '';
  const userInitial = user ? user.name.charAt(0).toUpperCase() : 'U';
  const isAdmin     = user && user.role === 'admin';

  const adminLinks = isAdmin ? `
    <div class="nav-section">Admin</div>
    <a href="approvals.html" class="nav-item ${_isApprovals ? 'active' : ''}">
      <span class="nav-icon">✅</span>
      <span>Approvals</span>
      <span class="nav-badge" id="nav-approval-badge"></span>
    </a>
    <a href="users.html" class="nav-item ${_isUsers ? 'active' : ''}">
      <span class="nav-icon">👥</span>
      <span>Users</span>
    </a>` : '';

  asideEl.innerHTML = `
    <div class="sidebar-brand">
      <a href="index.html" class="brand-wordmark">
        <span class="brand-empire">Empire</span><span class="brand-one">One</span>
      </a>
    </div>

    <nav class="sidebar-nav">
      <div class="nav-section">Overview</div>

      <a href="index.html" class="nav-item ${_isHome ? 'active' : ''}">
        <span class="nav-icon">⊞</span>
        <span>Dashboard</span>
      </a>

      <div class="nav-section">Manage</div>

      <a href="items.html" class="nav-item ${_isItems && !_activeCatId ? 'active' : ''}">
        <span class="nav-icon">⬡</span>
        <span>Assets</span>
      </a>

      <div class="sidebar-folder">
        <div class="sidebar-folder-header nav-item ${_folderOpen ? 'open' : ''}"
             onclick="_toggleSidebarFolder(this)">
          <span class="nav-icon">◈</span>
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

      <a href="damages.html" class="nav-item ${_isDamages ? 'active' : ''}">
        <span class="nav-icon">⚠</span>
        <span>Asset Status</span>
        ${openIssuesBadge}
      </a>

      <a href="assignees2.html" class="nav-item ${_isAssignees ? 'active' : ''}">
        <span class="nav-icon">🪪</span>
        <span>Employees</span>
      </a>

      <a href="accountability.html" class="nav-item ${_sidebarPage === 'accountability.html' ? 'active' : ''}">
        <span class="nav-icon">📋</span>
        <span>Accountability</span>
      </a>
      <a href="suppliers.html" class="nav-item ${_isSuppliers ? 'active' : ''}">
        <span class="nav-icon">🏭</span>
        <span>Suppliers</span>
      </a>

      ${isAdmin ? `
      <a href="receive.html" class="nav-item ${_isReceive ? 'active' : ''}">
        <span class="nav-icon">📥</span>
        <span>Receive</span>
        <span class="nav-badge" id="nav-po-badge"></span>
      </a>` : ''}

      ${adminLinks}

      <div class="nav-section">Preferences</div>
      <a href="audit.html" class="nav-item ${_isAudit ? 'active' : ''}">
        <span class="nav-icon">&#128203;</span>
        <span>Audit Log</span>
      </a>
      <a href="import.html" class="nav-item ${_isImport ? 'active' : ''}">
        <span class="nav-icon">&#8593;</span>
        <span>Import</span>
      </a>
      <a href="settings.html" class="nav-item ${_isSettings ? 'active' : ''}">
        <span class="nav-icon">⚙</span>
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
        <button class="theme-toggle-btn" id="sidebar-theme-btn" title="Toggle theme" onclick="_sidebarToggleTheme()">🌙</button>
        <button class="logout-btn" title="Logout" onclick="_sidebarLogout()">⏻</button>
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

  // Populate pending PO badge — admin only
  if (isAdmin && window.api && window.api.getPendingPurchaseOrders) {
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
    html[data-theme="light"] .main { background: #f0f4ff !important; }
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
if (!document.getElementById('_sidebar-styles')) {
  const style = document.createElement('style');
  style.id = '_sidebar-styles';
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
    /* Light mode: dark blue sidebar */
    html[data-theme="light"] .sidebar {
      background: #1e40af !important;
      border-right: 1px solid rgba(255,255,255,0.08) !important;
    }
    html[data-theme="light"] .sidebar-brand    { border-bottom-color: rgba(255,255,255,0.12) !important; }
    html[data-theme="light"] .nav-section      { color: rgba(255,255,255,0.45) !important; }
    html[data-theme="light"] .nav-item         { color: rgba(255,255,255,0.85) !important; }
    html[data-theme="light"] .nav-item:hover   { background: rgba(255,255,255,0.12) !important; color: #ffffff !important; }
    html[data-theme="light"] .nav-item.active  { background: rgba(255,255,255,0.20) !important; color: #ffffff !important; }
    html[data-theme="light"] .folder-arrow     { color: rgba(255,255,255,0.45) !important; }
    html[data-theme="light"] .nav-empty        { color: rgba(255,255,255,0.40) !important; }
    html[data-theme="light"] .sidebar-footer   { border-top-color: rgba(255,255,255,0.12) !important; }
    html[data-theme="light"] .user-name        { color: #ffffff !important; }
    html[data-theme="light"] .user-role        { color: rgba(255,255,255,0.55) !important; }
    html[data-theme="light"] .logout-btn       { color: rgba(255,255,255,0.55) !important; }
    html[data-theme="light"] .logout-btn:hover { background: rgba(244,91,105,0.25) !important; color: #ffffff !important; }
    html[data-theme="light"] .theme-toggle-btn { color: rgba(255,255,255,0.55) !important; }
    html[data-theme="light"] .theme-toggle-btn:hover { background: rgba(255,255,255,0.12) !important; color: #ffffff !important; }
    html[data-theme="light"] .nav-badge        { background: #29b6e8 !important; color: #fff !important; }
    html[data-theme="light"] .sidebar-folder-body { background: rgba(0,0,0,0.15) !important; }
    html[data-theme="light"] .nav-dot          { background: rgba(255,255,255,0.45) !important; }
    html[data-theme="light"] .nav-item.active .nav-dot { background: #ffffff !important; }

    /* ── Brand ── */
    .sidebar-brand {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 22px 20px 20px;
      border-bottom: 1px solid rgba(255,255,255,0.10);
      flex-shrink: 0;
    }
    .brand-wordmark {
      display: inline-flex;
      align-items: baseline;
      text-decoration: none;
      line-height: 1;
      gap: 0;
      transition: opacity 0.15s ease, transform 0.2s cubic-bezier(0.34,1.56,0.64,1);
    }
    .brand-wordmark:hover {
      opacity: 0.85;
      transform: scale(1.04);
    }
    .sidebar .brand-empire {
      font-family: 'DM Sans', sans-serif;
      font-size: 30px;
      font-weight: 800;
      letter-spacing: -0.8px;
      color: #ffffff;
      -webkit-text-stroke: 0.4px #ffffff;
    }
    .sidebar .brand-one {
      font-family: 'DM Sans', sans-serif;
      font-size: 30px;
      font-weight: 800;
      letter-spacing: -0.8px;
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
      display: inline-block;
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
      animation: folderBodyIn 0.25s cubic-bezier(0.22,1,0.36,1) both;
    }

    @keyframes folderBodyIn {
      from { opacity: 0; transform: translateY(-6px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    @keyframes catItemSlide {
      from { opacity: 0; transform: translateX(-10px); }
      to   { opacity: 1; transform: translateX(0); }
    }

    /* Staggered entrance for every child inside an open folder body */
    .sidebar-folder-body.open > * {
      opacity: 0;
      animation: catItemSlide 0.22s cubic-bezier(0.22,1,0.36,1) forwards;
    }
    .sidebar-folder-body.open > *:nth-child(1)  { animation-delay: 0.03s; }
    .sidebar-folder-body.open > *:nth-child(2)  { animation-delay: 0.07s; }
    .sidebar-folder-body.open > *:nth-child(3)  { animation-delay: 0.11s; }
    .sidebar-folder-body.open > *:nth-child(4)  { animation-delay: 0.15s; }
    .sidebar-folder-body.open > *:nth-child(5)  { animation-delay: 0.18s; }
    .sidebar-folder-body.open > *:nth-child(6)  { animation-delay: 0.21s; }
    .sidebar-folder-body.open > *:nth-child(7)  { animation-delay: 0.24s; }
    .sidebar-folder-body.open > *:nth-child(8)  { animation-delay: 0.27s; }
    .sidebar-folder-body.open > *:nth-child(9)  { animation-delay: 0.30s; }
    .sidebar-folder-body.open > *:nth-child(10) { animation-delay: 0.33s; }
    .sidebar-folder-body.open > *:nth-child(n+11) { animation-delay: 0.35s; }

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
      color: rgba(255,255,255,0.48);
      font-size: 18px;
      cursor: pointer;
      padding: 4px 6px;
      border-radius: 6px;
      transition: background 0.15s, color 0.15s, transform 0.15s cubic-bezier(0.34,1.56,0.64,1);
      line-height: 1;
    }
    .logout-btn:hover { background: rgba(244,91,105,0.22); color: #f45b69; transform: scale(1.15); }
    .logout-btn:active { transform: scale(0.9); }

    .theme-toggle-btn {
      background: none;
      border: none;
      color: rgba(255,255,255,0.48);
      font-size: 16px;
      cursor: pointer;
      padding: 4px 6px;
      border-radius: 6px;
      transition: background 0.15s, color 0.15s, transform 0.2s cubic-bezier(0.34,1.56,0.64,1);
      line-height: 1;
      margin-left: auto;
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
      .sidebar-folder-body.open,
      .sidebar-folder-body.open > * { animation: none !important; opacity: 1 !important; transform: none !important; }
      .logout-btn:hover,
      .theme-toggle-btn:hover { transform: none !important; }
    }
  `;
  document.head.appendChild(style);
}

// Render immediately (no categories — no blink)
_renderSidebar([]);

// Fetch categories and re-render; also re-render once auth resolves so
// admin-only links appear correctly after the session check.
function _loadSidebar() {
  return api.getCategories()
    .then(res => {
      _renderSidebar(res.data || []);
    })
    .catch(() => {});
}

_loadSidebar();

// Re-render after auth resolves so auth.currentUser is populated
if (typeof auth !== 'undefined') {
  const _origRequireAuth = auth.requireAuth.bind(auth);
  auth.requireAuth = async function () {
    const user = await _origRequireAuth();
    if (!user) return null;
    await _loadSidebar();
    if (window.refreshNotifDot) refreshNotifDot();
    return user;
  };
}

// Safety net: if auth.currentUser is already set (page loaded fast),
// re-render immediately so role-gated links are correct
if (typeof auth !== 'undefined' && auth.currentUser) {
  _loadSidebar();
} else {
  // Poll once after a short delay to catch cases where auth resolves
  // before the requireAuth hook fires (e.g. cached session)
  setTimeout(() => {
    if (typeof auth !== 'undefined' && auth.currentUser) {
      _loadSidebar();
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
  btn.textContent = isDark ? '🌙' : '☀';
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
 * Forces child animations to re-run each time the folder opens
 * by removing the .open class, forcing a reflow, then re-adding it.
 */
function _toggleSidebarFolder(header) {
  const body = header.nextElementSibling;
  if (!body) return;

  const isOpen = body.classList.contains('open');

  header.classList.toggle('open');
  const arrow = header.querySelector('.folder-arrow');
  if (arrow) arrow.classList.toggle('open');

  if (isOpen) {
    // Closing — just remove
    body.classList.remove('open');
  } else {
    // Opening — strip .open, force reflow, re-add so CSS animations restart
    body.classList.remove('open');
    // Remove animation from all children so they can restart
    const children = Array.from(body.children);
    children.forEach(el => {
      el.style.animation = 'none';
      el.style.opacity   = '0';
    });
    // Force reflow
    body.getBoundingClientRect();
    // Re-add .open — CSS will re-apply staggered animations
    body.classList.add('open');
    // Clear the inline overrides so CSS takes over
    children.forEach(el => {
      el.style.animation = '';
      el.style.opacity   = '';
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


