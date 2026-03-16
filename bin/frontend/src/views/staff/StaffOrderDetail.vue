<template>
  <StaffLayout :page-title="`Chi Tiết Đơn Hàng #${donHang.maDH || ''}`">
    <div class="p-8 space-y-6">

      <!-- Back -->
      <router-link to="/staff/orders"
        class="inline-flex items-center gap-2 text-sm font-medium text-gray-500 hover:text-blue-700 transition-colors">
        <span class="material-symbols-outlined text-[18px]">arrow_back</span>
        Quay lại danh sách
      </router-link>

      <!-- Loading -->
      <div v-if="loading" class="flex justify-center py-16 text-gray-400">
        <span class="material-symbols-outlined animate-spin text-5xl">progress_activity</span>
      </div>

      <template v-else>
        <!-- ORDER INFO -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

          <!-- Left: Order details -->
          <div class="lg:col-span-2 space-y-6">

            <!-- Info Card -->
            <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6">
              <h3 class="text-base font-bold text-gray-800 mb-5">Thông tin đơn hàng</h3>
              <div class="grid grid-cols-2 gap-4">
                <div class="bg-gray-50 rounded-xl p-4">
                  <p class="text-xs text-gray-400 font-medium uppercase tracking-wide mb-1">Mã đơn hàng</p>
                  <p class="text-sm font-bold text-blue-700">#{{ donHang.maDH }}</p>
                </div>
                <div class="bg-gray-50 rounded-xl p-4">
                  <p class="text-xs text-gray-400 font-medium uppercase tracking-wide mb-1">Ngày đặt</p>
                  <p class="text-sm font-medium text-gray-700">{{ formatDate(donHang.ngayDat) }}</p>
                </div>
                <div class="bg-gray-50 rounded-xl p-4">
                  <p class="text-xs text-gray-400 font-medium uppercase tracking-wide mb-1">Khách hàng</p>
                  <p class="text-sm font-medium text-gray-700">{{ donHang.khachHang?.hoTen || donHang.taiKhoan?.hoTen || '---' }}</p>
                </div>
                <div class="bg-gray-50 rounded-xl p-4">
                  <p class="text-xs text-gray-400 font-medium uppercase tracking-wide mb-1">Tổng tiền</p>
                  <p class="text-sm font-bold text-gray-900">{{ fmtCurrency(donHang.tongTien) }}</p>
                </div>
              </div>
            </div>

            <!-- Products -->
            <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
              <div class="px-6 py-4 border-b border-gray-100">
                <h3 class="text-base font-bold text-gray-800">Sản phẩm trong đơn</h3>
              </div>
              <table class="w-full text-sm">
                <thead class="bg-gray-50 border-b border-gray-200">
                  <tr>
                    <th class="px-6 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Sản Phẩm</th>
                    <th class="px-6 py-3 text-center text-xs font-semibold text-gray-500 uppercase">Số Lượng</th>
                    <th class="px-6 py-3 text-right text-xs font-semibold text-gray-500 uppercase">Đơn Giá</th>
                    <th class="px-6 py-3 text-right text-xs font-semibold text-gray-500 uppercase">Thành Tiền</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                  <tr v-for="c in chiTiet" :key="c.id" class="hover:bg-gray-50">
                    <td class="px-6 py-4 font-medium text-gray-800">{{ c.sanPham?.tenSP || c.sanPhamChiTiet?.sanPham?.tenSP || '---' }}</td>
                    <td class="px-6 py-4 text-center text-gray-600">{{ c.soLuong }}</td>
                    <td class="px-6 py-4 text-right text-gray-600">{{ fmtCurrency(c.gia || c.donGia) }}</td>
                    <td class="px-6 py-4 text-right font-bold text-gray-800">{{ fmtCurrency((c.gia || c.donGia) * c.soLuong) }}</td>
                  </tr>
                </tbody>
              </table>
              <div v-if="chiTiet.length === 0" class="px-6 py-8 text-center text-gray-400 text-sm">
                Không có sản phẩm
              </div>
            </div>
          </div>

          <!-- Right: Status Panel -->
          <div class="space-y-5">

            <!-- Current Status -->
            <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6">
              <h3 class="text-base font-bold text-gray-800 mb-4">Trạng Thái Đơn Hàng</h3>
              <div class="text-center py-3">
                <span class="inline-flex items-center px-4 py-2 text-sm font-bold rounded-full"
                  :class="statusClass(donHang.trangThaiDH)">
                  {{ statusText(donHang.trangThaiDH) }}
                </span>
              </div>
            </div>

            <!-- Update Status -->
            <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6">
              <h3 class="text-base font-bold text-gray-800 mb-4">Cập Nhật Trạng Thái</h3>
              <div class="flex flex-col gap-2">
                <button
                  v-for="action in statusActions"
                  :key="action.value"
                  @click="updateStatus(action.value)"
                  :disabled="donHang.trangThaiDH === action.value || updating"
                  class="flex items-center gap-3 w-full px-4 py-3 rounded-xl text-sm font-semibold transition-colors disabled:opacity-40 disabled:cursor-not-allowed"
                  :class="action.btnClass"
                >
                  <span class="material-symbols-outlined text-[18px]">{{ action.icon }}</span>
                  {{ action.label }}
                </button>
              </div>

              <div v-if="updating" class="mt-3 text-center text-xs text-gray-400 flex items-center justify-center gap-1">
                <span class="material-symbols-outlined text-[14px] animate-spin">progress_activity</span>
                Đang cập nhật...
              </div>
            </div>

          </div>
        </div>
      </template>
    </div>
  </StaffLayout>
