<template>
  
    <div class="p-8 space-y-6">

      <!-- THỐNG KÊ NHANH -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Chart Cột -->
        <div class="lg:col-span-2 bg-white p-6 rounded-2xl border border-[#C8A97E] shadow-sm">
          <h3 class="font-bold text-gray-800 flex items-center gap-2 mb-4">
            <span class="material-symbols-outlined text-blue-500">bar_chart</span> Phân Tích Đánh Giá Sản Phẩm (Top)
          </h3>
          <div class="h-64 relative w-full">
            <canvas id="reviewChart"></canvas>
          </div>
        </div>

        <div class="flex flex-col gap-6">
          <div class="bg-white p-6 rounded-2xl border border-[#C8A97E] shadow-sm flex-1">
            <h3 class="font-bold text-gray-800 flex items-center gap-2 mb-4">
              <span class="material-symbols-outlined text-green-500">trending_up</span> Top Đánh Giá Cao
            </h3>
            <div v-if="stats.topHigh.length" class="space-y-3">
              <div v-for="(sp, idx) in stats.topHigh.slice(0,3)" :key="idx" class="flex justify-between items-center text-sm">
                <span class="text-gray-700 font-medium truncate flex-1 pr-4" :title="sp.tenSP">{{ sp.tenSP }}</span>
                <div class="flex items-center gap-1.5 text-yellow-500 font-bold whitespace-nowrap bg-yellow-50 px-2 py-0.5 rounded">
                  <span>{{ Math.round(sp.diem * 10) / 10 }}</span> <span class="material-symbols-outlined text-[14px]">star</span>
                </div>
              </div>
            </div>
            <div v-else class="text-sm text-gray-400">Chưa có dữ liệu</div>
          </div>

          <div class="bg-white p-6 rounded-2xl border border-[#C8A97E] shadow-sm flex-1">
            <h3 class="font-bold text-gray-800 flex items-center gap-2 mb-4">
              <span class="material-symbols-outlined text-red-500">trending_down</span> Cần Lưu Ý (Thấp)
            </h3>
            <div v-if="stats.topLow.length" class="space-y-3">
              <div v-for="(sp, idx) in stats.topLow.slice(0,3)" :key="idx" class="flex justify-between items-center text-sm">
                <span class="text-gray-700 font-medium truncate flex-1 pr-4" :title="sp.tenSP">{{ sp.tenSP }}</span>
                <div class="flex items-center gap-1.5 text-red-500 font-bold whitespace-nowrap bg-red-50 px-2 py-0.5 rounded">
                  <span>{{ Math.round(sp.diem * 10) / 10 }}</span> <span class="material-symbols-outlined text-[14px]">star</span>
                </div>
              </div>
            </div>
            <div v-else class="text-sm text-gray-400">Chưa có dữ liệu</div>
          </div>
        </div>
      </div>

      <!-- BỘ LỌC -->
      <div class="flex flex-wrap items-center gap-4 bg-white p-4 rounded-2xl border border-[#C8A97E] shadow-sm">
        <div class="relative w-72">
          <span class="absolute inset-y-0 left-3 flex items-center text-gray-400">
            <span class="material-symbols-outlined text-[20px]">search</span>
          </span>
          <input
            v-model="filterKeyword"
            @keyup.enter="fetchReviews"
            placeholder="Tìm theo sản phẩm, user..."
            class="w-full border border-[#C8A97E]/50 rounded-2xl pl-10 pr-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 hover:border-[#C8A97E] transition-all shadow-sm"
          />
        </div>

        <!-- Custom Status Dropdown -->
        <div class="relative min-w-[200px]">
          <button @click.stop="openDropdown = openDropdown === 'status' ? null : 'status'"
            class="w-full border border-[#C8A97E]/50 rounded-2xl px-5 py-2.5 pr-10 text-sm bg-white text-left focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 hover:border-[#C8A97E] transition-all shadow-sm flex items-center justify-between">
            <span class="truncate font-medium text-gray-700">{{ getStatusLabel(filterStatus) || 'Tất cả trạng thái' }}</span>
            <span class="material-symbols-outlined text-[20px] absolute right-3 text-[#C8A97E]">expand_more</span>
          </button>
          <div v-if="openDropdown === 'status'" @click.stop class="absolute z-50 w-full mt-2 bg-white border border-[#C8A97E]/30 rounded-2xl shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-200">
            <div @click="filterStatus = ''; fetchReviews(); openDropdown = null" 
              class="px-5 py-3 text-sm cursor-pointer transition-colors border-b border-gray-50 bg-yellow-50/30" 
              :class="filterStatus === '' ? 'font-bold text-[#C8A97E]' : 'text-gray-500 hover:bg-[#C8A97E]/10'">
              Tất cả trạng thái
            </div>
            <div @click="filterStatus = 0; fetchReviews(); openDropdown = null" class="px-5 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="filterStatus === 0 ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">⏳ Chờ duyệt</div>
            <div @click="filterStatus = 1; fetchReviews(); openDropdown = null" class="px-5 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="filterStatus === 1 ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">✅ Đã hiển thị</div>
            <div @click="filterStatus = 2; fetchReviews(); openDropdown = null" class="px-5 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="filterStatus === 2 ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">🚫 Đã ẩn</div>
          </div>
        </div>

        <!-- Nút Làm mới -->
        <button @click="resetFilters" 
          class="flex items-center justify-center size-10 rounded-2xl border border-[#C8A97E]/30 bg-white text-[#C8A97E] hover:bg-[#C8A97E] hover:text-white transition-all shadow-sm group"
          title="Làm mới bộ lọc">
          <span class="material-symbols-outlined text-[22px] group-hover:rotate-180 transition-transform duration-500">refresh</span>
        </button>
      </div>

      <!-- BẢNG DANH SÁCH -->
      <div class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm overflow-hidden">
        <table class="w-full text-sm">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-5 py-3 text-left font-semibold text-gray-500 uppercase tracking-wider text-xs w-1/4">Sản Phẩm & User</th>
              <th class="px-5 py-3 text-left font-semibold text-gray-500 uppercase tracking-wider text-xs w-2/5">Nội Dung Đánh Giá</th>
              <th class="px-5 py-3 text-left font-semibold text-gray-500 uppercase tracking-wider text-xs">Phản Hồi (Admin)</th>
              <th class="px-5 py-3 text-center font-semibold text-gray-500 uppercase tracking-wider text-xs">Trạng Thái</th>
              <th class="px-5 py-3 text-center font-semibold text-gray-500 uppercase tracking-wider text-xs">Hành Động</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr v-for="rv in reviews" :key="rv.maDG" class="hover:bg-gray-50/50 transition-colors">
              <td class="px-5 py-4">
                <div class="font-semibold text-gray-800 line-clamp-2" :title="rv.tenSP">{{ rv.tenSP }}</div>
                <div class="text-xs text-gray-500 mt-1 flex items-center gap-1">
                  <span class="material-symbols-outlined text-[14px]">person</span> {{ rv.tenNguoiDung }}
                </div>
                <div class="text-xs text-gray-400 mt-0.5">{{ rv.ngayDanhGia }}</div>
              </td>
              
              <td class="px-5 py-4">
                <div class="flex items-center text-yellow-500 mb-1">
                  <span v-for="i in 5" :key="i" class="text-sm" :class="i <= rv.diem ? 'text-yellow-400' : 'text-gray-200'">★</span>
                </div>
                <p class="text-gray-700 line-clamp-3 text-sm leading-snug">{{ rv.noiDung }}</p>
                <div v-if="rv.reportCount > 0" class="mt-2 inline-flex items-center gap-1 text-xs px-2 py-0.5 rounded-full bg-red-100 text-red-600 font-medium">
                  <span class="material-symbols-outlined text-[14px]">flag</span> Bị báo cáo ({{ rv.reportCount }})
                </div>
              </td>

              <td class="px-5 py-4">
                <div v-if="rv.phanHoi" class="text-sm text-gray-600 bg-blue-50/50 p-2.5 rounded-lg border border-blue-100">
                  <div class="font-semibold text-blue-700 text-xs mb-1 flex items-center gap-1">
                    <span class="material-symbols-outlined text-[14px]">storefront</span> Admin ({{ rv.ngayPhanHoi }})
                  </div>
                  {{ rv.phanHoi }}
                </div>
                <button v-else @click="moModalPhanHoi(rv)" class="text-xs font-medium text-blue-600 hover:text-blue-800 transition-colors">
                  + Thêm phản hồi
                </button>
              </td>

              <td class="px-5 py-4 text-center">
                <span v-if="rv.trangThai === 0" class="inline-flex items-center px-2.5 py-1 text-xs font-medium rounded-full bg-orange-100 text-orange-700">
                  Chờ duyệt
                </span>
                <span v-else-if="rv.trangThai === 1" class="inline-flex items-center px-2.5 py-1 text-xs font-medium rounded-full bg-green-100 text-green-700">
                  Đã hiện
                </span>
                <span v-else-if="rv.trangThai === 2" class="inline-flex items-center px-2.5 py-1 text-xs font-medium rounded-full bg-gray-100 text-gray-600">
                  Đã ẩn
                </span>
              </td>

              <td class="px-5 py-4 text-center">
                <div class="flex flex-col items-center gap-2">
                  <div class="flex gap-2">
                    <button v-if="rv.trangThai !== 1" @click="updateStatus(rv.maDG, 1)" title="Duyệt (Hiển thị)"
                      class="flex items-center justify-center size-7 rounded bg-green-50 text-green-600 hover:bg-green-100 transition-colors">
                      <span class="material-symbols-outlined text-[16px]">visibility</span>
                    </button>
                    <button v-if="rv.trangThai !== 2" @click="updateStatus(rv.maDG, 2)" title="Ẩn"
                      class="flex items-center justify-center size-7 rounded bg-gray-100 text-gray-600 hover:bg-gray-200 transition-colors">
                      <span class="material-symbols-outlined text-[16px]">visibility_off</span>
                    </button>
                  </div>
                  <div class="flex gap-2">
                    <button @click="moModalPhanHoi(rv)" title="Trả lời"
                      class="flex items-center justify-center size-7 rounded bg-blue-50 text-blue-600 hover:bg-blue-100 transition-colors">
                      <span class="material-symbols-outlined text-[16px]">reply</span>
                    </button>
                    <button @click="xoaDanhGia(rv.maDG)" title="Xoá vĩnh viễn"
                      class="flex items-center justify-center size-7 rounded bg-red-50 text-red-600 hover:bg-red-100 transition-colors">
                      <span class="material-symbols-outlined text-[16px]">delete</span>
                    </button>
                  </div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>

        <!-- Loading / Empty -->
        <div v-if="loading" class="py-12 text-center text-gray-500">Đang tải dữ liệu...</div>
        <div v-else-if="reviews.length === 0" class="py-12 text-center text-gray-400">
          <span class="material-symbols-outlined text-4xl mb-2">find_in_page</span>
          <p>Không tìm thấy đánh giá nào phù hợp!</p>
        </div>

        <!-- Pagination -->
        <div v-if="totalPages > 1" class="px-5 py-4 border-t border-gray-200 flex justify-end gap-2 text-sm">
          <button v-for="p in totalPages" :key="p" @click="currentPage = p-1; fetchReviews()"
            class="size-8 flex items-center justify-center rounded-lg border font-medium transition-colors"
            :class="currentPage === p-1 ? 'bg-yellow-600 text-white border-yellow-600' : 'bg-white text-gray-600 border-gray-300 hover:bg-gray-50'">
            {{ p }}
          </button>
        </div>
      </div>

    </div>

    <!-- MODAL PHẢN HỒI -->
    <div v-if="hienModalReply" class="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4" @click.self="dongModalPhanHoi">
      <div class="bg-white rounded-2xl w-full max-w-lg shadow-2xl overflow-hidden">
        <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50">
          <h3 class="font-bold text-gray-800">Phản Hồi Đánh Giá</h3>
          <button @click="dongModalPhanHoi" class="text-gray-400 hover:text-gray-600"><span class="material-symbols-outlined">close</span></button>
        </div>
        <div class="p-6">
          <div class="bg-yellow-50/50 p-4 rounded-xl border border-yellow-100 mb-5">
            <p class="text-sm text-gray-700 italic">"{{ selectedReview?.noiDung }}"</p>
            <div class="text-xs text-yellow-600 mt-2 font-medium">— Từ {{ selectedReview?.tenNguoiDung }}</div>
          </div>
          <label class="block text-xs font-bold text-gray-600 uppercase mb-2">Lời Phản Hồi Từ Shop</label>
          <textarea v-model="noiDungReply" rows="4" placeholder="Nhập câu trả lời để đại diện shop phản hồi khách hàng..."
            class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-yellow-400 resize-none"></textarea>
        </div>
        <div class="px-6 py-4 bg-gray-50 border-t border-gray-100 flex justify-end gap-3">
          <button @click="dongModalPhanHoi" class="px-4 py-2 border border-gray-200 bg-white rounded-lg text-sm font-medium hover:bg-gray-100 transition-colors">Hủy</button>
          <button @click="guiPhanHoi" class="px-4 py-2 bg-yellow-600 text-white rounded-lg text-sm font-semibold shadow hover:bg-yellow-700 transition-colors">
            Gửi Phản Hồi
          </button>
        </div>
      </div>
    </div>
  
