<template>
  <div class="p-8 space-y-8">
    <!-- DASHBOARD MINI -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5">
      <div class="flex flex-col gap-2 rounded-2xl p-6 border border-[#C8A97E]/30 bg-white shadow-sm hover:shadow-md transition-shadow">
        <div class="flex items-center justify-between">
          <p class="text-gray-500 text-sm font-medium">Tổng Voucher</p>
          <div class="flex items-center justify-center size-10 rounded-xl bg-[#C8A97E]/10 text-[#C8A97E]">
            <span class="material-symbols-outlined text-[22px]">confirmation_number</span>
          </div>
        </div>
        <p class="text-2xl font-extrabold text-gray-900">{{ vouchers.length }}</p>
        <p class="text-xs font-medium text-gray-400">Trong hệ thống</p>
      </div>

      <div class="flex flex-col gap-2 rounded-2xl p-6 border border-[#C8A97E]/30 bg-white shadow-sm hover:shadow-md transition-shadow">
        <div class="flex items-center justify-between">
          <p class="text-gray-500 text-sm font-medium">Đang hoạt động</p>
          <div class="flex items-center justify-center size-10 rounded-xl bg-green-50 text-green-600">
            <span class="material-symbols-outlined text-[22px]">check_circle</span>
          </div>
        </div>
        <p class="text-2xl font-extrabold text-gray-900">{{ vouchers.filter(v => v.trangThai && !v.isDeleted).length }}</p>
        <p class="text-xs font-medium text-green-600">Sẵn sàng sử dụng</p>
      </div>

      <div class="flex flex-col gap-2 rounded-2xl p-6 border border-[#C8A97E]/30 bg-white shadow-sm hover:shadow-md transition-shadow">
        <div class="flex items-center justify-between">
          <p class="text-gray-500 text-sm font-medium">Tổng lượt dùng</p>
          <div class="flex items-center justify-center size-10 rounded-xl bg-orange-50 text-orange-600">
            <span class="material-symbols-outlined text-[22px]">group</span>
          </div>
        </div>
        <p class="text-2xl font-extrabold text-gray-900">{{ vouchers.reduce((acc, v) => acc + (v.daSuDung || 0), 0) }}</p>
        <p class="text-xs font-medium text-orange-600">Lượt khách đã áp dụng</p>
      </div>

      <div class="flex flex-col gap-2 rounded-2xl p-6 border border-[#C8A97E]/30 bg-white shadow-sm hover:shadow-md transition-shadow">
        <div class="flex items-center justify-between">
          <p class="text-gray-500 text-sm font-medium">Tiết kiệm cho khách</p>
          <div class="flex items-center justify-center size-10 rounded-xl bg-blue-50 text-blue-600">
            <span class="material-symbols-outlined text-[22px]">savings</span>
          </div>
        </div>
        <p class="text-2xl font-extrabold text-gray-900">Tính toán...</p>
        <p class="text-xs font-medium text-blue-600">Tổng giá trị giảm giá</p>
      </div>
    </div>

    <!-- HEADER -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 tracking-tight">Hệ Thống Voucher Luxury</h1>
        <p class="text-sm text-gray-500 mt-1">Quản lý các chương trình ưu đãi và mã giảm giá cho khách hàng.</p>
      </div>
      <button 
        @click="openAddModal" 
        class="bg-[#C8A97E] text-white px-6 py-3 rounded-xl font-bold text-sm hover:bg-[#B8986E] transition-all flex items-center justify-center gap-2 shadow-lg shadow-[#C8A97E]/20 active:scale-95"
      >
        <span class="material-symbols-outlined text-lg">add_circle</span>
        Tạo Voucher Mới
      </button>
    </div>

    <!-- Danh sách Voucher -->
    <div class="bg-white rounded-2xl border border-[#C8A97E]/30 overflow-hidden shadow-sm">
      <div class="overflow-x-auto">
        <table class="w-full text-left">
          <thead class="bg-gray-50/50 border-b border-gray-100">
            <tr>
              <th class="px-6 py-4 text-[11px] font-black uppercase text-gray-500 tracking-widest">Thông tin Voucher</th>
              <th class="px-6 py-4 text-[11px] font-black uppercase text-gray-500 tracking-widest text-center">Mức giảm</th>
              <th class="px-6 py-4 text-[11px] font-black uppercase text-gray-500 tracking-widest">Điều kiện áp dụng</th>
              <th class="px-6 py-4 text-[11px] font-black uppercase text-gray-500 tracking-widest">Hiệu suất</th>
              <th class="px-6 py-4 text-[11px] font-black uppercase text-gray-500 tracking-widest text-center">Trạng thái</th>
              <th class="px-6 py-4 text-[11px] font-black uppercase text-gray-500 tracking-widest text-right">Thao tác</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-50">
            <tr v-for="v in vouchers" :key="v.maVoucher" :class="['hover:bg-[#C8A97E]/5 transition-colors', v.isDeleted ? 'opacity-40 grayscale' : '']">
              <td class="px-6 py-5">
                <div class="flex flex-col">
                  <span class="font-bold text-gray-900 text-base tracking-tight mb-0.5">
                    {{ v.code }}
                  </span>
                  <span class="text-xs text-gray-500 line-clamp-1">{{ v.moTa || 'Cửa hàng thời trang Luxury' }}</span>
                </div>
              </td>
              <td class="px-6 py-5 text-center">
                <div class="flex flex-col items-center">
                  <span class="font-black text-[#C8A97E] text-lg">
                    {{ v.loaiGiamGia === 0 ? v.giaTri + '%' : formatPrice(v.giaTri) }}
                  </span>
                  <span v-if="v.loaiGiamGia === 0 && v.giaTriToiDa" class="text-[10px] text-gray-400 font-bold uppercase tracking-tighter">Tối đa {{ formatPrice(v.giaTriToiDa) }}</span>
                </div>
              </td>
              <td class="px-6 py-5">
                <div class="space-y-1.5">
                  <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-sm text-gray-400">person</span>
                    <span class="text-xs font-bold text-gray-700">{{ getTargetText(v.apDungCho) }}</span>
                  </div>
                  <div class="flex items-center gap-2">
                    <span class="material-symbols-outlined text-sm text-gray-400">payments</span>
                    <span class="text-xs font-medium text-gray-500">Đơn từ <span class="font-bold text-gray-700">{{ formatPrice(v.giaTriToiThieu) }}</span></span>
                  </div>
                </div>
              </td>
              <td class="px-6 py-5">
                <div class="flex flex-col gap-1.5 w-32">
                  <div class="flex justify-between items-center text-[10px] font-bold text-gray-500">
                    <span>{{ v.daSuDung }} đã dùng</span>
                    <span>{{ v.soLuong }} mã</span>
                  </div>
                  <div class="w-full bg-gray-100 h-1.5 rounded-full overflow-hidden">
                    <div 
                      class="bg-[#C8A97E] h-full transition-all duration-500" 
                      :style="{ width: Math.min((v.daSuDung / v.soLuong * 100), 100) + '%' }"
                    ></div>
                  </div>
                </div>
              </td>
              <td class="px-6 py-5 text-center">
                <span 
                  v-if="!v.isDeleted && v.trangThai && isVoucherActive(v)" 
                  class="inline-flex items-center px-3 py-1 rounded-full bg-green-50 text-[10px] font-black text-green-600 uppercase tracking-wider"
                >
                  Hoạt động
                </span>
                <span 
                  v-else 
                  class="inline-flex items-center px-3 py-1 rounded-full bg-gray-100 text-[10px] font-black text-gray-400 uppercase tracking-wider"
                >
                  {{ v.isDeleted ? 'Đã Xóa' : (!v.trangThai ? 'Vô Hiệu' : 'Hết Hạn') }}
                </span>
              </td>
              <td class="px-6 py-5 text-right">
                <div class="flex items-center justify-end gap-1">
                  <button @click="editVoucher(v)" class="size-9 rounded-xl hover:bg-white hover:shadow-md text-gray-400 hover:text-blue-500 transition-all flex items-center justify-center">
                    <span class="material-symbols-outlined text-[20px]">edit</span>
                  </button>
                  <button v-if="!v.isDeleted" @click="deleteVoucher(v.maVoucher)" class="size-9 rounded-xl hover:bg-white hover:shadow-md text-gray-400 hover:text-red-500 transition-all flex items-center justify-center">
                    <span class="material-symbols-outlined text-[20px]">delete</span>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div v-if="vouchers.length === 0" class="flex flex-col items-center justify-center py-16 text-gray-400">
        <span class="material-symbols-outlined text-5xl mb-3">confirmation_number</span>
        <p class="text-sm font-medium">Không tìm thấy mã giảm giá nào</p>
      </div>
    </div>

    <!-- MODAL ĐA NĂNG -->
    <div v-if="showModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm overflow-y-auto">
      <div class="bg-white rounded-3xl w-full max-w-4xl my-auto shadow-2xl animate-modal-in flex flex-col max-h-[90vh] overflow-hidden border border-[#C8A97E]/20">
        
        <!-- Modal Header -->
        <div class="px-8 py-6 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
          <div>
            <h2 class="text-xl font-bold text-gray-900 tracking-tight">{{ currentVoucher.maVoucher ? 'Cấu hình Voucher' : 'Thiết Lập Voucher Mới' }}</h2>
            <p class="text-xs text-[#C8A97E] font-bold uppercase tracking-widest mt-1">Hệ thống phân phối ưu đãi Luxury</p>
          </div>
          <button @click="showModal = false" class="size-10 flex items-center justify-center rounded-xl bg-white border border-gray-100 text-gray-400 hover:text-gray-900 transition-colors shadow-sm">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>
        
        <!-- Modal Body -->
        <form @submit.prevent="saveVoucher" class="overflow-y-auto w-full">
          <div class="p-8 grid grid-cols-1 md:grid-cols-2 gap-8">
            
            <!-- CẤU HÌNH CƠ BẢN -->
            <div class="space-y-6">
              <div class="flex items-center gap-3">
                 <span class="material-symbols-outlined text-[#C8A97E]">settings</span>
                 <h3 class="text-sm font-bold text-gray-800 uppercase tracking-widest">1. Thông tin cơ bản</h3>
              </div>
              
              <div class="grid grid-cols-2 gap-4">
                <div class="col-span-1">
                  <label class="block text-[11px] font-bold text-gray-500 uppercase tracking-widest mb-2">Mã Voucher</label>
                  <input v-model="currentVoucher.code" type="text" class="lux-input text-[#111111] uppercase tracking-widest font-black" placeholder="WELCOME2024" required>
                </div>
                <div class="col-span-1">
                  <label class="block text-[11px] font-bold text-gray-500 uppercase tracking-widest mb-2">Loại giảm giá</label>
                  <select v-model="currentVoucher.loaiGiamGia" class="lux-input">
                    <option :value="0">Phần trăm (%)</option>
                    <option :value="1">Cố định (VND)</option>
                  </select>
                </div>
              </div>

              <div class="grid grid-cols-3 gap-4">
                <div>
                  <label class="block text-[11px] font-bold text-gray-500 uppercase tracking-widest mb-2">Giá trị giảm</label>
                  <input type="text"
                    :value="formatCurrency(currentVoucher.giaTri)"
                    @input="e => currentVoucher.giaTri = parseCurrency(e.target.value)"
                    @blur="e => e.target.value = formatCurrency(currentVoucher.giaTri)"
                    class="lux-input font-bold text-gray-900" required>
                </div>
                <div>
                  <label class="block text-[11px] font-bold text-gray-500 uppercase tracking-widest mb-2">Giảm tối đa</label>
                  <input type="text"
                    :value="formatCurrency(currentVoucher.giaTriToiDa)"
                    @input="e => currentVoucher.giaTriToiDa = parseCurrency(e.target.value)"
                    @blur="e => e.target.value = formatCurrency(currentVoucher.giaTriToiDa)"
                    class="lux-input font-bold text-gray-900" placeholder="---">
                </div>
                <div>
                  <label class="block text-[11px] font-bold text-gray-500 uppercase tracking-widest mb-2">Số lượt phát hành</label>
                  <input v-model="currentVoucher.soLuong" type="number" class="lux-input font-bold text-gray-900" required>
                </div>
              </div>

              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="block text-[11px] font-bold text-gray-500 uppercase tracking-widest mb-2">Đơn hàng tối thiểu</label>
                  <input type="text"
                    :value="formatCurrency(currentVoucher.giaTriToiThieu)"
                    @input="e => currentVoucher.giaTriToiThieu = parseCurrency(e.target.value)"
                    @blur="e => e.target.value = formatCurrency(currentVoucher.giaTriToiThieu)"
                    class="lux-input" placeholder="0">
                </div>
                <div>
                   <label class="block text-[11px] font-bold text-gray-500 uppercase tracking-widest mb-2">Mỗi User dùng tối đa</label>
                   <input v-model="currentVoucher.gioiHanUser" type="number" class="lux-input" placeholder="1">
                </div>
              </div>

              <div>
                <label class="block text-[11px] font-bold text-gray-500 uppercase tracking-widest mb-2">Mô tả chương trình</label>
                <textarea v-model="currentVoucher.moTa" class="lux-input h-24 p-4 text-sm italic" placeholder="Ưu đãi dành cho bạn..."></textarea>
              </div>
            </div>

            <!-- CẤU HÌNH NÂNG CAO -->
            <div class="space-y-6">
              <div class="flex items-center gap-3">
                 <span class="material-symbols-outlined text-[#C8A97E]">verified_user</span>
                 <h3 class="text-sm font-bold text-gray-800 uppercase tracking-widest">2. Phân quyền & Điều kiện</h3>
              </div>
              
              <div>
                <label class="block text-[11px] font-bold text-gray-500 uppercase tracking-widest mb-3">Đối tượng áp dụng</label>
                <div class="grid grid-cols-2 gap-2">
                  <button type="button" v-for="t in targets" :key="t.val" 
                    @click="currentVoucher.apDungCho = t.val"
                    :class="['px-4 py-3 text-[11px] font-bold uppercase tracking-widest rounded-xl border transition-all', 
                              currentVoucher.apDungCho === t.val ? 'bg-[#111111] text-white border-[#111111] shadow-lg' : 'bg-white border-gray-200 text-gray-500 hover:border-[#C8A97E] hover:text-[#C8A97E]']"
                  >
                    {{ t.label }}
                  </button>
                </div>
              </div>

              <div v-if="currentVoucher.apDungCho === 'VIP'" class="bg-[#FDFCFB] p-5 rounded-2xl border border-[#C8A97E]/20 animate-fade-in">
                <label class="block text-[11px] font-bold text-[#C8A97E] uppercase tracking-widest mb-2">Điều kiện VIP: Tổng KH chi tiêu ≥</label>
                <input type="text"
                    :value="formatCurrency(currentVoucher.minTotalSpendingVIP)"
                    @input="e => currentVoucher.minTotalSpendingVIP = parseCurrency(e.target.value)"
                    @blur="e => e.target.value = formatCurrency(currentVoucher.minTotalSpendingVIP)"
                    class="lux-input bg-white font-bold" placeholder="50,000,000">
              </div>

              <div class="grid grid-cols-2 gap-4">
                <div>
                   <label class="block text-[11px] font-bold text-gray-500 uppercase tracking-widest mb-2">Ngày bắt đầu</label>
                   <input v-model="currentVoucher.ngayBatDau" type="datetime-local" class="lux-input text-[11px] font-bold">
                </div>
                <div>
                   <label class="block text-[11px] font-bold text-gray-500 uppercase tracking-widest mb-2">Ngày kết thúc</label>
                   <input v-model="currentVoucher.ngayKetThuc" type="datetime-local" class="lux-input text-[11px] font-bold">
                </div>
              </div>

              <div class="space-y-4 pt-6 border-t border-gray-100">
                <label class="flex items-center gap-3 cursor-pointer group">
                  <div class="relative flex items-center justify-center w-6 h-6 border border-gray-200 rounded-lg transition-all" 
                       :class="{'bg-[#111111] border-[#111111]': currentVoucher.khongApDungSale}">
                    <input v-model="currentVoucher.khongApDungSale" type="checkbox" class="absolute opacity-0 cursor-pointer">
                    <span v-if="currentVoucher.khongApDungSale" class="material-symbols-outlined text-white text-base">check</span>
                  </div>
                  <div class="flex flex-col">
                    <span class="text-xs font-bold text-gray-800">Không áp dụng cho hàng Sale</span>
                    <span class="text-[10px] text-gray-400 font-medium">Chỉ dành cho sản phẩm nguyên giá</span>
                  </div>
                </label>

                <label class="flex items-center gap-3 cursor-pointer group">
                  <div class="relative flex items-center justify-center w-6 h-6 border border-gray-200 rounded-lg transition-all" 
                       :class="{'bg-[#C8A97E] border-[#C8A97E]': currentVoucher.trangThai}">
                    <input v-model="currentVoucher.trangThai" type="checkbox" class="absolute opacity-0 cursor-pointer">
                    <span v-if="currentVoucher.trangThai" class="material-symbols-outlined text-white text-base">check</span>
                  </div>
                  <div class="flex flex-col">
                    <span class="text-xs font-bold text-gray-800 uppercase tracking-widest">Kích hoạt Voucher</span>
                    <span class="text-[10px] text-gray-400 font-medium tracking-tight">Voucher sẽ xuất hiện cho khách sử dụng</span>
                  </div>
                </label>
              </div>

            </div>
          </div>
          
          <!-- FOOTER -->
          <div class="px-8 py-6 border-t border-gray-100 flex gap-4 bg-gray-50/50">
            <button type="button" @click="showModal = false" class="flex-1 px-6 py-3 border border-gray-200 text-gray-500 rounded-xl font-bold uppercase tracking-widest text-[11px] hover:bg-white transition-all">Hủy bỏ</button>
            <button type="submit" class="flex-[2] px-6 py-3 bg-[#111111] text-white rounded-xl font-bold uppercase tracking-widest text-[11px] hover:bg-black transition-all shadow-lg active:scale-[0.98]">Xác nhận phát hành</button>
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
        const res = await axios.get('/admin/vouchers');
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
        await axios.post('/admin/vouchers', this.currentVoucher);
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
        await axios.delete(`/admin/vouchers/${id}`);
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
  padding: 0.75rem 1rem;
  border: 1px solid #E5E7EB;
  border-radius: 0.75rem;
  font-size: 0.875rem;
  font-weight: 500;
  outline: none;
  transition: all 0.3s;
  background-color: #fff;
}

.lux-input:focus {
  border-color: #C8A97E;
  box-shadow: 0 0 0 4px rgba(200, 169, 126, 0.1);
}

.animate-modal-in {
  animation: modalIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@keyframes modalIn {
  from { opacity: 0; transform: translateY(20px) scale(0.98); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}

.animate-fade-in {
  animation: fadeIn 0.3s ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
