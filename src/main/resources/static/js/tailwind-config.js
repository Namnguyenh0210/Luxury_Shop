/**
 * TAILWIND CONFIG - Cấu hình tập trung cho toàn bộ dự án
 * Tối ưu: Gộp tất cả config vào 1 file duy nhất
 */
// Wrap in function to execute after Tailwind CDN loads
(function() {
    if (typeof tailwind !== 'undefined') {
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#000000",
                        "primary-bg": "#FAFAFA",
                        "background-light": "#FAFAFA",
                        "background-dark": "#191919",
                        "text-primary": "#111111",
                        "text-primary-light": "#111111",
                        "text-primary-dark": "#FAFAFA",
                        "text-secondary": "#CFCFCF",
                        "text-secondary-light": "#757575",
                        "text-secondary-dark": "#CFCFCF",
                        "accent": "#D5BFA3",
                        "secondary": "#CFCFCF",
                        "secondary-gray": "#CFCFCF",
                        "border-light": "#CFCFCF",
                        "border-dark": "#444444",
                        "card-light": "#FFFFFF",
                        "card-dark": "#1F1F1F",
                        "cta": "#000000",
                        "cta-hover": "#000000",
                        "hover-cta": "#000000"
                    },
                    fontFamily: {
                        "display": ["Manrope", "sans-serif"],
                        "heading": ["Playfair Display", "serif"],
                        "serif": ["Playfair Display", "serif"]
                    },
                    borderRadius: {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    }
                }
            }
        };
    } else {
        // Fallback: define config as window object for CDN to pick up
        window.tailwindConfig = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#000000",
                        "primary-bg": "#FAFAFA",
                        "background-light": "#FAFAFA",
                        "background-dark": "#191919",
                        "text-primary": "#111111",
                        "text-primary-light": "#111111",
                        "text-primary-dark": "#FAFAFA",
                        "text-secondary": "#CFCFCF",
                        "text-secondary-light": "#757575",
                        "text-secondary-dark": "#CFCFCF",
                        "accent": "#D5BFA3",
                        "secondary": "#CFCFCF",
                        "secondary-gray": "#CFCFCF",
                        "border-light": "#CFCFCF",
                        "border-dark": "#444444",
                        "card-light": "#FFFFFF",
                        "card-dark": "#1F1F1F",
                        "cta": "#000000",
                        "cta-hover": "#000000",
                        "hover-cta": "#000000"
                    },
                    fontFamily: {
                        "display": ["Manrope", "sans-serif"],
                        "heading": ["Playfair Display", "serif"],
                        "serif": ["Playfair Display", "serif"]
                    },
                    borderRadius: {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    }
                }
            }
        };
    }
})();
