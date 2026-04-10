<template>
<div class="relative flex min-h-screen w-full flex-col group/design-root bg-background-light dark:bg-background-dark text-text-primary-light dark:text-text-primary-dark font-display">
    <!-- Header Fragment -->
    <AppHeader />
    
    <main class="flex-grow">
        <div class="container mx-auto px-4 lg:px-[1cm] xl:px-[2cm] py-4">
            <div class="flex min-h-[60vh] flex-col items-center justify-center gap-6 rounded-lg bg-cover bg-center bg-no-repeat p-4 text-center md:gap-8" data-alt="A high-fashion model posing in a minimalist, modern setting, wearing an elegant outfit from the new collection." style="background-image: linear-gradient(rgba(0, 0, 0, 0.2) 0%, rgba(0, 0, 0, 0.5) 100%), url('/images/banner/image.png');">
                <div class="flex flex-col gap-4">
                    <h1 class="font-serif text-4xl font-bold text-white md:text-6xl">Luxury Shop</h1>
                    <h2 class="text-base font-normal text-white md:text-lg">Thương hiệu thời trang dẫn đầu xu thế</h2>
                </div>
                <a class="flex min-w-[160px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-full h-12 px-8 bg-white text-black text-sm font-bold tracking-[0.2em] uppercase transition-all hover:bg-[#C8A97E] hover:text-white hover:scale-105 shadow-lg" href="/sanpham">
                    <span class="truncate">Khám phá ngay</span>
                </a>
            </div>
        </div>
      <div class="container mx-auto px-4 lg:px-[1cm] xl:px-[2cm] py-16">
        <h2 class="text-center font-serif text-3xl font-bold tracking-tight md:text-4xl">
          Thương Hiệu Nổi Bật
        </h2>

        <div class="mt-8 grid gap-6 [grid-template-columns:repeat(auto-fit,minmax(250px,1fr))]">

          <!-- CHANEL -->
          <div
            @click="goBrand(2)"
            class="group relative cursor-pointer overflow-hidden rounded-lg border border-gray-200 hover:border-[#C8A97E] transition"
        >
          <div class="aspect-[3/4] w-full">
            <img src="/images/banner/chanel-brand.png"
                 class="w-full h-full object-cover transition duration-500 group-hover:scale-105" />
          </div>

          <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition flex items-center justify-center">
            <span class="text-white font-bold tracking-widest">CHANEL</span>
          </div>
        </div>

          <!-- GUCCI -->
          <div
              @click="goBrand(1)"
              class="group relative cursor-pointer overflow-hidden rounded-lg border border-gray-200 hover:border-[#C8A97E] transition"
          >
            <div class="aspect-[3/4] w-full">
              <img src="/images/banner/gucci-brand.png"
                   class="w-full h-full object-cover" />
            </div>

            <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition flex items-center justify-center">
              <span class="text-white font-bold tracking-widest">GUCCI</span>
            </div>
          </div>

          <!-- MLB -->
          <div
              @click="goBrand(3)"
              class="group relative cursor-pointer overflow-hidden rounded-lg border border-gray-200 hover:border-[#C8A97E] transition"
          >
            <div class="aspect-[3/4] w-full">
              <img src="/images/banner/mlb-brand.png"
                   class="w-full h-full object-cover" />
            </div>

            <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition flex items-center justify-center">
              <span class="text-white font-bold tracking-widest">MLB</span>
            </div>
          </div>
        </div>
        </div>
      <div class="container mx-auto px-4 lg:px-[1cm] xl:px-[2cm] py-16 border-t border-gray-100">
        <h2 class="text-center font-serif text-3xl font-bold tracking-tight md:text-4xl">Sản Phẩm Mới</h2>
        
        <!-- Loading Skeleton / Placeholder if needed -->
        <div v-if="loading" class="mt-8 grid grid-cols-2 gap-x-4 gap-y-8 sm:grid-cols-2 md:grid-cols-4 lg:gap-x-6">
            <div v-for="i in 4" :key="i" class="animate-pulse">
                <div class="aspect-w-3 aspect-h-4 w-full rounded-lg bg-gray-200" style="aspect-ratio: 3/4;"></div>
                <div class="mt-4 h-4 w-3/4 bg-gray-200 rounded"></div>
                <div class="mt-2 h-4 w-1/4 bg-gray-200 rounded"></div>
            </div>
        </div>

        <div v-else class="mt-8 grid grid-cols-2 gap-x-4 gap-y-8 sm:grid-cols-2 md:grid-cols-4 lg:gap-x-6">
          <div v-for="(product, index) in newArrivals" :key="product.maSP" class="group relative flex flex-col">
            <div @click="goToDetail(product.maSP)" class="aspect-[3/4] w-full overflow-hidden rounded-lg bg-secondary cursor-pointer relative shadow-sm hover:shadow-md transition-shadow">
              <img 
                class="absolute inset-0 h-full w-full object-cover object-center transition-all duration-500 group-hover:scale-105" 
                :class="{'scale-110': index === 0, 'p-4': index !== 0}"
                :alt="product.tenSP"
                :src="product.anhChinh || '/img/placeholder.png'"
                @error="(e) => e.target.src = '/img/placeholder.png'"
              >
            </div>
            <div class="flex flex-col flex-1 p-4 bg-white">
              <!-- Brand and Title -->
              <div class="mb-2 w-full">
                <p class="text-[12px] text-gray-400 uppercase tracking-widest font-bold mb-1">
                  {{ product.thuongHieu?.tenTH || 'Thương hiệu' }}
                </p>
                <h4 class="text-gray-900 text-[16px] md:text-[17px] font-semibold leading-snug truncate w-full" :title="product.tenSP">
                  <a :href="`/sanpham/${product.maSP}`">
                    {{ product.tenSP }}
                  </a>
                </h4>
              </div>

              <!-- Bottom Row: Price (Left) & Add Button (Right) -->
              <div class="flex flex-row justify-between items-end mt-auto pt-1">
                <!-- Price -->
                <div class="flex flex-col justify-end">
                  <p class="text-[17px] md:text-[19px] font-bold text-gray-900">
                    {{ formatPrice(getPrice(product.maSP)) }}
                  </p>
                </div>

                <!-- Add Button -->
                <div class="flex-shrink-0">
                  <button
                      @click.stop="goToDetail(product.maSP)"
                      class="flex items-center gap-1.5 bg-black hover:bg-[#C8A97E] text-white px-3 py-2.5 rounded-lg text-sm font-bold transition-colors shadow-sm"
                      title="Xem chi tiết"
                  >
                    <span class="material-symbols-outlined text-[18px]">shopping_bag</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div v-if="!loading && newArrivals.length === 0" class="text-center py-10 opacity-60">
            Không có sản phẩm nào mới.
        </div>
      </div>ont
        <div class="bg-background-light dark:bg-background-dark py-16">
            <div class="container mx-auto px-4 lg:px-[1cm] xl:px-[2cm]">
                <div class="grid grid-cols-1 items-center gap-12 lg:grid-cols-2 lg:gap-32">
                    <div class="relative h-96 overflow-hidden rounded-lg lg:h-[32rem]">
                      <img
                          v-if="latestBlog && latestBlog.hinhAnh"
                          class="h-full w-full object-cover"
                          :src="latestBlog.hinhAnh"
                          :alt="latestBlog.tieuDe"
                          @error="(e) => e.target.src = 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=1000'"
                      />
                      <img
                          v-else
                          class="h-full w-full object-cover"
                          data-alt="An artistic, black and white shot of a designer sketching in a studio."
                          src="https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=1000"
                          alt="Banner blog"
                      />
                    </div>
                    <div class="text-center lg:text-left lg:pl-16">
                        <p v-if="latestBlog" class="text-[#C8A97E] text-[10px] uppercase tracking-[0.3em] font-bold mb-2">✦ Tin Tức Mới Nhất ✦</p>
                        <h2 class="font-serif text-3xl font-bold tracking-tight md:text-4xl">
                            {{ latestBlog ? latestBlog.tieuDe : 'Tin tức thời trang' }}
                        </h2>
                        <p class="mt-4 text-text-primary-light/80 dark:text-text-primary-dark/80 line-clamp-3">
                            {{ latestBlog ? latestBlog.tomTat : 'Tin thời trang sản phẩm cập nhật mới nhất 24/24 luôn nắm bắt xu thế và dẫ đầu trong lĩnh vực thời trang' }}
                        </p>
                        <router-link 
                            class="mt-8 inline-block rounded-full bg-black px-10 py-4 text-sm font-bold uppercase tracking-widest text-white transition-all hover:bg-[#C8A97E] hover:scale-105 shadow-xl" 
                            :to="latestBlog ? `/blog/${latestBlog.maBV}` : '/kienthuc'"
                        >
                            {{ latestBlog ? 'Đọc bài viết ngay' : 'Nhấn để xem bài viết mới nhất hiện tại' }}
                        </router-link>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <!-- Footer Fragment -->
    <AppFooter />
