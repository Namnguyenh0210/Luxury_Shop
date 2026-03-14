<template>
  <AdminLayout page-title="Quản Lý Sản Phẩm & Danh Mục">
    <div class="max-w-[1200px] mx-auto p-8 space-y-6">
      
      <!-- NAVIGATION TABS -->
      <div class="flex gap-1 bg-gray-100 p-1 rounded-2xl w-fit">
        <button 
          @click="activeTab = 'products'"
          :class="activeTab === 'products' ? 'bg-white shadow-sm text-yellow-700' : 'text-gray-500 hover:text-gray-700'"
          class="px-6 py-2.5 rounded-xl text-sm font-bold transition-all flex items-center gap-2"
        >
          <span class="material-symbols-outlined text-[20px]">inventory_2</span>
          Sản phẩm
        </button>
        <button 
          @click="activeTab = 'categories'"
          :class="activeTab === 'categories' ? 'bg-white shadow-sm text-yellow-700' : 'text-gray-500 hover:text-gray-700'"
          class="px-6 py-2.5 rounded-xl text-sm font-bold transition-all flex items-center gap-2"
        >
          <span class="material-symbols-outlined text-[20px]">category</span>
          Danh mục
        </button>
      </div>

      <!-- PRODUCT TAB -->
      <div v-if="activeTab === 'products'" class="space-y-6">
        <!-- ACTION BAR -->
        <div class="flex items-center justify-between gap-4">
          <div class="flex items-center gap-3 overflow-x-auto no-scrollbar">
            <div class="relative">
              <span class="absolute inset-y-0 left-3 flex items-center text-gray-400">
                <span class="material-symbols-outlined text-[18px]">search</span>
              </span>
              <input
                v-model="filters.keyword"
                @input="fetchProducts"
                placeholder="Tìm sản phẩm..."
                class="border border-gray-200 rounded-xl pl-9 pr-4 py-2.5 text-sm bg-white focus:outline-none focus:border-[#001f3f] focus:ring-1 focus:ring-[#001f3f] hover:border-[#001f3f] transition-all w-56"
              />
            </div>

            <select v-model="filters.categoryId" @change="fetchProducts"
              class="border border-gray-200 rounded-xl pl-4 pr-10 py-2.5 text-sm bg-white focus:outline-none focus:border-[#001f3f] focus:ring-1 focus:ring-[#001f3f] hover:border-[#001f3f] transition-all cursor-pointer min-w-[160px]">
              <option value="">Tất cả danh mục</option>
              <option v-for="c in categories" :key="c.maLoai" :value="c.maLoai">{{ c.tenLoai }}</option>
            </select>

            <select v-model="filters.brandId" @change="fetchProducts"
              class="border border-gray-200 rounded-xl pl-4 pr-10 py-2.5 text-sm bg-white focus:outline-none focus:border-[#001f3f] focus:ring-1 focus:ring-[#001f3f] hover:border-[#001f3f] transition-all cursor-pointer min-w-[160px]">
              <option value="">Tất cả thương hiệu</option>
              <option v-for="b in brands" :key="b.maTH" :value="b.maTH">{{ b.tenTH }}</option>
            </select>

            <select v-model="filters.status" @change="fetchProducts"
              class="border border-gray-200 rounded-xl pl-4 pr-10 py-2.5 text-sm bg-white focus:outline-none focus:border-[#001f3f] focus:ring-1 focus:ring-[#001f3f] hover:border-[#001f3f] transition-all cursor-pointer min-w-[150px]">
              <option value="">Tất cả trạng thái</option>
              <option value="1">Đang bán</option>
              <option value="0">Ngừng bán (Ẩn)</option>
            </select>
          </div>
        </div>

        <!-- PRODUCT TABLE -->
        <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
          <table class="w-full text-sm border-collapse" style="table-layout: fixed;">
            <thead class="bg-gray-50 border-b border-gray-200">
              <tr>
                <th class="px-4 py-4 text-xs font-semibold text-gray-500 uppercase w-[10%] text-center">ID</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-left w-[30%]">Tên Sản Phẩm</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[15%]">Danh Mục</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[15%]">Thương Hiệu</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[15%]">Trạng Thái</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[15%]">Hành Động</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr v-for="p in products" :key="p.id" class="hover:bg-yellow-50/50 transition-colors cursor-pointer" @click="openDetails(p.maSP)">
                <td class="px-4 py-4 font-mono text-xs text-gray-500 text-center">#{{ p.maSP }}</td>
                <td class="px-6 py-4 font-semibold text-gray-800 text-left truncate">{{ p.tenSP }}</td>
                <td class="px-6 py-4 text-gray-600 text-center truncate">{{ p.loaiSanPham?.tenLoai }}</td>
                <td class="px-6 py-4 text-gray-600 text-center truncate">{{ p.thuongHieu?.tenTH }}</td>
                <td class="px-6 py-4">
                  <span class="inline-flex items-center px-2.5 py-1 text-xs font-medium rounded-full"
                    :class="p.trangThaiSP == 1 ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'">
                    <span class="size-1.5 rounded-full mr-1.5" :class="p.trangThaiSP == 1 ? 'bg-green-500' : 'bg-red-500'"></span>
                    {{ p.trangThaiSP == 1 ? 'Đang bán' : 'Ngừng bán' }}
                  </span>
                </td>
                <td class="px-6 py-4" @click.stop>
                  <div class="flex justify-center gap-2">
                    <button @click="toggleStatus(p)" class="p-2 rounded-lg hover:bg-gray-100 text-gray-600 transition-all" :title="p.trangThaiSP == 1 ? 'Ẩn sản phẩm' : 'Hiện sản phẩm'">
                      <span class="material-symbols-outlined text-[20px]">
                        {{ p.trangThaiSP == 1 ? 'visibility' : 'visibility_off' }}
                      </span>
                    </button>
                    <button @click="editProduct(p)" class="p-2 rounded-lg hover:bg-yellow-50 text-yellow-700 transition-all" title="Sửa">
                      <span class="material-symbols-outlined text-[20px]">edit</span>
                    </button>
                    <button @click="deleteProduct(p.maSP)" class="p-2 rounded-lg hover:bg-red-50 text-red-600 transition-all" title="Xóa">
                      <span class="material-symbols-outlined text-[20px]">delete</span>
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <div v-if="products.length === 0" class="flex flex-col items-center justify-center py-16 text-gray-400">
            <span class="material-symbols-outlined text-5xl mb-3">inventory_2</span>
            <p class="text-sm">Không có sản phẩm nào</p>
          </div>
        </div>
      </div>

      <!-- CATEGORY TAB -->
      <div v-else class="space-y-6">

        <!-- CATEGORY TABLE -->
        <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
          <table class="w-full text-sm border-collapse" style="table-layout: fixed;">
            <thead class="bg-gray-50 border-b border-gray-200">
              <tr>
                <th class="px-4 py-4 text-xs font-semibold text-gray-500 uppercase w-[10%] text-center">ID</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-left w-[25%]">Tên danh mục</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-left w-[35%]">Mô tả</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[15%]">Trạng thái</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[15%]">Hành động</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr v-for="c in categories" :key="c.maLoai" class="hover:bg-yellow-50/50 transition-colors cursor-pointer" @click="openCategoryModal(c)">
                <td class="px-4 py-4 font-mono text-xs text-gray-500 text-center">#{{ c.maLoai }}</td>
                <td class="px-6 py-4 font-bold text-gray-800 text-left truncate">{{ c.tenLoai }}</td>
                <td class="px-6 py-4 text-gray-500 italic text-left text-xs truncate pr-4">{{ c.moTa || 'Chưa có mô tả' }}</td>
                <td class="px-6 py-4 text-center">
                  <span class="inline-flex items-center px-2.5 py-1 text-[10px] font-bold rounded-full"
                    :class="c.trangThai == 1 ? 'bg-blue-50 text-blue-600' : 'bg-gray-100 text-gray-500'">
                    {{ c.trangThai == 1 ? 'Hiển thị' : 'Đang ẩn' }}
                  </span>
                </td>
                <td class="px-6 py-4 text-center">
                   <div class="flex justify-center gap-2">
                    <button @click="toggleCategoryStatus(c)" class="p-2 rounded-lg hover:bg-gray-100 text-gray-600 transition-all" :title="c.trangThai == 1 ? 'Ẩn danh mục' : 'Hiện danh mục'">
                      <span class="material-symbols-outlined text-[20px]">
                        {{ c.trangThai == 1 ? 'visibility' : 'visibility_off' }}
                      </span>
                    </button>
                    <button @click="openCategoryModal(c)" class="p-2 rounded-lg hover:bg-blue-50 text-blue-600 transition-all" title="Sửa">
                      <span class="material-symbols-outlined text-[20px]">edit</span>
                    </button>
                    <button @click="deleteCategory(c.maLoai)" class="p-2 rounded-lg hover:bg-red-50 text-red-600 transition-all" title="Xóa">
                      <span class="material-symbols-outlined text-[20px]">delete</span>
                    </button>
                   </div>
                </td>
              </tr>
            </tbody>
          </table>
          <div v-if="categories.length === 0" class="flex flex-col items-center justify-center py-16 text-gray-400">
            <span class="material-symbols-outlined text-5xl mb-3">category</span>
            <p class="text-sm">Không có danh mục nào</p>
          </div>
        </div>
      </div>
    </div>

    <!-- PRODUCT DETAIL MODAL -->
    <div v-if="showDetails" class="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4" @click.self="showDetails=false">
      <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg overflow-hidden">
        <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100 bg-gray-50">
          <h3 class="text-base font-bold text-gray-800">{{ selectedProduct?.tenSP }}</h3>
          <button @click="showDetails=false" class="text-gray-400 hover:text-gray-600 transition-colors">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>
        <div class="p-6 space-y-3 text-sm">
          <div v-if="loadingDetails" class="flex justify-center py-8 text-gray-400">
            <span class="material-symbols-outlined animate-spin text-3xl">progress_activity</span>
          </div>
          <template v-else>
            <div class="flex justify-center mb-6">
              <img v-if="selectedProduct?.anhChinh" :src="selectedProduct.anhChinh" class="h-48 w-48 object-cover rounded-xl shadow-md border" alt="Product image" />
              <div v-else class="h-48 w-48 bg-gray-100 rounded-xl flex items-center justify-center text-gray-300">
                <span class="material-symbols-outlined text-5xl">image_not_supported</span>
              </div>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div class="p-3 bg-gray-50 rounded-xl">
                <p class="text-[10px] text-gray-400 uppercase font-bold mb-1">Danh mục</p>
                <p class="font-medium text-gray-800">{{ selectedProduct?.loaiSanPham?.tenLoai }}</p>
              </div>
              <div class="p-3 bg-gray-50 rounded-xl">
                <p class="text-[10px] text-gray-400 uppercase font-bold mb-1">Thương hiệu</p>
                <p class="font-medium text-gray-800">{{ selectedProduct?.thuongHieu?.tenTH }}</p>
              </div>
            </div>
            <div class="p-4 bg-gray-50 rounded-xl">
              <p class="text-[10px] text-gray-400 uppercase font-bold mb-2">Mô tả sản phẩm</p>
              <p class="text-gray-700 leading-relaxed text-xs">{{ selectedProduct?.moTa || 'Chưa có mô tả chi tiết' }}</p>
            </div>
          </template>
        </div>
        <div class="px-6 py-4 border-t border-gray-100 flex justify-end">
          <button @click="showDetails=false" class="px-6 py-2 rounded-xl bg-gray-100 hover:bg-gray-200 text-sm font-bold text-gray-600 transition-all">Đóng</button>
        </div>
      </div>
    </div>

    <!-- CATEGORY MODAL (CRUD) -->
    <div v-if="categoryModal.show" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
      <div class="bg-white rounded-3xl shadow-2xl w-full max-w-md overflow-hidden transform transition-all scale-100">
        <div class="p-6 border-b border-gray-100 flex items-center justify-between bg-gray-50/50">
          <h3 class="text-lg font-bold text-gray-800">
            {{ categoryModal.form.maLoai ? 'Cập nhật danh mục' : 'Thêm danh mục mới' }}
          </h3>
          <button @click="categoryModal.show = false" class="text-gray-400 hover:text-gray-600">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>
        <form @submit.prevent="saveCategory" class="p-6 space-y-5">
          <div class="space-y-2">
            <label class="text-sm font-bold text-gray-700">Tên danh mục</label>
            <input 
              v-model="categoryModal.form.tenLoai"
              type="text" 
              required
              placeholder="VD: Áo Polo, Quần Tây..."
              class="w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-yellow-400 outline-none transition-all"
            />
          </div>
          <div class="space-y-2">
            <label class="text-sm font-bold text-gray-700">Mô tả</label>
            <textarea 
              v-model="categoryModal.form.moTa"
              rows="3"
              placeholder="Nhập mô tả ngắn cho danh mục..."
              class="w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-yellow-400 outline-none transition-all resize-none"
            ></textarea>
          </div>
          <div class="flex items-center justify-end gap-3 pt-4">
            <button type="button" @click="categoryModal.show = false" class="px-5 py-2.5 rounded-xl border border-gray-200 text-gray-500 font-bold hover:bg-gray-50 transition-all">Hủy</button>
            <button type="submit" class="px-6 py-2.5 rounded-xl bg-yellow-400 hover:bg-yellow-500 text-yellow-900 font-bold shadow-lg shadow-yellow-100 transition-all">
              {{ categoryModal.form.maLoai ? 'Lưu thay đổi' : 'Tạo ngay' }}
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
  name: 'ProductList',
  components: { AdminLayout },

  data() {
    return {
      activeTab: 'products', // 'products' or 'categories'
      products: [],
      categories: [],
      brands: [],
      filters: { keyword: '', categoryId: '', brandId: '', status: '' },
      
      // Product details
      showDetails: false,
      selectedProduct: null,
      loadingDetails: false,

      // Category CRUD modal
      categoryModal: {
        show: false,
        form: { maLoai: null, tenLoai: '', moTa: '', trangThai: 1 }
      }
    }
  },

  methods: {
    // PRODUCTS
    async fetchProducts() {
      try {
        const res = await axios.get('/admin/products', { params: this.filters })
        this.products = res.data
      } catch (e) { console.error(e) }
    },

    async toggleStatus(product) {
      const newStatus = product.trangThaiSP == 1 ? 0 : 1;
      try {
        await axios.post('/admin/products', {
          ...product,
          trangThaiSP: newStatus
        });
        this.fetchProducts();
      } catch (e) { alert('Lỗi khi thay đổi trạng thái sản phẩm'); }
    },

    async openDetails(id) {
      this.showDetails = true
      this.loadingDetails = true
      try {
        const res = await axios.get(`/admin/products/${id}`)
        this.selectedProduct = res.data
      } catch (e) { console.error(e) }
      finally { this.loadingDetails = false }
    },

    editProduct(product) {
      this.$router.push(`/admin/products/edit/${product.maSP}`)
    },

    async deleteProduct(id) {
      if (!confirm('Xác nhận xóa sản phẩm này? Nội dung sẽ biến mất vĩnh viễn.')) return
      try {
        await axios.delete(`/admin/products/${id}`)
        this.fetchProducts()
      } catch(e) { alert('Không thể xóa sản phẩm này!') }
    },

    // CATEGORIES
    async fetchCategories() {
      try {
        const res = await axios.get('/admin/categories')
        this.categories = res.data
      } catch (e) { console.error(e) }
    },

    async toggleCategoryStatus(category) {
      const newStatus = category.trangThai == 1 ? 0 : 1;
      try {
        await axios.post('/admin/categories', {
          ...category,
          trangThai: newStatus
        });
        this.fetchCategories();
      } catch (e) { alert('Lỗi khi thay đổi trạng thái danh mục'); }
    },

    async fetchBrands() {
      try {
        const res = await axios.get('/admin/brands')
        this.brands = res.data
      } catch (e) { console.error(e) }
    },

    openCategoryModal(category = null) {
      if (category) {
        this.categoryModal.form = { ...category }
      } else {
        this.categoryModal.form = { maLoai: null, tenLoai: '', moTa: '', trangThai: 1 }
      }
      this.categoryModal.show = true
    },

    async saveCategory() {
      try {
        await axios.post('/admin/categories', this.categoryModal.form)
        alert(this.categoryModal.form.maLoai ? 'Cập nhật thành công!' : 'Thêm mới thành công!')
        this.categoryModal.show = false
        this.fetchCategories()
      } catch (e) {
        alert('Lỗi: ' + (e.response?.data?.message || 'Không thể lưu danh mục'))
      }
    },

    async deleteCategory(id) {
      if (!confirm('Xóa danh mục này có thể ảnh hưởng đến các sản phẩm thuộc danh mục. Bạn chắc chắn chứ?')) return
      try {
        await axios.delete(`/admin/categories/${id}`)
        this.fetchCategories()
      } catch(e) {
        alert('Không thể xóa danh mục này (có thể do đang chứa sản phẩm)')
      }
    }
  },

  mounted() {
    this.fetchProducts()
    this.fetchCategories()
    this.fetchBrands()
  }
}
</script>