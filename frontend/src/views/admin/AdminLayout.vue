<template>
  <div class="relative flex min-h-screen w-full flex-col bg-gray-50">
    <div class="flex h-full w-full grow">

      <!-- ====== SIDEBAR ====== -->
      <aside class="flex h-screen w-64 flex-col border-r border-gray-200 bg-white sticky top-0 z-20 shadow-sm">
        <!-- Scrollable Top Area -->
        <div class="flex-1 overflow-y-auto p-4 custom-scrollbar">
          <div class="flex flex-col gap-8">

            <div class="flex items-center gap-3 px-3 py-2">
              <div class="flex items-center justify-center size-9 rounded-lg bg-[#C8A97E] text-white shadow-sm shadow-[#C8A97E]/20">
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
                  class="flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition-all duration-200 text-gray-600 hover:bg-[#C8A97E]/10 hover:text-[#C8A97E] group"
                  active-class="bg-[#C8A97E]/10 text-[#C8A97E] font-semibold shadow-sm"
                >
                  <span class="material-symbols-outlined text-[20px] group-[.router-link-active]:text-[#C8A97E]">{{ item.icon }}</span>
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
        <header class="sticky top-0 z-40 flex h-[84px] items-center justify-between whitespace-nowrap border-b border-gray-200 bg-white/90 backdrop-blur-sm shadow-sm px-8">
          <div class="flex items-center gap-3">
            <!-- Breadcrumb / Page Title -->
            <h2 class="text-base font-bold text-gray-800 tracking-tight">{{ pageTitle }}</h2>
          </div>

          <div class="flex items-center gap-2">
            <!-- NOTIFICATION CENTER -->
            <div class="relative">
              <button 
                @click.stop="showNoti = !showNoti"
                class="flex h-10 w-10 items-center justify-center rounded-xl bg-gray-50 hover:bg-[#C8A97E]/10 text-gray-400 hover:text-[#C8A97E] transition-all relative group"
              >
                <span class="material-symbols-outlined text-[22px] group-hover:rotate-12 transition-transform">notifications</span>
                <span v-if="unreadCount > 0" class="absolute top-2 right-2 flex size-3 items-center justify-center rounded-full bg-red-500 text-[10px] font-bold text-white shadow-[0_0_10px_rgba(239,68,68,0.5)] border border-white animate-pulse-lux">
                </span>
              </button>

              <!-- Dropdown Menu -->
              <transition name="dropdown">
                <div v-if="showNoti" @click.stop class="absolute right-0 mt-4 w-80 bg-white/95 backdrop-blur-md rounded-3xl shadow-[0_20px_50px_rgba(0,0,0,0.15)] border border-white/20 overflow-hidden z-[100] origin-top-right">
                  <div class="p-5 bg-gradient-to-r from-[#C8A97E]/10 to-transparent border-b border-gray-100 flex justify-between items-center">
                    <h3 class="font-extrabold text-gray-900 text-sm flex items-center gap-2.5">
                      <span class="material-symbols-outlined text-base text-[#C8A97E]">notifications_active</span>
                      THÔNG BÁO MỚI
                    </h3>
                    <span class="text-[9px] bg-[#C8A97E] text-white px-2 py-1 rounded-lg font-black uppercase tracking-widest shadow-sm">{{ unreadCount }} CẦN XỬ LÝ</span>
                  </div>

                  <div class="max-h-[380px] overflow-y-auto custom-scrollbar bg-white/50">
                    <div v-if="notifications.length === 0" class="py-14 text-center text-gray-400">
                      <div class="size-16 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-4 border border-gray-100">
                        <span class="material-symbols-outlined text-3xl opacity-20 text-gray-900">notifications_none</span>
                      </div>
                      <p class="text-[11px] font-bold uppercase tracking-widest opacity-40">Mọi thứ đã gọn gàng</p>
                    </div>
                    
                    <template v-else>
                      <div 
                        v-for="(noti, idx) in notifications" :key="idx"
                        @click="goToNotiLink(noti)"
                        class="p-5 hover:bg-[#C8A97E]/5 cursor-pointer border-b border-gray-50 last:border-0 transition-all flex gap-4 group/item"
                      >
                        <div class="size-11 rounded-2xl flex items-center justify-center shrink-0 shadow-sm group-hover/item:scale-110 transition-transform duration-300" :class="noti.bg">
                          <span class="material-symbols-outlined text-[20px]" :class="noti.color">{{ noti.icon }}</span>
                        </div>
                        <div class="space-y-1.5 overflow-hidden">
                          <p class="text-xs font-black text-gray-900 leading-tight group-hover/item:text-[#C8A97E] transition-colors uppercase tracking-tight">{{ noti.title }}</p>
                          <p class="text-[11px] text-gray-500 line-clamp-2 leading-relaxed font-medium">{{ noti.desc }}</p>
                          <div class="flex items-center gap-2 mt-2">
                             <span class="size-1 rounded-full bg-[#C8A97E]"></span>
                             <p class="text-[9px] text-[#C8A97E] font-black uppercase tracking-wider italic">{{ noti.time }}</p>
                          </div>
                        </div>
                      </div>
                    </template>
                  </div>

                  <div class="py-6 text-center">
                    <span 
                      @click="showNoti = false" 
                      class="text-[10px] font-black text-gray-500 hover:text-[#C8A97E] uppercase tracking-[0.4em] transition-all cursor-pointer select-none hover:tracking-[0.5em] duration-300"
                    >
                      — ĐÓNG THÔNG BÁO —
                    </span>
                  </div>
                </div>
              </transition>
            </div>

            <div class="size-10 rounded-full bg-slate-200 overflow-hidden border-2 border-[#C8A97E] cursor-pointer shadow-sm hover:scale-105 transition-transform">
              <img
                :src="`https://ui-avatars.com/api/?name=${encodeURIComponent(adminUser.name || 'Admin')}&background=78350f&color=fff`"
                :alt="adminUser.name || 'Admin'"
              />
            </div>
          </div>
        </header>

        <!-- Page Content -->
        <div class="flex-1 bg-gray-50/30 overflow-x-hidden min-h-0 relative">
          <router-view v-slot="{ Component }">
            <transition name="page-fade">
              <component :is="Component" :key="$route.fullPath" />
            </transition>
          </router-view>
        </div>

      </main>
    </div>

  </div>
