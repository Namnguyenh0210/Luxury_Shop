<template>
<header>
    <!-- Top Bar -->
    <div class="bg-[papayawhip]">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex h-10 items-center justify-end text-xs text-text-primary-light/80 dark:text-text-primary-dark/80">
                <div class="flex items-center space-x-4">
                    <a class="flex items-center gap-1.5 hover:text-primary dark:hover:text-white" href="mailto:luxury@fashion.vn">
                        <span class="material-symbols-outlined text-base">mail</span>
                        <span>luxury@fashion.vn</span>
                    </a>
                    <span class="text-secondary">|</span>
                    <a class="flex items-center gap-1.5 hover:text-primary dark:hover:text-white" href="tel:0799191940">
                        <span class="material-symbols-outlined text-base">call</span>
                        <span>Hotline: 079 9191940</span>
                    </a>
                    <span class="hidden sm:inline text-secondary">|</span>
                    <a class="hidden sm:flex items-center gap-1.5 hover:text-primary dark:hover:text-white" href="#">
                        <span class="material-symbols-outlined text-base">handshake</span>
                        <span>Trở thành đối tác</span>
                    </a>
                    <span class="hidden md:inline text-secondary">|</span>
                    <a v-if="isAuthenticated" class="hidden md:flex items-center gap-1.5 hover:text-primary dark:hover:text-white" href="/profile">
                        <span class="material-symbols-outlined text-base">local_shipping</span>
                        <span>Theo Dõi Đơn Hàng</span>
                    </a>
                    <span v-if="!isAuthenticated" class="hidden lg:inline text-secondary">|</span>
                    <a v-if="!isAuthenticated" class="hidden lg:flex items-center gap-1.5 hover:text-primary dark:hover:text-white" href="/login">
                        <span class="material-symbols-outlined text-base">person</span>
                        <span>Đăng Ký / Đăng Nhập</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Header -->
    <div class="border-y border-secondary/50">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex h-24 items-center justify-between gap-4">
                <!-- Logo -->
                <div class="flex items-center">
                    <a href="/">
                        <h1 class="text-4xl font-serif text-text-primary-light dark:text-text-primary-dark hover:text-black dark:hover:text-white transition-colors cursor-pointer">
                            Luxury</h1>
                    </a>
                </div>

                <!-- Navigation -->
                <nav class="hidden lg:flex items-center gap-6">
                    <a class="text-sm font-medium text-text-primary-light dark:text-text-primary-dark hover:text-black dark:hover:text-white" href="/">Home</a>
                    <a class="flex items-center gap-2 text-sm font-medium text-text-primary-light dark:text-text-primary-dark hover:text-black dark:hover:text-white" href="/sanpham">
                        <span class="material-symbols-outlined">menu</span>
                        <span>Sản phẩm</span>
                    </a>
                    <a class="text-sm font-medium text-text-primary-light dark:text-text-primary-dark hover:text-black dark:hover:text-white" href="/nam">Nam</a>
                    <a class="text-sm font-medium text-text-primary-light dark:text-text-primary-dark hover:text-black dark:hover:text-white" href="/nu">Nữ</a>
                    <a class="text-sm font-medium text-text-primary-light dark:text-text-primary-dark hover:text-black dark:hover:text-white" href="/kienthuc">Blog</a>
                </nav>

                <!-- Right Section -->
                <div class="flex flex-1 items-center justify-end gap-2 md:gap-4">
                    <!-- Search Bar -->
                    <div class="hidden md:flex max-w-xs flex-1">
                        <form class="flex w-full" @submit.prevent="handleSearch">
                            <label class="sr-only" for="search-header">Tìm kiếm</label>
                            <input v-model="searchQuery" class="w-full border-r-0 border-secondary bg-transparent py-2 pl-4 text-sm focus:border-accent focus:ring-accent" id="search-header" name="search-header" placeholder="Nhập nội dung..." type="search">
                            <button class="flex items-center justify-center bg-accent px-4 text-sm font-semibold text-text-primary-light hover:bg-accent/90" type="submit">
                                <span class="material-symbols-outlined text-lg mr-1">search</span>
                                <span>Search</span>
                            </button>
                        </form>
                    </div>

                    <!-- Mobile Search -->
                    <button class="flex h-10 w-10 cursor-pointer items-center justify-center rounded-full hover:bg-black/10 dark:hover:bg-white/10 md:hidden">
                        <span class="material-symbols-outlined text-2xl">search</span>
                    </button>

                    <!-- Icons -->
                    <div class="flex items-center gap-2">
                        <!-- Wishlist -->
                        <a class="flex h-10 w-10 cursor-pointer items-center justify-center rounded-full hover:bg-black/10 dark:hover:bg-white/10" href="/profile">
                            <span class="material-symbols-outlined text-2xl">favorite_border</span>
                        </a>

                        <!-- Shopping Cart with badge -->
                        <a class="relative flex items-center gap-2 cursor-pointer hover:text-black dark:hover:text-white p-2 rounded-md hover:bg-black/10 dark:hover:bg-white/10" href="/giohang">
                            <span class="material-symbols-outlined text-2xl">shopping_bag</span>
                            <span class="hidden sm:inline text-sm font-medium">Giỏ Hàng</span>
                            <span v-if="cartCount > 0" class="cart-count absolute -top-1 -right-1 h-5 min-w-[20px] px-1 rounded-full bg-accent text-primary text-[11px] font-bold flex items-center justify-center">{{ cartCount }}</span>
                        </a>

                        <!-- User Avatar Dropdown (Only when authenticated) -->
                        <div v-if="isAuthenticated" class="relative" id="userDropdown">
                            <button @click="toggleUserMenu" class="flex items-center gap-2 cursor-pointer hover:opacity-80 p-1 rounded-full hover:bg-black/10 dark:hover:bg-white/10">
                                <!-- Avatar with fallback -->
                                <div class="h-10 w-10 rounded-full bg-gradient-to-br from-[#D5BFA3] to-[#111111] flex items-center justify-center text-white font-bold text-sm overflow-hidden">
                                    <img v-if="currentUser && currentUser.avatar" :src="currentUser.avatar" :alt="currentUser.hoTen" class="h-full w-full object-cover" @error="handleImageError">
                                    <span v-else class="flex items-center justify-center h-full w-full">{{ userInitial }}</span>
                                </div>
                                <span class="hidden lg:inline text-sm font-medium">{{ userName }}</span>
                                <span class="material-symbols-outlined text-lg">expand_more</span>
                            </button>

                            <!-- Dropdown Menu -->
                            <div v-show="showUserMenu" @click.stop id="userMenu" class="absolute right-0 mt-2 w-72 bg-white dark:bg-gray-800 rounded-lg shadow-xl border border-gray-200 dark:border-gray-700 z-50">
                                <!-- User Info Section -->
                                <div class="p-4 border-b border-gray-200 dark:border-gray-700">
                                    <div class="flex items-center gap-3">
                                        <div class="h-12 w-12 rounded-full bg-gradient-to-br from-[#D5BFA3] to-[#111111] flex items-center justify-center text-white font-bold overflow-hidden">
                                            <img v-if="currentUser && currentUser.avatar" :src="currentUser.avatar" :alt="currentUser.hoTen" class="h-full w-full object-cover" @error="handleImageError">
                                            <span v-else class="flex items-center justify-center h-full w-full">{{ userInitial }}</span>
                                        </div>
                                        <div class="flex-1 min-w-0">
                                            <p class="text-sm font-semibold text-gray-900 dark:text-white truncate">{{ userName }}</p>
                                            <p class="text-xs text-gray-500 dark:text-gray-400 truncate">{{ userEmail }}</p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Menu Items -->
                                <div class="py-2">
                                    <a class="flex items-center gap-3 px-4 py-2.5 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700" href="/profile">
                                        <span class="material-symbols-outlined text-xl">person</span>
                                        <span>Thông tin tài khoản</span>
                                    </a>
                                    <a class="flex items-center gap-3 px-4 py-2.5 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700" href="/profile#orders">
                                        <span class="material-symbols-outlined text-xl">shopping_bag</span>
                                        <span>Đơn hàng của tôi</span>
                                    </a>
                                    <a class="flex items-center gap-3 px-4 py-2.5 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700" href="/profile#wishlist">
                                        <span class="material-symbols-outlined text-xl">favorite</span>
                                        <span>Danh sách yêu thích</span>
                                    </a>
                                    <a class="flex items-center gap-3 px-4 py-2.5 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700" href="/profile#address">
                                        <span class="material-symbols-outlined text-xl">location_on</span>
                                        <span>Địa chỉ giao hàng</span>
                                    </a>

                                    <!-- Admin Dashboard (Only for Admin) -->
                                    <a v-if="isAdmin" class="flex items-center gap-3 px-4 py-2.5 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700 border-t border-gray-200 dark:border-gray-700" href="/admin/dashboard">
                                        <span class="material-symbols-outlined text-xl">admin_panel_settings</span>
                                        <span>Quản trị hệ thống</span>
                                    </a>

                                    <!-- Staff Dashboard (Only for Staff) -->
                                    <a v-if="isStaff" class="flex items-center gap-3 px-4 py-2.5 text-sm text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700 border-t border-gray-200 dark:border-gray-700" href="/staff/dashboard">
                                        <span class="material-symbols-outlined text-xl">badge</span>
                                        <span>Quản lý nhân viên</span>
                                    </a>

                                    <!-- Logout -->
                                    <button @click.stop="handleLogout" onclick="console.log('🟢 INLINE CLICK!')" class="w-full flex items-center gap-3 px-4 py-2.5 text-sm text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 border-t border-gray-200 dark:border-gray-700" type="button">
                                        <span class="material-symbols-outlined text-xl">logout</span>
                                        <span>Đăng xuất</span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

