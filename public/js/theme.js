/**
 * theme.js — Light / Dark mode manager.
 * Include this as the FIRST script in <head> to avoid flash of wrong theme.
 * Usage: theme.set('light' | 'dark'), theme.toggle(), theme.current()
 */
(function () {
  const KEY = 'inv_theme';

  function apply(t) {
    document.documentElement.setAttribute('data-theme', t);
  }

  // Apply immediately on parse (before DOM is ready) to prevent flash
  apply(localStorage.getItem(KEY) || 'dark');

  window.theme = {
    current() { return localStorage.getItem(KEY) || 'dark'; },
    set(t) {
      localStorage.setItem(KEY, t);
      apply(t);
      document.dispatchEvent(new CustomEvent('themechange', { detail: t }));
    },
    toggle() {
      this.set(this.current() === 'dark' ? 'light' : 'dark');
    },
  };
})();
