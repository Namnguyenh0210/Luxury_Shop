<template>
  <StaffLayout page-title="Quản Lý Đơn Hàng">
    <div class="p-8 space-y-6">

      <!-- ACTION BAR (Admin Style) -->
      <div class="flex flex-wrap items-center gap-4">
        <!-- Search Input -->
        <div class="relative flex-1 min-w-[200px] max-w-xs group">
          <span class="absolute inset-y-0 left-4 flex items-center text-[#C8A97E] group-focus-within:text-black transition-colors">
            <span class="material-symbols-outlined text-[20px]">search</span>
          </span>
          <input
            v-model="keyword"
            @input="fetchOrders"
            placeholder="Tìm kiếm đơn hàng..."
            class="w-full border border-[#C8A97E]/50 rounded-2xl pl-12 pr-4 py-3 text-sm bg-white focus:outline-none focus:ring-4 focus:ring-[#C8A97E]/10 focus:border-[#C8A97E] transition-all shadow-sm font-bold text-gray-700 placeholder:text-gray-400"
          />
        </div>

        <!-- Status Filter Dropdown -->
        <div class="relative min-w-[200px]">
          <button @click.stop="openDropdown = openDropdown === 'status' ? null : 'status'"
            class="w-full border border-[#C8A97E]/50 rounded-2xl pl-5 pr-10 py-3 text-sm bg-white text-left focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/20 hover:border-[#C8A97E] transition-all flex items-center justify-between shadow-sm">
            <span class="truncate font-black text-gray-700 uppercase tracking-widest text-[11px]">{{ status === '' ? 'Tất cả trạng thái' : statusText(status) }}</span>
            <span class="material-symbols-outlined text-[20px] absolute right-3 text-[#C8A97E]">expand_more</span>
          </button>
          
          <div v-if="openDropdown === 'status'" class="absolute z-50 w-full mt-2 bg-white border border-[#C8A97E]/20 rounded-2xl shadow-2xl overflow-hidden animate-in fade-in slide-in-from-top-2 duration-200">
            <div @click="status = ''; fetchOrders(); openDropdown = null" class="px-5 py-3 text-[11px] font-black uppercase tracking-widest cursor-pointer hover:bg-[#C8A97E]/10 transition-colors border-b border-gray-50" :class="status === '' ? 'text-[#C8A97E] bg-[#C8A97E]/5' : 'text-gray-500'">Tất cả trạng thái</div>
            <div v-for="s in [0, 1, 2, 3, 4, 6, 5, 7, 8]" :key="s"
                 @click="status = s.toString(); fetchOrders(); openDropdown = null"
                 class="px-5 py-3 text-[11px] font-black uppercase tracking-widest hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600"
                 :class="status === s.toString() ? 'text-[#C8A97E] bg-[#C8A97E]/5' : ''">
              {{ statusText(s) }}
            </div>
          </div>
        </div>

        <!-- Date Range Filter -->
        <div class="flex items-center gap-2 bg-white rounded-2xl p-1.5 border border-[#C8A97E]/30 shadow-sm shadow-[#C8A97E]/5">
          <input type="date" v-model="startDate" @change="fetchOrders"
            class="bg-transparent border-none text-[11px] font-black text-gray-700 focus:ring-0 w-[112px] cursor-pointer">
          <span class="text-[#C8A97E] px-0.5 font-bold">→</span>
          <input type="date" v-model="endDate" @change="fetchOrders"
            class="bg-transparent border-none text-[11px] font-black text-gray-700 focus:ring-0 w-[112px] cursor-pointer">
        </div>

        <!-- Reset Button -->
        <button @click="resetFilters" 
          class="flex items-center justify-center size-11 rounded-2xl border border-[#C8A97E]/30 bg-white text-[#C8A97E] hover:bg-[#C8A97E] hover:text-white transition-all shadow-sm group"
          title="Làm mới bộ lọc">
          <span class="material-symbols-outlined transition-transform duration-500 group-hover:rotate-180">refresh</span>
        </button>
      </div>
      </div>

      <!-- TABLE -->
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <table v-if="orders.length > 0" class="w-full text-sm">
          <thead class="bg-[#EFE9DB] border-b border-[#C8A97E]/30">
            <tr>
              <th class="px-6 py-4 text-left text-xs font-black text-black uppercase tracking-wider">Mã ĐH</th>
              <th class="px-6 py-4 text-left text-xs font-black text-black uppercase tracking-wider">Khách Hàng</th>
              <th class="px-6 py-4 text-left text-xs font-black text-black uppercase tracking-wider">Ngày Đặt</th>
              <th class="px-6 py-4 text-left text-xs font-black text-black uppercase tracking-wider">Tổng Tiền</th>
              <th class="px-6 py-4 text-left text-xs font-black text-black uppercase tracking-wider">Trạng Thái</th>
              <th class="px-6 py-4 text-center text-xs font-black text-black uppercase tracking-wider">Hành Động</th>
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
              <td class="px-6 py-4 text-center">
                <div class="flex items-center justify-center">
                  <router-link :to="`/staff/orders/${order.maDH}`"
                    class="flex items-center gap-2 px-4 py-2 bg-[#C8A97E]/10 text-[#C8A97E] hover:bg-[#C8A97E] hover:text-white rounded-xl text-[10px] font-black uppercase tracking-widest transition-all duration-300 group border border-[#C8A97E]/30 shadow-sm active:scale-95">
                    Xem chi tiết
                    <span class="material-symbols-outlined text-[16px] group-hover:translate-x-1 transition-transform">arrow_forward</span>
                  </router-link>
                </div>
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
      startDate: '',
      endDate: '',
      page: 0,
      totalPages: 0,
      openDropdown: null
    }
  },

  methods: {
    async fetchOrders() {
      try {
        const res = await axios.get('/staff/orders', {
          params: {
            keyword: this.keyword || undefined,
            status: this.status !== '' ? this.status : undefined,
            startDate: this.startDate || undefined,
            endDate: this.endDate || undefined,
            page: this.page
          },
          withCredentials: true
        })
        this.orders     = res.data.content || res.data || []
        this.totalPages = res.data.totalPages || 1
      } catch (e) { console.error(e) }
    },

    changePage(p) { this.page = p; this.fetchOrders() },

    resetFilters() {
      this.keyword = '';
      this.status = '';
      this.startDate = '';
      this.endDate = '';
      this.page = 0;
      this.fetchOrders();
    },

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
    },

    closeDropdowns() {
      this.openDropdown = null
    },

    handleGlobalClick(e) {
      if (this.openDropdown && !e.target.closest('.relative')) {
        this.closeDropdowns()
      }
    }
  },

  mounted() {
    this.fetchOrders()
    document.addEventListener('click', this.handleGlobalClick)
  },

  beforeUnmount() {
    document.removeEventListener('click', this.handleGlobalClick)
  }
}
</script>
