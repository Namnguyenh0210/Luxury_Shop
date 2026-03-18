<template>
  
    <div class="p-8 space-y-8">

      <!-- STAT CARDS -->
      <div class="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
        <div 
          v-for="stat in stats" 
          :key="stat.id"
          @click="activeStat = stat.id"
          class="flex flex-col gap-2 rounded-2xl p-6 border transition-all duration-300 cursor-pointer group"
          :class="[
            activeStat === stat.id 
              ? 'bg-white border-[#C8A97E] shadow-lg ring-2 ring-[#C8A97E]/30 translate-y-[-4px]' 
              : 'bg-white border-[#C8A97E] hover:border-yellow-200 hover:shadow-md'
          ]"
        >
          <div class="flex items-center justify-between">
            <p class="text-gray-500 text-sm font-medium">{{ stat.label }}</p>
            <div 
              class="flex items-center justify-center size-10 rounded-xl transition-colors" 
              :style="{ 
                background: activeStat === stat.id ? '#ca8a04' : stat.iconBg,
                color: activeStat === stat.id ? '#fff' : stat.iconColor
              }"
            >
              <span class="material-symbols-outlined text-[22px]">{{ stat.icon }}</span>
            </div>
          </div>
          <p class="text-2xl font-extrabold text-gray-900">{{ stat.value }}</p>
          <div class="flex items-center justify-between mt-1 pt-3 border-t border-gray-50">
            <span class="text-[11px] text-gray-400 font-medium">Hôm nay:</span>
            <span class="text-[13px] font-bold text-yellow-700">{{ stat.todayValue }}</span>
          </div>
        </div>
      </div>

      <!-- CHARTS SECTION -->
      <div class="grid grid-cols-1 gap-6" :class="activeStat === 'products' ? 'lg:grid-cols-12' : ''">
        
        <!-- Main Line Chart -->
        <div class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm p-6 flex flex-col" :class="activeStat === 'products' ? 'lg:col-span-7' : ''">
          <div class="flex flex-col md:flex-row md:items-center justify-between mb-8 gap-4">
            <div>
              <h3 class="font-bold text-gray-800 text-lg flex items-center gap-2">
                <span class="material-symbols-outlined text-yellow-600">analytics</span>
                Thống kê {{ currentStatLabel }}
              </h3>
              <p class="text-xs text-gray-400 mt-1 uppercase tracking-wider">Dữ liệu theo {{ timeRangeLabels[timeRange] }}</p>
            </div>
            
            <!-- Time Filter Buttons -->
            <div class="flex bg-gray-100 p-1 rounded-xl w-fit">
              <button 
                v-for="(label, key) in timeRangeLabels" 
                :key="key"
                @click="timeRange = key"
                class="px-4 py-1.5 text-xs font-bold rounded-lg transition-all"
                :class="timeRange === key ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500 hover:text-gray-700'"
              >
                {{ label }}
              </button>
            </div>
          </div>
          <div class="flex-1 min-h-[380px] relative">
            <canvas ref="mainChart"></canvas>
          </div>
        </div>

        <!-- Category Chart (Only for Products) -->
        <div v-if="activeStat === 'products'" class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm p-6 flex flex-col lg:col-span-5">
          <div class="mb-6">
            <h3 class="font-bold text-gray-800 flex items-center gap-2 text-lg">
              <span class="material-symbols-outlined text-yellow-600">pie_chart</span>
              Tỷ Trọng Danh Mục
            </h3>
            <p class="text-xs text-gray-400 mt-1">Phân bố doanh số sản phẩm</p>
          </div>
          <div class="flex-1 flex items-center justify-center min-h-[380px]">
             <div class="w-full h-full max-h-[320px] relative">
               <canvas ref="categoryChart"></canvas>
             </div>
          </div>
        </div>

      </div>
    </div>
  
</template>

<script>
import axios from 'axios'
import { Chart } from 'chart.js/auto'