</div>

</template>

<script>
import AppHeader from './fragments/AppHeader.vue'
import AppFooter from './fragments/AppFooter.vue'
import axios from 'axios'

export default {
  name: 'Home',
  components: {
    AppHeader,
    AppFooter
  },
  methods: {
    goBrand(brandId) {
      this.$router.push({
        path: '/sanpham',
        query: {
          thuongHieu: brandId
        }
      })
    },
    async fetchNewArrivals() {
        this.loading = true
        try {
            const res = await axios.get('/sanpham', {
                params: {
                    page: 0,
                    size: 4,
                    sort: 'moi'
                }
            })
            if (res.data.success) {
                this.newArrivals = res.data.content
                this.priceMap = res.data.priceStockMap
            }
        } catch (e) {
            console.error('Error fetching new arrivals:', e)
        } finally {
            this.loading = false
        }
    },
    getPrice(maSP) {
        return this.priceMap[maSP]?.minPrice || 0
    },
    formatPrice(price) {
        return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price);
    },
    goToDetail(id) {
        this.$router.push(`/sanpham/${id}`)
    },
    async fetchLatestBlog() {
        try {
            const res = await axios.get('/blog', {
                params: { page: 0, size: 1 }
            })
            // API trả về danhSach là mảng các bài viết
            if (res.data.thanhCong && res.data.danhSach && res.data.danhSach.length > 0) {
                this.latestBlog = res.data.danhSach[0]
            }
        } catch (e) {
            console.error('Error fetching latest blog:', e)
        }
    }
  },
  data() {
    return {
        newArrivals: [],
        priceMap: {},
        latestBlog: null,
        loading: true
    }
  },
  mounted() {
    this.fetchNewArrivals()
    this.fetchLatestBlog()
  }
}
</script>

<style scoped>
@import '@/assets/css/Home.css';

body {
    font-family: 'Times New Roman', Times, serif;
}
h1, h2, h3, h4, h5, h6 {
    font-family: 'Times New Roman', Times, serif;
}
.material-symbols-outlined {
    font-variation-settings:
                    'FILL' 0,
                    'wght' 300,
                    'GRAD' 0,
                    'opsz' 24
}
</style>
