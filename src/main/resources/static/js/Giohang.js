/**
 * GIOHANG.JS - TỐI ƯU
 * Chỉ giữ logic đặc thù cho trang giỏ hàng
 * Các hàm chung đã được chuyển vào common.js
 */

// Auto debug cart state khi vào trang giỏ hàng
document.addEventListener('DOMContentLoaded', function() {
    if (location.pathname === '/giohang' || location.pathname.includes('/cart')) {
        console.log('=== CART PAGE LOADED ===');

        // Debug cart state
        if (typeof window.debugCartState === 'function') {
            window.debugCartState();
        }

        // Refresh cart count
        if (typeof window.refreshCartCount === 'function') {
            window.refreshCartCount();
        }
    }
});

