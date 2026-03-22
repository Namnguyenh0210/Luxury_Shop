<template>
  <StaffLayout page-title="Dashboard Nhân Viên">
    <div class="p-8 space-y-8">

      <!-- Loading -->
      <div v-if="loading" class="flex items-center justify-center h-60 text-gray-400">
        <span class="material-symbols-outlined text-5xl animate-spin">progress_activity</span>
      </div>

      <template v-else>
        <!-- STAT CARDS -->
        <div class="grid grid-cols-1 gap-5 sm:grid-cols-3">
          <div
            v-for="stat in stats"
            :key="stat.label"
            class="flex flex-col gap-2 rounded-2xl p-6 border border-gray-200 bg-white shadow-sm hover:shadow-md transition-shadow"
          >
            <div class="flex items-center justify-between">
              <p class="text-gray-500 text-sm font-medium">{{ stat.label }}</p>
              <div class="flex items-center justify-center size-10 rounded-xl" :style="{ background: stat.iconBg }">
                <span class="material-symbols-outlined text-[22px]" :style="{ color: stat.iconColor }">{{ stat.icon }}</span>
              </div>
            </div>
            <p class="text-2xl font-extrabold text-gray-900">{{ stat.value }}</p>
            <p class="text-sm font-medium" :class="stat.trendColor">{{ stat.trend }}</p>
          </div>
        </div>

        <!-- QUICK ACCESS -->
        <div>
          <h3 class="text-lg font-bold text-gray-800 mb-5">Truy Cập Nhanh</h3>
          <div class="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
            <div
              v-for="module in modules"
              :key="module.to"
              class="flex flex-col gap-4 rounded-2xl p-6 border border-gray-200 bg-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 cursor-pointer group"
              @click="$router.push(module.to)"
            >
              <div class="flex items-center gap-4">
                <div class="flex items-center justify-center size-12 rounded-xl bg-blue-50 text-blue-700 group-hover:bg-blue-100 transition-colors">
                  <span class="material-symbols-outlined text-2xl">{{ module.icon }}</span>
                </div>
                <h4 class="text-base font-bold text-gray-900">{{ module.title }}</h4>
              </div>
              <p class="text-gray-500 text-sm leading-relaxed">{{ module.desc }}</p>
              <div class="mt-auto flex items-center gap-1 text-sm font-semibold text-blue-700 group-hover:gap-2 transition-all">
                <span>Truy cập</span>
                <span class="material-symbols-outlined text-base">arrow_forward</span>
              </div>
            </div>

            <!-- Locked modules -->
            <div
              v-for="locked in lockedModules"
              :key="locked.label"
              class="flex flex-col gap-4 rounded-2xl p-6 border border-dashed border-gray-200 bg-gray-50 cursor-not-allowed select-none opacity-60"
              :title="'Chỉ Admin mới có quyền'"
            >
              <div class="flex items-center gap-4">
                <div class="flex items-center justify-center size-12 rounded-xl bg-gray-100 text-gray-400">
                  <span class="material-symbols-outlined text-2xl">{{ locked.icon }}</span>
                </div>
                <h4 class="text-base font-bold text-gray-400">{{ locked.title }}</h4>
              </div>
              <p class="text-gray-400 text-sm leading-relaxed">{{ locked.desc }}</p>
              <div class="mt-auto flex items-center gap-1 text-sm font-medium text-gray-400">
                <span class="material-symbols-outlined text-base">lock</span>
                <span>Chỉ dành cho Admin</span>
              </div>
            </div>
          </div>
        </div>

        <!-- RECENT ORDERS TABLE -->
        <div>
          <h3 class="text-lg font-bold text-gray-800 mb-5">Đơn Hàng Gần Đây</h3>
          <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
            <table class="w-full text-sm">
              <thead class="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Mã ĐH</th>
                  <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Khách Hàng</th>
                  <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Tổng Tiền</th>
                  <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Trạng Thái</th>
                  <th class="px-6 py-4 text-right text-xs font-semibold text-gray-500 uppercase tracking-wider">Chi Tiết</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-100">
                <tr v-for="order in recentOrders" :key="order.maDH" class="hover:bg-blue-50/30 transition-colors">
                  <td class="px-6 py-4 font-mono text-xs text-blue-700 font-bold">#{{ order.maDH }}</td>
                  <td class="px-6 py-4 font-medium text-gray-800">{{ order.tenKhach || order.khachHang?.hoTen || '---' }}</td>
                  <td class="px-6 py-4 font-bold text-gray-800">{{ fmtCurrency(order.tongTien) }}</td>
                  <td class="px-6 py-4">
                    <span class="inline-flex items-center px-2.5 py-1 text-xs font-medium rounded-full"
                      :class="statusClass(order.trangThai ?? order.trangThaiDH)">
                      {{ statusText(order.trangThai ?? order.trangThaiDH) }}
                    </span>
                  </td>
                  <td class="px-6 py-4 text-right">
                    <router-link :to="`/staff/orders/${order.maDH}`"
                      class="text-xs font-medium text-blue-700 bg-blue-50 hover:bg-blue-100 px-3 py-1.5 rounded-lg transition-colors inline-flex items-center gap-1">
                      Xem
                      <span class="material-symbols-outlined text-[14px]">arrow_forward</span>
                    </router-link>
                  </td>
                </tr>
              </tbody>
            </table>
            <div v-if="recentOrders.length === 0" class="flex flex-col items-center justify-center py-12 text-gray-400">
              <span class="material-symbols-outlined text-5xl mb-3">receipt_long</span>
              <p class="text-sm">Không có đơn hàng gần đây</p>
            </div>
          </div>
        </div>
      </template>

    </div>
  </StaffLayout>
