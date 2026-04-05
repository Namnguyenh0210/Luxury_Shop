<template>
  <div class="p-8 space-y-8">
      
      <!-- PENDING ORDERS QUICK VIEW -->
      <div class="space-y-4">
        <div class="flex items-center justify-between">
          <h3 class="text-lg font-bold text-gray-800 flex items-center gap-2">
            <span v-if="pendingOrders.length > 0" class="flex h-3 w-3 rounded-full bg-red-500 animate-pulse"></span>
            <span v-else class="material-symbols-outlined text-gray-400 text-[20px]">notifications_none</span>
            Đơn hàng cần xác nhận
            <span class="px-2 py-0.5 bg-gray-100 text-gray-500 text-xs rounded-lg">{{ pendingOrders.length }}</span>
          </h3>
        </div>
        
        <div v-if="pendingOrders.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
          <div v-for="order in pendingOrders" :key="order.maDH" 
            class="bg-white p-5 rounded-2xl border-2 border-red-50 hover:border-red-200 shadow-sm transition-all group relative overflow-hidden">
            <div class="absolute top-0 right-0 p-3 opacity-10 group-hover:opacity-20 transition-opacity">
              <span class="material-symbols-outlined text-4xl text-red-500">pending_actions</span>
            </div>
            <div class="flex justify-between items-start mb-3">
              <div>
                <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Mã đơn hàng</span>
                <p class="font-mono text-sm font-bold text-yellow-700">#{{ order.maDH }}</p>
              </div>
              <p class="text-[10px] text-gray-400 font-medium whitespace-nowrap">{{ formatTimeAgo(order.ngayDat) }}</p>
            </div>
            <div class="space-y-1 mb-4">
              <p class="font-bold text-gray-800 truncate" :title="order.taiKhoan?.hoTen">{{ order.taiKhoan?.hoTen || 'Khách vãng lai' }}</p>
              <p class="text-lg font-black text-gray-900">{{ fmtCurrency(order.tongTien) }}</p>
            </div>
            <div class="flex items-center gap-2">
              <router-link :to="`/admin/orders/${order.maDH}`" 
                class="flex-1 text-center py-2 bg-yellow-400 hover:bg-yellow-500 text-yellow-900 text-[11px] font-black rounded-xl transition-all shadow-lg shadow-yellow-100">
                Xử lý ngay
              </router-link>
            </div>
          </div>
        </div>

        <!-- Empty State -->
        <div v-else class="bg-gray-50/50 border-2 border-dashed border-gray-200 rounded-3xl py-10 flex flex-col items-center justify-center text-gray-400">
           <span class="material-symbols-outlined text-4xl mb-2 opacity-50">task_alt</span>
           <p class="text-sm font-medium">Chưa có đơn hàng mới nào cần xác nhận</p>
        </div>
      </div>

      <!-- ACTION BAR -->
      <div class="flex flex-wrap items-center justify-between gap-6">
        <div class="flex flex-wrap items-center gap-4">
          <!-- Search -->
          <div class="relative w-72">
            <span class="absolute inset-y-0 left-3 flex items-center text-gray-400">
              <span class="material-symbols-outlined text-[20px]">search</span>
            </span>
            <input
              v-model="keyword"
              @input="onSearch"
              placeholder="Tìm tên khách hàng, email..."
              class="w-full border border-[#C8A97E]/50 rounded-2xl pl-10 pr-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 hover:border-[#C8A97E] transition-all shadow-sm"
            />
          </div>

          <!-- Custom Status Dropdown -->
          <div class="relative min-w-[200px]">
            <button @click.stop="openDropdown = openDropdown === 'status' ? null : 'status'"
              class="w-full border border-[#C8A97E]/50 rounded-2xl px-5 py-2.5 pr-10 text-sm bg-white text-left focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 hover:border-[#C8A97E] transition-all shadow-sm flex items-center justify-between">
              <span class="truncate font-medium text-gray-700">{{ getStatusLabel(status) || 'Tất cả trạng thái' }}</span>
              <span class="material-symbols-outlined text-[20px] absolute right-3 text-[#C8A97E]">expand_more</span>
            </button>
            <div v-if="openDropdown === 'status'" @click.stop class="absolute z-50 w-full mt-2 bg-white border border-[#C8A97E]/30 rounded-2xl shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-200">
              <div @click="status = ''; onSearch(); openDropdown = null" 
                class="px-5 py-3 text-sm cursor-pointer transition-colors border-b border-gray-50 bg-yellow-50/30" 
                :class="!status ? 'font-bold text-[#C8A97E]' : 'text-gray-500 hover:bg-[#C8A97E]/10'">
                Tất cả trạng thái
              </div>
              <div class="max-h-60 overflow-y-auto custom-scrollbar">
                <div v-for="s in statusOptions" :key="s.value" @click="status = s.value; onSearch(); openDropdown = null" 
                  class="px-5 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="status === s.value ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">
                  {{ s.label }}
                </div>
              </div>
            </div>
          </div>
          
          <!-- Nút Làm mới -->
          <button @click="resetFilters" 
            class="flex items-center justify-center size-10 rounded-2xl border border-[#C8A97E]/30 bg-white text-[#C8A97E] hover:bg-[#C8A97E] hover:text-white transition-all shadow-sm group"
            title="Làm mới bộ lọc">
            <span class="material-symbols-outlined text-[22px] group-hover:rotate-180 transition-transform duration-500">refresh</span>
          </button>
        </div>

        <!-- Time Range Filters -->
        <div class="flex items-center bg-gray-100 p-1 rounded-2xl shadow-inner">
          <button 
            v-for="range in timeRanges" 
            :key="range.value"
            @click="setTimeRange(range.value)"
            class="px-4 py-2 text-xs font-bold rounded-xl transition-all whitespace-nowrap"
            :class="timeRange === range.value ? 'bg-white text-yellow-700 shadow-sm' : 'text-gray-500 hover:text-gray-700'"
          >
            {{ range.label }}
          </button>
        </div>
      </div>

      <!-- TABLE -->
      <div class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm overflow-hidden">
        <table v-if="orders.length > 0" class="w-full text-sm">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Mã ĐH</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Khách Hàng</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Ngày Đặt</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Tổng Tiền</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Trạng Thái Đơn</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Thanh Toán</th>
              <th class="px-6 py-4 text-right text-xs font-semibold text-gray-500 uppercase tracking-wider">Chi Tiết</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr v-for="order in orders" :key="order.maDH" class="hover:bg-yellow-50/50 transition-colors">
              <td class="px-6 py-4 font-mono text-xs text-yellow-700 font-bold">#{{ order.maDH }}</td>
              <td class="px-6 py-4">
                <p class="font-semibold text-gray-800">{{ order.taiKhoan?.hoTen || 'Khách vãng lai' }}</p>
                <p class="text-xs text-gray-400">{{ order.taiKhoan?.email }}</p>
              </td>
              <td class="px-6 py-4 text-gray-600">{{ formatDate(order.ngayDat) }}</td>
              <td class="px-6 py-4 font-bold text-gray-800">{{ fmtCurrency(order.tongTien) }}</td>
              <td class="px-6 py-4">
                <span class="inline-flex items-center px-2.5 py-1 text-[11px] font-bold rounded-full"
                  :class="statusClass(order.trangThaiDH)">
                  {{ statusText(order.trangThaiDH) }}
                </span>
              </td>
              <td class="px-6 py-4">
                <span class="inline-flex items-center px-2.5 py-1 text-[11px] font-bold rounded-full shadow-sm border border-transparent"
                  :class="payStatusClass(order.trangThaiThanhToan)">
                  {{ payStatusText(order.trangThaiThanhToan) }}
                </span>
              </td>
              <td class="px-6 py-4 text-right">
                <router-link :to="`/admin/orders/${order.maDH}`"
                  class="text-xs font-medium text-yellow-700 bg-yellow-50 hover:bg-yellow-100 px-3 py-1.5 rounded-lg transition-colors inline-flex items-center gap-1">
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
        <span class="px-4 py-2 bg-yellow-600 text-white rounded-xl text-sm font-bold">{{ page + 1 }}</span>
        <button v-if="page < totalPages - 1" @click="changePage(page + 1)"
          class="flex items-center gap-1 px-4 py-2 border border-gray-200 rounded-xl hover:bg-gray-50 text-sm font-medium transition-colors">
          Sau
          <span class="material-symbols-outlined text-[16px]">chevron_right</span>
        </button>
      </div>
    </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'OrderList',

  data() {
    return {
      orders: [],
      pendingOrders: [],
      keyword: '',
      status: '',
      timeRange: '',
      page: 0,
      totalPages: 0,
      timeRanges: [
        { label: 'Tất cả', value: '' },
        { label: 'Hôm nay', value: 'day' },
        { label: 'Tuần này', value: 'week' },
        { label: 'Tháng này', value: 'month' },
        { label: 'Năm nay', value: 'year' },
      ],
      openDropdown: null,
      statusOptions: [
        { value: '0', label: 'Chờ xác nhận' },
        { value: '1', label: 'Đã xác nhận' },
        { value: '2', label: 'Đang giao' },
        { value: '3', label: 'Đã giao' },
        { value: '4', label: 'Hoàn tất' },
        { value: '5', label: 'Đã hủy' },
        { value: '6', label: 'Lỗi thanh toán' },
        { value: '7', label: 'Chờ thanh toán' }
      ]
    }
  },

  methods: {
    async fetchOrders() {
      try {
        const res = await axios.get('/admin/orders', {
          params: { 
            keyword: this.keyword, 
            status: this.status, 
            timeRange: this.timeRange,
            page: this.page,
            size: 10
          },
          withCredentials: true
        })
        this.orders     = res.data.content || []
        this.totalPages = res.data.totalPages || 0
      } catch (e) { 
        console.error('Lỗi khi tải đơn hàng:', e)
        this.orders = []
      }
    },

    async fetchPendingOrders() {
      try {
        const res = await axios.get('/admin/orders', {
          params: { status: 0, page: 0, size: 6 },
          withCredentials: true
        })
        this.pendingOrders = res.data.content || []
      } catch (e) { console.error(e) }
    },

    onSearch() {
      this.page = 0
      this.fetchOrders()
    },

    resetFilters() {
      this.keyword = ''
      this.status = ''
      this.timeRange = ''
      this.onSearch()
    },

    closeDropdowns() {
      if (!e.target.closest('.relative')) {
        this.openDropdown = null
      }
    },

    setTimeRange(val) {
      this.timeRange = val
      this.onSearch()
    },

    changePage(p) { this.page = p; this.fetchOrders() },

    formatDate(d) { return d ? new Date(d).toLocaleDateString('vi-VN') : '---' },

    formatTimeAgo(date) {
      if (!date) return '';
      const seconds = Math.floor((new Date() - new Date(date)) / 1000);
      let interval = seconds / 31536000;
      if (interval > 1) return Math.floor(interval) + " năm trước";
      interval = seconds / 2592000;
      if (interval > 1) return Math.floor(interval) + " tháng trước";
      interval = seconds / 86400;
      if (interval > 1) return Math.floor(interval) + " ngày trước";
      interval = seconds / 3600;
      if (interval > 1) return Math.floor(interval) + " giờ trước";
      interval = seconds / 60;
      if (interval > 1) return Math.floor(interval) + " phút trước";
      return "Vừa xong";
    },

    fmtCurrency(v) {
      return new Intl.NumberFormat('vi-VN').format(v || 0) + ' đ'
    },

    statusText(s) {
      return { 
        0: 'Chờ xác nhận', 
        1: 'Đã xác nhận', 
        2: 'Đang giao', 
        3: 'Đã giao', 
        4: 'Hoàn tất', 
        5: 'Đã hủy',
        6: 'Lỗi thanh toán',
        7: 'Chờ thanh toán'
      }[s] ?? 'Không xác định'
    },

    statusClass(s) {
      return {
        0: 'bg-yellow-100 text-yellow-700',
        1: 'bg-blue-100  text-blue-700',
        2: 'bg-indigo-100 text-indigo-700',
        3: 'bg-purple-100 text-purple-700',
        4: 'bg-green-100 text-green-700',
        5: 'bg-red-100   text-red-700',
        6: 'bg-orange-100 text-orange-700',
        7: 'bg-cyan-100 text-cyan-700 font-black animate-pulse'
      }[s] ?? 'bg-gray-100 text-gray-600'
    },

    payStatusText(s) {
      return {
        0: 'Chờ thanh toán',
        1: 'Đã thanh toán',
        2: 'Thất bại',
        3: 'Hết hạn',
        4: 'COD - Chưa thu'
      }[s] ?? 'Không xác định'
    },

    payStatusClass(s) {
      return {
        0: 'bg-yellow-50 text-yellow-600 border-yellow-200',
        1: 'bg-green-100 text-green-700 border-green-200',
        2: 'bg-red-100 text-red-700 border-red-200',
        3: 'bg-gray-100 text-gray-500 border-gray-200',
        4: 'bg-blue-50 text-blue-600 border-blue-200'
      }[s] ?? 'bg-gray-50 text-gray-400'
    },
    
    getStatusLabel(val) {
      if (!val) return ''
      return this.statusOptions.find(o => o.value === val)?.label || ''
    },
    
    closeDropdowns() {
      this.openDropdown = null
    }
  },

  mounted() { 
    window.addEventListener('click', this.closeDropdowns)
    this.fetchOrders();
    this.fetchPendingOrders();
  },

  beforeUnmount() {
    window.removeEventListener('click', this.closeDropdowns)
  }
}
</script>
