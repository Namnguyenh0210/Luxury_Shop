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

        <div class="px-4 sm:px-10 lg:px-20 py-10 flex-1">
            <div class="mx-auto max-w-7xl">

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
                                <h2 class="text-xl font-bold text-gray-900 mb-1">Bộ lọc</h2>
                                <p class="text-sm text-gray-500">{{ totalElements }} sản phẩm</p>
                            </div>

                            <!-- Sort -->
                            <div class="py-5 border-b border-gray-100">
                                <h3 class="text-sm font-bold uppercase tracking-wider text-gray-700 mb-3">Sắp xếp</h3>
                                <select v-model="filters.sort" @change="fetchProducts" class="w-full bg-white border border-gray-200 rounded-xl py-2.5 px-4 text-sm text-gray-800 focus:ring-2 focus:ring-gray-900 focus:border-transparent outline-none transition cursor-pointer hover:border-gray-400">
                                    <option value="moi">Mới nhất</option>
                                    <option value="gia-tang">Giá: Thấp → Cao</option>
                                    <option value="gia-giam">Giá: Cao → Thấp</option>
                                    <option value="ten">Tên A → Z</option>
                                </select>
                            </div>

                            <!-- Gender Filter -->
                            <div class="py-5 border-b border-gray-100">
                                <h3 class="text-sm font-bold uppercase tracking-wider text-gray-700 mb-4">Giới tính</h3>
                                <div class="space-y-2.5">
                                    <label v-for="g in genderOptions" :key="g.val" class="flex items-center gap-3 cursor-pointer group">
                                        <input
                                            v-model="filters.gioiTinh"
                                            type="radio"
                                            :value="g.val"
                                            @change="fetchProducts"
                                            class="h-4 w-4 accent-gray-900 cursor-pointer"
                                        >
                                        <span class="text-sm text-gray-700 group-hover:text-gray-900 transition-colors">{{ g.label }}</span>
                                    </label>
                                </div>
                            </div>

                            <!-- Clear Button -->
                            <div class="pt-5">
                                <button
                                    @click="resetFilters"
                                    class="w-full flex items-center justify-center gap-2 py-2.5 px-4 rounded-xl border border-gray-200 text-sm font-semibold text-gray-700 hover:bg-gray-900 hover:text-white hover:border-gray-900 transition-all duration-200"
                                >
                                    <span class="material-symbols-outlined text-base">filter_list_off</span>
                                    Xóa bộ lọc
                                </button>
                            </div>
                        </div>
                    </aside>

                    <!-- Products Area -->
                    <div class="w-full lg:w-[72%]">
                        <!-- Top Bar -->
                        <div class="flex justify-between items-center gap-4 pb-6 border-b border-gray-100 mb-8">
                            <p class="text-sm text-gray-500">
                                Hiển thị <span class="font-semibold text-gray-800">{{ products.length }}</span>
                                / <span class="font-semibold text-gray-800">{{ totalElements }}</span> sản phẩm
                            </p>
                            <!-- View mode toggle (aesthetic) -->
                            <div class="hidden sm:flex items-center gap-1 bg-gray-100 p-1 rounded-lg">
                                <button class="p-1.5 rounded-md bg-white shadow-sm text-gray-700">
                                    <span class="material-symbols-outlined text-base">grid_view</span>
                                </button>
                                <button class="p-1.5 rounded-md text-gray-400 hover:text-gray-600 transition-colors">
                                    <span class="material-symbols-outlined text-base">view_list</span>
                                </button>
                            </div>
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
                        <div v-else class="grid grid-cols-2 md:grid-cols-3 gap-5 lg:gap-6">
                            <div
                                v-for="product in products"
                                :key="product.maSP"
                                class="product-card group flex flex-col gap-0 relative"
                            >
                                <!-- Image Container -->
                                <div class="relative overflow-hidden rounded-xl bg-gray-100 aspect-[3/4]">
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
                                    <button class="wishlist-btn opacity-0 group-hover:opacity-100">
                                        <span class="material-symbols-outlined text-lg">favorite_border</span>
                                    </button>
                                </div>

                                <!-- Product Info -->
                                <div class="flex flex-col flex-1 mt-3 px-0.5">
                                    <p class="text-[10px] text-gray-400 uppercase tracking-widest font-semibold mb-1">
                                        {{ product.thuongHieu?.tenTH || 'Brand' }}
                                    </p>
                                    <h4 class="text-gray-900 text-sm font-semibold leading-snug flex-1 line-clamp-2">
                                        <a :href="`/sanpham/${product.maSP}`" class="hover:underline underline-offset-2">
                                            {{ product.tenSP }}
                                        </a>
                                    </h4>

                                    <!-- Price Row -->
                                    <div class="flex items-center gap-2 mt-2">
                                        <p v-if="getPriceStock(product.maSP)?.hasPromotion" class="text-gray-400 text-xs line-through">
                                            {{ formatPrice(getPriceStock(product.maSP)?.minPrice) }}
                                        </p>
                                        <p :class="['text-sm font-bold', getPriceStock(product.maSP)?.hasPromotion ? 'text-red-600' : 'text-gray-900']">
                                            {{ formatPrice(getPriceStock(product.maSP)?.finalPrice || getPriceStock(product.maSP)?.minPrice) }}
                                        </p>
                                    </div>

                                    <!-- Add to Cart Button -->
                                    <button
                                        @click="openQuickView(product.maSP)"
                                        :disabled="getPriceStock(product.maSP)?.outOfStock"
                                        class="add-cart-btn mt-3"
                                    >
                                        <span class="material-symbols-outlined text-sm">shopping_bag</span>
                                        {{ getPriceStock(product.maSP)?.outOfStock ? 'Hết hàng' : 'Chọn sản phẩm' }}
                                    </button>
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
      quickViewProductId: null
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
      this.currentPage = 0
      this.fetchProducts()
    }
  },

  mounted() {
    const path = this.$route.path
    if (path.includes('/nam')) {
      this.filters.gioiTinh = 0
      this.pageTitle = "Bộ sưu tập Nam"
    } else if (path.includes('/nu')) {
      this.filters.gioiTinh = 1
      this.pageTitle = "Bộ sưu tập Nữ"
    }
    this.fetchProducts()
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
  z-index: 3;
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

/* Add to Cart Button */
.add-cart-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  width: 100%;
  padding: 9px 12px;
  border-radius: 10px;
  border: 1.5px solid #E5E7EB;
  background: #fff;
  color: #111827;
  font-size: 12.5px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s ease;
  letter-spacing: 0.3px;
}
.add-cart-btn:hover:not(:disabled) {
  background: #111827;
  color: #fff;
  border-color: #111827;
}
.add-cart-btn:disabled {
  color: #9CA3AF;
  cursor: not-allowed;
  opacity: 0.6;
}

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
