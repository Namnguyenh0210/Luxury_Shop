/**
 * PRODUCT.JS - TỐI ƯU
 * Chỉ giữ logic đặc thù cho trang sản phẩm
 * Các hàm chung đã được chuyển vào common.js
 */

// Chỉ load khi ở trang Product
if (document.body.classList.contains('product-page') || location.pathname.includes('/product')) {
    document.addEventListener('DOMContentLoaded', function() {
        console.log('=== PRODUCT PAGE LOADED ===');

        // Các chức năng đặc thù cho trang product sẽ được thêm ở đây
        // Hiện tại đã chuyển hết sang common.js và backend
    });
}
