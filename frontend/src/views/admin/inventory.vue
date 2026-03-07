<template>
  <AdminLayout page-title="Kho & Nhà Cung Cấp">
    <div class="p-8 space-y-6">

      <!-- ACTION BAR -->
      <div class="flex items-center justify-between">
        <h3 class="text-base font-semibold text-gray-700">Danh sách phiếu nhập kho</h3>
        <button
          @click="showModal = true"
          class="flex items-center gap-2 bg-yellow-600 hover:bg-yellow-700 text-white px-5 py-2.5 rounded-xl text-sm font-semibold shadow-sm transition-colors"
        >
          <span class="material-symbols-outlined text-[18px]">add</span>
          Tạo Phiếu Nhập
        </button>
      </div>

      <!-- TABLE phiếu nhập kho (placeholder) -->
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <table class="w-full text-sm">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Mã Phiếu</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Nhà Cung Cấp</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Ngày Nhập</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Tổng Tiền</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Ghi Chú</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr v-for="phieu in danhSachPhieu" :key="phieu.id" class="hover:bg-yellow-50/50 transition-colors">
              <td class="px-6 py-4 font-mono text-xs text-gray-500">#{{ phieu.maPN }}</td>
              <td class="px-6 py-4 font-medium text-gray-800">{{ phieu.nhaCungCap?.tenNCC }}</td>
              <td class="px-6 py-4 text-gray-600">{{ formatDate(phieu.ngayNhap) }}</td>
              <td class="px-6 py-4 font-bold text-gray-800">{{ fmtCurrency(phieu.tongTien) }}</td>
              <td class="px-6 py-4 text-gray-500">{{ phieu.ghiChu || '---' }}</td>
            </tr>
          </tbody>
        </table>
        <div v-if="danhSachPhieu.length === 0" class="flex flex-col items-center justify-center py-16 text-gray-400">
          <span class="material-symbols-outlined text-5xl mb-3">inventory_2</span>
          <p class="text-sm">Chưa có phiếu nhập kho nào</p>
        </div>
      </div>
    </div>

    <!-- ====== MODAL TẠO PHIẾU NHẬP ====== -->
    <div v-if="showModal" class="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4" @click.self="closeModal">
      <div class="bg-white w-full max-w-4xl rounded-2xl shadow-2xl max-h-[90vh] overflow-y-auto">

        <!-- Modal Header -->
        <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100">
          <div>
            <h2 class="text-base font-bold text-gray-800">Tạo Phiếu Nhập Kho</h2>
            <p class="text-xs text-gray-400 mt-0.5">Điền thông tin và thêm sản phẩm cần nhập</p>
          </div>
          <button @click="closeModal" class="text-gray-400 hover:text-gray-600 transition-colors">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>

        <!-- Modal Body -->
        <div class="p-6 space-y-6">

          <!-- Thông tin chung -->
          <div class="grid grid-cols-2 gap-4 bg-gray-50 p-4 rounded-xl border border-gray-100">
            <div class="space-y-1.5">
              <label class="text-xs font-semibold text-gray-600 uppercase tracking-wide">Nhà Cung Cấp *</label>
              <select v-model="form.maNCC"
                class="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-yellow-400">
                <option value="">-- Chọn nhà cung cấp --</option>
                <option v-for="ncc in suppliers" :key="ncc.maNCC" :value="ncc.maNCC">{{ ncc.tenNCC }}</option>
              </select>
            </div>
            <div class="space-y-1.5">
              <label class="text-xs font-semibold text-gray-600 uppercase tracking-wide">Ghi Chú</label>
              <input v-model="form.ghiChu" placeholder="Ghi chú phiếu nhập..."
                class="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-yellow-400"/>
            </div>
          </div>

          <!-- Thêm sản phẩm vào phiếu -->
          <div class="space-y-3">
            <label class="text-xs font-semibold text-gray-600 uppercase tracking-wide">Thêm Sản Phẩm</label>
            <div class="flex flex-wrap gap-2 bg-gray-50 p-4 rounded-xl border border-gray-100">
              <select v-model="newItem.productId"
                class="border border-gray-200 rounded-xl px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-yellow-400 flex-1 min-w-[160px]">
                <option value="">-- Sản phẩm --</option>
                <option v-for="p in products" :key="p.maSP" :value="p.maSP">{{ p.tenSP }}</option>
              </select>
              <input v-model="newItem.size" placeholder="Size"
                class="border border-gray-200 rounded-xl px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-yellow-400 w-20"/>
              <input v-model="newItem.color" placeholder="Màu sắc"
                class="border border-gray-200 rounded-xl px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-yellow-400 w-28"/>
              <input type="number" v-model.number="newItem.qty" placeholder="SL" min="1"
                class="border border-gray-200 rounded-xl px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-yellow-400 w-20"/>
              <input type="number" v-model.number="newItem.price" placeholder="Giá nhập"
                class="border border-gray-200 rounded-xl px-3 py-2 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-yellow-400 w-28"/>
              <button @click="addItem"
                class="flex items-center gap-1.5 bg-yellow-600 hover:bg-yellow-700 text-white px-4 py-2 rounded-xl text-sm font-medium transition-colors">
                <span class="material-symbols-outlined text-[16px]">add</span>
                Thêm
              </button>
            </div>
          </div>

          <!-- Bảng sản phẩm trong phiếu -->
          <div class="rounded-xl border border-gray-200 overflow-hidden">
            <table class="w-full text-sm">
              <thead class="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">#</th>
                  <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Sản phẩm</th>
                  <th class="px-4 py-3 text-center text-xs font-semibold text-gray-500 uppercase">Size</th>
                  <th class="px-4 py-3 text-center text-xs font-semibold text-gray-500 uppercase">Màu</th>
                  <th class="px-4 py-3 text-center text-xs font-semibold text-gray-500 uppercase">SL</th>
                  <th class="px-4 py-3 text-right text-xs font-semibold text-gray-500 uppercase">Giá</th>
                  <th class="px-4 py-3 text-right text-xs font-semibold text-gray-500 uppercase">Thành tiền</th>
                  <th class="px-4 py-3"></th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-100">
                <tr v-for="(item, index) in form.items" :key="index" class="hover:bg-gray-50">
                  <td class="px-4 py-3 text-gray-500">{{ index + 1 }}</td>
                  <td class="px-4 py-3 font-medium text-gray-800">{{ getProductName(item.productId) }}</td>
                  <td class="px-4 py-3 text-center text-gray-600">{{ item.size }}</td>
                  <td class="px-4 py-3 text-center text-gray-600">{{ item.color }}</td>
                  <td class="px-4 py-3 text-center font-medium">{{ item.qty }}</td>
                  <td class="px-4 py-3 text-right text-gray-600">{{ fmtCurrency(item.price) }}</td>
                  <td class="px-4 py-3 text-right font-bold text-gray-800">{{ fmtCurrency(item.qty * item.price) }}</td>
                  <td class="px-4 py-3 text-center">
                    <button @click="removeItem(index)" class="text-red-400 hover:text-red-600 transition-colors">
                      <span class="material-symbols-outlined text-[18px]">delete</span>
                    </button>
                  </td>
                </tr>
                <tr v-if="form.items.length === 0">
                  <td colspan="8" class="px-4 py-8 text-center text-gray-400 text-sm">Chưa có sản phẩm trong phiếu</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Modal Footer -->
        <div class="flex items-center justify-between px-6 py-4 border-t border-gray-100 bg-gray-50 rounded-b-2xl">
          <div class="text-base font-bold text-gray-800">
            Tổng tiền: <span class="text-yellow-700">{{ fmtCurrency(totalAmount) }}</span>
          </div>
          <div class="flex gap-3">
            <button @click="closeModal"
              class="px-5 py-2.5 rounded-xl border border-gray-200 bg-white hover:bg-gray-50 text-sm font-medium text-gray-700 transition-colors">
              Hủy
            </button>
            <button @click="submit"
              class="px-5 py-2.5 rounded-xl bg-yellow-600 hover:bg-yellow-700 text-white text-sm font-semibold shadow-sm transition-colors">
              Lưu Phiếu
            </button>
          </div>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script>
