<template>
<div class="relative flex min-h-screen w-full flex-col bg-background-light dark:bg-background-dark">
    <AppHeader />
    
    <main class="flex-grow w-full px-4 md:px-[2cm] py-10">
        <h1 class="text-3xl font-bold mb-8">Giỏ hàng</h1>

        <!-- Loading State -->
        <div v-if="loading" class="text-center py-16">
            <div class="animate-spin rounded-full h-16 w-16 border-b-2 border-accent mx-auto"></div>
            <p class="mt-4 text-gray-600">Đang tải giỏ hàng...</p>
        </div>

        <!-- Empty Cart -->
        <div v-else-if="items.length === 0" class="text-center py-16 border border-gray-200 rounded-lg">
            <span class="material-symbols-outlined text-6xl text-gray-400 mb-4">shopping_cart</span>
            <p class="text-xl text-gray-600 mb-6">Giỏ hàng của bạn đang trống</p>
            <a href="/sanpham" class="inline-block px-6 py-3 bg-accent text-white rounded-lg font-semibold hover:bg-accent/90">
                Tiếp tục mua sắm
            </a>
        </div>

        <!-- Cart Items -->
        <div v-else class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Items List -->
            <div class="lg:col-span-2 space-y-6">
                <!-- Marketing Shipping Banner -->
                <div v-if="totalQuantity < 2" class="bg-[#FDF6ED] border border-[#F5E6D3] rounded-2xl p-5 flex items-center gap-4 animate-fadeIn transition-all">
                    <div class="bg-[#C8A97E] text-white w-12 h-12 rounded-full flex items-center justify-center flex-shrink-0 shadow-sm">
                        <span class="material-symbols-outlined">local_shipping</span>
                    </div>
                    <div>
                        <p class="text-sm font-bold text-[#111111] uppercase tracking-wider mb-1">Luxury Gift: Miễn phí vận chuyển</p>
                        <p class="text-xs text-gray-600">Mua thêm <span class="font-bold text-[#C8A97E] text-sm">01 sản phẩm</span> nữa để nhận ưu đãi Giao hàng miễn phí!</p>
                    </div>
                    <a href="/sanpham" class="ml-auto flex items-center gap-1 text-[10px] font-black uppercase tracking-widest text-[#C8A97E] hover:underline">
                        Chọn thêm <span class="material-symbols-outlined text-sm">arrow_forward</span>
                    </a>
                </div>
                <div v-else class="bg-[#EEF9F1] border border-[#D1EBD9] rounded-2xl p-5 flex items-center gap-4 animate-bounce-subtle">
                    <div class="bg-green-600 text-white w-12 h-12 rounded-full flex items-center justify-center flex-shrink-0 shadow-sm">
                        <span class="material-symbols-outlined">check_circle</span>
                    </div>
                    <div>
                        <p class="text-sm font-bold text-[#111111] uppercase tracking-wider mb-1">Chúc mừng thượng khách!</p>
                        <p class="text-xs text-gray-600">Đơn hàng của bạn đã đủ điều kiện nhận <span class="font-bold text-green-700">Giao hàng miễn phí</span>.</p>
                    </div>
                </div>

                <div v-for="item in items" :key="item.maGHCT" class="flex gap-4 border border-gray-100 rounded-2xl p-6 bg-white shadow-sm hover:shadow-md transition-all group">
                    <!-- Product Image -->
                    <a :href="`/sanpham/${item.sanPhamChiTiet.sanPham.maSP}`" class="flex-shrink-0 relative overflow-hidden rounded-xl">
                        <img 
                            :src="item.sanPhamChiTiet.sanPham.anhChinh || '/img/placeholder.png'" 
                            :alt="item.sanPhamChiTiet.sanPham.tenSP"
                            class="w-24 h-32 object-cover transform group-hover:scale-105 transition-transform duration-500"
                        >
                    </a>

                    <!-- Product Info -->
                    <div class="flex-grow flex flex-col">
                        <div class="flex justify-between items-start">
                            <div>
                                <p class="text-[9px] font-bold text-[#C8A97E] uppercase tracking-widest mb-1">{{ item.sanPhamChiTiet.sanPham.thuongHieu?.tenTH || 'Luxury Brand' }}</p>
                                <a :href="`/sanpham/${item.sanPhamChiTiet.sanPham.maSP}`" class="text-lg font-serif font-bold text-[#111111] hover:text-[#C8A97E] transition-colors uppercase leading-tight">
                                    {{ item.sanPhamChiTiet.sanPham.tenSP }}
                                </a>
                                <p class="text-xs text-gray-400 mt-2 flex gap-4 font-medium uppercase tracking-widest">
                                    <span v-if="item.sanPhamChiTiet.sizeSP">Size: {{ item.sanPhamChiTiet.sizeSP.tenSize }}</span>
                                    <span v-if="item.sanPhamChiTiet.mauSacSP">Màu: {{ item.sanPhamChiTiet.mauSacSP.tenMau }}</span>
                                </p>
                            </div>
                            <button 
                                @click="removeItem(item)" 
                                class="text-gray-300 hover:text-red-500 transition-colors p-2"
                                title="Xóa khỏi giỏ hàng"
                            >
                                <span class="material-symbols-outlined text-lg">close</span>
                            </button>
                        </div>
                        
                        <div class="mt-auto flex justify-between items-end pt-4 border-t border-gray-50">
                            <p class="text-lg font-bold text-[#111111] tracking-tight">{{ formatPrice(item.sanPhamChiTiet.giaBan) }}</p>

                            <!-- Quantity Controls -->
                            <div class="flex items-center gap-1 bg-[#F9F7F5] rounded-lg p-1 border border-gray-100">
                                <button 
                                    @click="updateQuantity(item, item.soLuong - 1)" 
                                    :disabled="item.soLuong <= 1"
                                    class="w-8 h-8 flex items-center justify-center text-gray-500 hover:text-[#C8A97E] disabled:opacity-30 transition-colors"
                                >
                                    <span class="material-symbols-outlined text-sm">remove</span>
                                </button>
                                <span class="w-8 text-center text-xs font-black text-[#111111]">{{ item.soLuong }}</span>
                                <button 
                                    @click="updateQuantity(item, item.soLuong + 1)"
                                    :disabled="item.soLuong >= (item.sanPhamChiTiet.soLuongTon || 99)"
                                    class="w-8 h-8 flex items-center justify-center text-gray-500 hover:text-[#C8A97E] disabled:opacity-30 transition-colors"
                                >
                                    <span class="material-symbols-outlined text-sm">add</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Cart Summary -->
            <div class="lg:col-span-1">
                <div class="bg-white rounded-3xl border border-[#C8A97E] p-8 shadow-xl sticky top-24">
                    <h2 class="text-xs font-black uppercase tracking-[0.3em] text-[#111111] mb-8 pb-4 border-b border-[#F5F1ED]">Thanh toán dự kiến</h2>
                    <div class="space-y-4">
                        <div class="flex justify-between text-xs font-bold uppercase tracking-widest text-gray-500">
                            <span>Tạm tính</span>
                            <span class="text-[#111111]">{{ formatPrice(subtotal) }}</span>
                        </div>
                        <div class="flex justify-between text-xs font-bold uppercase tracking-widest text-gray-500">
                            <span>Phí vận chuyển</span>
                            <span v-if="shippingFee > 0" class="text-[#111111]">{{ formatPrice(shippingFee) }}</span>
                            <span v-else class="text-green-600">Miễn phí</span>
                        </div>
                        <div class="flex justify-between items-baseline pt-8 border-t border-gray-100">
                            <span class="text-xs font-black uppercase tracking-[0.2em] text-[#111111]">Tổng cộng</span>
                            <span class="text-3xl font-bold text-[#C8A97E] tracking-tighter">{{ formatPrice(total) }}</span>
                        </div>
                    </div>
                    <a 
                        href="/checkout"
                        class="w-full block text-center bg-[#111111] text-white font-bold py-5 rounded-full mt-10 hover:bg-[#C8A97E] transition-all shadow-xl uppercase text-[11px] tracking-widest"
                    >
                        Tiến hành đặt hàng
                    </a>
                    <a href="/sanpham" class="w-full block text-center text-[10px] font-bold uppercase tracking-widest text-gray-400 mt-6 hover:text-[#C8A97E] transition-colors">
                        Tiếp tục mua sắm
                    </a>
                </div>
            </div>
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
  name: 'Giohang',
  components: {
    AppHeader,
    AppFooter
  },
  data() {
    return {
      loading: true,
      items: []
    }
  },
  computed: {
    totalQuantity() {
      return this.items.reduce((sum, item) => sum + item.soLuong, 0)
    },
    subtotal() {
      return this.items.reduce((sum, item) => {
        const price = item.sanPhamChiTiet.giaBan || 0
        return sum + (price * item.soLuong)
      }, 0)
    },
    shippingFee() {
      return this.totalQuantity >= 2 ? 0 : 30000
    },
    total() {
      return this.subtotal + this.shippingFee
    }
  },
  methods: {
    async fetchCart() {
      this.loading = true
      try {
        const response = await axios.get('/cart/items')
        if (response.data.success) {
          this.items = response.data.items || []
        }
      } catch (err) {
        console.error('Error fetching cart:', err)
        if (err.response?.status === 401) {
          window.$toast.warning('Vui lòng đăng nhập để trải nghiệm mua hàng!')
          this.items = []
        } else {
          window.$toast.error('Không thể tải giỏ hàng')
        }
      } finally {
        this.loading = false
      }
    },
    
    async updateQuantity(item, newQuantity) {
      if (newQuantity < 1) return
      
      try {
        const response = await axios.post('/cart/update', null, {
          params: { cartItemId: item.maGHCT, quantity: newQuantity }
        })
        
        if (response.data.success) {
          item.soLuong = newQuantity
        } else {
          window.$toast.info(response.data.message)
        }
      } catch (err) {
        console.error('Error updating quantity:', err)
        window.$toast.error('Không thể cập nhật số lượng')
      }
    },
    
    async removeItem(item) {
      const ok = await window.$confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?')
      if (!ok) return
      
      try {
        const response = await axios.post('/cart/remove', null, {
          params: { cartItemId: item.maGHCT }
        })
        
        if (response.data.success) {
          this.items = this.items.filter(i => i.maGHCT !== item.maGHCT)
          window.$toast.success('Đã xóa sản phẩm khỏi giỏ hàng')
        } else {
          window.$toast.error(response.data.message)
        }
      } catch (err) {
        console.error('Error removing item:', err)
        window.$toast.error('Không thể xóa sản phẩm')
      }
    },
    
    formatPrice(price) {
      if (!price) return '₫0'
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price)
    }
  },
  
  mounted() {
    this.fetchCart()
  }
}
</script>
