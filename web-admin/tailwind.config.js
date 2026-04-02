/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts}"
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('daisyui')
  ],
  daisyui: {
    themes: [
      {
        tucolmadodark: {
          "primary": "#10b981", "secondary": "#f59e0b", "accent": "#14b8a6", "neutral": "#1e293b",
          "base-100": "#0f172a", "base-200": "#1e293b", "base-300": "#334155", "base-content": "#f8fafc"
        },
        tucolmadolight: {
          "primary": "#10b981", "secondary": "#f59e0b", "accent": "#14b8a6", "neutral": "#cbd5e1",
          "base-100": "#f8fafc", "base-200": "#f1f5f9", "base-300": "#e2e8f0", "base-content": "#0f172a"
        }
      }
    ],
  }
}
