<template>
  
    <div class="p-8 space-y-8 bg-[#FDFCFB] min-h-screen">
      
      <!-- Top Action Bar -->
      <div class="flex justify-between items-center bg-white p-4 rounded-2xl shadow-sm border border-[#E5E7EB]">
        <router-link to="/admin/orders" class="flex items-center gap-2 text-[11px] font-bold uppercase tracking-widest text-gray-500 hover:text-[#C8A97E] transition-all">
          <span class="material-symbols-outlined text-[18px]">arrow_back</span>
          Danh sách đơn hàng
        </router-link>
        
        <div v-if="order" class="flex items-center gap-4">
          <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Trạng thái xử lý:</span>
          <div class="flex gap-2">
            <div class="px-6 py-2 rounded-full text-[11px] font-black uppercase tracking-widest shadow-sm border" :class="statusClass(order.trangThaiDH).class">
              {{ statusClass(order.trangThaiDH).text }}
            </div>
            <div class="px-6 py-2 rounded-full text-[11px] font-black uppercase tracking-widest shadow-sm border" :class="payStatusClass(order.trangThaiThanhToan).class">
              {{ payStatusClass(order.trangThaiThanhToan).text }}
            </div>
          </div>
        </div>
      </div>

      <div v-if="loading" class="flex flex-col items-center justify-center py-32 text-[#C8A97E]">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-[#C8A97E] mb-6"></div>
        <p class="text-[11px] font-bold uppercase tracking-[0.3em]">Đang truy xuất kiệt tác...</p>
      </div>

      <div v-else-if="order" class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        <!-- Left Column: Products & Actions -->
        <div class="lg:col-span-2 space-y-8">
          
          <!-- Product Card -->
          <div class="bg-white rounded-3xl border border-[#E5E7EB] shadow-xl overflow-hidden">
            <div class="p-8 border-b border-[#F5F1ED] bg-[#111111] text-white flex justify-between items-center">
              <div>
                <p class="text-[10px] font-bold uppercase tracking-[0.4em] text-[#C8A97E] mb-1">Luxury Experience</p>
                <h3 class="font-serif text-xl font-bold tracking-tight uppercase flex items-center gap-3">
                  Đơn hàng #{{ order.maDH }}
                </h3>
              </div>
              <div class="text-right">
                <p class="text-[10px] font-medium text-gray-400 uppercase tracking-widest">{{ formatDate(order.ngayDat) }}</p>
              </div>
            </div>
            
            <div class="p-8">
              <p class="text-[10px] font-bold uppercase tracking-[0.2em] text-[#C8A97E] mb-8">Danh sách kiệt tác ({{ orderItems.length }})</p>
              
              <div class="space-y-8">
                <div v-for="item in orderItems" :key="item.maCT" class="flex gap-6 items-start border-b border-[#F5F1ED] pb-8 last:border-0 last:pb-0">
                  <div class="relative w-24 h-32 flex-shrink-0 bg-[#F5F1ED] overflow-hidden rounded-2xl border border-[#E5E7EB]">
                    <img
                      class="absolute inset-0 w-full h-full object-cover transform hover:scale-110 transition-transform duration-500"
                      :src="getImgUrl(item)"
                      @error="e => e.target.src='/img/placeholder.png'"
                    />
                  </div>
                  
                  <div class="flex-1 min-w-0">
                    <p class="text-[10px] font-bold text-[#C8A97E] uppercase tracking-widest mb-1">{{ getBrand(item) }}</p>
                    <h4 class="font-serif text-lg font-bold text-[#111111] uppercase leading-tight hover:text-[#C8A97E] transition-colors cursor-pointer">
                      {{ getProductName(item) }}
                    </h4>
                    <div class="flex flex-wrap gap-2 mt-4">
                      <span v-if="getSize(item)" class="text-[10px] text-gray-500 font-bold px-3 py-1 border border-[#E5E7EB] bg-white rounded-md tracking-widest">{{ getSize(item) }}</span>
                      <span v-if="getColor(item)" class="text-[10px] text-gray-500 font-bold px-3 py-1 border border-[#E5E7EB] bg-white rounded-md tracking-widest">{{ getColor(item) }}</span>
                    </div>
                  </div>

                  <div class="text-right flex-shrink-0">
                    <p class="text-lg font-bold text-[#111111] tracking-tight">{{ fmtCurrency(item.donGia) }}</p>
                    <p class="text-[11px] text-gray-400 mt-1 uppercase font-black">Số lượng: {{ item.soLuong }}</p>
                    <p class="text-[12px] font-bold text-[#C8A97E] mt-2">{{ fmtCurrency(item.donGia * item.soLuong) }}</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Totals Summary -->
            <div class="bg-[#F9F7F5] p-8 mt-4 border-t border-[#E5E7EB]">
              <div class="w-full md:w-3/5 ml-auto space-y-3">
                <div class="flex justify-between text-[11px] font-bold uppercase tracking-widest text-gray-500">
                  <span>Tạm tính</span>
                  <span class="text-[#111111]">{{ fmtCurrency(subTotal) }}</span>
                </div>
                <div v-if="order.giamGia > 0" class="flex justify-between text-[11px] font-bold uppercase tracking-widest text-green-600">
                  <span>Ưu đãi Voucher</span>
                  <span>-{{ fmtCurrency(order.giamGia) }}</span>
                </div>
                <div class="flex justify-between text-[11px] font-bold uppercase tracking-widest text-gray-500">
                  <span>Phí vận chuyển</span>
                  <span v-if="order.phiShip > 0" class="text-[#111111]">{{ fmtCurrency(order.phiShip) }}</span>
                  <span v-else class="text-green-600">Miễn phí</span>
                </div>
                <div class="pt-4 border-t border-[#E5E7EB] flex justify-between items-baseline">
                  <span class="text-xs font-black uppercase tracking-[0.2em] text-[#111111]">Tổng cộng</span>
                  <span class="text-3xl font-bold text-[#C8A97E] tracking-tighter">{{ fmtCurrency(order.tongTien) }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Status Update Actions -->
          <div class="bg-white rounded-3xl border border-[#E5E7EB] shadow-lg p-8">
            <h4 class="text-[10px] font-bold text-gray-400 uppercase tracking-[0.3em] mb-8 flex items-center gap-3">
              <span class="h-px w-8 bg-gray-200"></span>
              Điều phối đơn hàng
              <span class="h-px flex-1 bg-gray-200"></span>
            </h4>

            <div v-if="order.khachBaoChuaNhan" class="mb-8 p-6 border border-red-200 rounded-2xl bg-red-50/50">
              <h3 class="text-red-700 font-bold text-sm mb-4 flex items-center gap-3 uppercase tracking-wider">
                <span class="material-symbols-outlined text-xl">warning</span>
                Khách báo chưa nhận hàng!
              </h3>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                <div class="text-[11px]"><strong class="uppercase tracking-widest text-red-800">Lý do:</strong> <span class="italic text-gray-700">"{{ order.lyDoChuaNhan }}"</span></div>
                <div class="text-[11px]"><strong class="uppercase tracking-widest text-red-800">Mô tả:</strong> <span class="italic text-gray-700">{{ order.moTaChuaNhan || '---' }}</span></div>
              </div>
              <button @click="cancelReportedOrder" class="w-full md:w-auto bg-red-600 text-white px-8 py-3.5 rounded-full font-bold text-[11px] uppercase tracking-widest hover:bg-red-700 transition shadow-lg">
                Hủy đơn & Hoàn tiền ngay
              </button>
            </div>
            
            <!-- Đơn PayOS đang chờ thanh toán (trạng thái 7) -->
            <div v-if="order.trangThaiDH === 7" class="p-6 bg-cyan-50 border border-cyan-200 rounded-2xl flex items-center gap-4">
              <span class="material-symbols-outlined text-cyan-500 text-2xl"> hourglass_top </span>
              <div>
                <p class="font-bold text-cyan-700 uppercase text-[11px] tracking-widest">Đang chờ khách thanh toán qua PayOS</p>
                <p class="text-xs text-cyan-600 mt-1">Đơn hàng sẽ tự chuyển sang “Chờ xác nhận” sau khi khách thanh toán thành công.</p>
              </div>
            </div>

            <div v-if="order.trangThaiDH === 5" class="p-6 bg-gray-50 border border-gray-200 rounded-2xl flex items-center gap-4">
              <span class="material-symbols-outlined text-red-500">cancel</span>
              <div>
                <p class="font-bold text-red-600 uppercase text-[11px] tracking-widest">Đơn hàng đã bị hủy</p>
                <p v-if="order.lyDoHuy" class="text-xs text-gray-500 mt-1 italic">"{{ order.lyDoHuy }}"</p>
              </div>
            </div>

            <!-- Refund Section for Admin -->
            <div v-if="order.trangThaiThanhToan === 5" class="mt-8 overflow-hidden rounded-3xl border border-orange-200 shadow-xl bg-white slide-up">
              <div class="bg-orange-600 p-6 text-white">
                <h5 class="text-[11px] font-black uppercase tracking-[0.3em] flex items-center gap-2">
                  <span class="material-symbols-outlined">payments</span> 
                  Yêu cầu hoàn tiền gấp
                </h5>
              </div>
              <div class="p-8 space-y-6">
                <div class="p-5 bg-orange-50 rounded-2xl border border-orange-100 italic text-orange-800 text-xs leading-relaxed">
                  "Đơn hàng này đã được khách trả tiền nhưng hiện tại đã bị hủy. Vui lòng liên hệ khách hàng để lấy thông tin tài khoản và hoàn tất chuyển trả lại tiền."
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div class="space-y-4">
                    <div class="flex items-center gap-3">
                      <span class="w-8 h-8 rounded-full bg-orange-100 flex items-center justify-center">
                        <span class="material-symbols-outlined text-orange-600 text-[18px]">person</span>
                      </span>
                      <div>
                        <p class="text-[9px] font-bold text-gray-400 uppercase tracking-widest">Chủ tài khoản liên hệ</p>
                        <p class="text-sm font-black text-gray-800 uppercase">{{ order.taiKhoan?.hoTen }}</p>
                      </div>
                    </div>
                    <div class="flex items-center gap-3">
                      <span class="w-8 h-8 rounded-full bg-orange-100 flex items-center justify-center">
                        <span class="material-symbols-outlined text-orange-600 text-[18px]">call</span>
                      </span>
                      <div>
                        <p class="text-[9px] font-bold text-gray-400 uppercase tracking-widest">Điện thoại</p>
                        <p class="text-sm font-black text-gray-800 tracking-wider">{{ order.taiKhoan?.soDienThoai }}</p>
                      </div>
                    </div>
                  </div>
                  
                  <div class="flex flex-col justify-center gap-3">
                     <button @click="confirmRefund" class="w-full bg-[#111111] hover:bg-orange-600 text-white px-8 py-4 rounded-full font-bold text-[10px] uppercase tracking-[0.2em] transition-all shadow-xl shadow-orange-200/50 flex items-center justify-center gap-2">
                        <span class="material-symbols-outlined text-sm">verified</span>
                        Xác nhận đã chuyển khoản trả khách
                     </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Lỗi thanh toán (trạng thái 8) -->
            <div v-if="order.trangThaiDH === 8" class="p-6 bg-orange-50 border border-orange-200 rounded-2xl flex items-center gap-4">
              <span class="material-symbols-outlined text-orange-500 text-2xl">payment_alert</span>
              <div>
                <p class="font-bold text-orange-700 uppercase text-[11px] tracking-widest">Lỗi thanh toán PayOS</p>
                <p class="text-xs text-orange-600 mt-1">Khách đã hủy hoặc thanh toán thất bại. Vui lòng liên hệ khách hàng.</p>
              </div>
            </div>

            <div v-if="order.trangThaiDH < 4 && order.trangThaiDH !== 7 && order.trangThaiDH !== 8 && !order.khachBaoChuaNhan" class="flex flex-wrap gap-4">
              <div class="flex-1 min-w-[200px]">
                <button v-if="order.trangThaiDH === 0" 
                  @click="updateStatus(1)" 
                  :disabled="isPayOSButNotPaid"
                  class="w-full text-white px-8 py-4 rounded-full font-bold text-[11px] uppercase tracking-widest transition shadow-xl"
                  :class="isPayOSButNotPaid ? 'bg-gray-400 cursor-not-allowed grayscale' : 'bg-[#111111] hover:bg-[#C8A97E]'">
                  Phê duyệt đơn hàng
                </button>
                <p v-if="isPayOSButNotPaid" class="text-[10px] text-red-500 font-bold mt-2 text-center flex items-center justify-center gap-2">
                   <span class="material-symbols-outlined text-[14px]">info</span>
                   Chờ khách thanh toán xong mới được phê duyệt
                </p>
              </div>

              <button v-if="order.trangThaiDH === 0 && !showCancelForm" @click="showCancelForm = true" class="flex-1 md:flex-none px-8 py-4 rounded-full border border-red-200 text-red-600 font-bold text-[11px] uppercase tracking-widest hover:bg-red-50 transition">
                Từ chối đơn
              </button>

              <div v-if="showCancelForm" class="w-full p-6 bg-red-50/30 border border-red-100 rounded-2xl space-y-4 animate-fadeIn">
                <label class="text-[10px] font-bold text-red-700 uppercase tracking-widest">Lý do từ chối:</label>
                <textarea v-model="cancelReason" rows="3" placeholder="Nhập lý do (Vd: Hết hàng, thông tin ảo...)" class="w-full bg-white border border-red-100 rounded-xl px-4 py-3 text-sm outline-none focus:border-red-400 transition-all"></textarea>
                <div class="flex gap-3">
                  <button @click="cancelOrder0" :disabled="!cancelReason.trim()" class="bg-red-600 text-white px-6 py-2.5 rounded-full font-bold text-[10px] uppercase tracking-widest disabled:opacity-50">Xác nhận hủy</button>
                  <button @click="showCancelForm = false; cancelReason = ''" class="bg-white text-gray-500 px-6 py-2.5 rounded-full border border-gray-200 font-bold text-[10px] uppercase tracking-widest">Đóng</button>
                </div>
              </div>

              <button v-if="order.trangThaiDH === 1" @click="updateStatus(2)" class="flex-1 bg-indigo-600 text-white px-8 py-4 rounded-full font-bold text-[11px] uppercase tracking-widest hover:bg-indigo-700 transition shadow-xl">
                Bàn giao vận chuyển
              </button>

              <button v-if="order.trangThaiDH === 2" @click="updateStatus(3)" class="flex-1 bg-teal-600 text-white px-8 py-4 rounded-full font-bold text-[11px] uppercase tracking-widest hover:bg-teal-700 transition shadow-xl">
                Xác nhận đã đến nơi
              </button>

              <button v-if="order.trangThaiDH === 3" @click="updateStatus(4)" class="flex-1 bg-green-600 text-white px-8 py-4 rounded-full font-bold text-[11px] uppercase tracking-widest hover:bg-green-700 transition shadow-xl">
                Quyết toán & Hoàn tất
              </button>
            </div>
            
            <div v-else-if="order.trangThaiDH >= 4 && order.trangThaiDH !== 8 && order.trangThaiDH !== 7 && !order.khachBaoChuaNhan" class="text-center py-4 bg-gray-50 rounded-2xl border border-dashed border-gray-200">
               <p class="text-[11px] font-bold text-gray-400 uppercase tracking-[0.3em] italic">
                 {{ order.trangThaiDH >= 4 && order.trangThaiDH !== 5 ? 'Hợp đồng này đã được thực hiện hoàn tất' : 'Hợp đồng này đã bị hủy bỏ' }}
               </p>
            </div>
          </div>
        </div>

        <!-- Right Column: Customer & Payment -->
        <div class="space-y-8">
          <!-- Customer Info -->
          <div class="bg-white rounded-3xl border border-[#E5E7EB] shadow-lg p-8">
            <h3 class="font-serif text-lg font-bold text-[#111111] uppercase mb-8 flex items-center gap-3">
              <span class="material-symbols-outlined text-[#C8A97E]">face</span>
              Thượng khách
            </h3>
            <div class="space-y-6">
              <div>
                <p class="text-[9px] text-gray-400 font-black uppercase tracking-[0.2em] mb-2">Chủ sở hữu</p>
                <p class="text-sm font-bold text-[#111111] uppercase tracking-tight">{{ order.taiKhoan?.hoTen || 'Khách vãng lai' }}</p>
              </div>
              <div class="flex items-center gap-3">
                <span class="material-symbols-outlined text-gray-300 text-sm">alternate_email</span>
                <p class="text-sm text-gray-600">{{ order.taiKhoan?.email || '---' }}</p>
              </div>
              <div class="flex items-center gap-3">
                <span class="material-symbols-outlined text-gray-300 text-sm">call</span>
                <p class="text-sm text-gray-600">{{ order.taiKhoan?.soDienThoai || '---' }}</p>
              </div>
            </div>
          </div>

          <!-- Shipping Info -->
          <div class="bg-white rounded-3xl border border-[#E5E7EB] shadow-lg p-8">
             <h3 class="font-serif text-lg font-bold text-[#111111] uppercase mb-8 flex items-center gap-3">
              <span class="material-symbols-outlined text-[#C8A97E]">distance</span>
              Điểm đến
            </h3>
            <div class="space-y-4">
               <div>
                  <p class="text-[9px] text-gray-400 font-black uppercase tracking-[0.2em] mb-2">Người tiếp nhận</p>
                  <p class="text-sm font-bold text-[#111111] uppercase tracking-tight">{{ order.hoTenNguoiNhan || order.taiKhoan?.hoTen }}</p>
                  <p class="text-xs text-gray-500 mt-1">{{ order.sdtNguoiNhan || order.taiKhoan?.soDienThoai }}</p>
               </div>
               <div>
                  <p class="text-[9px] text-gray-400 font-black uppercase tracking-[0.2em] mb-2">Địa chỉ chi tiết</p>
                  <p class="text-xs text-gray-700 leading-relaxed italic">"{{ order.diaChiGiao?.diaChiChiTiet || 'Chưa cập nhật' }}"</p>
               </div>
               <div v-if="order.ghiChu">
                  <p class="text-[9px] text-gray-400 font-black uppercase tracking-[0.2em] mb-2">Lời nhắn</p>
                  <p class="text-xs text-yellow-800 bg-yellow-50 p-3 rounded-xl border border-yellow-100">"{{ order.ghiChu }}"</p>
               </div>
            </div>
          </div>

          <!-- Payment Info -->
          <div class="bg-[#111111] rounded-3xl shadow-2xl p-8 text-white">
             <h3 class="font-serif text-lg font-bold uppercase mb-8 flex items-center gap-3">
              <span class="material-symbols-outlined text-[#C8A97E]">bid_landscape</span>
              Giao dịch
            </h3>
            <div class="space-y-6">
               <div class="flex justify-between items-center bg-white/5 p-4 rounded-2xl border border-white/10">
                  <span class="text-[10px] uppercase font-bold text-gray-400">Hình thức</span>
                  <span class="text-xs font-black uppercase tracking-widest text-[#C8A97E]">{{ order.hinhThucThanhToan?.tenHinhThuc || 'COD' }}</span>
               </div>
               <div class="flex justify-between items-center p-2">
                  <span class="text-[10px] uppercase font-bold text-gray-400">Trạng thái</span>
                  <div class="flex items-center gap-2">
                    <span class="h-2 w-2 rounded-full" :class="order.trangThaiThanhToan === 1 ? 'bg-green-500' : 'bg-yellow-500'"></span>
                    <span class="text-xs font-black uppercase tracking-widest" :class="order.trangThaiThanhToan === 1 ? 'text-green-500' : 'text-yellow-500'">
                       {{ order.trangThaiThanhToan === 1 ? 'Đã thanh toán' : 'Đang chờ' }}
                    </span>
                  </div>
               </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  
</template>

<script>
import axios from 'axios'

export default {
  name: 'OrderDetail',
  data() {
    return {
      order: null,
      loading: true,
      showCancelForm: false,
      cancelReason: ''
    }
  },
  computed: {
    orderItems() { return this.order?.chiTietList || [] },
    subTotal() {
      return this.orderItems.reduce((acc, item) => acc + (item.donGia * item.soLuong), 0)
    },
    isPayOSButNotPaid() {
      // 0: Chờ xác nhận, 7: Chờ thanh toán, 4: COD
      const isPayOS = this.order?.hinhThucThanhToan?.tenHinhThuc?.toLowerCase().includes('payos');
      return isPayOS && this.order?.trangThaiThanhToan !== 1;
    }
  },
  methods: {
    async fetchOrderDetail() {
      this.loading = true
      try {
        const id = this.$route.params.id
        const res = await axios.get(`/admin/orders/${id}`, { withCredentials: true })
        this.order = res.data
      } catch (e) {
        console.error("Lỗi khi tải chi tiết đơn hàng:", e)
        window.$toast.error("Không thể tải thông tin đơn hàng")
      } finally {
        this.loading = false
      }
    },
    // HELPERS CHO GIAO DIEN LUXURY
    getImgUrl(item) {
      if (item.anh) return item.anh;
      return item.sanPhamChiTiet?.sanPham?.anhChinh || item.sanPhamChiTiet?.anhBienThe || '/img/placeholder.png';
    },
    getBrand(item) { return item.thuongHieu || item.sanPhamChiTiet?.sanPham?.thuongHieu?.tenTH || 'Luxury Brand'; },
    getProductName(item) { return item.tenSP || item.sanPhamChiTiet?.sanPham?.tenSP || 'Sản phẩm cao cấp'; },
    getSize(item) { return item.size || item.sanPhamChiTiet?.sizeSP?.tenSize; },
    getColor(item) { return item.mau || item.sanPhamChiTiet?.mauSacSP?.tenMau; },
    formatDate(dateStr) {
      if (!dateStr) return '---';
      const d = new Date(dateStr);
      return d.toLocaleString('vi-VN', { hour: '2-digit', minute: '2-digit', day: '2-digit', month: '2-digit', year: 'numeric' });
    },

    async updateStatus(newStatus) {
      const ok = await window.$confirm(`Xác nhận chuyển sang trạng thái: ${this.statusClass(newStatus).text}?`)
      if (!ok) return
      try {
        const res = await axios.put(
            `/admin/orders/${this.order.maDH}/status`,
            null,
            { params: { status: newStatus }, withCredentials: true }
        )
        if (res.data.success) {
          window.$toast.success('Cập nhật trạng thái thành công!')
          this.fetchOrderDetail()
        } else {
          window.$toast.error(res.data.message)
        }
      } catch (err) {
        console.error("Update error", err)
        window.$toast.error(err.response?.data?.message || err.response?.data || 'Không thể cập nhật trạng thái')
      }
    },
    
    async cancelReportedOrder() {
      const reason = prompt("Nhập lý do hủy đơn (ví dụ: Giao thất bại, đã hoàn tiền):", "Khách báo chưa nhận được hàng: " + this.order.lyDoChuaNhan)
      if (reason === null) return
      
      try {
        await axios.put(
            `/admin/orders/${this.order.maDH}/status`,
            null,
            { params: { status: 5, reason: reason }, withCredentials: true }
        )
        window.$toast.success("Đơn hàng đã được hủy và lưu lý do!")
        this.fetchOrderDetail()
      } catch (err) {
        console.error("Cancel reported order error", err)
        window.$toast.error(err.response?.data?.message || err.response?.data || 'Không thể hủy đơn hàng')
      }
    },

    async cancelOrder0() {
      if (!this.cancelReason.trim()) return;
      try {
        const res = await axios.put(
            `/admin/orders/${this.order.maDH}/status`,
            null,
            { params: { status: 5, reason: this.cancelReason }, withCredentials: true }
        )
        if (res.data.success) {
          window.$toast.success("Đơn hàng đã được hủy thành công!")
          this.showCancelForm = false;
          this.cancelReason = '';
          this.fetchOrderDetail()
        } else {
          window.$toast.error(res.data.message)
        }
      } catch (err) {
        console.error("Cancel error", err)
        window.$toast.error(err.response?.data?.message || 'Không thể hủy đơn hàng')
      }
    },

    async confirmRefund() {
      const ghiChu = prompt("Nhập ghi chú hoàn tiền (Tùy chọn):", "Đã chuyển khoản trả khách qua " + (this.order.hinhThucThanhToan?.tenHinhThuc || 'Stk'))
      if (ghiChu === null) return

      try {
        const res = await axios.post(`/orders/${this.order.maDH}/confirm-refund`, { ghiChu }, { withCredentials: true })
        if (res.data.success) {
          window.$toast.success("✅ Đã xác nhận hoàn tiền thành công!")
          this.fetchOrderDetail()
        }
      } catch (err) {
        console.error("Confirm refund error", err)
        window.$toast.error(err.response?.data?.message || 'Lỗi khi xác nhận hoàn tiền')
      }
    },
    fmtCurrency(v) { return new Intl.NumberFormat('vi-VN').format(v || 0) + ' đ' },
    statusClass(s) {
      return {
        0: { text: 'Chờ xác nhận', class: 'bg-yellow-100 text-yellow-700' },
        1: { text: 'Đã xác nhận', class: 'bg-blue-100  text-blue-700' },
        2: { text: 'Đang giao', class: 'bg-purple-100 text-purple-700' },
        3: { text: 'Đã giao', class: 'bg-teal-100 text-teal-700' },
        4: { text: 'Hoàn tất', class: 'bg-green-100 text-green-700' },
        5: { text: 'Đã hủy', class: 'bg-red-100   text-red-700' },
        6: { text: 'Đã đánh giá', class: 'bg-orange-100 text-orange-700' },
        7: { text: 'Chờ thanh toán', class: 'bg-cyan-100 text-cyan-700' },
        8: { text: 'Lỗi thanh toán', class: 'bg-gray-100 text-gray-700' }
      }[s] ?? { text: 'Không xác định', class: 'bg-gray-100 text-gray-600' }
    },
    payStatusClass(s) {
      return {
        0: { text: 'Chờ thanh toán', class: 'bg-yellow-50 text-yellow-600 border-yellow-200' },
        1: { text: 'Đã thanh toán', class: 'bg-green-100 text-green-700 border-green-200' },
        2: { text: 'Thanh toán thất bại', class: 'bg-red-100 text-red-700 border-red-200' },
        3: { text: 'Thanh toán hết hạn', class: 'bg-gray-100 text-gray-500 border-gray-200' },
        4: { text: 'COD - Chưa thu', class: 'bg-blue-50 text-blue-600 border-blue-200' },
        5: { text: 'Chờ hoàn tiền', class: 'bg-orange-100 text-orange-700 border-orange-200' },
        6: { text: 'Đã hoàn tiền', class: 'bg-blue-100 text-blue-700 border-blue-200' }
      }[s] ?? { text: 'Chưa xác định', class: 'bg-gray-50 text-gray-400' }
    }
  },
  mounted() { this.fetchOrderDetail() }
}
</script>
