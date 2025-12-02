/**
 * MAIN.JS - TỐI ƯU
 * File này giờ chỉ chứa jQuery legacy code nếu cần
 * Hầu hết chức năng đã được chuyển sang common.js (Vanilla JS)
 */

$(document).ready(function() {
    console.log('=== MAIN.JS (jQuery) LOADED ===');

    // Nếu có jQuery code legacy, giữ lại ở đây
    // Khuyến khích dùng Vanilla JS trong common.js thay vì jQuery

    // Form validation (Bootstrap)
    $('form.needs-validation').submit(function(e) {
        if (!this.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
        }
        $(this).addClass('was-validated');
    });
});
