<template>
<div class="relative flex min-h-screen w-full flex-col bg-background-light dark:bg-background-dark">
    <AppHeader />
    
    <main class="flex-grow">
        <!-- Hero Banner -->
        <div class="w-full h-64 md:h-80 bg-cover bg-center" style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuB5W0Z1Vkco91_aJ_qkKWvtqX0Yb9RrdT2NsXC35LNW-qWI2knzUdihll3uvOo4CRQlHBcY85Vh-zFPBRLfK1bgDV4oK-x21wGeGycdUAV3LsGIuJ7CswmJt7UpnPsXc2zNxkktJoUzwzPOXr6NahbQc4xp-16Ms8jXCM_UbGr9T25x0CccdBp50sAipknWdVzd8LFXDjxsKynEsDvPxXKYFIxOU5luI-v3Afy3GlgNCko9gXki3jooTC40OzAGyVl0bLitFtWyHfI');">
            <div class="w-full h-full flex flex-col justify-center items-center bg-black/30">
                <h1 class="text-white text-4xl md:text-6xl font-bold tracking-tight">{{ pageTitle }}</h1>
                <p class="text-white/90 mt-4 text-lg">Discover the latest in luxury fashion</p>
            </div>
        </div>

        <div class="px-4 sm:px-10 lg:px-20 py-10 flex-1">
            <div class="mx-auto max-w-7xl">
                <div class="flex flex-wrap justify-between gap-4 py-4 mb-6">
                    <h1 class="text-primary-text dark:text-white text-4xl lg:text-5xl font-black leading-tight tracking-[-0.033em]">All Products</h1>
                </div>

                <!-- Loading State -->
                <div v-if="loading" class="text-center py-16">
                    <div class="animate-spin rounded-full h-16 w-16 border-b-2 border-accent mx-auto"></div>
                    <p class="mt-4 text-gray-600">Loading products...</p>
                </div>

                <!-- Error State -->
                <div v-else-if="error" class="text-center py-16 border border-red-200 rounded-lg bg-red-50">
                    <span class="material-symbols-outlined text-6xl text-red-600 mb-4">error</span>
                    <p class="text-red-600 mb-2">{{ error }}</p>
                    <button @click="fetchProducts" class="px-6 py-2 bg-accent text-white rounded-lg hover:bg-accent/90">
                        Retry
                    </button>
                </div>

                <!-- Products Grid -->
                <div v-else class="flex flex-col lg:flex-row gap-12">
                    <!-- Sidebar Filters -->
                    <aside class="w-full lg:w-[30%] lg:pr-8">
                        <div class="sticky top-28 space-y-8">
                            <div class="py-6 border-b border-secondary/50">
                                <h3 class="text-lg font-semibold mb-4 text-black">Sort By</h3>
                                <select v-model="filters.sort" @change="fetchProducts" class="w-full bg-transparent border border-secondary rounded-md py-2 px-3">
                                    <option value="moi">Newest</option>
                                    <option value="gia-tang">Price: Low to High</option>
                                    <option value="gia-giam">Price: High to Low</option>
                                    <option value="ten">Name A-Z</option>
                                </select>
                            </div>

                            <div class="py-6 border-b border-secondary/50">
                                <h3 class="text-lg font-semibold mb-4 text-black">Gender</h3>
                                <div class="space-y-3 text-black">
                                    <label class="flex items-center cursor-pointer">
                                        <input v-model="filters.gioiTinh" type="radio" :value="null" @change="fetchProducts" class="h-4 w-4">
                                        <span class="ml-3 text-sm">All</span>
                                    </label>
                                    <label class="flex items-center cursor-pointer">
                                        <input v-model="filters.gioiTinh" type="radio" :value="0" @change="fetchProducts" class="h-4 w-4">
                                        <span class="ml-3 text-sm">Nam</span>
                                    </label>
                                    <label class="flex items-center cursor-pointer">
                                        <input v-model="filters.gioiTinh" type="radio" :value="1" @change="fetchProducts" class="h-4 w-4">
                                        <span class="ml-3 text-sm">Nữ</span>
                                    </label>
                                    <label class="flex items-center cursor-pointer">
                                        <input v-model="filters.gioiTinh" type="radio" :value="2" @change="fetchProducts" class="h-4 w-4">
                                        <span class="ml-3 text-sm">Unisex</span>
                                    </label>
                                </div>
                            </div>

                            <div class="py-6 space-y-4">
                                <button @click="resetFilters" class="w-full bg-transparent text-black border border-secondary text-sm font-bold py-2.5 rounded-lg hover:bg-black/5">
                                    Clear Filters
                                </button>
                            </div>
                        </div>
                    </aside>

                    <!-- Products List -->
                    <div class="w-full lg:w-[70%]">
                        <div class="flex justify-between items-center gap-4 py-3 border-b border-secondary/50 mb-8">
                            <p class="text-sm text-gray-500">
                                Showing {{ products.length }} of {{ totalElements }} products
                            </p>
                        </div>

                        <!-- Empty State -->
                        <div v-if="products.length === 0" class="text-center py-16 border border-secondary/50 rounded-lg">
                            <span class="material-symbols-outlined text-6xl text-gray-400 mb-4">shopping_bag</span>
                            <p class="text-gray-600 mb-2">No products found</p>
                            <button @click="resetFilters" class="px-6 py-2 bg-accent text-white rounded-lg hover:bg-accent/90">
                                Clear Filters
                            </button>
                        </div>

                        <!-- Product Grid -->
                        <div v-else class="grid grid-cols-2 md:grid-cols-3 gap-6 lg:gap-8">
                            <div v-for="product in products" :key="product.maSP" class="group flex flex-col gap-3 relative overflow-hidden">
                                <div class="w-full aspect-[3/4] rounded-lg bg-gray-100 overflow-hidden relative">
                                    <a :href="`/sanpham/${product.maSP}`">
                                        <img 
                                            v-if="product.anhChinh" 
                                            :src="product.anhChinh" 
                                            :alt="product.tenSP"
                                            class="h-full w-full object-cover transition-transform duration-300 group-hover:scale-105"
                                            loading="lazy"
                                            @error="handleImageError"
                                        >
                                        <div v-else class="h-full w-full flex items-center justify-center text-gray-400 bg-gray-100">
                                            <div class="text-center">
                                                <span class="material-symbols-outlined text-4xl">image</span>
                                                <p class="mt-2 text-sm">No Image</p>
                                            </div>
                                        </div>
                                    </a>

                                    <!-- Product Badges -->
                                    <span v-if="getPriceStock(product.maSP)?.outOfStock" class="absolute top-2 left-2 bg-red-600 text-white text-[10px] font-bold px-2 py-1 rounded shadow">
                                        HẾT HÀNG
                                    </span>
                                    <span v-if="getPriceStock(product.maSP)?.hasPromotion" class="absolute top-2 right-2 bg-red-600 text-white text-xs font-bold px-2 py-1 rounded shadow">
                                        -{{ Math.round(getPriceStock(product.maSP)?.discountPercent || 0) }}%
                                    </span>
                                </div>

                                <div class="flex flex-col flex-1">
                                    <p class="text-xs text-gray-700 uppercase tracking-wider">
                                        {{ product.thuongHieu?.tenTH || 'Brand' }}
                                    </p>
                                    <h4 class="text-black text-base font-medium leading-normal flex-1">
                                        <a :href="`/sanpham/${product.maSP}`" class="hover:underline">
                                            {{ product.tenSP }}
                                        </a>
                                    </h4>
                                    <div class="mt-1">
                                        <p v-if="getPriceStock(product.maSP)?.hasPromotion" class="text-gray-400 text-xs line-through">
                                            {{ formatPrice(getPriceStock(product.maSP)?.minPrice) }}
                                        </p>
                                        <p class="text-black text-sm font-semibold">
                                            {{ formatPrice(getPriceStock(product.maSP)?.finalPrice || getPriceStock(product.maSP)?.minPrice) }}
                                        </p>
                                    </div>
                                </div>

                                <!-- Add to Cart Button -->
                                <button 
                                    @click="addToCart(product.maSP)"
                                    :disabled="getPriceStock(product.maSP)?.outOfStock"
                                    class="mt-3 w-full bg-black text-white text-sm font-bold py-2.5 rounded-lg transition-colors hover:bg-gray-800 disabled:bg-gray-400 disabled:cursor-not-allowed"
                                >
                                    {{ getPriceStock(product.maSP)?.outOfStock ? 'Hết hàng' : '🛒 Add to Cart' }}
                                </button>
                            </div>
                        </div>

                        <!-- Pagination -->
                        <div v-if="totalPages > 1" class="flex justify-center items-center gap-2 mt-12">
                            <button 
                                @click="changePage(currentPage - 1)" 
                                :disabled="currentPage === 0"
                                class="flex h-10 w-10 items-center justify-center rounded-full hover:bg-black/5 disabled:text-gray-300"
                            >
                                <span class="material-symbols-outlined">chevron_left</span>
                            </button>
                            
                            <button 
                                v-for="page in displayPages" 
                                :key="page"
                                @click="changePage(page)"
                                :class="['flex h-10 w-10 items-center justify-center rounded-full text-sm font-bold', 
                                         page === currentPage ? 'bg-black text-white' : 'hover:bg-black/5']"
                            >
                                {{ page + 1 }}
                            </button>
                            
                            <button 
                                @click="changePage(currentPage + 1)"
                                :disabled="currentPage === totalPages - 1"
                                class="flex h-10 w-10 items-center justify-center rounded-full hover:bg-black/5 disabled:text-gray-300"
                            >
                                <span class="material-symbols-outlined">chevron_right</span>
                            </button>
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
import axios from 'axios'

