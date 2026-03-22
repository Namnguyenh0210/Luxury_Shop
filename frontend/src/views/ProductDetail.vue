<template>
<div class="relative flex min-h-screen w-full flex-col bg-background-light dark:bg-background-dark">
    <AppHeader />
    
    <main class="flex-grow">
        <!-- Loading State -->
        <div v-if="loading" class="container mx-auto px-4 py-16 text-center">
            <div class="animate-spin rounded-full h-16 w-16 border-b-2 border-accent mx-auto"></div>
            <p class="mt-4 text-gray-600">Đang tải sản phẩm...</p>
        </div>

        <!-- Lỗi -->
        <div v-else-if="error" class="container mx-auto px-4 py-16 text-center">
            <span class="material-symbols-outlined text-6xl text-red-600 mb-4">error</span>
            <p class="text-red-600 mb-4">{{ error }}</p>
            <a href="/sanpham" class="px-6 py-2 bg-black text-white rounded-lg hover:bg-gray-800">
                Quay lại danh sách sản phẩm
            </a>
        </div>

        <!-- Product Detail -->
        <div v-else-if="product" class="container mx-auto px-4 sm:px-6 lg:px-8 py-10">
            <!-- Breadcrumb -->
            <nav class="mb-6 text-sm">
                <a href="/" class="text-gray-500 hover:text-gray-700">Trang chủ</a>
                <span class="mx-2 text-gray-400">/</span>
                <a href="/sanpham" class="text-gray-500 hover:text-gray-700">Sản phẩm</a>
                <span class="mx-2 text-gray-400">/</span>
                <span class="text-gray-900">{{ product.tenSP }}</span>
            </nav>

            <!-- Product Main Section -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 mb-16">
                <!-- Product Images -->
                <div class="space-y-4">
                    <div class="aspect-square bg-gray-100 rounded-lg overflow-hidden">
                        <img 
                            :src="currentImage" 
                            :alt="product.tenSP"
                            class="w-full h-full object-cover"
                            @error="handleImageError"
                        >
                    </div>
                    <!-- Image Thumbnails (if product has multiple images) -->
                    <div v-if="productImages.length > 1" class="grid grid-cols-4 gap-2">
                        <button 
                            v-for="(img, index) in productImages" 
                            :key="index"
                            @click="currentImage = img"
                            :class="['aspect-square bg-gray-100 rounded-lg overflow-hidden border-2 transition-colors',
                                     currentImage === img ? 'border-accent' : 'border-transparent hover:border-gray-300']"
                        >
                            <img :src="img" :alt="`${product.tenSP} ${index + 1}`" class="w-full h-full object-cover">
                        </button>
                    </div>
                </div>

                <!-- Product Info -->
                <div class="space-y-6">
                    <div>
                        <p class="text-sm text-gray-600 uppercase">{{ product.thuongHieu?.tenTH || 'Thương hiệu' }}</p>
                        <h1 class="text-3xl lg:text-4xl font-bold text-gray-900 mt-2">{{ product.tenSP }}</h1>
                    </div>

                    <!-- Price -->
                    <div class="border-t border-b border-gray-200 py-4">
                        <div v-if="minPrice && maxPrice && minPrice.toString() !== maxPrice.toString()" class="text-3xl font-bold text-[#C8A97E]">
                            {{ formatPrice(minPrice) }} - {{ formatPrice(maxPrice) }}
                        </div>
                        <div v-else-if="minPrice" class="text-3xl font-bold text-[#C8A97E]">
                            {{ formatPrice(minPrice) }}
                        </div>
                        <div v-else class="text-3xl font-bold text-[#C8A97E]">
                            Liên hệ
                        </div>
                        <p class="text-sm text-gray-600 mt-1">{{ totalStock > 0 ? `${totalStock} sản phẩm trong kho` : 'Hết hàng' }}</p>
                    </div>

                    <!-- Variant Selection -->
                    <div v-if="variants.length > 0" class="space-y-4">
                        <!-- Size Selection -->
                        <div v-if="availableSizes.length > 0">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Kích thước (Size)</label>
                            <div class="flex flex-wrap gap-2">
                                <button 
                                    v-for="size in availableSizes" 
                                    :key="size"
                                    @click="selectedSize = size"
                                    :class="['px-4 py-2 border rounded-md font-medium transition-all duration-200 min-w-[3rem] text-center',
                                             selectedSize === size ? 'item-active' : 'item-inactive']"
                                >
                                    {{ size }}
                                </button>
                            </div>
                        </div>

                        <!-- Color Selection -->
                        <div v-if="availableColors.length > 0">
                            <label class="block text-sm font-medium text-gray-700 mb-2">Màu sắc (Color)</label>
                            <div class="flex flex-wrap gap-2">
                                <button 
                                    v-for="color in availableColors" 
                                    :key="color"
                                    @click="selectedColor = color"
                                    :class="['px-4 py-2 border rounded-md font-medium transition-all duration-200 min-w-[4rem] text-center',
                                             selectedColor === color ? 'item-active' : 'item-inactive']"
                                >
                                    {{ color }}
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Quantity -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Số lượng</label>
                        <div class="flex items-center space-x-4">
                            <button 
                                @click="decreaseQuantity" 
                                class="w-10 h-10 border border-gray-300 rounded-md hover:bg-gray-100 transition-colors"
                                :disabled="quantity <= 1"
                            >
                                -
                            </button>
                            <input 
                                v-model.number="quantity" 
                                type="number" 
                                min="1" 
                                class="w-20 text-center border border-gray-300 rounded-md py-2 focus:border-black outline-none"
                            >
                            <button 
                                @click="increaseQuantity" 
                                class="w-10 h-10 border border-gray-300 rounded-md hover:bg-gray-100 transition-colors"
                                :disabled="quantity >= maxQuantity"
                            >
                                +
                            </button>
                        </div>
                    </div>

                    <!-- Actions: Add to Cart & Wishlist -->
                    <div class="flex gap-4">
                        <button 
                            @click="addToCart"
                            :disabled="!canAddToCart"
                            class="flex-grow bg-black text-white text-lg font-bold py-4 rounded-lg hover:bg-gray-800 disabled:bg-gray-400 disabled:cursor-not-allowed transition-all active:scale-[0.98] shadow-lg shadow-black/10"
                        >
                            {{ totalStock > 0 ? 'Thêm vào giỏ hàng' : 'Hết hàng' }}
                        </button>
                        <button 
                            @click="toggleWishlist"
                            class="w-16 flex items-center justify-center border-2 border-gray-900 rounded-lg hover:bg-gray-50 transition-all group"
                        >
                            <span 
                                class="material-symbols-outlined text-2xl transition-all group-active:scale-125"
                                :class="isFavorite ? 'text-red-600 fill-icon' : 'text-gray-900'"
                            >
                                {{ isFavorite ? 'favorite' : 'favorite_border' }}
                            </span>
                        </button>
                    </div>

                    <!-- Product Description -->
                    <div class="border-t border-gray-200 pt-6">
                        <h3 class="text-lg font-semibold mb-2">Mô tả sản phẩm</h3>
                        <p class="text-gray-700 whitespace-pre-line">{{ product.moTa || 'Không có mô tả cho sản phẩm này.' }}</p>
                    </div>
                </div>
            </div>

            <!-- Reviews Section - Component mới -->
            <div class="mt-16 max-w-4xl mx-auto">
                <ProductReviews :productId="product.maSP" />
            </div>


            <!-- Related Products -->
            <div v-if="relatedProducts.length > 0" class="border-t border-gray-200 pt-12">
                <h2 class="text-2xl font-bold mb-6">Có thể bạn quan tâm</h2>
                <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                    <a 
                        v-for="item in relatedProducts" 
                        :key="item.maSP"
                        :href="`/sanpham/${item.maSP}`"
                        class="group"
                    >
                        <div class="aspect-[3/4] bg-gray-100 rounded-lg overflow-hidden mb-3">
                            <img 
                                :src="item.anhChinh || '/img/placeholder.png'" 
                                :alt="item.tenSP"
                                class="w-full h-full object-cover group-hover:scale-105 transition-transform"
                            >
                        </div>
                        <p class="text-xs text-gray-600 uppercase">{{ item.thuongHieu?.tenTH || 'Brand' }}</p>
                        <h4 class="font-medium text-sm">{{ item.tenSP }}</h4>
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
import ProductReviews from './fragments/ProductReviews.vue'
import axios from 'axios'

