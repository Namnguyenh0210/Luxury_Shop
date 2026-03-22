<template>
  <div class="relative flex min-h-screen w-full flex-col group/design-root bg-background-light dark:bg-background-dark text-text-primary-light dark:text-text-primary-dark font-display">
    <AppHeader />
    <div class="flex-grow">

    <!-- Loading -->
    <div v-if="dangTai" class="flex flex-col items-center justify-center min-h-screen">
      <div class="w-12 h-12 border-4 border-[#C8A97E] border-t-transparent rounded-full animate-spin mb-4"></div>
      <p class="text-gray-400">Đang tải bài viết...</p>
    </div>

    <!-- Không tìm thấy -->
    <div v-else-if="!baiViet" class="flex flex-col items-center justify-center min-h-screen text-gray-400">
      <span class="material-symbols-outlined text-6xl mb-4">article</span>
      <h2 class="text-xl font-bold mb-2">Bài viết không tồn tại</h2>
      <router-link to="/blog" class="text-[#C8A97E] hover:underline uppercase tracking-widest text-xs font-bold">← Quay lại trang blog</router-link>
    </div>

    <template v-else>
      <!-- BREADCRUMB -->
      <div class="w-full px-4 md:px-[2cm] py-8 border-b border-gray-100 dark:border-gray-800">
        <nav class="flex items-center gap-2 text-[10px] uppercase tracking-[0.2em] text-gray-400">
          <router-link to="/" class="hover:text-[#C8A97E] transition-colors">TRANG CHỦ</router-link>
          <span class="material-symbols-outlined text-[12px]">chevron_right</span>
          <router-link to="/blog" class="hover:text-[#C8A97E] transition-colors">KIẾN THỨC</router-link>
          <span class="material-symbols-outlined text-[12px]">chevron_right</span>
          <span class="text-gray-900 dark:text-gray-100 font-medium truncate max-w-[200px]">{{ baiViet.tieuDe }}</span>
        </nav>
      </div>

      <!-- NỘI DUNG BÀI VIẾT -->
      <article class="w-full px-4 md:px-[2cm] py-16">
        <div class="max-w-4xl mx-auto">
          <!-- Header bài viết -->
          <header class="mb-12 text-center">
            <div v-if="baiViet.loaiBaiViet" class="mb-6">
              <span class="inline-block border border-[#C8A97E] text-[#C8A97E] text-[10px] font-bold px-4 py-1 rounded-full uppercase tracking-[0.3em]">
                {{ baiViet.loaiBaiViet.tenLoaiBV }}
              </span>
            </div>
            <h1 class="text-3xl md:text-5xl font-serif font-bold text-gray-900 dark:text-white leading-tight mb-8">
              {{ baiViet.tieuDe }}
            </h1>
            <div class="flex items-center justify-center gap-6 text-[11px] uppercase tracking-widest text-gray-400 pb-12 border-b border-gray-100 dark:border-gray-800">
              <div class="flex items-center gap-2">
                <div class="w-6 h-6 rounded-full bg-[#C8A97E] text-black flex items-center justify-center font-bold text-[10px]">
                  {{ (baiViet.tacGia || 'L').charAt(0).toUpperCase() }}
                </div>
                <span class="font-bold text-gray-900 dark:text-white">{{ baiViet.tacGia || 'LUXURY EDITOR' }}</span>
              </div>
              <span class="w-[3px] h-[3px] bg-gray-300 rounded-full"></span>
              <span>{{ formatDate(baiViet.ngayDang) }}</span>
              <span class="w-[3px] h-[3px] bg-gray-300 rounded-full"></span>
              <span class="flex items-center gap-1">
                <span class="material-symbols-outlined text-[14px]">visibility</span>
                {{ baiViet.luotXem || 0 }} Views
              </span>
            </div>
          </header>

          <!-- ẢNH BÌA BÀI VIẾT -->
          <div v-if="baiViet.hinhAnh" class="w-full aspect-[16/9] rounded-sm overflow-hidden mb-16 shadow-2xl">
            <img :src="baiViet.hinhAnh" :alt="baiViet.tieuDe" class="w-full h-full object-cover transition-all duration-1000" />
          </div>

          <!-- Thân bài viết -->
          <div class="prose prose-stone dark:prose-invert max-w-none text-gray-800 dark:text-gray-200 leading-[2] font-light text-lg mb-20"
            style="white-space: pre-wrap;">
            {{ baiViet.noiDung }}
          </div>

          <!-- CHIA SẺ -->
          <div class="py-8 border-t border-b border-gray-100 dark:border-gray-800 mb-20">
            <div class="flex flex-col sm:flex-row items-center justify-between gap-6">
              <span class="text-[10px] font-bold uppercase tracking-[0.3em] text-gray-400">Share this story</span>
              <div class="flex items-center gap-4">
                <button @click="chiaSeFacebook"
                  class="w-10 h-10 flex items-center justify-center rounded-full border border-gray-200 hover:border-[#C8A97E] hover:text-[#C8A97E] transition-all">
                  <svg viewBox="0 0 24 24" class="w-4 h-4 fill-current"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/></svg>
                </button>
                <button @click="chiaSeFacebook"
                  class="w-10 h-10 flex items-center justify-center rounded-full border border-gray-200 hover:border-[#C8A97E] hover:text-[#C8A97E] transition-all">
                   <svg viewBox="0 0 24 24" class="w-4 h-4 fill-current"><path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/></svg>
                </button>
                <button @click="saoChepLink"
                  class="flex items-center gap-2 border border-gray-200 hover:border-[#C8A97E] hover:text-[#C8A97E] px-6 py-2 rounded-full text-[10px] font-bold uppercase tracking-widest transition-all">
                  <span class="material-symbols-outlined text-[16px]">link</span>
                  {{ daSaoChepLink ? 'COPIED' : 'COPY LINK' }}
                </button>
              </div>
            </div>
          </div>

          <!-- BÀI VIẾT LIÊN QUAN -->
          <section v-if="lienQuan.length > 0" class="mb-24">
            <div class="flex flex-col items-center mb-12">
              <h2 class="text-2xl font-serif font-bold text-gray-900 dark:text-white mb-2">Related Stories</h2>
              <div class="w-12 h-[1px] bg-[#C8A97E]"></div>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-8">
              <router-link v-for="bv in lienQuan" :key="bv.maBV"
                :to="`/blog/${bv.maBV}`"
                class="group flex flex-col">
                <div class="aspect-[4/5] overflow-hidden bg-stone-100 dark:bg-stone-900 mb-4">
                  <img v-if="bv.hinhAnh" :src="bv.hinhAnh" :alt="bv.tieuDe"
                    class="w-full h-full object-cover grayscale-[30%] group-hover:grayscale-0 transition-all duration-700" />
                  <div v-else class="w-full h-full flex items-center justify-center">
                    <span class="material-symbols-outlined text-stone-200 text-3xl">article</span>
                  </div>
                </div>
                <div>
                  <p class="font-serif font-bold text-gray-900 dark:text-white text-base line-clamp-2 group-hover:text-[#C8A97E] transition-colors leading-snug">
                    {{ bv.tieuDe }}
                  </p>
                  <p class="text-[10px] text-gray-400 uppercase tracking-widest mt-3">{{ formatDate(bv.ngayDang) }}</p>
                </div>
              </router-link>
            </div>
          </section>

          <!-- KHU VỰC BÌNH LUẬN -->
          <section id="binh-luan">
            <!-- Header -->
            <div class="comment-section-header">
              <div class="comment-accent-bar"></div>
              <h2 class="comment-section-title">
                Bình Luận
                <span class="comment-count-badge">{{ soLuongBinhLuan }}</span>
              </h2>
            </div>

            <!-- Form bình luận -->
            <div class="comment-form-card">
              <div v-if="daDangNhap" class="comment-form-inner">
                <div class="form-user-avatar">
                  <span>B</span>
                </div>
                <div class="comment-input-wrap">
                  <textarea
                    v-model="noiDungBinhLuan"
                    rows="4"
                    maxlength="500"
                    placeholder="Chia sẻ suy nghĩ của bạn về bài viết này..."
                    class="comment-textarea"
                  ></textarea>
                  <div class="comment-form-footer">
                    <span class="comment-char-count">{{ noiDungBinhLuan.length }}/500</span>
                    <button
                      @click="dangBinhLuan"
                      :disabled="dangGui || !noiDungBinhLuan.trim()"
                      class="comment-submit-btn"
                    >
                      <span v-if="dangGui" class="comment-spinner"></span>
                      <svg v-else xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="22" y1="2" x2="11" y2="13"></line><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                      </svg>
                      {{ dangGui ? 'Đang gửi...' : 'Đăng bình luận' }}
                    </button>
                  </div>
                </div>
              </div>
              <div v-else class="comment-login-prompt">
                <span class="material-symbols-outlined prompt-icon">lock</span>
                <p>Đăng nhập để tham gia thảo luận về bài viết này</p>
                <router-link to="/login" class="comment-login-btn">Đăng nhập ngay</router-link>
              </div>
            </div>

            <!-- Thông báo -->
            <Transition name="notif-fade">
              <div v-if="thongBao"
                :class="['comment-notif', loaiThongBao === 'ok' ? 'ok' : 'err']">
                {{ thongBao }}
              </div>
            </Transition>

            <!-- Danh sách bình luận -->
            <div v-if="danhSachBinhLuan.length === 0" class="comment-empty">
              <span class="material-symbols-outlined prompt-icon" style="color: #9CA3AF; background: #F3F4F6;">chat_bubble</span>
              <p>Chưa có bình luận nào. Hãy là người đầu tiên!</p>
            </div>

            <TransitionGroup name="comment-item" tag="div" class="comment-list">
              <div v-for="bl in danhSachBinhLuan" :key="bl.maBL" class="comment-card">
                <!-- Avatar -->
                <div class="comment-avatar">
                  {{ (bl.tenNguoiDung || 'K').charAt(0).toUpperCase() }}
                </div>
                <!-- Nội dung -->
                <div class="comment-body">
                  <div class="comment-meta flex justify-between items-start">
                    <div>
                      <span class="comment-author">{{ bl.tenNguoiDung || 'Khách' }}</span>
                      <span class="comment-time">• {{ formatDateTime(bl.ngayBinhLuan) }}</span>
                    </div>
                    <button v-if="daDangNhap" @click="baoCaoBinhLuan(bl.maBL)" title="Báo cáo vi phạm" class="btn-report-cmt text-gray-300 hover:text-red-500 transition-colors">
                      <span class="material-symbols-outlined text-[16px]">flag</span>
                    </button>
                  </div>
                  <p class="comment-text">{{ bl.noiDung }}</p>

                  <!-- Admin Phản hồi -->
                  <div v-if="bl.phanHoiAdmin" class="admin-reply-box mt-3 bg-gray-50/80 p-3 rounded-lg border border-gray-100">
                    <div class="flex items-center gap-1 text-[#C8A97E] font-semibold text-xs mb-1">
                      <span class="material-symbols-outlined text-[14px]">storefront</span> 
                      Phản hồi từ Luxury Shop 
                      <span class="text-gray-400 font-normal ml-1">{{ formatDateTime(bl.ngayPhanHoiAdmin) }}</span>
                    </div>
                    <p class="text-sm text-gray-700 leading-relaxed">{{ bl.phanHoiAdmin }}</p>
                  </div>

                  <div class="comment-actions mt-2">
                    <button @click="likeBinhLuan(bl)" class="comment-like-btn" :class="{ liked: bl.liked }">
                      <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" :fill="bl.liked ? 'currentColor' : 'none'" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                      </svg>
                      <span>{{ bl.soLuongLike || 0 }} thích</span>
                    </button>
                  </div>
                </div>
              </div>
            </TransitionGroup>

          </section>


          <!-- Nút quay lại -->
          <div class="mt-14 pt-6 border-t border-gray-100">
            <router-link to="/blog"
              class="inline-flex items-center gap-2 text-xs font-bold uppercase tracking-widest text-gray-400 hover:text-[#C8A97E] transition-colors">
              <span class="material-symbols-outlined text-[18px]">arrow_back</span>
              Quay Lại Trang Blog
            </router-link>
          </div>
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
        const res = await axios.get('/auth/current-user')
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

