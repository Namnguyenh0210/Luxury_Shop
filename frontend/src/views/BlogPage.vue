<template>
  <div class="relative flex min-h-screen w-full flex-col group/design-root bg-background-light dark:bg-background-dark text-text-primary-light dark:text-text-primary-dark font-display">
    <AppHeader />
    <div class="flex-grow">

    <!-- HERO SECTION -->
    <section class="relative min-h-[50vh] flex items-center justify-center overflow-hidden">
      <div class="absolute inset-0 bg-cover bg-center bg-fixed transition-transform duration-1000"
        style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuDMTNoi4GK3bD9_L6V5FInuIltPBhQaSgp9c6pJSXVVUFUOGbaLX5qWkS6PapTywk-PdfIvXbWzRqUb3QneLD78UoPfJz5Dq8XeTi8kX8jZ53hkE4ZTXgUlj6xHyiDNLF9as7HR-iA1otrrbjasvZZgnXDANWvdgkKTRzSlTQVEmUyk-hQDsqmxL88bCEzONW515DyTOXaMbWXgDDbR2ABRhKE23E--uCxI0HH0_5PwvO_1vdM2ZDUKdW5lvRPEvLjVjY9ymCsxrPk');">
      </div>
      <div class="absolute inset-0 bg-black/50 backdrop-blur-[2px]"></div>
      <div class="relative z-10 text-center px-4 max-w-4xl mx-auto">
        <p class="text-[#C8A97E] text-xs font-bold uppercase tracking-[0.3em] mb-4">✦ THE EDITORIAL ✦</p>
        <h1 class="text-4xl md:text-6xl font-serif font-bold text-white mb-6 leading-tight">
          Phong Cách & <br>
          <span class="text-[#C8A97E] italic">Cảm Hứng</span>
        </h1>
        <p class="text-white/70 text-base md:text-lg mb-8 max-w-2xl mx-auto font-light tracking-wide">
          Nơi lưu giữ những câu chuyện về phong cách sống, xu hướng thời trang thượng lưu và tư duy thẩm mỹ hiện đại.
        </p>
        <a href="#bai-viet" class="inline-flex items-center gap-3 border border-[#C8A97E] text-[#C8A97E] hover:bg-[#C8A97E] hover:text-black font-bold px-10 py-3 rounded-full transition-all duration-500 group">
          KHÁM PHÁ
          <span class="material-symbols-outlined transition-transform group-hover:translate-y-1">arrow_downward</span>
        </a>
      </div>
    </section>

    <!-- BREADCRUMB -->
    <div class="w-full px-4 md:px-[2cm] py-8 border-b border-gray-100 dark:border-gray-800">
      <nav class="flex items-center gap-2 text-xs uppercase tracking-widest text-gray-400">
        <router-link to="/" class="hover:text-[#C8A97E] transition-colors">TRANG CHỦ</router-link>
        <span class="material-symbols-outlined text-[12px]">chevron_right</span>
        <span class="text-gray-900 dark:text-gray-100">KIẾN THỨC</span>
      </nav>
    </div>

    <!-- NỘI DUNG CHÍNH -->
    <main class="w-full px-4 md:px-[2cm] py-16" id="bai-viet">

      <!-- Loading -->
      <div v-if="dangTai" class="flex flex-col items-center justify-center py-24">
        <div class="w-12 h-12 border-2 border-[#C8A97E] border-t-transparent rounded-full animate-spin mb-4"></div>
        <p class="text-gray-400 font-light tracking-widest uppercase text-xs">Đang tải câu chuyện...</p>
      </div>

      <template v-else>

        <!-- BÀI VIẾT NỔI BẬT -->
        <section v-if="noiBat.length > 0" class="mb-24">
          <div class="flex flex-col items-center mb-12">
            <h2 class="text-3xl font-serif font-bold text-gray-900 dark:text-white mb-2 text-center">Featured Stories</h2>
            <div class="w-16 h-[2px] bg-[#C8A97E]"></div>
          </div>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
            <router-link v-for="bv in noiBat.slice(0,2)" :key="bv.maBV"
              :to="`/blog/${bv.maBV}`"
              class="group relative overflow-hidden rounded-lg bg-gray-100 dark:bg-gray-900 block aspect-[16/10]">
              <img v-if="bv.hinhAnh" :src="bv.hinhAnh" :alt="bv.tieuDe"
                class="w-full h-full object-cover transition-transform duration-1000 group-hover:scale-105" />
              <div v-else class="w-full h-full bg-stone-100 flex items-center justify-center">
                <span class="material-symbols-outlined text-6xl text-stone-300">article</span>
              </div>
              <div class="absolute inset-0 bg-gradient-to-t from-black/90 via-black/20 to-transparent opacity-80 group-hover:opacity-100 transition-opacity"></div>
              <div class="absolute bottom-0 left-0 right-0 p-8">
                <span v-if="bv.loaiBaiViet" class="inline-block border border-[#C8A97E] text-[#C8A97E] text-[10px] font-bold px-3 py-1 rounded-full mb-4 uppercase tracking-widest">
                  {{ bv.loaiBaiViet.tenLoaiBV }}
                </span>
                <h3 class="text-white font-serif font-bold text-2xl leading-tight mb-3 group-hover:text-[#C8A97E] transition-colors">
                  {{ bv.tieuDe }}
                </h3>
                <div class="flex items-center gap-4 text-white/50 text-[11px] uppercase tracking-widest">
                  <span>{{ bv.tacGia || 'Luxury Editor' }}</span>
                  <span class="w-1 h-1 bg-white/30 rounded-full"></span>
                  <span>{{ formatDate(bv.ngayDang) }}</span>
                </div>
              </div>
            </router-link>
          </div>
        </section>

        <!-- TÌM KIẾM & LỌC -->
        <div class="flex flex-col md:flex-row items-center justify-between gap-6 mb-16 pb-8 border-b border-gray-100 dark:border-gray-800">
           <div class="flex items-center gap-8">
              <h2 class="text-2xl font-serif font-bold text-gray-900 dark:text-white">The Collection</h2>
              <span class="text-xs text-gray-400 uppercase tracking-widest font-medium">{{ tongSo }} ARTICLES</span>
           </div>
          <div class="relative w-full md:w-80">
            <input v-model="tuKhoaTim" @input="timKiem" placeholder="Search the archives..."
              class="w-full bg-transparent border-b border-gray-300 dark:border-gray-700 pb-2 text-sm focus:outline-none focus:border-[#C8A97E] transition-colors placeholder:text-gray-400 uppercase tracking-widest" />
            <span class="absolute right-0 bottom-2 text-gray-400">
              <span class="material-symbols-outlined text-[18px]">search</span>
            </span>
          </div>
        </div>

        <!-- DANH SÁCH BÀI VIẾT -->
        <section>
          <!-- Không có bài viết -->
          <div v-if="danhSach.length === 0" class="flex flex-col items-center justify-center py-24 text-gray-400">
            <span class="material-symbols-outlined text-4xl mb-4 font-light">article</span>
            <p class="text-sm uppercase tracking-[0.2em]">No articles found in this collection</p>
          </div>

          <!-- Grid bài viết -->
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-x-8 gap-y-16">
            <router-link v-for="bv in danhSach" :key="bv.maBV"
              :to="`/blog/${bv.maBV}`"
              class="group flex flex-col bg-transparent">

              <!-- Ảnh bài viết -->
              <div class="relative overflow-hidden aspect-[4/5] bg-stone-100 dark:bg-stone-900 rounded-sm mb-6">
                <img v-if="bv.hinhAnh" :src="bv.hinhAnh" :alt="bv.tieuDe"
                  class="w-full h-full object-cover grayscale-[20%] group-hover:grayscale-0 transition-all duration-700 group-hover:scale-[1.03]" />
                <div v-else class="w-full h-full flex items-center justify-center">
                  <span class="material-symbols-outlined text-4xl text-stone-200">article</span>
                </div>
                <div v-if="bv.loaiBaiViet" class="absolute top-4 left-4">
                  <span class="bg-white/90 dark:bg-black/90 text-black dark:text-white text-[9px] font-bold px-3 py-1 uppercase tracking-widest shadow-sm">
                    {{ bv.loaiBaiViet.tenLoaiBV }}
                  </span>
                </div>
              </div>

              <!-- Nội dung card -->
              <div class="flex flex-col flex-1">
                <div class="flex items-center gap-2 text-[10px] text-gray-400 uppercase tracking-widest mb-3">
                  <span>{{ formatDate(bv.ngayDang) }}</span>
                  <span class="w-[2px] h-[2px] bg-gray-300 rounded-full"></span>
                  <span>{{ bv.loaiBaiViet ? bv.loaiBaiViet.tenLoaiBV : 'Edit' }}</span>
                </div>
                <h3 class="font-serif font-bold text-gray-900 dark:text-white text-lg mb-3 line-clamp-2 group-hover:text-[#C8A97E] transition-colors leading-snug">
                  {{ bv.tieuDe }}
                </h3>
                <p class="text-gray-800 dark:text-gray-200 text-sm line-clamp-3 flex-1 mb-6 leading-relaxed font-light">
                  {{ bv.tomTat || 'Discover the latest stories from our editors...' }}
                </p>
                <div class="flex items-center justify-between text-[11px] text-gray-600 dark:text-gray-400 py-4 border-t border-gray-100 dark:border-gray-800">
                  <div class="flex items-center gap-2">
                    <span class="w-5 h-5 rounded-full bg-stone-200 dark:bg-stone-800 flex items-center justify-center text-[10px] font-bold text-stone-600">
                      {{ (bv.tacGia || 'L').charAt(0).toUpperCase() }}
                    </span>
                    <span class="font-medium uppercase tracking-tight">{{ bv.tacGia || 'Luxury Fashion' }}</span>
                  </div>
                  <div class="flex items-center gap-3">
                    <span class="flex items-center gap-1">
                      <span class="material-symbols-outlined text-[14px]">visibility</span>
                      {{ bv.luotXem || 0 }}
                    </span>
                    <span class="flex items-center gap-1">
                      <span class="material-symbols-outlined text-[14px]">chat_bubble</span>
                      {{ bv.soLuongBinhLuan || 0 }}
                    </span>
                  </div>
                </div>
              </div>
            </router-link>
          </div>

          <!-- PHÂN TRANG -->
          <div v-if="tongTrang > 1" class="flex justify-center items-center gap-8 mt-24">
            <button @click="doiTrang(trangHienTai - 1)" :disabled="trangHienTai === 0"
              class="flex items-center gap-2 text-xs font-bold uppercase tracking-widest text-gray-400 hover:text-[#C8A97E] disabled:opacity-20 transition-colors">
              <span class="material-symbols-outlined text-[18px]">west</span> Previous
            </button>
            <div class="flex gap-4">
              <button v-for="t in tongTrang" :key="t"
                @click="doiTrang(t - 1)"
                class="w-8 h-8 rounded-full border text-[11px] font-bold flex items-center justify-center transition-all duration-300"
                :class="trangHienTai === t - 1
                  ? 'bg-[#C8A97E] border-[#C8A97E] text-black shadow-lg shadow-[#C8A97E]/20'
                  : 'border-transparent text-gray-400 hover:text-gray-900 dark:hover:text-white'">
                {{ t }}
              </button>
            </div>
            <button @click="doiTrang(trangHienTai + 1)" :disabled="trangHienTai >= tongTrang - 1"
              class="flex items-center gap-2 text-xs font-bold uppercase tracking-widest text-gray-400 hover:text-[#C8A97E] disabled:opacity-20 transition-colors">
              Next <span class="material-symbols-outlined text-[18px]">east</span>
            </button>
          </div>
        </section>

      </template>
    </main>

    </div><!-- end flex-grow -->
    <AppFooter />
  </div>
