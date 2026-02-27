<template>
  <div class="relative flex min-h-screen w-full flex-col bg-background-light text-text-primary-light font-display">

    <AppHeader />

    <main class="flex-grow">

      <!-- Hero -->
      <div class="container mx-auto p-6 lg:p-10">
        <div
            class="flex min-h-[40vh] flex-col items-center justify-center rounded-lg bg-cover bg-center text-center"
            style="background-image: linear-gradient(rgba(0,0,0,.3), rgba(0,0,0,.6)), url('https://images.unsplash.com/photo-1441986300917-64674bd600d8');"
        >
          <h1 class="font-serif text-4xl md:text-6xl text-white font-bold">
            Staff Dashboard
          </h1>
          <p class="mt-4 text-white/90 text-lg">
            Manage orders. Handle content. Support operations.
          </p>
        </div>
      </div>

      <!-- Stats -->
      <div class="container mx-auto px-6 py-16">
        <h2 class="text-center font-serif text-3xl font-bold md:text-4xl">
          Daily Overview
        </h2>

        <div class="mt-10 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">

          <div class="rounded-lg border p-8 text-center shadow-sm hover:shadow-md transition">
            <h3 class="text-sm uppercase tracking-widest text-gray-500">Total Orders</h3>
            <p class="mt-4 text-2xl font-semibold">
              {{ orderCount }}
            </p>
          </div>

          <div class="rounded-lg border p-8 text-center shadow-sm hover:shadow-md transition">
            <h3 class="text-sm uppercase tracking-widest text-gray-500">Pending Orders</h3>
            <p class="mt-4 text-2xl font-semibold">
              {{ pendingCount }}
            </p>
          </div>

          <div class="rounded-lg border p-8 text-center shadow-sm hover:shadow-md transition">
            <h3 class="text-sm uppercase tracking-widest text-gray-500">My Posts</h3>
            <p class="mt-4 text-2xl font-semibold">
              {{ myPostCount }}
            </p>
          </div>

        </div>
      </div>

      <!-- Recent Orders -->
      <div class="container mx-auto px-6 pb-16">
        <h2 class="font-serif text-2xl font-bold mb-6">Recent Pending Orders</h2>

        <div class="overflow-x-auto rounded-lg border">
          <table class="min-w-full text-sm">
            <thead class="bg-gray-100">
            <tr>
              <th class="px-4 py-3 text-left">Order ID</th>
              <th class="px-4 py-3 text-left">Customer</th>
              <th class="px-4 py-3 text-left">Total</th>
              <th class="px-4 py-3 text-left">Status</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="order in recentOrders" :key="order.maDH" class="border-t">
              <td class="px-4 py-3">{{ order.maDH }}</td>
              <td class="px-4 py-3">{{ order.taiKhoan?.hoTen }}</td>
              <td class="px-4 py-3">{{ order.tongTien?.toLocaleString() }} ₫</td>
              <td class="px-4 py-3">Pending</td>
            </tr>
            </tbody>
          </table>
        </div>
      </div>

    </main>

    <AppFooter />

  </div>
</template>

<script>
import axios from 'axios'
import AppHeader from '../fragments/AppHeader.vue'
import AppFooter from '../fragments/AppFooter.vue'

export default {
  name: 'StaffDashboard',
  components: { AppHeader, AppFooter },
  data() {
    return {
      orderCount: 0,
      pendingCount: 0,
      myPostCount: 0,
      recentOrders: []
    }
  },
  async mounted() {
    try {
      const res = await axios.get('/staff/dashboard')
      this.orderCount = res.data.orderCount
      this.pendingCount = res.data.pendingCount
      this.myPostCount = res.data.myPostCount
      this.recentOrders = res.data.recentOrders
    } catch (err) {
      console.error("Staff dashboard error", err)
    }
  }
}
</script>

<style scoped>
h1, h2 {
  font-family: 'Playfair Display', serif;
}
</style>