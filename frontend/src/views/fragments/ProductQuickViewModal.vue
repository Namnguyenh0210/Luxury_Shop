<template>
  <!-- Quick View Modal Overlay -->
  <Teleport to="body">
    <Transition name="modal-fade">
      <div
        v-if="isOpen"
        class="quickview-overlay"
        @click.self="closeModal"
        role="dialog"
        aria-modal="true"
        aria-label="Xem nhanh sản phẩm"
      >
        <Transition name="modal-slide">
          <div v-if="isOpen" class="quickview-modal">
            <!-- Close Button -->
            <button @click="closeModal" class="quickview-close" aria-label="Đóng">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
              </svg>
            </button>

            <!-- Loading State -->
            <div v-if="loading" class="quickview-loading">
              <div class="loading-spinner"></div>
              <p>Đang tải sản phẩm...</p>
            </div>

            <!-- Product Content -->
            <div v-else-if="product" class="quickview-content">
              <!-- LEFT: Images -->
              <div class="quickview-images">
                <!-- Main Image -->
                <div class="main-image-wrap">
                  <img
                    :src="currentImage"
                    :alt="product.tenSP"
                    class="main-image"
                    @error="handleImageError"
                  >
                  <!-- Discount Badge -->
                  <span v-if="hasPromotion" class="badge-discount">
                    -{{ discountPercent }}%
                  </span>
                  <!-- Out of Stock Badge -->
                  <span v-if="totalStock === 0" class="badge-outofstock">Hết hàng</span>
                </div>

                <!-- Thumbnail Strip -->
                <div v-if="allImages.length > 1" class="thumbnail-strip">
                  <button
                    v-for="(img, index) in allImages"
                    :key="index"
                    @click="currentImage = img"
                    :class="['thumb-btn', { active: currentImage === img }]"
                  >
                    <img :src="img" :alt="`Ảnh ${index + 1}`" @error="handleImageError">
                  </button>
                </div>
              </div>

              <!-- RIGHT: Product Info -->
              <div class="quickview-info">
                <!-- Brand -->
                <p class="product-brand">{{ product.thuongHieu?.tenTH || 'Thương hiệu' }}</p>

                <!-- Name -->
                <h2 class="product-name">{{ product.tenSP }}</h2>

                <!-- Stock Status -->
                <div class="stock-status" :class="totalStock > 0 ? 'in-stock' : 'out-stock'">
                  <span class="status-dot"></span>
                  <span>{{ totalStock > 0 ? `Còn hàng (${totalStock})` : 'Hết hàng' }}</span>
                </div>

                <!-- Price -->
                <div class="price-section">
                  <template v-if="hasPromotion">
                    <span class="price-original">{{ formatPrice(minPrice) }}</span>
                    <span class="price-sale">{{ formatPrice(finalPrice) }}</span>
                  </template>
                  <template v-else>
                    <span class="price-main">{{ formatPrice(minPrice || finalPrice) }}</span>
                  </template>
                </div>

                <div class="divider"></div>

                <!-- Size Selection -->
                <div v-if="availableSizes.length > 0" class="variant-group">
                  <div class="variant-label">
                    Kích thước: <strong>{{ selectedSize || '—' }}</strong>
                  </div>
                  <div class="variant-options">
                    <button
                      v-for="size in availableSizes"
                      :key="size"
                      @click="selectSize(size)"
                      :class="['size-btn', { 
                        active: selectedSize === size, 
                        'not-available': !isSizeAvailable(size)
                      }]"
                    >
                      {{ size }}
                    </button>
                  </div>
                </div>

                <!-- Color Selection -->
                <div v-if="availableColors.length > 0" class="variant-group">
                  <div class="variant-label">
                    Màu sắc: <strong>{{ selectedColor || '—' }}</strong>
                  </div>
                  <div class="variant-options">
                    <button
                      v-for="color in availableColors"
                      :key="color"
                      @click="selectColor(color)"
                      :class="['color-btn', { 
                        active: selectedColor === color,
                        'not-available': !isColorAvailable(color)
                      }]"
                    >
                      {{ color }}
                    </button>
                  </div>
                </div>

                <!-- Quantity -->
                <div class="quantity-group">
                  <div class="variant-label">Số lượng:</div>
                  <div class="qty-controls">
                    <button @click="decreaseQty" :disabled="quantity <= 1" class="qty-btn">−</button>
                    <span class="qty-display">{{ quantity }}</span>
                    <button @click="increaseQty" :disabled="quantity >= maxQty" class="qty-btn">+</button>
                  </div>
                </div>

                <div class="divider"></div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                  <button
                    @click="addToCart"
                    :disabled="totalStock === 0 || addingToCart"
                    class="btn-add-cart"
                  >
                    <span v-if="addingToCart" class="btn-spinner"></span>
                    <svg v-else xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle>
                      <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                    </svg>
                    {{ totalStock === 0 ? 'Hết hàng' : (addingToCart ? 'Đang thêm...' : 'THÊM VÀO GIỎ') }}
                  </button>

                  <a :href="`/sanpham/${product.maSP}`" class="btn-view-detail">
                    Xem chi tiết sản phẩm →
                  </a>
                </div>

                <!-- Toast Notification -->
                <Transition name="toast-anim">
                  <div v-if="toastMessage" :class="['toast-notify', toastType]">
                    {{ toastMessage }}
                  </div>
                </Transition>
              </div>
            </div>

            <!-- Error State -->
            <div v-else class="quickview-error">
              <span style="font-size:40px">😔</span>
              <p>Không thể tải thông tin sản phẩm</p>
              <button @click="closeModal" class="btn-close-err">Đóng</button>
            </div>
          </div>
        </Transition>
      </div>
    </Transition>
  </Teleport>
