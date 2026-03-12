<template>
  <section class="reviews-section" id="danh-gia">
    <!-- Header -->
    <div class="section-header">
      <div class="header-accent"></div>
      <h2 class="section-title">Đánh giá sản phẩm</h2>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="reviews-loading">
      <div class="spinner"></div>
      <p>Đang tải đánh giá...</p>
    </div>

    <template v-else>
      <!-- ========== SUMMARY PANEL ========== -->
      <div class="rating-summary">
        <!-- Điểm lớn bên trái -->
        <div class="avg-score-box">
          <div class="avg-number">{{ diemTrungBinh > 0 ? diemTrungBinh.toFixed(1) : '—' }}</div>
          <div class="avg-stars">
            <span v-for="s in 5" :key="s" class="star-icon" :class="{ filled: s <= Math.round(diemTrungBinh) }">★</span>
          </div>
          <div class="avg-count">{{ tongSoDanhGia }} đánh giá</div>
        </div>

        <!-- Phân bố sao -->
        <div class="star-distribution">
          <div v-for="(count, star) in thongKeSao" :key="star" class="star-bar-row">
            <div class="star-label">
              <span class="star-icon filled" style="font-size:13px">★</span>
              <span>{{ star }}</span>
            </div>
            <div class="star-bar-track">
              <div class="star-bar-fill" :style="{ width: tongSoDanhGia > 0 ? (count / tongSoDanhGia * 100) + '%' : '0%' }"></div>
            </div>
            <span class="star-count">{{ count }}</span>
          </div>
        </div>
      </div>

      <!-- ========== FORM ĐÁNH GIÁ ========== -->
      <div class="review-form-wrap">
        <!-- Nếu chưa đăng nhập -->
        <div v-if="!daDangNhap" class="review-auth-prompt">
          <span class="material-symbols-outlined prompt-icon">lock</span>
          <p>Đăng nhập để viết đánh giá về sản phẩm này</p>
          <a href="/login" class="btn-login-prompt">Đăng nhập</a>
        </div>

        <!-- Đã đăng nhập nhưng chưa mua -->
        <div v-else-if="coTheReview.length === 0 && !daDanhGiaHet" class="review-not-purchased">
          <span class="material-symbols-outlined prompt-icon">shopping_bag</span>
          <p>Chỉ khách hàng đã mua và nhận được sản phẩm mới có thể đánh giá.</p>
        </div>

        <!-- Form đánh giá (đã mua + đơn đã giao) -->
        <div v-else-if="coTheReview.length > 0" class="review-form">
          <h3 class="form-title">
            <span class="material-symbols-outlined" style="font-size: 20px; vertical-align: middle; margin-right: 6px;">edit_document</span>
            Viết đánh giá của bạn
          </h3>

          <!-- Chọn đơn hàng cần review (nếu có nhiều) -->
          <div v-if="coTheReview.length > 1" class="form-group">
            <label class="form-label">Chọn đơn hàng để đánh giá:</label>
            <select v-model="selectedMaCT" class="form-select">
              <option v-for="ct in coTheReview" :key="ct.maCT" :value="ct.maCT">
                Đơn #{{ ct.maDH }} — {{ ct.tenBienThe }}
              </option>
            </select>
          </div>
          <div v-else class="form-info-tag">
            Đang đánh giá: Đơn #{{ coTheReview[0].maDH }} — {{ coTheReview[0].tenBienThe }}
          </div>

          <!-- Chọn sao -->
          <div class="form-group">
            <label class="form-label">Chất lượng sản phẩm: <span class="required">*</span></label>
            <div class="star-picker">
              <button
                v-for="s in 5" :key="s"
                @click="selectedDiem = s"
                @mouseover="hoveredDiem = s"
                @mouseleave="hoveredDiem = 0"
                :class="['star-pick-btn', { active: s <= (hoveredDiem || selectedDiem) }]"
                type="button"
              >★</button>
              <span class="star-label-text" :class="{ visible: selectedDiem > 0 }">
                {{ starLabels[selectedDiem - 1] }}
              </span>
            </div>
          </div>

          <!-- Nhập bình luận -->
          <div class="form-group">
            <label class="form-label">Nhận xét của bạn:</label>
            <textarea v-model="noiDung" rows="4" class="form-textarea"
              placeholder="Chia sẻ cảm nhận về chất liệu, đường may, kích thước... để giúp người mua khác!">
            </textarea>
            <span class="char-count">{{ noiDung.length }} / 500</span>
          </div>

          <!-- Buttons -->
          <div class="form-actions">
            <button @click="guiDanhGia" :disabled="dangGui || selectedDiem === 0" class="btn-submit">
              <span v-if="dangGui" class="btn-spinner"></span>
              <span v-else class="material-symbols-outlined" style="font-size:16px">send</span>
              {{ dangGui ? 'Đang gửi...' : 'Gửi đánh giá' }}
            </button>
          </div>

          <!-- Toast -->
          <Transition name="toast">
            <div v-if="toastMsg" :class="['toast', toastType]">
              {{ toastMsg }}
            </div>
          </Transition>
        </div>

        <!-- Đã đánh giá hết rồi -->
        <div v-else-if="daDanhGiaHet" class="review-done">
          <span class="material-symbols-outlined prompt-icon" style="color: #10B981;">check_circle</span>
          <p>Bạn đã hoàn tất đánh giá cho tất cả sản phẩm đã mua. Cảm ơn bạn!</p>
        </div>
      </div>

      <!-- ========== DANH SÁCH ĐÁNH GIÁ ========== -->
      <div class="reviews-list">
        <div v-if="danhGiaList.length === 0" class="no-reviews">
          <span class="material-symbols-outlined" style="font-size:48px;color:#D1D5DB">reviews</span>
          <p>Chưa có đánh giá nào. Hãy là người đầu tiên đánh giá sản phẩm này!</p>
        </div>

        <div v-else class="review-cards">
          <TransitionGroup name="review-item">
            <div v-for="dg in danhGiaList" :key="dg.maDG" class="review-card">
              <!-- Avatar + tên + Nút Report -->
              <div class="reviewer-info">
                <div class="reviewer-avatar">
                  <img v-if="dg.avatar" :src="dg.avatar" :alt="dg.tenNguoiDung" @error="handleAvatarError">
                  <span v-else>{{ (dg.tenNguoiDung || 'K').charAt(0).toUpperCase() }}</span>
                </div>
                <div class="flex-1">
                  <div class="reviewer-name">{{ dg.tenNguoiDung }}</div>
                  <div class="review-date">{{ dg.ngayDanhGia }}</div>
                </div>
                <button v-if="daDangNhap" @click="baoCaoDanhGia(dg.maDG)" title="Báo cáo vi phạm" class="btn-report">
                  <span class="material-symbols-outlined text-[16px]">flag</span>
                </button>
              </div>

              <!-- Sao + biến thể + text + Phản hồi shop -->
              <div class="review-body">
                <div class="review-stars-row">
                  <span v-for="s in 5" :key="s" class="star-icon" :class="{ filled: s <= dg.diem }">★</span>
                  <span v-if="dg.tenBienThe" class="review-variant">{{ dg.tenBienThe }}</span>
                </div>
                <p v-if="dg.noiDung" class="review-text">{{ dg.noiDung }}</p>
                <p v-else class="review-text no-content">— Không có nhận xét —</p>

                <!-- Admin Phản hồi -->
                <div v-if="dg.phanHoi" class="admin-reply-box mt-3 bg-gray-50/80 p-3 rounded-lg border border-gray-100">
                  <div class="flex items-center gap-1 text-yellow-600 font-semibold text-xs mb-1">
                    <span class="material-symbols-outlined text-[14px]">storefront</span> 
                    Phản hồi từ Luxury Shop 
                    <span class="text-gray-400 font-normal ml-1">{{ dg.ngayPhanHoi }}</span>
                  </div>
                  <p class="text-sm text-gray-700 leading-relaxed">{{ dg.phanHoi }}</p>
                </div>
              </div>
            </div>
          </TransitionGroup>
        </div>
      </div>
    </template>
  </section>
