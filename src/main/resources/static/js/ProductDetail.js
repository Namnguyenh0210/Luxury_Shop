/**
 * PRODUCTDETAIL.JS - TỐI ƯU
 * Logic cho trang chi tiết sản phẩm
 */

// Chỉ load khi ở trang Product Detail
if (document.body.classList.contains('product-detail-page') || location.pathname.includes('/product/')) {
    document.addEventListener('DOMContentLoaded', function() {
        console.log('=== PRODUCT DETAIL PAGE LOADED ===');

        // Image gallery/zoom nếu cần
        const mainImage = document.querySelector('.product-main-image');
        const thumbnails = document.querySelectorAll('.product-thumbnail');

        if (mainImage && thumbnails.length > 0) {
            thumbnails.forEach(thumb => {
                thumb.addEventListener('click', function() {
                    const newSrc = this.getAttribute('data-image-url');
                    if (newSrc) mainImage.src = newSrc;

                    // Remove active class from all
                    thumbnails.forEach(t => t.classList.remove('active'));
                    this.classList.add('active');
                });
            });
        }

        // Quantity selector
        const qtyInput = document.getElementById('quantity');
        const btnMinus = document.getElementById('qty-minus');
        const btnPlus = document.getElementById('qty-plus');

        if (qtyInput && btnMinus && btnPlus) {
            btnMinus.addEventListener('click', function() {
                const currentVal = parseInt(qtyInput.value) || 1;
                if (currentVal > 1) qtyInput.value = currentVal - 1;
            });

            btnPlus.addEventListener('click', function() {
                const currentVal = parseInt(qtyInput.value) || 1;
                const maxVal = parseInt(qtyInput.getAttribute('max')) || 99;
                if (currentVal < maxVal) qtyInput.value = currentVal + 1;
            });
        }
    });
}

