// Global Tailwind CDN configuration (must load BEFORE CDN script)
// Centralized to avoid duplicated configs in Product.js, Giohang.js, etc.
// Colors match design tokens used across templates.
if (typeof tailwind === 'undefined') { window.tailwind = {}; }
if (!tailwind.config) {
  tailwind.config = {
    darkMode: 'class',
    theme: {
      extend: {
        colors: {
          primary: '#000000',
          accent: '#D5BFA3',
          'background-light': '#FAFAFA',
          'background-dark': '#191919',
          'primary-text': '#111111',
          'secondary-gray': '#CFCFCF',
          'hover-cta': '#000000'
        },
        fontFamily: {
          display: ['Manrope','sans-serif'],
          heading: ['Playfair Display','serif']
        },
        borderRadius: {
          DEFAULT: '0.25rem',
          lg: '0.5rem',
          xl: '0.75rem',
          full: '9999px'
        }
      }
    }
  };
}
// Backward compatibility alias (old typo tmtailwind.config)
if (typeof tmtailwind === 'undefined') { window.tmtailwind = window.tailwind; }

