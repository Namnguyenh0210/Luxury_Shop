<template>
  <AdminLayout page-title="Báo Cáo & Thống Kê">
    <div class="p-8 space-y-8">

      <!-- STAT CARDS -->
      <div class="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
        <div v-for="stat in stats" :key="stat.label"
          class="flex flex-col gap-2 rounded-2xl p-6 border border-gray-200 bg-white shadow-sm">
          <div class="flex items-center justify-between">
            <p class="text-gray-500 text-sm font-medium">{{ stat.label }}</p>
            <div class="flex items-center justify-center size-10 rounded-xl" :style="{ background: stat.iconBg }">
              <span class="material-symbols-outlined text-[22px]" :style="{ color: stat.iconColor }">{{ stat.icon }}</span>
            </div>
          </div>
          <p class="text-2xl font-extrabold text-gray-900">{{ stat.value }}</p>
        </div>
      </div>

      <!-- CHARTS ROW -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">

        <!-- Revenue Chart -->
        <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h3 class="font-bold text-gray-800">Doanh Thu 7 Ngày</h3>
              <p class="text-xs text-gray-400 mt-0.5">Thống kê theo ngày gần nhất</p>
            </div>
            <span class="material-symbols-outlined text-yellow-600 text-2xl">show_chart</span>
          </div>
          <canvas ref="revenueChart" height="200"></canvas>
        </div>

        <!-- Category Pie Chart -->
        <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h3 class="font-bold text-gray-800">Tỷ Trọng Danh Mục</h3>
              <p class="text-xs text-gray-400 mt-0.5">Phân bố doanh thu theo danh mục</p>
            </div>
            <span class="material-symbols-outlined text-yellow-600 text-2xl">donut_large</span>
          </div>
          <canvas ref="categoryChart" height="200"></canvas>
        </div>

      </div>
    </div>
  </AdminLayout>
</template>

<script>
import AdminLayout from './AdminLayout.vue'
import axios from 'axios'
import { Chart } from 'chart.js/auto'

export default {
  name: 'ReportAnalytics',
  components: { AdminLayout },

  data() {
    return {
      totalRevenue: 0,
      newOrders: 0,
      soldProducts: 0,
      totalCustomers: 0,
      chartLabels: [],
      chartData: [],
      categoryData: []
    }
  },

  computed: {
    stats() {
      return [
        { label: 'Tổng Doanh Thu',   icon: 'payments',       iconBg: '#fef9c3', iconColor: '#a16207', value: this.fmtMoney(this.totalRevenue) },
        { label: 'Đơn Hàng Mới',     icon: 'receipt_long',   iconBg: '#dbeafe', iconColor: '#1d4ed8', value: this.newOrders },
        { label: 'Sản Phẩm Đã Bán',  icon: 'shopping_bag',   iconBg: '#dcfce7', iconColor: '#15803d', value: this.soldProducts },
        { label: 'Tổng Khách Hàng',  icon: 'group',           iconBg: '#fce7f3', iconColor: '#be185d', value: this.totalCustomers },
      ]
    }
  },

  methods: {
    fmtMoney(v) {
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(v || 0)
    },

	async loadData() {
	  try {
	    const res = await axios.get(
	      'http://localhost:8080/api/admin/reports',
	      { withCredentials: true }
	    )

	    this.totalRevenue   = res.data.totalRevenue
	    this.newOrders      = res.data.newOrders
	    this.soldProducts   = res.data.soldProducts
	    this.totalCustomers = res.data.totalCustomers

	    this.chartLabels = res.data.chartLabels
	    this.chartData   = res.data.chartData

	    this.categoryData = {
	      labels: ['Áo', 'Quần', 'Giày', 'Phụ kiện'],
	      data: [30, 25, 20, 25]
	    }

	    this.$nextTick(() => {
	      this.renderRevenueChart()
	      this.renderCategoryChart()
	    })

	  } catch (e) {
	    console.error(e)
	  }
	},

    renderRevenueChart() {
      new Chart(this.$refs.revenueChart, {
        type: 'line',
        data: {
          labels: this.chartLabels,
          datasets: [{
            label: 'Doanh thu (đ)',
            data: this.chartData,
            borderColor: '#d97706',
            backgroundColor: 'rgba(217,119,6,0.08)',
            fill: true,
            tension: 0.4,
            pointBackgroundColor: '#d97706',
            pointRadius: 4
          }]
        },
        options: {
          responsive: true,
          plugins: { legend: { display: false } },
          scales: { y: { beginAtZero: true, grid: { color: '#f3f4f6' } }, x: { grid: { display: false } } }
        }
      })
    },

    renderCategoryChart() {
      new Chart(this.$refs.categoryChart, {
        type: 'doughnut',
        data: {
          labels: this.categoryData.labels || [],
          datasets: [{
            data: this.categoryData.data || [],
            backgroundColor: ['#d97706','#3b82f6','#10b981','#8b5cf6','#ef4444','#f59e0b'],
            borderWidth: 0
          }]
        },
        options: {
          responsive: true,
          plugins: { legend: { position: 'bottom', labels: { padding: 16, font: { size: 12 } } } },
          cutout: '65%'
        }
      })
    }
  },

  mounted() { this.loadData() }
}
</script>