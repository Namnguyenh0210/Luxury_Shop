/**
 * PAY.JS - TỐI ƯU
 * Logic cho trang thanh toán
 */

// Chỉ load khi ở trang Payment
if (document.body.classList.contains('pay-page') || location.pathname.includes('/pay')) {
    document.addEventListener('DOMContentLoaded', function() {
        console.log('=== PAYMENT PAGE LOADED ===');

        // Payment method selection
        const paymentMethods = document.querySelectorAll('input[name="paymentMethod"]');
        if (paymentMethods.length > 0) {
            paymentMethods.forEach(method => {
                method.addEventListener('change', function() {
                    // Show/hide payment-specific forms
                    const selectedMethod = this.value;
                    console.log('Payment method selected:', selectedMethod);
                });
            });
        }
    });
}