</template>

<script>
import StaffLayout from './StaffLayout.vue'
import axios from 'axios'

export default {
  name: 'StaffOrderDetail',
  components: { StaffLayout },

  data() {
    return {
      loading: true,
      updating: false,
      donHang: {},
      chiTiet: [],
      statusActions: [
        { value: 1, label: 'Xác Nhận Đơn',  icon: 'check_circle',  btnClass: 'bg-blue-50 text-blue-700 hover:bg-blue-100'    },
        { value: 2, label: 'Đang Giao Hàng', icon: 'local_shipping', btnClass: 'bg-purple-50 text-purple-700 hover:bg-purple-100' },
        { value: 3, label: 'Hoàn Tất',       icon: 'task_alt',      btnClass: 'bg-green-50 text-green-700 hover:bg-green-100'  },
        { value: 4, label: 'Hủy Đơn',        icon: 'cancel',        btnClass: 'bg-red-50 text-red-600 hover:bg-red-100'        },
      ]
    }
  },

  async mounted() {
    await this.loadDetail()
  },

  methods: {
    async loadDetail() {
      this.loading = true
      try {
        const id  = this.$route.params.id
        const res = await axios.get(`/staff/orders/${id}`, { withCredentials: true })
        this.donHang = res.data.donHang || res.data
        this.chiTiet = res.data.chiTiet || this.donHang.chiTiet || []
      } catch (e) { console.error(e) }
      finally { this.loading = false }
    },

    async updateStatus(status) {
      if (!confirm(`Cập nhật trạng thái sang "${this.statusText(status)}"?`)) return
      this.updating = true
      try {
        const id = this.$route.params.id
        await axios.put(`/staff/orders/${id}/status`, null, {
          params: { trangThaiMoi: status },
          withCredentials: true
        })
        await this.loadDetail()
      } catch (e) { console.error(e); alert('Có lỗi khi cập nhật trạng thái') }
      finally { this.updating = false }
    },

    fmtCurrency(v) { return new Intl.NumberFormat('vi-VN').format(v || 0) + ' đ' },

    formatDate(d) { return d ? new Date(d).toLocaleString('vi-VN') : '---' },

    statusText(s) {
      return { 0: 'Chờ xác nhận', 1: 'Đã xác nhận', 2: 'Đang giao', 3: 'Hoàn tất', 4: 'Đã hủy' }[s] ?? 'Không xác định'
    },

    statusClass(s) {
      return {
        0: 'bg-yellow-100 text-yellow-700',
        1: 'bg-blue-100  text-blue-700',
        2: 'bg-purple-100 text-purple-700',
        3: 'bg-green-100 text-green-700',
        4: 'bg-red-100   text-red-700'
      }[s] ?? 'bg-gray-100 text-gray-600'
    }
  }
}
</script>