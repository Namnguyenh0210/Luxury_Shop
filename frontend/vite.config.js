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
      // ====================================================
      // CHỈ PROXY CÁC ENDPOINT THỰC SỰ CỦA SPRING BOOT
      // Các route Vue (/login, /admin, /staff...) KHÔNG proxy
      // vì Vue Router tự xử lý chúng
      // ====================================================

      // ✅ REST API
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false
      },

      // ✅ Google OAuth2 - PHẢI proxy qua Spring Boot (port 8080)
      // Khi user click "Đăng nhập với Google", Spring Security xử lý
      '/oauth2': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false
      },

      // ✅ Google OAuth2 callback từ Google → Spring Boot nhận
      '/login/oauth2': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false
      },

      // ✅ Spring Security logout (invalidate session phía server)
      '/logout': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false
      },

      // ✅ PayOS Payment
      '/payment': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false
      },

      // ✅ Register POST (form submit) - GET /register xử lý bởi Vue Router
      '/register': {
        target: 'http://localhost:8080',
        changeOrigin: true,
        secure: false,
        // Chỉ proxy POST (form submit), không proxy GET
        bypass(req) {
          if (req.method === 'GET') return req.url
        }
      }
    }
  }
})



