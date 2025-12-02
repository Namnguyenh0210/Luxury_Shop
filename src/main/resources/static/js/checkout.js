/**
 * CHECKOUT.JS - TỐI ƯU
 * Logic cho trang thanh toán
 * Đã tối ưu và sử dụng showToast từ common.js
 */

// Address form modal
window.showAddAddressForm = function() {
    const modal = document.getElementById('address-form-modal');
    if (modal) {
        modal.style.display = 'flex';
        setTimeout(() => {
            const inp = document.querySelector('#addressForm input[name="name"]');
            if (inp) inp.focus();
        }, 100);
    }
};

window.hideAddAddressForm = function() {
    const modal = document.getElementById('address-form-modal');
    if (modal) modal.style.display = 'none';
};

// Set default address
window.setDefaultAddress = function(id) {
    fetch('/api/address/set-default/' + id, { method: 'POST' })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                showToast('success', 'Thành công', 'Đã đặt địa chỉ làm mặc định');
                const addr = document.querySelector('.address-item[data-id="' + id + '"]');
                if (addr) {
                    addr.classList.add('highlight');
                    setTimeout(() => addr.classList.remove('highlight'), 1200);
                }
                // Reload page to update default status
                setTimeout(() => location.reload(), 1500);
            } else {
                showToast('error', 'Lỗi', data.message || 'Không thể đặt địa chỉ mặc định');
            }
        })
        .catch(err => {
            console.error(err);
            showToast('error', 'Lỗi', 'Không thể kết nối đến server');
        });
};

// Edit address
window.editAddress = function(id) {
    // TODO: Load address data and show edit form
    console.log('Edit address:', id);
    showToast('info', 'Thông báo', 'Tính năng đang phát triển');
};

// Delete address
window.deleteAddress = function(id) {
    if (!confirm('Bạn có chắc muốn xóa địa chỉ này?')) return;

    fetch('/api/address/delete/' + id, { method: 'DELETE' })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                showToast('success', 'Thành công', 'Đã xóa địa chỉ');
                // Remove address element from DOM
                const addr = document.querySelector('.address-item[data-id="' + id + '"]');
                if (addr) addr.remove();
            } else {
                showToast('error', 'Lỗi', data.message || 'Không thể xóa địa chỉ');
            }
        })
        .catch(err => {
            console.error(err);
            showToast('error', 'Lỗi', 'Không thể kết nối đến server');
        });
};

// Address form submit
document.addEventListener('DOMContentLoaded', function() {
    const addressForm = document.getElementById('addressForm');
    if (addressForm) {
        addressForm.addEventListener('submit', function(e) {
            e.preventDefault();

            const formData = new FormData(this);

            fetch('/api/address/add', {
                method: 'POST',
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    showToast('success', 'Thành công', 'Lưu địa chỉ thành công!');
                    hideAddAddressForm();
                    // Reload to show new address
                    setTimeout(() => location.reload(), 1500);
                } else {
                    showToast('error', 'Lỗi', data.message || 'Không thể lưu địa chỉ');
                }
            })
            .catch(err => {
                console.error(err);
                showToast('error', 'Lỗi', 'Không thể kết nối đến server');
            });
        });
    }
});