</template>

<script>
import axios from 'axios'

export default {
  name: 'ProductReviews',
  props: {
    productId: { type: Number, required: true }
  },
  data() {
    return {
      loading: true,
      danhGiaList: [],
      diemTrungBinh: 0,
      tongSoDanhGia: 0,
      thongKeSao: { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 },
      coTheReview: [],
      daDangNhap: false,
      daDanhGiaHet: false,

      // Form
      selectedDiem: 0,
      hoveredDiem: 0,
      noiDung: '',
      selectedMaCT: null,
      dangGui: false,
      toastMsg: null,
      toastType: 'success',

      starLabels: ['Tệ', 'Không hài lòng', 'Bình thường', 'Hài lòng', 'Xuất sắc!']
    }
  },
  watch: {
    productId: {
      immediate: true,
      handler(val) {
        if (val) this.init()
      }
    }
  },
  methods: {
    async init() {
      // Kiểm tra đăng nhập riêng biệt trước
      try {
        const authRes = await axios.get('/auth/current-user')
        this.daDangNhap = authRes.data.authenticated === true
        this.currentUserName = authRes.data.hoTen || ''
      } catch {
        this.daDangNhap = false
      }
      await this.fetchReviews()
    },

    async fetchReviews() {
      this.loading = true
      try {
        const res = await axios.get(`/san-pham/${this.productId}/danh-gia`)
        if (res.data) {
          this.danhGiaList = res.data.danhGiaList || []
          this.diemTrungBinh = res.data.diemTrungBinh || 0
          this.tongSoDanhGia = res.data.tongSoDanhGia || 0
          this.thongKeSao = res.data.thongKeSao || {}
          // Chỉ lấy coTheReview nếu đã đăng nhập
          if (this.daDangNhap) {
            this.coTheReview = res.data.coTheReview || []
            if (this.coTheReview.length > 0 && !this.selectedMaCT) {
              this.selectedMaCT = this.coTheReview[0].maCT
            }
          }
        }
      } catch (err) {
        console.error('Lỗi tải đánh giá:', err)
      } finally {
        this.loading = false
      }
    },


    async guiDanhGia() {
      if (this.selectedDiem === 0) {
        this.showToast('Vui lòng chọn số sao!', 'error')
        return
      }
      this.dangGui = true

      try {
        const res = await axios.post(`/san-pham/${this.productId}/danh-gia`, {
          diem: this.selectedDiem,
          noiDung: this.noiDung.trim(),
          maCT: this.selectedMaCT
        })
        if (res.data.thanhCong) {
          this.showToast(res.data.thongBao, 'success')
          // Thêm review mới lên đầu danh sách
          this.danhGiaList.unshift(res.data.danhGia)
          this.diemTrungBinh = res.data.diemTrungBinhMoi || this.diemTrungBinh
          this.tongSoDanhGia = res.data.tongSoDanhGiaMoi || this.tongSoDanhGia

          // Xóa item đã review khỏi coTheReview
          this.coTheReview = this.coTheReview.filter(ct => ct.maCT !== this.selectedMaCT)

          // Reset form
          this.selectedDiem = 0
          this.noiDung = ''
          if (this.coTheReview.length > 0) {
            this.selectedMaCT = this.coTheReview[0].maCT
          } else {
            this.daDanhGiaHet = true
          }
          // Cập nhật thống kê
          this.fetchReviews()
        } else {
          this.showToast(res.data.thongBao, 'error')
        }
      } catch (err) {
        this.showToast('Có lỗi xảy ra, vui lòng thử lại', 'error')
      } finally {
        this.dangGui = false
      }
    },

    async baoCaoDanhGia(maDG) {
      if (!confirm('Bạn có chắc chắn muốn báo cáo nội dung này là spam / xúc phạm?')) return
      try {
        const res = await axios.post(`/san-pham/danh-gia/${maDG}/report`)
        if (res.data.thanhCong) {
          this.showToast('Báo cáo thành công. Quản trị viên sẽ xem xét!', 'success')
        } else {
          this.showToast(res.data.thongBao, 'error')
        }
      } catch (e) {
        this.showToast('Lỗi gửi báo cáo', 'error')
      }
    },

    showToast(msg, type = 'success') {
      this.toastMsg = msg
      this.toastType = type
      setTimeout(() => { this.toastMsg = null }, 4000)
    },

    handleAvatarError(e) {
      e.target.style.display = 'none'
    }
  }
}
</script>