</template>

<script>
export default {
  name: 'AppHeader',
  data() {
    return {
      searchQuery: '',
      showUserMenu: false,
      currentUser: null,
      cartCount: 0,
      isAuthenticated: false
    }
  },
  computed: {
    userName() {
      return this.currentUser?.hoTen || 'User'
    },
    userEmail() {
      return this.currentUser?.email || 'email@example.com'
    },
    userInitial() {
      return this.currentUser?.hoTen?.charAt(0).toUpperCase() || 'U'
    },
    isAdmin() {
      return this.currentUser?.roles?.includes('ADMIN') || false
    },
    isStaff() {
      return this.currentUser?.roles?.includes('NHANVIEN') || false
    }
  },
  methods: {
    toggleUserMenu() {
      this.showUserMenu = !this.showUserMenu
    },
    handleImageError(event) {
      event.target.style.display = 'none'
    },
    handleSearch() {
      if (this.searchQuery.trim()) {
        window.location.href = `/sanpham?search=${encodeURIComponent(this.searchQuery)}`
      }
    },
    async fetchCartCount() {
      try {
        const res = await fetch('/api/cart/count')
        if (res.ok) {
          const data = await res.json()
          this.cartCount = data.count || 0
        }
      } catch (err) {
        console.warn('Không lấy được số lượng giỏ hàng', err)
      }
    },
    async fetchCurrentUser() {
      try {
        // Only fetch if we don't already have user data
        if (this.currentUser !== null) {
          return
        }
        
        const res = await fetch('/api/auth/current-user', {
          credentials: 'include'
        })
        
        if (res.ok) {
          const data = await res.json()
          // Only set authenticated if server confirms authentication
          if (data.authenticated === true) {
            this.currentUser = data
            this.isAuthenticated = true
          } else {
            this.currentUser = null
            this.isAuthenticated = false
          }
        } else {
          this.currentUser = null
          this.isAuthenticated = false
        }
      } catch (err) {
        console.warn('Không lấy được thông tin user', err)
        this.currentUser = null
        this.isAuthenticated = false
      }
    },
    handleClickOutside(event) {
      const dropdown = document.getElementById('userDropdown')
      if (dropdown && !dropdown.contains(event.target)) {
        this.showUserMenu = false
      }
    },
    async handleLogout() {
      console.log('🔴 LOGOUT CLICKED - Starting logout process...')
      
      try {
        // 1. Clear local state FIRST (prevent race conditions)
        this.currentUser = null
        this.isAuthenticated = false
        this.showUserMenu = false
        this.cartCount = 0
        
        console.log('🔴 Local state cleared, calling logout API...')
        
        // 2. Call logout API with credentials and timeout
        const controller = new AbortController()
        const timeoutId = setTimeout(() => controller.abort(), 5000) // 5s timeout
        
        const response = await fetch('/api/auth/logout', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          credentials: 'include',
          signal: controller.signal
        })
        
        clearTimeout(timeoutId)
        console.log('🔴 Logout API response:', response.status, response.ok)
        
        // 3. Force reload regardless of API response
        // Use location.href instead of window.location.replace for cleaner reload
        console.log('🔴 Forcing page reload...')
        window.location.href = '/'
        
      } catch (error) {
        console.error('🔴 Error during logout:', error)
        
        // Even if API fails, clear state and reload
        this.currentUser = null
        this.isAuthenticated = false
        this.showUserMenu = false
        this.cartCount = 0
        
        // Force reload anyway
        window.location.href = '/'
      }
    }
  },
  mounted() {
    // Fetch user data and cart count
    this.fetchCurrentUser()
    this.fetchCartCount()
    
    // Close dropdown when clicking outside
    document.addEventListener('click', this.handleClickOutside)
    
    // Expose refreshCartCount globally for other components
    window.refreshCartCount = this.fetchCartCount
  },
  beforeUnmount() {
    document.removeEventListener('click', this.handleClickOutside)
  }
}
</script>

<style scoped>
/* Header specific styles */
</style>
