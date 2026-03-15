<template>
  <AdminLayout page-title="Chỉnh Sửa Sản Phẩm">
    <div class="p-8 max-w-4xl mx-auto">
      <button @click="$router.back()" class="flex items-center text-gray-500 hover:text-yellow-600 mb-6 transition-colors">
        <span class="material-symbols-outlined mr-1">arrow_back</span>
        Trở về danh sách
      </button>

      <div class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm overflow-hidden text-sm">
        <div class="p-6 border-b border-gray-100 bg-gray-50/50">
          <h2 class="text-lg font-bold text-gray-800">Thông tin sản phẩm #{{ $route.params.id }}</h2>
        </div>

        <form @submit.prevent="updateProduct" class="p-8 space-y-6">
          <div v-if="loading" class="flex flex-col items-center py-12 text-gray-400">
            <span class="material-symbols-outlined animate-spin text-4xl mb-2">progress_activity</span>
            <p>Đang tải dữ liệu...</p>
          </div>

          <template v-else>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div class="space-y-2 md:col-span-2">
                <label class="text-sm font-semibold text-gray-700">Tên sản phẩm</label>
                <input v-model="form.tenSP" type="text" required
                  class="w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 focus:ring-2 focus:ring-[#C8A97E]/30 outline-none transition-all" />
              </div>

              <div class="space-y-2">
                <label class="text-sm font-semibold text-gray-700">Danh mục</label>
                <select v-model="form.loaiSanPham.maLoai" required
                  class="w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 focus:ring-2 focus:ring-[#C8A97E]/30 outline-none transition-all bg-white">
                  <option value="" disabled>Chọn danh mục</option>
                  <option v-for="c in categories" :key="c.maLoai" :value="c.maLoai">{{ c.tenLoai }}</option>
                </select>
              </div>

              <div class="space-y-2">
                <label class="text-sm font-semibold text-gray-700">Thương hiệu</label>
                <select v-model="form.thuongHieu.maTH" required
                  class="w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 focus:ring-2 focus:ring-[#C8A97E]/30 outline-none transition-all bg-white">
                  <option value="" disabled>Chọn thương hiệu</option>
                  <option v-for="b in brands" :key="b.maTH" :value="b.maTH">{{ b.tenTH }}</option>
                </select>
              </div>

              <div class="space-y-2">
                <label class="text-sm font-semibold text-gray-700">Giới tính</label>
                <select v-model="form.gioiTinh" class="w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 focus:ring-2 focus:ring-[#C8A97E]/30 outline-none transition-all bg-white">
                  <option :value="0">Nam</option>
                  <option :value="1">Nữ</option>
                  <option :value="2">Unisex</option>
                </select>
              </div>

              <div class="space-y-2">
                <label class="text-sm font-semibold text-gray-700">Trạng thái kinh doanh</label>
                <div class="flex gap-4 p-1 bg-gray-100 rounded-xl w-fit">
                  <button type="button" @click="form.trangThaiSP = 1"
                    :class="form.trangThaiSP == 1 ? 'bg-white shadow-sm text-green-600' : 'text-gray-500'"
                    class="px-4 py-1.5 rounded-lg text-sm font-medium transition-all">Đang bán</button>
                  <button type="button" @click="form.trangThaiSP = 0"
                    :class="form.trangThaiSP == 0 ? 'bg-white shadow-sm text-red-600' : 'text-gray-500'"
                    class="px-4 py-1.5 rounded-lg text-sm font-medium transition-all">Ngừng bán</button>
                </div>
              </div>

              <div class="space-y-2 md:col-span-2">
                <label class="text-sm font-semibold text-gray-700">Mô tả chi tiết</label>
                <textarea v-model="form.moTa" rows="5"
                  class="w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 focus:ring-2 focus:ring-[#C8A97E]/30 outline-none transition-all resize-none"></textarea>
              </div>
            </div>

            <div class="flex items-center justify-end gap-3 pt-6 border-t border-gray-100">
              <button type="button" @click="$router.back()"
                class="px-6 py-2.5 rounded-xl border border-gray-200 text-gray-600 hover:bg-gray-50 font-medium transition-all">
                Hủy bỏ
              </button>
              <button type="submit" :disabled="saving"
                class="px-8 py-2.5 rounded-xl bg-yellow-400 hover:bg-yellow-500 text-yellow-900 font-bold shadow-lg shadow-yellow-200 transition-all disabled:opacity-50 flex items-center">
                <span v-if="saving" class="material-symbols-outlined animate-spin mr-2 text-sm">progress_activity</span>
                Lưu thay đổi
              </button>
            </div>
          </template>
        </form>
      </div>
    </div>
  </AdminLayout>
</template>

<script>
import AdminLayout from './AdminLayout.vue'
import axios from 'axios'

export default {
  name: 'EditProduct',
  components: { AdminLayout },
  data() {
    return {
      loading: true,
      saving: false,
      categories: [],
      brands: [],
      form: {
        maSP: null,
        tenSP: '',
        loaiSanPham: { maLoai: '' },
        thuongHieu: { maTH: '' },
        gioiTinh: 2,
        moTa: '',
        trangThaiSP: 1,
        anhChinh: ''
      }
    }
  },
  methods: {
    async fetchData() {
      const productId = this.$route.params.id;
      try {
        // Gọi song song thông tin sản phẩm và dữ liệu hỗ trợ (nếu có)
        // Lưu ý: Backend cần cho phép ADMIN truy cập các endpoint này
        const [prodRes, catRes, brandRes] = await Promise.allSettled([
          axios.get(`/admin/products/${productId}`),
          axios.get('/admin/categories'), // Cần bổ sung ở Backend
          axios.get('/admin/brands')      // Cần bổ sung ở Backend
        ]);

        if (prodRes.status === 'fulfilled') {
          const p = prodRes.data;
          this.form = {
            maSP: p.maSP,
            tenSP: p.tenSP,
            loaiSanPham: { maLoai: p.loaiSanPham?.maLoai || '' },
            thuongHieu: { maTH: p.thuongHieu?.maTH || '' },
            gioiTinh: p.gioiTinh ?? 2,
            moTa: p.moTa || '',
            trangThaiSP: p.trangThaiSP ?? 1,
            anhChinh: p.anhChinh || '',
            ngayTao: p.ngayTao
          };
        } else {
          throw new Error("Không thể tải thông tin sản phẩm");
        }

        if (catRes.status === 'fulfilled') this.categories = catRes.data;
        if (brandRes.status === 'fulfilled') this.brands = brandRes.data;

      } catch (e) {
        console.error("Lỗi FetchData:", e);
        alert(e.message || 'Lỗi kết nối Server!');
        this.$router.push('/admin/products');
      } finally {
        this.loading = false;
      }
    },

    async updateProduct() {
      this.saving = true;
      try {
        // Theo Controller của bạn: @PostMapping xử lý cả thêm mới và cập nhật
        // Nếu maSP != null -> Backend setNgayCapNhat() và thực hiện save (Merge)
        const response = await axios.post('/admin/products', this.form);
        
        if (response.data) {
          alert('Cập nhật thành công!');
          this.$router.push('/admin/products');
        }
      } catch (e) {
        console.error("Lỗi Update:", e);
        // Kiểm tra lỗi 403 (Chưa đăng nhập ADMIN)
        if (e.response?.status === 403) {
          alert("Bạn không có quyền thực hiện hành động này!");
        } else {
          alert('Lỗi: ' + (e.response?.data?.message || 'Không thể lưu sản phẩm'));
        }
      } finally {
        this.saving = false;
      }
    }
  },
  mounted() {
    this.fetchData();
  }
}
</script>