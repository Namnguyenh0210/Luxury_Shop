/**
 * PROFILE.JS - TỐI ƯU
 * Logic cho trang profile
 */

// Chỉ load khi ở trang Profile
if (document.body.classList.contains('profile-page') || location.pathname.includes('/profile')) {
    document.addEventListener('DOMContentLoaded', function() {
        console.log('=== PROFILE PAGE LOADED ===');

        // Preview avatar upload
        const avatarInput = document.getElementById('avatar-upload');
        const avatarPreview = document.getElementById('avatar-preview');

        if (avatarInput && avatarPreview) {
            avatarInput.addEventListener('change', function(e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        avatarPreview.src = e.target.result;
                    };
                    reader.readAsDataURL(file);
                }
            });
        }
    });
}