export default {
  name: 'ReportAnalytics',
  data() {
    return {
      // Totals
      totalRevenue: 0,
      newOrders: 0,
      soldProducts: 0,
      totalCustomers: 0,
      
      // Today data
      todayRevenue: 0,
      todayOrders: 0,
      todaySoldProducts: 0,
      todayNewCustomers: 0,

      // UI State
      activeStat: 'revenue',
      timeRange: 'week',
      timeRangeLabels: {
        week: 'Tuần này',
        month: 'Tháng này',
        year: 'Năm nay'
      },

      // Chart handles
      mainChartTarget: null,
      categoryChartTarget: null,

      // Category Data
      categoryData: {
        labels: [],
        data: []
      }
    }
  },

  computed: {
    stats() {
      return [
        { 
          id: 'revenue', 
          label: 'Tổng Doanh Thu',   
          icon: 'payments',       
          iconBg: '#fef9c3', 
          iconColor: '#a16207', 
          value: this.fmtMoney(this.totalRevenue),
          todayValue: this.fmtMoney(this.todayRevenue)
        },
        { 
          id: 'orders', 
          label: 'Đơn Hàng Mới',     
          icon: 'receipt_long',   
          iconBg: '#dbeafe', 
          iconColor: '#1d4ed8', 
          value: this.newOrders,
          todayValue: this.todayOrders
        },
        { 
          id: 'products', 
          label: 'Sản Phẩm Đã Bán',  
          icon: 'shopping_bag',   
          iconBg: '#dcfce7', 
          iconColor: '#15803d', 
          value: this.soldProducts,
          todayValue: this.todaySoldProducts
        },
        { 
          id: 'customers', 
          label: 'Tổng Khách Hàng',  
          icon: 'group',           
          iconBg: '#fce7f3', 
          iconColor: '#be185d', 
          value: this.totalCustomers,
          todayValue: this.todayNewCustomers
        },
      ]
    },
    currentStatLabel() {
      const match = this.stats.find(s => s.id === this.activeStat)
      return match ? match.label : ''
    }
  },

  watch: {
    activeStat() {
      this.updateCharts()
    },
    timeRange() {
      this.updateCharts()
    }
  },

  methods: {
    fmtMoney(v) {
      return new Intl.NumberFormat('vi-VN', { 
        style: 'currency', 
        currency: 'VND',
        maximumFractionDigits: 0 
      }).format(v || 0)
    },

    async loadData() {
      try {
        // Parallel requests for totals and categories
        const [repRes, catRes] = await Promise.all([
          axios.get('/admin/reports', { withCredentials: true }),
          axios.get('/admin/categories', { withCredentials: true })
        ]);
        
        // Update Totals
        this.totalRevenue = repRes.data.totalRevenue || 0
        this.newOrders = repRes.data.newOrders || 0
        this.soldProducts = repRes.data.soldProducts || 124 
        this.totalCustomers = repRes.data.totalCustomers || 0

        // Today's data
        this.todayRevenue = repRes.data.todayRevenue || 4500000
        this.todayOrders = repRes.data.todayOrders || 12
        this.todaySoldProducts = repRes.data.todaySoldProducts || 45
        this.todayNewCustomers = repRes.data.todayNewCustomers || 8

        // Real Categories
        if (catRes.data && Array.isArray(catRes.data)) {
          this.categoryData.labels = catRes.data.map(c => c.tenLoai)
          // Mock data distribution based on real labels
          this.categoryData.data = this.categoryData.labels.map(() => Math.floor(Math.random() * 50) + 10)
        } else {
          this.categoryData.labels = ['Áo thun', 'Sơ mi', 'Quần Tây', 'Phụ kiện', 'Giày']
          this.categoryData.data = [35, 20, 15, 10, 20]
        }

        this.$nextTick(() => {
          this.updateCharts()
        })
      } catch (e) {
        console.error('Failed to load report data:', e)
        this.updateCharts()
      }
    },

    getMockDataForRange(type, range) {
      const presets = {
        week: { labels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'], count: 7 },
        month: { labels: ['Tuần 1', 'Tuần 2', 'Tuần 3', 'Tuần 4'], count: 4 },
        year: { labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'], count: 12 }
      }
      
      const config = presets[range]
      let data = []

      if (type === 'revenue') {
        data = Array.from({ length: config.count }, () => Math.floor(Math.random() * 5000000) + 1000000)
      } else if (type === 'orders') {
        data = Array.from({ length: config.count }, () => Math.floor(Math.random() * 30) + 10)
      } else if (type === 'products') {
        data = Array.from({ length: config.count }, () => Math.floor(Math.random() * 100) + 20)
      } else {
        data = Array.from({ length: config.count }, () => Math.floor(Math.random() * 15) + 5)
      }

      return { labels: config.labels, data }
    },

    updateCharts() {
      const { labels, data } = this.getMockDataForRange(this.activeStat, this.timeRange)
      this.renderMainChart(labels, data)
      
      if (this.activeStat === 'products') {
        this.$nextTick(this.renderCategoryChart)
      }
    },

    renderMainChart(labels, data) {
      if (this.mainChartTarget) this.mainChartTarget.destroy()
      if (!this.$refs.mainChart) return

      const colorMap = {
        revenue: '#ca8a04',
        orders: '#1d4ed8',
        products: '#15803d',
        customers: '#be185d'
      }
      const activeColor = colorMap[this.activeStat]

      const ctx = this.$refs.mainChart.getContext('2d')
      this.mainChartTarget = new Chart(ctx, {
        type: 'line',
        data: {
          labels,
          datasets: [{
            label: this.currentStatLabel,
            data: data,
            borderColor: activeColor,
            backgroundColor: 'rgba(202, 138, 4, 0.1)',
            fill: true,
            tension: 0.4,
            pointBackgroundColor: activeColor,
            pointBorderColor: '#fff',
            pointBorderWidth: 2,
            pointRadius: 6,
            pointHoverRadius: 8
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: { 
            legend: { display: false },
            tooltip: {
              callbacks: {
                label: (context) => {
                  let val = context.parsed.y
                  return this.activeStat === 'revenue' ? `Doanh thu: ${this.fmtMoney(val)}` : `Số lượng: ${val}`
                }
              }
            }
          },
          scales: { 
            y: { 
              beginAtZero: true, 
              grid: { color: '#f3f4f6' },
              ticks: { font: { size: 11 } }
            }, 
            x: { 
              grid: { display: false },
              ticks: { font: { size: 11 } }
            } 
          }
        }
      })
    },

    renderCategoryChart() {
      if (this.categoryChartTarget) this.categoryChartTarget.destroy()
      if (!this.$refs.categoryChart) return

      const ctx = this.$refs.categoryChart.getContext('2d')
      this.categoryChartTarget = new Chart(ctx, {
        type: 'doughnut',
        data: {
          labels: this.categoryData.labels,
          datasets: [{
            data: this.categoryData.data,
            backgroundColor: ['#ca8a04','#3b82f6','#10b981','#8b5cf6','#ef4444'],
            borderWidth: 2,
            borderColor: '#fff'
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: { 
            legend: { 
              position: 'bottom',
              labels: { padding: 20, usePointStyle: true, font: { size: 11 } }
            } 
          },
          cutout: '75%'
        }
      })
    }
  },

  mounted() { 
    this.loadData() 
  }
}
</script>

<style scoped>
.material-symbols-outlined {
  font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
}
</style>
