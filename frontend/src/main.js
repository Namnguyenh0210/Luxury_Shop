import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import App from './App.vue'
import axios from 'axios'

// Import original CSS files as global styles
import './assets/css/Home.css'
import './assets/css/Product.css'
import './assets/css/ProductDetail.css'
import './assets/css/BlogPage.css'
import './assets/css/BlogDetail.css'
import './assets/css/Checkout-success.css'
import './assets/css/Login.css'
import './assets/css/Pay.css'
import './assets/css/Profile.css'
import './assets/css/admin.css'

// Import ComingSoon wrapper for pages being converted
const ComingSoon = () => import('./views/layout/ComingSoon.vue')

// import views dynamically
const routes = [
  // Home - Fully converted ✅
  { path: '/', component: () => import('./views/Home.vue') },

  // Products - Now using real Product.vue ✅
  { path: '/sanpham', component: () => import('./views/Product.vue') },
  { path: '/product', component: () => import('./views/Product.vue') },
  { path: '/nam', component: () => import('./views/Product.vue') },
  { path: '/nu', component: () => import('./views/Product.vue') },
  { path: '/product/:id', component: () => import('./views/ProductDetail.vue') },
  { path: '/sanpham/:id', component: () => import('./views/ProductDetail.vue') },

  // Blog - Using ComingSoon wrapper
  { path: '/blog', component: ComingSoon, props: { title: 'Blog' } },
  { path: '/kienthuc', component: ComingSoon, props: { title: 'Kiến thức' } },
  { path: '/blog/:id', component: ComingSoon, props: { title: 'Blog Detail' } },

  // Cart & Checkout - Cart converted ✅
  { path: '/giohang', component: () => import('./views/Cart.vue') },
  { path: '/cart', component: () => import('./views/Cart.vue') },
  { path: '/checkout', component: () => import('./views/Checkout.vue') }, // ✅ Now converted!
  { path: '/payment', component: () => import('./views/Payment.vue') }, // Was Pay.vue
  { path: '/checkout-success', component: () => import('./views/CheckoutSuccess.vue') }, // Was Checkout-success.vue

  // Auth - Using ComingSoon wrapper (Register renamed)
  { path: '/login', component: () => import('./views/Login.vue') },
  { path: '/register', component: () => import('./views/Register.vue') }, // Was ĐkiTk.vue
  { path: '/dangky', component: () => import('./views/Register.vue') },

  // User Profile
  { path: '/profile', component: () => import('./views/Profile.vue') },

  // About/Introduction
  { path: '/gioithieu', component: () => import('./views/Home.vue') },

  // Error pages
  { path: '/403', component: () => import('./views/error/403.vue') }, // Moved to error/
  { path: '/:pathMatch(.*)*', component: () => import('./views/error/404.vue') }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

axios.defaults.baseURL = '/api'
axios.defaults.withCredentials = true

const app = createApp(App)
app.use(router)
app.config.globalProperties.$axios = axios
app.mount('#app')
