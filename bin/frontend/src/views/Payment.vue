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

            <!-- Error Message -->
            <div v-if="errorMsg" class="mb-4 p-4 bg-orange-50 border border-orange-200 rounded-xl text-orange-700 text-sm">
              ⚠️ {{ errorMsg }}
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div class="bg-gray-50 rounded-xl p-3">
                <p class="text-xs text-gray-400 mb-1">Mã đơn hàng</p>
                <p class="font-bold text-gray-800">#{{ orderId || orderCode || '...' }}</p>
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

          <!-- ✅ SUCCESS OVERLAY khi thanh toán thành công -->
          <div v-if="isSuccess"
            class="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm">
            <div class="bg-white rounded-3xl p-10 text-center shadow-2xl max-w-sm mx-4 animate-bounce-in">
              <div class="w-24 h-24 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <span class="material-symbols-outlined text-green-600 text-6xl">check_circle</span>
              </div>
              <h2 class="text-2xl font-black text-gray-900 mb-2">Thanh toán thành công! 🎉</h2>
              <p class="text-gray-500 mb-4">Đơn hàng của bạn đã được xác nhận.<br>Đang chuyển sang trang xác nhận...</p>
              <div class="flex justify-center">
                <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-green-600"></div>
              </div>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="flex flex-wrap gap-3 justify-center">
            <button @click="manualCheck"
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
      orderId: null,      // ID đơn hàng gốc trong DB
      orderCode: null,    // Mã PayOS (dùng để poll trạng thái)
      amount: 0,
      qrCode: null,
      checkoutUrl: null,
      paymentStatus: 'PENDING', // PENDING | PAID | CANCELLED
      timeLeft: 15 * 60,        // 15 phút
      isExpired: false,
      isSuccess: false,         // animation sau khi PAID
      checkTimer: null,
      countdownTimer: null,
      errorMsg: null
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
      return {
        PENDING:   '⏳ Chờ thanh toán',
        PAID:      '✅ Đã thanh toán',
        CANCELLED: '❌ Đã hủy'
      }[this.paymentStatus] ?? 'Không xác định'
    },
    statusClass() {
      return {
        PENDING:   'text-yellow-600',
        PAID:      'text-green-600',
        CANCELLED: 'text-red-600'
      }[this.paymentStatus]
    },
    statusDot() {
      return {
        PENDING:   'bg-yellow-400',
        PAID:      'bg-green-500',
        CANCELLED: 'bg-red-500'
      }[this.paymentStatus]
    }
  },

  async mounted() {
    const q = this.$route.query
    this.orderId   = q.orderId   || null
    this.orderCode = q.orderCode || null

    if (!this.orderId) {
      this.errorMsg = 'Không tìm thấy thông tin đơn hàng. Vui lòng thử lại.'
      this.loading = false
      return
    }

    try {
      // Dùng Vite proxy /payment/payos → localhost:8080
      // (không dùng axios vì baseURL = '/api' sẽ thành /api/payment/payos/...)
      const res = await fetch(`/payment/payos/data/${this.orderId}`, {
        credentials: 'include'
      })

      if (res.ok) {
        const data = await res.json()
        this.qrCode      = data.qrCode      || null
        this.checkoutUrl = data.checkoutUrl  || null
        this.orderCode   = data.orderCode    || this.orderCode
        this.amount      = data.amount       || 0
      } else if (res.status === 404) {
        this.errorMsg = 'Dữ liệu thanh toán không tìm thấy (session hết hạn?). Vui lòng đặt lại.'
      } else {
        this.errorMsg = `Lỗi tải dữ liệu thanh toán (HTTP ${res.status}). Vui lòng thử lại.`
      }
    } catch (e) {
      console.error('Failed to fetch payment data:', e)
      this.errorMsg = 'Lỗi kết nối. Vui lòng reload trang.'
    }

    this.loading = false

    if (this.orderCode) {
      await this.checkPaymentStatus()
      this.checkTimer     = setInterval(this.checkPaymentStatus, 3000)
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
      const codeToCheck = this.orderCode || this.orderId
      if (!codeToCheck) return

      try {
        // Dùng absolute URL vì endpoint này KHÔNG có /api prefix
        // (axios.defaults.baseURL = '/api' → phải dùng full URL)
        const res = await axios.get(`http://localhost:5173/payment/payos/check/${codeToCheck}`)

        if (res.data.success) {
          this.paymentStatus = res.data.status

          if (res.data.status === 'PAID') {
            // Thanh toán thành công!
            this.isSuccess = true
            clearInterval(this.checkTimer)
            clearInterval(this.countdownTimer)

            // Delay 3 giây để user thấy animation thành công rồi redirect
            setTimeout(() => {
              const targetId = this.orderId || this.orderCode
              this.$router.push(`/checkout-success?orderId=${targetId}`)
            }, 3000)

          } else if (res.data.status === 'CANCELLED') {
            clearInterval(this.checkTimer)
            clearInterval(this.countdownTimer)
          }
        }
      } catch (e) {
        // Không hiện lỗi vì polling nền, chỉ log
        console.warn('Polling payment status failed:', e.message)
      }
    },

    async manualCheck() {
      await this.checkPaymentStatus()
    }
  }
}
</script>