</template>


<script>
import { authState, fetchCurrentUser } from '@/utils/auth'
import axios from 'axios'

export default {
  name: 'AdminLayout',
  components: { },

  data() {
    return {
      showNoti: false,
      unreadCount: 0,
      notifications: [],
      allNavItems: [
        { isHeader: true, label: 'Tổng Quan' },
        { to: '/admin/dashboard', icon: 'dashboard',    label: 'Bảng Điều Khiển'  },
        { to: '/admin/reports',   icon: 'bar_chart',    label: 'Báo Cáo Thống Kê', roles: ['ADMIN']  },

        { isHeader: true, label: 'Kinh Doanh' },
        { to: '/admin/products',  icon: 'diamond',      label: 'Sản Phẩm'  },
        { to: '/admin/orders',    icon: 'receipt_long', label: 'Đơn Hàng'  },
        { to: '/admin/inventory', icon: 'inventory_2',  label: 'Kho & Nhập Hàng' },
        { to: '/admin/vouchers',  icon: 'redeem',       label: 'Khuyến Mãi & Voucher' },
        { to: '/admin/reviews',   icon: 'star_rate',    label: 'Đánh Giá' },

        { isHeader: true, label: 'Người Dùng' },
        { to: '/admin/customers', icon: 'person',       label: 'Danh Sách Tài Khoản', roles: ['ADMIN'] },
        { to: '/admin/chat',      icon: 'chat',         label: 'Hỗ Trợ Trực Tuyến' },

        { isHeader: true, label: 'Nội Dung' },
        { to: '/admin/blogs',     icon: 'article',      label: 'Bài Viết Blog'  },
        { to: '/admin/comments',  icon: 'forum',        label: 'Phản Hồi (Blog)' },
      ]
    }
  },

  computed: {
    pageTitle() {
      return this.$route.meta?.title || 'Quản lý'
    },
    adminUser() {
      return authState.user || { name: 'Admin', role: '...', roles: [] }
    },
    userInitial() {
      return this.adminUser.name ? this.adminUser.name.charAt(0).toUpperCase() : 'A'
    },
    navItems() {
      return this.allNavItems.filter(item => {
        if (!item.roles) return true
        return item.roles.some(role => this.adminUser.roles.includes(role))
      })
    }
  },

  async created() {
    await fetchCurrentUser()
    if (!authState.user && authState.fetched) {
      window.location.href = '/login'
    }
    this.fetchNotifications()
    // Tự động cập nhật mỗi 2 phút
    this.notiInterval = setInterval(this.fetchNotifications, 120000)
    window.addEventListener('click', () => { this.showNoti = false })
  },

  beforeUnmount() {
    clearInterval(this.notiInterval)
  },

  methods: {
    async fetchNotifications() {
      try {
        // Gọi API thống kê để lấy các con số tổng quát
        const res = await axios.get('/admin/reports', { withCredentials: true })
        const stats = res.data
        const newNotis = []

        // 1. Kiểm tra đơn hàng mới (Chờ xác nhận) - Dữ liệu từ Backend
        if (stats.pendingConfirmCount > 0) {
           newNotis.push({
             title: 'ĐƠN HÀNG MỚI',
             desc: `Bạn có ${stats.pendingConfirmCount} đơn hàng mới đang chờ xác nhận từ khách hàng.`,
             icon: 'shopping_cart_checkout',
             bg: 'bg-green-50',
             color: 'text-green-600',
             time: 'CẦN XỬ LÝ',
             link: '/admin/orders'
           })
        }

        // 2. Kiểm tra hoàn tiền (PayOS Cancelled but Paid) - Dữ liệu từ Backend
        if (stats.refundPendingCount > 0) {
            newNotis.push({
              title: 'YÊU CẦU HOÀN TIỀN',
              desc: `Có ${stats.refundPendingCount} đơn hàng PayOS đã hủy nhưng cần bạn hoàn tiền thủ công.`,
              icon: 'account_balance_wallet',
              bg: 'bg-red-50',
              color: 'text-red-500',
              time: 'GẤP',
              link: '/admin/orders?payStatus=5'
            })
        }

        // 3. Kiểm tra sản phẩm sắp hết hàng (Dưới 10 món)
        // Query đơn giản đến API sản phẩm để lấy thông tin kho
        const productRes = await axios.get('/admin/products', { params: { pageSize: 100 }, withCredentials: true })
        if (productRes.data && (productRes.data.content || productRes.data.danhSach)) {
           const list = productRes.data.content || productRes.data.danhSach
           const lowStockItems = list.filter(p => p.totalStock !== undefined && p.totalStock < 10)
           if (lowStockItems.length > 0) {
              newNotis.push({
                 title: 'KHO HÀNG SẮP HẾT',
                 desc: `Có ${lowStockItems.length} sản phẩm trong kho còn dưới 10 món. Hãy kiểm tra lại!`,
                 icon: 'inventory_2',
                 bg: 'bg-orange-50',
                 color: 'text-orange-500',
                 time: 'KIỂM KHO',
                 link: '/admin/products'
              })
           }
        }

        this.notifications = newNotis
        this.unreadCount = newNotis.length
      } catch (e) {
        console.error('Lỗi fetch notifications:', e)
      }
    },

    goToNotiLink(noti) {
      this.showNoti = false
      this.$router.push(noti.link)
    },

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

/* Page Transition */
.page-fade-enter-active,
.page-fade-leave-active {
  transition: all 0.3s ease;
}

.page-fade-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

.page-fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

@keyframes pulse-lux {
  0% { transform: scale(1); box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.7); }
  70% { transform: scale(1.2); box-shadow: 0 0 0 10px rgba(239, 68, 68, 0); }
  100% { transform: scale(1); box-shadow: 0 0 0 0 rgba(239, 68, 68, 0); }
}
.animate-pulse-lux {
  animation: pulse-lux 2s infinite cubic-bezier(0.4, 0, 0.6, 1);
}

/* Dropdown Animation */
.dropdown-enter-active,
.dropdown-leave-active {
  transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.dropdown-enter-from {
  opacity: 0;
  transform: translateY(-20px) scale(0.95);
  filter: blur(10px);
}
.dropdown-leave-to {
  opacity: 0;
  transform: translateY(-10px) scale(0.98);
}
</style>

