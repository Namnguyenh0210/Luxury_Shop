<template>
  
    <div class="p-8 space-y-6">

      <!-- THỐNG KÊ NHANH & CHART -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Chart Cột -->
        <div class="lg:col-span-2 bg-white p-6 rounded-2xl border border-[#C8A97E] shadow-sm">
          <h3 class="font-bold text-gray-800 flex items-center gap-2 mb-4">
            <span class="material-symbols-outlined text-purple-500">insert_chart</span> Bài Viết Được Thảo Luận Nhiều Nhất
          </h3>
          <div class="h-64 relative w-full">
            <canvas id="commentChart"></canvas>
          </div>
        </div>

        <!-- Danh sách thống kê -->
        <div class="bg-white p-6 rounded-2xl border border-[#C8A97E] shadow-sm flex flex-col">
          <h3 class="font-bold text-gray-800 flex items-center gap-2 mb-4">
            <span class="material-symbols-outlined text-orange-500">local_fire_department</span> Top Bài Viết Hot
          </h3>
          <div v-if="stats.topBlogs.length" class="space-y-4 flex-1 overflow-y-auto">
            <div v-for="(blog, idx) in stats.topBlogs.slice(0, 5)" :key="idx" class="flex justify-between items-center text-sm">
              <span class="text-gray-700 font-medium truncate flex-1 pr-4" :title="blog.tieuDe">{{ blog.tieuDe }}</span>
              <div class="flex items-center gap-1.5 text-purple-600 font-bold whitespace-nowrap bg-purple-50 px-2 py-0.5 rounded">
                <span>{{ blog.tongBL }}</span> <span class="material-symbols-outlined text-[14px]">forum</span>
              </div>
            </div>
          </div>
          <div v-else class="text-sm text-gray-400">Chưa có dữ liệu</div>
        </div>
      </div>

      <!-- BỘ LỌC -->
      <div class="flex flex-wrap items-center gap-4 bg-white p-4 rounded-2xl border border-[#C8A97E] shadow-sm">
        <div class="relative group">
          <span class="absolute inset-y-0 left-4 flex items-center text-[#C8A97E] group-focus-within:text-black transition-colors">
            <span class="material-symbols-outlined text-[20px]">search</span>
          </span>
          <input
            v-model="filterKeyword"
            @keyup.enter="fetchComments"
            placeholder="Tìm bài viết, khách hàng..."
            class="w-full border border-[#C8A97E]/50 rounded-2xl pl-12 pr-4 py-3 text-sm bg-white focus:outline-none focus:ring-4 focus:ring-[#C8A97E]/10 focus:border-[#C8A97E] transition-all shadow-sm font-bold text-gray-700 placeholder:text-gray-400"
          />
        </div>

        <!-- Custom Status Dropdown -->
        <div class="relative min-w-[200px]">
            <button @click.stop="openDropdown = openDropdown === 'status' ? null : 'status'"
              class="w-full border border-[#C8A97E]/50 rounded-2xl px-5 py-3 pr-10 text-sm bg-white text-left focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/20 hover:border-[#C8A97E] transition-all shadow-sm flex items-center justify-between">
              <span class="truncate font-black text-gray-700 uppercase tracking-widest text-[11px]">{{ getStatusLabel(filterStatus) || 'Tất cả trạng thái' }}</span>
              <span class="material-symbols-outlined text-[20px] absolute right-3 text-[#C8A97E]">expand_more</span>
            </button>
          <div v-if="openDropdown === 'status'" @click.stop class="absolute z-50 w-full mt-2 bg-white border border-[#C8A97E]/30 rounded-2xl shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-200">
            <div @click="filterStatus = ''; fetchComments(); openDropdown = null" 
              class="px-5 py-3 text-sm cursor-pointer transition-colors border-b border-gray-50 bg-yellow-50/30" 
              :class="filterStatus === '' ? 'font-bold text-[#C8A97E]' : 'text-gray-500 hover:bg-[#C8A97E]/10'">
              Tất cả trạng thái
            </div>
            <div @click="filterStatus = true; fetchComments(); openDropdown = null" class="px-5 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="filterStatus === true ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">✅ Giao diện hiển thị</div>
            <div @click="filterStatus = false; fetchComments(); openDropdown = null" class="px-5 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="filterStatus === false ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">🚫 Đã ẩn vi phạm</div>
          </div>
        </div>
        <!-- Date Filters -->
        <div class="flex items-center gap-2 bg-white rounded-2xl p-1.5 border border-[#C8A97E]/30 shadow-sm shadow-[#C8A97E]/5">
          <input type="date" v-model="filterStartDate" @change="fetchComments" class="bg-transparent border-none text-[11px] font-black text-gray-700 focus:ring-0 w-[115px] cursor-pointer">
          <span class="text-[#C8A97E] px-1 font-bold">→</span>
          <input type="date" v-model="filterEndDate" @change="fetchComments" class="bg-transparent border-none text-[11px] font-black text-gray-700 focus:ring-0 w-[115px] cursor-pointer">
        </div>

        <!-- Nút Làm mới -->
        <button @click="resetFilters" 
          class="flex items-center justify-center size-10 rounded-2xl border border-[#C8A97E]/30 bg-white text-[#C8A97E] hover:bg-[#C8A97E] hover:text-white transition-all shadow-sm group"
          title="Làm mới bộ lọc">
          <span class="material-symbols-outlined text-[22px] group-hover:rotate-180 transition-transform duration-500">refresh</span>
        </button>
      </div>

      <!-- BẢNG DANH SÁCH -->
      <div class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm overflow-hidden text-left">
        <table class="w-full text-sm">
          <thead class="bg-[#EFE9DB] border-b border-[#C8A97E]/30">
            <tr>
              <th class="px-5 py-3 text-left font-black text-black uppercase tracking-wider text-xs w-[20%]">Bài Viết & User</th>
              <th class="px-5 py-3 text-left font-black text-black uppercase tracking-wider text-xs w-[25%]">Nội Dung Bình Luận</th>
              <th class="px-5 py-3 text-left font-black text-black uppercase tracking-wider text-xs w-[25%]">Phản Hồi (Admin)</th>
              <th class="px-5 py-3 text-center font-black text-black uppercase tracking-wider text-xs w-[15%]">Trạng Thái</th>
              <th class="px-5 py-3 text-center font-black text-black uppercase tracking-wider text-xs w-[15%]">Hành Động</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr v-for="bl in comments" :key="bl.maBL" class="hover:bg-purple-50/30 transition-colors">
              <td class="px-5 py-4">
                <div class="font-semibold text-gray-800 line-clamp-2" :title="bl.tieuDe">{{ bl.tieuDe }}</div>
                <div class="text-xs text-gray-500 mt-1 flex items-center gap-1">
                  <span class="material-symbols-outlined text-[14px]">person</span> {{ bl.tenNguoiDung }}
                </div>
                <div class="text-xs text-gray-400 mt-0.5">{{ bl.ngayBinhLuan }}</div>
              </td>
              
              <td class="px-5 py-4">
                <p class="text-gray-700 line-clamp-3 text-sm leading-snug">{{ bl.noiDung }}</p>
                <div v-if="bl.reportCount > 0" class="mt-2 inline-flex items-center gap-1 text-xs px-2 py-0.5 rounded-full bg-red-100 text-red-600 font-medium">
                  <span class="material-symbols-outlined text-[14px]">flag</span> Bị báo cáo ({{ bl.reportCount }})
                </div>
              </td>

              <td class="px-5 py-4">
                <div v-if="bl.phanHoiAdmin" class="text-sm text-gray-600 bg-purple-50/50 p-2.5 rounded-lg border border-purple-100">
                  <div class="font-semibold text-purple-700 text-[10px] mb-1 flex items-center gap-1 uppercase tracking-wider text-left">
                    <span class="material-symbols-outlined text-[12px]">admin_panel_settings</span> Admin ({{ bl.ngayPhanHoiAdmin }})
                  </div>
                  <div class="text-left">{{ bl.phanHoiAdmin }}</div>
                </div>
                <button v-else @click="moModalPhanHoi(bl)" class="text-xs font-medium text-purple-400 hover:text-purple-600 transition-colors flex items-center gap-1 italic">
                  <span class="material-symbols-outlined text-[14px]">add_comment</span> Chờ phản hồi...
                </button>
              </td>

              <td class="px-5 py-4 text-center">
                <span v-if="bl.trangThai === false" class="inline-flex items-center px-2.5 py-1 text-[10px] font-bold rounded-full bg-gray-100 text-gray-500 uppercase tracking-wider">
                  Đã ẩn
                </span>
                <span v-else-if="bl.trangThai === true" class="inline-flex items-center px-2.5 py-1 text-[10px] font-bold rounded-full bg-green-100 text-green-600 uppercase tracking-wider">
                  Hiển thị
                </span>
              </td>

              <td class="px-5 py-4">
                <div class="flex items-center justify-center gap-4">
                  <!-- Eye Icon (Show/Hide) -->
                  <button v-if="bl.trangThai === true" @click="updateStatus(bl.maBL, false)" title="Ẩn vi phạm"
                    class="text-gray-400 hover:text-slate-600 transition-colors">
                    <span class="material-symbols-outlined text-[22px]">visibility</span>
                  </button>
                  <button v-else @click="updateStatus(bl.maBL, true)" title="Hiển thị lại"
                    class="text-green-400 hover:text-green-600 transition-colors">
                    <span class="material-symbols-outlined text-[22px]">visibility_off</span>
                  </button>

                  <!-- Edit/Reply Icon -->
                  <button @click="moModalPhanHoi(bl)" title="Phản hồi"
                    class="text-blue-400 hover:text-blue-600 transition-colors">
                    <span class="material-symbols-outlined text-[22px]">edit_note</span>
                  </button>

                  <!-- Delete Icon -->
                  <button @click="xoaBinhLuan(bl.maBL)" title="Xoá vĩnh viễn"
                    class="text-red-400 hover:text-red-600 transition-colors">
                    <span class="material-symbols-outlined text-[22px]">delete</span>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>

        <!-- Loading / Empty -->
        <div v-if="loading" class="py-12 text-center text-gray-500">Đang tải dữ liệu...</div>
        <div v-else-if="comments.length === 0" class="py-12 text-center text-gray-400">
          <span class="material-symbols-outlined text-4xl mb-2">find_in_page</span>
          <p>Không có bình luận nào!</p>
        </div>

        <!-- Pagination -->
        <div v-if="totalPages > 1" class="px-5 py-4 border-t border-gray-200 flex justify-end items-center gap-2">
          <button v-if="currentPage > 0" @click="currentPage = currentPage - 1; fetchComments()"
            class="flex items-center gap-1 px-4 py-2 border border-gray-200 rounded-xl hover:bg-gray-50 text-sm font-medium transition-colors">
            <span class="material-symbols-outlined text-[16px]">chevron_left</span>
            Trước
          </button>
          <span class="px-4 py-2 bg-purple-600 text-white rounded-xl text-sm font-bold">{{ currentPage + 1 }}</span>
          <button v-if="currentPage < totalPages - 1" @click="currentPage = currentPage + 1; fetchComments()"
            class="flex items-center gap-1 px-4 py-2 border border-gray-200 rounded-xl hover:bg-gray-50 text-sm font-medium transition-colors">
            Sau
            <span class="material-symbols-outlined text-[16px]">chevron_right</span>
          </button>
        </div>
      </div>

    </div>

    <!-- MODAL PHẢN HỒI -->
    <div v-if="hienModalReply" class="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4" @click.self="dongModalPhanHoi">
      <div class="bg-white rounded-2xl w-full max-w-lg shadow-2xl overflow-hidden">
        <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50">
          <h3 class="font-bold text-gray-800">Phản Hồi Bình Luận</h3>
          <button @click="dongModalPhanHoi" class="text-gray-400 hover:text-gray-600"><span class="material-symbols-outlined">close</span></button>
        </div>
        <div class="p-6">
          <div class="bg-purple-50/50 p-4 rounded-xl border border-purple-100 mb-5">
            <p class="text-sm text-gray-700 italic">"{{ selectedComment?.noiDung }}"</p>
            <div class="text-xs text-purple-600 mt-2 font-medium">— Từ {{ selectedComment?.tenNguoiDung }}</div>
          </div>
          <label class="block text-xs font-bold text-gray-600 uppercase mb-2">Lời Phản Hồi Từ Shop</label>
          <textarea v-model="noiDungReply" rows="4" placeholder="Nhập câu trả lời để tương tác với độc giả..."
            class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-purple-400 resize-none"></textarea>
        </div>
        <div class="px-6 py-4 bg-gray-50 border-t border-gray-100 flex justify-end gap-3">
          <button @click="dongModalPhanHoi" class="px-4 py-2 border border-gray-200 bg-white rounded-lg text-sm font-medium hover:bg-gray-100 transition-colors">Hủy</button>
          <button @click="guiPhanHoi" class="px-4 py-2 bg-purple-600 text-white rounded-lg text-sm font-semibold shadow hover:bg-purple-700 transition-colors">
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
  name: 'CommentsAdmin',
  data() {
    return {
      comments: [],
      stats: { topBlogs: [] },
      filterKeyword: '',
      filterStatus: '',
      filterStartDate: '',
      filterEndDate: '',
      currentPage: 0,
      totalPages: 0,
      loading: false,

      hienModalReply: false,
      selectedComment: null,
      noiDungReply: '',
      
      chartInstance: null,
      openDropdown: null
    }
  },
  mounted() {
    window.addEventListener('click', this.closeDropdowns)
    this.fetchStats()
    this.fetchComments()
  },

  beforeUnmount() {
    window.removeEventListener('click', this.closeDropdowns)
  },
  methods: {
    async fetchComments() {
      this.loading = true
      try {
        const res = await axios.get('/admin/binh-luan', {
          params: { 
            keyword: this.filterKeyword, 
            trangThai: this.filterStatus, 
            startDate: this.filterStartDate, 
            endDate: this.filterEndDate, 
            page: this.currentPage 
          },
          withCredentials: true
        })
        if (res.data.thanhCong) {
          this.comments = res.data.danhSach || []
          this.totalPages = res.data.tongTrang || 0
        }
      } catch (e) {
        console.error(e)
      } finally {
        this.loading = false
      }
    },



    resetFilters() {
      this.filterKeyword = ''
      this.filterStatus = ''
      this.filterStartDate = ''
      this.filterEndDate = ''
      this.currentPage = 0
      this.fetchComments()
    },

    getStatusLabel(val) {
      if (val === '') return ''
      if (val === false) return '🚫 Đã bị ẩn'
      if (val === true) return '✅ Đang hiển thị'
      return ''
    },

    resetFilters() {
      this.filterKeyword = ''
      this.filterStatus = ''
      this.fetchComments()
    },

    closeDropdowns() {
      this.openDropdown = null
    },

    async fetchStats() {
      try {
        const res = await axios.get('/admin/binh-luan/stats', { withCredentials: true })
        if (res.data.thanhCong) {
          this.stats.topBlogs = res.data.topBlogs || []
          
          this.$nextTick(() => {
            this.renderChart()
          })
        }
      } catch (e) { console.error(e) }
    },
    renderChart() {
      const ctx = document.getElementById('commentChart')
      if (!ctx || this.stats.topBlogs.length === 0) return
      
      if (this.chartInstance) {
        this.chartInstance.destroy()
      }

      // Giới hạn 7 bài viết hiển thị trên biểu đồ
      const labels = this.stats.topBlogs.slice(0, 7).map(item => {
        return item.tieuDe.length > 25 ? item.tieuDe.substring(0, 25) + '...' : item.tieuDe
      });
      const dataPoints = this.stats.topBlogs.slice(0, 7).map(item => item.tongBL);

      this.chartInstance = new Chart(ctx, {
        type: 'bar',
        data: {
          labels: labels,
          datasets: [{
            label: 'Số lượng bình luận',
            data: dataPoints,
            backgroundColor: 'rgba(168, 85, 247, 0.85)',
            borderColor: 'rgba(168, 85, 247, 1)',
            borderWidth: 1,
            borderRadius: 6,
            barThickness: 32
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: { display: false }
          },
          scales: {
            y: {
              beginAtZero: true,
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
      const txt = newStatus ? 'BỎ ẨN (Hiển thị lại)' : 'ẨN';
      const ok = await window.$confirm(`Xác nhận ${txt} bình luận này?`)
      if(!ok) return
      try {
        const res = await axios.put(`/admin/binh-luan/${id}/status`, { trangThai: newStatus }, { withCredentials: true })
        if(res.data.thanhCong) {
          this.fetchComments()
        } else window.$alert('Lỗi: ' + res.data.thongBao, 'Lỗi')
      } catch (e) { window.$alert('Lỗi kết nối', 'Lỗi') }
    },
    async xoaBinhLuan(id) {
      const ok = await window.$confirm('Bạn có chắc chắn muốn xóa vĩnh viễn bình luận này?')
      if(!ok) return
      try {
        const res = await axios.delete(`/admin/binh-luan/${id}`, { withCredentials: true })
        if(res.data.thanhCong) {
          this.fetchComments()
          this.fetchStats()
        } else window.$alert('Lỗi: ' + res.data.thongBao, 'Lỗi')
      } catch (e) { window.$alert('Lỗi kết nối', 'Lỗi') }
    },
    moModalPhanHoi(bl) {
      this.selectedComment = bl
      this.noiDungReply = bl.phanHoiAdmin || ''
      this.hienModalReply = true
    },
    dongModalPhanHoi() {
      this.hienModalReply = false
      this.selectedComment = null
      this.noiDungReply = ''
    },
    async guiPhanHoi() {
      try {
        const res = await axios.post(`/admin/binh-luan/${this.selectedComment.maBL}/reply`, 
          { phanHoiAdmin: this.noiDungReply }, { withCredentials: true })
        if(res.data.thanhCong) {
          window.$alert('Đã phản hồi!', 'Thành công')
          this.dongModalPhanHoi()
          this.fetchComments()
        } else window.$alert('Lỗi: ' + res.data.thongBao, 'Lỗi')
      } catch (e) { window.$alert('Lỗi kết nối', 'Lỗi') }
    }
  }
}
</script>
