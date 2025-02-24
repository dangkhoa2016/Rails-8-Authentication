// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "@popperjs/core"
import "controllers"
import * as bootstrap from "bootstrap"

function initTheme() {
  const attributeName = 'data-bs-theme';

  const getPreferredTheme = () => {
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
  };

  const setTheme = theme => {
    if (theme === 'auto' && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      document.documentElement.setAttribute(attributeName, 'dark')
    } else {
      document.documentElement.setAttribute(attributeName, theme)
    }

    const event = new Event('ColorSchemeChange')
    document.documentElement.dispatchEvent(event)
  };

  setTheme(getPreferredTheme());
};

initTheme();
