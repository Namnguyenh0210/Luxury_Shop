tailwind.config = {
    darkMode: "class",
    theme: {
        extend: {
            colors: {
                "primary": "#000000",
                "background-light": "#f7f7f7",
                "background-dark": "#191919",
                "brand-off-white": "#FAFAFA",
                "brand-dark-gray": "#111111",
                "brand-light-beige": "#D5BFA3",
                "brand-light-gray": "#CFCFCF",
                "brand-deep-black": "#000000",
            },
            fontFamily: {
                "display": ["Manrope", "sans-serif"]
            },
            borderRadius: {"DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px"},
        },
    },
};

// Toggle password visibility
document.addEventListener('DOMContentLoaded', function() {
    const togglePassword = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('password');

    if (togglePassword && passwordInput) {
        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);

            // Toggle icon
            const icon = this.querySelector('.material-symbols-outlined');
            if (icon) {
                icon.textContent = type === 'password' ? 'visibility' : 'visibility_off';
            }
        });
    }
});

