<template>
  <div class="relative flex min-h-screen w-full flex-col bg-background-light text-text-primary-light font-display">

    <AppHeader />

    <main class="flex-grow">

      <!-- Hero Section -->
      <div class="container mx-auto p-6 lg:p-10">
        <div
            class="flex min-h-[50vh] flex-col items-center justify-center rounded-lg bg-cover bg-center bg-no-repeat text-center"
            style="background-image: linear-gradient(rgba(0,0,0,.3), rgba(0,0,0,.6)), url('https://images.unsplash.com/photo-1521334884684-d80222895322');"
        >
          <h1 class="font-serif text-4xl md:text-6xl text-white font-bold">
            Admin Control Center
          </h1>
          <p class="mt-4 text-white/90 text-lg">
            Monitor performance. Control operations. Elevate your brand.
          </p>
        </div>
      </div>

      <!-- Statistics Section -->
      <div class="container mx-auto px-6 py-16">
        <h2 class="text-center font-serif text-3xl font-bold md:text-4xl">
          Store Performance
        </h2>

        <div class="mt-10 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">

          <div class="rounded-lg border p-8 text-center shadow-sm hover:shadow-md transition">
            <h3 class="text-sm uppercase tracking-widest text-gray-500">Total Revenue</h3>
            <p class="mt-4 text-2xl font-semibold">
              {{ totalRevenue.toLocaleString() }} ₫
            </p>
          </div>

          <div class="rounded-lg border p-8 text-center shadow-sm hover:shadow-md transition">
            <h3 class="text-sm uppercase tracking-widest text-gray-500">New Orders</h3>
            <p class="mt-4 text-2xl font-semibold">
              {{ newOrdersCount }}
            </p>
          </div>

          <div class="rounded-lg border p-8 text-center shadow-sm hover:shadow-md transition">
            <h3 class="text-sm uppercase tracking-widest text-gray-500">Customers</h3>
            <p class="mt-4 text-2xl font-semibold">
              {{ totalCustomers }}
            </p>
          </div>

          <div class="rounded-lg border p-8 text-center shadow-sm hover:shadow-md transition">
            <h3 class="text-sm uppercase tracking-widest text-gray-500">Products</h3>
            <p class="mt-4 text-2xl font-semibold">
              {{ productCount }}
            </p>
          </div>

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
  name: 'AdminDashboard',
  components: { AppHeader, AppFooter },
  data() {
    return {
      totalRevenue: 0,
      newOrdersCount: 0,
      totalCustomers: 0,
      productCount: 0
    }
  },
  async mounted() {
    try {
      const res = await axios.get('/admin/dashboard')
      this.totalRevenue = res.data.totalRevenue
      this.newOrdersCount = res.data.newOrdersCount
      this.totalCustomers = res.data.totalCustomers
      this.productCount = res.data.productCount
    } catch (err) {
      console.error("Dashboard load error", err)
    }
  }
}
</script>

<style scoped>
h1, h2 {
  font-family: 'Playfair Display', serif;
}
</style>