</template>

<script>
import axios from 'axios'
import Chart from 'chart.js/auto'

export default {
  name: 'ReviewsAdmin',
  data() {
    return {
      reviews: [],
      stats: { topHigh: [], topLow: [] },
      filterKeyword: '',
      filterStatus: '',
      currentPage: 0,
      totalPages: 0,
      loading: false,

      hienModalReply: false,
      selectedReview: null,
      noiDungReply: '',
      chartInstance: null,
      openDropdown: null
    }
  },
  mounted() {
    window.addEventListener('click', this.closeDropdowns)
    this.fetchStats()
    this.fetchReviews()
  },
  beforeUnmount() {
    window.removeEventListener('click', this.closeDropdowns)
  },
  methods: {
    async fetchReviews() {
      this.loading = true
      try {
        const res = await axios.get('/admin/danh-gia', {
          params: { keyword: this.filterKeyword, trangThai: this.filterStatus, page: this.currentPage },
          withCredentials: true
        })
        if (res.data.thanhCong) {
          this.reviews = res.data.danhSach || []
          this.totalPages = res.data.tongTrang || 0
        }
      } catch (e) {
        console.error(e)
      } finally {
        this.loading = false
      }
    },


    getStatusLabel(val) {
      if (val === '') return ''
      if (val === 0) return '⏳ Chờ duyệt'
      if (val === 1) return '✅ Đã hiển thị'
      if (val === 2) return '🚫 Đã ẩn'
      return ''
    },

    resetFilters() {
      this.filterKeyword = ''
      this.filterStatus = ''
      this.fetchReviews()
    },

    closeDropdowns() {
      this.openDropdown = null
    },
    async fetchStats() {
      try {
        const res = await axios.get('/admin/danh-gia/stats', { withCredentials: true })
        if (res.data.thanhCong) {
          this.stats.topHigh = res.data.topHigh || []
          this.stats.topLow = res.data.topLow || []
          
          this.$nextTick(() => {
            this.renderChart()
          })
        }
      } catch (e) { console.error(e) }
    },
    renderChart() {
      const ctx = document.getElementById('reviewChart')
      if (!ctx) return
      
      if (this.chartInstance) {
        this.chartInstance.destroy()
      }

      // Giới hạn 7 sản phẩm hiển thị trên biểu đồ
      const labels = this.stats.topHigh.slice(0, 7).map(item => {
        return item.tenSP.length > 20 ? item.tenSP.substring(0, 20) + '...' : item.tenSP
      });
      const dataPoints = this.stats.topHigh.slice(0, 7).map(item => Math.round(item.diem * 10) / 10);
      const counts = this.stats.topHigh.slice(0, 7).map(item => item.tongDG);

      this.chartInstance = new Chart(ctx, {
        type: 'bar',
        data: {
          labels: labels,
          datasets: [{
            label: 'Điểm số trung bình (sao)',
            data: dataPoints,
            backgroundColor: 'rgba(212, 168, 83, 0.85)',
            borderColor: 'rgba(212, 168, 83, 1)',
            borderWidth: 1,
            borderRadius: 6,
            barThickness: 32
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: { display: false },
            tooltip: {
              callbacks: {
                afterLabel: function(context) {
                  return `Số lượt đánh giá: ${counts[context.dataIndex]}`;
                }
              }
            }
          },
          scales: {
            y: {
              beginAtZero: true,
              max: 5,
              ticks: { stepSize: 1 }
            },
            x: {
              grid: { display: false }
            }
          }
        }
      })
    },
    async updateStatus(id, newStatus) {
      const ok = await window.$confirm(`Xác nhận ${newStatus === 1 ? 'DUYỆT (Hiển thị)' : 'ẨN'} đánh giá này?`)
      if(!ok) return
      try {
        const res = await axios.put(`/admin/danh-gia/${id}/status`, { trangThai: newStatus }, { withCredentials: true })
        if(res.data.thanhCong) {
          window.$alert('Cập nhật thành công', 'Thành công')
          this.fetchReviews()
        } else window.$alert('Lỗi: ' + res.data.thongBao, 'Lỗi')
      } catch (e) { window.$alert('Lỗi kết nối', 'Lỗi') }
    },
    async xoaDanhGia(id) {
      const ok = await window.$confirm('Bạn có chắc chắn muốn xóa vĩnh viễn đánh giá này?')
      if(!ok) return
      try {
        const res = await axios.delete(`/admin/danh-gia/${id}`, { withCredentials: true })
        if(res.data.thanhCong) {
          window.$alert('Đã xóa thành công', 'Thành công')
          this.fetchReviews()
          this.fetchStats()
        } else window.$alert('Lỗi: ' + res.data.thongBao, 'Lỗi')
      } catch (e) { window.$alert('Lỗi kết nối', 'Lỗi') }
    },
    moModalPhanHoi(rv) {
      this.selectedReview = rv
      this.noiDungReply = rv.phanHoi || ''
      this.hienModalReply = true
    },
    dongModalPhanHoi() {
      this.hienModalReply = false
      this.selectedReview = null
      this.noiDungReply = ''
    },
    async guiPhanHoi() {
      try {
        const res = await axios.post(`/admin/danh-gia/${this.selectedReview.maDG}/reply`, 
          { phanHoi: this.noiDungReply }, { withCredentials: true })
        if(res.data.thanhCong) {
          window.$alert('Đã phản hồi!', 'Thành công')
          this.dongModalPhanHoi()
          this.fetchReviews()
        } else window.$alert('Lỗi: ' + res.data.thongBao, 'Lỗi')
      } catch (e) { window.$alert('Lỗi kết nối', 'Lỗi') }
    }
  }
}
</script>
