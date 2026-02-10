<template>
  <div class="relative flex min-h-screen w-full flex-col bg-gray-50">
    <AppHeader />
    
    <main class="flex-grow">
      <div class="container mx-auto px-4 sm:px-6 lg:px-20 py-8 lg:py-12">
        <!-- Page Title -->
        <div class="mb-8">
          <h1 class="text-3xl lg:text-4xl font-black font-heading text-gray-900 tracking-tight">Thanh toán</h1>
          <p class="text-gray-500 mt-2">Vui lòng kiểm tra thông tin trước khi đặt hàng</p>
        </div>

        <!-- Alert Messages -->
        <div v-if="error" class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
          <div class="flex items-center gap-3">
            <span class="material-symbols-outlined text-red-600">error</span>
            <p class="text-red-800">{{ error }}</p>
          </div>
        </div>

        <div v-if="success" class="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg">
          <div class="flex items-center gap-3">
            <span class="material-symbols-outlined text-green-600">check_circle</span>
            <p class="text-green-800">{{ success }}</p>
          </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="flex flex-col items-center justify-center py-20">
          <div class="animate-spin rounded-full h-16 w-16 border-b-2 border-yellow-600 mb-4"></div>
          <p class="text-gray-600">Đang tải thông tin...</p>
        </div>

        <!-- Main Content Grid -->
        <form v-else @submit.prevent="handleSubmit" class="grid grid-cols-1 lg:grid-cols-12 gap-8">
          <!-- Left Column: Shipping & Payment Info -->
          <div class="lg:col-span-7 space-y-6">
            <!-- Shipping Address Section -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
              <div class= "p-6 border-b border-gray-200">
                <h2 class="text-xl font-bold text-gray-900 flex items-center gap-2">
                  <span class="material-symbols-outlined">local_shipping</span>
                  Địa chỉ giao hàng
                </h2>
              </div>

              <div class="p-6">
                <!-- Existing Addresses -->
                <div v-if="diaChiList.length > 0" class="space-y-3">
                  <div v-for="(diaChi, index) in diaChiList" :key="diaChi.maDiaChi"
                       @click="selectedAddress = diaChi.maDiaChi"
                       :class="['relative flex items-start p-4 border-2 rounded-lg cursor-pointer transition-all hover:border-yellow-600',
                                selectedAddress === diaChi.maDiaChi ? 'border-yellow-600 bg-yellow-50' : 'border-gray-200']">
                    <input type="radio" v-model="selectedAddress" :value="diaChi.maDiaChi" required
                           class="mt-1 h-4 w-4 text-yellow-600 border-gray-300 focus:ring-yellow-600" />
                    <label class="ml-3 flex-1 cursor-pointer">
                      <div class="flex items-center gap-2 mb-1">
                        <span class="font-semibold text-gray-900">{{ diaChi.hoTenNguoiNhan }}</span>
                        <span v-if="diaChi.laMacDinh" class="px-2 py-0.5 bg-yellow-600 text-white text-xs rounded-full">Mặc định</span>
                      </div>
                      <p class="text-sm text-gray-600">{{ diaChi.soDienThoai }}</p>
                      <p class="text-sm text-gray-600 mt-1">{{ diaChi.diaChiChiTiet }}</p>
                    </label>
                  </div>
                </div>

                <!-- No Address Available -->
                <div v-else class="text-center py-8 text-gray-500">
                  <span class="material-symbols-outlined text-5xl mb-3 text-gray-400">location_off</span>
                  <p class="mb-4">Bạn chưa có địa chỉ giao hàng nào.</p>
                  <a href="/profile" class="inline-flex items-center gap-2 px-6 py-3 bg-yellow-600 text-white rounded-lg font-semibold hover:bg-yellow-700 transition">
                    <span class="material-symbols-outlined">add</span>
                    Thêm địa chỉ mới
                  </a>
                </div>

                <!-- Add New Address Button -->
                <div v-if="diaChiList.length > 0" class="mt-4">
                  <a href="/profile" class="inline-flex items-center gap-2 text-yellow-600 hover:text-yellow-700 font-semibold text-sm transition">
                    <span class="material-symbols-outlined text-lg">add_circle</span>
                    Thêm địa chỉ mới
                  </a>
                </div>
              </div>
            </div>

            <!-- Payment Method Section -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
              <div class="p-6 border-b border-gray-200">
                <h2 class="text-xl font-bold text-gray-900 flex items-center gap-2">
                  <span class="material-symbols-outlined">payment</span>
                  Phương thức thanh toán
                </h2>
              </div>

              <div class="p-6 space-y-3">
                <div v-if="paymentMethods.length > 0">
                  <div v-for="(method, index) in paymentMethods" :key="method.maHinhThucTT"
                       @click="selectedPayment = method.maHinhThucTT"
                       :class="['relative flex items-start p-4 border-2 rounded-lg cursor-pointer hover:border-yellow-600 transition',
                                selectedPayment === method.maHinhThucTT ? 'border-yellow-600 bg-yellow-50' : 'border-gray-200']">
                    <input type="radio" v-model="selectedPayment" :value="method.maHinhThucTT" required
                           class="mt-1 h-4 w-4 text-yellow-600 border-gray-300 focus:ring-yellow-600" />
                    <label class="ml-3 flex-1 cursor-pointer">
                      <div class="flex items-center gap-2 mb-1">
                        <span class="material-symbols-outlined text-yellow-600">{{ method.icon || 'credit_card' }}</span>
                        <span class="font-semibold text-gray-900">{{ method.tenHinhThuc }}</span>
                        <span v-if="method.tenHinhThuc && method.tenHinhThuc.toLowerCase().includes('payos')"
                              class="px-2 py-0.5 bg-green-100 text-green-700 text-xs rounded-full font-medium">💳 Quét QR</span>
                      </div>
                      <p class="text-sm text-gray-600">{{ method.moTa || 'Không có mô tả' }}</p>
                    </label>
                  </div>
                </div>

                <!-- Fallback nếu không có phương thức nào -->
                <div v-else class="p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
                  <p class="text-sm text-yellow-800">⚠️ Chưa có phương thức thanh toán nào. Vui lòng liên hệ admin.</p>
                </div>
              </div>
            </div>

            <!-- Order Notes Section -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
              <div class="p-6 border-b border-gray-200">
                <h2 class="text-xl font-bold text-gray-900 flex items-center gap-2">
                  <span class="material-symbols-outlined">note_alt</span>
                  Ghi chú đơn hàng
                </h2>
              </div>

              <div class="p-6">
                <textarea v-model="orderNote" rows="4"
                          class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-yellow-600 focus:border-transparent bg-white text-gray-900"
                          placeholder="Ghi chú thêm về đơn hàng (tùy chọn)..."></textarea>
              </div>
            </div>
          </div>

          <!-- Right Column: Order Summary -->
          <div class="lg:col-span-5">
            <div class="bg-white rounded-xl shadow-sm border border-gray-200 lg:sticky lg:top-6">
              <div class="p-6 border-b border-gray-200">
                <h2 class="text-xl font-bold text-gray-900">Đơn hàng của bạn</h2>
              </div>

              <!-- Cart Items -->
              <div class="p-6 max-h-96 overflow-y-auto">
                <div class="space-y-4">
                  <div v-for="item in cartItems" :key="item.id" class="flex gap-4 pb-4 border-b border-gray-200 last:border-0 last:pb-0">
                    <div class="relative flex-shrink-0 w-20 h-20 bg-gray-100 rounded-lg overflow-hidden">
                      <img :src="`/api/img/${item.anh}`" :alt="item.tenSP"
                           class="w-full h-full object-cover"
                           @error="$event.target.src='/img/placeholder.png'" />
                      <span class="absolute -top-2 -right-2 bg-yellow-600 text-white text-xs font-bold rounded-full w-6 h-6 flex items-center justify-center">
                        {{ item.soLuong }}
                      </span>
                    </div>
                    <div class="flex-1 min-w-0">
                      <p class="text-xs font-semibold text-gray-500 uppercase mb-1">{{ item.thuongHieu }}</p>
                      <h3 class="text-sm font-bold text-gray-900 line-clamp-1">{{ item.tenSP }}</h3>
                      <p class="text-xs text-gray-500 mt-1">
                        <span v-if="item.size">Size: {{ item.size }}</span>
                        <span v-if="item.size && item.mau"> • </span>
                        <span v-if="item.mau">Màu: {{ item.mau }}</span>
                      </p>
                      <p class="text-sm font-bold text-gray-900 mt-1">{{ formatPrice(item.thanhTien) }}</p>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Price Summary -->
              <div class="p-6 border-t border-gray-200 space-y-3">
                <div class="flex justify-between text-sm">
                  <span class="text-gray-600">Tạm tính:</span>
                  <span class="font-semibold text-gray-900">{{ formatPrice(orderSubtotal) }}</span>
                </div>
                <div class="flex justify-between text-sm">
                  <span class="text-gray-600">Phí vận chuyển:</span>
                  <span class="font-semibold text-green-600">Miễn phí</span>
                </div>
                <div class="pt-3 border-t border-gray-200">
                  <div class="flex justify-between items-center">
                    <span class="text-lg font-bold text-gray-900">Tổng cộng:</span>
                    <span class="text-2xl font-black text-yellow-600">{{ formatPrice(orderTotal) }}</span>
                  </div>
                </div>
              </div>

              <!-- Action Buttons -->
              <div class="p-6 border-t border-gray-200 space-y-3">
                <button type="submit" :disabled="isSubmitting"
                        class="w-full flex items-center justify-center gap-2 h-12 rounded-lg bg-yellow-600 text-white font-bold text-base hover:bg-yellow-700 transition-all shadow-md hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed">
                  <span v-if="!isSubmitting" class="material-symbols-outlined">shopping_bag</span>
                  <span v-if="!isSubmitting">Đặt hàng ngay</span>
                  <span v-else class="flex items-center gap-2">
                    <svg class="animate-spin h-5 w-5" fill="none" viewBox="0 0 24 24">
                      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Đang xử lý...
                  </span>
                </button>
                <a href="/giohang"
                   class="w-full flex items-center justify-center gap-2 h-12 rounded-lg border-2 border-gray-300 text-gray-900 font-semibold text-base hover:bg-gray-50 transition-all">
                  <span class="material-symbols-outlined">arrow_back</span>
                  <span>Quay lại giỏ hàng</span>
                </a>
              </div>

              <!-- Security Badge -->
              <div class="p-6 bg-gray-50 space-y-3">
                <div class="flex items-center gap-3 text-sm text-gray-600">
                  <span class="material-symbols-outlined text-green-600">verified</span>
                  <span>Giao dịch an toàn & bảo mật</span>
                </div>
                <div class="flex items-center gap-3 text-sm text-gray-600">
                  <span class="material-symbols-outlined text-green-600">policy</span>
                  <span>Chính sách đổi trả linh hoạt</span>
                </div>
                <div class="flex items-center gap-3 text-sm text-gray-600">
                  <span class="material-symbols-outlined text-green-600">support_agent</span>
                  <span>Hỗ trợ 24/7</span>
                </div>
              </div>
            </div>
          </div>
        </form>
      </div>
    </main>

    <AppFooter />
  </div>
