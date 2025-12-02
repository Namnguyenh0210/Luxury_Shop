/**
 * HOME.JS - TỐI ƯU
 * Chỉ giữ logic đặc thù cho trang Home
 * Tailwind config đã được gộp vào tailwind-config.js
 */

// Chỉ load khi ở trang Home
if (document.body.classList.contains('home-page') || location.pathname === '/' || location.pathname === '/home') {
    document.addEventListener('DOMContentLoaded', function() {
        console.log('=== HOME PAGE LOADED ===');

        // Carousel/slider nếu có
        // Animation effects đã có trong common.js
    });
}

