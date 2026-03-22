<template>
  <div class="p-6 md:p-10 w-full" style="background:#FDFCFB; min-height: 100vh;">
    <!-- DASHBOARD MINI -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12">
      <div class="bg-white p-8 border border-[#E5E7EB] shadow-sm hover:shadow-md transition-shadow group">
        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-[0.2em] mb-4 group-hover:text-[#C8A97E] transition-colors">Tổng Voucher</p>
        <h3 class="text-4xl font-serif text-[#111111] font-bold">{{ vouchers.length }}</h3>
      </div>
      <div class="bg-white p-8 border border-[#E5E7EB] shadow-sm hover:shadow-md transition-shadow group">
        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-[0.2em] mb-4 group-hover:text-green-600 transition-colors">Đang hoạt động</p>
        <h3 class="text-4xl font-serif text-green-700 font-bold">{{ vouchers.filter(v => v.trangThai && !v.isDeleted).length }}</h3>
      </div>
      <div class="bg-white p-8 border border-[#E5E7EB] shadow-sm hover:shadow-md transition-shadow group">
        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-[0.2em] mb-4 group-hover:text-[#C8A97E] transition-colors">Tổng lượt dùng</p>
        <h3 class="text-4xl font-serif font-bold" style="color:#C8A97E;">{{ vouchers.reduce((acc, v) => acc + v.daSuDung, 0) }}</h3>
      </div>
      <div class="bg-white p-8 border border-[#E5E7EB] shadow-sm hover:shadow-md transition-shadow group">
        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-[0.2em] mb-4 group-hover:text-blue-600 transition-colors">Tiết kiệm cho khách</p>
        <h3 class="text-4xl font-serif text-blue-700 font-bold">---</h3>
      </div>
    </div>

    <!-- HEADER -->
    <div class="flex justify-between items-center mb-10 pb-6 border-b border-[#E5E7EB]">
      <div class="flex items-center gap-6">
        <h1 class="text-3xl font-serif font-bold text-[#111111] uppercase tracking-[0.05em]">Hệ thống Voucher Luxury</h1>
        <span class="px-4 py-1.5 bg-[#111111] text-white text-[10px] font-bold uppercase tracking-[0.2em]">Professional Edition</span>
      </div>
      <button 
        @click="openAddModal" 
        class="bg-[#C8A97E] text-white px-8 py-3.5 rounded-full font-bold text-xs uppercase tracking-[0.2em] hover:bg-[#B8986E] transition-all flex items-center gap-2 shadow-sm"
      >
        <span class="material-symbols-outlined text-sm">add</span>
        Tạo Voucher Mới
      </button>
    </div>

    <!-- Danh sách Voucher -->
    <div class="bg-white border border-[#E5E7EB] overflow-hidden">
      <table class="w-full text-left">
        <thead style="background:#F7F4F1;" class="border-b border-[#E5E7EB]">
          <tr>
            <th class="px-8 py-5 text-[10px] font-bold uppercase text-gray-400 tracking-[0.2em]">Thông tin Voucher</th>
            <th class="px-8 py-5 text-[10px] font-bold uppercase text-gray-400 tracking-[0.2em]">Mức giảm</th>
            <th class="px-8 py-5 text-[10px] font-bold uppercase text-gray-400 tracking-[0.2em]">Đối tượng & Điều kiện</th>
            <th class="px-8 py-5 text-[10px] font-bold uppercase text-gray-400 tracking-[0.2em]">Hiệu suất</th>
            <th class="px-8 py-5 text-[10px] font-bold uppercase text-gray-400 tracking-[0.2em]">Trạng thái</th>
            <th class="px-8 py-5 text-[10px] font-bold uppercase text-gray-400 tracking-[0.2em] text-right">Thao tác</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-[#E5E7EB]">
          <tr v-for="v in vouchers" :key="v.maVoucher" :class="['hover:bg-gray-50/50 transition-colors', v.isDeleted ? 'opacity-40 grayscale' : '']">
            <td class="px-6 py-5">
              <div class="flex flex-col">
                <span class="font-serif font-bold text-lg text-[#111111] tracking-wide mb-1">
                  {{ v.code }}
                </span>
                <span class="text-xs text-gray-500 italic">{{ v.moTa || 'Không có mô tả' }}</span>
                <div class="flex gap-2 mt-2">
                  <span class="text-[9px] font-bold border border-blue-200 text-blue-700 px-2 py-0.5 uppercase tracking-widest" v-if="v.gioiHanUser">1 User / {{ v.gioiHanUser }} Lượt</span>
                  <span class="text-[9px] font-bold border border-red-200 text-red-700 px-2 py-0.5 uppercase tracking-widest" v-if="v.khongApDungSale">No Sale</span>
                </div>
              </div>
            </td>
            <td class="px-6 py-5">
              <div class="flex flex-col">
                <span class="font-bold text-[#111111] text-base">
                  {{ v.loaiGiamGia === 0 ? '-' + v.giaTri + '%' : '-' + formatPrice(v.giaTri) }}
                </span>
                <span v-if="v.loaiGiamGia === 0 && v.giaTriToiDa" class="text-[10px] text-gray-500 font-bold uppercase tracking-widest mt-1">Max {{ formatPrice(v.giaTriToiDa) }}</span>
              </div>
            </td>
            <td class="px-6 py-5">
              <div class="space-y-2">
                <div class="flex items-center gap-2">
                  <span class="material-symbols-outlined text-sm text-[#C8A97E]">group</span>
                  <span class="text-[10px] font-bold text-[#111111] uppercase tracking-widest">{{ getTargetText(v.apDungCho) }}</span>
                </div>
                <div class="flex items-center gap-2">
                  <span class="material-symbols-outlined text-sm text-[#C8A97E]">shopping_cart</span>
                  <span class="text-[10px] font-bold text-gray-500 uppercase tracking-widest">Đơn từ {{ formatPrice(v.giaTriToiThieu) }}</span>
                </div>
              </div>
            </td>
            <td class="px-6 py-5">
              <div class="flex flex-col gap-2 w-32">
                <div class="flex justify-between items-center text-[10px] font-bold uppercase text-gray-500 tracking-widest">
                  <span>Usage</span>
                  <span>{{ v.daSuDung }}/{{ v.soLuong }}</span>
                </div>
                <div class="w-full bg-[#F5F1ED] h-1 overflow-hidden">
                  <div 
                    class="bg-[#C8A97E] h-full transition-all duration-500" 
                    :style="{ width: (v.daSuDung / v.soLuong * 100) + '%' }"
                  ></div>
                </div>
              </div>
            </td>
            <td class="px-6 py-5">
               <span 
                v-if="!v.isDeleted && v.trangThai && isVoucherActive(v)" 
                class="inline-flex items-center gap-1.5 px-2 py-1 border border-green-200 text-[9px] font-bold text-green-700 uppercase tracking-widest bg-green-50"
              >
                <span class="w-1.5 h-1.5 bg-green-600 rounded-full animate-pulse"></span>
                Đang chạy
              </span>
              <span 
                v-else 
                class="inline-flex items-center gap-1.5 px-2 py-1 border border-red-200 text-[9px] font-bold text-red-700 uppercase tracking-widest bg-red-50"
              >
                {{ v.isDeleted ? 'Đã Xóa' : (!v.trangThai ? 'Vô Hiệu' : 'Hết Hạn') }}
              </span>
            </td>
            <td class="px-6 py-5 text-right">
              <div class="flex items-center justify-end gap-3">
                <button @click="editVoucher(v)" class="text-gray-400 hover:text-[#C8A97E] transition-colors" title="Chỉnh sửa">
                  <span class="material-symbols-outlined text-[20px]">edit_square</span>
                </button>
                <button v-if="!v.isDeleted" @click="deleteVoucher(v.maVoucher)" class="text-gray-400 hover:text-red-600 transition-colors" title="Xóa mềm">
                  <span class="material-symbols-outlined text-[20px]">delete</span>
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- MODAL ĐA NĂNG -->
    <div v-if="showModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm overflow-y-auto">
      <div class="bg-white border border-[#E5E7EB] w-full max-w-4xl my-auto shadow-2xl animate-modal-in flex flex-col max-h-[90vh]">
        
        <!-- Modal Header -->
        <div class="p-10 border-b border-[#F5F1ED] flex justify-between items-start" style="background:#FDFCFB;">
          <div class="flex flex-col">
            <h2 class="text-4xl font-serif font-bold text-[#111111] uppercase tracking-[0.05em]">{{ currentVoucher.maVoucher ? 'Cấu hình Voucher' : 'THIẾT LẬP VOUCHER MỚI' }}</h2>
            <p class="text-[11px] text-[#C8A97E] font-bold uppercase tracking-[0.3em] mt-3">Hệ thống phân phối ưu đãi Luxury</p>
          </div>
          <button @click="showModal = false" class="text-gray-300 hover:text-[#111111] transition-colors p-2">
            <span class="material-symbols-outlined text-3xl">close</span>
          </button>
        </div>
        
        <!-- Modal Body -->
        <form @submit.prevent="saveVoucher" class="overflow-y-auto w-full">
          <div class="p-10 grid grid-cols-1 md:grid-cols-2 gap-16">
            
            <!-- CẤU HÌNH CƠ BẢN -->
            <div class="space-y-8">
              <div class="flex items-center gap-4 mb-2">
                <div class="w-[3px] h-6 bg-[#C8A97E]"></div>
                <h3 class="text-sm font-bold text-[#C8A97E] uppercase tracking-[0.2em]">1. Thông tin cơ bản</h3>
              </div>
              
              <div class="grid grid-cols-2 gap-6">
                <div class="col-span-1">
                  <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-[0.15em] mb-3">Mã Voucher</label>
                  <input v-model="currentVoucher.code" type="text" class="lux-input-large text-[#111111] uppercase tracking-[0.2em]" placeholder="WELCOME2024" required>
                </div>
                <div class="col-span-1">
                  <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-[0.15em] mb-3">Loại giảm giá</label>
                  <div class="relative">
                    <select v-model="currentVoucher.loaiGiamGia" class="lux-input pr-10 appearance-none">
                      <option :value="0">Theo phần trăm (%)</option>
                      <option :value="1">Số tiền cố định (VND)</option>
                    </select>
                    <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none">expand_more</span>
                  </div>
                </div>
              </div>

              <div class="grid grid-cols-3 gap-0 border border-[#EDF1F5] rounded-sm overflow-hidden shadow-sm">
                <div class="p-5 border-r border-[#EDF1F5] bg-white">
                  <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-[0.1em] mb-2">Giá trị giảm</label>
                  <input type="text"
                    :value="formatCurrency(currentVoucher.giaTri)"
                    @input="e => currentVoucher.giaTri = parseCurrency(e.target.value)"
                    @blur="e => e.target.value = formatCurrency(currentVoucher.giaTri)"
                    class="w-full text-xl font-bold text-[#111111] outline-none bg-transparent" required>
                </div>
                <div class="p-5 border-r border-[#EDF1F5] bg-white">
                  <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-[0.1em] mb-2">Giảm tối đa</label>
                  <input type="text"
                    :value="formatCurrency(currentVoucher.giaTriToiDa)"
                    @input="e => currentVoucher.giaTriToiDa = parseCurrency(e.target.value)"
                    @blur="e => e.target.value = formatCurrency(currentVoucher.giaTriToiDa)"
                    class="w-full text-xl font-bold text-[#111111] outline-none bg-transparent" placeholder="BỎ TRỐNG">
                </div>
                <div class="p-5 bg-white">
                  <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-[0.1em] mb-2">Tổng số lượt</label>
                  <input v-model="currentVoucher.soLuong" type="number" class="w-full text-xl font-bold text-[#111111] outline-none bg-transparent" required>
                </div>
              </div>

              <div class="grid grid-cols-2 gap-6">
                <div>
                  <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-[0.15em] mb-3">Đơn hàng tối thiểu</label>
                  <input type="text"
                    :value="formatCurrency(currentVoucher.giaTriToiThieu)"
                    @input="e => currentVoucher.giaTriToiThieu = parseCurrency(e.target.value)"
                    @blur="e => e.target.value = formatCurrency(currentVoucher.giaTriToiThieu)"
                    class="lux-input text-lg" placeholder="0">
                </div>
                <div>
                   <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-[0.15em] mb-3">Mỗi User dùng</label>
                   <input v-model="currentVoucher.gioiHanUser" type="number" class="lux-input text-lg" placeholder="1">
                </div>
              </div>

              <div>
                <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-[0.15em] mb-3">Mô tả chương trình</label>
                <textarea v-model="currentVoucher.moTa" class="lux-input h-32 p-4 text-sm italic leading-relaxed" placeholder="Thông điệp gửi đến khách hàng khi áp mã..."></textarea>
              </div>
            </div>

            <!-- CẤU HÌNH NÂNG CAO -->
            <div class="space-y-8">
              <div class="flex items-center gap-4 mb-2">
                <div class="w-[3px] h-6 bg-[#C8A97E]"></div>
                <h3 class="text-sm font-bold text-[#C8A97E] uppercase tracking-[0.2em]">2. Phân quyền & Điều kiện</h3>
              </div>
              
              <div>
                <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-[0.15em] mb-4">Đối tượng áp dụng</label>
                <div class="grid grid-cols-2 gap-3">
                  <button type="button" v-for="t in targets" :key="t.val" 
                    @click="currentVoucher.apDungCho = t.val"
                    :class="['px-4 py-4 text-[10px] font-bold uppercase tracking-[0.2em] border transition-all duration-300 text-center shadow-sm', 
                              currentVoucher.apDungCho === t.val ? 'bg-[#111111] text-white border-[#111111]' : 'bg-white border-[#E5E7EB] text-gray-500 hover:border-[#C8A97E] hover:text-[#C8A97E]']"
                  >
                    {{ t.label }}
                  </button>
                </div>
              </div>

              <div v-if="currentVoucher.apDungCho === 'VIP'" class="bg-[#FDFCFB] p-6 border border-[#E5E7EB] animate-fade-in shadow-inner">
                <label class="block text-[10px] font-bold text-[#C8A97E] uppercase tracking-[0.2em] mb-3">Điều kiện VIP: Tổng chi tiêu ≥</label>
                <input type="text"
                    :value="formatCurrency(currentVoucher.minTotalSpendingVIP)"
                    @input="e => currentVoucher.minTotalSpendingVIP = parseCurrency(e.target.value)"
                    @blur="e => e.target.value = formatCurrency(currentVoucher.minTotalSpendingVIP)"
                    class="lux-input bg-white text-lg" placeholder="50,000,000">
              </div>

              <div class="grid grid-cols-2 gap-6">
                <div class="relative">
                   <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-[0.15em] mb-3">Ngày bắt đầu</label>
                   <div class="relative">
                    <input v-model="currentVoucher.ngayBatDau" type="datetime-local" class="lux-input text-xs font-bold uppercase pr-10">
                    <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none">calendar_month</span>
                   </div>
                </div>
                <div class="relative">
                   <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-[0.15em] mb-3">Ngày kết thúc</label>
                   <div class="relative">
                    <input v-model="currentVoucher.ngayKetThuc" type="datetime-local" class="lux-input text-xs font-bold uppercase pr-10">
                    <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none">event_busy</span>
                   </div>
                </div>
              </div>

              <div class="space-y-6 pt-10 border-t border-[#F5F1ED]">
                <label class="flex items-start gap-5 cursor-pointer group">
                  <div class="relative flex items-center justify-center w-6 h-6 border border-[#E5E7EB] group-hover:border-[#111111] transition-all bg-white shadow-sm mt-0.5" 
                       :class="{'bg-[#111111] border-[#111111]': currentVoucher.khongApDungSale}">
                    <input v-model="currentVoucher.khongApDungSale" type="checkbox" class="absolute opacity-0">
                    <span v-if="currentVoucher.khongApDungSale" class="material-symbols-outlined text-white text-base">check</span>
                  </div>
                  <div class="flex flex-col">
                    <span class="text-[13px] font-bold text-[#111111] uppercase tracking-[0.1em]">LOẠI TRỪ SẢN PHẨM SALE</span>
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-[0.15em] mt-1.5 underline decoration-[#C8A97E] underline-offset-4">Chỉ áp dụng cho hàng nguyên giá</span>
                  </div>
                </label>

                <label class="flex items-start gap-5 cursor-pointer group">
                  <div class="relative flex items-center justify-center w-6 h-6 border border-[#E5E7EB] group-hover:border-[#111111] transition-all bg-white shadow-sm mt-0.5" 
                       :class="{'bg-[#111111] border-[#111111]': currentVoucher.trangThai}">
                    <input v-model="currentVoucher.trangThai" type="checkbox" class="absolute opacity-0">
                    <span v-if="currentVoucher.trangThai" class="material-symbols-outlined text-white text-base">check</span>
                  </div>
                  <div class="flex flex-col">
                    <span class="text-[13px] font-bold text-[#111111] uppercase tracking-[0.1em]">BẬT VOUCHER NÀY</span>
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-[0.15em] mt-1.5">Voucher sẽ xuất hiện cho khách hàng dùng</span>
                  </div>
                </label>
              </div>

            </div>
          </div>
          
          <!-- FOOTER -->
          <div class="px-10 py-8 border-t border-[#F5F1ED] flex gap-5 bg-white sticky bottom-0 z-10 shadow-[0_-5px_20px_rgba(0,0,0,0.02)]">
            <button type="button" @click="showModal = false" class="flex-1 px-10 py-4 border border-[#E1E1E1] text-gray-500 rounded-full font-bold uppercase tracking-[0.2em] text-[11px] hover:bg-gray-50 transition-all text-center">Hủy bỏ</button>
            <button type="submit" class="flex-[2] px-10 py-4 bg-[#111111] text-white rounded-full font-bold uppercase tracking-[0.2em] text-[11px] hover:bg-black transition-all text-center shadow-lg active:scale-[0.98]">Xác nhận & Phát hành Voucher</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'VoucherList',
  data() {
    return {
      vouchers: [],
      showModal: false,
      targets: [
        { label: 'Tất cả khách', val: 'ALL' },
        { label: 'Khách hàng mới', val: 'NEW' },
        { label: 'Khách hàng VIP', val: 'VIP' },
        { label: 'Đặc quyền riêng', val: 'PRIVATE' }
      ],
      currentVoucher: {
        maVoucher: null,
        code: '',
        moTa: '',
        loaiGiamGia: 0,
        giaTri: 0,
        giaTriToiThieu: 0,
        giaTriToiDa: null,
        soLuong: 100,
        daSuDung: 0,
        gioiHanUser: 1,
        apDungCho: 'ALL',
        minTotalSpendingVIP: 0,
        maLoaiApDung: '',
        maTHApDung: '',
        khongApDungSale: false,
        ngayBatDau: this.formatDateForInput(new Date()),
        ngayKetThuc: this.formatDateForInput(new Date(Date.now() + 30*24*60*60*1000)),
        trangThai: true,
        isDeleted: false
      }
    };
  },
  methods: {
    async fetchVouchers() {
      try {
        const res = await axios.get('/api/admin/vouchers');
        this.vouchers = res.data;
      } catch (err) {
        console.error('Fetch vouchers failed', err);
      }
    },
    openAddModal() {
      this.currentVoucher = {
        maVoucher: null, code: '', moTa: '', loaiGiamGia: 0, giaTri: 0, giaTriToiThieu: 0,
        giaTriToiDa: null, soLuong: 100, daSuDung: 0, gioiHanUser: 1, apDungCho: 'ALL',
        minTotalSpendingVIP: 0, maLoaiApDung: '', maTHApDung: '', khongApDungSale: false,
        ngayBatDau: this.formatDateForInput(new Date()),
        ngayKetThuc: this.formatDateForInput(new Date(Date.now() + 30*24*60*60*1000)),
        trangThai: true, isDeleted: false
      };
      this.showModal = true;
    },
    editVoucher(v) {
      this.currentVoucher = { 
        ...v,
        ngayBatDau: this.formatDateForInput(v.ngayBatDau),
        ngayKetThuc: this.formatDateForInput(v.ngayKetThuc)
      };
      this.showModal = true;
    },
    async saveVoucher() {
      try {
        await axios.post('/api/admin/vouchers', this.currentVoucher);
        this.showModal = false;
        this.fetchVouchers();
        if(window.$alert) window.$alert('Phát hành Voucher Luxury thành công!', 'Thành công');
        else alert('Lưu thành công!');
      } catch (err) {
        if(window.$alert) window.$alert('Lỗi khi lưu voucher: ' + err.message, 'Lỗi');
        else alert('Lỗi: ' + err.message);
      }
    },
    async deleteVoucher(id) {
      if (window.$confirm) {
        if (!await window.$confirm('Bạn có chắc muốn xóa Voucher này khỏi hệ thống?')) return;
      } else {
        if (!confirm('Bạn có chắc muốn xóa?')) return;
      }
      try {
        await axios.delete(`/api/admin/vouchers/${id}`);
        this.fetchVouchers();
      } catch (err) {
        if(window.$alert) window.$alert('Không thể thực hiện xóa', 'Lỗi');
        else alert('Lỗi xóa');
      }
    },
    formatPrice(price) {
      if (!price) return '0đ';
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price);
    },
    formatCurrency(value) {
      if (!value) return '';
      return Number(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    },
    parseCurrency(value) {
      if (!value) return null;
      const parsed = parseInt(value.replace(/,/g, '').replace(/\D/g, ''), 10);
      return isNaN(parsed) ? null : parsed;
    },
    formatDate(dateStr) {
      if (!dateStr) return '';
      return new Date(dateStr).toLocaleDateString('vi-VN');
    },
    formatDateForInput(date) {
      if (!date) return '';
      const d = new Date(date);
      return d.toISOString().slice(0, 16);
    },
    isVoucherActive(v) {
      const now = new Date();
      return new Date(v.ngayBatDau) <= now && new Date(v.ngayKetThuc) >= now;
    },
    getTargetText(target) {
      switch(target) {
        case 'NEW': return 'Khách mới';
        case 'VIP': return 'Thanh viên VIP';
        case 'PRIVATE': return 'Đặc quyền';
        default: return 'Tất cả khách';
      }
    }
  },
  mounted() {
    this.fetchVouchers();
  }
};
</script>

<style scoped>
.lux-input {
  width: 100%;
  padding: 1rem 1.25rem;
  border: 1px solid #E5E7EB;
  font-weight: 700;
  outline: none;
  font-family: inherit;
  transition: all 0.3s;
  background-color: #fff;
  border-radius: 2px;
}
.lux-input:focus {
  border-color: #C8A97E;
  box-shadow: 0 0 0 4px rgba(200, 169, 126, 0.05);
}

.lux-input-large {
  width: 100%;
  padding: 1.25rem 1.5rem;
  border: 1px solid #E5E7EB;
  font-weight: 700;
  font-size: 1.25rem;
  outline: none;
  font-family: inherit;
  transition: all 0.3s;
  background-color: #fff;
  border-radius: 2px;
}
.lux-input-large:focus {
  border-color: #C8A97E;
  box-shadow: 0 0 0 4px rgba(200, 169, 126, 0.05);
}

.animate-modal-in {
  animation: modalIn 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}
@keyframes modalIn {
  from { opacity: 0; transform: translateY(30px) scale(0.98); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}

.animate-fade-in {
  animation: fadeIn 0.4s ease-out;
}
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
