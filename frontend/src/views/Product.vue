<template>
<div class="relative flex min-h-screen w-full flex-col bg-background-light dark:bg-background-dark">
    <AppHeader />
    
    <main class="flex-grow">
        <!-- Hero Banner -->
        <div class="w-full h-64 md:h-80 bg-cover bg-center" style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuB5W0Z1Vkco91_aJ_qkKWvtqX0Yb9RrdT2NsXC35LNW-qWI2knzUdihll3uvOo4CRQlHBcY85Vh-zFPBRLfK1bgDV4oK-x21wGeGycdUAV3LsGIuJ7CswmJt7UpnPsXc2zNxkktJoUzwzPOXr6NahbQc4xp-16Ms8jXCM_UbGr9T25x0CccdBp50sAipknWdVzd8LFXDjxsKynEsDvPxXKYFIxOU5luI-v3Afy3GlgNCko9gXki3jooTC40OzAGyVl0bLitFtWyHfI');">
            <div class="w-full h-full flex flex-col justify-center items-center bg-black/50">
                <h1 class="text-white text-4xl md:text-6xl font-bold tracking-tight font-serif">{{ pageTitle }}</h1>
                <p class="text-white/80 mt-4 text-lg">Khám phá bộ sưu tập thời trang cao cấp</p>
                <!-- Breadcrumb -->
                <div class="flex items-center gap-2 mt-4 text-white/60 text-sm">
                    <a href="/" class="hover:text-white transition-colors">Trang chủ</a>
                    <span>/</span>
                    <span class="text-white/90">{{ pageTitle }}</span>
                </div>
            </div>
        </div>

        <div class="py-10 flex-1 w-full px-4 md:px-[3.7cm]">
            <div class="mx-auto w-full">

                <!-- Loading State -->
                <div v-if="loading" class="text-center py-24">
                    <div class="inline-block animate-spin rounded-full h-16 w-16 border-4 border-gray-200 border-t-gray-900"></div>
                    <p class="mt-6 text-gray-500 font-medium">Đang tải sản phẩm...</p>
                </div>

                <!-- Error State -->
                <div v-else-if="error" class="text-center py-16 border border-red-100 rounded-2xl bg-red-50">
                    <span class="material-symbols-outlined text-6xl text-red-400 mb-4">error</span>
                    <p class="text-red-600 mb-4 font-medium">{{ error }}</p>
                    <button @click="fetchProducts" class="px-8 py-3 bg-gray-900 text-white rounded-full font-semibold hover:bg-gray-700 transition-colors">
                        Thử lại
                    </button>
                </div>

                <!-- Products Grid -->
                <div v-else class="flex flex-col lg:flex-row gap-12">
                    <!-- Sidebar Filters -->
                    <aside class="w-full lg:w-[28%]">
                        <div class="sticky top-28 space-y-1">
                            <!-- Filter Header -->
                            <div class="pb-6 border-b border-gray-100">
                                <h2 class="text-2xl font-bold text-gray-900 mb-1">Bộ lọc</h2>
                                <p class="text-base text-gray-500">{{ totalElements }} sản phẩm</p>
                            </div>

                            <!-- Sort -->
                            <div class="py-5 border-b border-gray-100">
                                <h3 class="text-base font-bold uppercase tracking-wider text-gray-700 mb-3">Sắp xếp</h3>
                                <div class="relative custom-dropdown" @click="toggleSortDropdown">
                                    <div class="w-full bg-white border border-gray-200 rounded-xl py-3 px-4 text-base text-gray-800 focus:ring-2 focus:ring-gray-900 focus:border-transparent transition flex justify-between items-center cursor-pointer hover:border-gray-400">
                                        <span>{{ selectedSortLabel }}</span>
                                        <span class="material-symbols-outlined text-[18px] transition-transform duration-200" :class="{ 'rotate-180': sortDropdownOpen }">expand_more</span>
                                    </div>
                                    
                                    <!-- Dropdown menu -->
                                    <transition name="fade">
                                        <div v-if="sortDropdownOpen" class="absolute z-20 w-full mt-2 bg-white border border-gray-100 rounded-xl shadow-lg py-2 overflow-hidden">
                                            <div 
                                                v-for="option in sortOptions" 
                                                :key="option.value"
                                                @click.stop="selectSortOption(option)"
                                                class="px-4 py-2.5 hover:bg-gray-100 cursor-pointer text-base transition-colors flex items-center justify-between"
                                                :class="{ 'text-gray-900 font-bold bg-gray-50': filters.sort === option.value, 'text-gray-700': filters.sort !== option.value }"
                                            >
                                                {{ option.label }}
                                                <span v-if="filters.sort === option.value" class="material-symbols-outlined text-[18px]">check</span>
                                            </div>
                                        </div>
                                    </transition>
                                </div>
                            </div>

                            <!-- Gender Filter -->
                            <div class="py-5 border-b border-gray-100">
                                <h3 class="text-base font-bold uppercase tracking-wider text-gray-700 mb-4">Giới tính</h3>
                                <div class="space-y-3">
                                    <label v-for="g in genderOptions" :key="g.val" class="flex items-center gap-3 cursor-pointer group">
                                        <input
                                            v-model="filters.gioiTinh"
                                            type="radio"
                                            :value="g.val"
                                            @change="fetchProducts"
                                            class="h-5 w-5 accent-gray-900 cursor-pointer"
                                        >
                                        <span class="text-base text-gray-700 group-hover:text-gray-900 transition-colors">{{ g.label }}</span>
                                    </label>
                                </div>
                            </div>

                            <!-- Brand Filter -->
                            <div class="py-5 border-b border-gray-100" v-if="brands && brands.length > 0">
                                <h3 class="text-base font-bold uppercase tracking-wider text-gray-700 mb-4">Hãng sản xuất</h3>
                                <div class="grid grid-cols-2 gap-2">
                                    <button 
                                        v-for="brand in (showAllBrands ? brands : brands.slice(0, 4))" 
                                        :key="brand.maTH"
                                        @click="toggleBrand(brand.maTH)"
                                        class="py-2.5 px-2 border rounded-xl text-[13px] font-bold transition-colors flex items-center justify-center tracking-wider uppercase"
                                        :class="filters.thuongHieu === brand.maTH ? 'border-[#C8A97E] text-[#C8A97E] bg-white shadow-sm' : 'border-gray-200 text-gray-600 hover:border-[#C8A97E] hover:text-[#C8A97E]'"
                                    >
                                        {{ brand.tenTH }}
                                    </button>
                                </div>
                                <button v-if="brands.length > 4" @click="showAllBrands = !showAllBrands" class="mt-3 text-blue-600 font-bold text-[13px] hover:underline transition-all">
                                    {{ showAllBrands ? 'Ẩn bớt' : 'Xem thêm' }}
                                </button>
                            </div>

                            <!-- Price Filter -->
                            <div class="py-5 border-b border-gray-100">
                                <h3 class="text-base font-bold uppercase tracking-wider text-gray-700 mb-4">Mức giá</h3>
                                <div class="space-y-3 mb-5">
                                    <label class="flex items-center gap-3 cursor-pointer group">
                                        <input type="radio" value="all" v-model="selectedPriceLevel" @change="setPriceLevel('all')" class="h-5 w-5 accent-red-600 cursor-pointer">
                                        <span class="text-base text-gray-700 group-hover:text-gray-900">Tất cả</span>
                                    </label>
                                    <label class="flex items-center gap-3 cursor-pointer group">
                                        <input type="radio" value="<2m" v-model="selectedPriceLevel" @change="setPriceLevel('<2m')" class="h-5 w-5 accent-red-600 cursor-pointer">
                                        <span class="text-base text-gray-700 group-hover:text-gray-900">Dưới 2 triệu</span>
                                    </label>
                                    <label class="flex items-center gap-3 cursor-pointer group">
                                        <input type="radio" value="2-4m" v-model="selectedPriceLevel" @change="setPriceLevel('2-4m')" class="h-5 w-5 accent-red-600 cursor-pointer">
                                        <span class="text-base text-gray-700 group-hover:text-gray-900">Từ 2 - 4 triệu</span>
                                    </label>
                                    <label class="flex items-center gap-3 cursor-pointer group">
                                        <input type="radio" value="4-7m" v-model="selectedPriceLevel" @change="setPriceLevel('4-7m')" class="h-5 w-5 accent-red-600 cursor-pointer">
                                        <span class="text-base text-gray-700 group-hover:text-gray-900">Từ 4 - 7 triệu</span>
                                    </label>
                                    <label class="flex items-center gap-3 cursor-pointer group">
                                        <input type="radio" value="7-13m" v-model="selectedPriceLevel" @change="setPriceLevel('7-13m')" class="h-5 w-5 accent-red-600 cursor-pointer">
                                        <span class="text-base text-gray-700 group-hover:text-gray-900">Từ 7 - 13 triệu</span>
                                    </label>
                                    <label class="flex items-center gap-3 cursor-pointer group">
                                        <input type="radio" value="13-20m" v-model="selectedPriceLevel" @change="setPriceLevel('13-20m')" class="h-5 w-5 accent-red-600 cursor-pointer">
                                        <span class="text-base text-gray-700 group-hover:text-gray-900">Từ 13 - 20 triệu</span>
                                    </label>
                                    <label class="flex items-center gap-3 cursor-pointer group">
                                        <input type="radio" value=">20m" v-model="selectedPriceLevel" @change="setPriceLevel('>20m')" class="h-5 w-5 accent-red-600 cursor-pointer">
                                        <span class="text-base text-gray-700 group-hover:text-gray-900">Trên 20 triệu</span>
                                    </label>
                                </div>
                                <p class="text-[13px] font-bold text-gray-800 mb-3">Hoặc nhập khoảng giá phù hợp với bạn:</p>
                                <div class="flex items-center gap-2 mb-3">
                                    <input type="text" v-model="customMinPrice" @blur="formatInputPrice('min')" placeholder="0đ" class="w-full border border-gray-300 rounded-lg py-2 px-1 text-sm text-center outline-none focus:border-gray-900 transition-colors">
                                    <span class="text-gray-500 font-bold">~</span>
                                    <input type="text" v-model="customMaxPrice" @blur="formatInputPrice('max')" placeholder="100.000.000đ" class="w-full border border-gray-300 rounded-lg py-2 px-1 text-sm text-center outline-none focus:border-gray-900 transition-colors">
                                </div>
                                <button @click="applyCustomPrice" class="w-full py-2 bg-black border border-black rounded-lg text-sm font-bold text-white hover:bg-[#C8A97E] hover:border-[#C8A97E] transition-colors">
                                    Áp dụng khoảng giá
                                </button>
                            </div>

                            <!-- Clear Button -->
                            <div class="pt-5">
                                <button
                                    @click="resetFilters"
                                    class="w-full flex items-center justify-center gap-2 py-3 px-4 rounded-xl border border-gray-200 text-base font-semibold text-gray-700 hover:bg-gray-900 hover:text-white hover:border-gray-900 transition-all duration-200"
                                >
                                    <span class="material-symbols-outlined text-lg">filter_list_off</span>
                                    Xóa bộ lọc
                                </button>
                            </div>
                        </div>
                    </aside>

                    <!-- Products Area -->
                    <div class="w-full lg:w-[72%]">
                        <!-- Top Bar -->
                        <div class="pb-6 border-b border-gray-100 mb-8">
                            <p class="text-sm text-gray-500">
                                Hiển thị <span class="font-semibold text-gray-800">{{ products.length }}</span>
                                / <span class="font-semibold text-gray-800">{{ totalElements }}</span> sản phẩm
                            </p>
                        </div>

                        <!-- Empty State -->
                        <div v-if="products.length === 0" class="text-center py-24 border border-gray-100 rounded-2xl">
                            <span class="material-symbols-outlined text-7xl text-gray-200 mb-6">inventory_2</span>
                            <h3 class="text-xl font-bold text-gray-800 mb-2">Không tìm thấy sản phẩm</h3>
                            <p class="text-gray-500 mb-6">Hãy thử điều chỉnh bộ lọc của bạn</p>
                            <button @click="resetFilters" class="px-8 py-3 bg-gray-900 text-white rounded-full font-semibold hover:bg-gray-700 transition-colors">
                                Xem tất cả sản phẩm
                            </button>
                        </div>

                        <!-- Product Grid -->
                        <div v-else class="grid grid-cols-2 sm:grid-cols-2 lg:grid-cols-3 gap-8 lg:gap-10">
                            <div
                                v-for="product in products"
                                :key="product.maSP"
                                class="product-card group flex flex-col gap-0 relative bg-white rounded-2xl border border-transparent hover:border-[#C8A97E] overflow-hidden transition-all duration-300 shadow-sm hover:shadow-xl"
                            >
                                <!-- Image Container -->
                                <div class="relative overflow-hidden bg-gray-100 aspect-[3/4]">
                                    <a :href="`/sanpham/${product.maSP}`">
                                        <img
                                            v-if="product.anhChinh"
                                            :src="product.anhChinh"
                                            :alt="product.tenSP"
                                            class="h-full w-full object-cover transition-transform duration-500 group-hover:scale-107"
                                            loading="lazy"
                                            @error="handleImageError"
                                        >
                                        <div v-else class="h-full w-full flex items-center justify-center text-gray-300 bg-gray-100">
                                            <span class="material-symbols-outlined text-5xl">image</span>
                                        </div>
                                    </a>

                                    <!-- Badges -->
                                    <span v-if="getPriceStock(product.maSP)?.outOfStock" class="badge badge-soldout">
                                        HẾT HÀNG
                                    </span>
                                    <span v-if="getPriceStock(product.maSP)?.hasPromotion" class="badge badge-sale">
                                        -{{ Math.round(getPriceStock(product.maSP)?.discountPercent || 0) }}%
                                    </span>

                                    <!-- Quick View Overlay (hover) -->
                                    <div class="quick-view-overlay">
                                        <button
                                            @click.prevent="openQuickView(product.maSP)"
                                            class="quick-view-btn"
                                        >
                                            <span class="material-symbols-outlined text-base">visibility</span>
                                            Xem nhanh
                                        </button>
                                    </div>

                                    <!-- Wishlist button -->
                                    <button 
                                      @click.stop="toggleWishlist(product.maSP)"
                                      class="wishlist-btn opacity-0 group-hover:opacity-100 flex items-center justify-center transition-all active:scale-125 shadow-lg group/heart"
                                    >
                                      <span 
                                        class="material-symbols-outlined text-lg transition-all"
                                        :class="isFavorite(product.maSP) ? 'text-red-600 fill-icon scale-110' : 'text-gray-400 group-hover/heart:text-red-500'"
                                      >
                                        {{ isFavorite(product.maSP) ? 'favorite' : 'favorite_border' }}
                                      </span> 
                                    </button>
                                </div>

                                <!-- Product Info Area -->
                                <div class="flex flex-col flex-1 p-4">
                                    <!-- Brand and Title -->
                                    <div class="mb-2 w-full">
                                        <p class="text-[13px] text-gray-500 uppercase tracking-widest font-bold mb-1">
                                            {{ product.thuongHieu?.tenTH || 'Brand' }}
                                        </p>
                                        <h4 class="text-gray-900 text-[17px] md:text-[18px] font-semibold leading-snug truncate w-full" :title="product.tenSP">
                                            <a :href="`/sanpham/${product.maSP}`" class="hover:underline underline-offset-2">
                                                {{ product.tenSP }}
                                            </a>
                                        </h4>
                                    </div>

                                    <!-- Bottom Row: Price (Left) & Add Button (Right) -->
                                    <div class="flex flex-row justify-between items-end mt-auto pt-1">
                                        <!-- Price -->
                                        <div class="flex flex-col justify-end">
                                            <p v-if="getPriceStock(product.maSP)?.hasPromotion" class="text-gray-400 text-sm line-through mb-0.5">
                                                {{ formatPrice(getPriceStock(product.maSP)?.minPrice) }}
                                            </p>
                                            <p :class="['text-[17px] md:text-[19px] font-bold', getPriceStock(product.maSP)?.hasPromotion ? 'text-[#C8A97E]' : 'text-gray-900']">
                                                {{ formatPrice(getPriceStock(product.maSP)?.finalPrice || getPriceStock(product.maSP)?.minPrice) }}
                                            </p>
                                        </div>

                                        <!-- Add Button -->
                                        <div class="flex-shrink-0">
                                            <button
                                                @click="openQuickView(product.maSP)"
                                                :disabled="getPriceStock(product.maSP)?.outOfStock"
                                                class="flex items-center gap-1.5 bg-black hover:bg-[#C8A97E] text-white px-3.5 py-2.5 rounded-lg text-sm font-bold transition-colors disabled:opacity-50 disabled:cursor-not-allowed shadow-sm"
                                                title="Thêm vào giỏ"
                                            >
                                                <span class="material-symbols-outlined text-[18px]">shopping_bag</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Pagination -->
                        <div v-if="totalPages > 1" class="flex justify-center items-center gap-2 mt-14">
                            <button
                                @click="changePage(currentPage - 1)"
                                :disabled="currentPage === 0"
                                class="pagination-arrow"
                            >
                                <span class="material-symbols-outlined">chevron_left</span>
                            </button>

                            <button
                                v-for="page in displayPages"
                                :key="page"
                                @click="changePage(page)"
                                :class="['pagination-num', page === currentPage ? 'active' : '']"
                            >
                                {{ page + 1 }}
                            </button>

                            <button
                                @click="changePage(currentPage + 1)"
                                :disabled="currentPage === totalPages - 1"
                                class="pagination-arrow"
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

    <!-- ✨ QUICK VIEW MODAL -->
    <ProductQuickViewModal
        :productId="quickViewProductId"
        :isOpen="quickViewOpen"
        @close="closeQuickView"
        @cart-updated="onCartUpdated"
    />
