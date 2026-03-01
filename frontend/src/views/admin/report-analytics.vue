<template>
  <div class="flex flex-col min-h-screen p-10 bg-gray-50">

    <h1 class="text-2xl font-bold mb-6">Báo Cáo Thống Kê</h1>

    <!-- Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">

      <div class="bg-blue-600 text-white p-6 rounded-xl">
        <p class="text-sm">Tổng Doanh Thu</p>
        <h3 class="text-2xl font-bold mt-2">
          {{ formatMoney(totalRevenue) }}
        </h3>
      </div>

      <div class="bg-white p-6 rounded-xl shadow">
        <p class="text-sm text-gray-500">Đơn hàng mới</p>
        <h3 class="text-2xl font-bold mt-2">
          {{ newOrders }}
        </h3>
      </div>

      <div class="bg-white p-6 rounded-xl shadow">
        <p class="text-sm text-gray-500">Sản phẩm đã bán</p>
        <h3 class="text-2xl font-bold mt-2">
          {{ soldProducts }}
        </h3>
      </div>

      <div class="bg-white p-6 rounded-xl shadow">
        <p class="text-sm text-gray-500">Tổng khách hàng</p>
        <h3 class="text-2xl font-bold mt-2">
          {{ totalCustomers }}
        </h3>
      </div>

    </div>

    <!-- Charts -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">

      <div class="bg-white p-6 rounded-xl shadow">
        <h3 class="font-bold mb-4">Doanh Thu 7 Ngày</h3>
        <canvas ref="revenueChart"></canvas>
      </div>

      <div class="bg-white p-6 rounded-xl shadow">
        <h3 class="font-bold mb-4">Tỷ Trọng Danh Mục</h3>
        <canvas ref="categoryChart"></canvas>
      </div>

    </div>

  </div>
</template>

<script>
import axios from "axios"
import { Chart } from "chart.js/auto"

export default {
  name: "report-analytics",

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

  methods: {
    formatMoney(value) {
      return new Intl.NumberFormat("vi-VN", {
        style: "currency",
        currency: "VND"
      }).format(value)
    },

    loadData() {
      axios.get("/api/reports/overview")
          .then(res => {
            const data = res.data
            this.totalRevenue = data.totalRevenue
            this.newOrders = data.newOrders
            this.soldProducts = data.soldProducts
            this.totalCustomers = data.totalCustomers
          })

      axios.get("/api/reports/revenue-7days")
          .then(res => {
            this.chartLabels = res.data.labels
            this.chartData = res.data.data
            this.renderRevenueChart()
          })

      axios.get("/api/reports/category")
          .then(res => {
            this.categoryData = res.data
            this.renderCategoryChart()
          })
    },

    renderRevenueChart() {
      new Chart(this.$refs.revenueChart, {
        type: "line",
        data: {
          labels: this.chartLabels,
          datasets: [{
            label: "Doanh thu",
            data: this.chartData,
            borderColor: "#2563eb",
            backgroundColor: "rgba(37, 99, 235, 0.1)",
            fill: true,
            tension: 0.4
          }]
        }
      })
    },

    renderCategoryChart() {
      new Chart(this.$refs.categoryChart, {
        type: "doughnut",
        data: {
          labels: this.categoryData.labels,
          datasets: [{
            data: this.categoryData.data
          }]
        }
      })
    }
  },

  mounted() {
    this.loadData()
  }
}
</script>