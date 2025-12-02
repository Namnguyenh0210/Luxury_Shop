/**
 * ĐkiTk.JS - TỐI ƯU (Đăng ký tài khoản)
 * Logic cho trang đăng ký
 */

// Chỉ load khi ở trang Register
if (document.body.classList.contains('register-page') || location.pathname.includes('/register') || location.pathname.includes('/dkitk')) {
    document.addEventListener('DOMContentLoaded', function() {
        console.log('=== REGISTER PAGE LOADED ===');

        // Password match validation
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');

        if (password && confirmPassword) {
            confirmPassword.addEventListener('input', function() {
                if (this.value !== password.value) {
                    this.setCustomValidity('Mật khẩu không khớp');
                } else {
                    this.setCustomValidity('');
                }
            });
        }

        // Password toggle (sử dụng từ common.js)
    });
}
