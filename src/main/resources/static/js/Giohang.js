// Fix typo: use tailwind.config instead of tmtailwind.config
if (typeof tailwind === 'undefined') { window.tailwind = {}; }
if (!tailwind.config) {
    tailwind.config = {
        darkMode: "class",
        theme: { extend: { colors: { "primary": "#000000","background-light": "#FAFAFA","background-dark": "#191919","primary-text": "#111111","accent": "#D5BFA3","secondary-gray": "#CFCFCF","hover-cta": "#000000" }, fontFamily: { "display": ["Manrope","sans-serif"], "heading": ["Playfair Display","serif"] }, borderRadius: { "DEFAULT": "0.25rem","lg": "0.5rem","xl": "0.75rem","full": "9999px" } } }
    };
}
// Provide backward compatibility alias to silence old references
if (typeof tmtailwind === 'undefined') { window.tmtailwind = window.tailwind; }
// Expose debug function
window.debugCartState = async function(){ try { const r = await fetch('/api/cart/items'); const j = await r.json(); console.log('[DEBUG CART]', j); } catch(e){ console.warn('Cannot fetch debug cart', e); } };
// Auto debug on load for troubleshooting
document.addEventListener('DOMContentLoaded', ()=>{ if (location.pathname === '/giohang') { window.debugCartState(); if(typeof window.refreshCartCount==='function'){window.refreshCartCount();} }});
