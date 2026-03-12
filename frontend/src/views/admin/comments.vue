<template>
  <AdminLayout page-title="Quản Lý Bình Luận Bài Viết">
    <div class="p-8 space-y-6">

      <!-- THỐNG KÊ NHANH & CHART -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Chart Cột -->
        <div class="lg:col-span-2 bg-white p-6 rounded-2xl border border-gray-200 shadow-sm">
          <h3 class="font-bold text-gray-800 flex items-center gap-2 mb-4">
            <span class="material-symbols-outlined text-purple-500">insert_chart</span> Bài Viết Được Thảo Luận Nhiều Nhất
          </h3>
          <div class="h-64 relative w-full">
            <canvas id="commentChart"></canvas>
          </div>
        </div>

        <!-- Danh sách thống kê -->
        <div class="bg-white p-6 rounded-2xl border border-gray-200 shadow-sm flex flex-col">
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
      <div class="flex flex-wrap items-center gap-4 bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
        <div class="relative">
          <span class="absolute inset-y-0 left-3 flex items-center text-gray-400">
            <span class="material-symbols-outlined text-[18px]">search</span>
          </span>
          <input
            v-model="filterKeyword"
            @keyup.enter="fetchComments"
            placeholder="Tìm theo bài viết, khách hàng..."
            class="border border-gray-200 rounded-xl pl-9 pr-4 py-2 text-sm focus:outline-none focus:border-purple-500 focus:ring-1 focus:ring-purple-500 w-64"
          />
        </div>

        <select v-model="filterStatus" @change="fetchComments" class="border border-gray-200 rounded-xl px-4 py-2 text-sm focus:outline-none focus:border-purple-500">
          <option value="">-- Tất cả trạng thái --</option>
          <option :value="false">⏳ Chờ duyệt (Pending)</option>
          <option :value="true">✅ Đã hiển thị (Approved)</option>
        </select>

        <button @click="fetchComments" class="bg-gray-100 hover:bg-gray-200 text-gray-700 px-4 py-2 rounded-xl text-sm font-medium transition-colors">
          Lọc
        </button>
      </div>

      <!-- BẢNG DANH SÁCH -->
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <table class="w-full text-sm">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-5 py-3 text-left font-semibold text-gray-500 uppercase tracking-wider text-xs w-1/4">Bài Viết & User</th>
              <th class="px-5 py-3 text-left font-semibold text-gray-500 uppercase tracking-wider text-xs w-2/5">Nội Dung Bình Luận</th>
              <th class="px-5 py-3 text-left font-semibold text-gray-500 uppercase tracking-wider text-xs">Phản Hồi (Admin)</th>
              <th class="px-5 py-3 text-center font-semibold text-gray-500 uppercase tracking-wider text-xs">Trạng Thái</th>
              <th class="px-5 py-3 text-center font-semibold text-gray-500 uppercase tracking-wider text-xs">Hành Động</th>
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
                  <div class="font-semibold text-purple-700 text-xs mb-1 flex items-center gap-1">
                    <span class="material-symbols-outlined text-[14px]">admin_panel_settings</span> Admin ({{ bl.ngayPhanHoiAdmin }})
                  </div>
                  {{ bl.phanHoiAdmin }}
                </div>
                <button v-else @click="moModalPhanHoi(bl)" class="text-xs font-medium text-purple-600 hover:text-purple-800 transition-colors">
                  + Thêm phản hồi
                </button>
              </td>

              <td class="px-5 py-4 text-center">
                <span v-if="bl.trangThai === false" class="inline-flex items-center px-2.5 py-1 text-xs font-medium rounded-full bg-orange-100 text-orange-700">
                  Chờ duyệt
                </span>
                <span v-else-if="bl.trangThai === true" class="inline-flex items-center px-2.5 py-1 text-xs font-medium rounded-full bg-green-100 text-green-700">
                  Đã hiện
                </span>
              </td>

              <td class="px-5 py-4 text-center">
                <div class="flex flex-col items-center gap-2">
                  <div class="flex gap-2">
                    <button v-if="bl.trangThai === false" @click="updateStatus(bl.maBL, true)" title="Duyệt (Hiển thị)"
                      class="flex items-center justify-center size-7 rounded bg-green-50 text-green-600 hover:bg-green-100 transition-colors">
                      <span class="material-symbols-outlined text-[16px]">visibility</span>
                    </button>
                    <button v-if="bl.trangThai === true" @click="updateStatus(bl.maBL, false)" title="Bỏ duyệt (Ẩn)"
                      class="flex items-center justify-center size-7 rounded bg-gray-100 text-gray-600 hover:bg-gray-200 transition-colors">
                      <span class="material-symbols-outlined text-[16px]">visibility_off</span>
                    </button>
                  </div>
                  <div class="flex gap-2">
                    <button @click="moModalPhanHoi(bl)" title="Trả lời"
                      class="flex items-center justify-center size-7 rounded bg-purple-50 text-purple-600 hover:bg-purple-100 transition-colors">
                      <span class="material-symbols-outlined text-[16px]">reply</span>
                    </button>
                    <button @click="xoaBinhLuan(bl.maBL)" title="Xoá vĩnh viễn"
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
        <div v-else-if="comments.length === 0" class="py-12 text-center text-gray-400">
          <span class="material-symbols-outlined text-4xl mb-2">find_in_page</span>
          <p>Không có bình luận nào!</p>
        </div>

        <!-- Pagination -->
        <div v-if="totalPages > 1" class="px-5 py-4 border-t border-gray-200 flex justify-end gap-2 text-sm">
          <button v-for="p in totalPages" :key="p" @click="currentPage = p-1; fetchComments()"
            class="size-8 flex items-center justify-center rounded-lg border font-medium transition-colors"
            :class="currentPage === p-1 ? 'bg-purple-600 text-white border-purple-600' : 'bg-white text-gray-600 border-gray-300 hover:bg-gray-50'">
            {{ p }}
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
  </AdminLayout>
