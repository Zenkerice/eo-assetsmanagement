/**
 * Shared front-end utilities used across all pages.
 */

/** Resolve project URL root (e.g. /inventory) */
function resolveProjectRoot() {
  if (window.location.protocol === 'file:') {
    const m = window.location.pathname.match(/\/([^/]+)\/public\//);
    return `http://localhost/${m ? m[1] : 'inventory'}`;
  }
  const parts = window.location.pathname.split('/');
  const pub   = parts.lastIndexOf('public');
  return pub !== -1 ? parts.slice(0, pub).join('/') : parts.slice(0, -1).join('/');
}

/** HTML-escape a string for safe insertion into innerHTML */
function esc(s) {
  const d = document.createElement('div');
  d.textContent = s ?? '';
  return d.innerHTML;
}

/**
 * Format a date or datetime value.
 * @param {string} value
 * @param {{ dateTime?: boolean, empty?: string }} opts
 */
function formatDate(value, opts = {}) {
  if (!value) return opts.empty ?? '';
  const raw = String(value);
  const d   = new Date(raw.includes('T') ? raw : raw + 'T00:00:00');
  if (isNaN(d.getTime())) return opts.empty ?? '';
  if (opts.dateTime) {
    return d.toLocaleString('en-US', {
      month: 'short', day: 'numeric', year: 'numeric',
      hour: 'numeric', minute: '2-digit',
    });
  }
  return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
}

/** Show a location context badge in the topbar */
function showLocationBadge(locName, opts = {}) {
  const target = document.querySelector('.topbar-actions');
  if (!target || !locName) return;
  let badge = document.getElementById('ctx-loc-badge');
  if (!badge) {
    badge = document.createElement('span');
    badge.id        = 'ctx-loc-badge';
    badge.className = 'loc-badge';
    target.prepend(badge);
  }
  badge.textContent   = '\u{1F4CD} ' + locName;
  badge.onclick       = opts.onClick || null;
  badge.title         = opts.title   || '';
  badge.style.cursor  = opts.onClick ? 'pointer' : '';
}

window.resolveProjectRoot = resolveProjectRoot;
window.esc              = esc;
window.formatDate       = formatDate;
window.showLocationBadge = showLocationBadge;

// Back-compat alias used by some pages
window.fmtDate = (d, empty) => formatDate(d, { empty: empty ?? '<span style="color:var(--muted)">&mdash;</span>' });
