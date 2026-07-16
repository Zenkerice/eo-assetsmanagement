/**
 * Auth helper — checks session, redirects to login if needed,
 * exposes currentUser and role helpers.
 */

const AUTH_BASE = resolveProjectRoot() + '/api/auth';

const auth = {
  /** Cached user from session check */
  currentUser: null,

  /** The resolved API base URL for auth endpoints */
  AUTH_BASE,

  /** Fetch current session user. Redirects to login.html if not authenticated. */
  async requireAuth() {
    try {
      const res  = await fetch(`${AUTH_BASE}/me`, { credentials: 'include' });
      const data = await res.json();
      if (!res.ok || !data.success) {
        this._redirectLogin();
        return null;
      }
      this.currentUser = data.data;
      return data.data;
    } catch {
      this._redirectLogin();
      return null;
    }
  },

  /** Require admin role. Redirects to index.html if staff. */
  async requireAdmin() {
    const user = await this.requireAuth();
    if (!user) return null;
    if (user.role !== 'admin') {
      window.location.href = 'index.html';
      return null;
    }
    return user;
  },

  /** Login with username + password. Returns user or throws. */
  async login(username, password) {
    const res  = await fetch(`${AUTH_BASE}/login`, {
      method:      'POST',
      credentials: 'include',
      headers:     { 'Content-Type': 'application/json' },
      body:        JSON.stringify({ username, password }),
    });
    const data = await res.json();
    if (!res.ok || !data.success) throw new Error(data.error || 'Login failed');
    this.currentUser = data.data;
    return data.data;
  },

  /** Register a new account (viewer or staff only). */
  async register(payload) {
    const res  = await fetch(`${AUTH_BASE}/register`, {
      method:  'POST',
      headers: { 'Content-Type': 'application/json' },
      body:    JSON.stringify(payload),
    });
    const data = await res.json();
    if (!res.ok || !data.success) throw new Error(data.error || 'Registration failed');
    return data.data;
  },

  /** Logout and redirect to login page. */
  async logout() {
    await fetch(`${AUTH_BASE}/logout`, { method: 'POST', credentials: 'include' });
    this.currentUser = null;
    // Clear sidebar cache so next login starts fresh
    try { sessionStorage.removeItem('_sb_user'); sessionStorage.removeItem('_sb_cats'); } catch(_) {}
    this._redirectLogin();
  },

  // ── User management (admin) ───────────────────────────────────────────────

  async getUsers() {
    const res  = await fetch(`${AUTH_BASE}/users`, { credentials: 'include' });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Failed to load users');
    return data.data;
  },

  async createUser(payload) {
    const res  = await fetch(`${AUTH_BASE}/users`, {
      method:      'POST',
      credentials: 'include',
      headers:     { 'Content-Type': 'application/json' },
      body:        JSON.stringify(payload),
    });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Failed to create user');
    return data.data;
  },

  async updateUser(id, payload) {
    const uid = parseInt(id, 10);
    if (!uid) throw new Error('Invalid user ID');
    const res  = await fetch(`${AUTH_BASE}/users/${uid}`, {
      method:      'PUT',
      credentials: 'include',
      headers:     { 'Content-Type': 'application/json' },
      body:        JSON.stringify(payload),
    });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Failed to update user');
    return data.data;
  },

  /** Update the currently logged-in user's own profile (works for all roles, no admin needed). */
  async updateMe(payload) {
    const res  = await fetch(`${AUTH_BASE}/me`, {
      method:      'PUT',
      credentials: 'include',
      headers:     { 'Content-Type': 'application/json' },
      body:        JSON.stringify(payload),
    });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Failed to update profile');
    return data.data;
  },

  async deleteUser(id) {
    const uid = parseInt(id, 10);
    if (!uid) throw new Error('Invalid user ID');
    const res  = await fetch(`${AUTH_BASE}/users/${uid}`, {
      method:      'DELETE',
      credentials: 'include',
    });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Failed to delete user');
    return data;
  },

  async approveUser(id) {
    const uid = parseInt(id, 10);
    if (!uid) throw new Error('Invalid user ID');
    return this.updateUser(uid, { status: 'active' });
  },

  async rejectUser(id) {
    const uid = parseInt(id, 10);
    if (!uid) throw new Error('Invalid user ID');
    return this.updateUser(uid, { status: 'rejected' });
  },

  // ── Helpers ───────────────────────────────────────────────────────────────

  isAdmin()  { return this.currentUser?.role === 'admin'; },
  isStaff()  { return this.currentUser?.role === 'staff'; },
  isViewer() { return this.currentUser?.role === 'viewer'; },
  isManager(){ return this.currentUser?.role === 'manager'; },
  isRequestUser() { return this.isStaff() || this.isViewer() || this.isManager(); },

  /** Default landing page after login */
  getLandingPage(role) {
    if (role === 'staff' || role === 'viewer' || role === 'manager') return 'requests.html';
    return 'index.html';
  },

  /** Standard page bootstrap: auth check, sidebar user info, optional callback */
  async initPage({ admin = false, onReady } = {}) {
    const user = admin ? await this.requireAdmin() : await this.requireAuth();
    if (!user) return null;
    this.renderUserInfo();
    if (onReady) await onReady(user);
    return user;
  },

  /** Returns the display label for a user's role/position.
   *  Format: "Position (Role)" if position is set, otherwise just "Role".
   *  e.g. "Team Leader (Supervisor)" or "Supervisor"
   */
  getRoleDisplay(user) {
    const roleLabels = { admin: 'Admin', manager: 'Manager', staff: 'Staff', viewer: 'Supervisor' };
    const roleLabel  = roleLabels[user.role] || user.role;
    return user.position ? `${user.position} (${roleLabel})` : roleLabel;
  },

  /** Render user info into sidebar footer elements if they exist. */
  renderUserInfo() {
    const user = this.currentUser;
    if (!user) return;
    const nameEl   = document.querySelector('.user-name');
    const roleEl   = document.querySelector('.user-role');
    const avatarEl = document.querySelector('.avatar');
    if (nameEl)   nameEl.textContent   = user.name;
    if (roleEl)   roleEl.textContent   = this.getRoleDisplay(user);
    if (avatarEl) avatarEl.textContent = user.name.charAt(0).toUpperCase();
  },

  _redirectLogin() {
    const page = window.location.pathname.split('/').pop();
    if (page !== 'login.html') {
      window.location.href = 'login.html';
    }
  },
};