export default {
  name: 'Product',
  components: {
    AppHeader,
    AppFooter
  },
  data() {
    return {
      products: [],
      priceStockMap: {},
      loading: true,
      error: null,
      filters: {
        search: null,
        loai: null,
        gioiTinh: null,
        thuongHieu: null,
        minPrice: null,
        maxPrice: null,
        sort: 'moi'
      },
      currentPage: 0,
      pageSize: 12,
      totalElements: 0,
      totalPages: 0,
      pageTitle: 'All Products'
    }
  },
  computed: {
    displayPages() {
      const pages = []
      const maxDisplay = 5
      let start = Math.max(0, this.currentPage - 2)
      let end = Math.min(this.totalPages - 1, start + maxDisplay - 1)
      
      if (end - start < maxDisplay - 1) {
        start = Math.max(0, end - maxDisplay + 1)
      }
      
      for (let i = start; i <= end; i++) {
        pages.push(i)
      }
      return pages
    }
  },
  methods: {
    async fetchProducts() {
      this.loading = true
      this.error = null
      
      try {
        const params = {
          page: this.currentPage,
          size: this.pageSize,
          ...this.filters
        }
        
        // Remove null/undefined values
        Object.keys(params).forEach(key => {
          if (params[key] === null || params[key] === undefined) {
            delete params[key]
          }
        })
        
        const response = await axios.get('/sanpham', { params })  // axios baseURL already has /api
        
        if (response.data.success) {
          this.products = response.data.content || []
          this.priceStockMap = response.data.priceStockMap || {}
          this.totalElements = response.data.totalElements || 0
          this.totalPages = response.data.totalPages || 0
          this.currentPage = response.data.currentPage || 0
        } else {
          this.error = response.data.message || 'Failed to load products'
        }
      } catch (err) {
        console.error('Error fetching products:', err)
        this.error = 'Failed to load products. Please try again later.'
      } finally {
        this.loading = false
      }
    },
    
    getPriceStock(productId) {
      return this.priceStockMap[productId] || {}
    },
    
    formatPrice(price) {
      if (!price || price === 0) return 'Liên hệ'
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price)
    },
    
    handleImageError(event) {
      event.target.src = '/img/placeholder.png'
    },
    
    async addToCart(productId) {
      try {
        const response = await axios.post('/cart/add-product', null, {
          params: { productId, quantity: 1 }
        })
        
        if (response.data.success) {
          alert(response.data.message)
          // Refresh cart count in header
          if (window.refreshCartCount) {
            window.refreshCartCount()
          }
        } else {
          alert(response.data.message)
        }
      } catch (err) {
        console.error('Error adding to cart:', err)
        alert('Không thể thêm sản phẩm vào giỏ hàng')
      }
    },
    
    changePage(page) {
      if (page >= 0 && page < this.totalPages) {
        this.currentPage = page
        this.fetchProducts()
        window.scrollTo({ top: 0, behavior: 'smooth' })
      }
    },
    
    resetFilters() {
      this.filters = {
        search: null,
        loai: null,
        gioiTinh: null,
        thuongHieu: null,
        minPrice: null,
        maxPrice: null,
        sort: 'moi'
      }
      this.currentPage = 0
      this.fetchProducts()
    }
  },
  
  mounted() {
    // Check route for gender filter
    const path = this.$route.path
    if (path.includes('/nam')) {
      this.filters.gioiTinh = 0
      this.pageTitle = "Men's Collection"
    } else if (path.includes('/nu')) {
      this.filters.gioiTinh = 1
      this.pageTitle = "Women's Collection"
    }
    
    this.fetchProducts()
  }
}
</script>

<style scoped>
/* Product specific styles */
</style>
