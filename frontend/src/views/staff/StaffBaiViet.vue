<template>
  <StaffLayout page-title="Quản Lý Bài Viết">
    <div class="p-8 space-y-6">

      <!-- ACTION BAR -->
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div class="relative">
          <span class="absolute inset-y-0 left-3 flex items-center text-gray-400">
            <span class="material-symbols-outlined text-[18px]">search</span>
          </span>
          <input
            v-model="keyword"
            placeholder="Tìm bài viết..."
            class="border border-gray-200 rounded-xl pl-9 pr-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-blue-400 w-64"
          />
        </div>
        <button @click="openModal()"
          class="flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-5 py-2.5 rounded-xl text-sm font-semibold shadow-sm transition-colors">
          <span class="material-symbols-outlined text-[18px]">add</span>
          Thêm Bài Viết
        </button>
      </div>

      <!-- TABLE -->
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <table class="w-full text-sm">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">ID</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Tiêu Đề</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Loại</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Ngày Đăng</th>
              <th class="px-6 py-4 text-center text-xs font-semibold text-gray-500 uppercase tracking-wider">Hành Động</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr v-for="post in filteredPosts" :key="post.maBV || post.id" class="hover:bg-blue-50/30 transition-colors">
              <td class="px-6 py-4 font-mono text-xs text-gray-500">#{{ post.maBV || post.id }}</td>
              <td class="px-6 py-4 font-semibold text-gray-800 max-w-xs">
                <p class="truncate">{{ post.tieuDe }}</p>
              </td>
              <td class="px-6 py-4">
                <span class="inline-block bg-blue-100 text-blue-700 px-2.5 py-1 rounded-full text-xs font-medium">
                  {{ post.loaiBaiViet?.tenLoai || 'Chưa phân loại' }}
                </span>
              </td>
              <td class="px-6 py-4 text-gray-600">{{ formatDate(post.ngayDang || post.ngayTao) }}</td>
              <td class="px-6 py-4 text-center">
                <div class="flex items-center justify-center gap-2">
                  <button @click="editPost(post)"
                    class="text-xs font-medium text-blue-700 bg-blue-50 hover:bg-blue-100 px-3 py-1.5 rounded-lg transition-colors">
                    Sửa
                  </button>
                  <button @click="deletePost(post.maBV || post.id)"
                    class="text-xs font-medium text-red-600 bg-red-50 hover:bg-red-100 px-3 py-1.5 rounded-lg transition-colors">
                    Xóa
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>

        <div v-if="filteredPosts.length === 0" class="flex flex-col items-center justify-center py-16 text-gray-400">
          <span class="material-symbols-outlined text-5xl mb-3">article</span>
          <p class="text-sm">Chưa có bài viết nào</p>
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

    <!-- MODAL -->
    <div v-if="showModal" class="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4" @click.self="closeModal">
      <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg">
        <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100">
          <h3 class="text-base font-bold text-gray-800">
            {{ form.maBV || form.id ? 'Cập nhật bài viết' : 'Thêm bài viết mới' }}
          </h3>
          <button @click="closeModal" class="text-gray-400 hover:text-gray-600 transition-colors">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>
        <div class="p-6 space-y-4">
          <div class="space-y-1.5">
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Tiêu Đề *</label>
            <input v-model="form.tieuDe" placeholder="Nhập tiêu đề bài viết..."
              class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400"/>
          </div>
          <div class="space-y-1.5">
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Nội Dung</label>
            <textarea v-model="form.noiDung" rows="6" placeholder="Nhập nội dung bài viết..."
              class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400 resize-none"></textarea>
          </div>
        </div>
        <div class="flex justify-end gap-3 px-6 py-4 border-t border-gray-100 bg-gray-50 rounded-b-2xl">
          <button @click="closeModal"
            class="px-5 py-2.5 rounded-xl border border-gray-200 bg-white hover:bg-gray-50 text-sm font-medium text-gray-700 transition-colors">
            Hủy
          </button>
          <button @click="savePost" :disabled="saving"
            class="px-5 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 disabled:opacity-50 text-white text-sm font-semibold shadow-sm transition-colors flex items-center gap-2">
            <span v-if="saving" class="material-symbols-outlined text-[16px] animate-spin">progress_activity</span>
            {{ saving ? 'Đang lưu...' : 'Lưu' }}
          </button>
        </div>
      </div>
    </div>
  </StaffLayout>
</template>

<script>
import StaffLayout from './StaffLayout.vue'
import axios from 'axios'

export default {
  name: 'StaffBaiViet',
  components: { StaffLayout },

  data() {
    return {
      posts: [],
      keyword: '',
      page: 0,
      totalPages: 0,
      showModal: false,
      saving: false,
      form: {}
    }
  },

  computed: {
    filteredPosts() {
      if (!this.keyword) return this.posts
      const kw = this.keyword.toLowerCase()
      return this.posts.filter(p => (p.tieuDe || '').toLowerCase().includes(kw))
    }
  },

  async mounted() { await this.loadData() },

  methods: {
    async loadData() {
      try {
        const res = await axios.get('/staff/baiviet', {
          params: { page: this.page },
          withCredentials: true
        })
        this.posts      = res.data.content || res.data || []
        this.totalPages = res.data.totalPages || 1
      } catch (e) { console.error(e) }
    },

    changePage(p) { this.page = p; this.loadData() },

    openModal()  { this.form = {}; this.showModal = true },
    closeModal() { this.showModal = false },
    editPost(p)  { this.form = { ...p }; this.showModal = true },

    formatDate(d) { return d ? new Date(d).toLocaleDateString('vi-VN') : '---' },

    async savePost() {
      if (!this.form.tieuDe) { alert('Nhập tiêu đề bài viết'); return }
      this.saving = true
      try {
        const id = this.form.maBV || this.form.id
        if (id) {
          await axios.put(`/staff/baiviet/${id}`, this.form, { withCredentials: true })
        } else {
          await axios.post('/staff/baiviet', this.form, { withCredentials: true })
        }
        this.closeModal()
        await this.loadData()
      } catch (e) { console.error(e); alert('Có lỗi khi lưu bài viết') }
      finally { this.saving = false }
    },

    async deletePost(id) {
      if (!confirm('Xóa bài viết này?')) return
      try {
        await axios.delete(`/staff/baiviet/${id}`, { withCredentials: true })
        this.posts = this.posts.filter(p => (p.maBV || p.id) !== id)
      } catch (e) { console.error(e); alert('Có lỗi khi xóa') }
    }
  }
}
</script>