</template>

<script>
import AdminLayout from './AdminLayout.vue'
import axios from 'axios'
import Chart from 'chart.js/auto'

export default {
  name: 'CommentsAdmin',
  components: { AdminLayout },
  data() {
    return {
      comments: [],
      stats: { topBlogs: [] },
      filterKeyword: '',
      filterStatus: '',
      currentPage: 0,
      totalPages: 0,
      loading: false,

      hienModalReply: false,
      selectedComment: null,
      noiDungReply: '',
      
      chartInstance: null
    }
  },
  async mounted() {
    await this.fetchStats()
    await this.fetchComments()
  },
  methods: {
    async fetchComments() {
      this.loading = true
      try {
        const res = await axios.get('/admin/binh-luan', {
          params: { keyword: this.filterKeyword, trangThai: this.filterStatus, page: this.currentPage },
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
      const txt = newStatus ? 'DUYỆT (Hiển thị)' : 'BỎ DUYỆT (Ẩn)';
      if(!confirm(`Xác nhận ${txt} bình luận này?`)) return
      try {
        const res = await axios.put(`/admin/binh-luan/${id}/status`, { trangThai: newStatus }, { withCredentials: true })
        if(res.data.thanhCong) {
          this.fetchComments()
        } else alert('Lỗi: ' + res.data.thongBao)
      } catch (e) { alert('Lỗi kết nối') }
    },
    async xoaBinhLuan(id) {
      if(!confirm('Bạn có chắc chắn muốn xóa vĩnh viễn bình luận này?')) return
      try {
        const res = await axios.delete(`/admin/binh-luan/${id}`, { withCredentials: true })
        if(res.data.thanhCong) {
          this.fetchComments()
          this.fetchStats()
        } else alert('Lỗi: ' + res.data.thongBao)
      } catch (e) { alert('Lỗi kết nối') }
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
          alert('Đã phản hồi!')
          this.dongModalPhanHoi()
          this.fetchComments()
        } else alert('Lỗi: ' + res.data.thongBao)
      } catch (e) { alert('Lỗi kết nối') }
    }
  }
}
</script>
