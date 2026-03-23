import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import App from './App.vue'
import axios from 'axios'

// Import global styles (font + margin)
import './assets/css/global.css'
import './utils/modal.js'

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
  { path: '/dang-ky', component: () => import('./views/Register.vue') },
  { path: '/forgot-password', component: () => import('./views/ForgotPassword.vue') },
  { path: '/verify-otp', component: () => import('./views/VerifyOtp.vue') },
  { path: '/reset-password', component: () => import('./views/ResetPassword.vue') },

  // User Profile
  { path: '/profile', component: () => import('./views/Profile.vue') },
  { path: '/profile/orders/:id', component: () => import('./views/OrderDetailUser.vue') },

  // About/Introduction
  { path: '/gioithieu', component: () => import('./views/Home.vue') },

  // AI Chat Redirect - To avoid 404 and trigger widget
  { 
    path: '/chat', 
    redirect: '/', 
    beforeEnter: (to, from, next) => {
      next('/');
      setTimeout(() => window.dispatchEvent(new Event('open-chat')), 500);
    } 
  },

  // Error pages
  { path: '/403', component: () => import('./views/error/403.vue') }, // Moved to error/
  { path: '/:pathMatch(.*)*', component: () => import('./views/error/404.vue') },
  // Admin - Nested Routes with Persistent Layout
  {
    path: '/admin',
    component: () => import('./views/admin/AdminLayout.vue'),
    redirect: '/admin/dashboard',
    children: [
      { path: 'dashboard', component: () => import('./views/admin/admin.vue'), meta: { title: 'Tổng Quan' } },
      { path: 'products', component: () => import('./views/admin/product-list.vue'), meta: { title: 'Sản Phẩm' } },
      { path: 'products/add', component: () => import('./views/admin/AddProduct.vue'), meta: { title: 'Thêm Sản Phẩm' } },
      { path: 'products/edit/:id', component: () => import('./views/admin/EditProduct.vue'), meta: { title: 'Sửa Sản Phẩm' } },
      { path: 'inventory', component: () => import('./views/admin/inventory.vue'), meta: { title: 'Kho & Nhập Hàng' } },
      { path: 'vouchers', component: () => import('./views/admin/voucher-list.vue'), meta: { title: 'Mã giảm giá' } },
      { path: 'orders', component: () => import('./views/admin/order-list.vue'), meta: { title: 'Đơn Hàng' } },
      { path: 'orders/:id', component: () => import('./views/admin/order-detail.vue'), meta: { title: 'Chi Tiết Đơn Hàng' } },
      { path: 'customers', component: () => import('./views/admin/customer-list.vue'), meta: { title: 'Người Dùng' } },
      { path: 'blogs', component: () => import('./views/admin/blog-list.vue'), meta: { title: 'Bài Viết Blog' } },
      { path: 'reviews', component: () => import('./views/admin/reviews.vue'), meta: { title: 'Đánh Giá' } },
      { path: 'comments', component: () => import('./views/admin/comments.vue'), meta: { title: 'Phản Hồi' } },
      { path: 'reports', component: () => import('./views/admin/report-analytics.vue'), meta: { title: 'Thống Kê' } },
      { path: 'chat', component: () => import('./views/admin/admin-chat.vue'), meta: { title: 'Chat Trực Tuyến' } },
    ]
  },
  // Staff fallback to admin layout too
  {
    path: '/staff',
    component: () => import('./views/admin/AdminLayout.vue'),
    redirect: '/staff/dashboard',
    children: [
      { path: 'dashboard', component: () => import('./views/admin/admin.vue'), meta: { title: 'Tổng Quan' } },
      { path: 'blogs', component: () => import('./views/admin/blog-list.vue'), meta: { title: 'Bài Viết Blog' } },
      { path: 'orders', component: () => import('./views/admin/order-list.vue'), meta: { title: 'Đơn Hàng' } },
      { path: 'orders/:id', component: () => import('./views/admin/order-detail.vue'), meta: { title: 'Chi Tiết Đơn Hàng' } },
      { path: 'chat', component: () => import('./views/admin/admin-chat.vue'), meta: { title: 'Chat Trực Tuyến' } },
    ]
  },
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