</template>

<script>
import axios from 'axios'

export default {
  name: 'ProductQuickViewModal',
  props: {
    productId: { type: Number, default: null },
    isOpen: { type: Boolean, default: false }
  },
  emits: ['close', 'cart-updated'],
  data() {
    return {
      loading: false,
      product: null,
      variants: [],
      minPrice: null,
      maxPrice: null,
      finalPrice: null,
      totalStock: 0,
      hasPromotion: false,
      discountPercent: 0,
      currentImage: '',
      selectedSize: null,
      selectedColor: null,
      quantity: 1,
      addingToCart: false,
      toastMessage: null,
      toastType: 'success',
      toastTimer: null
    }
  },
  computed: {
    allImages() {
      if (!this.product) return []
      const imgs = []
      if (this.product.anhChinh) imgs.push(this.product.anhChinh)
      if (this.product.anhPhu1) imgs.push(this.product.anhPhu1)
      if (this.product.anhPhu2) imgs.push(this.product.anhPhu2)
      if (this.product.anhPhu3) imgs.push(this.product.anhPhu3)
      return imgs.length > 0 ? imgs : ['/img/placeholder.png']
    },
    availableSizes() {
      if (!this.variants) return []
      const sizes = [...new Set(this.variants.filter(v => v.sizeSP && v.sizeSP.tenSize).map(v => v.sizeSP.tenSize))]
      const sizeOrder = ['S', 'M', 'L', 'XL', 'XXL', '2XL', '3XL']
      return sizes.sort((a, b) => {
        const idxA = sizeOrder.indexOf(a.toUpperCase())
        const idxB = sizeOrder.indexOf(b.toUpperCase())
        if (idxA === -1 && idxB === -1) return a.localeCompare(b)
        if (idxA === -1) return 1
        if (idxB === -1) return -1
        return idxA - idxB
      })
    },
    availableColors() {
      if (!this.variants) return []
      return [...new Set(this.variants.filter(v => v.mauSacSP && v.mauSacSP.tenMau).map(v => v.mauSacSP.tenMau))]
    },
    selectedVariant() {
      if (!this.selectedSize || !this.selectedColor) return null
      return this.variants.find(v =>
        v.sizeSP?.tenSize === this.selectedSize &&
        v.mauSacSP?.tenMau === this.selectedColor &&
        v.soLuongTon > 0 && v.trangThai !== false
      )
    },
    maxQty() {
      return this.selectedVariant?.soLuongTon || this.totalStock || 99
    }
  },
  watch: {
    isOpen(val) {
      if (val && this.productId) {
        this.fetchProduct()
        document.body.style.overflow = 'hidden'
      } else {
        document.body.style.overflow = ''
        this.reset()
      }
    },
    productId(val) {
      if (val && this.isOpen) {
        this.fetchProduct()
      }
    }
  },
  methods: {
    async fetchProduct() {
      this.loading = true
      this.product = null
      try {
        const res = await axios.get(`/sanpham/${this.productId}`)
        if (res.data.success) {
          this.product = res.data.product
          this.variants = res.data.variants || []
          this.minPrice = res.data.minPrice
          this.maxPrice = res.data.maxPrice
          this.totalStock = res.data.totalStock || 0
          this.currentImage = this.allImages[0]

          // Force user to choose
          this.selectedSize = null
          this.selectedColor = null

          // Check promotion from priceStockMap if available
          const listRes = await axios.get(`/sanpham`, { params: { page: 0, size: 1 } })
          if (listRes.data?.priceStockMap?.[this.productId]) {
            const ps = listRes.data.priceStockMap[this.productId]
            this.hasPromotion = ps.hasPromotion || false
            this.discountPercent = Math.round(ps.discountPercent || 0)
            this.finalPrice = ps.finalPrice || this.minPrice
          } else {
            this.finalPrice = this.minPrice
          }
        }
      } catch (err) {
        console.error('QuickView error:', err)
      } finally {
        this.loading = false
      }
    },

    isSizeAvailable(size) {
      if (!this.selectedColor) {
        // Nếu chưa chọn màu, xem size này có màu nào còn hàng không
        return this.variants.some(v => v.sizeSP?.tenSize === size && v.soLuongTon > 0 && v.trangThai !== false)
      }
      return this.variants.some(v => 
        v.sizeSP?.tenSize === size && 
        v.mauSacSP?.tenMau === this.selectedColor && 
        v.soLuongTon > 0 && v.trangThai !== false
      )
    },
    isColorAvailable(color) {
      if (!this.selectedSize) {
        // Nếu chưa chọn size, xem màu này có size nào còn hàng không
        return this.variants.some(v => v.mauSacSP?.tenMau === color && v.soLuongTon > 0 && v.trangThai !== false)
      }
      return this.variants.some(v => 
        v.mauSacSP?.tenMau === color && 
        v.sizeSP?.tenSize === this.selectedSize && 
        v.soLuongTon > 0 && v.trangThai !== false
      )
    },
    selectSize(size) {
      if (this.selectedSize === size) this.selectedSize = null
      else this.selectedSize = size
    },
    selectColor(color) {
      if (this.selectedColor === color) this.selectedColor = null
      else this.selectedColor = color
    },

    async addToCart() {
      if (this.totalStock === 0) return
      
      // 1. Kiểm tra lựa chọn đầy đủ
      if (!this.selectedSize || !this.selectedColor) {
        this.showToast('Vui lòng chọn Size và Màu sắc!', 'error')
        return
      }

      const variant = this.selectedVariant
      if (!variant) {
        this.showToast('Phiên bản này hiện đang hết hàng.', 'error')
        return
      }

      this.addingToCart = true
      try {
        const params = { 
          productId: this.product.maSP, 
          quantity: this.quantity,
          variantId: variant.maBienThe
        }

        const res = await axios.post('/cart/add-product', null, { params })
        if (res.data.success) {
          this.showToast('Đã thêm vào giỏ hàng thành công!', 'success')
          this.$emit('cart-updated')
          if (window.refreshCartCount) window.refreshCartCount()
        } else {
          this.showToast(res.data.message || 'Không thể thêm sản phẩm', 'error')
        }
      } catch (err) {
        if (err.response?.status === 401) {
          this.showToast('Vui lòng đăng nhập để trải nghiệm mua hàng!', 'error')
        } else {
          this.showToast('Có lỗi xảy ra, vui lòng thử lại', 'error')
        }
      } finally {
        this.addingToCart = false
      }
    },

    showToast(msg, type = 'success') {
      clearTimeout(this.toastTimer)
      this.toastMessage = msg
      this.toastType = type
      this.toastTimer = setTimeout(() => { this.toastMessage = null }, 3000)
    },

    closeModal() {
      this.$emit('close')
    },

    decreaseQty() {
      if (this.quantity > 1) this.quantity--
    },

    increaseQty() {
      if (this.quantity < this.maxQty) this.quantity++
    },

    handleImageError(e) {
      e.target.src = '/img/placeholder.png'
    },

    formatPrice(price) {
      if (!price) return 'Liên hệ'
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price)
    },

    reset() {
      this.product = null
      this.variants = []
      this.selectedSize = null
      this.selectedColor = null
      this.quantity = 1
      this.toastMessage = null
    }
  },
  mounted() {
    const handler = (e) => { if (e.key === 'Escape') this.closeModal() }
    document.addEventListener('keydown', handler)
    this.$once?.('hook:unmounted', () => document.removeEventListener('keydown', handler))
  }
}
</script>

