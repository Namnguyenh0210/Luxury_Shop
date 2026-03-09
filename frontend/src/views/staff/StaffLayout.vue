<template>
  <div class="relative flex min-h-screen w-full flex-col bg-gray-50">
    <div class="flex h-full w-full grow">

      <!-- ====== SIDEBAR ====== -->
      <aside class="flex h-screen w-64 flex-col justify-between border-r border-gray-200 bg-white p-4 sticky top-0 z-20 shadow-sm">
        <div class="flex flex-col gap-8">

          <!-- Logo -->
          <div class="flex items-center gap-3 px-3 py-2">
            <div class="flex items-center justify-center size-9 rounded-lg bg-blue-600 text-white">
              <span class="material-symbols-outlined text-xl">badge</span>
            </div>
            <div>
              <p class="text-sm font-extrabold text-gray-900 tracking-wide">LUXURY</p>
              <p class="text-[10px] text-blue-600 uppercase tracking-widest font-semibold">Staff Panel</p>
            </div>
          </div>

          <!-- User Info -->
          <div class="flex items-center gap-3 px-3 py-2 rounded-xl bg-gray-50 border border-gray-100">
            <div class="size-9 rounded-full bg-blue-700 text-white flex items-center justify-center font-bold text-base uppercase flex-shrink-0">
              {{ userInitial }}
            </div>
            <div class="flex flex-col overflow-hidden">
              <p class="text-sm font-semibold text-gray-800 truncate">{{ staffUser.name || 'Nhân Viên' }}</p>
              <p class="text-xs text-blue-500 truncate font-medium">{{ staffUser.role || 'ROLE_NHANVIEN' }}</p>
            </div>
          </div>

          <!-- Nav — chỉ có các chức năng được phép -->
          <nav class="flex flex-col gap-1">
            <router-link
              v-for="item in navItems"
              :key="item.to"
              :to="item.to"
              class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition-all duration-200 text-gray-600 hover:bg-blue-50 hover:text-blue-800 group"
              active-class="bg-blue-50 text-blue-800 font-semibold shadow-sm"
            >
              <span class="material-symbols-outlined text-[20px]">{{ item.icon }}</span>
              {{ item.label }}
            </router-link>

            <!-- Divider + Locked Features -->
            <div class="mt-3 pt-3 border-t border-gray-100">
              <p class="px-3 pb-2 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Không có quyền</p>
              <div
                v-for="item in lockedItems"
                :key="item.label"
                class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium text-gray-300 cursor-not-allowed select-none"
                :title="'Chức năng này chỉ dành cho Admin'"
              >
                <span class="material-symbols-outlined text-[20px]">{{ item.icon }}</span>
                <span>{{ item.label }}</span>
                <span class="ml-auto material-symbols-outlined text-[14px] text-gray-300">lock</span>
              </div>
            </div>
          </nav>
        </div>

        <!-- Logout -->
        <div class="px-1 pb-2">
          <div class="border-t border-gray-100 pt-3">
            <button
              @click="logout"
              class="flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium text-red-500 hover:bg-red-50 transition-all duration-200"
            >
              <span class="material-symbols-outlined text-[20px]">logout</span>
              Đăng xuất
            </button>
          </div>
        </div>
      </aside>

      <!-- ====== MAIN AREA ====== -->
      <main class="flex flex-1 flex-col min-w-0">

        <!-- Header -->
        <header class="sticky top-0 z-10 flex items-center justify-between whitespace-nowrap border-b border-gray-200 px-8 py-3 bg-white/90 backdrop-blur-sm shadow-sm">
          <div class="flex items-center gap-3">
            <h2 class="text-base font-bold text-gray-800 tracking-tight">{{ pageTitle }}</h2>
          </div>
          <div class="flex items-center gap-2">
            <button class="flex h-9 w-9 items-center justify-center rounded-xl hover:bg-gray-100 text-gray-500 transition-colors relative">
              <span class="material-symbols-outlined text-[20px]">notifications</span>
            </button>
            <div class="size-9 rounded-full bg-slate-200 overflow-hidden border-2 border-blue-400 cursor-pointer">
              <img
                :src="`https://ui-avatars.com/api/?name=${encodeURIComponent(staffUser.name || 'Staff')}&background=1d4ed8&color=fff`"
                :alt="staffUser.name || 'Staff'"
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
  name: 'StaffLayout',

  props: {
    pageTitle: {
      type: String,
      default: 'Staff Panel'
    }
  },

  data() {
    return {
      staffUser: { name: '', role: '' },

      // Nav items mà nhân viên được phép
      navItems: [
        { to: '/staff/dashboard', icon: 'dashboard',    label: 'Dashboard'    },
        { to: '/staff/orders',    icon: 'receipt_long', label: 'Đơn Hàng'    },
        { to: '/staff/chat',      icon: 'support_agent',label: 'Hỗ Trợ Online'},
        { to: '/staff/blogs',     icon: 'article',      label: 'Bài Viết'    },
      ],

      // Chức năng bị khóa — chỉ hiển thị để nhân viên biết
      lockedItems: [
        { icon: 'group',    label: 'Tài Khoản'         },
        { icon: 'bar_chart', label: 'Báo Cáo & Thống Kê' },
      ]
    }
  },

  computed: {
    userInitial() {
      return this.staffUser.name ? this.staffUser.name.charAt(0).toUpperCase() : 'S'
    }
  },

  async created() {
    try {
      const res = await axios.get('/staff/dashboard', { withCredentials: true })
      this.staffUser = res.data.user || { name: 'Nhân Viên', role: 'ROLE_NHANVIEN' }
    } catch {
      this.staffUser = { name: 'Nhân Viên', role: 'ROLE_NHANVIEN' }
    }
  },

  methods: {
    logout() {
      window.location.href = '/logout'
    }
  }
}
</script>
