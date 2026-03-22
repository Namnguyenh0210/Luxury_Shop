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
                                <input type="text"
                                    :value="formatCurrency(form.giaBan)"
                                    @input="e => form.giaBan = parseCurrency(e.target.value)"
                                    @blur="e => e.target.value = formatCurrency(form.giaBan)"
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

        <!-- FRAME 3: VARIANTS (BOTTOM - FULL WIDTH) -->
        <div class="lg:col-span-12 mt-4 bg-white rounded-[3.5rem] border border-[#C8A97E]/30 p-12 shadow-[0_30px_100px_rgba(200,169,126,0.1)] relative overflow-hidden group/variants">
             <!-- Background Luxury Watermark -->
             <span class="absolute right-[-5%] top-[-5%] text-[#C8A97E]/5 font-black text-[150px] italic pointer-events-none select-none">SKU</span>

             <div class="flex items-center justify-between mb-12 relative z-10">
                <div class="flex items-center gap-6">
                   <div class="size-20 bg-gradient-to-br from-[#C8A97E]/20 to-[#C8A97E]/5 rounded-3xl flex items-center justify-center text-[#C8A97E] shadow-inner border border-[#C8A97E]/20">
                      <span class="material-symbols-outlined text-[40px]">inventory_2</span>
                   </div>
                   <div>
                      <h2 class="text-3xl font-black text-gray-900 tracking-tight uppercase leading-none">Danh sách biến thể</h2>
                      <p class="text-[11px] text-[#C8A97E] font-black uppercase tracking-[0.4em] italic mt-2 opacity-80">Cấu hình chi tiết kích thước, màu sắc & giá lẻ</p>
                   </div>
                </div>
             </div>

             <div class="overflow-x-auto custom-scrollbar relative z-10">
                <table class="w-full border-separate border-spacing-y-4 px-2">
                   <thead>
                      <tr class="text-[11px] font-black uppercase tracking-[0.2em] text-[#C8A97E]/60 text-left">
                         <th class="px-10 pb-4">Kích thước</th>
                         <th class="px-10 pb-4">Màu sắc</th>
                         <th class="px-10 pb-4 text-center">Tồn kho</th>
                         <th class="px-10 pb-4">Giá bán lẻ (VNĐ)</th>
                         <th class="px-10 pb-4 text-center">Trạng thái</th>
                         <th class="px-10 pb-4 text-right">Tùy chọn</th>
                      </tr>
                   </thead>
                   <tbody>
                      <tr v-for="(v, idx) in variants" :key="idx" 
                          class="bg-[#FCFAF7] hover:bg-white hover:shadow-[0_15px_40px_rgba(200,169,126,0.15)] transition-all duration-500 rounded-[2.5rem] group/v-item border border-transparent hover:border-[#C8A97E]/30">
                         <!-- Size -->
                         <td class="px-4 py-5 first:rounded-l-[2.5rem]">
                            <div class="w-full bg-white border border-[#C8A97E]/10 rounded-2xl px-5 py-3 text-sm font-black text-gray-800 text-center shadow-sm relative overflow-hidden">
                               {{ getVariantSizeName(v.maSize) }}
                            </div>
                         </td>
                         <!-- Color -->
                         <td class="px-4 py-5">
                            <div class="w-full bg-white border border-[#C8A97E]/10 rounded-2xl px-5 py-3 text-sm font-black text-gray-800 text-center shadow-sm relative overflow-hidden">
                               {{ getVariantColorName(v.maMau) }}
                            </div>
                         </td>
                         <!-- Stock -->
                         <td class="px-10 py-5 text-center">
                            <div class="inline-flex flex-col items-center">
                                <span class="text-xl font-black text-gray-900 leading-none">{{ v.soLuongTon || 0 }}</span>
                                <span class="text-[9px] text-[#C8A97E] font-black uppercase tracking-widest mt-1 opacity-60">Sản phẩm</span>
                            </div>
                         </td>
                         <!-- Price -->
                         <td class="px-4 py-5">
                            <div class="relative group/price-input">
                               <input type="text" 
                                      :value="formatCurrency(v.giaBan)"
                                      @input="e => v.giaBan = parseCurrency(e.target.value)"
                                      @blur="e => e.target.value = formatCurrency(v.giaBan)"
                                      class="w-full bg-white border border-[#C8A97E]/20 rounded-2xl px-6 py-3 text-base font-black text-gray-900 placeholder-gray-300 focus:border-[#C8A97E] focus:ring-1 focus:ring-[#C8A97E] outline-none transition-all shadow-sm pr-10">
                               <span class="absolute right-4 top-1/2 -translate-y-1/2 text-[12px] text-[#C8A97E] font-black italic">đ</span>
                            </div>
                         </td>
                         <!-- Status Switch -->
                         <td class="px-10 py-5 text-center">
                            <div class="flex flex-col items-center gap-2">
                                <label class="relative inline-flex items-center cursor-pointer scale-110">
                                  <input type="checkbox" v-model="v.trangThai" class="sr-only peer">
                                  <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-[#C8A97E]"></div>
                                </label>
                                <span class="text-[9px] font-black uppercase tracking-[0.2em]" :class="v.trangThai ? 'text-green-600' : 'text-gray-400'">
                                    {{ v.trangThai ? 'Đang bán' : 'Tạm ẩn' }}
                                </span>
                            </div>
                         </td>
                         <!-- Delete Action -->
                         <td class="px-10 py-5 text-right last:rounded-r-[2.5rem]">
                            <button v-if="v.soLuongTon === 0" @click.prevent="removeVariant(idx)" 
                                class="size-12 bg-white border border-red-50 rounded-2xl flex items-center justify-center text-red-300 hover:text-white hover:bg-red-500 hover:border-red-500 transition-all shadow-sm hover:shadow-lg hover:shadow-red-500/20 active:scale-90 ml-auto" title="Xóa tùy chọn">
                               <span class="material-symbols-outlined text-[24px]">delete_outline</span>
                            </button>
                            <div v-else class="size-12 bg-gray-50 border border-gray-100 rounded-2xl flex items-center justify-center text-gray-300 ml-auto cursor-not-allowed group/hint relative" title="Chỉ được xóa khi tồn kho = 0">
                               <span class="material-symbols-outlined text-[24px]">delete_outline</span>
                               <!-- Tooltip on hover -->
                               <span class="absolute right-full mr-2 opacity-0 group-hover/hint:opacity-100 transition-opacity whitespace-nowrap bg-gray-800 text-white text-[10px] uppercase font-bold px-3 py-1.5 rounded-lg tracking-widest pointer-events-none z-20">Không thể xóa khi còn tồn</span>
                            </div>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </div>
             
             <!-- EMPTY STATE -->
             <div v-if="variants.length === 0" class="flex flex-col items-center justify-center py-28 text-gray-400 bg-[#FCFAF7] rounded-[3rem] border-2 border-dashed border-[#C8A97E]/30 mt-10">
                <div class="size-24 bg-white rounded-full flex items-center justify-center shadow-xl mb-8 border border-[#C8A97E]/10">
                    <span class="material-symbols-outlined text-5xl text-[#C8A97E]/20">inventory_2</span>
                </div>
                <h3 class="text-lg font-black text-gray-800 tracking-tight text-center">Sản phẩm chưa có lựa chọn phân loại</h3>
                <p class="text-sm text-[#C8A97E] italic mt-2 opacity-70">Các biến thể cụ thể (Màu sắc, Size) sẽ được tự tạo thông qua phiếu tạo và nhập kho.</p>
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
        trangThaiSP: 1,
        maLoai: '',
        maTH: '',
        gioiTinh: 2
      },
      categories: [],
      brands: [],
      sizes: [],
      colors: [],
      variants: []
    }
  },
  methods: {
    async fetchData() {
      const productId = this.$route.params.id;
      this.loading = true;
      try {
        const [prodRes, catRes, brandRes, sizeRes, colorRes] = await Promise.all([
          axios.get(`/admin/products/${productId}`),
          axios.get('/admin/categories'),
          axios.get('/admin/brands'),
          axios.get('/admin/products/sizes'),
          axios.get('/admin/products/colors')
        ]);

        const p = prodRes.data;
        if (!p) throw new Error("Thông tin sản phẩm không tồn tại");

        this.originalProduct = p;
        this.categories = catRes.data;
        this.brands = brandRes.data;
        this.sizes = sizeRes.data;
        this.colors = colorRes.data;
        const sizeOrder = ['S', 'M', 'L', 'XL', 'XXL', '2XL', '3XL'];
        this.variants = (p.variants || []).map(v => ({
            ...v,
            maSize: v.sizeSP?.maSize || '',
            maMau: v.mauSacSP?.maMau || ''
        })).sort((a, b) => {
            const tenA = a.sizeSP?.tenSize?.toUpperCase() || '';
            const tenB = b.sizeSP?.tenSize?.toUpperCase() || '';
            const idxA = sizeOrder.indexOf(tenA);
            const idxB = sizeOrder.indexOf(tenB);
            
            if (idxA === -1 && idxB === -1) return tenA.localeCompare(tenB);
            if (idxA === -1) return 1;
            if (idxB === -1) return -1;
            return idxA - idxB;
        });

        const basePrice = (p.variants && p.variants.length > 0) ? p.variants[0].giaBan : 0;
	
        this.form = {
          maSP: p.maSP,
          tenSP: p.tenSP,
          anhChinh: p.anhChinh || '',
          giaBan: basePrice,
          moTa: p.moTa || '',
          trangThaiSP: p.trangThaiSP ?? 1,
          maLoai: p.loaiSanPham?.maLoai || '',
          maTH: p.thuongHieu?.maTH || '',
          gioiTinh: p.gioiTinh ?? 2
        };

      } catch (e) {
        console.error("Lỗi FetchData:", e);
        window.$toast.error(e.message || 'Hệ thống gián đoạn!')
        this.$router.push('/admin/products');
      } finally {
        this.loading = false;
      }
    },

	async updateProduct() {
	  if (!this.form.tenSP.trim()) return window.$toast.warning("Tên sản phẩm bắt buộc nhập");
	  if (this.form.giaBan < 0) return window.$toast.warning("Giá trị không hợp lệ");

	  this.saving = true;
	  try {
        // Tìm object đầy đủ cho các quan hệ
        const selectedCat = this.categories.find(c => c.maLoai == this.form.maLoai);
        const selectedBrand = this.brands.find(b => b.maTH == this.form.maTH);

	    const payload = { 
	        ...this.originalProduct,
	        tenSP: this.form.tenSP,
	        anhChinh: this.form.anhChinh,
	        moTa: this.form.moTa,
	        trangThaiSP: this.form.trangThaiSP,
			maSP: this.form.maSP,
            gioiTinh: this.form.gioiTinh,
            loaiSanPham: selectedCat,
            thuongHieu: selectedBrand,
            variants: this.variants.map(v => {
                // Ensure correct objects for size/color
                const s = this.sizes.find(sz => sz.maSize == v.maSize || sz.maSize == v.sizeSP?.maSize);
                const c = this.colors.find(cl => cl.maMau == v.maMau || cl.maMau == v.mauSacSP?.maMau);
                return {
                    ...v,
                    sizeSP: s,
                    mauSacSP: c,
                    sanPham: { maSP: this.form.maSP }
                };
            })
	    };

	    const response = await axios.post('/admin/products', payload);
	    
	    if (response.data) {
          window.$toast.success('Dữ liệu đã được lưu thành công!')
	      this.$router.push('/admin/products');
	    }
	  } catch (e) {
	    console.error("Lỗi Update:", e);
		const msg = e.response?.data?.message || e.message || 'Lỗi lưu dữ liệu';
	    window.$toast.error('Cảnh báo: ' + msg);
	  } finally {
	    this.saving = false;
	  }
	},


    removeVariant(idx) {
        this.variants.splice(idx, 1);
    },

    formatCurrency(value) {
        if (!value) return '';
        return Number(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    },

    parseCurrency(value) {
        if (!value) return 0;
        const parsed = parseInt(String(value).replace(/,/g, '').replace(/\D/g, ''), 10);
        return isNaN(parsed) ? 0 : parsed;
    },

    getVariantSizeName(id) {
        const s = this.sizes.find(sz => sz.maSize == id);
        return s ? s.tenSize : '---';
    },

    getVariantColorName(id) {
        const c = this.colors.find(cl => cl.maMau == id);
        return c ? c.tenMau : '---';
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
  appearance: none;
}

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  appearance: none;
  margin: 0;
}
input[type=number] {
  -moz-appearance: textfield;
  appearance: textfield;
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
