<template>
  <StaffLayout :page-title="'Chi Tiết Đơn Hàng #' + (order?.maDH || '')">
    <div class="p-8 space-y-6">

      <div class="flex justify-between items-center">
        <router-link to="/staff/orders" class="flex items-center gap-2 text-sm font-medium text-gray-500 hover:text-blue-700 transition-colors">
          <span class="material-symbols-outlined text-[18px]">arrow_back</span>
          Quay lại danh sách
        </router-link>

        <div v-if="order" class="flex items-center gap-3">
          <span class="text-sm text-gray-400">Trạng thái hiện tại:</span>
          <span class="px-4 py-1.5 rounded-full text-xs font-bold shadow-sm" :class="statusClass(order.trangThaiDH)">
            {{ statusText(order.trangThaiDH) }}
          </span>
        </div>
      </div>

      <div v-if="loading" class="flex flex-col items-center justify-center py-20 text-blue-600">
        <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-blue-600 mb-4"></div>
        <p class="font-medium">Đang tải thông tin đơn hàng...</p>
      </div>

      <div v-else-if="order" class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <div class="lg:col-span-2 space-y-6">
          <!-- Sản phẩm -->
          <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
            <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
              <h3 class="font-bold text-gray-800 flex items-center gap-2">
                <span class="material-symbols-outlined text-blue-600">shopping_basket</span>
                Sản phẩm đã đặt
              </h3>
              <span class="text-sm font-medium text-gray-500">{{ orderItems.length }} mặt hàng</span>
            </div>

            <div class="divide-y divide-gray-100">
              <div v-for="item in orderItems" :key="item.maCTDH" class="p-6 flex items-center gap-4 hover:bg-gray-50/50 transition-colors">
                <img :src="item.sanPhamChiTiet?.anhBienThe || 'https://via.placeholder.com/80'"
                     class="w-20 h-20 object-cover rounded-xl border border-gray-100 shadow-sm" />

                <div class="flex-1">
                  <h4 class="font-bold text-gray-800 text-lg leading-tight mb-1">
                    {{ item.sanPhamChiTiet?.sanPham?.tenSP || 'Sản phẩm không tồn tại' }}
                  </h4>
                  <div class="flex gap-4 text-xs font-medium text-gray-500 uppercase tracking-wider">
                    <span class="bg-gray-100 px-2 py-0.5 rounded">Size: {{ item.sanPhamChiTiet?.sizeSP?.tenSize || '-' }}</span>
                    <span class="bg-gray-100 px-2 py-0.5 rounded">Màu: {{ item.sanPhamChiTiet?.mauSacSP?.tenMau || '-' }}</span>
                  </div>
                </div>

                <div class="text-right">
                  <p class="text-sm text-gray-400 font-medium">x{{ item.soLuong }}</p>
                  <p class="font-bold text-blue-700 text-lg">{{ fmtCurrency(item.donGia) }}</p>
                </div>
              </div>
            </div>

            <div class="p-6 bg-blue-50/30 space-y-3">
              <div class="flex justify-between text-sm text-gray-600">
                <span>Tạm tính</span>
                <span class="font-medium">{{ fmtCurrency(subTotal) }}</span>
              </div>
              <div class="flex justify-between text-sm text-gray-600">
                <span>Phí vận chuyển</span>
                <span class="font-medium">{{ fmtCurrency(order.phiShip) }}</span>
              </div>
              <div class="flex justify-between items-center pt-3 border-t border-blue-100">
                <span class="font-bold text-gray-800 text-lg">Tổng cộng</span>
                <span class="font-black text-2xl text-blue-700">{{ fmtCurrency(order.tongTien) }}</span>
              </div>
            </div>
          </div>

          <!-- Cập nhật trạng thái -->
          <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6 flex flex-wrap gap-3">
            <h4 class="w-full mb-2 text-sm font-bold text-gray-400 uppercase tracking-widest">Cập nhật trạng thái</h4>

            <template v-if="order.trangThaiDH < 3 && order.trangThaiDH !== 4">

              <!-- 0: Chờ xác nhận → Xác nhận + Hủy -->
              <template v-if="order.trangThaiDH === 0">
                <button @click="updateStatus(1)"
                  class="flex-1 min-w-[150px] bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 rounded-xl transition-all shadow-md flex items-center justify-center gap-2">
                  <span class="material-symbols-outlined">check_circle</span> Xác nhận đơn
                </button>
                <button @click="updateStatus(4)"
                  class="flex-1 min-w-[150px] border-2 border-red-200 text-red-600 hover:bg-red-50 font-bold py-3 rounded-xl transition-all flex items-center justify-center gap-2">
                  <span class="material-symbols-outlined">cancel</span> Hủy đơn hàng
                </button>
              </template>

              <!-- 1: Đã xác nhận → chỉ Giao hàng, KHÔNG hủy được -->
              <template v-if="order.trangThaiDH === 1">
                <button @click="updateStatus(2)"
                  class="flex-1 min-w-[150px] bg-purple-600 hover:bg-purple-700 text-white font-bold py-3 rounded-xl transition-all shadow-md flex items-center justify-center gap-2">
                  <span class="material-symbols-outlined">local_shipping</span> Bắt đầu giao hàng
                </button>
                <p class="w-full text-xs text-orange-500 font-medium text-center">
                  ⚠️ Đơn đã xác nhận — Không thể hủy. Liên hệ trực tiếp với khách nếu cần.
                </p>
              </template>

              <!-- 2: Đang giao → chỉ Hoàn tất, KHÔNG hủy được -->
              <template v-if="order.trangThaiDH === 2">
                <button @click="updateStatus(3)"
                  class="flex-1 min-w-[150px] bg-green-600 hover:bg-green-700 text-white font-bold py-3 rounded-xl transition-all shadow-md flex items-center justify-center gap-2">
                  <span class="material-symbols-outlined">verified</span> Xác nhận hoàn tất
                </button>
                <p class="w-full text-xs text-orange-500 font-medium text-center">
                  ⚠️ Đang vận chuyển — Không thể hủy.
                </p>
              </template>

            </template>

            <div v-if="order.trangThaiDH >= 3 || order.trangThaiDH === 4" class="w-full text-center py-2 text-gray-400 italic text-sm">
              {{ order.trangThaiDH === 3 ? '✅ Đơn hàng đã hoàn tất.' : '❌ Đơn hàng đã bị hủy.' }}
            </div>
          </div>
        </div>

        <!-- Right panel -->
        <div class="space-y-6">
          <!-- Khách hàng -->
          <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6">
            <h3 class="font-bold text-gray-800 mb-4 flex items-center gap-2 border-b pb-3">
              <span class="material-symbols-outlined text-blue-600">person</span>
              Khách hàng
            </h3>
            <div class="space-y-4">
              <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Họ và tên</p>
                <p class="font-semibold text-gray-800">{{ order.taiKhoan?.hoTen || 'Khách vãng lai' }}</p>
              </div>
              <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Email</p>
                <p class="text-sm text-gray-600">{{ order.taiKhoan?.email || '---' }}</p>
              </div>
              <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Số điện thoại</p>
                <p class="text-sm text-gray-600">{{ order.taiKhoan?.soDienThoai || '---' }}</p>
              </div>
            </div>
          </div>

          <!-- Địa chỉ -->
          <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6">
            <h3 class="font-bold text-gray-800 mb-4 flex items-center gap-2 border-b pb-3">
              <span class="material-symbols-outlined text-blue-600">location_on</span>
              Địa chỉ giao hàng
            </h3>
            <p class="text-sm text-gray-600 leading-relaxed">
              {{ order.diaChiGiao?.diaChiChiTiet || 'Chưa cập nhật địa chỉ' }}
            </p>
          </div>

          <!-- Thanh toán -->
          <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6">
            <h3 class="font-bold text-gray-800 mb-4 flex items-center gap-2 border-b pb-3">
              <span class="material-symbols-outlined text-blue-600">payments</span>
              Thanh toán
            </h3>
            <div class="space-y-3">
              <div class="flex justify-between text-sm">
                <span class="text-gray-400">Phương thức:</span>
                <span class="font-medium text-gray-800">{{ order.hinhThucThanhToan?.tenHinhThuc || 'Tiền mặt' }}</span>
              </div>
              <div class="flex justify-between text-sm">
                <span class="text-gray-400">Trạng thái:</span>
                <span :class="order.trangThaiThanhToan === 1 ? 'text-green-600' : 'text-red-500'" class="font-bold">
                  {{ order.trangThaiThanhToan === 1 ? 'Đã thanh toán' : 'Chờ thanh toán' }}
                </span>
              </div>
            </div>
          </div>
        </div>

      </div>
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
      order: null,
      loading: true
    }
  },

  computed: {
    orderItems() { return this.order?.chiTietList || [] },
    subTotal() {
      return this.orderItems.reduce((acc, item) => acc + (item.donGia * item.soLuong), 0)
    }
  },

  methods: {
    async fetchOrderDetail() {
      this.loading = true
      try {
        const id = this.$route.params.id
        // Gọi API Staff cho chi tiết đơn hàng
        const res = await axios.get(`/staff/orders/${id}`, { withCredentials: true })
        // API staff trả về { donHang, chiTiet }
        if (res.data.donHang) {
          this.order = res.data.donHang
          // Gắn chiTietList vào order để computed orderItems hoạt động
          this.order.chiTietList = res.data.chiTiet || []
        } else {
          this.order = res.data
        }
      } catch (e) {
        console.error('Lỗi khi tải chi tiết đơn hàng:', e)
      } finally {
        this.loading = false
      }
    },

    async updateStatus(newStatus) {
      if (!confirm('Bạn có chắc chắn muốn chuyển trạng thái đơn hàng này?')) return
      try {
        await axios.put(`/staff/orders/${this.order.maDH}/status`, null, {
          params: { trangThaiMoi: newStatus },
          withCredentials: true
        })
        await this.fetchOrderDetail()
      } catch (e) {
        alert('Lỗi: ' + (e.response?.data?.message || e.response?.data || 'Không thể cập nhật trạng thái'))
      }
    },

    fmtCurrency(v) { return new Intl.NumberFormat('vi-VN').format(v || 0) + ' đ' },

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
  },

  mounted() { this.fetchOrderDetail() }
}
</script>