</template>

<script>
import AppHeader from './fragments/AppHeader.vue'
import AppFooter from './fragments/AppFooter.vue'
import axios from 'axios'

export default {
  name: 'Checkout',
  components: {
    AppHeader,
    AppFooter
  },
  data() {
    return {
      loading: true,
      error: null,
      success: null,
      isSubmitting: false,
      diaChiList: [],
      paymentMethods: [],
      cartItems: [],
      selectedAddress: null,
      selectedPayment: null,
      orderNote: '',
      orderSubtotal: 0,
      orderTotal: 0
    }
  },
  methods: {
    async fetchCheckoutData() {
      this.loading = true
      this.error = null
      
      try {
        const response = await axios.get('/checkout')
        
        if (response.data.diaChiList) {
          this.diaChiList = response.data.diaChiList
          // Auto-select default address
          const defaultAddress = this.diaChiList.find(d => d.laMacDinh)
          if (defaultAddress) {
            this.selectedAddress = defaultAddress.maDiaChi
          } else if (this.diaChiList.length > 0) {
            this.selectedAddress = this.diaChiList[0].maDiaChi
          }
        }
        
        if (response.data.paymentMethods) {
          this.paymentMethods = response.data.paymentMethods
          // Auto-select first payment method
          if (this.paymentMethods.length > 0) {
            this.selectedPayment = this.paymentMethods[0].maHinhThucTT
          }
        }
        
        if (response.data.cartItems) {
          this.cartItems = response.data.cartItems
        }
        
        this.orderSubtotal = response.data.orderSubtotal || 0
        this.orderTotal = response.data.orderTotal || 0
        
      } catch (err) {
        console.error('Error fetching checkout data:', err)
        this.error = 'Không thể tải thông tin thanh toán. Vui lòng thử lại.'
      } finally {
        this.loading = false
      }
    },
    
    async handleSubmit() {
      if (!this.selectedAddress) {
        this.error = 'Vui lòng chọn địa chỉ giao hàng!'
        window.scrollTo({ top: 0, behavior: 'smooth' })
        return
      }
      
      if (!this.selectedPayment) {
        this.error = 'Vui lòng chọn phương thức thanh toán!'
        window.scrollTo({ top: 0, behavior: 'smooth' })
        return
      }
      
      this.isSubmitting = true
      this.error = null
      
      try {
        const response = await axios.post('/checkout/place-order', null, {
          params: {
            diaChiId: this.selectedAddress,
            paymentMethod: this.selectedPayment,
            ghiChu: this.orderNote || ''
          }
        })
        
        if (response.data.success) {
          // Redirect to success page or payment page
          if (response.data.redirectUrl) {
            window.location.href = response.data.redirectUrl
          } else {
            window.location.href = '/checkout-success'
          }
        } else {
          this.error = response.data.message || 'Đặt hàng thất bại'
          window.scrollTo({ top: 0, behavior: 'smooth' })
        }
      } catch (err) {
        console.error('Error placing order:', err)
        this.error = err.response?.data?.message || 'Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại.'
        window.scrollTo({ top: 0, behavior: 'smooth' })
      } finally {
        this.isSubmitting = false
      }
    },
    
    formatPrice(price) {
      if (!price) return '0 đ'
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price)
    }
  },
  
  mounted() {
    this.fetchCheckoutData()
  }
}
</script>

<style scoped>
/* Checkout specific styles */
</style>
