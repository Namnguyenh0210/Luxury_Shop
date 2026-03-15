<template>
  <AdminLayout page-title="Thêm Sản Phẩm Mới">
    <div class="p-8 max-w-4xl mx-auto">
      <button @click="$router.back()" class="flex items-center text-gray-500 hover:text-yellow-600 mb-6 transition-colors">
        <span class="material-symbols-outlined mr-1">arrow_back</span>
        Trở về danh sách
      </button>

      <div class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm overflow-hidden text-sm">
        <div class="p-6 border-b border-gray-100 bg-gray-50/50">
          <h2 class="text-lg font-bold text-gray-800">Tạo sản phẩm mới</h2>
        </div>

        <form @submit.prevent="saveProduct" class="p-8 space-y-6">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="space-y-2 md:col-span-2">
              <label class="text-sm font-semibold text-gray-700">Tên sản phẩm</label>
              <input v-model="form.tenSP" type="text" required placeholder="Nhập tên sản phẩm..."
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
              <label class="text-sm font-semibold text-gray-700">URL Ảnh chính</label>
              <input v-model="form.anhChinh" type="text" placeholder="https://..."
                class="w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 focus:ring-2 focus:ring-[#C8A97E]/30 outline-none transition-all" />
            </div>

            <div class="space-y-2 md:col-span-2">
              <label class="text-sm font-semibold text-gray-700">Mô tả chi tiết</label>
              <textarea v-model="form.moTa" rows="5" placeholder="Nhập mô tả sản phẩm..."
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
              Thêm sản phẩm
            </button>
          </div>
        </form>
      </div>
    </div>
  </AdminLayout>
</template>

<script>
import AdminLayout from './AdminLayout.vue'
import axios from 'axios'

export default {
  name: 'AddProduct',
  components: { AdminLayout },
  data() {
    return {
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
      try {
        const [catRes, brandRes] = await Promise.all([
          axios.get('/admin/categories'),
          axios.get('/admin/brands')
        ]);
        this.categories = catRes.data;
        this.brands = brandRes.data;
      } catch (e) {
        console.error("Lỗi FetchData:", e);
      }
    },

    async saveProduct() {
      this.saving = true;
      try {
        const response = await axios.post('/admin/products', this.form);
        if (response.data) {
          alert('Thêm sản phẩm thành công!');
          this.$router.push('/admin/products');
        }
      } catch (e) {
        alert('Lỗi: ' + (e.response?.data?.message || 'Không thể tạo sản phẩm'));
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
