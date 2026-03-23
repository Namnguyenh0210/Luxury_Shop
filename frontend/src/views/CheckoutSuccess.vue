<template>
  <div class="min-h-screen bg-[#FDFCFB] flex flex-col font-sans">

    <!-- Header -->
    <header class="sticky top-0 z-10 bg-white border-b border-[#E5E7EB] px-6 py-4 print:hidden">
      <div class="max-w-4xl mx-auto flex items-center justify-between">
        <router-link to="/" class="flex items-center gap-2 text-[#111111] hover:text-[#C8A97E] transition-colors">
          <span class="material-symbols-outlined text-xl">arrow_back</span>
          <span class="text-sm font-bold uppercase tracking-widest">Trang chủ</span>
        </router-link>
        <router-link to="/sanpham" class="text-sm font-bold text-[#C8A97E] hover:text-[#111111] uppercase tracking-widest transition-colors">
          Tiếp tục mua sắm
        </router-link>
      </div>
    </header>

    <!-- Main Content -->
    <main class="flex-1 flex items-center justify-center py-10 px-4 print:py-0 print:px-0">
      <div class="w-full max-w-2xl">

        <!-- Loading -->
        <div v-if="loading" class="flex flex-col items-center justify-center py-24 print:hidden">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-[#C8A97E] mb-4"></div>
          <p class="text-[#C8A97E] text-sm tracking-widest uppercase font-bold">Đang tải hóa đơn...</p>
        </div>

        <template v-else-if="donHang">
          <!-- Success Message (Hide on print) -->
          <div class="flex flex-col items-center text-center mb-8 print:hidden">
            <div class="mb-5 flex h-16 w-16 items-center justify-center rounded-full bg-green-50 border border-green-100 text-green-600 shadow-sm">
              <span class="material-symbols-outlined text-3xl">done_all</span>
            </div>
            <h1 class="font-serif text-3xl md:text-4xl font-bold tracking-tight text-[#111111] uppercase mb-2">
              Cảm ơn bạn đã đặt hàng
            </h1>
            <p class="max-w-md text-sm text-gray-500 leading-relaxed">
              Kiệt tác của bạn đang được chúng tôi chuẩn bị. Dưới đây là biên lai xác nhận đơn hàng của bạn.
            </p>
          </div>

          <!-- INVOICE CARD -->
          <div class="bg-white border border-[#E5E7EB] shadow-xl rounded-2xl overflow-hidden print:shadow-none print:border-none print:rounded-none">
            
            <!-- Invoice Header -->
            <div class="p-8 md:p-10 border-b border-[#F5F1ED] bg-[#111111] text-white flex flex-col md:flex-row justify-between items-start md:items-center">
              <div>
                <p class="text-[10px] font-bold uppercase tracking-[0.4em] text-[#C8A97E] mb-2">Luxury Experience</p>
                <h2 class="font-serif text-2xl font-bold tracking-tight uppercase">Biên lai mua hàng</h2>
              </div>
              <div class="mt-4 md:mt-0 text-left md:text-right">
                <p class="text-sm font-bold text-white uppercase tracking-wider">Mã đơn: #{{ donHang.maDH }}</p>
                <p class="text-[11px] text-gray-400 mt-1 uppercase tracking-widest">{{ formatDate(donHang.ngayDat) }}</p>
              </div>
            </div>

            <!-- Customer & Shipping Info -->
            <div class="grid grid-cols-1 md:grid-cols-2 divide-y md:divide-y-0 md:divide-x divide-[#E5E7EB] border-b border-[#F5F1ED] bg-[#FDFCFB]">
              <div class="p-8 md:p-10">
                <p class="text-[10px] font-bold uppercase tracking-[0.2em] text-gray-400 mb-4">Thông tin khách hàng</p>
                <div class="space-y-1">
                  <p class="text-sm font-bold text-[#111111] uppercase">{{ donHang.taiKhoan?.hoTen || 'Khách vãng lai' }}</p>
                  <p class="text-sm text-gray-600">{{ donHang.taiKhoan?.email || 'N/A' }}</p>
                  <p class="text-sm text-gray-600">{{ donHang.taiKhoan?.soDienThoai || 'N/A' }}</p>
                </div>
              </div>
              <div class="p-8 md:p-10">
                <p class="text-[10px] font-bold uppercase tracking-[0.2em] text-gray-400 mb-4">Giao hàng đến</p>
                <div class="space-y-1">
                  <p class="text-sm font-bold text-[#111111] uppercase">{{ donHang.hoTenNguoiNhan || donHang.taiKhoan?.hoTen }}</p>
                  <p class="text-sm text-gray-600">{{ donHang.sdtNguoiNhan || donHang.taiKhoan?.soDienThoai }}</p>
                  <p class="text-sm text-gray-600 leading-relaxed">{{ donHang.diaChiGiao?.diaChiChiTiet || donHang.diaChiGiaoHang || 'N/A' }}</p>
                </div>
              </div>
            </div>

            <!-- Products List -->
            <div class="p-8 md:p-10">
              <p class="text-[10px] font-bold uppercase tracking-[0.2em] text-[#C8A97E] mb-6">Chi tiết kiệt tác</p>
              
              <div class="space-y-6">
                <div v-for="item in chiTiet" :key="item.id || item.maCT" class="flex gap-4 items-start border-b border-[#F5F1ED] pb-6 last:border-0 last:pb-0">
                  <div class="relative w-20 h-24 flex-shrink-0 bg-[#F5F1ED] overflow-hidden rounded-xl border border-[#E5E7EB]">
                    <img
                      class="absolute inset-0 w-full h-full object-cover"
                      :src="getImgUrl(item)"
                      @error="e => e.target.src='/img/placeholder.png'"
                      alt="Product"
                    />
                  </div>
                  <div class="flex-1 min-w-0">
                    <p class="text-[10px] font-bold text-[#C8A97E] uppercase tracking-widest">{{ getBrand(item) }}</p>
                    <h3 class="text-xs font-bold text-[#111111] mt-1 uppercase leading-snug">{{ getProductName(item) }}</h3>
                    <div class="flex flex-wrap gap-2 mt-2">
                      <span v-if="getSize(item)" class="text-[10px] text-gray-500 font-bold px-2 py-0.5 border border-[#E5E7EB] bg-white">{{ getSize(item) }}</span>
                      <span v-if="getColor(item)" class="text-[10px] text-gray-500 font-bold px-2 py-0.5 border border-[#E5E7EB] bg-white">{{ getColor(item) }}</span>
                    </div>
                  </div>
                  <div class="text-right flex-shrink-0 ml-4">
                    <p class="text-sm font-bold text-[#111111]">{{ fmtCurrency(item.donGia || item.giaBan) }}</p>
                    <p class="text-[11px] text-gray-500 mt-1 uppercase font-semibold">SL: {{ item.soLuong }}</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Summary Totals -->
            <div class="bg-[#F9F7F5] p-8 md:p-10 border-t border-[#E5E7EB]">
              <div class="w-full md:w-3/5 ml-auto">
                <table class="w-full text-sm">
                  <tbody>
                    <tr>
                      <td class="py-2.5 text-gray-500 font-semibold text-xs uppercase tracking-widest align-top">Tạm tính</td>
                      <td class="py-2.5 font-bold text-[#111111] text-right align-top">{{ fmtCurrency(subTotal) }}</td>
                    </tr>
                    <tr v-if="discountAmount > 0">
                      <td class="py-2.5 text-gray-500 font-semibold text-xs uppercase tracking-widest align-top">Giảm giá</td>
                      <td class="py-2.5 font-bold text-green-600 text-right align-top">-{{ fmtCurrency(discountAmount) }}</td>
                    </tr>
                    <tr>
                      <td class="py-2.5 text-gray-500 font-semibold text-xs uppercase tracking-widest align-top">Vận chuyển</td>
                      <td class="py-2.5 font-bold text-green-600 uppercase tracking-widest text-[10px] text-right align-top">Miễn phí</td>
                    </tr>
                    <tr>
                      <td class="py-2.5 text-gray-500 font-semibold text-xs uppercase tracking-widest align-top pr-4">Thanh toán</td>
                      <td class="py-2.5 font-bold text-[#111111] uppercase whitespace-normal text-right align-top text-xs">{{ donHang.hinhThucThanhToan?.tenPhuongThuc || 'COD' }}</td>
                    </tr>
                    <tr>
                      <td colspan="2" class="pt-4 border-b border-[#E5E7EB]"></td>
                    </tr>
                    <tr>
                      <td class="pt-5 text-sm font-bold text-[#111111] uppercase tracking-widest align-bottom">Tổng cộng</td>
                      <td class="pt-5 text-2xl font-bold text-[#C8A97E] text-right align-bottom">{{ fmtCurrency(donHang.tongTien) }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <div v-if="donHang.ghiChu" class="bg-yellow-50 p-6 md:px-10 border-t border-yellow-100 flex items-start gap-3">
               <span class="material-symbols-outlined text-[#C8A97E] text-lg">edit_note</span>
               <div>
                 <p class="text-[10px] font-bold text-[#C8A97E] uppercase tracking-widest mb-1">Ghi chú của bạn</p>
                 <p class="text-sm text-yellow-900 italic">"{{ donHang.ghiChu }}"</p>
               </div>
            </div>

          </div>

          <!-- Action Buttons -->
          <div class="mt-8 flex flex-wrap gap-4 justify-center print:hidden">
            <button @click="printInvoice"
              class="flex items-center justify-center gap-2 px-6 py-3.5 rounded-full border border-[#111111] text-[#111111] text-[11px] font-bold uppercase tracking-[0.2em] hover:bg-[#111111] hover:text-white transition-all">
              <span class="material-symbols-outlined text-sm">print</span>
              In hóa đơn
            </button>
            <router-link to="/profile#orders"
              class="flex items-center justify-center gap-2 px-6 py-3.5 rounded-full bg-[#111111] text-white text-[11px] font-bold uppercase tracking-[0.2em] hover:bg-[#C8A97E] transition-all shadow-md">
              <span class="material-symbols-outlined text-sm">receipt_long</span>
              Xem đơn hàng
            </router-link>
          </div>
        </template>

        <!-- Fallback -->
        <div v-else class="text-center py-24 text-gray-400 bg-white border border-[#E5E7EB] rounded-2xl shadow-sm print:hidden">
          <span class="material-symbols-outlined text-5xl mb-3 text-gray-300">search_off</span>
          <p class="text-sm uppercase tracking-widest font-bold">Không tìm thấy thông tin đơn hàng</p>
          <router-link to="/" class="mt-6 inline-block px-6 py-3 bg-[#111111] text-white text-[11px] font-bold uppercase tracking-[0.2em] rounded-full hover:bg-[#C8A97E] transition-colors">Về trang chủ</router-link>
        </div>

      </div>
    </main>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'CheckoutSuccess',

  data() {
    return {
      loading: true,
      donHang: null,
      chiTiet: []
    }
  },

  computed: {
    subTotal() {
      if (!this.chiTiet.length) return 0;
      return this.chiTiet.reduce((acc, item) => acc + (item.donGia || item.giaBan) * item.soLuong, 0);
    },
    discountAmount() {
      if (!this.donHang || !this.donHang.tongTien) return 0;
      // Nếu có phí vận chuyển, công thức tính giảm giá sẽ phải trừ đi, hiện tại free ship
      let giamGia = this.subTotal - this.donHang.tongTien;
      return giamGia > 0 ? giamGia : 0;
    }
  },

  async mounted() {
    const orderId = this.$route.query.orderId || this.$route.params.id
    if (!orderId) { this.loading = false; return }
    try {
      const res = await axios.get(`/orders/${orderId}`, { withCredentials: true })
      this.donHang = res.data.donHang || res.data
      this.chiTiet = res.data.chiTiet || this.donHang?.chiTiet || this.donHang?.chiTietList || []
    } catch (e) {
      console.error(e)
    } finally {
      this.loading = false
    }
  },

  methods: {
    fmtCurrency(v) {
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(v || 0)
    },
    formatDate(d) {
      if (!d) return '---'
      return new Date(d).toLocaleString('vi-VN', { 
        year: 'numeric', month: '2-digit', day: '2-digit',
        hour: '2-digit', minute: '2-digit'
      })
    },
    printInvoice() {
      window.print();
    },
    getImgUrl(item) {
      const spct = item.sanPhamChiTiet;
      const sp = spct?.sanPham;
      
      let url = sp?.anhChinh || spct?.anhBienThe || item.anh;
      
      if (!url) return '/img/placeholder.png';
      
      if (url.includes('media.gucci.com') && sp?.anhChinh) {
        url = sp.anhChinh;
      }
      
      if (url.startsWith('http')) return url;
      return `/api/img/${url}`;
    },
    getBrand(item) {
      return item.sanPhamChiTiet?.sanPham?.thuongHieu?.tenTH || item.thuongHieu || 'Luxury Brand';
    },
    getProductName(item) {
      return item.sanPhamChiTiet?.sanPham?.tenSP || item.tenSP || 'Sản phẩm cao cấp';
    },
    getSize(item) {
      return item.sanPhamChiTiet?.sizeSP?.tenSize || item.size;
    },
    getColor(item) {
      return item.sanPhamChiTiet?.mauSacSP?.tenMau || item.mau;
    }
  }
}
</script>

<style scoped>
@media print {
  @page { margin: 0; }
  body { 
    background-color: white !important; 
    -webkit-print-color-adjust: exact; 
    print-color-adjust: exact;
  }
}
</style>
