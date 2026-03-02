<template>
  <div class="min-h-screen bg-[#fef8f3] flex flex-col">

    <!-- Header -->
    <header class="sticky top-0 z-10 bg-white border-b border-[#e9d5c7] px-6 py-4">
      <div class="max-w-4xl mx-auto flex items-center justify-between">
        <router-link to="/" class="flex items-center gap-2 text-amber-800 hover:text-amber-600 transition-colors">
          <span class="material-symbols-outlined text-xl">arrow_back</span>
          <span class="text-sm font-medium">Trang chủ</span>
        </router-link>
        <router-link to="/sanpham" class="text-sm font-semibold text-amber-700 hover:text-amber-900 transition-colors">
          Tiếp tục mua sắm →
        </router-link>
      </div>
    </header>

    <!-- Main Content -->
    <main class="flex-1 flex items-center justify-center py-12 px-4">
      <div class="w-full max-w-4xl">

        <!-- Success Icon & Title -->
        <div class="flex flex-col items-center text-center mb-10">
          <div class="mb-5 flex h-20 w-20 items-center justify-center rounded-full bg-green-100 text-green-600 shadow-sm">
            <span class="material-symbols-outlined text-5xl">check_circle</span>
          </div>
          <h1 class="text-4xl md:text-5xl font-bold tracking-tight text-gray-900 mb-3">
            Cảm ơn đã đặt hàng!
          </h1>
          <p class="max-w-md text-base text-gray-500 leading-relaxed">
            Đơn hàng của bạn đã được tiếp nhận. Chúng tôi sẽ xử lý và giao hàng sớm nhất có thể.
          </p>
        </div>

        <!-- Loading -->
        <div v-if="loading" class="flex justify-center py-12 text-gray-400">
          <span class="material-symbols-outlined animate-spin text-4xl">progress_activity</span>
        </div>

        <template v-else-if="donHang">
          <!-- Order Detail Card -->
          <div class="rounded-2xl border border-[#e9d5c7] bg-white shadow-sm overflow-hidden">

            <!-- Info Grid -->
            <div class="p-6 md:p-8">
              <h3 class="text-lg font-bold text-gray-800 mb-5">Chi tiết đơn hàng</h3>
              <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
                <div class="bg-gray-50 rounded-xl p-4">
                  <p class="text-xs text-gray-400 font-medium uppercase tracking-wide mb-1">Mã đơn hàng</p>
                  <p class="text-sm font-bold text-gray-800">#{{ donHang.maDH }}</p>
                </div>
                <div class="bg-gray-50 rounded-xl p-4">
                  <p class="text-xs text-gray-400 font-medium uppercase tracking-wide mb-1">Ngày đặt hàng</p>
                  <p class="text-sm font-medium text-gray-700">{{ formatDate(donHang.ngayDat) }}</p>
                </div>
                <div class="bg-gray-50 rounded-xl p-4">
                  <p class="text-xs text-gray-400 font-medium uppercase tracking-wide mb-1">Khách hàng</p>
                  <p class="text-sm font-medium text-gray-700">{{ donHang.taiKhoan?.hoTen }}</p>
                </div>
                <div class="bg-gray-50 rounded-xl p-4">
                  <p class="text-xs text-gray-400 font-medium uppercase tracking-wide mb-1">Địa chỉ giao hàng</p>
                  <p class="text-sm font-medium text-gray-700">{{ donHang.diaChiGiao?.diaChiChiTiet || 'N/A' }}</p>
                </div>
                <div class="bg-gray-50 rounded-xl p-4 sm:col-span-2">
                  <p class="text-xs text-gray-400 font-medium uppercase tracking-wide mb-1">Phương thức thanh toán</p>
                  <p class="text-sm font-medium text-gray-700">{{ donHang.hinhThucThanhToan?.tenPhuongThuc || 'COD' }}</p>
                </div>
                <div v-if="donHang.ghiChu" class="bg-gray-50 rounded-xl p-4 sm:col-span-2">
                  <p class="text-xs text-gray-400 font-medium uppercase tracking-wide mb-1">Ghi chú</p>
                  <p class="text-sm font-medium text-gray-700">{{ donHang.ghiChu }}</p>
                </div>
              </div>
            </div>

            <!-- Products List -->
            <div v-if="chiTiet && chiTiet.length > 0" class="border-t border-[#e9d5c7] p-6 md:p-8">
              <h3 class="text-lg font-bold text-gray-800 mb-5">Sản phẩm đã đặt</h3>
              <ul class="space-y-5">
                <li v-for="item in chiTiet" :key="item.id" class="flex items-start gap-4">
                  <img
                    class="h-20 w-20 flex-shrink-0 rounded-xl object-cover border border-gray-100"
                    :src="item.sanPhamChiTiet?.anhBienThe || item.sanPhamChiTiet?.sanPham?.anhChinh || '/img/placeholder.png'"
                    @error="e => e.target.src='/img/placeholder.png'"
                    alt="Sản phẩm"
                  />
                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-bold text-gray-800">{{ item.sanPhamChiTiet?.sanPham?.thuongHieu?.tenTH || 'BRAND' }}</p>
                    <p class="text-sm text-gray-500 truncate">{{ item.sanPhamChiTiet?.sanPham?.tenSP }}</p>
                    <p class="mt-1 text-xs text-gray-400">
                      <span v-if="item.sanPhamChiTiet?.sizeSP">Size: {{ item.sanPhamChiTiet.sizeSP.tenSize }}</span>
                      <span v-if="item.sanPhamChiTiet?.mauSacSP"> / Màu: {{ item.sanPhamChiTiet.mauSacSP.tenMau }}</span>
                      / SL: {{ item.soLuong }}
                    </p>
                  </div>
                  <p class="text-sm font-bold text-gray-800 flex-shrink-0">{{ fmtCurrency(item.donGia) }}</p>
                </li>
              </ul>
            </div>

            <!-- Total -->
            <div class="border-t border-[#e9d5c7] p-6 md:p-8">
              <div class="space-y-2 text-sm">
                <div class="flex justify-between text-gray-500">
                  <span>Tạm tính</span>
                  <span>{{ fmtCurrency(donHang.tongTien) }}</span>
                </div>
                <div class="flex justify-between text-gray-500">
                  <span>Phí vận chuyển</span>
                  <span class="text-green-600 font-medium">Miễn phí</span>
                </div>
                <div class="flex justify-between border-t border-[#e9d5c7] pt-3 text-base font-bold text-gray-900">
                  <span>Tổng cộng</span>
                  <span class="text-amber-700">{{ fmtCurrency(donHang.tongTien) }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="mt-8 flex flex-col sm:flex-row gap-3 justify-center">
            <router-link to="/sanpham"
              class="flex items-center justify-center gap-2 px-8 py-3 rounded-xl bg-amber-700 text-white font-semibold hover:bg-amber-800 transition-colors shadow-sm">
              <span class="material-symbols-outlined text-[18px]">shopping_bag</span>
              Tiếp tục mua sắm
            </router-link>
            <router-link to="/profile"
              class="flex items-center justify-center gap-2 px-8 py-3 rounded-xl border border-gray-300 bg-white text-gray-700 font-semibold hover:bg-gray-50 transition-colors">
              <span class="material-symbols-outlined text-[18px]">receipt_long</span>
              Xem đơn hàng của tôi
            </router-link>
          </div>
        </template>

        <!-- Fallback nếu không có dữ liệu -->
        <div v-else class="text-center py-10 text-gray-400">
          <p>Không tìm thấy thông tin đơn hàng.</p>
          <router-link to="/" class="mt-4 inline-block text-amber-700 font-medium hover:underline">Về trang chủ</router-link>
        </div>

      </div>
    </main>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'CheckoutSuccess',

  data() {
    return {
      loading: true,
      donHang: null,
      chiTiet: []
    }
  },

  async mounted() {
    const orderId = this.$route.query.orderId || this.$route.params.id
    if (!orderId) { this.loading = false; return }
    try {
      const res = await axios.get(`/api/orders/${orderId}`, { withCredentials: true })
      this.donHang = res.data.donHang || res.data
      this.chiTiet = res.data.chiTiet || this.donHang?.chiTiet || []
    } catch (e) {
      console.error(e)
    } finally {
      this.loading = false
    }
  },

  methods: {
    fmtCurrency(v) {
      return new Intl.NumberFormat('vi-VN').format(v || 0) + ' đ'
    },
    formatDate(d) {
      if (!d) return '---'
      return new Date(d).toLocaleString('vi-VN')
    }
  }
}
</script>
