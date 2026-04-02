/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{html,ts}"],
  theme: {
    extend: {},
  },
  plugins: [require('daisyui')],
  daisyui: {
    themes: [
      {
        "tucolmadomate": {
          "base-100": "#121212",
          "base-200": "#1E1E1E",
          "base-300": "#2D2D2D",
          "primary": "#3b82f6",
          "secondary": "#10b981",
        }
      }
    ],
  },
}