</div>
</template>

<script>
import AppHeader from './fragments/AppHeader.vue'
import AppFooter from './fragments/AppFooter.vue'
import ProductQuickViewModal from './fragments/ProductQuickViewModal.vue'
import axios from 'axios'

export default {
  name: 'Product',
  components: {
    AppHeader,
    AppFooter,
    ProductQuickViewModal
  },
  data() {
    return { 
      favoriteMap: {},
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
      pageTitle: 'Tất cả sản phẩm',
      genderOptions: [
        { val: null, label: 'Tất cả' },
        { val: 0, label: 'Nam' },
        { val: 1, label: 'Nữ' },
        { val: 2, label: 'Unisex' }
      ],
      // Quick View
      quickViewOpen: false,
      quickViewProductId: null,
      
      // Brands
      brands: [],
      showAllBrands: false,
      
      // Price Filters
      selectedPriceLevel: null,
      customMinPrice: null,
      customMaxPrice: null, 
      
      // Sort Dropdown
      sortDropdownOpen: false,
      sortOptions: [
        { value: 'moi', label: 'Mới nhất' },
        { value: 'gia-tang', label: 'Giá: Thấp → Cao' },
        { value: 'gia-giam', label: 'Giá: Cao → Thấp' },
        { value: 'ten', label: 'Tên A → Z' }
      ]
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
      for (let i = start; i <= end; i++) pages.push(i)
      return pages
    },
    selectedSortLabel() {
      const option = this.sortOptions.find(o => o.value === this.filters.sort)
      return option ? option.label : 'Sắp xếp'
    }
  },
  methods: {
    toggleSortDropdown() {
      this.sortDropdownOpen = !this.sortDropdownOpen
    },
    selectSortOption(option) {
      this.filters.sort = option.value
      this.sortDropdownOpen = false
      this.fetchProducts()
    },
    handleGlobalClick(e) {
      if (this.sortDropdownOpen && !e.target.closest('.custom-dropdown')) {
        this.sortDropdownOpen = false
      }
    },
    async fetchProducts() {
      this.loading = true
      this.error = null
      try {
        const params = {
          page: this.currentPage,
          size: this.pageSize,
          ...this.filters
        }
        Object.keys(params).forEach(key => {
          if (params[key] === null || params[key] === undefined) delete params[key]
        })
        const response = await axios.get('/sanpham', { params })
        if (response.data.success) {
          this.products = response.data.content || []
          this.priceStockMap = response.data.priceStockMap || {}
          this.totalElements = response.data.totalElements || 0
          this.totalPages = response.data.totalPages || 0
          this.currentPage = response.data.currentPage || 0
          if (response.data.brands) {
             this.brands = response.data.brands
          }
        } else {
          this.error = response.data.message || 'Tải sản phẩm thất bại'
        }
      } catch (err) {
        console.error('Error fetching products:', err)
        this.error = 'Không thể tải sản phẩm. Vui lòng thử lại.'
      } finally {
        this.loading = false
      } 
    }, 

    //WISHLIST
    async fetchFavorites() {
      try {
        const res = await axios.get('/favorites', {
          withCredentials: true
        })

        const map = {}
        if (res.data && Array.isArray(res.data)) {
          res.data.forEach(item => {
            map[item.maSP] = true
          })
        }

        this.favoriteMap = map
      } catch (e) {
        if (e.response?.status !== 401) {
          console.error("Load favorites failed", e)
        }
      }
    },

    async toggleWishlist(productId) {
      try {
        const res = await axios.post('/favorites/toggle', null, {
          params: { maSP: productId },
          withCredentials: true
        })

        const isFav = (res.data && res.data.isFavorite !== undefined) ? res.data.isFavorite : !this.favoriteMap[productId]
        
        // Cập nhật lại Map một cách tường minh để Vue bắt kịp change
        const updatedMap = { ...this.favoriteMap }
        updatedMap[productId] = isFav
        this.favoriteMap = updatedMap

        // Hiển thị thông báo qua window.$toast
        if (isFav) {
          window.$toast({
            title: 'Sản phẩm yêu thích',
            message: 'Đã thêm vào bộ sưu tập của bạn.',
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
        console.error("Wishlist error:", err.response?.data || err)
        window.$toast({
          title: 'Thông báo',
          message: 'Hành động thất bại. Có thể do lỗi kết nối hoặc phiên đăng nhập.',
          icon: 'error'
        })
      } 
      this.$forceUpdate()
    },
    
  //   async checkFavorite(productId) {
  //   try {
  //     const res = await axios.get('/api/favorites/check', {
  //       params: { maSP: productId },
  //       withCredentials: true
  //     })
  //     this.favoriteMap[productId] = res.data.isFavorite
  //   } catch (e) {
  //     this.favoriteMap[productId] = false
  //   }
  // },

   isFavorite(productId) {
      return !!this.favoriteMap[productId]
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

    openQuickView(productId) {
      this.quickViewProductId = productId
      this.quickViewOpen = true
    },

    closeQuickView() {
      this.quickViewOpen = false
      setTimeout(() => { this.quickViewProductId = null }, 300)
    },

    onCartUpdated() {
      if (window.refreshCartCount) window.refreshCartCount()
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
      this.selectedPriceLevel = null
      this.customMinPrice = null
      this.customMaxPrice = null
      this.currentPage = 0
      this.fetchProducts()
    },

    toggleBrand(brandId) {
      if (this.filters.thuongHieu === brandId) {
        this.filters.thuongHieu = null;
      } else {
        this.filters.thuongHieu = brandId;
      }
      this.currentPage = 0;
      this.fetchProducts();
    },

    setPriceLevel(level) {
      this.selectedPriceLevel = level;
      if (level === 'all') {
        this.filters.minPrice = null;
        this.filters.maxPrice = null;
      } else if (level === '<2m') {
        this.filters.minPrice = null;
        this.filters.maxPrice = 2000000;
      } else if (level === '2-4m') {
        this.filters.minPrice = 2000000;
        this.filters.maxPrice = 4000000;
      } else if (level === '4-7m') {
        this.filters.minPrice = 4000000;
        this.filters.maxPrice = 7000000;
      } else if (level === '7-13m') {
        this.filters.minPrice = 7000000;
        this.filters.maxPrice = 13000000;
      } else if (level === '13-20m') {
        this.filters.minPrice = 13000000;
        this.filters.maxPrice = 20000000;
      } else if (level === '>20m') {
        this.filters.minPrice = 20000000;
        this.filters.maxPrice = null;
      }
      this.customMinPrice = null;
      this.customMaxPrice = null;
      this.currentPage = 0;
      this.fetchProducts();
    },

    applyCustomPrice() {
      this.selectedPriceLevel = 'custom';
      this.filters.minPrice = this.customMinPrice ? parseInt(this.customMinPrice.toString().replace(/\D/g, '')) : null;
      this.filters.maxPrice = this.customMaxPrice ? parseInt(this.customMaxPrice.toString().replace(/\D/g, '')) : null;
      this.currentPage = 0;
      this.fetchProducts();
    },

    formatInputPrice(type) {
      if (type === 'min' && this.customMinPrice) {
          let val = parseInt(this.customMinPrice.toString().replace(/\D/g, '')) || 0;
          this.customMinPrice = new Intl.NumberFormat('vi-VN').format(val) + 'đ';
      } else if (type === 'max' && this.customMaxPrice) {
          let val = parseInt(this.customMaxPrice.toString().replace(/\D/g, '')) || 0;
          this.customMaxPrice = new Intl.NumberFormat('vi-VN').format(val) + 'đ';
      }
    },

    parseQueryParams() {
      const path = this.$route.path
      const query = this.$route.query
      
      this.filters.gioiTinh = null
      if (path.includes('/nam')) {
        this.filters.gioiTinh = 0
        this.pageTitle = "Bộ sưu tập Nam"
      } else if (path.includes('/nu')) {
        this.filters.gioiTinh = 1
        this.pageTitle = "Bộ sưu tập Nữ"
      } else {
        this.pageTitle = "Tất cả sản phẩm"
      }

      if (query.loai) {
        this.filters.loai = parseInt(query.loai)
      } else {
        this.filters.loai = null
      }
      
      if (query.search) {
        this.filters.search = query.search
        this.pageTitle = `Kết quả tìm kiếm cho "${query.search}"`
      } else {
        this.filters.search = null
      }

      if (query.thuongHieu) {
        this.filters.thuongHieu = parseInt(query.thuongHieu)
      } else {
        this.filters.thuongHieu = null
      }

      this.currentPage = 0
      this.fetchProducts()
    }
  },

  mounted() {
    document.addEventListener('click', this.handleGlobalClick)
    this.parseQueryParams()
    this.fetchProducts()
    this.fetchFavorites()
  },

  watch: {
    '$route.query': {
      handler() {
        this.parseQueryParams()
      },
      deep: true
    }
  },

  beforeUnmount() {
    document.removeEventListener('click', this.handleGlobalClick)
  }
}
</script>

<style scoped>
/* ==============================
   PRODUCT PAGE — LUXURY STYLES
   ============================== */

/* Product Card */
.product-card {
  transition: transform 0.3s ease;
}
.product-card:hover {
  transform: translateY(-2px);
}

/* Scale animation */
.group-hover\:scale-107:hover .h-full {
  transform: scale(1.07);
}

/* Badges */
.badge {
  position: absolute;
  font-size: 10px;
  font-weight: 800;
  padding: 3px 10px;
  border-radius: 20px;
  letter-spacing: 0.3px;
  z-index: 2;
}
.badge-soldout {
  top: 10px;
  left: 10px;
  background: #111827;
  color: #fff;
}
.badge-sale {
  top: 10px;
  right: 10px;
  background: linear-gradient(135deg, #DC2626, #B91C1C);
  color: #fff;
}

/* Quick View Overlay */
.quick-view-overlay {
  position: absolute;
  inset: 0;
  background: rgba(10, 10, 20, 0);
  display: flex;
  align-items: flex-end;
  padding-bottom: 12px;
  justify-content: center;
  transition: background 0.3s ease;
  z-index: 1;
}
.product-card:hover .quick-view-overlay {
  background: rgba(10, 10, 20, 0.2);
}
.quick-view-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  background: rgba(255,255,255,0.95);
  backdrop-filter: blur(8px);
  border: none;
  border-radius: 50px;
  padding: 8px 18px;
  font-size: 12px;
  font-weight: 700;
  color: #111827;
  cursor: pointer;
  transform: translateY(12px);
  opacity: 0;
  transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 4px 16px rgba(0,0,0,0.15);
}
.product-card:hover .quick-view-btn {
  transform: translateY(0);
  opacity: 1;
}
.quick-view-btn:hover {
  background: #111827;
  color: #fff;
} 
.quick-view-overlay {
  pointer-events: none;
}

/* Wishlist button */
.wishlist-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 34px;
  height: 34px;
  border-radius: 50%;
  background: rgba(255,255,255,0.9);
  backdrop-filter: blur(4px);
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #6B7280;
  transition: all 0.2s;
  z-index: 4;
}
.wishlist-btn:hover {
  color: #DC2626;
  background: #fff;
}
.wishlist-btn {
  z-index: 9999;
}

/* Nút Thêm thay thế */

/* Pagination */
.pagination-arrow {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: 1.5px solid #E5E7EB;
  background: #fff;
  color: #374151;
  cursor: pointer;
  transition: all 0.2s;
}
.pagination-arrow:hover:not(:disabled) {
  border-color: #111827;
  background: #111827;
  color: #fff;
}
.pagination-arrow:disabled {
  opacity: 0.35;
  cursor: not-allowed;
}
.pagination-num {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: 1.5px solid #E5E7EB;
  background: #fff;
  color: #374151;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}
.pagination-num:hover { border-color: #6B7280; }
.pagination-num.active {
  background: #111827;
  border-color: #111827;
  color: #fff;
}
</style>
