<template>
  <StaffLayout page-title="Quản Lý Đơn Hàng">
    <div class="p-8 space-y-6">

      <!-- ACTION BAR -->
      <div class="flex flex-wrap items-center gap-4">
        <div class="relative flex-1 min-w-[200px] max-w-xs">
          <span class="absolute inset-y-0 left-3 flex items-center text-gray-400">
            <span class="material-symbols-outlined text-[18px]">search</span>
          </span>
          <input
            v-model="keyword"
            @input="fetchOrders"
            placeholder="Tìm kiếm đơn hàng..."
            class="w-full border border-gray-200 rounded-xl pl-9 pr-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-blue-400"
          />
        </div>

        <select v-model="status" @change="fetchOrders"
          class="border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-blue-400">
          <option value="">Tất cả trạng thái</option>
          <option value="0">Chờ xác nhận</option>
          <option value="1">Đã xác nhận</option>
          <option value="2">Đang giao</option>
          <option value="3">Đã giao</option>
          <option value="4">Hoàn tất</option>
          <option value="6">Đã đánh giá</option>
          <option value="5">Đã hủy</option>
          <option value="7">Chờ thanh toán</option>
          <option value="8">Lỗi thanh toán</option>
        </select>
      </div>

      <!-- TABLE -->
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <table v-if="orders.length > 0" class="w-full text-sm">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Mã ĐH</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Khách Hàng</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Ngày Đặt</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Tổng Tiền</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Trạng Thái</th>
              <th class="px-6 py-4 text-right text-xs font-semibold text-gray-500 uppercase tracking-wider">Chi Tiết</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr v-for="order in orders" :key="order.maDH" class="hover:bg-blue-50/30 transition-colors">
              <td class="px-6 py-4 font-mono text-xs text-blue-700 font-bold">#{{ order.maDH }}</td>
              <td class="px-6 py-4">
                <p class="font-semibold text-gray-800">{{ order.taiKhoan?.hoTen || 'Khách vãng lai' }}</p>
                <p class="text-xs text-gray-400">{{ order.taiKhoan?.email }}</p>
              </td>
              <td class="px-6 py-4 text-gray-600">{{ formatDate(order.ngayDat) }}</td>
              <td class="px-6 py-4 font-bold text-gray-800">{{ fmtCurrency(order.tongTien) }}</td>
              <td class="px-6 py-4">
                <span class="inline-flex items-center px-2.5 py-1 text-xs font-medium rounded-full"
                  :class="statusClass(order.trangThaiDH)">
                  {{ statusText(order.trangThaiDH) }}
                </span>
              </td>
              <td class="px-6 py-4 text-right">
                <router-link :to="`/staff/orders/${order.maDH}`"
                  class="text-xs font-medium text-blue-700 bg-blue-50 hover:bg-blue-100 px-3 py-1.5 rounded-lg transition-colors inline-flex items-center gap-1">
                  Xem
                  <span class="material-symbols-outlined text-[14px]">arrow_forward</span>
                </router-link>
              </td>
            </tr>
          </tbody>
        </table>

        <div v-else class="flex flex-col items-center justify-center py-16 text-gray-400">
          <span class="material-symbols-outlined text-5xl mb-3">receipt_long</span>
          <p class="text-sm">Không có đơn hàng nào</p>
        </div>
      </div>

      <!-- PAGINATION -->
      <div v-if="totalPages > 1" class="flex justify-end items-center gap-2">
        <button v-if="page > 0" @click="changePage(page - 1)"
          class="flex items-center gap-1 px-4 py-2 border border-gray-200 rounded-xl hover:bg-gray-50 text-sm font-medium transition-colors">
          <span class="material-symbols-outlined text-[16px]">chevron_left</span>
          Trước
        </button>
        <span class="px-4 py-2 bg-blue-600 text-white rounded-xl text-sm font-bold">{{ page + 1 }}</span>
        <button v-if="page < totalPages - 1" @click="changePage(page + 1)"
          class="flex items-center gap-1 px-4 py-2 border border-gray-200 rounded-xl hover:bg-gray-50 text-sm font-medium transition-colors">
          Sau
          <span class="material-symbols-outlined text-[16px]">chevron_right</span>
        </button>
      </div>
    </div>
  </StaffLayout>
</template>

<script>
import StaffLayout from './StaffLayout.vue'
import axios from 'axios'

export default {
  name: 'StaffOrders',
  components: { StaffLayout },

  data() {
    return {
      orders: [],
      keyword: '',
      status: '',
      page: 0,
      totalPages: 0
    }
  },

  methods: {
    async fetchOrders() {
      try {
        const res = await axios.get('/staff/orders', {
          params: {
            keyword: this.keyword || undefined,
            status: this.status !== '' ? this.status : undefined,
            page: this.page
          },
          withCredentials: true
        })
        this.orders     = res.data.content || res.data || []
        this.totalPages = res.data.totalPages || 1
      } catch (e) { console.error(e) }
    },

    changePage(p) { this.page = p; this.fetchOrders() },

    formatDate(d) { return d ? new Date(d).toLocaleDateString('vi-VN') : '---' },

    fmtCurrency(v) { return new Intl.NumberFormat('vi-VN').format(v || 0) + ' đ' },

    statusText(s) {
      return { 
        0: 'Chờ xác nhận', 
        1: 'Đã xác nhận', 
        2: 'Đang giao', 
        3: 'Đã giao', 
        4: 'Hoàn tất', 
        5: 'Đã hủy',
        6: 'Đã đánh giá',
        7: 'Chờ thanh toán',
        8: 'Lỗi thanh toán'
      }[s] ?? 'Không xác định'
    },

    statusClass(s) {
      return {
        0: 'bg-yellow-100 text-yellow-700',
        1: 'bg-blue-100  text-blue-700',
        2: 'bg-purple-100 text-purple-700',
        3: 'bg-indigo-100 text-indigo-700',
        4: 'bg-green-100 text-green-700',
        5: 'bg-red-100   text-red-700',
        6: 'bg-orange-100 text-orange-700',
        7: 'bg-cyan-100 text-cyan-700',
        8: 'bg-gray-100 text-gray-700'
      }[s] ?? 'bg-gray-100 text-gray-600'
    }
  },

  mounted() { this.fetchOrders() }
}
</script>
