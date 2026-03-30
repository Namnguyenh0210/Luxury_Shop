import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { fileURLToPath, URL } from 'node:url'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  server: {
    port: 5173,
    proxy: {
      // ✅ /api → Spring Boot (checkout data: /api/checkout, /api/checkout/place-order)
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false
      },

      // ✅ Google OAuth2
      '/oauth2': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false
      },

      // ✅ Google OAuth2 callback
      '/login/oauth2': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false
      },

      // ✅ Spring Security logout
      '/logout': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false
      },

      // ✅ PayOS API endpoints (check, webhook, return, cancel)
      // /payment Vue page → KHÔNG proxy (Vue Router xử lý)
      // /payment/payos/* → Spring Boot xử lý
      '/payment/payos': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false
      },

      // ✅ Register POST only — GET /register là Vue Router route
      '/register': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false,
        bypass(req) {
          if (req.method === 'GET') return req.url
        }
      },
      
      // ✅ Static assets from Backend (Uploads & Avatars ONLY)
      '/uploads': { target: 'http://localhost:8080', changeOrigin: true },
      '/avatars': { target: 'http://localhost:8080', changeOrigin: true },

      // ❌ REMOVED /img and /images because they conflict with the frontend public folder assets.
      // Admin API calls already go through /api/admin/... via axios.defaults.baseURL = '/api'

      // ❌ KHÔNG proxy /checkout — Vue Router xử lý
      // Data fetch qua /api/checkout (đã có trong /api proxy trên)
    }
  }
})





