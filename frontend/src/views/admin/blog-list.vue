<template>
  <AdminLayout page-title="Nội Dung & Bài Viết">
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
            class="border border-gray-200 rounded-xl pl-9 pr-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-yellow-400 w-64"
          />
        </div>
        <button @click="openModal()"
          class="flex items-center gap-2 bg-yellow-600 hover:bg-yellow-700 text-white px-5 py-2.5 rounded-xl text-sm font-semibold shadow-sm transition-colors">
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
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Tác Giả</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Ngày Tạo</th>
              <th class="px-6 py-4 text-center text-xs font-semibold text-gray-500 uppercase tracking-wider">Hành Động</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr v-for="blog in filteredBlogs" :key="blog.id" class="hover:bg-yellow-50/50 transition-colors">
              <td class="px-6 py-4 font-mono text-xs text-gray-500">#{{ blog.id }}</td>
              <td class="px-6 py-4 font-semibold text-gray-800 max-w-xs">
                <p class="truncate">{{ blog.tieuDe }}</p>
              </td>
              <td class="px-6 py-4">
                <span class="inline-block bg-blue-100 text-blue-700 px-2.5 py-1 rounded-full text-xs font-medium">
                  {{ blog.loaiBaiViet?.tenLoai || 'Chưa phân loại' }}
                </span>
              </td>
              <td class="px-6 py-4 text-gray-600">{{ blog.tacGia || '---' }}</td>
              <td class="px-6 py-4 text-gray-600">{{ formatDate(blog.ngayTao) }}</td>
              <td class="px-6 py-4 text-center">
                <div class="flex items-center justify-center gap-2">
                  <button @click="editBlog(blog)"
                    class="text-xs font-medium text-yellow-700 bg-yellow-50 hover:bg-yellow-100 px-3 py-1.5 rounded-lg transition-colors">
                    Sửa
                  </button>
                  <button @click="deleteBlog(blog.id)"
                    class="text-xs font-medium text-red-600 bg-red-50 hover:bg-red-100 px-3 py-1.5 rounded-lg transition-colors">
                    Xóa
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>

        <div v-if="filteredBlogs.length === 0" class="flex flex-col items-center justify-center py-16 text-gray-400">
          <span class="material-symbols-outlined text-5xl mb-3">article</span>
          <p class="text-sm">Chưa có bài viết nào</p>
        </div>
      </div>
    </div>

    <!-- MODAL -->
    <div v-if="showModal" class="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4" @click.self="closeModal">
      <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg">
        <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100">
          <h3 class="text-base font-bold text-gray-800">
            {{ form.id ? 'Cập nhật bài viết' : 'Thêm bài viết mới' }}
          </h3>
          <button @click="closeModal" class="text-gray-400 hover:text-gray-600 transition-colors">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>
        <div class="p-6 space-y-4">
          <div class="space-y-1.5">
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Tiêu Đề</label>
            <input v-model="form.tieuDe" placeholder="Nhập tiêu đề bài viết..."
              class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-yellow-400"/>
          </div>
          <div class="space-y-1.5">
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Tác Giả</label>
            <input v-model="form.tacGia" placeholder="Tên tác giả"
              class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-yellow-400"/>
          </div>
          <div class="space-y-1.5">
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Nội Dung</label>
            <textarea v-model="form.noiDung" rows="5" placeholder="Nhập nội dung bài viết..."
              class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-yellow-400 resize-none"></textarea>
          </div>
        </div>
        <div class="flex justify-end gap-3 px-6 py-4 border-t border-gray-100 bg-gray-50 rounded-b-2xl">
          <button @click="closeModal"
            class="px-5 py-2.5 rounded-xl border border-gray-200 bg-white hover:bg-gray-50 text-sm font-medium text-gray-700 transition-colors">
            Hủy
          </button>
          <button @click="saveBlog"
            class="px-5 py-2.5 rounded-xl bg-yellow-600 hover:bg-yellow-700 text-white text-sm font-semibold shadow-sm transition-colors">
            Lưu
          </button>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script>
import AdminLayout from './AdminLayout.vue'
import axios from 'axios'

export default {
  name: 'BlogList',
  components: { AdminLayout },

  data() {
    return {
      blogs: [],
      keyword: '',
      showModal: false,
      form: {}
    }
  },

  computed: {
    filteredBlogs() {
      if (!this.keyword) return this.blogs
      const kw = this.keyword.toLowerCase()
      return this.blogs.filter(b => (b.tieuDe || '').toLowerCase().includes(kw))
    }
  },

  async mounted() {
    try {
      const res = await axios.get('/admin/blogs/list', { withCredentials: true })
      this.blogs = res.data || []
    } catch (e) { console.error(e) }
  },

  methods: {
    openModal()  { this.form = {}; this.showModal = true },
    closeModal() { this.showModal = false },
    editBlog(b)  { this.form = { ...b }; this.showModal = true },
    formatDate(d) { return d ? new Date(d).toLocaleDateString('vi-VN') : '---' },

    async saveBlog() {
      try {
        await axios.post('/admin/blogs/save', this.form, { withCredentials: true })
        this.closeModal()
        location.reload()
      } catch (e) { console.error(e) }
    },

    async deleteBlog(id) {
      if (!confirm('Xóa bài viết này?')) return
      await axios.post(`/admin/blogs/delete/${id}`, {}, { withCredentials: true })
      this.blogs = this.blogs.filter(b => b.id !== id)
    }
  }
}
</script>