<style scoped>
/* ============================================
   PRODUCT REVIEWS — LUXURY DESIGN SYSTEM
   ============================================ */
.reviews-section {
  padding: 48px 0 24px;
  border-top: 1px solid #F3F4F6;
  position: relative;
}

.section-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 32px;
}
.header-accent {
  width: 4px;
  height: 28px;
  background: linear-gradient(180deg, #D4A853, #B8892A);
  border-radius: 2px;
}
.section-title {
  font-size: 22px;
  font-weight: 800;
  color: #111827;
  font-family: 'Playfair Display', Georgia, serif;
  margin: 0;
}

/* Loading */
.reviews-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 40px;
  color: #6B7280;
}
.spinner {
  width: 36px; height: 36px;
  border: 3px solid #F3F4F6;
  border-top-color: #D4A853;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* ===== SUMMARY PANEL ===== */
.rating-summary {
  display: flex;
  gap: 40px;
  background: linear-gradient(135deg, #FAFAFA, #F9F5ED);
  border: 1px solid #F0E6C8;
  border-radius: 16px;
  padding: 28px 32px;
  margin-bottom: 32px;
  align-items: center;
}
.avg-score-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  min-width: 100px;
  border-right: 1px solid #E5E7EB;
  padding-right: 32px;
}
.avg-number {
  font-size: 52px;
  font-weight: 900;
  color: #111827;
  line-height: 1;
  font-family: 'Playfair Display', Georgia, serif;
}
.avg-stars { display: flex; gap: 3px; margin: 8px 0; }
.avg-count { font-size: 12px; color: #6B7280; }

.review-summary { flex: 1; display: flex; align-items: center; gap: 32px; padding-right: 28px; border-right: 1px solid #E5E7EB; }
.sum-left { text-align: center; display: flex; flex-direction: column; align-items: center; }
.sum-points { font-size: 56px; font-weight: 800; color: #111827; letter-spacing: -1px; line-height: 1; }
.sum-stars { color: #F59E0B; font-size: 16px; margin: 6px 0 8px; }
.sum-total { font-size: 13px; color: #6B7280; font-weight: 500; }

.btn-report {
  background: none; border: none; padding: 4px;
  color: #D1D5DB; cursor: pointer; transition: color 0.2s;
}
.btn-report:hover { color: #DC2626; }

.star-bars { flex: 1; display: flex; flex-direction: column; gap: 8px; }
.star-bar-row { display: flex; align-items: center; gap: 10px; }
.star-label { display: flex; align-items: center; gap: 3px; font-size: 13px; color: #374151; min-width: 28px; }
.star-bar-track {
  flex: 1;
  height: 8px;
  background: #E5E7EB;
  border-radius: 99px;
  overflow: hidden;
}
.star-bar-fill {
  height: 100%;
  background: linear-gradient(90deg, #D4A853, #F0C060);
  border-radius: 99px;
  transition: width 0.6s ease;
}
.star-count { font-size: 12px; color: #6B7280; min-width: 20px; text-align: right; }

/* Stars */
.star-icon { font-size: 16px; color: #D1D5DB; }
.star-icon.filled { color: #F59E0B; }

/* ===== REVIEW FORM ===== */
.review-form-wrap {
  background: #FFFFFF;
  border: 1px solid #E5E7EB;
  border-radius: 16px;
  padding: 28px;
  margin-bottom: 36px;
  position: relative;
}
.review-auth-prompt, .review-not-purchased, .review-done {
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
.btn-login-prompt {
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
.btn-login-prompt:hover { background: #D4A853; color: #fff; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(212,168,83,0.3); }

.form-title { font-size: 15px; font-weight: 800; color: #111827; margin: 0 0 20px; }
.form-group { margin-bottom: 16px; }
.form-label { display: block; font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 8px; }
.required { color: #DC2626; }
.form-info-tag {
  font-size: 12px;
  color: #6B7280;
  background: #F3F4F6;
  padding: 6px 12px;
  border-radius: 8px;
  margin-bottom: 16px;
  display: inline-block;
}
.form-select {
  width: 100%;
  border: 1.5px solid #E5E7EB;
  border-radius: 10px;
  padding: 10px 14px;
  font-size: 14px;
  color: #374151;
  outline: none;
  transition: border-color 0.15s;
  background: #fff;
}
.form-select:focus { border-color: #D4A853; }

/* Star Picker */
.star-picker { display: flex; align-items: center; gap: 6px; }
.star-pick-btn {
  font-size: 32px;
  color: #E5E7EB;
  background: none;
  border: none;
  cursor: pointer;
  transition: all 0.15s ease;
  line-height: 1;
  padding: 0;
}
.star-pick-btn.active { color: #F59E0B; transform: scale(1.15); }
.star-pick-btn:hover { transform: scale(1.25); }
.star-label-text {
  font-size: 13px;
  font-weight: 700;
  color: #D4A853;
  margin-left: 8px;
  opacity: 0;
  transition: opacity 0.2s;
}
.star-label-text.visible { opacity: 1; }

.form-textarea {
  width: 100%;
  border: 1.5px solid #E5E7EB;
  border-radius: 10px;
  padding: 12px 14px;
  font-size: 14px;
  color: #374151;
  resize: vertical;
  outline: none;
  font-family: inherit;
  transition: border-color 0.15s;
  box-sizing: border-box;
}
.form-textarea:focus { border-color: #D4A853; }
.char-count { font-size: 11px; color: #9CA3AF; float: right; margin-top: 4px; }

.form-actions { display: flex; justify-content: flex-end; margin-top: 16px; }
.btn-submit {
  display: flex;
  align-items: center;
  gap: 8px;
  background: linear-gradient(135deg, #1a1a2e, #0f3460);
  color: #fff;
  border: none;
  border-radius: 12px;
  padding: 12px 28px;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s;
  box-shadow: 0 4px 16px rgba(15, 52, 96, 0.25);
}
.btn-submit:hover:not(:disabled) { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(15, 52, 96, 0.35); }
.btn-submit:disabled { opacity: 0.5; cursor: not-allowed; transform: none; }
.btn-spinner {
  width: 14px; height: 14px;
  border: 2px solid rgba(255,255,255,0.4);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}

/* Toast */
.toast {
  margin-top: 16px;
  padding: 12px 16px;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 600;
}
.toast.success { background: #ECFDF5; color: #065F46; border: 1px solid #A7F3D0; }
.toast.error { background: #FEF2F2; color: #991B1B; border: 1px solid #FECACA; }
.toast-enter-active { transition: all 0.3s ease; }
.toast-leave-active { transition: all 0.2s ease; }
.toast-enter-from, .toast-leave-to { opacity: 0; transform: translateY(-8px); }

/* ===== REVIEWS LIST ===== */
.reviews-list { min-height: 8px; }
.no-reviews {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 48px;
  text-align: center;
  color: #9CA3AF;
  border: 1.5px dashed #E5E7EB;
  border-radius: 16px;
  font-size: 14px;
}
.review-cards { display: flex; flex-direction: column; gap: 16px; }
.review-card {
  padding: 20px 24px;
  background: #fff;
  border: 1px solid #F3F4F6;
  border-radius: 14px;
  transition: all 0.2s ease;
}
.review-card:hover {
  border-color: #E5E7EB;
  box-shadow: 0 4px 16px rgba(0,0,0,0.06);
}
.reviewer-info { display: flex; align-items: center; gap: 12px; margin-bottom: 12px; }
.reviewer-avatar {
  width: 40px; height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #D4A853, #B8892A);
  color: #fff;
  font-size: 16px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  flex-shrink: 0;
}
.reviewer-avatar img { width: 100%; height: 100%; object-fit: cover; }
.reviewer-name { font-size: 14px; font-weight: 700; color: #111827; }
.review-date { font-size: 12px; color: #9CA3AF; margin-top: 2px; }
.review-body { overflow: hidden; }
.review-stars-row { display: flex; align-items: center; gap: 6px; margin-bottom: 8px; }
.review-variant {
  font-size: 11px;
  color: #6B7280;
  background: #F3F4F6;
  padding: 2px 10px;
  border-radius: 20px;
  margin-left: 4px;
}
.review-text { font-size: 14px; color: #374151; line-height: 1.6; margin: 0; }
.review-text.no-content { color: #9CA3AF; font-style: italic; }

/* Animations */
.review-item-enter-active { transition: all 0.4s ease; }
.review-item-enter-from { opacity: 0; transform: translateY(-12px); }

@media (max-width: 640px) {
  .rating-summary { flex-direction: column; gap: 20px; }
  .avg-score-box { border-right: none; border-bottom: 1px solid #E5E7EB; padding-right: 0; padding-bottom: 20px; }
}
</style>
