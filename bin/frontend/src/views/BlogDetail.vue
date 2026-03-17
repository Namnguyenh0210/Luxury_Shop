<template>
  <div class="relative flex min-h-screen w-full flex-col group/design-root bg-background-light dark:bg-background-dark text-text-primary-light dark:text-text-primary-dark font-display">
    <AppHeader />
    <div class="flex-grow">

    <!-- Loading -->
    <div v-if="dangTai" class="flex flex-col items-center justify-center min-h-screen">
      <div class="w-12 h-12 border-4 border-yellow-400 border-t-transparent rounded-full animate-spin mb-4"></div>
      <p class="text-gray-400">Đang tải bài viết...</p>
    </div>

    <!-- Không tìm thấy -->
    <div v-else-if="!baiViet" class="flex flex-col items-center justify-center min-h-screen text-gray-400">
      <span class="material-symbols-outlined text-6xl mb-4">article</span>
      <h2 class="text-xl font-bold mb-2">Bài viết không tồn tại</h2>
      <router-link to="/blog" class="text-yellow-600 hover:underline">← Quay lại trang blog</router-link>
    </div>

    <template v-else>
      <!-- BREADCRUMB -->
      <div class="max-w-4xl mx-auto px-4 sm:px-6 pt-8">
        <nav class="flex items-center gap-2 text-sm text-gray-500">
          <router-link to="/" class="hover:text-yellow-600 transition-colors">Trang Chủ</router-link>
          <span class="material-symbols-outlined text-[14px]">chevron_right</span>
          <router-link to="/blog" class="hover:text-yellow-600 transition-colors">Blog</router-link>
          <span class="material-symbols-outlined text-[14px]">chevron_right</span>
          <span class="text-gray-800 font-medium line-clamp-1">{{ baiViet.tieuDe }}</span>
        </nav>
      </div>

      <!-- ẢNH BÌA BÀI VIẾT -->
      <div class="max-w-4xl mx-auto px-4 sm:px-6 mt-6">
        <div v-if="baiViet.hinhAnh" class="w-full h-64 sm:h-80 md:h-[450px] rounded-2xl overflow-hidden">
          <img :src="baiViet.hinhAnh" :alt="baiViet.tieuDe" class="w-full h-full object-cover" />
        </div>
      </div>

      <!-- NỘI DUNG BÀI VIẾT -->
      <article class="max-w-4xl mx-auto px-4 sm:px-6 py-10">

        <!-- Header bài viết -->
        <header class="mb-8">
          <div v-if="baiViet.loaiBaiViet" class="mb-4">
            <span class="inline-block bg-yellow-100 text-yellow-800 text-xs font-bold px-3 py-1 rounded-full uppercase tracking-widest">
              {{ baiViet.loaiBaiViet.tenLoaiBV }}
            </span>
          </div>
          <h1 class="text-3xl sm:text-4xl md:text-5xl font-bold text-gray-900 leading-tight mb-6">
            {{ baiViet.tieuDe }}
          </h1>
          <div class="flex flex-wrap items-center gap-4 text-sm text-gray-500 pb-6 border-b border-gray-100">
            <div class="flex items-center gap-2">
              <div class="w-8 h-8 rounded-full bg-yellow-500 text-black flex items-center justify-center font-bold text-sm">
                {{ (baiViet.tacGia || 'L').charAt(0).toUpperCase() }}
              </div>
              <span class="font-medium text-gray-700">{{ baiViet.tacGia || 'Luxury Fashion' }}</span>
            </div>
            <span class="flex items-center gap-1">
              <span class="material-symbols-outlined text-[16px]">calendar_today</span>
              {{ formatDate(baiViet.ngayDang) }}
            </span>
            <span class="flex items-center gap-1">
              <span class="material-symbols-outlined text-[16px]">visibility</span>
              {{ baiViet.luotXem || 0 }} lượt xem
            </span>
            <span class="flex items-center gap-1">
              <span class="material-symbols-outlined text-[16px]">chat_bubble</span>
              {{ soLuongBinhLuan }} bình luận
            </span>
          </div>
        </header>

        <!-- Thân bài viết -->
        <div class="prose prose-lg max-w-none text-gray-700 leading-relaxed"
          style="white-space: pre-wrap; line-height: 1.9; font-size: 1.05rem;">
          {{ baiViet.noiDung }}
        </div>

        <!-- CHIA SẺ -->
        <div class="mt-12 py-6 border-t border-b border-gray-100">
          <div class="flex flex-wrap items-center justify-between gap-4">
            <span class="text-sm font-bold uppercase tracking-wider text-gray-500">📢 Chia Sẻ Bài Viết:</span>
            <div class="flex items-center gap-3">
              <button @click="chiaSeFacebook"
                class="flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
                <svg viewBox="0 0 24 24" class="w-4 h-4 fill-white"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/></svg>
                Facebook
              </button>
              <button @click="chiaSeFacebook"
                class="flex items-center gap-2 bg-black hover:bg-gray-800 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
                <svg viewBox="0 0 24 24" class="w-4 h-4 fill-white"><path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/></svg>
                X (Twitter)
              </button>
              <button @click="saoChepLink"
                class="flex items-center gap-2 bg-gray-100 hover:bg-gray-200 text-gray-700 px-4 py-2 rounded-lg text-sm font-medium transition-colors">
                <span class="material-symbols-outlined text-[16px]">link</span>
                {{ daSaoChepLink ? 'Đã sao chép!' : 'Sao Chép Link' }}
              </button>
            </div>
          </div>
        </div>

        <!-- BÀI VIẾT LIÊN QUAN -->
        <section v-if="lienQuan.length > 0" class="mt-14">
          <div class="flex items-center gap-3 mb-6">
            <div class="w-1 h-7 bg-yellow-500 rounded-full"></div>
            <h2 class="text-xl font-bold text-gray-900">Bài Viết Liên Quan</h2>
          </div>
          <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
            <router-link v-for="bv in lienQuan" :key="bv.maBV"
              :to="`/blog/${bv.maBV}`"
              class="group flex flex-col rounded-xl overflow-hidden border border-gray-100 hover:shadow-md transition-all duration-300">
              <div class="aspect-video overflow-hidden bg-gray-100">
                <img v-if="bv.hinhAnh" :src="bv.hinhAnh" :alt="bv.tieuDe"
                  class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" />
                <div v-else class="w-full h-full bg-yellow-50 flex items-center justify-center">
                  <span class="material-symbols-outlined text-yellow-300 text-3xl">article</span>
                </div>
              </div>
              <div class="p-4">
                <p class="font-semibold text-gray-800 text-sm line-clamp-2 group-hover:text-yellow-700 transition-colors leading-tight">
                  {{ bv.tieuDe }}
                </p>
                <p class="text-xs text-gray-400 mt-2">{{ formatDate(bv.ngayDang) }}</p>
              </div>
            </router-link>
          </div>
        </section>

        <!-- KHU VỰC BÌNH LUẬN -->
        <section class="mt-14" id="binh-luan">
          <div class="flex items-center gap-3 mb-6">
            <div class="w-1 h-7 bg-yellow-500 rounded-full"></div>
            <h2 class="text-xl font-bold text-gray-900">
              Bình Luận ({{ soLuongBinhLuan }})
            </h2>
          </div>

          <!-- Form bình luận -->
          <div class="bg-gray-50 rounded-2xl p-6 mb-8">
            <h3 class="text-sm font-bold text-gray-700 mb-3 uppercase tracking-wide">
              {{ daDangNhap ? '✍️ Viết bình luận của bạn' : '🔒 Đăng nhập để bình luận' }}
            </h3>
            <div v-if="daDangNhap">
              <textarea v-model="noiDungBinhLuan" rows="4"
                placeholder="Chia sẻ suy nghĩ của bạn về bài viết này..."
                class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-yellow-400 resize-none bg-white mb-3">
              </textarea>
              <div class="flex justify-end">
                <button @click="dangBinhLuan" :disabled="dangGui || !noiDungBinhLuan.trim()"
                  class="flex items-center gap-2 bg-yellow-500 hover:bg-yellow-600 text-black font-bold px-6 py-2.5 rounded-xl text-sm transition-colors disabled:opacity-50">
                  <span class="material-symbols-outlined text-[16px]">send</span>
                  {{ dangGui ? 'Đang gửi...' : 'Đăng Bình Luận' }}
                </button>
              </div>
            </div>
            <div v-else class="flex items-center justify-between">
              <p class="text-sm text-gray-500">Bạn cần đăng nhập để có thể bình luận</p>
              <router-link to="/login" class="bg-yellow-500 hover:bg-yellow-600 text-black font-bold px-5 py-2 rounded-xl text-sm transition-colors">
                Đăng Nhập
              </router-link>
            </div>
          </div>

          <!-- Thông báo -->
          <div v-if="thongBao" class="mb-4 px-4 py-3 rounded-xl text-sm font-medium"
            :class="loaiThongBao === 'ok' ? 'bg-green-50 text-green-700 border border-green-200' : 'bg-red-50 text-red-600 border border-red-200'">
            {{ thongBao }}
          </div>

          <!-- Danh sách bình luận -->
          <div v-if="danhSachBinhLuan.length === 0" class="text-center py-12 text-gray-400">
            <span class="material-symbols-outlined text-5xl mb-3">chat_bubble_outline</span>
            <p>Chưa có bình luận nào. Hãy là người đầu tiên!</p>
          </div>

          <div v-else class="space-y-4">
            <div v-for="bl in danhSachBinhLuan" :key="bl.maBL"
              class="flex gap-4 p-5 bg-white rounded-2xl border border-gray-100 hover:border-yellow-200 transition-colors">

              <!-- Avatar -->
              <div class="flex-shrink-0">
                <div class="w-10 h-10 rounded-full bg-gradient-to-br from-yellow-400 to-yellow-600 text-black flex items-center justify-center font-bold text-sm">
                  {{ (bl.tenNguoiDung || 'K').charAt(0).toUpperCase() }}
                </div>
              </div>

              <!-- Nội dung bình luận -->
              <div class="flex-1 min-w-0">
                <div class="flex items-center gap-2 mb-1">
                  <span class="font-semibold text-gray-800 text-sm">{{ bl.tenNguoiDung || 'Khách' }}</span>
                  <span class="text-xs text-gray-400">• {{ formatDateTime(bl.ngayBinhLuan) }}</span>
                </div>
                <p class="text-gray-700 text-sm leading-relaxed">{{ bl.noiDung }}</p>
                <div class="flex items-center gap-3 mt-3">
                  <button @click="likeBinhLuan(bl)"
                    class="flex items-center gap-1 text-xs text-gray-400 hover:text-red-500 transition-colors group">
                    <span class="material-symbols-outlined text-[16px] group-hover:fill-red-500">favorite</span>
                    <span>{{ bl.soLuongLike || 0 }} thích</span>
                  </button>
                </div>
              </div>
            </div>
          </div>

        </section>

        <!-- Nút quay lại -->
        <div class="mt-14 pt-6 border-t border-gray-100">
          <router-link to="/blog"
            class="inline-flex items-center gap-2 text-sm font-medium text-gray-500 hover:text-yellow-600 transition-colors">
            <span class="material-symbols-outlined text-[18px]">arrow_back</span>
            Quay Lại Trang Blog
          </router-link>
        </div>
      </article>
    </template>

    </div><!-- end flex-grow -->
    <AppFooter />
  </div>
