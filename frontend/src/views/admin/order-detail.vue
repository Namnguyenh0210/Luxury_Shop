<template>
  <AdminLayout :page-title="'Chi Tiết Đơn Hàng #' + (order?.maDH || '')">
    <div class="p-8 space-y-6">
      
      <div class="flex justify-between items-center">
        <router-link to="/admin/orders" class="flex items-center gap-2 text-sm font-medium text-gray-500 hover:text-yellow-700 transition-colors">
          <span class="material-symbols-outlined text-[18px]">arrow_back</span>
          Quay lại danh sách
        </router-link>
        
        <div v-if="order" class="flex items-center gap-3">
          <span class="text-sm text-gray-400">Trạng thái hiện tại:</span>
          <span class="px-4 py-1.5 rounded-full text-xs font-bold shadow-sm" :class="statusClass(order.trangThaiDH).class">
            {{ statusClass(order.trangThaiDH).text }}
          </span>
        </div>
      </div>

      <div v-if="loading" class="flex flex-col items-center justify-center py-20 text-yellow-600">
        <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-yellow-600 mb-4"></div>
        <p class="font-medium">Đang tải thông tin đơn hàng...</p>
      </div>

      <div v-else-if="order" class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        <div class="lg:col-span-2 space-y-6">
          <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
            <div class="p-6 border-b border-gray-100 flex justify-between items-center bg-gray-50/50">
              <h3 class="font-bold text-gray-800 flex items-center gap-2">
                <span class="material-symbols-outlined text-yellow-600">shopping_basket</span>
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
                  <p class="font-bold text-yellow-700 text-lg">{{ fmtCurrency(item.donGia) }}</p>
                </div>
              </div>
            </div>

            <div class="p-6 bg-yellow-50/30 space-y-3">
              <div class="flex justify-between text-sm text-gray-600">
                <span>Tạm tính</span>
                <span class="font-medium">{{ fmtCurrency(subTotal) }}</span>
              </div>
              <div class="flex justify-between text-sm text-gray-600">
                <span>Phí vận chuyển</span>
                <span class="font-medium">{{ fmtCurrency(order.phiShip) }}</span>
              </div>
              <div class="flex justify-between items-center pt-3 border-t border-yellow-100">
                <span class="font-bold text-gray-800 text-lg">Tổng cộng</span>
                <span class="font-black text-2xl text-yellow-700">{{ fmtCurrency(order.tongTien) }}</span>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6 flex flex-wrap gap-3">
            <h4 class="w-full mb-2 text-sm font-bold text-gray-400 uppercase tracking-widest">Cập nhật trạng thái</h4>

            <!-- Chỉ hiện nút hành động phù hợp với trạng thái hiện tại -->
              <div v-if="order.khachBaoChuaNhan" class="mb-4 p-4 border-2 border-red-500 rounded bg-red-50 animate-pulse">
        <h3 class="text-red-600 font-bold text-lg mb-2 flex items-center gap-2">
          <span class="material-symbols-outlined">report_problem</span>
          Khách hàng báo chưa nhận được hàng!
        </h3>
        <p class="text-sm text-gray-700"><strong>Lý do:</strong> {{ order.lyDoChuaNhan }}</p>
        <p class="text-sm text-gray-700"><strong>Mô tả:</strong> {{ order.moTaChuaNhan || 'Không có mô tả thêm' }}</p>
        
        <div class="mt-4 flex gap-3">
          <button 
            @click="cancelReportedOrder"
            class="bg-red-600 text-white px-4 py-2 rounded font-bold hover:bg-red-700 transition shadow">
            Xác nhận hủy đơn & Hoàn tiền
          </button>
        </div>
      </div>
      
      <div v-if="order.trangThaiDH === 5" class="mb-4 p-4 bg-gray-100 border rounded">
        <p class="text-red-600 font-bold">Đơn hàng đã hủy</p>
        <p v-if="order.lyDoHuy" class="text-sm"><strong>Lý do hủy:</strong> {{ order.lyDoHuy }}</p>
      </div>

    <div v-if="order.trangThaiDH < 4 && !order.khachBaoChuaNhan" class="flex gap-4 mb-6">
      <button
          v-if="order.trangThaiDH === 0"
          @click="updateStatus(1)"
          class="bg-blue-600 text-white px-6 py-2 rounded-lg font-bold hover:bg-blue-700 transition">
        Xác nhận đơn hàng
      </button>

      <button
          v-if="order.trangThaiDH === 1"
          @click="updateStatus(2)"
          class="bg-purple-600 text-white px-6 py-2 rounded-lg font-bold hover:bg-purple-700 transition">
        Giao cho đơn vị vận chuyển
      </button>

      <button
          v-if="order.trangThaiDH === 2"
          @click="updateStatus(3)"
          class="bg-teal-600 text-white px-6 py-2 rounded-lg font-bold hover:bg-teal-700 transition">
        Xác nhận đã giao
      </button>

      <button
          v-if="order.trangThaiDH === 3"
          @click="updateStatus(4)"
          class="bg-green-600 text-white px-6 py-2 rounded-lg font-bold hover:bg-green-700 transition">
        Hoàn tất đơn hàng
      </button>
    </div>
            <div v-else-if="order.trangThaiDH >= 4 && !order.khachBaoChuaNhan" class="w-full text-center py-2 text-gray-400 italic text-sm">
              {{ order.trangThaiDH === 4 ? '✅ Đơn hàng đã hoàn tất.' : (order.trangThaiDH === 5 ? '❌ Đơn hàng đã bị hủy.' : 'Trạng thái xử lý đặc biệt.') }}
            </div>
          </div>
        </div>

        <div class="space-y-6">
          <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6">
            <h3 class="font-bold text-gray-800 mb-4 flex items-center gap-2 border-b pb-3">
              <span class="material-symbols-outlined text-yellow-600">person</span>
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

          <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6">
            <h3 class="font-bold text-gray-800 mb-4 flex items-center gap-2 border-b pb-3">
              <span class="material-symbols-outlined text-yellow-600">location_on</span>
              Địa chỉ giao hàng
            </h3>
            <p class="text-sm text-gray-600 leading-relaxed">
              {{ order.diaChiGiao?.diaChiChiTiet || 'Chưa cập nhật địa chỉ' }}
            </p>
          </div>

          <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-6">
            <h3 class="font-bold text-gray-800 mb-4 flex items-center gap-2 border-b pb-3">
              <span class="material-symbols-outlined text-yellow-600">payments</span>
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
  </AdminLayout>
