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
        <div v-else-if="product" class="w-full px-4 md:px-[2cm] py-10">
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
                        <!-- Hiển thị giá cụ thể khi ĐÃ CHỌN đủ cấu hình -->
                        <div v-if="selectedVariant" class="text-3xl font-bold text-[#C8A97E]">
                            {{ formatPrice(selectedVariant.giaBan) }}
                        </div>

                        <!-- Hiển thị khoảng giá Min/Max khi CHƯA CHỌN đủ cấu hình -->
                        <div v-else-if="minPrice && maxPrice && minPrice.toString() !== maxPrice.toString()" class="text-3xl font-bold text-[#C8A97E]">
                            {{ formatPrice(minPrice) }} - {{ formatPrice(maxPrice) }}
                        </div>
                        <div v-else-if="minPrice" class="text-3xl font-bold text-[#C8A97E]">
                            {{ formatPrice(minPrice) }}
                        </div>
                        <div v-else class="text-3xl font-bold text-[#C8A97E]">
                            Liên hệ
                        </div>

                        <!-- Hiển thị số lượng tồn kho -->
                        <p v-if="selectedVariant" class="text-sm text-gray-600 mt-1">
                            {{ selectedVariant.soLuongTon > 0 ? `${selectedVariant.soLuongTon} sản phẩm có sẵn cho phân loại này` : 'Phân loại này đã hết hàng' }}
                        </p>
                        <p v-else class="text-sm text-gray-600 mt-1">
                            {{ totalStock > 0 ? `${totalStock} sản phẩm trong kho` : 'Hết hàng' }}
                        </p>
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
                                    @click="selectSize(size)"
                                    :disabled="!isSizeAvailable(size)"
                                    :class="['px-4 py-2 border rounded-md font-medium transition-all duration-200 min-w-[3rem] text-center',
                                             selectedSize === size ? 'item-active' : 'item-inactive',
                                             !isSizeAvailable(size) ? 'opacity-30 cursor-not-allowed bg-gray-100 italic' : 'hover:border-black cursor-pointer']"
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
                                    @click="selectColor(color)"
                                    :disabled="!isColorAvailable(color)"
                                    :class="['px-4 py-2 border rounded-md font-medium transition-all duration-200 min-w-[4rem] text-center',
                                             selectedColor === color ? 'item-active' : 'item-inactive',
                                             !isColorAvailable(color) ? 'opacity-30 cursor-not-allowed bg-gray-100 italic' : 'hover:border-black cursor-pointer']"
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
                            class="flex-grow bg-black text-white text-lg font-bold py-4 rounded-lg hover:bg-gray-800 transition-all active:scale-[0.98] shadow-lg shadow-black/10"
                        >
                            {{ totalStock > 0 ? 'Thêm vào giỏ hàng' : 'Hết hàng' }}
                        </button>
                        <button 
                            @click="toggleWishlist"
                            :disabled="isToggling"
                            class="w-16 flex items-center justify-center border-2 border-gray-900 rounded-lg hover:bg-gray-50 transition-all group disabled:opacity-50 disabled:cursor-not-allowed"
                        >
                            <span 
                                class="material-symbols-outlined text-2xl transition-all group-active:scale-125"
                                :class="[isFavorite ? 'text-red-600 fill-icon' : 'text-gray-900', isToggling ? 'animate-pulse' : '']"
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
            <div v-if="relatedProducts.length > 0" class="border-t border-gray-200 mt-20 pt-16">
                <h2 class="text-3xl font-bold mb-10 font-serif">Có thể bạn quan tâm</h2>
                <div class="grid grid-cols-2 lg:grid-cols-4 gap-8">
                    <div 
                        v-for="item in relatedProducts" 
                        :key="item.maSP"
                        class="group flex flex-col h-full bg-white rounded-2xl overflow-hidden hover:shadow-xl transition-all duration-300 border border-gray-50"
                    >
                        <!-- Image Wrapper -->
                        <div @click="goToDetail(item.maSP)" class="aspect-[3/4] bg-[#f8f8f8] relative overflow-hidden cursor-pointer">
                            <img 
                                :src="item.anhChinh || '/images/placeholder.png'" 
                                :alt="item.tenSP"
                                class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700"
                            >
                            <!-- Heart Overlay (Optional matching theme) -->
                            <div class="absolute top-4 right-4 opacity-0 group-hover:opacity-100 transition-opacity">
                                <span class="material-symbols-outlined text-gray-400 hover:text-red-500 bg-white/80 p-2 rounded-full cursor-pointer backdrop-blur-sm">favorite</span>
                            </div>
                        </div>

                        <!-- Product Info -->
                        <div class="p-5 flex flex-col flex-1">
                            <p class="text-[11px] text-[#A0A0A0] uppercase tracking-[0.15em] font-bold mb-1.5">
                                {{ item.thuongHieu?.tenTH || 'Brand' }}
                            </p>
                            <h4 @click="goToDetail(item.maSP)" class="font-bold text-[16px] text-gray-900 mb-4 line-clamp-1 cursor-pointer hover:text-accent transition-colors">
                                {{ item.tenSP }}
                            </h4>
                            
                            <!-- Bottom Row -->
                            <div class="flex items-center justify-between mt-auto">
                                <div class="flex flex-col">
                                    <span class="text-[17px] font-black text-gray-900">
                                        {{ formatPrice(getRelatedPrice(item.maSP)) }}
                                    </span>
                                </div>
                                <button 
                                    @click="goToDetail(item.maSP)"
                                    class="bg-black text-white w-10 h-10 rounded-xl flex items-center justify-center hover:bg-accent transition-colors shadow-lg shadow-black/10 active:scale-95"
                                >
                                    <span class="material-symbols-outlined text-[20px]">shopping_bag</span>
                                </button>
                            </div>
                        </div>
                    </div>
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
      reviews: [],
      reviewCount: 0,
      relatedProducts: [],
      relatedPriceMap: {},
      currentImage: '',
      selectedSize: null,
      selectedColor: null,
      quantity: 1,
      isFavorite: false,
      isToggling: false
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
      
      // Define correct order for garment sizes
      const sizeOrder = ['S', 'M', 'L', 'XL', 'XXL', '2XL', '3XL'];
      
      return sizes.sort((a, b) => {
        const indexA = sizeOrder.indexOf(a.toUpperCase());
        const indexB = sizeOrder.indexOf(b.toUpperCase());
        
        // If size not in list, put at end
        if (indexA === -1 && indexB === -1) return a.localeCompare(b);
        if (indexA === -1) return 1;
        if (indexB === -1) return -1;
        
        return indexA - indexB;
      });
    },
    availableColors() {
      if (!this.variants) return []
      const colors = [...new Set(this.variants.filter(v => v.mauSacSP && v.mauSacSP.tenMau).map(v => v.mauSacSP.tenMau))]
      return colors
    },
    selectedVariant() {
      if (!this.selectedSize || !this.selectedColor) return null
      return this.variants.find(v => 
        (v.sizeSP?.tenSize === this.selectedSize) &&
        (v.mauSacSP?.tenMau === this.selectedColor) &&
        v.soLuongTon > 0 && v.trangThai !== false
      )
    },
    maxQuantity() {
      return this.selectedVariant?.soLuongTon || this.totalStock || 99
    },
    canAddToCart() {
      return this.selectedVariant != null && this.totalStock > 0 && this.quantity > 0 && this.quantity <= this.maxQuantity
    },
    totalStock() {
      if (!this.variants) return 0;
      return this.variants
        .filter(v => v.trangThai !== false)
        .reduce((sum, v) => sum + (v.soLuongTon || 0), 0);
    }
  },
  methods: {
    isSizeAvailable(size) {
        if (!this.selectedColor) return true;
        return this.variants.some(v => v.sizeSP?.tenSize === size && v.mauSacSP?.tenMau === this.selectedColor && v.soLuongTon > 0 && v.trangThai !== false);
    },
    isColorAvailable(color) {
        if (!this.selectedSize) return true;
        return this.variants.some(v => v.mauSacSP?.tenMau === color && v.sizeSP?.tenSize === this.selectedSize && v.soLuongTon > 0 && v.trangThai !== false);
    },
    selectSize(size) {
        if (this.selectedSize === size) {
            this.selectedSize = null; // Unselect to unlock colors
            return;
        }
        if (!this.isSizeAvailable(size)) return; // Strict lock
        this.selectedSize = size;
    },
    selectColor(color) {
        if (this.selectedColor === color) {
            this.selectedColor = null; // Unselect to unlock sizes
            return;
        }
        if (!this.isColorAvailable(color)) return; // Strict lock
        this.selectedColor = color;
    },
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
          this.reviews = response.data.reviews || []
          this.reviewCount = response.data.reviewCount || 0
          this.relatedProducts = response.data.relatedProducts || []
          this.relatedPriceMap = response.data.relatedPriceMap || {}
          
          this.currentImage = this.productImages[0]
          
          // reset selection to null to force user to choose
          this.selectedSize = null;
          this.selectedColor = null;
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
        // 401 (Unauthorized) status - User is likely not logged in
        this.isFavorite = false
        // No need to log 401s as they are expected for guest users
        if (e.response && e.response.status !== 401) {
            console.error("Check favorite failed", e)
        }
      }
    },

    async toggleWishlist() {
      if (this.isToggling) return
      this.isToggling = true
      
      try {
        const productId = this.product.maSP
        const res = await axios.post('/favorites/toggle', null, {
          params: { maSP: productId },
          withCredentials: true
        })

        this.isFavorite = res.data.isFavorite

        if (this.isFavorite) {
          window.$toast({
            title: 'SẢN PHẨM YÊU THÍCH',
            message: 'Đã thêm sản phẩm này vào bộ sưu tập của bạn.',
            icon: 'favorite'
          })
        } else {
          window.$toast({
            title: 'SẢN PHẨM YÊU THÍCH',
            message: 'Đã bỏ sản phẩm khỏi bộ sưu tập.',
            icon: 'heart_broken'
          })
        }
      } catch (err) {
        if (err.response?.status === 401) {
          window.$toast({
            title: 'THÔNG BÁO',
            message: 'Vui lòng đăng nhập để sử dụng tính năng yêu thích.',
            icon: 'person'
          })
        } else {
          window.$toast({
            title: 'THÔNG BÁO',
            message: 'Hành động không thành công. Vui lòng thử lại sau.',
            icon: 'error'
          })
        }
      } finally {
        this.isToggling = false
      }
    },
    
    formatPrice(price) {
      if (price === undefined || price === null || price === 0) return '0 ₫'
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price)
    },
    getRelatedPrice(maSP) {
      return this.relatedPriceMap[maSP]?.minPrice || 0
    },
    goToDetail(id) {
      window.location.href = `/sanpham/${id}`;
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
      // 1. Kiểm tra lựa chọn đầy đủ
      if (!this.selectedSize || !this.selectedColor) {
          window.$toast.warning('Vui lòng chọn Size và Màu sắc trước khi đặt hàng!');
          return;
      }

      const variant = this.selectedVariant;
      if (!variant) {
          window.$toast.warning('Phiên bản sản phẩm này hiện đang hết hàng.');
          return;
      }

      if (this.quantity > variant.soLuongTon) {
          window.$toast.warning(`Chỉ còn ${variant.soLuongTon} sản phẩm trong kho!`);
          return;
      }

      try {
        const params = {
          productId: this.product.maSP,
          quantity: this.quantity,
          variantId: variant.maBienThe
        }

        const response = await axios.post('/cart/add-product', null, { params })
        
        if (response.data.success) {
          window.$toast.success('Đã thêm sản phẩm vào giỏ hàng thành công!')
          // Optionally refresh cart count if needed
          if (window.refreshCartCount) window.refreshCartCount()
        } else {
          window.$toast.info(response.data.message)
        }
      } catch (err) {
        console.error('Error adding to cart:', err)
        window.$toast.error('Có lỗi xảy ra khi thêm vào giỏ hàng!')
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
