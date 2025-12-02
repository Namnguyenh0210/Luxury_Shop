/**
 * LOGIN.JS - TỐI ƯU
 * Logic cho trang đăng nhập
 * Password toggle đã được chuyển vào common.js
 */

// Chỉ load khi ở trang Login
if (document.body.classList.contains('login-page') || location.pathname.includes('/login')) {
    document.addEventListener('DOMContentLoaded', function() {
        console.log('=== LOGIN PAGE LOADED ===');

        // Form validation sẽ do HTML5 + backend xử lý
        // Password toggle đã có trong common.js
    });
}
