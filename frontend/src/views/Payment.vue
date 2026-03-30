<template>
  <div class="min-h-screen flex flex-col" style="background:#FDFCFB;">
    <!-- Header -->
    <header class="bg-white/80 backdrop-blur-md border-b border-gray-100 px-6 py-5 sticky top-0 z-30">
      <div class="max-w-3xl mx-auto flex items-center justify-between">
        <router-link to="/" class="flex items-center gap-2 text-[10px] font-black uppercase tracking-[0.2em] text-gray-400 hover:text-[#C8A97E] transition-all">
          <span class="material-symbols-outlined text-sm">arrow_back</span>
          Về trang chủ
        </router-link>
        <div class="flex items-center gap-3">
           <span class="text-[10px] font-bold text-gray-300 uppercase tracking-widest hidden sm:block">Secure Gateway</span>
           <h1 class="text-xs font-black text-[#111111] uppercase tracking-[0.3em] flex items-center gap-2">
             <span class="h-2 w-2 rounded-full bg-[#C8A97E]"></span>
             Thanh toán PayOS
           </h1>
        </div>
      </div>
    </header>

    <main class="flex-1 flex items-center justify-center py-12 px-4">
      <div class="w-full max-w-3xl space-y-8">

        <!-- Loading -->
        <div v-if="loading" class="flex flex-col items-center justify-center py-32 text-[#C8A97E]">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-[#C8A97E] mb-6"></div>
          <p class="text-[10px] font-bold uppercase tracking-[0.4em]">Đang thiết lập cổng thanh toán bảo mật...</p>
        </div>

        <template v-else>
          <!-- Header Card -->
          <div class="text-center space-y-3 animate-fadeIn">
            <p class="text-[10px] font-bold uppercase tracking-[0.5em] text-[#C8A97E]">Luxury Experience</p>
            <h2 class="font-serif text-3xl md:text-4xl font-bold text-[#111111] tracking-tight uppercase">Quét mã QR để hoàn tất</h2>
            <div class="w-16 h-px bg-[#C8A97E] mx-auto mt-4"></div>
          </div>

          <div class="grid grid-cols-1 lg:grid-cols-5 gap-8 items-start">
            
            <!-- LEFT: Order Info & Steps -->
            <div class="lg:col-span-2 space-y-6 animate-slideInLeft">
               <!-- Order Info Card -->
               <div class="bg-white rounded-3xl border border-[#E5E7EB] shadow-xl p-8">
                 <h3 class="text-[11px] font-black text-[#111111] uppercase tracking-[0.2em] mb-6 border-b border-gray-50 pb-4">Thông tin đơn hàng</h3>
                 
                 <div v-if="errorMsg" class="mb-5 p-4 bg-red-50 border border-red-100 rounded-2xl text-red-700 text-[11px] font-bold italic line-clamp-3">
                   "{{ errorMsg }}"
                 </div>

                 <div class="space-y-6">
                    <div class="flex justify-between items-center group">
                       <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest group-hover:text-[#C8A97E] transition-colors">Đơn hàng</span>
                       <span class="text-sm font-black text-[#111111]">#{{ orderId || orderCode || '...' }}</span>
                    </div>
                    
                    <div class="p-5 bg-[#111111] rounded-2xl text-white shadow-lg transform hover:-translate-y-1 transition-all duration-300">
                       <p class="text-[9px] font-bold uppercase tracking-[0.3em] text-[#C8A97E] mb-2">Số tiền quyết toán</p>
                       <p class="text-2xl font-bold tracking-tighter">{{ fmtCurrency(amount) }}</p>
                    </div>

                    <div class="flex justify-between items-center bg-[#FDFCFB] p-4 rounded-xl border border-gray-50">
                       <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Trạng thái</span>
                       <div class="flex items-center gap-2">
                         <span class="h-1.5 w-1.5 rounded-full animate-pulse" :class="statusDot"></span>
                         <span class="text-[10px] font-black uppercase tracking-widest" :class="statusClass">{{ statusText }}</span>
                       </div>
                    </div>
                 </div>
               </div>

               <!-- Steps Card -->
               <div class="bg-white rounded-3xl border border-[#E5E7EB] shadow-lg p-8">
                  <h4 class="text-[11px] font-black text-[#111111] uppercase tracking-[0.2em] mb-6 flex items-center gap-2">
                    <span class="material-symbols-outlined text-[18px] text-[#C8A97E]">verified_user</span>
                    Quy trình bảo mật
                  </h4>
                  <div class="space-y-5">
                    <div v-for="(step, i) in ['Mở ứng dụng ngân hàng/Ví điện tử', 'Chọn Quét mã QR / Chuyển khoản', 'Mã QR hiển thị bên phải', 'Kiểm tra thông tin & Xác nhận', 'Hệ thống tự động cập nhật ngay']" 
                         :key="i" class="flex gap-4 items-center">
                      <span class="text-[10px] font-black text-white bg-[#C8A97E] w-5 h-5 rounded-full flex items-center justify-center flex-shrink-0 shadow-sm">{{ i+1 }}</span>
                      <p class="text-xs text-gray-600 font-medium tracking-tight">{{ step }}</p>
                    </div>
                  </div>
               </div>
            </div>

            <!-- RIGHT: QR Code -->
            <div class="lg:col-span-3 space-y-6 animate-slideInRight">
               <div class="bg-white rounded-[2.5rem] border border-[#C8A97E]/30 shadow-2xl p-10 text-center relative overflow-hidden group">
                 <!-- Decorative elements -->
                 <div class="absolute top-0 right-0 w-32 h-32 bg-[#C8A97E]/5 rounded-full -mr-16 -mt-16 transition-transform group-hover:scale-150"></div>
                 <div class="absolute bottom-0 left-0 w-24 h-24 bg-[#111111]/5 rounded-full -ml-12 -mb-12 transition-transform group-hover:scale-150"></div>
                 
                 <div v-if="qrCode" class="relative z-10">
                    <div class="inline-block p-4 bg-white border-[6px] border-[#111111] rounded-[2rem] shadow-2xl transform transition-transform group-hover:rotate-1">
                       <img :src="qrCode" alt="QR Code PayOS" class="w-72 h-72 object-contain" />
                    </div>
                    <p class="mt-8 text-[11px] font-black text-[#111111] uppercase tracking-[0.4em] animate-pulse">Đang chờ tín hiệu thanh toán...</p>
                 </div>

                 <div v-if="!qrCode && checkoutUrl" class="py-12 px-6">
                    <span class="material-symbols-outlined text-6xl text-[#C8A97E]/30 mb-6">link</span>
                    <p class="text-xs text-gray-500 mb-8 font-medium">Phiên thanh toán đã được chuẩn bị sẵn sàng</p>
                    <a :href="checkoutUrl" target="_blank"
                      class="inline-flex items-center gap-3 bg-[#111111] text-white px-10 py-4 rounded-full font-bold text-[11px] uppercase tracking-widest hover:bg-[#C8A97E] transition-all shadow-xl shadow-black/10">
                      Mở trang thanh toán gốc
                      <span class="material-symbols-outlined text-sm">open_in_new</span>
                    </a>
                 </div>

                 <!-- Countdown Bar -->
                 <div class="mt-10 flex flex-col items-center">
                    <div class="flex items-center gap-3 bg-[#FDFCFB] border border-[#F5E6D3] text-[#C8A97E] px-8 py-3 rounded-full text-[11px] font-black uppercase tracking-widest shadow-inner">
                      <span class="material-symbols-outlined text-base">hourglass_top</span>
                      Thời gian còn lại: <span class="text-[#111111] ml-1">{{ countdownDisplay }}</span>
                    </div>
                    <div class="w-1/2 h-1 bg-gray-100 rounded-full mt-4 overflow-hidden">
                       <div class="h-full bg-[#C8A97E] transition-all duration-1000" :style="{width: (timeLeft/(15*60)*100)+'%'}"></div>
                    </div>
                 </div>
               </div>

               <!-- Bottom Actions -->
               <div class="flex flex-col sm:flex-row gap-4">
                  <button @click="manualCheck"
                    class="flex-1 flex items-center justify-center gap-3 bg-[#111111] text-[#C8A97E] px-8 py-4 rounded-full font-bold text-[10px] uppercase tracking-[0.3em] hover:bg-[#C8A97E] hover:text-white transition-all shadow-lg">
                    <span class="material-symbols-outlined text-base">cached</span>
                    Xác nhận thủ công
                  </button>
                  <router-link to="/profile"
                    class="flex-1 flex items-center justify-center gap-3 border border-gray-200 text-gray-400 px-8 py-4 rounded-full font-bold text-[10px] uppercase tracking-[0.3em] hover:border-[#111111] hover:text-[#111111] transition-all">
                    <span class="material-symbols-outlined text-base">list_alt</span>
                    Trang đơn hàng
                  </router-link>
               </div>
            </div>
          </div>

          <!-- Expired Message -->
          <div v-if="isExpired" class="fixed inset-0 z-50 flex items-center justify-center bg-[#111111]/95 backdrop-blur-md animate-fadeIn">
            <div class="max-w-md w-full bg-white rounded-[3rem] p-12 text-center shadow-2xl mx-4">
              <span class="material-symbols-outlined text-red-500 text-7xl mb-6">history_toggle_off</span>
              <h4 class="font-serif text-2xl font-bold text-[#111111] mb-2 uppercase">Giao dịch đã đóng</h4>
              <p class="text-sm text-gray-400 mb-8 font-medium">Hết thời gian thanh toán bảo mật. Vui lòng quay lại đơn hàng để thiết lập phiên mới.</p>
              <router-link to="/profile" class="block bg-red-600 text-white px-10 py-4 rounded-full text-[11px] font-black uppercase tracking-widest hover:bg-black transition-all shadow-xl shadow-red-200">
                Về quản lý đơn hàng
              </router-link>
            </div>
          </div>

          <!-- SUCCESS OVERLAY (Premium Style) -->
          <div v-if="isSuccess"
            class="fixed inset-0 z-50 flex items-center justify-center bg-[#FDFCFB]/95 backdrop-blur-xl animate-fadeIn">
            <div class="text-center max-w-sm mx-4 animate-scaleUp">
              <div class="w-32 h-32 bg-[#EEF9F1] rounded-full flex items-center justify-center mx-auto mb-10 shadow-inner">
                <span class="material-symbols-outlined text-green-600 text-7xl animate-bounce-subtle">check_circle</span>
              </div>
              <p class="text-[11px] font-bold text-[#C8A97E] uppercase tracking-[0.5em] mb-4">Success</p>
              <h2 class="font-serif text-3xl font-bold text-[#111111] mb-4 uppercase tracking-tight">Thanh toán hoàn tất</h2>
              <p class="text-xs text-gray-500 mb-10 font-medium leading-relaxed uppercase tracking-widest">Tuyệt phẩm của bạn đang được chuẩn bị để khởi hành...</p>
              <div class="flex flex-col items-center gap-2">
                <div class="w-40 h-1 bg-gray-100 rounded-full overflow-hidden">
                   <div class="h-full bg-green-500 animate-loading-bar"></div>
                </div>
                <span class="text-[9px] font-bold text-gray-300 uppercase tracking-widest">Đang chuyển hướng</span>
              </div>
            </div>
          </div>
        </template>

      </div>
    </main>

    <!-- Footer Security Badges -->
    <footer class="py-8 border-t border-gray-100 mt-12 bg-white">
      <div class="max-w-3xl mx-auto flex flex-wrap justify-around gap-8 opacity-40 grayscale group-hover:grayscale-0 transition-all">
         <div class="flex items-center gap-2 font-bold text-[10px] uppercase tracking-widest">
           <span class="material-symbols-outlined text-sm">shield_lock</span> PCI-DSS Compliant
         </div>
         <div class="flex items-center gap-2 font-bold text-[10px] uppercase tracking-widest">
           <span class="material-symbols-outlined text-sm">verified</span> SSL Encryption
         </div>
         <div class="flex items-center gap-2 font-bold text-[10px] uppercase tracking-widest">
           <span class="material-symbols-outlined text-sm">task_alt</span> Auto Confirmed
         </div>
      </div>
    </footer>
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
        // Dùng proxy /payment qua Vite để bảo mật và đồng nhất host
        const res = await axios.get(`/payment/payos/check/${codeToCheck}`)

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

<style scoped>
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
@keyframes slideInLeft {
  from { opacity: 0; transform: translateX(-30px); }
  to { opacity: 1; transform: translateX(0); }
}
@keyframes slideInRight {
  from { opacity: 0; transform: translateX(30px); }
  to { opacity: 1; transform: translateX(0); }
}
@keyframes scaleUp {
  from { opacity: 0; transform: scale(0.9); }
  to { opacity: 1; transform: scale(1); }
}
@keyframes bounce-subtle {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-5px); }
}
@keyframes loading-bar {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(100%); }
}

.animate-fadeIn { animation: fadeIn 1s ease-out forwards; }
.animate-slideInLeft { animation: slideInLeft 0.8s ease-out forwards; }
.animate-slideInRight { animation: slideInRight 0.8s ease-out forwards; }
.animate-scaleUp { animation: scaleUp 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) forwards; }
.animate-bounce-subtle { animation: bounce-subtle 2s infinite ease-in-out; }
.animate-loading-bar { animation: loading-bar 2s infinite ease-in-out; }
</style>
