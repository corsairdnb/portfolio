import './style.css';

const storageKey = 'theme';
const dark = 'dark';
const light = 'light';
const auto = 'auto';

const button = document.getElementById('switch');
const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');

/**
 * @param {string} theme - light|dark|auto
 */
function applyTheme(theme) {
  let currentTheme = theme;

  if (theme === auto) {
    currentTheme = prefersDark.matches ? dark : light;
  }

  if (currentTheme === dark) {
    document.documentElement.classList.add(dark);
  } else {
    document.documentElement.classList.remove(dark);
  }

  const themeDisplay = theme.charAt(0).toUpperCase() + theme.slice(1);
  button.textContent = `Тема: ${themeDisplay}`;
}

/**
 * @param {string} currentTheme - light|dark|auto
 * @returns {string} - light|dark|auto
 */
function getNextTheme(currentTheme) {
  switch (currentTheme) {
    case light:
      return dark;
    case dark:
      return auto;
    case auto:
    default:
      return light;
  }
}

function initializeTheme() {
  const savedTheme = localStorage.getItem(storageKey);
  const initialTheme = savedTheme || auto;

  applyTheme(initialTheme);

  prefersDark.addEventListener('change', () => {
    const stored = localStorage.getItem(storageKey);
    if (!stored || stored === auto) {
      applyTheme(auto);
    }
  });
}

function handleThemeToggle() {
  const currentSavedTheme = localStorage.getItem(storageKey) || auto;
  const newTheme = getNextTheme(currentSavedTheme);

  localStorage.setItem(storageKey, newTheme);
  applyTheme(newTheme);
}

initializeTheme();

if (button) {
  button.addEventListener('click', handleThemeToggle);
}
