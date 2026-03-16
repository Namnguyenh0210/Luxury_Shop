<template>
  <div class="relative flex min-h-screen w-full flex-col bg-gray-50">
    <div class="flex h-full w-full grow">

      <!-- ====== SIDEBAR ====== -->
      <aside class="flex h-screen w-64 flex-col border-r border-gray-200 bg-white sticky top-0 z-20 shadow-sm">
        <!-- Scrollable Top Area -->
        <div class="flex-1 overflow-y-auto p-4 custom-scrollbar">
          <div class="flex flex-col gap-8">

            <div class="flex items-center gap-3 px-3 py-2">
              <div class="flex items-center justify-center size-9 rounded-lg bg-yellow-600 text-white shadow-sm">
                <span class="material-symbols-outlined text-xl">diamond</span>
              </div>
              <div>
                <p class="text-sm font-extrabold text-gray-900 tracking-wide">LUXURY</p>
                <p class="text-[10px] text-gray-400 uppercase tracking-widest">Admin Panel</p>
              </div>
            </div>

            <div class="flex items-center gap-3 px-3 py-2 rounded-xl bg-gray-50 border border-gray-100">
              <div class="size-9 rounded-full bg-slate-800 text-white flex items-center justify-center font-bold text-base uppercase flex-shrink-0">
                {{ userInitial }}
              </div>
              <div class="flex flex-col overflow-hidden">
                <p class="text-sm font-semibold text-gray-800 truncate">{{ adminUser.name || 'Admin User' }}</p>
                <p class="text-xs text-gray-400 truncate">{{ adminUser.role || 'ROLE_ADMIN' }}</p>
              </div>
            </div>

            <nav class="flex flex-col gap-1">
              <template v-for="item in navItems" :key="item.label">
                <!-- Category Header -->
                <p v-if="item.isHeader" class="px-3 pb-2 pt-4 text-[10px] font-bold text-gray-400 uppercase tracking-widest first:pt-0">
                  {{ item.label }}
                </p>

                <!-- Action button -->
                <button
                  v-else-if="item.isAction"
                  @click="item.action"
                  class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition-all duration-200 text-gray-600 hover:bg-yellow-50 hover:text-yellow-800 group w-full text-left"
                >
                  <span class="material-symbols-outlined text-[20px]">{{ item.icon }}</span>
                  {{ item.label }}
                </button>

                <!-- Regular Link -->
                <router-link
                  v-else
                  :to="item.to"
                  class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition-all duration-200 text-gray-600 hover:bg-yellow-50 hover:text-yellow-800 group"
                  active-class="bg-yellow-50 text-yellow-800 font-semibold shadow-sm"
                >
                  <span class="material-symbols-outlined text-[20px] group-[.router-link-active]:text-yellow-700">{{ item.icon }}</span>
                  {{ item.label }}
                </router-link>
              </template>
            </nav>
          </div>
        </div>

        <!-- Logout Button (Fixed at Bottom) -->
        <div class="p-4 border-t border-gray-100 bg-white">
          <button
            @click="logout"
            class="flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium text-red-500 hover:bg-red-50 transition-all duration-200"
          >
            <span class="material-symbols-outlined text-[20px]">logout</span>
            Đăng xuất
          </button>
        </div>
      </aside>

      <!-- ====== MAIN AREA ====== -->
      <main class="flex flex-1 flex-col min-w-0">

        <!-- Header -->
        <header class="sticky top-0 z-10 flex h-[84px] items-center justify-between whitespace-nowrap border-b border-gray-200 bg-white/90 backdrop-blur-sm shadow-sm px-8">
          <div class="flex items-center gap-3">
            <!-- Breadcrumb / Page Title -->
            <h2 class="text-base font-bold text-gray-800 tracking-tight">{{ pageTitle }}</h2>
          </div>

          <div class="flex items-center gap-2">
            <button class="flex h-9 w-9 items-center justify-center rounded-xl hover:bg-gray-100 text-gray-500 transition-colors relative">
              <span class="material-symbols-outlined text-[20px]">notifications</span>
              <span class="absolute top-1.5 right-1.5 size-2 rounded-full bg-yellow-500"></span>
            </button>
            <div class="size-9 rounded-full bg-slate-200 overflow-hidden border-2 border-yellow-400 cursor-pointer">
              <img
                :src="`https://ui-avatars.com/api/?name=${encodeURIComponent(adminUser.name || 'Admin')}&background=78350f&color=fff`"
                :alt="adminUser.name || 'Admin'"
              />
            </div>
          </div>
        </header>

        <!-- Page Content -->
        <div class="flex-1 overflow-auto">
          <slot />
        </div>

      </main>
    </div>

  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'AdminLayout',
  components: { },

  props: {
    pageTitle: {
      type: String,
      default: 'Admin'
    }
  },

  data() {
    return {
      adminUser: { name: '', role: '' },
      navItems: [
        { isHeader: true, label: 'Tổng Quan' },
        { to: '/admin/dashboard', icon: 'dashboard',    label: 'Bảng Điều Khiển'  },
        { to: '/admin/reports',   icon: 'bar_chart',    label: 'Báo Cáo Thống Kê'  },

        { isHeader: true, label: 'Kinh Doanh' },
        { to: '/admin/products',  icon: 'diamond',      label: 'Sản Phẩm'  },
        { to: '/admin/orders',    icon: 'receipt_long', label: 'Đơn Hàng'  },
        { to: '/admin/inventory', icon: 'inventory_2',  label: 'Kho & Nhập Hàng' },
        { to: '/admin/reviews',   icon: 'star_rate',    label: 'Đánh Giá' },

        { isHeader: true, label: 'Người Dùng' },
        { to: '/admin/customers', icon: 'person',       label: 'Danh Sách Tài Khoản' },
        { to: '/admin/chat',      icon: 'chat',         label: 'Hỗ Trợ Trực Tuyến' },

        { isHeader: true, label: 'Nội Dung' },
        { to: '/admin/blogs',     icon: 'article',      label: 'Bài Viết Blog'  },
        { to: '/admin/comments',  icon: 'forum',        label: 'Phản Hồi (Blog)' },
      ]
    }
  },

  computed: {
    userInitial() {
      return this.adminUser.name ? this.adminUser.name.charAt(0).toUpperCase() : 'A'
    }
  },

  async created() {
    try {
      const res = await axios.get('/admin/reports', { withCredentials: true })
      this.adminUser = res.data.user || { name: 'Admin', role: 'ROLE_ADMIN' }
    } catch {
      this.adminUser = { name: 'Admin', role: 'ROLE_ADMIN' }
    }
  },

  methods: {
    logout() {
      window.location.href = '/logout'
    }
  }
}
</script>
<style scoped>
/* Custom Scrollbar for Sidebar */
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #e5e7eb;
  border-radius: 10px;
}
.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: #d1d5db;
}
</style>