<style scoped>
/* =========================================
   QUICKVIEW MODAL — LUXURY DESIGN
   ========================================= */
.quickview-overlay {
  position: fixed;
  inset: 0;
  z-index: 9999;
  background: rgba(10, 10, 20, 0.65);
  backdrop-filter: blur(6px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
  overflow-y: auto;
}

.quickview-modal {
  position: relative;
  background: #FFFFFF;
  border-radius: 20px;
  width: 100%;
  max-width: 900px;
  max-height: 90vh;
  overflow: hidden;
  box-shadow: 0 32px 80px rgba(0, 0, 0, 0.35), 0 0 0 1px rgba(255,255,255,0.1);
  display: flex;
  flex-direction: column;
}

/* --- Close Button --- */
.quickview-close {
  position: absolute;
  top: 16px;
  right: 16px;
  z-index: 10;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: 1.5px solid #E5E7EB;
  background: #fff;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #374151;
  transition: all 0.2s ease;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}
.quickview-close:hover {
  background: #1a1a2e;
  color: #fff;
  border-color: #1a1a2e;
  transform: rotate(90deg);
}

/* --- Loading --- */
.quickview-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px;
  gap: 16px;
  color: #6B7280;
  min-height: 300px;
}
.loading-spinner {
  width: 44px;
  height: 44px;
  border: 3px solid #F3F4F6;
  border-top-color: #1a1a2e;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* --- Content Layout --- */
.quickview-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  overflow: hidden;
  max-height: 90vh;
}