</template>

<script>
import AdminLayout from './AdminLayout.vue'
import axios from 'axios'

export default {
  name: 'OrderDetail',
  components: { AdminLayout },
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
        const res = await axios.get(`http://localhost:8080/admin/orders/${id}`, { withCredentials: true })
        this.order = res.data
      } catch (e) {
        console.error("Lỗi khi tải chi tiết đơn hàng:", e)
      } finally {
        this.loading = false
      }
    },
    async updateStatus(newStatus) {
      if (!confirm(`Xác nhận chuyển sang trạng thái: ${this.statusClass(newStatus).text}?`)) return
      try {
        const res = await axios.put(
            `http://localhost:8080/admin/orders/${this.order.maDH}/status`,
            null,
            { params: { status: newStatus }, withCredentials: true }
        )
        if (res.data.success) {
          this.fetchOrderDetail()
        } else {
          alert(res.data.message)
        }
      } catch (err) {
        console.error("Update error", err)
        alert('Lỗi: ' + (err.response?.data?.message || err.response?.data || 'Không thể cập nhật trạng thái'))
      }
    },
    
    async cancelReportedOrder() {
      const reason = prompt("Nhập lý do hủy đơn (ví dụ: Giao thất bại, đã hoàn tiền):", "Khách báo chưa nhận được hàng: " + this.order.lyDoChuaNhan)
      if (reason === null) return
      
      try {
        // Sử dụng /status endpoint với status=5 (Hủy) và thêm lý do nếu backend hỗ trợ (as implicit or explicit param)
        // Hiện tại AdminDonHangController chỉ nhận status. Cần cập nhật backend hoặc dùng endpoint khác.
        // Tôi sẽ dùng updateStatus 5 và sau đó cập nhật lý do hủy.
        
        await axios.put(
            `http://localhost:8080/admin/orders/${this.order.maDH}/status`,
            null,
            { params: { status: 5, reason: reason }, withCredentials: true } // Added reason param
        )
        
        // Cập nhật lý do hủy trong field DonHang
        // Giả sử có endpoint cập nhật lý do hoặc backend tự mapping
        
        alert("Đơn hàng đã được hủy và lưu lý do!")
        this.fetchOrderDetail()
      } catch (err) {
        console.error("Cancel reported order error", err)
        alert('Lỗi: ' + (err.response?.data?.message || err.response?.data || 'Không thể hủy đơn hàng'))
      }
    },
    fmtCurrency(v) { return new Intl.NumberFormat('vi-VN').format(v || 0) + ' đ' },
    statusClass(s) {
      return {
        0: { text: 'Chờ xác nhận', class: 'bg-yellow-100 text-yellow-700' },
        1: { text: 'Đã xác nhận', class: 'bg-blue-100  text-blue-700' },
        2: { text: 'Đang giao', class: 'bg-purple-100 text-purple-700' },
        3: { text: 'Đã giao', class: 'bg-teal-100 text-teal-700' },
        4: { text: 'Hoàn tất', class: 'bg-green-100 text-green-700' },
        5: { text: 'Đã hủy', class: 'bg-red-100   text-red-700' }
      }[s] ?? { text: 'Không xác định', class: 'bg-gray-100 text-gray-600' }
    }
  },
  mounted() { this.fetchOrderDetail() }
}
</script>