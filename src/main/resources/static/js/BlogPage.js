tailwind.config = {
    darkMode: "class",
    theme: {
        extend: {
            colors: {
                "primary": "#d5c0a4",
                "background-light": "#FAFAFA",
                "background-dark": "#1d1a15",
                "text-primary-light": "#111111",
                "text-primary-dark": "#f7f7f6",
                "text-secondary-light": "#6b7280",
                "text-secondary-dark": "#9ca3af",
                "border-light": "#CFCFCF",
                "border-dark": "#374151",
                "cta-hover": "#000000"
            },
            fontFamily: {
                "display": ["Manrope", "sans-serif"],
                "serif": ["Playfair Display", "serif"]
            },
            borderRadius: {
                "DEFAULT": "0.25rem",
                "lg": "0.5rem",
                "xl": "0.75rem",
                "full": "9999px"
            },
        },
    },
};
