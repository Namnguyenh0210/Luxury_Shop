/**
 * COMMON.JS - TỔNG HỢP CHỨC NĂNG CHUNG TỐI ƯU
 * Gộp tất cả hàm dùng chung để tránh trùng lặp
 */

// ============= UI UTILITIES =============
// Mobile menu toggle
function toggleMobileMenu() {
    const nav = document.getElementById('mainNav');
    if (nav) nav.classList.toggle('show');
}

// Toggle user dropdown menu
function toggleUserDropdown() {
    const dropdown = document.getElementById('userDropdown');
    const userAvatar = document.querySelector('.user-avatar');
    if (dropdown && userAvatar) {
        dropdown.classList.toggle('show');
        userAvatar.classList.toggle('active');
    }
}

// ============= TOAST NOTIFICATION - CHUNG CHO TOÀN DỰ ÁN =============
window.showToast = function(type, title, message) {
    // Nếu chỉ truyền 2 params (legacy support)
    if (!message && title) {
        message = title;
        title = type === 'success' ? 'Thành công' : 'Lỗi';
    }

    const toast = document.getElementById('toast-notification');
    if (!toast) {
        // Fallback: tạo toast đơn giản nếu không có element
        const div = document.createElement('div');
        div.className = 'toast-fallback ' + type;
        div.style.cssText = 'position:fixed;top:20px;right:20px;padding:15px 25px;background:'+(type==='success'?'#10b981':'#ef4444')+';color:white;border-radius:8px;z-index:9999;box-shadow:0 4px 12px rgba(0,0,0,0.15);';
        div.innerHTML = '<strong>'+title+'</strong><br>'+message;
        document.body.appendChild(div);
        setTimeout(() => div.remove(), 4000);
        return;
    }

    const icon = document.getElementById('toast-icon');
    const titleEl = document.getElementById('toast-title');
    const messageEl = document.getElementById('toast-message');

    if (type === 'success') {
        toast.style.borderLeftColor = '#10b981';
        if (icon) icon.textContent = '✅';
    } else {
        toast.style.borderLeftColor = '#ef4444';
        if (icon) icon.textContent = '❌';
    }

    if (titleEl) titleEl.textContent = title;
    if (messageEl) messageEl.textContent = message;
    toast.style.display = 'block';

    setTimeout(() => hideToast(), 4000);
};

window.hideToast = function() {
    const toast = document.getElementById('toast-notification');
    if (toast) toast.style.display = 'none';
};

// ============= FORMAT UTILITIES =============
// Format Price (VND)
window.formatPrice = function(price) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(price);
};

// ============= CART UTILITIES =============
// Refresh cart count từ server
window.refreshCartCount = function() {
    fetch('/api/cart/count')
        .then(res => res.json())
        .then(data => {
            const cartCountElements = document.querySelectorAll('.cart-count');
            cartCountElements.forEach(el => {
                el.textContent = data.count || 0;
                el.style.display = data.count > 0 ? 'flex' : 'none';
            });
        })
        .catch(err => console.error('Error refreshing cart count:', err));
};

// Add to cart - Hàm chung tối ưu
window.addToCartFromList = function(btn) {
    const spId = btn.getAttribute('data-sp-id');
    const spName = btn.getAttribute('data-sp-name');
    const btnText = btn.querySelector('.btn-text');

    if (!spId) {
        showToast('error', 'Lỗi', 'Không tìm thấy ID sản phẩm');
        return;
    }

    const originalText = btnText.textContent;
    btn.disabled = true;
    btnText.textContent = 'Đang thêm...';

    // Backend sẽ tự động tìm biến thể còn hàng
    fetch('/api/cart/add-product', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({ productId: spId, quantity: 1 })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            showToast('success', 'Thành công!', 'Đã thêm "' + spName + '" vào giỏ hàng');
            refreshCartCount();
        } else {
            showToast('error', 'Không thể thêm', data.message || 'Có lỗi xảy ra');
        }
        btn.disabled = false;
        btnText.textContent = originalText;
    })
    .catch(error => {
        console.error('Lỗi:', error);
        showToast('error', 'Lỗi', 'Không thể kết nối đến server');
        btn.disabled = false;
        btnText.textContent = originalText;
    });
};

// ============= FORM VALIDATION =============
// Form validation helpers
window.validateForm = function(formId) {
    const form = document.getElementById(formId);
    if (!form) return false;

    // Để browser tự validate (HTML5)
    if (!form.checkValidity()) {
        form.reportValidity();
        return false;
    }
    return true;
};

// ============= DOM READY INITIALIZATION =============
document.addEventListener('DOMContentLoaded', function() {
    // Close dropdown when clicking outside
    document.addEventListener('click', function(event) {
        const userMenu = document.querySelector('.user-menu');
        const dropdown = document.getElementById('userDropdown');
        const userAvatar = document.querySelector('.user-avatar');

        if (userMenu && dropdown && !userMenu.contains(event.target)) {
            dropdown.classList.remove('show');
            if (userAvatar) userAvatar.classList.remove('active');
        }
    });

    // Smooth scrolling for anchor links
    const anchorLinks = document.querySelectorAll('a[href^="#"]');
    anchorLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (href !== '#' && href.length > 1) {
                e.preventDefault();
                const target = document.querySelector(href);
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            }
        });
    });

    // Header scroll effect
    const header = document.querySelector('header');
    if (header) {
        window.addEventListener('scroll', function() {
            if (window.scrollY > 50) {
                header.classList.add('scrolled');
            } else {
                header.classList.remove('scrolled');
            }
        });
    }

    // Back to top button
    const backToTop = document.getElementById('back-to-top');
    if (backToTop) {
        window.addEventListener('scroll', function() {
            backToTop.style.display = window.scrollY > 300 ? 'block' : 'none';
        });

        backToTop.addEventListener('click', function() {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    }

    // Initialize cart count
    refreshCartCount();

    // Animation on scroll
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.animate-on-scroll').forEach(el => observer.observe(el));

    // Toggle password visibility
    const togglePassword = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('password');
    if (togglePassword && passwordInput) {
        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            const icon = this.querySelector('.material-symbols-outlined');
            if (icon) icon.textContent = type === 'password' ? 'visibility' : 'visibility_off';
        });
    }
});

// Debug helper
window.debugCartState = async function() {
    try {
        const r = await fetch('/api/cart/items');
        const j = await r.json();
        console.log('[DEBUG CART]', j);
    } catch(e) {
        console.warn('Cannot fetch debug cart', e);
    }
};