</template>

<script>
import StaffLayout from './StaffLayout.vue'
import axios from 'axios'

export default {
  name: 'StaffDashboard',
  components: { StaffLayout },

  data() {
    return {
      loading: true,
      orderCount: 0,
      pendingCount: 0,
      myPostCount: 0,
      recentOrders: [],

      modules: [
        { to: '/staff/orders', icon: 'receipt_long', title: 'Quản Lý Đơn Hàng', desc: 'Xem, xác nhận và cập nhật trạng thái đơn hàng của khách.' },
        { to: '/staff/blogs',  icon: 'article',      title: 'Quản Lý Bài Viết', desc: 'Tạo, chỉnh sửa và quản lý bài viết blog của cửa hàng.' },
      ],

      lockedModules: [
        { icon: 'group',    title: 'Tài Khoản',          desc: 'Quản lý tài khoản khách hàng và nhân viên.' },
        { icon: 'bar_chart', title: 'Báo Cáo & Thống Kê', desc: 'Xem các báo cáo chi tiết về hoạt động kinh doanh.' },
      ]
    }
  },

  computed: {
    stats() {
      return [
        { label: 'Tổng Đơn Hàng',   icon: 'receipt_long',     iconBg: '#dbeafe', iconColor: '#1d4ed8', value: this.orderCount,   trend: 'Tất cả đơn',       trendColor: 'text-blue-600'  },
        { label: 'Đơn Chờ Xử Lý',   icon: 'pending_actions',  iconBg: '#fef9c3', iconColor: '#a16207', value: this.pendingCount, trend: 'Cần xử lý ngay',   trendColor: 'text-yellow-600' },
        { label: 'Bài Viết Của Tôi', icon: 'article',          iconBg: '#dcfce7', iconColor: '#15803d', value: this.myPostCount,  trend: 'Bài viết đã đăng', trendColor: 'text-green-600' },
      ]
    }
  },

  async mounted() {
    try {
      const res = await axios.get('/staff/dashboard', { withCredentials: true })
      this.orderCount   = res.data.orderCount   || 0
      this.pendingCount = res.data.pendingCount  || 0
      this.myPostCount  = res.data.myPostCount   || 0
      this.recentOrders = res.data.recentOrders  || []
    } catch (e) {
      console.error('Staff dashboard error:', e)
    } finally {
      this.loading = false
    }
  },

  methods: {
    fmtCurrency(v) { return new Intl.NumberFormat('vi-VN').format(v || 0) + ' đ' },

    statusText(s) {
      return { 0: 'Chờ xác nhận', 1: 'Đã xác nhận', 2: 'Đang giao', 3: 'Hoàn tất', 4: 'Đã hủy' }[s] ?? 'Không xác định'
    },

    statusClass(s) {
      return {
        0: 'bg-yellow-100 text-yellow-700',
        1: 'bg-blue-100  text-blue-700',
        2: 'bg-purple-100 text-purple-700',
        3: 'bg-green-100 text-green-700',
        4: 'bg-red-100   text-red-700'
      }[s] ?? 'bg-gray-100 text-gray-600'
    }
  }
}
</script>
