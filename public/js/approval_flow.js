/**
 * approval_flow.js
 *
 * Helper used on pages where staff initiate mutations.
 * Instead of calling the API directly, staff actions are queued
 * as approval_requests for admin review.
 *
 * Usage:
 *   const result = await ApprovalFlow.submit({
 *     action_type:   'create' | 'update' | 'delete',
 *     resource_type: 'Asset' | 'Assignment' | 'Damage' | 'Supplier' | 'Category',
 *     resource_id:   null | number,
 *     resource_name: string,
 *     payload:       object,     // the data that would have been sent
 *     notes:         string,     // optional staff note
 *   });
 *   // result.queued === true  → staff sees "submitted for approval"
 *   // result.queued === false → admin, executed directly
 */

const ApprovalFlow = (() => {

  function isStaff() {
    return typeof auth !== 'undefined' && auth.currentUser?.role === 'staff';
  }

  function isRequestUser() {
    return typeof auth !== 'undefined' && (auth.currentUser?.role === 'staff' || auth.currentUser?.role === 'viewer');
  }

  /**
   * If the current user is staff, queue the action for approval and show a
   * pending toast.  Returns { queued: true, data: approval_request }.
   *
   * If the user is admin (or viewer), returns { queued: false } and the
   * caller should proceed with the direct API call.
   */
  async function submit(opts) {
    if (!isRequestUser()) return { queued: false };

    try {
      const res = await api.submitApproval({
        action_type:   opts.action_type,
        resource_type: opts.resource_type,
        resource_id:   opts.resource_id   || null,
        resource_name: opts.resource_name || null,
        payload:       opts.payload       || {},
        notes:         opts.notes         || null,
      });

      // Show persistent pending toast
      _showPendingToast(opts.action_type, opts.resource_type, opts.resource_name);

      // Immediately trigger a badge refresh on this client (notif dot updates)
      // The admin's client will pick it up within 10 s via the sidebar poll.
      if (window.refreshNotifDot) refreshNotifDot();

      return { queued: true, data: res.data };
    } catch (e) {
      if (window.showToast) showToast('Failed to submit request: ' + e.message, 'error');
      throw e;
    }
  }

  function _showPendingToast(action, resource, name) {
    const label = name ? `"${name}"` : resource;
    const msg   = `⏳ ${_cap(action)} request for ${label} submitted — awaiting admin approval.`;

    if (window.showToast) {
      showToast(msg);
    } else {
      // Fallback: inject a simple banner
      const banner = document.createElement('div');
      banner.style.cssText = 'position:fixed;bottom:24px;right:24px;background:#162040;border:1px solid rgba(245,166,35,.4);border-radius:10px;padding:14px 18px;font-size:13px;color:#f5a623;z-index:9999;max-width:340px;box-shadow:0 8px 32px rgba(0,0,0,.5);';
      banner.textContent = msg;
      document.body.appendChild(banner);
      setTimeout(() => banner.remove(), 5000);
    }
  }

  function _cap(s) {
    return s ? s.charAt(0).toUpperCase() + s.slice(1) : s;
  }

  return { submit, isStaff, isRequestUser };
})();
