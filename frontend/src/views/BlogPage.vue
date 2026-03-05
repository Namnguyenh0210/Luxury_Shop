<template>
  <div class="relative flex min-h-screen w-full flex-col group/design-root bg-background-light dark:bg-background-dark text-text-primary-light dark:text-text-primary-dark font-display">
    <AppHeader />
    <div class="flex-grow">

    <!-- HERO SECTION -->
    <section class="relative min-h-[60vh] flex items-center justify-center overflow-hidden">
      <div class="absolute inset-0 bg-cover bg-center"
        style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuDMTNoi4GK3bD9_L6V5FInuIltPBhQaSgp9c6pJSXVVUFUOGbaLX5qWkS6PapTywk-PdfIvXbWzRqUb3QneLD78UoPfJz5Dq8XeTi8kX8jZ53hkE4ZTXgUlj6xHyiDNLF9as7HR-iA1otrrbjasvZZgnXDANWvdgkKTRzSlTQVEmUyk-hQDsqmxL88bCEzONW515DyTOXaMbWXgDDbR2ABRhKE23E--uCxI0HH0_5PwvO_1vdM2ZDUKdW5lvRPEvLjVjY9ymCsxrPk');">
      </div>
      <div class="absolute inset-0 bg-gradient-to-b from-black/30 via-black/50 to-black/70"></div>
      <div class="relative z-10 text-center px-4 max-w-4xl mx-auto">
        <p class="text-yellow-400 text-sm font-bold uppercase tracking-widest mb-4">✦ Luxury Fashion Blog ✦</p>
        <h1 class="text-4xl md:text-6xl font-bold text-white mb-6 leading-tight">
          Phong Cách Sống<br><span class="text-yellow-400">Đẳng Cấp</span>
        </h1>
        <p class="text-white/80 text-lg mb-8 max-w-2xl mx-auto">
          Khám phá xu hướng thời trang, phong cách sống xa hoa và những câu chuyện đằng sau các thương hiệu luxury hàng đầu thế giới.
        </p>
        <a href="#bai-viet" class="inline-flex items-center gap-2 bg-yellow-500 hover:bg-yellow-600 text-black font-bold px-8 py-3 rounded-full transition-all duration-300 transform hover:scale-105">
          Đọc Ngay
          <span class="material-symbols-outlined">arrow_downward</span>
        </a>
      </div>
    </section>

    <!-- NỘI DUNG CHÍNH -->
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16" id="bai-viet">

      <!-- Loading -->
      <div v-if="dangTai" class="flex flex-col items-center justify-center py-24">
        <div class="w-12 h-12 border-4 border-yellow-400 border-t-transparent rounded-full animate-spin mb-4"></div>
        <p class="text-gray-400">Đang tải bài viết...</p>
      </div>

      <template v-else>

        <!-- BÀI VIẾT NỔI BẬT -->
        <section v-if="noiBat.length > 0" class="mb-16">
          <div class="flex items-center gap-3 mb-8">
            <div class="w-1 h-8 bg-yellow-500 rounded-full"></div>
            <h2 class="text-2xl font-bold text-gray-900">Bài Viết Nổi Bật</h2>
          </div>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <router-link v-for="bv in noiBat.slice(0,2)" :key="bv.maBV"
              :to="`/blog/${bv.maBV}`"
              class="group relative overflow-hidden rounded-2xl bg-gray-100 block"
              style="aspect-ratio: 4/3;">
              <img v-if="bv.hinhAnh" :src="bv.hinhAnh" :alt="bv.tieuDe"
                class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110" />
              <div v-else class="w-full h-full bg-gradient-to-br from-yellow-100 to-yellow-200 flex items-center justify-center">
                <span class="material-symbols-outlined text-6xl text-yellow-400">article</span>
              </div>
              <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent"></div>
              <div class="absolute bottom-0 left-0 right-0 p-6">
                <span v-if="bv.loaiBaiViet" class="inline-block bg-yellow-500 text-black text-xs font-bold px-3 py-1 rounded-full mb-3">
                  {{ bv.loaiBaiViet.tenLoaiBV }}
                </span>
                <h3 class="text-white font-bold text-xl leading-tight mb-2 group-hover:text-yellow-300 transition-colors">
                  {{ bv.tieuDe }}
                </h3>
                <p class="text-white/70 text-sm">{{ bv.tacGia }} • {{ formatDate(bv.ngayDang) }}</p>
              </div>
            </router-link>
          </div>
        </section>

        <!-- TÌM KIẾM -->
        <div class="flex items-center gap-3 mb-8">
          <div class="relative flex-1 max-w-md">
            <span class="absolute inset-y-0 left-3 flex items-center text-gray-400">
              <span class="material-symbols-outlined text-[18px]">search</span>
            </span>
            <input v-model="tuKhoaTim" @input="timKiem" placeholder="Tìm kiếm bài viết..."
              class="w-full border border-gray-200 rounded-xl pl-9 pr-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-yellow-400" />
          </div>
        </div>

        <!-- DANH SÁCH BÀI VIẾT -->
        <section>
          <div class="flex items-center gap-3 mb-8">
            <div class="w-1 h-8 bg-yellow-500 rounded-full"></div>
            <h2 class="text-2xl font-bold text-gray-900">Tất Cả Bài Viết</h2>
            <span class="bg-yellow-100 text-yellow-700 px-3 py-1 rounded-full text-sm font-medium">{{ tongSo }} bài</span>
          </div>

          <!-- Không có bài viết -->
          <div v-if="danhSach.length === 0" class="flex flex-col items-center justify-center py-24 text-gray-400">
            <span class="material-symbols-outlined text-6xl mb-4">article</span>
            <p class="text-lg">Không có bài viết nào</p>
            <p class="text-sm mt-1">Hãy quay lại sau nhé!</p>
          </div>

          <!-- Grid bài viết -->
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
            <router-link v-for="bv in danhSach" :key="bv.maBV"
              :to="`/blog/${bv.maBV}`"
              class="group flex flex-col bg-white rounded-2xl overflow-hidden shadow-sm border border-gray-100 hover:shadow-lg hover:-translate-y-1 transition-all duration-300">

              <!-- Ảnh bài viết -->
              <div class="relative overflow-hidden aspect-[4/3] bg-gray-100">
                <img v-if="bv.hinhAnh" :src="bv.hinhAnh" :alt="bv.tieuDe"
                  class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105" />
                <div v-else class="w-full h-full bg-gradient-to-br from-yellow-50 to-yellow-100 flex items-center justify-center">
                  <span class="material-symbols-outlined text-5xl text-yellow-300">article</span>
                </div>
                <div v-if="bv.loaiBaiViet" class="absolute top-3 left-3">
                  <span class="bg-yellow-500 text-black text-xs font-bold px-2.5 py-1 rounded-full">
                    {{ bv.loaiBaiViet.tenLoaiBV }}
                  </span>
                </div>
              </div>

              <!-- Nội dung card -->
              <div class="flex flex-col flex-1 p-5">
                <h3 class="font-bold text-gray-900 text-base mb-2 line-clamp-2 group-hover:text-yellow-700 transition-colors leading-tight">
                  {{ bv.tieuDe }}
                </h3>
                <p class="text-gray-500 text-sm line-clamp-3 flex-1 mb-4 leading-relaxed">
                  {{ bv.tomTat || 'Nhấn để đọc bài viết đầy đủ...' }}
                </p>
                <div class="flex items-center justify-between text-xs text-gray-400 pt-3 border-t border-gray-100">
                  <div class="flex items-center gap-1">
                    <span class="material-symbols-outlined text-[14px]">person</span>
                    <span class="font-medium">{{ bv.tacGia || 'Luxury Fashion' }}</span>
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
                    <span>{{ formatDate(bv.ngayDang) }}</span>
                  </div>
                </div>
              </div>
            </router-link>
          </div>

          <!-- PHÂN TRANG -->
          <div v-if="tongTrang > 1" class="flex justify-center gap-2 mt-12">
            <button @click="doiTrang(trangHienTai - 1)" :disabled="trangHienTai === 0"
              class="px-4 py-2 rounded-xl border border-gray-200 text-sm font-medium text-gray-600 hover:bg-gray-50 disabled:opacity-40 transition-colors">
              ← Trước
            </button>
            <button v-for="t in tongTrang" :key="t"
              @click="doiTrang(t - 1)"
              class="px-4 py-2 rounded-xl border text-sm font-medium transition-colors"
              :class="trangHienTai === t - 1
                ? 'bg-yellow-500 border-yellow-500 text-black font-bold'
                : 'border-gray-200 text-gray-600 hover:bg-gray-50'">
              {{ t }}
            </button>
            <button @click="doiTrang(trangHienTai + 1)" :disabled="trangHienTai >= tongTrang - 1"
              class="px-4 py-2 rounded-xl border border-gray-200 text-sm font-medium text-gray-600 hover:bg-gray-50 disabled:opacity-40 transition-colors">
              Sau →
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
  },

  methods: {
    async taiDuLieu(trang = 0) {
      this.dangTai = true
      try {
        const params = { page: trang, size: 9 }
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
