<template>
  <div class="p-8 space-y-8">

    <!-- Loading -->
    <div v-if="loading" class="flex items-center justify-center h-60 text-gray-400">
      <span class="material-symbols-outlined text-5xl animate-spin">progress_activity</span>
    </div>

    <template v-else>
      <!-- STAT CARDS -->
      <div class="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
        <div
          v-for="stat in stats"
          :key="stat.label"
		  @click="$router.push(stat.route)"
          class="flex flex-col gap-2 rounded-2xl p-6 border border-[#C8A97E] bg-white shadow-sm hover:shadow-md transition-shadow"
        >
          <div class="flex items-center justify-between">
            <p class="text-gray-500 text-sm font-medium">{{ stat.label }}</p>
            <div class="flex items-center justify-center size-10 rounded-xl text-[#C8A97E]" :style="{ background: stat.iconBg }">
              <span class="material-symbols-outlined text-[22px]">{{ stat.icon }}</span>
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
            class="flex flex-col gap-4 rounded-2xl p-6 border border-[#C8A97E] bg-white hover:shadow-lg hover:-translate-y-1 transition-all duration-300 cursor-pointer group"
            @click="$router.push(module.to)"
          >
            <div class="flex items-center gap-4">
              <div class="flex items-center justify-center size-12 rounded-xl bg-[#C8A97E]/10 text-[#C8A97E] group-hover:bg-[#C8A97E]/20 transition-colors">
                <span class="material-symbols-outlined text-2xl">{{ module.icon }}</span>
              </div>
              <h4 class="text-base font-bold text-gray-900">{{ module.title }}</h4>
            </div>
            <p class="text-gray-500 text-sm leading-relaxed">{{ module.desc }}</p>
            <div class="mt-auto flex items-center gap-1 text-sm font-semibold text-[#C8A97E] group-hover:gap-2 transition-all">
              <span>Truy cập</span>
              <span class="material-symbols-outlined text-base">arrow_forward</span>
            </div>
          </div>
        </div>
      </div>
    </template>

  </div>
</template>

<script>
import axios from 'axios'
import { authState } from '@/utils/auth'

export default {
  name: 'AdminDashboardPage',

  data() {
    return {
      loading: true,
      totalRevenue: 0,
      newOrdersCount: 0,
      uniqueVisitors: 0,
      totalCustomers: 0,

      allModules: [
        { to: '/admin/products',  icon: 'diamond',      title: 'Quản Lý Sản Phẩm',    desc: 'Thêm mới, chỉnh sửa, và quản lý tất cả sản phẩm.' },
        { to: '/admin/inventory', icon: 'inventory_2',  title: 'Kho & Nhà Cung Cấp',  desc: 'Quản lý tồn kho, nhà cung cấp và nhập hàng.' },
        { to: '/admin/orders',    icon: 'receipt_long', title: 'Quản Lý Đơn Hàng',    desc: 'Xem và xử lý các đơn hàng của khách hàng.' },
        { to: '/admin/customers', icon: 'group',        title: 'Khách Hàng & KM',      desc: 'Quản lý thông tin khách hàng và chiến dịch marketing.', roles: ['ADMIN'] },
        { to: '/admin/blogs',     icon: 'article',      title: 'Nội Dung & Tương Tác', desc: 'Quản lý bài viết blog, banner và các trang tĩnh.' },
        { to: '/admin/reports',   icon: 'bar_chart',    title: 'Báo Cáo & Thống Kê',   desc: 'Xem các báo cáo chi tiết về hoạt động kinh doanh.', roles: ['ADMIN'] },
      ]
    }
  },

  computed: {
    currentUser() {
      return authState.user || { roles: [] }
    },
    stats() {
      const isAdmin = this.currentUser.roles.includes('ADMIN')
      const list = [
        { label: 'Tổng Doanh Thu',   icon: 'payments',     iconBg: '#fef9c3', value: this.fmtCurrency(this.totalRevenue),    trend: '+100% vs tháng trước', trendColor: 'text-green-600', role: 'ADMIN', route: '/admin/reports' },
        { label: 'Đơn Chờ Xử Lý',   icon: 'pending_actions', iconBg: '#dbeafe', value: this.newOrdersCount,                  trend: 'Cần duyệt ngay',       trendColor: 'text-blue-600', route: '/admin/orders'  },
        { label: 'Lượt Truy Cập',    icon: 'bar_chart',    iconBg: '#dcfce7', value: this.fmtNumber(this.uniqueVisitors),    trend: '+5.4% tháng này',      trendColor: 'text-green-600', role: 'ADMIN', route: '/admin/reports' },
        { label: 'Tổng Khách Hàng',  icon: 'group',        iconBg: '#fce7f3', value: this.totalCustomers,                     trend: '+12 người mới',        trendColor: 'text-green-600', role: 'ADMIN', route: '/admin/customers' },
      ]
      return list.filter(item => !item.role || (item.role === 'ADMIN' && isAdmin))
    },
    modules() {
      const isAdmin = this.currentUser.roles.includes('ADMIN')
      return this.allModules.filter(item => {
        if (!item.roles) return true
        return item.roles.includes('ADMIN') ? isAdmin : true
      })
    }
  },

  async mounted() {
    try {
      // Load dashboard stats
      if (this.currentUser.roles.includes('ADMIN')) {
        const res = await axios.get('/admin/reports', { withCredentials: true })
        this.totalRevenue   = res.data.totalRevenue   || 0
        this.newOrdersCount = res.data.newOrders || 0
        this.uniqueVisitors = res.data.uniqueVisitors || 0
        this.totalCustomers = res.data.totalCustomers || 0
      } else {
        try {
          const res = await axios.get('/admin/reports', { withCredentials: true })
          this.newOrdersCount = res.data.newOrders || 0
        } catch { /* ignore */ }
      }
    } catch (e) {
      console.error('Dashboard error:', e)
    } finally {
      this.loading = false
    }
  },

  methods: {
    fmtCurrency(v) { return new Intl.NumberFormat('vi-VN').format(v) + ' đ' },
    fmtNumber(v)   { return new Intl.NumberFormat('vi-VN').format(v) }
  }
}

</script>