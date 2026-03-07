<template>
  <AdminLayout page-title="Quản Lý Sản Phẩm">
    <div class="p-8 space-y-6">

      <!-- ACTION BAR -->
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div class="flex flex-wrap gap-3">
          <div class="relative">
            <span class="absolute inset-y-0 left-3 flex items-center text-gray-400">
              <span class="material-symbols-outlined text-[18px]">search</span>
            </span>
            <input
              v-model="filters.keyword"
              @input="fetchProducts"
              placeholder="Tìm sản phẩm..."
              class="border border-gray-200 rounded-xl pl-9 pr-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-yellow-400 w-56"
            />
          </div>

          <select v-model="filters.categoryId" @change="fetchProducts"
            class="border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-yellow-400">
            <option value="">Tất cả danh mục</option>
            <option v-for="c in categories" :key="c.maLoai" :value="c.maLoai">{{ c.tenLoai }}</option>
          </select>

          <select v-model="filters.brandId" @change="fetchProducts"
            class="border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-yellow-400">
            <option value="">Tất cả thương hiệu</option>
            <option v-for="b in brands" :key="b.maTH" :value="b.maTH">{{ b.tenTH }}</option>
          </select>

          <select v-model="filters.status" @change="fetchProducts"
            class="border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-yellow-400">
            <option value="">Tất cả trạng thái</option>
            <option value="1">Đang bán</option>
            <option value="0">Ngừng bán</option>
          </select>
        </div>
      </div>

      <!-- TABLE -->
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <table class="w-full text-sm">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Mã SP</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Tên Sản Phẩm</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Danh Mục</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Thương Hiệu</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Trạng Thái</th>
              <th class="px-6 py-4 text-right text-xs font-semibold text-gray-500 uppercase tracking-wider">Hành Động</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr
              v-for="p in products"
              :key="p.id"
              class="hover:bg-yellow-50/50 transition-colors cursor-pointer"
              @click="openDetails(p.maSP)"
            >
              <td class="px-6 py-4 font-mono text-xs text-gray-500">#{{ p.maSP }}</td>
              <td class="px-6 py-4 font-semibold text-gray-800">{{ p.tenSP }}</td>
              <td class="px-6 py-4 text-gray-600">{{ p.loaiSanPham?.tenLoai }}</td>
              <td class="px-6 py-4 text-gray-600">{{ p.thuongHieu?.tenTH }}</td>
              <td class="px-6 py-4">
                <span class="inline-flex items-center px-2.5 py-1 text-xs font-medium rounded-full"
                  :class="p.trangThaiSP == 1 ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'">
                  <span class="size-1.5 rounded-full mr-1.5"
                    :class="p.trangThaiSP == 1 ? 'bg-green-500' : 'bg-red-500'"></span>
                  {{ p.trangThaiSP == 1 ? 'Đang bán' : 'Ngừng bán' }}
                </span>
              </td>
              <td class="px-6 py-4 text-right" @click.stop>
                <button @click="editProduct(p)"
                  class="text-xs font-medium text-yellow-700 bg-yellow-50 hover:bg-yellow-100 px-3 py-1.5 rounded-lg transition-colors mr-2">
                  Sửa
                </button>
                <button @click="deleteProduct(p.maSP)"
                  class="text-xs font-medium text-red-600 bg-red-50 hover:bg-red-100 px-3 py-1.5 rounded-lg transition-colors">
                  Xóa
                </button>
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

    <!-- DETAIL MODAL -->
    <div v-if="showDetails" class="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4" @click.self="showDetails=false">
      <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg">
        <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100">
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
            <div class="flex justify-between py-2 border-b border-gray-50">
              <span class="text-gray-500">Danh mục</span>
              <span class="font-medium text-gray-800">{{ selectedProduct?.loaiSanPham?.tenLoai }}</span>
            </div>
            <div class="flex justify-between py-2 border-b border-gray-50">
              <span class="text-gray-500">Thương hiệu</span>
              <span class="font-medium text-gray-800">{{ selectedProduct?.thuongHieu?.tenTH }}</span>
            </div>
            <div class="py-2">
              <span class="text-gray-500 block mb-1">Mô tả</span>
              <p class="text-gray-700 leading-relaxed">{{ selectedProduct?.moTa || 'Chưa có mô tả' }}</p>
            </div>
          </template>
        </div>
        <div class="px-6 py-4 border-t border-gray-100 flex justify-end">
          <button @click="showDetails=false"
            class="px-5 py-2 rounded-xl bg-gray-100 hover:bg-gray-200 text-sm font-medium transition-colors">
            Đóng
          </button>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script>
import AdminLayout from './AdminLayout.vue'
import axios from 'axios'
axios.defaults.baseURL = 'http://localhost:8080';
export default {
  name: 'ProductList',
  components: { AdminLayout },

  data() {
    return {
      products: [],
      categories: [],
      brands: [],
      filters: { keyword: '', categoryId: '', brandId: '', status: '' },
      showDetails: false,
      selectedProduct: null,
      loadingDetails: false
    }
  },

  methods: {
	
    async fetchProducts() {
      try {
        const res = await axios.get('/api/admin/products', { params: this.filters })
        this.products = res.data
      } catch (e) { console.error(e) }
    },

    async openDetails(id) {
      this.showDetails = true
      this.loadingDetails = true
      try {
        const res = await axios.get(`/api/admin/products/${id}`)
        this.selectedProduct = res.data
      } catch (e) { console.error(e) }
      finally { this.loadingDetails = false }
    },

    editProduct(product) {
      this.$router.push(`/admin/products/edit/${product.maSP}`)
    },

    async deleteProduct(id) {
      if (!confirm('Xóa sản phẩm này?')) return
      await axios.delete(`/api/admin/products/${id}`)
      this.fetchProducts()
    }
  },

  mounted() { this.fetchProducts() }
}
</script>