</template>

<script>
import axios from 'axios'
import AppHeader from './fragments/AppHeader.vue'
import AppFooter from './fragments/AppFooter.vue'

export default {
  name: 'BlogDetail',
  components: { AppHeader, AppFooter },

  data() {
    return {
      baiViet: null,
      danhSachBinhLuan: [],
      lienQuan: [],
      soLuongBinhLuan: 0,
      dangTai: true,
      noiDungBinhLuan: '',
      dangGui: false,
      thongBao: '',
      loaiThongBao: 'ok',
      daDangNhap: false,
      daSaoChepLink: false
    }
  },

  async mounted() {
    await this.kiemTraDangNhap()
    await this.taiChiTiet()
  },

  watch: {
    '$route.params.id'() {
      this.taiChiTiet()
    }
  },

  methods: {
    async kiemTraDangNhap() {
      try {
        const res = await axios.get('/api/auth/current-user')
        this.daDangNhap = res.data.authenticated === true
      } catch {
        this.daDangNhap = false
      }
    },

    async taiChiTiet() {
      const id = this.$route.params.id
      if (!id) return
      this.dangTai = true
      try {
        const res = await axios.get(`/blog/${id}`)
        if (res.data.thanhCong) {
          this.baiViet = res.data.baiViet
          this.danhSachBinhLuan = res.data.binhLuan || []
          this.lienQuan = res.data.lienQuan || []
          this.soLuongBinhLuan = res.data.soLuongBinhLuan || 0
        } else {
          this.baiViet = null
        }
      } catch (e) {
        console.error('Lỗi tải chi tiết bài viết:', e)
        this.baiViet = null
      } finally {
        this.dangTai = false
      }
    },

    async dangBinhLuan() {
      if (!this.noiDungBinhLuan.trim()) return
      this.dangGui = true
      this.thongBao = ''
      try {
        const id = this.$route.params.id
        const res = await axios.post(`/blog/${id}/binh-luan`, {
          noiDung: this.noiDungBinhLuan.trim()
        })
        if (res.data.thanhCong) {
          this.danhSachBinhLuan.unshift(res.data.binhLuan)
          this.soLuongBinhLuan++
          this.noiDungBinhLuan = ''
          this.thongBao = '✅ Bình luận đã được đăng thành công!'
          this.loaiThongBao = 'ok'
        } else {
          this.thongBao = '❌ ' + (res.data.thongBao || 'Có lỗi xảy ra')
          this.loaiThongBao = 'loi'
        }
      } catch (e) {
        this.thongBao = '❌ Lỗi kết nối: ' + e.message
        this.loaiThongBao = 'loi'
      } finally {
        this.dangGui = false
        setTimeout(() => this.thongBao = '', 4000)
      }
    },

    async likeBinhLuan(bl) {
      try {
        const res = await axios.post(`/blog/binh-luan/${bl.maBL}/like`)
        if (res.data.thanhCong) {
          bl.soLuongLike = res.data.soLuongLike
        }
      } catch (e) {
        console.error('Lỗi like:', e)
      }
    },

    chiaSeFacebook() {
      const url = encodeURIComponent(window.location.href)
      window.open(`https://www.facebook.com/sharer/sharer.php?u=${url}`, '_blank', 'width=600,height=400')
    },

    saoChepLink() {
      navigator.clipboard.writeText(window.location.href).then(() => {
        this.daSaoChepLink = true
        setTimeout(() => this.daSaoChepLink = false, 2000)
      })
    },

    formatDate(d) {
      if (!d) return ''
      return new Date(d).toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' })
    },

    formatDateTime(d) {
      if (!d) return ''
      return new Date(d).toLocaleString('vi-VN', {
        day: '2-digit', month: '2-digit', year: 'numeric',
        hour: '2-digit', minute: '2-digit'
      })
    }
  }
}
</script>

<style scoped>
.line-clamp-1 {
  display: -webkit-box;
  -webkit-line-clamp: 1;
  line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
