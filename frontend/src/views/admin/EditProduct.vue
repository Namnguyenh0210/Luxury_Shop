<template>
  <div class="min-h-screen bg-[#FDFBF9] p-4 md:p-8 selection:bg-[#C8A97E] selection:text-white">
    <div class="max-w-6xl mx-auto space-y-10 pb-20">
      
      <!-- HEADER -->
      <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 animate-in fade-in slide-in-from-top duration-700">
        <div class="flex items-center gap-6">
          <button @click="$router.push('/admin/products')" class="size-14 rounded-2xl bg-white border border-[#C8A97E]/30 text-gray-500 hover:text-[#C8A97E] hover:border-[#C8A97E] transition-all flex items-center justify-center shadow-sm group">
            <span class="material-symbols-outlined group-hover:-translate-x-1 transition-transform text-[28px]">arrow_back</span>
          </button>
          <div>
            <h1 class="text-3xl font-black text-gray-900 tracking-tight italic">Sửa sản phẩm</h1>
            <div class="flex items-center gap-2 mt-2">
                <span class="size-1.5 bg-[#C8A97E] rounded-full animate-pulse"></span>
                <p class="text-xs font-bold text-[#C8A97E] uppercase tracking-widest">Hệ thống quản trị LUXURY SHOP v2.0</p>
            </div>
          </div>
        </div>
        <div class="flex items-center gap-4 text-sm font-bold uppercase tracking-widest">
           <button @click="$router.push('/admin/products')" class="px-8 py-4 rounded-2xl text-[#C8A97E] hover:bg-[#C8A97E]/10 transition-all">
              HỦY BỎ
           </button>
           <button @click="updateProduct" :disabled="saving || loading" class="px-10 py-4 rounded-2xl bg-gray-900 text-white hover:bg-black transition-all shadow-xl shadow-[#C8A97E]/20 disabled:opacity-50 flex items-center gap-3">
              <span v-if="saving" class="material-symbols-outlined animate-spin text-lg">progress_activity</span>
              <span v-else class="material-symbols-outlined text-[20px]">verified</span>
              LƯU THAY ĐỔI
           </button>
        </div>
      </div>

      <div v-if="loading" class="flex flex-col items-center justify-center py-40 gap-6">
        <div class="relative size-20">
            <div class="absolute inset-0 border-[3px] border-[#C8A97E]/10 rounded-full"></div>
            <div class="absolute inset-0 border-[3px] border-[#C8A97E] border-t-transparent rounded-full animate-spin"></div>
        </div>
        <p class="text-xs font-bold text-[#C8A97E] animate-pulse tracking-[0.2em] italic uppercase">Đang đồng bộ hóa dữ liệu...</p>
      </div>

      <!-- MAIN CONTENT GRID -->
      <div v-else class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start animate-in fade-in zoom-in duration-700">
        
        <!-- FRAME 1: EDITABLE (LEFT - LARGE) -->
        <div class="lg:col-span-8 bg-white rounded-[3rem] border border-[#C8A97E]/20 shadow-2xl shadow-stone-200/40 p-10 lg:p-12 relative overflow-hidden group">
            <div class="relative z-10">
                <div class="flex items-center justify-between mb-10 pb-6 border-b border-gray-50">
                    <h3 class="text-lg font-bold text-gray-800 uppercase tracking-widest flex items-center gap-4">
                        <span class="size-10 bg-[#C8A97E] text-white rounded-xl shadow-lg flex items-center justify-center">
                           <span class="material-symbols-outlined text-[20px]">edit_square</span>
                        </span>
                        Nội dung chỉnh sửa
                    </h3>
                    <div class="px-5 py-2 rounded-full bg-[#C8A97E]/5 border border-[#C8A97E]/10 text-xs font-bold text-[#C8A97E] italic uppercase tracking-wider">Luxury Mode</div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-12 gap-10">
                    <!-- LEFT COLUMN (FORM FIELDS) -->
                    <div class="md:col-span-7 space-y-8">
                        <!-- NAME FIELD -->
                        <div class="group/input">
                            <label class="text-xs font-bold text-[#C8A97E] uppercase tracking-widest mb-3 block">Tên sản phẩm quốc tế</label>
                            <input v-model="form.tenSP" placeholder="Luxury Fashion Piece..." 
                                class="w-full bg-transparent border border-[#C8A97E]/30 rounded-[1.5rem] px-6 py-4 text-lg font-bold text-gray-900 outline-none focus:border-[#C8A97E] focus:ring-1 focus:ring-[#C8A97E] transition-all shadow-sm" />
                        </div>

                        <!-- PRICE FIELD -->
                        <div class="group/input">
                            <label class="text-xs font-bold text-[#C8A97E] uppercase tracking-widest mb-3 block">Giá bán niêm yết (VNĐ)</label>
                            <div class="relative flex items-center">
                                <span class="absolute left-6 text-[#C8A97E] material-symbols-outlined text-[20px]">payments</span>
                                <input v-model.number="form.giaBan" type="number" 
                                    class="w-full bg-transparent border border-[#C8A97E]/30 rounded-[1.5rem] pl-14 pr-12 py-4 text-xl font-bold text-[#C8A97E] outline-none focus:border-[#C8A97E] focus:ring-1 focus:ring-[#C8A97E] transition-all shadow-sm tabular-nums" />
                                <span class="absolute right-6 text-lg font-bold text-[#C8A97E]/50 italic">₫</span>
                            </div>
                        </div>

                        <!-- STATUS TOGGLE -->
                        <div class="space-y-4">
                             <label class="text-xs font-bold text-[#C8A97E] uppercase tracking-widest block">Trạng thái phát hành</label>
                             <div class="flex items-center gap-4">
                                <button @click="form.trangThaiSP = 1" type="button" 
                                    :class="form.trangThaiSP == 1 ? 'bg-white border-[#C8A97E] text-green-600 shadow-md transform scale-[1.02]' : 'bg-gray-50 border-transparent text-gray-400 hover:bg-gray-100'"
                                    class="flex-1 py-4 rounded-[1.2rem] border-2 text-xs font-bold uppercase transition-all tracking-widest flex items-center justify-center gap-2">
                                    <span class="size-2 rounded-full bg-green-500" v-if="form.trangThaiSP == 1"></span>
                                    Đang kinh doanh
                                </button>
                                <button @click="form.trangThaiSP = 0" type="button" 
                                    :class="form.trangThaiSP == 0 ? 'bg-white border-[#C8A97E] text-red-500 shadow-md transform scale-[1.02]' : 'bg-gray-50 border-transparent text-gray-400 hover:bg-gray-100'"
                                    class="flex-1 py-4 rounded-[1.2rem] border-2 text-xs font-bold uppercase transition-all tracking-widest flex items-center justify-center gap-2">
                                    <span class="size-2 rounded-full bg-red-500" v-if="form.trangThaiSP == 0"></span>
                                    Dừng kinh doanh
                                </button>
                             </div>
                        </div>
                    </div>

                    <!-- RIGHT COLUMN (MEDIA PREVIEW & URL) -->
                    <div class="md:col-span-5 space-y-8">
                        <div class="relative aspect-[4/5] rounded-[2.5rem] bg-gray-50 border border-[#C8A97E]/20 p-2 overflow-hidden shadow-inner group/img">
                            <img v-if="form.anhChinh" :src="form.anhChinh" class="w-full h-full object-cover rounded-[2rem] transition-transform duration-1000 group-hover/img:scale-105" @error="onImgError" />
                            <div v-else class="w-full h-full flex flex-col items-center justify-center text-gray-200 italic">
                                <span class="material-symbols-outlined text-8xl mb-3 font-thin">insert_photo</span>
                                <p class="text-xs font-bold uppercase tracking-widest leading-none">Chưa có ảnh</p>
                            </div>
                        </div>
                        <div class="space-y-3">
                            <label class="text-xs font-bold text-[#C8A97E] uppercase tracking-widest block text-center">Liên kết hình ảnh trực tiếp</label>
                            <input v-model="form.anhChinh" placeholder="https://..." 
                                class="w-full bg-transparent border border-[#C8A97E]/30 rounded-[1.2rem] px-5 py-3.5 text-sm font-bold text-gray-600 focus:border-[#C8A97E] transition-all outline-none" />
                        </div>
                    </div>

                    <!-- DESCRIPTION (FOOTER AREA) -->
                    <div class="md:col-span-12 space-y-4 pt-4 border-t border-gray-50">
                        <label class="text-xs font-bold text-[#C8A97E] uppercase tracking-widest block">Mô tả sản phẩm</label>
                        <textarea v-model="form.moTa" rows="5" placeholder="Câu chuyện thương hiệu..."
                            class="w-full bg-transparent border border-[#C8A97E]/30 rounded-[2rem] p-8 text-base leading-relaxed text-gray-700 italic focus:border-[#C8A97E] transition-all outline-none resize-none shadow-sm focus:ring-1 focus:ring-[#C8A97E]"></textarea>
                    </div>
                </div>
            </div>
        </div>

        <!-- FRAME 2: READ-ONLY INFO (RIGHT - SMALL) -->
        <div class="lg:col-span-4 bg-[#FCF8F2] rounded-[3rem] border border-[#C8A97E]/20 p-10 lg:p-12 space-y-12 relative overflow-hidden group/read shadow-xl shadow-[#C8A97E]/5">
             <div class="relative z-10">
                <div class="flex items-center gap-4 mb-10">
                   <div class="size-10 bg-white rounded-xl border border-[#C8A97E]/10 flex items-center justify-center text-[#C8A97E]">
                      <span class="material-symbols-outlined text-[20px]">account_tree</span>
                   </div>
                   <h3 class="text-base font-bold text-gray-800 uppercase tracking-widest whitespace-nowrap">Thông tin chỉ đọc</h3>
                </div>

                <div class="space-y-6">
                    <!-- ID DISPLAY -->
                    <div class="bg-white rounded-[2rem] p-8 border border-[#C8A97E]/20 shadow-sm relative group/id">
                        <p class="text-xs text-[#C8A97E] font-bold uppercase tracking-widest mb-2 opacity-80 italic">ID Sản Phẩm</p>
                        <p class="font-bold text-3xl text-gray-900 leading-none tracking-tighter">#{{ form.maSP }}</p>
                    </div>

                    <!-- META CARDS -->
                    <div class="grid grid-cols-1 gap-3">
                        <div v-for="(item, idx) in [
                          { label: 'Thương hiệu', val: originalProduct?.thuongHieu?.tenTH, icon: 'stars' },
                          { label: 'Danh mục', val: originalProduct?.loaiSanPham?.tenLoai, icon: 'category' },
                          { label: 'Giới tính', val: originalProduct?.gioiTinh === 0 ? 'Nam' : originalProduct?.gioiTinh === 1 ? 'Nữ' : 'Unisex', icon: 'wc' }
                        ]" :key="idx" class="p-5 bg-white rounded-[1.5rem] border border-[#C8A97E]/10 shadow-sm flex items-center gap-5">
                            <div class="size-10 bg-[#C8A97E]/10 rounded-xl flex items-center justify-center text-[#C8A97E]">
                                <span class="material-symbols-outlined text-[20px]">{{ item.icon }}</span>
                            </div>
                            <div>
                                <p class="text-xs text-[#C8A97E] font-bold uppercase tracking-widest italic opacity-80 mb-1">{{ item.label }}</p>
                                <p class="font-bold text-base text-gray-800">{{ item.val || '---' }}</p>
                            </div>
                        </div>
                    </div>

                    <!-- HISTORY BOX -->
                    <div class="bg-gray-900 rounded-[2.5rem] p-8 text-white relative shadow-2xl mt-8 overflow-hidden">
                         <span class="absolute right-[-10%] bottom-[-10%] text-white opacity-[0.03] font-black text-[120px] italic select-none pointer-events-none">LUXURY</span>
                         <p class="text-xs font-bold text-[#C8A97E] uppercase tracking-widest mb-6 flex items-center gap-2">
                             <span class="size-2 bg-[#C8A97E] rounded-full"></span>
                             Tiến trình thời gian
                         </p>
                         <div class="space-y-6">
                            <div class="flex items-start gap-4">
                                <div class="size-1.5 bg-[#C8A97E] rounded-full mt-2"></div>
                                <div>
                                    <p class="text-xs text-white/50 font-bold uppercase tracking-widest mb-1">Ngày tạo</p>
                                    <p class="font-bold text-sm tracking-tight">{{ formatDate(originalProduct?.ngayTao) }}</p>
                                </div>
                            </div>
                            <div class="flex items-start gap-4">
                                <div class="size-1.5 bg-white/20 rounded-full mt-2"></div>
                                <div>
                                    <p class="text-xs text-white/50 font-bold uppercase tracking-widest mb-1">Cập nhật cuối</p>
                                    <p class="font-bold text-sm italic tracking-tight opacity-90">{{ formatDate(originalProduct?.ngayCapNhat) }}</p>
                                </div>
                            </div>
                         </div>
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
  name: 'EditProduct',
  data() {
    return {
      loading: true,
      saving: false,
      originalProduct: null,
      form: {
        maSP: null,
        tenSP: '',
        anhChinh: '',
        giaBan: 0,
        moTa: '',
        trangThaiSP: 1
      }
    }
  },
  methods: {
    async fetchData() {
      const productId = this.$route.params.id;
      this.loading = true;
      try {
        const res = await axios.get(`/admin/products/${productId}`);
        const p = res.data;
        if (!p) throw new Error("Thông tin sản phẩm không tồn tại");

        this.originalProduct = p;
        const basePrice = (p.variants && p.variants.length > 0) ? p.variants[0].giaBan : 0;
	
        this.form = {
          maSP: p.maSP,
          tenSP: p.tenSP,
          anhChinh: p.anhChinh || '',
          giaBan: basePrice,
          moTa: p.moTa || '',
          trangThaiSP: p.trangThaiSP ?? 1
        };

      } catch (e) {
        console.error("Lỗi FetchData:", e);
        if (window.$alert) window.$alert(e.message || 'Hệ thống gián đoạn!', 'Lỗi');
        this.$router.push('/admin/products');
      } finally {
        this.loading = false;
      }
    },

	async updateProduct() {
	  if (!this.form.tenSP.trim()) return alert("Tên sản phẩm bắt buộc nhập");
	  if (this.form.giaBan < 0) return alert("Giá trị không hợp lệ");

	  this.saving = true;
	  try {
	    const payload = { 
	        ...this.originalProduct,
	        tenSP: this.form.tenSP,
	        anhChinh: this.form.anhChinh,
	        moTa: this.form.moTa,
	        trangThaiSP: this.form.trangThaiSP,
			maSP: this.form.maSP
	    };

	    // ❌ TẠM THỜI KHÔNG ĐỤNG VARIANTS

	    const response = await axios.post('/admin/products', payload);
	    
	    if (response.data) {
	      window.$toast?.success('Dữ liệu đã được lưu thành công!');
	      this.$router.push('/admin/products');
	    }
	  } catch (e) {
	    console.error("Lỗi Update:", e);
	    alert('Cảnh báo: ' + (e.response?.data?.message || 'Lỗi lưu dữ liệu'));
	  } finally {
	    this.saving = false;
	  }
	},

    formatDate(date) {
        if (!date) return 'NaN';
        return new Date(date).toLocaleDateString('vi-VN', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    },

    onImgError(e) {
      e.target.src = '/img/placeholder.png';
    }
  },
  mounted() {
    this.fetchData();
  }
}
</script>

<style scoped>
* {
    font-family: 'Times New Roman', Times, serif !important;
}

.material-symbols-outlined {
    font-family: 'Material Symbols Outlined' !important;
}

input, textarea {
  box-shadow: none !important;
  -webkit-appearance: none;
}

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
input[type=number] {
  -moz-appearance: textfield;
}

.animate-in {
  animation-fill-mode: both;
}

::selection {
  background: #C8A97E;
  color: white;
}

button, input, textarea {
    transition: all 0.25s ease;
}
</style>