/* ===== COMMENT SECTION — LUXURY ===== */
.comment-section-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 24px;
}
.comment-accent-bar {
  width: 4px;
  height: 26px;
  background: linear-gradient(180deg, #D4A853, #B8892A);
  border-radius: 2px;
}
.comment-section-title {
  font-size: 20px;
  font-weight: 800;
  color: #111827;
  font-family: 'Times New Roman', Times, serif;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 10px;
}
.comment-count-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 26px;
  height: 22px;
  padding: 0 8px;
  background: #1a1a2e;
  color: #fff;
  font-size: 12px;
  font-weight: 700;
  border-radius: 11px;
  font-family: inherit;
}

/* Comment Form Card */
.comment-form-card {
  background: #FAFAFA;
  border: 1px solid #F0E6C8;
  border-radius: 16px;
  padding: 24px;
  margin-bottom: 28px;
}
.comment-form-inner {
  display: flex;
  gap: 14px;
  align-items: flex-start;
}
.form-user-avatar {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  background: linear-gradient(135deg, #D4A853, #B8892A);
  color: #fff;
  font-size: 15px;
  font-weight: 800;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.comment-input-wrap { flex: 1; }
.comment-textarea {
  width: 100%;
  border: 1.5px solid #E5E7EB;
  border-radius: 12px;
  padding: 12px 14px;
  font-size: 14px;
  color: #374151;
  font-family: inherit;
  resize: vertical;
  outline: none;
  background: #fff;
  transition: border-color 0.15s;
  box-sizing: border-box;
  line-height: 1.5;
}
.comment-textarea:focus { border-color: #D4A853; }
.comment-form-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 8px;
}
.comment-char-count { font-size: 11px; color: #9CA3AF; }
.comment-submit-btn {
  display: flex;
  align-items: center;
  gap: 7px;
  background: linear-gradient(135deg, #1a1a2e, #0f3460);
  color: #fff;
  border: none;
  border-radius: 10px;
  padding: 9px 22px;
  font-size: 13px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s;
}
.comment-submit-btn:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 6px 20px rgba(15,52,96,0.35);
}
.comment-submit-btn:disabled { opacity: 0.45; cursor: not-allowed; transform: none; }
.comment-spinner {
  width: 13px; height: 13px;
  border: 2px solid rgba(255,255,255,0.35);
  border-top-color: #fff;
  border-radius: 50%;
  animation: cspin 0.7s linear infinite;
}
@keyframes cspin { to { transform: rotate(360deg); } }

/* Login prompt */
.comment-login-prompt {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 32px 0;
  text-align: center;
  color: #4B5563;
  font-size: 14.5px;
}
.prompt-icon {
  font-size: 36px;
  color: #D4A853;
  background: rgba(212, 168, 83, 0.1);
  padding: 16px;
  border-radius: 50%;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.comment-login-btn {
  display: inline-block;
  background: #111827;
  color: #fff;
  padding: 10px 32px;
  border-radius: 6px;
  text-decoration: none;
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 0.5px;
  text-transform: uppercase;
  margin-top: 8px;
  transition: all 0.3s ease;
}
.comment-login-btn:hover { background: #D4A853; color: #fff; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(212,168,83,0.3); }

/* Notification */
.comment-notif {
  margin-bottom: 16px;
  padding: 10px 14px;
  border-radius: 10px;
  font-size: 13px;
  font-weight: 600;
}
.comment-notif.ok { background: #ECFDF5; color: #065F46; border: 1px solid #A7F3D0; }
.comment-notif.err { background: #FEF2F2; color: #991B1B; border: 1px solid #FECACA; }
.notif-fade-enter-active { transition: all 0.25s ease; }
.notif-fade-leave-active { transition: all 0.2s ease; }
.notif-fade-enter-from, .notif-fade-leave-to { opacity: 0; transform: translateY(-6px); }

/* Comment Empty */
.comment-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 40px;
  color: #9CA3AF;
  font-size: 14.5px;
  text-align: center;
  border: 1.5px dashed #E5E7EB;
  border-radius: 14px;
}

/* Comment List */
.comment-list { display: flex; flex-direction: column; gap: 14px; }
.comment-card {
  display: flex;
  gap: 12px;
  padding: 18px 20px;
  background: #fff;
  border: 1px solid #F3F4F6;
  border-radius: 14px;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.comment-card:hover {
  border-color: #F0E6C8;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}
.comment-avatar {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  background: linear-gradient(135deg, #D4A853, #9A6B1E);
  color: #fff;
  font-size: 15px;
  font-weight: 800;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.comment-body { flex: 1; min-width: 0; }
.comment-meta { display: flex; align-items: center; gap: 6px; margin-bottom: 6px; }
.comment-author { font-size: 13px; font-weight: 700; color: #111827; }
.comment-time { font-size: 12px; color: #9CA3AF; }
.comment-text {
  font-size: 14px;
  color: #374151;
  line-height: 1.65;
  margin: 0 0 10px;
  white-space: pre-wrap;
}
.comment-actions { display: flex; gap: 12px; }
.comment-like-btn {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 12px;
  color: #9CA3AF;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  transition: color 0.15s;
}
.comment-like-btn:hover { color: #DC2626; }
.comment-like-btn.liked { color: #DC2626; }

/* Animations */  
.comment-item-enter-active { transition: all 0.35s ease; }
.comment-item-leave-active { transition: all 0.2s ease; }
.comment-item-enter-from { opacity: 0; transform: translateY(-10px); }
.comment-item-leave-to { opacity: 0; transform: translateX(10px); }
</style>

