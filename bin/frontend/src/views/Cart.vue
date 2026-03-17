<template>
<div class="relative flex min-h-screen w-full flex-col bg-background-light dark:bg-background-dark">
    <AppHeader />
    
    <main class="flex-grow container mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <h1 class="text-3xl font-bold mb-8">Shopping Cart</h1>

        <!-- Loading State -->
        <div v-if="loading" class="text-center py-16">
            <div class="animate-spin rounded-full h-16 w-16 border-b-2 border-accent mx-auto"></div>
            <p class="mt-4 text-gray-600">Loading cart...</p>
        </div>

        <!-- Empty Cart -->
        <div v-else-if="items.length === 0" class="text-center py-16 border border-gray-200 rounded-lg">
            <span class="material-symbols-outlined text-6xl text-gray-400 mb-4">shopping_cart</span>
            <p class="text-xl text-gray-600 mb-6">Your cart is empty</p>
            <a href="/sanpham" class="inline-block px-6 py-3 bg-accent text-white rounded-lg font-semibold hover:bg-accent/90">
                Continue Shopping
            </a>
        </div>

        <!-- Cart Items -->
        <div v-else class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Items List -->
            <div class="lg:col-span-2 space-y-4">
                <div v-for="item in items" :key="item.maGHCT" class="flex gap-4 border border-gray-200 rounded-lg p-4">
                    <!-- Product Image -->
                    <a :href="`/sanpham/${item.sanPhamChiTiet.sanPham.maSP}`" class="flex-shrink-0">
                        <img 
                            :src="item.sanPhamChiTiet.sanPham.anhChinh || '/img/placeholder.png'" 
                            :alt="item.sanPhamChiTiet.sanPham.tenSP"
                            class="w-24 h-24 object-cover rounded-lg"
                        >
                    </a>

                    <!-- Product Info -->
                    <div class="flex-grow">
                        <a :href="`/sanpham/${item.sanPhamChiTiet.sanPham.maSP}`" class="text-lg font-semibold hover:underline">
                            {{ item.sanPhamChiTiet.sanPham.tenSP }}
                        </a>
                        <p class="text-sm text-gray-600 mt-1">
                            <span v-if="item.sanPhamChiTiet.sizeSP">Size: {{ item.sanPhamChiTiet.sizeSP.tenSize }}</span>
                            <span v-if="item.sanPhamChiTiet.mauSacSP" class="ml-2">Color: {{ item.sanPhamChiTiet.mauSacSP.tenMau }}</span>
                        </p>
                        <p class="text-lg font-bold text-accent mt-2">{{ formatPrice(item.sanPhamChiTiet.giaBan) }}</p>

                        <!-- Quantity Controls -->
                        <div class="flex items-center gap-4 mt-4">
                            <div class="flex items-center gap-2">
                                <button 
                                    @click="updateQuantity(item, item.soLuong - 1)" 
                                    :disabled="item.soLuong <= 1"
                                    class="w-8 h-8 border border-gray-300 rounded hover:bg-gray-100 disabled:opacity-50"
                                >
                                    -
                                </button>
                                <span class="w-12 text-center font-medium">{{ item.soLuong }}</span>
                                <button 
                                    @click="updateQuantity(item, item.soLuong + 1)"
                                    :disabled="item.soLuong >= (item.sanPhamChiTiet.soLuongTon || 99)"
                                    class="w-8 h-8 border border-gray-300 rounded hover:bg-gray-100 disabled:opacity-50"
                                >
                                    +
                                </button>
                            </div>
                            <button 
                                @click="removeItem(item)" 
                                class="text-red-600 text-sm hover:underline ml-auto"
                            >
                                Remove
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Cart Summary -->
            <div class="lg:col-span-1">
                <div class="border border-gray-200 rounded-lg p-6 sticky top-24">
                    <h2 class="text-xl font-bold mb-4">Order Summary</h2>
                    <div class="space-y-3 border-t border-gray-200 pt-4">
                        <div class="flex justify-between">
                            <span class="text-gray-600">Subtotal</span>
                            <span class="font-medium">{{ formatPrice(subtotal) }}</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-600">Shipping</span>
                            <span class="font-medium">Free</span>
                        </div>
                        <div class="flex justify-between text-lg font-bold border-t border-gray-200 pt-3">
                            <span>Total</span>
                            <span class="text-accent">{{ formatPrice(total) }}</span>
                        </div>
                    </div>
                    <a 
                        href="/checkout"
                        class="w-full block text-center bg-black text-white font-bold py-3 rounded-lg mt-6 hover:bg-gray-800"
                    >
                        Proceed to Checkout
                    </a>
                    <a href="/sanpham" class="w-full block text-center text-gray-600 mt-4 hover:underline">
                        Continue Shopping
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
    subtotal() {
      return this.items.reduce((sum, item) => {
        const price = item.sanPhamChiTiet.giaBan || 0
        return sum + (price * item.soLuong)
      }, 0)
    },
    total() {
      return this.subtotal // Add shipping, tax, etc. here if needed
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
        alert('Failed to load cart')
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
          alert(response.data.message)
        }
      } catch (err) {
        console.error('Error updating quantity:', err)
        alert('Failed to update quantity')
      }
    },
    
    async removeItem(item) {
      if (!confirm('Remove this item from cart?')) return
      
      try {
        const response = await axios.post('/cart/remove', null, {
          params: { cartItemId: item.maGHCT }
        })
        
        if (response.data.success) {
          this.items = this.items.filter(i => i.maGHCT !== item.maGHCT)
        } else {
          alert(response.data.message)
        }
      } catch (err) {
        console.error('Error removing item:', err)
        alert('Failed to remove item')
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
