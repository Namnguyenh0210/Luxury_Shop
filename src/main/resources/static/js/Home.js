/**
 * HOME.JS - TỐI ƯU
 * Chỉ giữ logic đặc thù cho trang Home
 * Tailwind config đã được gộp vào tailwind-config.js
 */

// Chỉ load khi ở trang Home
document.addEventListener('DOMContentLoaded', function() {
    // Check if we're on home page by checking path or specific elements
    const isHomePage = document.body.classList.contains('home-page') ||
                       location.pathname === '/' ||
                       location.pathname === '/home' ||
                       document.querySelector('.home-page-content') !== null;

    if (isHomePage) {
        console.log('=== HOME PAGE LOADED ===');

        // Carousel/slider nếu có
        // Animation effects đã có trong common.js
    }
});
