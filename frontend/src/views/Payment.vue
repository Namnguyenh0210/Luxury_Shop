<template>
  <div class="min-h-screen bg-gray-50 flex flex-col">

    <!-- Header -->
    <header class="bg-white border-b border-gray-200 px-6 py-4 shadow-sm">
      <div class="max-w-2xl mx-auto flex items-center justify-between">
        <router-link to="/" class="flex items-center gap-2 text-gray-600 hover:text-gray-900 transition-colors">
          <span class="material-symbols-outlined">arrow_back</span>
          <span class="text-sm font-medium">Về trang chủ</span>
        </router-link>
        <h1 class="text-base font-bold text-gray-800">💳 Thanh toán PayOS</h1>
      </div>
    </header>

    <main class="flex-1 flex items-center justify-center py-10 px-4">
      <div class="w-full max-w-2xl space-y-6">

        <!-- Loading -->
        <div v-if="loading" class="flex justify-center py-16 text-gray-400">
          <span class="material-symbols-outlined animate-spin text-5xl">progress_activity</span>
        </div>

        <template v-else>
          <!-- Header Card -->
          <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6 text-center">
            <h2 class="text-2xl font-bold text-gray-800 mb-1">Quét mã QR để thanh toán</h2>
            <p class="text-gray-500 text-sm">Mở app ngân hàng và quét mã bên dưới</p>
          </div>

          <!-- Order Info -->
          <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6">
            <h3 class="text-base font-bold text-gray-700 mb-4">Thông tin đơn hàng</h3>
            <div class="grid grid-cols-2 gap-4">
              <div class="bg-gray-50 rounded-xl p-3">
                <p class="text-xs text-gray-400 mb-1">Mã đơn hàng</p>
                <p class="font-bold text-gray-800">#{{ orderCode }}</p>
              </div>
              <div class="bg-gray-50 rounded-xl p-3">
                <p class="text-xs text-gray-400 mb-1">Số tiền</p>
                <p class="font-bold text-red-600 text-lg">{{ fmtCurrency(amount) }}</p>
              </div>
              <div class="bg-gray-50 rounded-xl p-3">
                <p class="text-xs text-gray-400 mb-1">Trạng thái</p>
                <span class="inline-flex items-center gap-1.5 text-sm font-semibold" :class="statusClass">
                  <span class="size-2 rounded-full" :class="statusDot"></span>
                  {{ statusText }}
                </span>
              </div>
              <div v-if="donHang" class="bg-gray-50 rounded-xl p-3">
                <p class="text-xs text-gray-400 mb-1">Khách hàng</p>
                <p class="font-medium text-gray-700 text-sm">{{ donHang.taiKhoan?.hoTen }}</p>
              </div>
            </div>
          </div>

          <!-- QR Code -->
          <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6 text-center">
            <div v-if="qrCode" class="flex justify-center mb-4">
              <img :src="qrCode" alt="QR Code PayOS" class="w-64 h-64 rounded-xl border border-gray-200 shadow-sm" />
            </div>

            <div v-if="!qrCode && checkoutUrl" class="mb-4">
              <p class="text-gray-500 text-sm mb-4">Nhấn nút bên dưới để mở trang thanh toán PayOS</p>
              <a :href="checkoutUrl" target="_blank"
                class="inline-flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-8 py-3 rounded-xl font-bold transition-colors">
                <span class="material-symbols-outlined text-[20px]">open_in_new</span>
                Mở trang thanh toán
              </a>
            </div>

            <!-- Countdown -->
            <div class="mt-4 inline-flex items-center gap-2 bg-amber-50 text-amber-700 px-4 py-2 rounded-xl text-sm font-medium">
              <span class="material-symbols-outlined text-[18px]">timer</span>
              Thời gian còn lại: <span class="font-bold">{{ countdownDisplay }}</span>
            </div>
          </div>

          <!-- Steps -->
          <div class="bg-blue-50 rounded-2xl border border-blue-100 p-6">
            <h4 class="font-bold text-blue-800 mb-3 flex items-center gap-2">
              <span class="material-symbols-outlined text-[20px]">help</span>
              Hướng dẫn thanh toán
            </h4>
            <ol class="space-y-2 text-sm text-blue-700">
              <li class="flex items-start gap-2"><span class="font-bold text-blue-500 mt-0.5">1.</span> Mở ứng dụng ngân hàng (Momo, ZaloPay, Banking app...)</li>
              <li class="flex items-start gap-2"><span class="font-bold text-blue-500 mt-0.5">2.</span> Chọn chức năng "Quét mã QR" hoặc "Chuyển khoản"</li>
              <li class="flex items-start gap-2"><span class="font-bold text-blue-500 mt-0.5">3.</span> Quét mã QR code hiển thị bên trên</li>
              <li class="flex items-start gap-2"><span class="font-bold text-blue-500 mt-0.5">4.</span> Kiểm tra thông tin và xác nhận thanh toán</li>
              <li class="flex items-start gap-2"><span class="font-bold text-blue-500 mt-0.5">5.</span> Hệ thống sẽ tự động cập nhật khi thành công</li>
            </ol>
          </div>

          <!-- Action Buttons -->
          <div class="flex flex-wrap gap-3 justify-center">
            <button @click="checkPaymentStatus"
              class="flex items-center gap-2 bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-xl font-bold transition-colors">
              <span class="material-symbols-outlined text-[18px]">refresh</span>
              Kiểm tra thanh toán
            </button>
            <router-link to="/profile"
              class="flex items-center gap-2 bg-gray-600 hover:bg-gray-700 text-white px-6 py-3 rounded-xl font-bold transition-colors">
              <span class="material-symbols-outlined text-[18px]">receipt_long</span>
              Xem đơn hàng
            </router-link>
          </div>

          <!-- Expired Message -->
          <div v-if="isExpired" class="bg-red-50 border border-red-200 rounded-2xl p-6">
            <h4 class="font-bold text-red-700 mb-2 flex items-center gap-2">
              <span class="material-symbols-outlined">warning</span>
              Hết thời gian thanh toán
            </h4>
            <p class="text-sm text-red-600 mb-4">Link thanh toán đã hết hạn. Vui lòng vào trang đơn hàng để tiếp tục.</p>
            <router-link to="/profile" class="inline-flex items-center gap-2 bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-xl text-sm font-bold transition-colors">
              Xem đơn hàng của tôi
            </router-link>
          </div>
        </template>

      </div>
    </main>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'PaymentPage',

  data() {
    return {
      loading: true,
      orderCode: null,
      amount: 0,
      qrCode: null,
      checkoutUrl: null,
      donHang: null,
      paymentStatus: 'PENDING', // PENDING | PAID | CANCELLED
      timeLeft: 15 * 60, // 15 phút
      isExpired: false,
      checkTimer: null,
      countdownTimer: null
    }
  },

  computed: {
    countdownDisplay() {
      if (this.isExpired) return 'Hết hạn'
      const m = Math.floor(this.timeLeft / 60).toString().padStart(2, '0')
      const s = (this.timeLeft % 60).toString().padStart(2, '0')
      return `${m}:${s}`
    },
    statusText() {
      return { PENDING: 'Chờ thanh toán', PAID: 'Đã thanh toán', CANCELLED: 'Đã hủy' }[this.paymentStatus] ?? 'Không xác định'
    },
    statusClass() {
      return { PENDING: 'text-yellow-600', PAID: 'text-green-600', CANCELLED: 'text-red-600' }[this.paymentStatus]
    },
    statusDot() {
      return { PENDING: 'bg-yellow-400', PAID: 'bg-green-500', CANCELLED: 'bg-red-500' }[this.paymentStatus]
    }
  },

  async mounted() {
    // Lấy thông tin từ query params hoặc route params
    this.orderCode = this.$route.query.orderCode || this.$route.params.orderCode
    this.amount    = this.$route.query.amount    || 0
    this.qrCode    = this.$route.query.qrCode    || null
    this.checkoutUrl = this.$route.query.checkoutUrl || null

    this.loading = false

    if (this.orderCode) {
      this.checkPaymentStatus()
      this.checkTimer    = setInterval(this.checkPaymentStatus, 5000)
      this.countdownTimer = setInterval(this.updateCountdown, 1000)
    }
  },

  beforeUnmount() {
    clearInterval(this.checkTimer)
    clearInterval(this.countdownTimer)
  },

  methods: {
    fmtCurrency(v) {
      return new Intl.NumberFormat('vi-VN').format(v || 0) + ' đ'
    },

    updateCountdown() {
      if (this.timeLeft <= 0) {
        this.isExpired = true
        this.paymentStatus = 'CANCELLED'
        clearInterval(this.countdownTimer)
        clearInterval(this.checkTimer)
        return
      }
      this.timeLeft--
    },

    async checkPaymentStatus() {
      if (!this.orderCode) return
      try {
        const res = await axios.get(`/payment/payos/check/${this.orderCode}`)
        if (res.data.success) {
          this.paymentStatus = res.data.status

          if (res.data.status === 'PAID') {
            clearInterval(this.checkTimer)
            clearInterval(this.countdownTimer)
            setTimeout(() => {
              this.$router.push(`/checkout-success?orderId=${this.orderCode}`)
            }, 2000)
          } else if (res.data.status === 'CANCELLED') {
            clearInterval(this.checkTimer)
            clearInterval(this.countdownTimer)
          }
        }
      } catch (e) {
        console.error('Error checking payment:', e)
      }
    }
  }
}
</script>
