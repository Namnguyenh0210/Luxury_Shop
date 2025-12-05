/**
 * PRODUCTDETAIL.JS - TỐI ƯU
 * Logic cho trang chi tiết sản phẩm - ƯU TIÊN BACKEND
 */

// Global variables cho product detail
let selectedColorId = null;
let selectedSizeId = null;
let selectedVariantId = null;
let selectedStock = 0;
let selectedPrice = null;
let variants = [];

// Chỉ load khi ở trang Product Detail
document.addEventListener('DOMContentLoaded', function() {
    // Check if we're on product detail page
    const isProductDetailPage = document.body.classList.contains('product-detail-page') ||
                                 location.pathname.includes('/sanpham/') ||
                                 document.querySelector('.product-detail-content') !== null;

    if (isProductDetailPage) {
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
    }
});

// ============= HELPER FUNCTIONS =============

window.decreaseQuantity = function() {
    const input = document.getElementById('quantity');
    const currentValue = parseInt(input.value) || 1;
    if (currentValue > 1) {
        input.value = currentValue - 1;
    }
};

window.increaseQuantity = function() {
    const input = document.getElementById('quantity');
    const currentValue = parseInt(input.value) || 1;
    const maxValue = parseInt(input.max) || 99;
    if (currentValue < maxValue) {
        input.value = currentValue + 1;
    } else {
        if (typeof showToast === 'function') {
            showToast('error', 'Hết hàng', `Chỉ còn ${maxValue} sản phẩm trong kho`);
        } else {
            alert(`⚠️ Chỉ còn ${maxValue} sản phẩm trong kho`);
        }
    }
};

window.findVariantId = function() {
    let variantId = null;

    // Nếu đã chọn cả màu và size, tìm variant tương ứng
    if (selectedColorId && selectedSizeId && variants && variants.length > 0) {
        const variant = variants.find(v =>
            v.mauSacSP && v.mauSacSP.maMau == selectedColorId &&
            v.sizeSP && v.sizeSP.maSize == selectedSizeId
        );
        if (variant) {
            variantId = variant.maBienThe;
            console.log('✅ Found variant by color+size:', variantId);
        }
    }
    // Nếu chỉ chọn size, dùng selectedVariantId
    else if (selectedVariantId) {
        variantId = selectedVariantId;
        console.log('✅ Using selected variant ID:', variantId);
    }
    // Nếu chưa chọn gì, lấy variant đầu tiên có tồn kho
    else if (variants && variants.length > 0) {
        const availableVariant = variants.find(v => v.soLuongTon > 0);
        if (availableVariant) {
            variantId = availableVariant.maBienThe;
            console.log('✅ Using first available variant:', variantId);
        }
    }

    return variantId;
};

// ============= MAIN CART FUNCTIONS - TỐI ƯU =============

