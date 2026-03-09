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

  // Blog - Kết nối DB thật ✅
  { path: '/blog', component: () => import('./views/BlogPage.vue') },
  { path: '/kienthuc', component: () => import('./views/BlogPage.vue') },
  { path: '/blog/:id', component: () => import('./views/BlogDetail.vue') },
  { path: '/kienthuc/:id', component: () => import('./views/BlogDetail.vue') },

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
  { path: '/:pathMatch(.*)*', component: () => import('./views/error/404.vue') },
  { path: '/admin/dashboard', component: () => import('./views/admin/admin.vue') },
  { path: '/admin/products', component: () => import('./views/admin/product-list.vue') },
  { path: '/admin/products/edit/:id', component: () => import('./views/admin/EditProduct.vue') },
  { path: '/admin/inventory', component: () => import('./views/admin/inventory.vue') },
  { path: '/admin/orders', component: () => import('./views/admin/order-list.vue') },
  { path: '/admin/orders/:id', component: () => import('./views/admin/order-detail.vue') },
  { path: '/admin/customers', component: () => import('./views/admin/customer-list.vue') },
  { path: '/admin/blogs', component: () => import('./views/admin/blog-list.vue') },
  { path: '/admin/reports', component: () => import('./views/admin/report-analytics.vue') },
  { path: '/staff/dashboard', component: () => import('./views/staff/StaffDashboard.vue') },
  { path: '/staff/blogs', component: () => import('./views/staff/StaffBaiViet.vue') },
  { path: '/staff/orders', component: () => import('./views/staff/StaffOrders.vue') },
  { path: '/staff/orders/:id', component: () => import('./views/staff/StaffOrderDetail.vue') },
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