import AdminLayout from './AdminLayout.vue'
import axios from 'axios'

export default {
  name: 'InventoryPage',
  components: { AdminLayout },

  data() {
    return {
      showModal: false,
      suppliers: [],
      products: [],
      danhSachPhieu: [],
      form: { maNCC: '', ghiChu: '', items: [] },
      newItem: { productId: '', size: '', color: '', qty: 1, price: 0 }
    }
  },

  computed: {
    totalAmount() {
      return this.form.items.reduce((sum, i) => sum + i.qty * i.price, 0)
    }
  },

  async mounted() {
    try {
      // Gọi đúng địa chỉ Backend (thêm http://localhost:8080 nếu cần)
      const res = await axios.get('http://localhost:8080/admin/inventory', { withCredentials: true });
      
      // Gán dữ liệu từ Map trả về
      this.suppliers = res.data.suppliers;
      this.products = res.data.products;
      this.danhSachPhieu = res.data.phieuNhaps;
    } catch (e) { 
      console.error("Lỗi lấy dữ liệu:", e); 
    }
  },

  methods: {
    closeModal() {
      this.showModal = false
      this.resetForm()
    },
    resetForm() {
      this.form = { maNCC: '', ghiChu: '', items: [] }
    },
    addItem() {
      if (!this.newItem.productId) { alert('Chọn sản phẩm'); return }
      this.form.items.push({ ...this.newItem })
      this.newItem = { productId: '', size: '', color: '', qty: 1, price: 0 }
    },
    removeItem(index) { this.form.items.splice(index, 1) },
	getProductName(id) {
	  const p = this.products.find(x => x.maSP === id)
	  return p ? p.tenSP : ''
	},
    fmtCurrency(v) {
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(v || 0)
    },
    formatDate(d) {
      return d ? new Date(d).toLocaleDateString('vi-VN') : '---'
    },
    async submit() {
      if (!this.form.maNCC) { alert('Chọn nhà cung cấp'); return }
      if (this.form.items.length === 0) { alert('Thêm ít nhất 1 sản phẩm'); return }
      try {
		await axios.post(
		  'http://localhost:8080/admin/inventory/import',
		  this.form,
		  { withCredentials: true }
		)
        alert('Tạo phiếu thành công!')
        this.closeModal()
      } catch (e) { console.error(e); alert('Lỗi khi lưu phiếu') }
    }
  }
}
</script>