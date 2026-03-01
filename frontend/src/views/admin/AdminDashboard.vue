<template>
  <div class="relative flex min-h-screen w-full flex-col">
    <div class="flex h-full w-full grow">

      <!-- SIDEBAR -->
      <aside class="flex h-screen w-64 flex-col justify-between border-r p-4 sticky top-0 bg-white">

        <div class="flex flex-col gap-8">

          <!-- USER INFO -->
          <div class="flex items-center gap-3 px-3">
            <div class="size-10 rounded-full bg-slate-900 text-white flex items-center justify-center font-bold text-lg uppercase">
              {{ userInitial }}
            </div>

            <div class="flex flex-col">
              <h1 class="text-sm font-bold truncate w-32">
                {{ user.name }}
              </h1>
              <p class="text-xs text-gray-500">
                {{ user.role }}
              </p>
            </div>
          </div>

          <!-- NAV -->
          <nav class="flex flex-col gap-2">
            <router-link class="sidebar-link" to="/admin/dashboard">Dashboard</router-link>
            <router-link class="sidebar-link" to="/admin/products">Sản Phẩm</router-link>
            <router-link class="sidebar-link" to="/admin/inventory">Kho & NCC</router-link>
            <router-link class="sidebar-link" to="/admin/orders">Đơn Hàng</router-link>
            <router-link class="sidebar-link" to="/admin/customers">Tài Khoản</router-link>
            <router-link class="sidebar-link" to="/admin/blogs">Nội Dung</router-link>
            <router-link class="sidebar-link" to="/admin/reports">Báo Cáo</router-link>
          </nav>

        </div>
      </aside>

      <!-- MAIN -->
      <main class="flex flex-1 flex-col">

        <!-- HEADER -->
        <header class="sticky top-0 flex items-center justify-between px-10 py-3 bg-white border-b">
          <h2 class="text-lg font-bold">Dashboard Tổng Quan</h2>

          <button @click="logout" class="text-red-500 hover:bg-red-50 p-2 rounded-full">
            Logout
          </button>
        </header>

        <!-- CONTENT -->
        <div class="flex flex-1 flex-col p-10 gap-10">

          <!-- STATS -->
          <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">

            <div class="card">
              <p class="card-title">Tổng Doanh Thu</p>
              <p class="card-value">{{ formatCurrency(totalRevenue) }}</p>
            </div>

            <div class="card">
              <p class="card-title">Đơn Chờ Xử Lý</p>
              <p class="card-value">{{ newOrdersCount }}</p>
            </div>

            <div class="card">
              <p class="card-title">Lượt Truy Cập</p>
              <p class="card-value">{{ formatNumber(uniqueVisitors) }}</p>
            </div>

            <div class="card">
              <p class="card-title">Tổng Khách Hàng</p>
              <p class="card-value">{{ totalCustomers }}</p>
            </div>

          </div>

        </div>
      </main>
    </div>
  </div>
</template>

<script>
import axios from "axios"

export default {
  name: "AdminDashboard",

  data() {
    return {
      totalRevenue: 0,
      newOrdersCount: 0,
      uniqueVisitors: 0,
      totalCustomers: 0,
      user: {
        name: "",
        role: ""
      }
    }
  },

  computed: {
    userInitial() {
      return this.user.name
          ? this.user.name.charAt(0).toUpperCase()
          : "A"
    }
  },

  async mounted() {
    try {
      const res = await axios.get("http://localhost:8080/admin/dashboard-data", {
        withCredentials: true
      })

      this.totalRevenue = res.data.totalRevenue
      this.newOrdersCount = res.data.newOrdersCount
      this.uniqueVisitors = res.data.uniqueVisitors
      this.totalCustomers = res.data.totalCustomers
      this.user = res.data.user

    } catch (error) {
      console.error("Dashboard error:", error)
    }
  },

  methods: {
    formatCurrency(value) {
      return new Intl.NumberFormat("vi-VN").format(value) + " đ"
    },

    formatNumber(value) {
      return new Intl.NumberFormat("vi-VN").format(value)
    },

    logout() {
      window.location.href = "http://localhost:8080/logout"
    }
  }
}
</script>

<style scoped>
.sidebar-link {
  padding: 8px 12px;
  border-radius: 8px;
  color: #666;
  transition: 0.2s;
}
.sidebar-link:hover {
  background: #f5f5f5;
  color: black;
}
.card {
  padding: 24px;
  border-radius: 16px;
  border: 1px solid #eee;
  background: white;
}
.card-title {
  font-size: 14px;
  color: #666;
}
.card-value {
  font-size: 28px;
  font-weight: bold;
}
</style>