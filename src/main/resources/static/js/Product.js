(function(){
  // Merge/extend global tailwind config instead of overwriting
  if (typeof tailwind === 'undefined') window.tailwind = {}; if(!tailwind.config) tailwind.config={theme:{extend:{}}};
  const extend = tailwind.config.theme.extend || (tailwind.config.theme.extend={});
  extend.colors = Object.assign({}, extend.colors, {"primary-bg": "#FAFAFA","primary-text": "#111111","accent": "#D5BFA3","secondary": "#CFCFCF","cta-hover": "#000000","primary": "#d5c0a4","background-light": "#FAFAFA","background-dark": "#1d1a15"});
  extend.fontFamily = Object.assign({}, extend.fontFamily, {"display": ["Manrope", "sans-serif"]});
  extend.borderRadius = Object.assign({}, extend.borderRadius, {"DEFAULT": "0.25rem","lg": "0.5rem","xl": "0.75rem","full": "9999px"});
})();

// ============= TOAST NOTIFICATION FUNCTIONS =============
window.showToast = function(type, title, message) {
    const toast = document.getElementById('toast-notification');
    if (!toast) {
        console.error('Toast element not found!');
        return;
    }

    const icon = document.getElementById('toast-icon');
    const titleEl = document.getElementById('toast-title');
    const messageEl = document.getElementById('toast-message');

    if (type === 'success') {
        toast.style.borderLeftColor = '#10b981';
        icon.textContent = '✅';
    } else {
        toast.style.borderLeftColor = '#ef4444';
        icon.textContent = '❌';
    }

    titleEl.textContent = title;
    messageEl.textContent = message;
    toast.style.display = 'block';

    setTimeout(function() {
        hideToast();
    }, 4000);
};

window.hideToast = function() {
    const toast = document.getElementById('toast-notification');
    if (toast) {
        toast.style.display = 'none';
    }
};

// ============= ADD TO CART FUNCTION =============
window.addToCartFromList = function(btn) {
    const spId = btn.getAttribute('data-sp-id');
    const spName = btn.getAttribute('data-sp-name');
    const btnText = btn.querySelector('.btn-text');

    console.log('=== BẮT ĐẦU THÊM SẢN PHẨM VÀO GIỎ HÀNG ===');
    console.log('Sản phẩm ID:', spId);
    console.log('Tên sản phẩm:', spName);

    if (!spId) {
        console.error('Không tìm thấy ID sản phẩm');
        showToast('error', 'Lỗi', 'Không tìm thấy ID sản phẩm');
        return;
    }

    const originalText = btnText.textContent;
    btn.disabled = true;
    btnText.textContent = 'Đang thêm...';

    // Bước 1: Lấy biến thể còn hàng
    fetch('/api/sanpham/' + spId + '/available-variant')
        .then(function(response) {
            console.log('Response status:', response.status);
            if (!response.ok) {
                throw new Error('HTTP error! status: ' + response.status);
            }
            return response.json();
        })
        .then(function(variantData) {
            console.log('Variant data:', variantData);

            if (!variantData.success) {
                showToast('error', 'Không thể thêm', variantData.message || 'Không tìm thấy biến thể khả dụng');
                btn.disabled = false;
                btnText.textContent = originalText;
                return null;
            }

            const maBienThe = variantData.variant.maBienThe;
            console.log('Mã biến thể:', maBienThe);

            // Bước 2: Thêm vào giỏ hàng
            const formData = new URLSearchParams();
            formData.append('maBienThe', maBienThe);
            formData.append('soLuong', '1');

            return fetch('/api/cart/add', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            });
        })
        .then(function(cartResponse) {
            if (!cartResponse) return null;

            console.log('Cart response status:', cartResponse.status);
            if (!cartResponse.ok) {
                throw new Error('HTTP error! status: ' + cartResponse.status);
            }
            return cartResponse.json();
        })
        .then(function(cartData) {
            if (!cartData) return;

            console.log('Cart data:', cartData);

            if (cartData.success) {
                showToast('success', 'Thành công!', 'Đã thêm "' + spName + '" vào giỏ hàng');

                // Cập nhật số lượng giỏ hàng trên header
                if (cartData.cartCount !== undefined) {
                    const cartCountElements = document.querySelectorAll('.cart-count');
                    cartCountElements.forEach(function(el) {
                        el.textContent = cartData.cartCount;
                        el.style.display = cartData.cartCount > 0 ? 'flex' : 'none';
                    });
                    if (typeof window.refreshCartCount === 'function') {
                        // Force re-fetch to sync if server logic differs
                        setTimeout(()=>window.refreshCartCount(),200);
                    }
                }
            } else {
                showToast('error', 'Không thể thêm', cartData.message || 'Có lỗi xảy ra');
            }

            btn.disabled = false;
            btnText.textContent = originalText;
        })
        .catch(function(error) {
            console.error('Lỗi khi thêm vào giỏ hàng:', error);
            showToast('error', 'Lỗi', 'Không thể kết nối đến server. Vui lòng thử lại.');
            btn.disabled = false;
            btnText.textContent = originalText;
        });
};

// ============= INITIALIZATION =============
document.addEventListener('DOMContentLoaded', function() {
    console.log('=== PRODUCT.JS LOADED ===');
    console.log('window.addToCartFromList:', typeof window.addToCartFromList);
    console.log('window.showToast:', typeof window.showToast);
    console.log('window.hideToast:', typeof window.hideToast);
});
