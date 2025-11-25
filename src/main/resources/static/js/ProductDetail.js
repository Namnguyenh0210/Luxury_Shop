tailwind.config = {
    darkMode: "class",
    theme: {
        extend: {
            colors: {
                "primary": "#000000",
                "background-light": "#FAFAFA",
                "background-dark": "#111111",
                "text-primary": "#111111",
                "text-secondary": "#CFCFCF",
                "accent": "#D5BFA3",
            },
            fontFamily: {
                "display": ["Manrope", "sans-serif"],
                "serif": ["Playfair Display", "serif"]
            },
            borderRadius: {"DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px"},
        },
    },
}