/* --- Left: Images --- */
.quickview-images {
  background: #F8F9FA;
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  overflow: hidden;
}
.main-image-wrap {
  position: relative;
  aspect-ratio: 4/5;
  border-radius: 12px;
  overflow: hidden;
  background: #EFEFEF;
}
.main-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s ease;
}
.main-image-wrap:hover .main-image {
  transform: scale(1.04);
}
.badge-discount {
  position: absolute;
  top: 10px;
  right: 10px;
  background: #C8A97E;
  color: #fff;
  font-size: 11px;
  font-weight: 800;
  padding: 4px 10px;
  border-radius: 20px;
  letter-spacing: 0.3px;
}
.badge-outofstock {
  position: absolute;
  top: 10px;
  left: 10px;
  background: #1F2937;
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  padding: 4px 10px;
  border-radius: 20px;
}
.thumbnail-strip {
  display: flex;
  gap: 8px;
  overflow-x: auto;
  padding-bottom: 4px;
}
.thumb-btn {
  flex-shrink: 0;
  width: 60px;
  height: 60px;
  border-radius: 8px;
  overflow: hidden;
  border: 2px solid transparent;
  cursor: pointer;
  padding: 0;
  background: none;
  transition: all 0.2s;
}
.thumb-btn.active { border-color: #1a1a2e; }
.thumb-btn:hover { border-color: #6B7280; }
.thumb-btn img { width: 100%; height: 100%; object-fit: cover; }

/* --- Right: Info --- */
.quickview-info {
  padding: 32px;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 0;
}
.product-brand {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 2px;
  text-transform: uppercase;
  color: #9CA3AF;
  margin: 0 0 8px;
}
.product-name {
  font-size: 20px;
  font-weight: 800;
  color: #111827;
  margin: 0 0 12px;
  font-family: 'Times New Roman', Times, serif;
  line-height: 1.3;
}

/* Stock Status */
.stock-status {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  font-weight: 600;
  padding: 4px 12px;
  border-radius: 20px;
  margin-bottom: 16px;
  width: fit-content;
}
.stock-status.in-stock { background: #ECFDF5; color: #065F46; }
.stock-status.out-stock { background: #FEF2F2; color: #991B1B; }
.status-dot {
  width: 7px; height: 7px;
  border-radius: 50%;
  background: currentColor;
}

/* Price */
.price-section {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 20px;
}
.price-original {
  font-size: 14px;
  color: #9CA3AF;
  text-decoration: line-through;
}
.price-sale {
  font-size: 24px;
  font-weight: 900;
  color: #C8A97E;
}
.price-main {
  font-size: 24px;
  font-weight: 900;
  color: #111827;
}

/* Divider */
.divider {
  height: 1px;
  background: linear-gradient(to right, #F3F4F6, #E5E7EB, #F3F4F6);
  margin: 16px 0;
}

/* Variants */
.variant-group { margin-bottom: 16px; }
.variant-label {
  font-size: 13px;
  color: #6B7280;
  margin-bottom: 10px;
}
.variant-label strong { color: #111827; }
.variant-options { display: flex; flex-wrap: wrap; gap: 8px; }

.size-btn {
  min-width: 44px;
  height: 36px;
  padding: 0 12px;
  border: 1.5px solid #D1D5DB;
  border-radius: 8px;
  background: #fff;
  font-size: 13px;
  font-weight: 600;
  color: #374151;
  cursor: pointer;
  transition: all 0.18s ease;
  position: relative;
}
.size-btn:hover { border-color: #1a1a2e; color: #1a1a2e; }
.size-btn.active {
  border-color: #C8A97E;
  background: #C8A97E;
  color: #fff;
}
.size-btn.not-available,
.color-btn.not-available {
  opacity: 0.25;
  font-style: italic;
  filter: grayscale(1);
  cursor: not-allowed;
}

.color-btn {
  padding: 6px 16px;
  border: 1.5px solid #D1D5DB;
  border-radius: 8px;
  background: #fff;
  font-size: 13px;
  font-weight: 500;
  color: #374151;
  cursor: pointer;
  transition: all 0.18s ease;
}
.color-btn:hover { border-color: #1a1a2e; }
.color-btn.active {
  border-color: #C8A97E;
  background: #FDFCFB;
  color: #C8A97E;
  font-weight: 700;
  box-shadow: inset 0 0 0 1px #C8A97E;
}

/* Quantity */
.quantity-group { margin-bottom: 4px; }
.qty-controls {
  display: flex;
  align-items: center;
  gap: 0;
  border: 1.5px solid #D1D5DB;
  border-radius: 10px;
  width: fit-content;
  overflow: hidden;
}
.qty-btn {
  width: 38px;
  height: 38px;
  border: none;
  background: #F9FAFB;
  font-size: 18px;
  font-weight: 400;
  color: #374151;
  cursor: pointer;
  transition: background 0.15s;
  display: flex;
  align-items: center;
  justify-content: center;
}
.qty-btn:hover:not(:disabled) { background: #F3F4F6; }
.qty-btn:disabled { opacity: 0.35; cursor: not-allowed; }
.qty-display {
  min-width: 44px;
  text-align: center;
  font-size: 15px;
  font-weight: 700;
  color: #111827;
  border-left: 1px solid #E5E7EB;
  border-right: 1px solid #E5E7EB;
  height: 38px;
  line-height: 38px;
}

/* Action Buttons */
.action-buttons {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-top: 4px;
}
.btn-add-cart {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  width: 100%;
  height: 50px;
  border: none;
  border-radius: 12px;
  background: linear-gradient(135deg, #111111, #333333);
  color: #fff;
  font-size: 14px;
  font-weight: 800;
  letter-spacing: 1.5px;
  cursor: pointer;
  transition: all 0.25s ease;
  box-shadow: 0 4px 16px rgba(220, 38, 38, 0.35);
}
.btn-add-cart:hover:not(:disabled) {
  transform: translateY(-2px);
  background: #C8A97E;
  box-shadow: 0 8px 24px rgba(200, 169, 126, 0.4);
}
.btn-add-cart:disabled {
  background: #9CA3AF;
  box-shadow: none;
  cursor: not-allowed;
  transform: none;
}
.btn-spinner {
  width: 18px; height: 18px;
  border: 2px solid rgba(255,255,255,0.4);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}
.btn-view-detail {
  text-align: center;
  font-size: 13px;
  color: #6B7280;
  text-decoration: none;
  padding: 8px;
  border-radius: 8px;
  transition: color 0.15s;
}
.btn-view-detail:hover { color: #111827; text-decoration: underline; }

/* Toast Notification */
.toast-notify {
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  padding: 12px 24px;
  border-radius: 50px;
  font-size: 15px;
  font-weight: 700;
  white-space: nowrap;
  box-shadow: 0 4px 20px rgba(0,0,0,0.15);
  z-index: 10;
}
.toast-notify.success { background: #065F46; color: #ECFDF5; }
.toast-notify.error { background: #991B1B; color: #FEF2F2; }

/* Error State */
.quickview-error {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px;
  gap: 16px;
  color: #6B7280;
  min-height: 300px;
}
.btn-close-err {
  padding: 10px 28px;
  border: 1.5px solid #D1D5DB;
  border-radius: 8px;
  background: none;
  cursor: pointer;
  font-size: 14px;
  font-weight: 600;
}

/* === ANIMATIONS === */
.modal-fade-enter-active,
.modal-fade-leave-active {
  transition: opacity 0.3s ease;
}
.modal-fade-enter-from,
.modal-fade-leave-to {
  opacity: 0;
}

.modal-slide-enter-active {
  transition: all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.modal-slide-leave-active {
  transition: all 0.25s ease;
}
.modal-slide-enter-from {
  opacity: 0;
  transform: scale(0.9) translateY(20px);
}
.modal-slide-leave-to {
  opacity: 0;
  transform: scale(0.95) translateY(10px);
}

.toast-anim-enter-active { transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1); }
.toast-anim-leave-active { transition: all 0.2s ease; }
.toast-anim-enter-from { opacity: 0; transform: translateX(-50%) translateY(10px); }
.toast-anim-leave-to { opacity: 0; transform: translateX(-50%) translateY(6px); }

/* Responsive */
@media (max-width: 680px) {
  .quickview-content { grid-template-columns: 1fr; }
  .quickview-images { max-height: 300px; }
  .quickview-info { padding: 20px; }
}
</style>
