<template>
  <div class="relative flex min-h-screen w-full flex-col" style="background:#FDFCFB;">
    <AppHeader />

    <main class="flex-grow">
      <div class="w-full px-4 md:px-[2cm] py-10">

        <!-- Page Title — Luxury serif style khớp Home.vue -->
        <div class="mb-12">
          <p class="text-[11px] font-bold uppercase tracking-[0.4em] text-[#C8A97E] mb-3">Luxury Experience</p>
          <h1 class="font-serif text-4xl md:text-5xl font-bold text-[#111111] tracking-tight uppercase">Thanh toán</h1>
          <div class="w-20 h-[3px] mt-5 bg-[#C8A97E]"></div>
          <p class="mt-5 text-[13px] text-gray-400 uppercase tracking-[0.1em] font-medium">Hoàn tất đơn hàng kiệt tác của bạn</p>
        </div>

        <!-- Alert -->
        <div v-if="error" class="mb-6 p-4 border-l-4 border-red-600 bg-red-50">
          <p class="text-red-800 font-bold text-sm">{{ error }}</p>
        </div>

        <!-- Loading -->
        <div v-if="loading" class="flex flex-col items-center justify-center py-24">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-[#C8A97E] mb-4"></div>
          <p class="text-[#C8A97E] text-sm tracking-widest uppercase font-bold">Đang tải...</p>
        </div>

        <!-- Main grid -->
        <form v-else @submit.prevent="handleSubmit" class="grid grid-cols-1 lg:grid-cols-12 gap-10">

          <!-- LEFT: Shipping & Payment -->
          <div class="lg:col-span-7 space-y-8">

            <!-- ĐỊA CHỈ GIAO HÀNG -->
            <div class="bg-white border border-[#C8A97E]/30 shadow-sm rounded-2xl overflow-hidden">
              <div class="px-8 py-5 border-b border-[#F5F1ED] flex items-center justify-between" style="background:#FDFCFB;">
                <div class="flex items-center gap-3">
                  <span class="material-symbols-outlined text-[#C8A97E] text-xl">location_on</span>
                  <h2 class="font-serif font-bold text-[#111111] tracking-[0.1em] text-sm uppercase">1. Địa chỉ giao hàng</h2>
                </div>
              </div>
              <div class="p-6">
                <div v-if="diaChiList.length > 0" class="space-y-3">
                  <div v-for="diaChi in diaChiList" :key="diaChi.maDiaChi"
                    @click="selectedAddress = diaChi.maDiaChi"
                    :class="['flex items-start p-4 border cursor-pointer transition-all',
                              selectedAddress === diaChi.maDiaChi
                                ? 'border-[#C8A97E] bg-[#FDFCFB]'
                                : 'border-[#E5E7EB] hover:border-[#C8A97E]/50']">
                    <input type="radio" v-model="selectedAddress" :value="diaChi.maDiaChi" required
                           class="mt-1 h-4 w-4 accent-[#C8A97E]" />
                    <div class="ml-4 flex-1">
                      <div class="flex items-center gap-2 mb-0.5">
                        <span class="font-bold text-[#111111] text-sm">{{ diaChi.hoTenNguoiNhan }}</span>
                        <span v-if="diaChi.laMacDinh"
                          class="px-2 py-0.5 text-[10px] font-bold uppercase tracking-widest text-white"
                          style="background:#C8A97E;">Mặc định</span>
                      </div>
                      <p class="text-xs text-gray-500 mt-0.5">{{ diaChi.soDienThoai }}</p>
                      <p class="text-sm text-gray-600 mt-1 leading-relaxed">{{ diaChi.diaChiChiTiet }}</p>
                    </div>
                  </div>
                </div>
                <div v-else class="text-center py-10">
                  <span class="material-symbols-outlined text-5xl text-gray-200 block mb-3">location_off</span>
                  <p class="text-gray-500 text-sm mb-4">Bạn chưa có địa chỉ giao hàng.</p>
                  <button @click="showAddAddress = true"
                     class="inline-flex items-center gap-2 px-6 py-2.5 bg-[#111111] text-white text-xs uppercase font-bold tracking-widest hover:bg-[#C8A97E] transition-colors rounded-xl">
                    <span class="material-symbols-outlined text-sm">add</span>Thêm địa chỉ
                  </button>
                </div>
                <!-- Inline Add Address Toggle -->
                <div v-if="diaChiList.length > 0" class="mt-4 pt-4 border-t border-[#E5E7EB]">
                  <button @click="showAddAddress = !showAddAddress" type="button"
                     class="inline-flex items-center gap-1.5 text-[#C8A97E] hover:underline text-xs font-bold uppercase tracking-widest nav-link">
                    <span class="material-symbols-outlined text-sm">{{ showAddAddress ? 'remove_circle' : 'add_circle' }}</span>
                    {{ showAddAddress ? 'Hủy thêm địa chỉ' : 'Thêm địa chỉ mới' }}
                  </button>
                </div>

                <!-- Inline Add Address Form -->
                <div v-if="showAddAddress" class="mt-5 p-5 bg-[#FDFCFB] border border-[#C8A97E]/40 rounded-xl space-y-4 shadow-inner">
                  <h3 class="text-xs font-bold text-[#111111] uppercase tracking-widest mb-1">Thêm địa chỉ mới</h3>
                  <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <input v-model="newAddress.ten" type="text" placeholder="Họ và tên người nhận (*)" class="w-full px-4 py-3 bg-white border border-[#E5E7EB] rounded-xl text-sm focus:border-[#C8A97E] outline-none transition-colors" />
                    <input v-model="newAddress.phone" type="text" placeholder="Số điện thoại (*)" class="w-full px-4 py-3 bg-white border border-[#E5E7EB] rounded-xl text-sm focus:border-[#C8A97E] outline-none transition-colors" />
                  </div>
                  <textarea v-model="newAddress.diaChi" rows="2" placeholder="Địa chỉ chi tiết (Số nhà, đường, phường/xã, quận/huyện, tỉnh/TP) (*)" class="w-full px-4 py-3 bg-white border border-[#E5E7EB] rounded-xl text-sm focus:border-[#C8A97E] outline-none transition-colors"></textarea>
                  <button @click="saveNewAddress" type="button" :disabled="isSavingAddress" class="px-6 py-3 bg-[#111111] text-white rounded-xl text-xs font-bold uppercase tracking-widest hover:bg-[#C8A97E] disabled:opacity-50 transition-colors shadow-md">
                    {{ isSavingAddress ? 'Đang lưu...' : 'Lưu địa chỉ' }}
                  </button>
                </div>
              </div>
            </div>

            <!-- PHƯƠNG THỨC THANH TOÁN -->
            <div class="bg-white border border-[#C8A97E]/30 shadow-sm rounded-2xl overflow-hidden mt-8">
              <div class="px-8 py-5 border-b border-[#F5F1ED] flex items-center justify-between" style="background:#FDFCFB;">
                <div class="flex items-center gap-3">
                  <span class="material-symbols-outlined text-[#C8A97E] text-xl">account_balance_wallet</span>
                  <h2 class="font-serif font-bold text-[#111111] tracking-[0.1em] text-sm uppercase">2. Phương thức thanh toán</h2>
                </div>
              </div>
              <div class="p-6">
                <div v-if="paymentMethods.length > 0" class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <label v-for="method in paymentMethods" :key="method.maHinhThucTT"
                    :class="['flex items-center p-5 border rounded-xl cursor-pointer transition-all shadow-sm',
                              selectedPayment === method.maHinhThucTT
                                ? 'border-[#C8A97E] bg-[#FDFCFB] ring-1 ring-[#C8A97E]'
                                : 'border-[#E5E7EB] bg-white hover:border-[#C8A97E]/50']">
                    <input type="radio" v-model="selectedPayment" :value="method.maHinhThucTT" required
                           class="h-5 w-5 accent-[#C8A97E]" />
                    <div class="ml-4 flex items-center gap-3">
                      <span class="material-symbols-outlined text-[#C8A97E] text-2xl">{{ method.icon || 'credit_card' }}</span>
                      <div>
                        <p class="font-bold text-[#111111] text-[13px] uppercase tracking-wider">{{ method.tenHinhThuc }}</p>
                        <p v-if="method.tenHinhThuc && method.tenHinhThuc.toLowerCase().includes('payos')"
                           class="text-[10px] text-gray-400 uppercase tracking-widest mt-1">PayOS Security QR</p>
                      </div>
                    </div>
                  </label>
                </div>
                <div v-else class="p-4 border-l-4 border-amber-400 bg-amber-50 text-sm text-amber-800">
                  Chưa có phương thức thanh toán. Vui lòng liên hệ hỗ trợ.
                </div>
              </div>
            </div>

            <!-- GHI CHÚ -->
            <div class="bg-white border border-[#C8A97E]/30 shadow-sm rounded-2xl overflow-hidden mt-8">
              <div class="px-8 py-5 border-b border-[#F5F1ED] flex items-center gap-3" style="background:#FDFCFB;">
                <span class="material-symbols-outlined text-[#C8A97E] text-lg">chat_bubble_outline</span>
                <h2 class="font-serif font-bold text-[#111111] tracking-[0.1em] text-sm uppercase">3. Ghi chú đơn hàng</h2>
              </div>
              <div class="p-6">
                <textarea v-model="orderNote" rows="3"
                  class="w-full px-4 py-3 border border-[#E5E7EB] text-sm outline-none focus:border-[#C8A97E] transition-colors bg-[#FDFCFB]"
                  placeholder="Yêu cầu riêng cho chúng tôi..."></textarea>
              </div>
            </div>

          </div>

          <!-- RIGHT: Order Summary -->
          <div class="lg:col-span-5">
            <div class="sticky top-6 bg-white border border-[#C8A97E]/30 shadow-md rounded-2xl overflow-hidden">

              <!-- Header -->
              <div class="px-6 py-4 flex items-center gap-2" style="background:#111111;">
                <h2 class="font-serif font-bold text-white uppercase tracking-widest text-sm">Đơn hàng của bạn</h2>
              </div>

              <!-- Cart Items -->
              <div class="max-h-80 overflow-y-auto custom-scrollbar">
                <div v-for="item in cartItems" :key="item.id"
                  class="flex gap-4 p-4 border-b border-[#E5E7EB] last:border-0">
                  <div class="relative flex-shrink-0 w-20 h-24 bg-[#F5F1ED] overflow-hidden rounded-xl">
                    <img :src="item.anh && item.anh.startsWith('http') ? item.anh : `/api/img/${item.anh}`" :alt="item.tenSP"
                         class="w-full h-full object-cover"
                         @error="$event.target.src='/img/placeholder.png'" />
                    <span class="absolute top-0 right-0 bg-[#111111] text-white text-[10px] font-bold w-5 h-5 flex items-center justify-center rounded-bl-lg">
                      {{ item.soLuong }}
                    </span>
                  </div>
                  <div class="flex-1 min-w-0 py-1">
                    <p class="text-[10px] font-bold text-[#C8A97E] uppercase tracking-widest">{{ item.thuongHieu }}</p>
                    <h3 class="text-xs font-bold text-[#111111] mt-0.5 leading-tight uppercase line-clamp-2">{{ item.tenSP }}</h3>
                    <div class="flex gap-2 mt-1.5">
                      <span v-if="item.size" class="text-[10px] text-gray-500 font-bold px-1.5 py-0.5 border border-[#E5E7EB]">{{ item.size }}</span>
                      <span v-if="item.mau" class="text-[10px] text-gray-500 font-bold px-1.5 py-0.5 border border-[#E5E7EB]">{{ item.mau }}</span>
                    </div>
                    <p class="text-sm font-bold text-[#111111] mt-2">{{ formatPrice(item.thanhTien) }}</p>
                  </div>
                </div>
              </div>

              <!-- Voucher -->
              <div class="p-8 border-t border-[#E5E7EB]" style="background:#F9F7F5;">
                <p class="text-[10px] font-bold uppercase tracking-[0.25em] text-[#C8A97E] mb-4">Mã ưu đãi (Voucher)</p>
                
                <!-- Display available vouchers -->
                <div v-if="!appliedVoucher && availableVouchers.length > 0" class="mb-5 space-y-2">
                  <div class="max-h-40 overflow-y-auto custom-scrollbar space-y-2 pr-1">
                    <div v-for="v in availableVouchers" :key="v.maVoucher" 
                         @click="voucherCode = v.code; applyVoucher()"
                         class="p-4 bg-white border border-[#C8A97E]/40 rounded-xl cursor-pointer hover:border-[#C8A97E] hover:shadow-md active:bg-yellow-50 flex justify-between items-center transition-all group">
                       <div>
                         <p class="font-bold text-[#111111] text-[13px] uppercase tracking-wider group-hover:text-[#C8A97E] transition-colors">{{ v.code }}</p>
                         <p class="text-[10px] text-gray-500 mt-1 uppercase tracking-widest font-semibold flex items-center gap-1">
                           <span class="material-symbols-outlined text-[12px] text-green-600">sell</span>
                           Giảm {{ v.loaiGiamGia === 0 ? v.giaTri + '%' : formatPrice(v.giaTri) }} {{ v.giaTriToiDa ? '(Tối đa ' + formatPrice(v.giaTriToiDa) + ')' : '' }}
                         </p>
                       </div>
                       <span class="text-[9px] font-black text-white tracking-[0.2em] uppercase py-2 px-4 bg-[#111111] rounded-full group-hover:bg-[#C8A97E] transition-all shadow-sm">Áp dụng</span>
                    </div>
                  </div>
                </div>

                <div class="flex gap-3">
                  <input
                    v-model="voucherCode"
                    type="text"
                    placeholder="ENTER CODE"
                    :disabled="!!appliedVoucher"
                    class="flex-1 px-5 py-3.5 border border-[#E5E7EB] text-xs uppercase font-bold tracking-[0.2em] outline-none focus:border-[#C8A97E] bg-white transition-all shadow-sm rounded-sm"
                  />
                  <button v-if="!appliedVoucher"
                    @click="applyVoucher" type="button"
                    class="px-6 py-3.5 bg-[#111111] text-white text-[11px] rounded-full uppercase font-bold tracking-[0.2em] hover:bg-[#C8A97E] transition-all shadow-md active:scale-95">
                    Áp dụng
                  </button>
                  <button v-else
                    @click="removeVoucher" type="button"
                    class="px-6 py-3.5 bg-red-600 text-white text-[11px] rounded-full uppercase font-bold tracking-[0.2em] hover:bg-red-700 transition-all shadow-md active:scale-95">
                    Gỡ bỏ
                  </button>
                </div>
                <p v-if="voucherMessage"
                   :class="['text-[11px] mt-4 font-bold tracking-wide flex items-center gap-2', appliedVoucher ? 'text-green-700' : 'text-red-600']">
                  <span class="material-symbols-outlined text-sm">{{ appliedVoucher ? 'check_circle' : 'error' }}</span>
                  {{ voucherMessage }}
                </p>
              </div>

              <!-- Price Summary -->
              <div class="p-8 border-t border-[#E5E7EB] space-y-4">
                <div class="flex justify-between text-sm">
                  <span class="text-gray-400 uppercase tracking-[0.2em] text-[10px] font-bold">Tạm tính:</span>
                  <span class="font-bold text-[#111111]">{{ formatPrice(orderSubtotal) }}</span>
                </div>
                <div v-if="appliedVoucher && discountAmount > 0" class="flex justify-between text-sm">
                  <span class="text-gray-400 uppercase tracking-[0.2em] text-[10px] font-bold">Mã ưu đãi:</span>
                  <span class="font-bold text-green-700 tracking-wide">- {{ formatPrice(discountAmount) }}</span>
                </div>
                <div class="flex justify-between text-sm">
                  <span class="text-gray-400 uppercase tracking-[0.2em] text-[10px] font-bold">Vận chuyển:</span>
                  <span class="font-bold text-[#C8A97E] text-[11px] tracking-widest uppercase">Premium Delivery Service</span>
                </div>
                <div class="flex justify-between text-[10px]">
                  <span class="text-gray-400 uppercase tracking-[0.1em]">Phí vận chuyển:</span>
                  <span class="text-green-600 font-bold uppercase tracking-widest">Miễn phí</span>
                </div>

                <!-- Total -->
                <div class="pt-4 border-t border-[#E5E7EB]">
                  <div class="flex justify-between items-baseline">
                    <span class="text-xs font-bold uppercase tracking-widest text-[#111111]">Tổng cộng:</span>
                    <span class="text-2xl font-bold" style="color:#C8A97E;">{{ formatPrice(finalTotal) }}</span>
                  </div>
                </div>
              </div>

              <!-- Submit Button -->
              <div class="px-5 pb-5 space-y-3">
                <button type="submit" :disabled="isSubmitting"
                  class="w-full flex items-center justify-center gap-3 py-5 bg-[#111111] text-white text-[11px] rounded-full font-bold uppercase tracking-[0.3em] hover:bg-[#C8A97E] transition-all shadow-xl disabled:opacity-50 active:scale-[0.98]">
                  <span v-if="!isSubmitting" class="material-symbols-outlined text-base leading-none">diamond</span>
                  <span>{{ isSubmitting ? 'ĐANG XỬ LÝ GIAO DỊCH...' : 'XÁC NHẬN THANH TOÁN' }}</span>
                </button>
                <a href="/giohang"
                  class="w-full flex items-center justify-center gap-2 py-4 border border-[#E5E7EB] text-gray-400 text-[10px] rounded-full font-bold uppercase tracking-[0.2em] hover:border-[#111111] hover:text-[#111111] transition-all">
                  <span class="material-symbols-outlined text-sm">arrow_back</span>Quay lại túi hàng
                </a>
              </div>

              <!-- Security Badges -->
              <div class="grid grid-cols-2 divide-x divide-[#E5E7EB] border-t border-[#E5E7EB]" style="background:#F5F1ED;">
                <div class="flex flex-col items-center gap-1 p-4 text-center">
                  <span class="material-symbols-outlined text-xl text-[#C8A97E]">verified</span>
                  <p class="text-[9px] font-bold uppercase tracking-widest text-gray-500">Giao dịch bảo mật</p>
                </div>
                <div class="flex flex-col items-center gap-1 p-4 text-center">
                  <span class="material-symbols-outlined text-xl text-[#C8A97E]">local_shipping</span>
                  <p class="text-[9px] font-bold uppercase tracking-widest text-gray-500">Giao hàng Premium</p>
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
  components: { AppHeader, AppFooter },
  data() {
    return {
      loading: true,
      error: null,
      isSubmitting: false,
      diaChiList: [],
      paymentMethods: [],
      cartItems: [],
      selectedAddress: null,
      selectedPayment: null,
      orderNote: '',
      orderSubtotal: 0,
      voucherCode: '',
      appliedVoucher: null,
      voucherMessage: '',
      discountAmount: 0,
      
      // Address creation state & Vouchers
      showAddAddress: false,
      isSavingAddress: false,
      newAddress: { ten: '', phone: '', diaChi: '' },
      availableVouchers: []
    }
  },
  computed: {
    finalTotal() {
      return Math.max(0, (this.orderSubtotal || 0) - this.discountAmount)
    }
  },
  methods: {
    async fetchCheckoutData() {
      this.loading = true
      this.error = null
      try {
        const res = await axios.get('/checkout')
        if (res.data.diaChiList) {
          this.diaChiList = res.data.diaChiList
          const def = this.diaChiList.find(d => d.laMacDinh)
          this.selectedAddress = def ? def.maDiaChi : (this.diaChiList[0]?.maDiaChi || null)
        }
        if (res.data.paymentMethods) {
          this.paymentMethods = res.data.paymentMethods
          if (this.paymentMethods.length > 0) this.selectedPayment = this.paymentMethods[0].maHinhThucTT
        }
        if (res.data.cartItems) this.cartItems = res.data.cartItems
        this.orderSubtotal = res.data.orderSubtotal || 0
        
        // After establishing subtotal, fetch available vouchers
        this.fetchAvailableVouchers()
      } catch (err) {
        if (err.response?.status === 401) {
          window.$toast.warning('Vui lòng đăng nhập để trải nghiệm mua hàng!')
          setTimeout(() => { window.location.href = '/login' }, 2000)
        } else {
          this.error = 'Không thể tải thông tin thanh toán. Vui lòng thử lại.'
        }
      } finally {
        this.loading = false
      }
    },

    async applyVoucher() {
      if (!this.voucherCode) return
      this.voucherMessage = ''
      try {
        const res = await axios.get('/vouchers/check', {
          params: { code: this.voucherCode, orderAmount: this.orderSubtotal }
        })
        if (res.data.success) {
          this.appliedVoucher = res.data
          this.calculateDiscount()
          this.voucherMessage = '✓ Đã áp dụng mã ưu đãi thành công.'
        } else {
          this.voucherMessage = res.data.message || 'Mã không hợp lệ.'
        }
      } catch {
        this.voucherMessage = 'Không thể kiểm tra mã. Vui lòng thử lại.'
      }
    },

    async fetchAvailableVouchers() {
      if (this.orderSubtotal <= 0) return;
      try {
        const res = await axios.get('/vouchers/available', {
          params: { orderAmount: this.orderSubtotal }
        })
        if (res.data && Array.isArray(res.data)) {
          this.availableVouchers = res.data
        }
      } catch (err) {
        console.error("Voucher fetch err", err)
      }
    },

    async saveNewAddress() {
      if (!this.newAddress.ten || !this.newAddress.phone || !this.newAddress.diaChi) {
        window.$toast.error('Vui lòng nhập đầy đủ thông tin địa chỉ (*)');
        return;
      }
      
      const phoneRegex = /^(0)(3|5|7|8|9)[0-9]{8}$/;
      if (!phoneRegex.test(this.newAddress.phone)) {
        window.$toast.error('Số điện thoại không hợp lệ. Vui lòng nhập đúng 10 số, bắt đầu bằng 0 (vd: 0912345678).');
        return;
      }
      
      this.isSavingAddress = true;
      try {
        const formData = new FormData()
        formData.append("hoTenNguoiNhan", this.newAddress.ten)
        formData.append("soDienThoai", this.newAddress.phone)
        formData.append("diaChiChiTiet", this.newAddress.diaChi)
        
        await axios.post("/profile/address/add", formData)
        window.$toast.success("Đã thêm địa chỉ mới!")
        this.showAddAddress = false
        this.newAddress = { ten: '', phone: '', diaChi: '' }
        
        // Refresh checkout data to load new address
        await this.fetchCheckoutData()
      } catch (e) {
        console.error("Save address err", e)
        window.$toast.error("Không thể thêm địa chỉ mới. Thử lại sau.")
      } finally {
        this.isSavingAddress = false
      }
    },

    calculateDiscount() {
      if (!this.appliedVoucher) { this.discountAmount = 0; return }
      const v = this.appliedVoucher
      if (v.loaiGiamGia === 0) {
        let disc = this.orderSubtotal * (v.giaTri / 100)
        if (v.giaTriToiDa && disc > v.giaTriToiDa) disc = v.giaTriToiDa
        this.discountAmount = disc
      } else {
        this.discountAmount = Math.min(v.giaTri, this.orderSubtotal)
      }
    },

    removeVoucher() {
      this.appliedVoucher = null
      this.discountAmount = 0
      this.voucherCode = ''
      this.voucherMessage = ''
    },

    async handleSubmit() {
      if (!this.selectedAddress) return this.showError('Vui lòng chọn địa chỉ giao hàng.')
      if (!this.selectedPayment) return this.showError('Vui lòng chọn phương thức thanh toán.')
      this.isSubmitting = true
      this.error = null
      try {
        const res = await axios.post('/checkout/place-order', null, {
          params: {
            diaChiId: this.selectedAddress,
            paymentMethod: this.selectedPayment,
            ghiChu: this.orderNote || '',
            voucherId: this.appliedVoucher ? this.appliedVoucher.maVoucher : null
          }
        })
        if (res.data.success) {
          window.location.href = res.data.redirectUrl || '/checkout-success'
        } else {
          this.showError(res.data.message || 'Đặt hàng thất bại.')
        }
      } catch {
        this.showError('Có lỗi xảy ra. Vui lòng thử lại.')
      } finally {
        this.isSubmitting = false
      }
    },

    showError(msg) {
      this.error = msg
      window.scrollTo({ top: 0, behavior: 'smooth' })
    },

    formatPrice(price) {
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price || 0)
    }
  },
  mounted() {
    this.fetchCheckoutData()
  }
}
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar { width: 4px; }
.custom-scrollbar::-webkit-scrollbar-track { background: #F5F1ED; }
.custom-scrollbar::-webkit-scrollbar-thumb { background: #C8A97E; }
</style>