window.addProductToCart = function() {
    const variantId = findVariantId();
    const quantity = parseInt(document.getElementById('quantity').value) || 1;

    if (!variantId) {
        if (typeof showToast === 'function') {
            showToast('error', 'Chưa chọn sản phẩm', 'Vui lòng chọn màu sắc và size');
        } else {
            alert('⚠️ Vui lòng chọn màu sắc và size');
        }
        return;
    }

    if (!selectedColorId || !selectedSizeId) {
        if (typeof showToast === 'function') {
            showToast('error', 'Chưa chọn đầy đủ', 'Vui lòng chọn đầy đủ màu sắc và size');
        } else {
            alert('⚠️ Vui lòng chọn đầy đủ màu sắc và size');
        }
        return;
    }

    if (quantity > selectedStock) {
        if (typeof showToast === 'function') {
            showToast('error', 'Vượt quá tồn kho', `Chỉ còn ${selectedStock} sản phẩm trong kho`);
        } else {
            alert(`⚠️ Chỉ còn ${selectedStock} sản phẩm trong kho`);
        }
        return;
    }

    console.log('🛒 Adding to cart:', { variantId, quantity });

    // Disable button để tránh click nhiều lần
    const btn = document.getElementById('addToCartBtn');
    const originalText = btn.innerHTML;
    btn.disabled = true;
    btn.innerHTML = '<span>⏳ Đang thêm...</span>';

    fetch('/api/cart/add', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({
            maBienThe: variantId,
            soLuong: quantity
        })
    })
    .then(r => {
        if (!r.ok) {
            throw new Error('Network response was not ok');
        }
        return r.json();
    })
    .then(data => {
        btn.disabled = false;
        btn.innerHTML = originalText;

        console.log('✅ Add to cart response:', data);

        if (data.success) {
            // Show success message with toast
            const colorName = document.getElementById('selectedColorName').textContent;
            const sizeName = document.getElementById('selectedSizeName').textContent;
            const productName = document.querySelector('h1').textContent || 'Sản phẩm';

            if (typeof showToast === 'function') {
                showToast('success', 'Thêm vào giỏ hàng thành công!',
                    `${productName} - ${colorName} - ${sizeName} (x${quantity})`);
            } else {
                alert(`✅ ${data.message}\n\nSản phẩm: ${productName}\nMàu: ${colorName}\nSize: ${sizeName}\nSố lượng: ${quantity}`);
            }

            // Cập nhật số lượng giỏ hàng trong header
            if (data.cartCount) {
                const cartBadges = document.querySelectorAll('.cart-count');
                cartBadges.forEach(badge => {
                    badge.textContent = data.cartCount;
                    badge.style.display = data.cartCount > 0 ? 'flex' : 'none';
                });
            }

            // Refresh cart count
            if (typeof refreshCartCount === 'function') {
                refreshCartCount();
            }
        } else {
            // Kiểm tra nếu chưa đăng nhập
            if (data.message && (data.message.includes('đăng nhập') || data.message.includes('login'))) {
                if (typeof showToast === 'function') {
                    showToast('error', 'Vui lòng đăng nhập', 'Bạn cần đăng nhập để thêm sản phẩm vào giỏ hàng');
                } else {
                    alert('⚠️ Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng');
                }
                // Chuyển hướng đến trang đăng nhập sau 2 giây
                setTimeout(() => {
                    window.location.href = '/login?redirect=' + encodeURIComponent(window.location.pathname);
                }, 2000);
            } else {
                if (typeof showToast === 'function') {
                    showToast('error', 'Không thể thêm', data.message || 'Có lỗi xảy ra');
                } else {
                    alert('❌ ' + (data.message || 'Có lỗi xảy ra'));
                }
            }
        }
    })
    .catch(e => {
        btn.disabled = false;
        btn.innerHTML = originalText;
        console.error('❌ Error adding to cart:', e);

        if (typeof showToast === 'function') {
            showToast('error', 'Lỗi kết nối', 'Không thể kết nối đến server. Vui lòng thử lại.');
        } else {
            alert('❌ Lỗi: ' + e.message);
        }
    });
};

window.buyNow = function() {
    const variantId = findVariantId();
    const quantity = parseInt(document.getElementById('quantity').value) || 1;

    if (!variantId) {
        if (typeof showToast === 'function') {
            showToast('error', 'Chưa chọn sản phẩm', 'Vui lòng chọn màu sắc và size');
        } else {
            alert('⚠️ Vui lòng chọn màu sắc và size');
        }
        return;
    }

    if (!selectedColorId || !selectedSizeId) {
        if (typeof showToast === 'function') {
            showToast('error', 'Chưa chọn đầy đủ', 'Vui lòng chọn đầy đủ màu sắc và size');
        } else {
            alert('⚠️ Vui lòng chọn đầy đủ màu sắc và size');
        }
        return;
    }

    if (quantity > selectedStock) {
        if (typeof showToast === 'function') {
            showToast('error', 'Vượt quá tồn kho', `Chỉ còn ${selectedStock} sản phẩm trong kho`);
        } else {
            alert(`⚠️ Chỉ còn ${selectedStock} sản phẩm trong kho`);
        }
        return;
    }

    console.log('⚡ Buy now:', { variantId, quantity });

    // Thêm vào giỏ hàng rồi chuyển đến trang thanh toán
    fetch('/api/cart/add', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({
            maBienThe: variantId,
            soLuong: quantity
        })
    })
    .then(r => {
        if (!r.ok) {
            throw new Error('Network response was not ok');
        }
        return r.json();
    })
    .then(data => {
        console.log('✅ Buy now response:', data);

        if (data.success) {
            // Chuyển đến trang thanh toán
            window.location.href = '/checkout';
        } else {
            // Kiểm tra nếu chưa đăng nhập
            if (data.message && (data.message.includes('đăng nhập') || data.message.includes('login'))) {
                if (typeof showToast === 'function') {
                    showToast('error', 'Vui lòng đăng nhập', 'Bạn cần đăng nhập để mua hàng');
                } else {
                    alert('⚠️ Vui lòng đăng nhập để mua hàng');
                }
                setTimeout(() => {
                    window.location.href = '/login?redirect=' + encodeURIComponent(window.location.pathname);
                }, 2000);
            } else {
                if (typeof showToast === 'function') {
                    showToast('error', 'Không thể mua', data.message || 'Có lỗi xảy ra');
                } else {
                    alert('❌ ' + (data.message || 'Có lỗi xảy ra'));
                }
            }
        }
    })
    .catch(e => {
        console.error('❌ Error in buy now:', e);

        if (typeof showToast === 'function') {
            showToast('error', 'Lỗi kết nối', 'Không thể kết nối đến server. Vui lòng thử lại.');
        } else {
            alert('❌ Lỗi: ' + e.message);
        }
    });
};
