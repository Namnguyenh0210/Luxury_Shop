<template>
  <div class="flex min-h-screen">

    <!-- SIDEBAR -->
    <aside class="w-64 border-r p-4">
      <h2 class="font-bold mb-6">ADMIN</h2>

      <nav class="flex flex-col gap-2 text-sm">
        <RouterLink to="/admin/dashboard">Dashboard</RouterLink>
        <RouterLink to="/admin/products" class="font-bold text-blue-600">
          Sản Phẩm
        </RouterLink>
        <RouterLink to="/admin/orders">Đơn Hàng</RouterLink>
      </nav>
    </aside>

    <!-- MAIN -->
    <main class="flex-1 p-10">

      <!-- FILTER -->
      <div class="bg-white p-6 rounded-xl border mb-6">
        <div class="grid md:grid-cols-4 gap-4">

          <input
              v-model="filters.keyword"
              @input="fetchProducts"
              placeholder="Tên sản phẩm..."
              class="border rounded px-3 py-2 text-sm" />

          <select
              v-model="filters.categoryId"
              @change="fetchProducts"
              class="border rounded px-3 py-2 text-sm">
            <option value="">Tất cả danh mục</option>
            <option
                v-for="c in categories"
                :key="c.id"
                :value="c.id">
              {{ c.tenLoai }}
            </option>
          </select>

          <select
              v-model="filters.brandId"
              @change="fetchProducts"
              class="border rounded px-3 py-2 text-sm">
            <option value="">Tất cả thương hiệu</option>
            <option
                v-for="b in brands"
                :key="b.id"
                :value="b.id">
              {{ b.tenTH }}
            </option>
          </select>

          <select
              v-model="filters.status"
              @change="fetchProducts"
              class="border rounded px-3 py-2 text-sm">
            <option value="">Tất cả trạng thái</option>
            <option value="1">Đang bán</option>
            <option value="0">Ngừng bán</option>
          </select>

        </div>
      </div>

      <!-- TABLE -->
      <div class="bg-white rounded-xl border overflow-hidden">

        <table class="w-full text-sm">
          <thead class="bg-gray-50">
          <tr>
            <th class="px-6 py-4">Mã</th>
            <th class="px-6 py-4">Tên</th>
            <th class="px-6 py-4">Danh mục</th>
            <th class="px-6 py-4">Thương hiệu</th>
            <th class="px-6 py-4">Trạng thái</th>
            <th class="px-6 py-4 text-right"></th>
          </tr>
          </thead>

          <tbody>
          <tr
              v-for="p in products"
              :key="p.id"
              class="border-t hover:bg-gray-50 cursor-pointer"
              @click="openDetails(p.id)">

            <td class="px-6 py-4 font-mono">#{{ p.maSP }}</td>
            <td class="px-6 py-4 font-medium">{{ p.tenSP }}</td>
            <td class="px-6 py-4">{{ p.loaiSanPham?.tenLoai }}</td>
            <td class="px-6 py-4">{{ p.thuongHieu?.tenTH }}</td>

            <td class="px-6 py-4">
                <span
                    class="px-2 py-1 text-xs rounded-full"
                    :class="p.trangThaiSP == 1
                    ? 'bg-green-100 text-green-700'
                    : 'bg-red-100 text-red-700'">
                  {{ p.trangThaiSP == 1 ? 'Đang bán' : 'Ngừng bán' }}
                </span>
            </td>

            <td
                class="px-6 py-4 text-right"
                @click.stop>

              <button
                  @click="editProduct(p)"
                  class="text-blue-600 mr-2">
                Sửa
              </button>

              <button
                  @click="deleteProduct(p.id)"
                  class="text-red-600">
                Xóa
              </button>

            </td>
          </tr>
          </tbody>
        </table>

        <div
            v-if="products.length === 0"
            class="p-8 text-center text-gray-500">
          Không có sản phẩm
        </div>

      </div>

      <!-- DETAILS MODAL -->
      <div
          v-if="showDetails"
          class="fixed inset-0 bg-black/50 flex items-center justify-center">

        <div class="bg-white p-6 rounded-xl w-[600px]">

          <h3 class="text-lg font-bold mb-4">
            {{ selectedProduct?.tenSP }}
          </h3>

          <div v-if="loadingDetails">
            Đang tải...
          </div>

          <div v-else>
            <p><b>Danh mục:</b> {{ selectedProduct?.loaiSanPham?.tenLoai }}</p>
            <p><b>Thương hiệu:</b> {{ selectedProduct?.thuongHieu?.tenTH }}</p>
            <p><b>Mô tả:</b> {{ selectedProduct?.moTa }}</p>
          </div>

          <div class="mt-6 text-right">
            <button @click="showDetails=false">Đóng</button>
          </div>

        </div>
      </div>

    </main>
  </div>
</template>
<script>
import axios from "axios"

export default {

  name: "ProductList",

  data() {
    return {
      products: [],
      categories: [],
      brands: [],

      filters: {
        keyword: "",
        categoryId: "",
        brandId: "",
        status: ""
      },

      showDetails: false,
      selectedProduct: null,
      loadingDetails: false
    }
  },

  methods: {

    async fetchProducts() {
      const res = await axios.get(
          "http://localhost:8080/api/products",
          { params: this.filters }
      )
      this.products = res.data
    },

    async openDetails(id) {
      this.showDetails = true
      this.loadingDetails = true

      const res = await axios.get(
          `http://localhost:8080/api/products/${id}`
      )

      this.selectedProduct = res.data
      this.loadingDetails = false
    },

    editProduct(product) {
      this.$router.push(`/admin/products/edit/${product.id}`)
    },

    async deleteProduct(id) {
      if (!confirm("Xóa sản phẩm này?")) return

      await axios.delete(
          `http://localhost:8080/api/products/${id}`
      )

      this.fetchProducts()
    }

  },

  mounted() {
    this.fetchProducts()
  }

}
</script>