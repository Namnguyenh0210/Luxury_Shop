/**
 * CHECKOUT-SUCCESS.JS - TỐI ƯU
 * Logic cho trang đặt hàng thành công
 */

// Chỉ load khi ở trang Checkout Success
if (document.body.classList.contains('checkout-success-page') || location.pathname.includes('/checkout-success')) {
    document.addEventListener('DOMContentLoaded', function() {
        console.log('=== CHECKOUT SUCCESS PAGE LOADED ===');

        // Animation hiển thị thông báo thành công
        const successIcon = document.querySelector('.success-icon');
        if (successIcon) {
            successIcon.classList.add('animate-bounce');
        }

        // Clear cart sau khi đặt hàng thành công
        if (typeof window.refreshCartCount === 'function') {
            window.refreshCartCount();
        }
    });
}