</template>

<script>
import axios from 'axios'
import AppHeader from './fragments/AppHeader.vue'
import AppFooter from './fragments/AppFooter.vue'

export default {
  name: 'BlogPage',
  components: { AppHeader, AppFooter },

  data() {
    return {
      danhSach: [],
      noiBat: [],
      dangTai: true,
      tuKhoaTim: '',
      tongSo: 0,
      tongTrang: 1,
      trangHienTai: 0,
      demTim: null
    }
  },

  async mounted() {
    await this.taiDuLieu()

    if (this.$route.query.latest && this.danhSach.length > 0) {
      this.danhSach.sort((a, b) => new Date(b.ngayDang) - new Date(a.ngayDang))

      const baiMoiNhat = this.danhSach[0]

      this.$router.replace(`/blog/${baiMoiNhat.maBV}`)
    }
  },

  methods: {
    async taiDuLieu(trang = 0) {
      this.dangTai = true
      try {
        const params = { page: trang, size: 12 }
        if (this.tuKhoaTim.trim()) params.search = this.tuKhoaTim.trim()

        const res = await axios.get('/blog', { params })
        if (res.data.thanhCong !== false) {
          this.danhSach = res.data.danhSach || []
          this.noiBat = res.data.noiBat || []
          this.tongSo = res.data.tongSo || 0
          this.tongTrang = res.data.tongTrang || 1
          this.trangHienTai = res.data.trangHienTai || 0
        }
      } catch (e) {
        console.error('Lỗi tải bài viết:', e)
      } finally {
        this.dangTai = false
      }
    },

    timKiem() {
      clearTimeout(this.demTim)
      this.demTim = setTimeout(() => this.taiDuLieu(0), 400)
    },

    doiTrang(trang) {
      if (trang < 0 || trang >= this.tongTrang) return
      this.trangHienTai = trang
      this.taiDuLieu(trang)
      window.scrollTo({ top: 0, behavior: 'smooth' })
    },

    formatDate(d) {
      if (!d) return ''
      return new Date(d).toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' })
    }
  }
}
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