export default {
  name: 'ProductDetail',
  components: {
    AppHeader,
    AppFooter,
    ProductReviews
  },
  data() {
    return {
      loading: true,
      error: null,
      product: null,
      variants: [],
      minPrice: null,
      maxPrice: null,
      totalStock: 0,
      reviews: [],
      reviewCount: 0,
      relatedProducts: [],
      currentImage: '',
      selectedSize: null,
      selectedColor: null,
      quantity: 1,
      isFavorite: false
    }
  },
  computed: {
    productImages() {
      const images = []
      if (this.product?.anhChinh) images.push(this.product.anhChinh)
      if (this.product?.anhPhu1) images.push(this.product.anhPhu1)
      if (this.product?.anhPhu2) images.push(this.product.anhPhu2)
      if (this.product?.anhPhu3) images.push(this.product.anhPhu3)
      return images.length > 0 ? images : ['/img/placeholder.png']
    },
    availableSizes() {
      if (!this.variants) return []
      const sizes = [...new Set(this.variants.filter(v => v.sizeSP && v.sizeSP.tenSize).map(v => v.sizeSP.tenSize))]
      return sizes.sort() // Sắp xếp cho dễ nhìn
    },
    availableColors() {
      if (!this.variants) return []
      const colors = [...new Set(this.variants.filter(v => v.mauSacSP && v.mauSacSP.tenMau).map(v => v.mauSacSP.tenMau))]
      return colors
    },
    selectedVariant() {
      return this.variants.find(v => 
        (!this.selectedSize || v.sizeSP?.tenSize === this.selectedSize) &&
        (!this.selectedColor || v.mauSacSP?.tenMau === this.selectedColor) &&
        v.soLuongTon > 0
      )
    },
    maxQuantity() {
      return this.selectedVariant?.soLuongTon || this.totalStock || 99
    },
    canAddToCart() {
      return this.totalStock > 0 && this.quantity > 0 && this.quantity <= this.maxQuantity
    }
  },
  methods: {
    async fetchProduct() {
      this.loading = true
      this.error = null
      
      try {
        const productId = this.$route.params.id
        const response = await axios.get(`/sanpham/${productId}`)
        
        if (response.data.success) {
          this.product = response.data.product
          this.variants = response.data.variants || []
          this.minPrice = response.data.minPrice
          this.maxPrice = response.data.maxPrice
          this.totalStock = response.data.totalStock || 0
          this.reviews = response.data.reviews || []
          this.reviewCount = response.data.reviewCount || 0
          this.relatedProducts = response.data.relatedProducts || []
          
          this.currentImage = this.productImages[0]
          
          // Auto-select first available variant
          if (this.availableSizes.length > 0) this.selectedSize = this.availableSizes[0]
          if (this.availableColors.length > 0) this.selectedColor = this.availableColors[0]
        } else {
          this.error = response.data.message || 'Product not found'
        }
      } catch (err) {
        console.error('Error fetching product:', err)
        this.error = 'Failed to load product details'
      } finally {
        this.loading = false
      }
      this.checkIfFavorite()
    },

    async checkIfFavorite() {
      try {
        const productId = this.$route.params.id
        const res = await axios.get('/favorites', { withCredentials: true })
        if (res.data && Array.isArray(res.data)) {
          this.isFavorite = res.data.some(item => item.maSP == productId)
        }
      } catch (e) {
        // 401 là do chưa đăng nhập, không cần báo lỗi
        this.isFavorite = false
        if (e.response?.status !== 401) {
            console.error("Check favorite failed", e)
        }
      }
    },

    async toggleWishlist() {
      try {
        const productId = this.product.maSP
        const res = await axios.post('/favorites/toggle', null, {
          params: { maSP: productId },
          withCredentials: true
        })

        this.isFavorite = res.data.isFavorite

        if (this.isFavorite) {
          window.$toast({
            title: 'Sản phẩm yêu thích',
            message: 'Đã thêm sản phẩm này vào bộ sưu tập của bạn.',
            icon: 'favorite'
          })
        } else {
          window.$toast({
            title: 'Sản phẩm yêu thích',
            message: 'Đã bỏ sản phẩm khỏi bộ sưu tập.',
            icon: 'heart_broken'
          })
        }
      } catch (err) {
        window.$toast({
          title: 'Thông báo',
          message: 'Hành động không thành công. Bạn vui lòng đăng nhập trước nhé.',
          icon: 'error'
        })
      }
    },
    
    formatPrice(price) {
      if (!price) return 'Liên hệ'
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price)
    },
    
    handleImageError(event) {
      event.target.src = '/img/placeholder.png'
    },
    
    increaseQuantity() {
      if (this.quantity < this.maxQuantity) {
        this.quantity++
      }
    },
    
    decreaseQuantity() {
      if (this.quantity > 1) {
        this.quantity--
      }
    },
    
    async addToCart() {
      if (!this.canAddToCart) return
      
      try {
        const params = {
          productId: this.product.maSP,
          quantity: this.quantity
        }
        
        // ✨ Quan trọng: Gửi variantId chính xác của Size/Màu khách chọn
        if (this.selectedVariant) {
          params.variantId = this.selectedVariant.maBienThe
        }

        const response = await axios.post('/cart/add-product', null, { params })
        
        if (response.data.success) {
          window.$alert(response.data.message, 'Thành công')
          this.quantity = 1
        } else {
          window.$alert(response.data.message, 'Thông báo')
        }
      } catch (err) {
        console.error('Error adding to cart:', err)
        window.$alert('Không thể thêm sản phẩm vào giỏ hàng', 'Lỗi')
      }
    }
  },
  
  mounted() {
    this.fetchProduct()
  },
  
  watch: {
    '$route.params.id'() {
      this.fetchProduct()
    }
  }
}
</script>

<style scoped>
/* ProductDetail specific styles */

.item-active {
  background-color: #C8A97E !important;
  color: #ffffff !important;
  border-color: #C8A97E !important;
}

.item-inactive {
  background-color: #ffffff !important;
  color: #111827 !important;
  border-color: #d1d5db !important;
}

.item-inactive:hover {
  border-color: #000000 !important;
}

.fill-icon {
  font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24 !important;
}
</style>
