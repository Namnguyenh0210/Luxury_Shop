<template>
  <AdminLayout page-title="Quản Lý Bài Viết">
    <div class="p-8 space-y-6">

      <!-- ACTION BAR -->
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div class="relative w-72">
          <span class="absolute inset-y-0 left-3 flex items-center text-gray-400">
            <span class="material-symbols-outlined text-[20px]">search</span>
          </span>
          <input
            v-model="tuKhoa"
            placeholder="Tìm bài viết..."
            class="w-full border border-[#C8A97E]/50 rounded-2xl pl-10 pr-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 hover:border-[#C8A97E] transition-all shadow-sm"
          />
        </div>
        <button @click="moModal()"
          class="flex items-center gap-2 bg-yellow-600 hover:bg-yellow-700 text-white px-5 py-2.5 rounded-xl text-sm font-semibold shadow-sm transition-colors">
          <span class="material-symbols-outlined text-[18px]">add</span>
          Thêm Bài Viết
        </button>
      </div>

      <!-- BẢNG DANH SÁCH -->
      <div class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm overflow-hidden">
        <table class="w-full text-sm">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">ID</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Hình Ảnh</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Tiêu Đề</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Loại</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Tác Giả</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Trạng Thái</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Ngày Đăng</th>
              <th class="px-6 py-4 text-center text-xs font-semibold text-gray-500 uppercase tracking-wider">Hành Động</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr v-for="bv in danhSachLocByKeyword" :key="bv.maBV" class="hover:bg-yellow-50/50 transition-colors">
              <td class="px-6 py-4 font-mono text-xs text-gray-500">#{{ bv.maBV }}</td>
              <td class="px-6 py-4">
                <img v-if="bv.hinhAnh" :src="bv.hinhAnh" class="w-16 h-12 object-cover rounded-lg" />
                <div v-else class="w-16 h-12 bg-gray-100 rounded-lg flex items-center justify-center">
                  <span class="material-symbols-outlined text-gray-300 text-2xl">image</span>
                </div>
              </td>
              <td class="px-6 py-4 font-semibold text-gray-800 max-w-xs">
                <p class="truncate">{{ bv.tieuDe }}</p>
              </td>
              <td class="px-6 py-4">
                <span class="inline-block bg-blue-100 text-blue-700 px-2.5 py-1 rounded-full text-xs font-medium">
                  {{ bv.loaiBaiViet?.tenLoaiBV || 'Chưa phân loại' }}
                </span>
              </td>
              <td class="px-6 py-4 text-gray-600">{{ bv.tacGia || '---' }}</td>
              <td class="px-6 py-4">
                <span class="inline-flex items-center px-2.5 py-1 text-xs font-medium rounded-full"
                  :class="bv.trangThai ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'">
                  <span class="size-1.5 rounded-full mr-1.5" :class="bv.trangThai ? 'bg-green-500' : 'bg-yellow-500'"></span>
                  {{ bv.trangThai ? 'Đã xuất bản' : 'Bản nháp' }}
                </span>
              </td>
              <td class="px-6 py-4 text-gray-600">{{ formatDate(bv.ngayDang) }}</td>
              <td class="px-6 py-4 text-center">
                <div class="flex items-center justify-center gap-2">
                  <button @click="suaBaiViet(bv)"
                    class="text-xs font-medium text-yellow-700 bg-yellow-50 hover:bg-yellow-100 px-3 py-1.5 rounded-lg transition-colors">
                    Sửa
                  </button>
                  <button @click="xoaBaiViet(bv.maBV)"
                    class="text-xs font-medium text-red-600 bg-red-50 hover:bg-red-100 px-3 py-1.5 rounded-lg transition-colors">
                    Xóa
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>

        <div v-if="danhSachLocByKeyword.length === 0" class="flex flex-col items-center justify-center py-16 text-gray-400">
          <span class="material-symbols-outlined text-5xl mb-3">article</span>
          <p class="text-sm">Chưa có bài viết nào</p>
        </div>
      </div>
    </div>

    <!-- MODAL THÊM/SỬA BÀI VIẾT -->
    <div v-if="hienModal" class="fixed inset-0 z-50 bg-black/50 flex items-start justify-center p-4 overflow-y-auto" @click.self="dongModal">
      <div class="bg-white rounded-2xl shadow-2xl w-full max-w-2xl my-8">
        <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100">
          <h3 class="text-base font-bold text-gray-800">
            {{ form.maBV ? 'Cập Nhật Bài Viết' : 'Thêm Bài Viết Mới' }}
          </h3>
          <button @click="dongModal" class="text-gray-400 hover:text-gray-600 transition-colors">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>

        <div class="p-6 space-y-4">
          <!-- Tiêu Đề -->
          <div class="space-y-1.5">
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Tiêu Đề <span class="text-red-500">*</span></label>
            <input v-model="form.tieuDe" placeholder="Nhập tiêu đề bài viết..."
              class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-yellow-400"/>
          </div>

          <!-- Loại Bài Viết -->
          <div class="space-y-1.5">
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Loại Bài Viết</label>
            <div class="flex gap-2">
              <select v-model="form.maLoaiBV"
                class="flex-1 border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-yellow-400 bg-white">
                <option value="">-- Chọn loại bài viết --</option>
                <option v-for="loai in danhSachLoai" :key="loai.maLoaiBV" :value="loai.maLoaiBV">
                  {{ loai.tenLoaiBV }}
                </option>
              </select>
              <button @click="moModalThemLoai" type="button"
                class="flex items-center gap-1 bg-blue-50 hover:bg-blue-100 text-blue-700 font-medium px-4 py-2.5 rounded-xl border border-blue-200 transition-colors">
                <span class="material-symbols-outlined text-[18px]">add</span>
                Thêm Mới
              </button>
            </div>
          </div>

          <!-- Hình Ảnh -->
          <div class="space-y-1.5">
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">URL Hình Ảnh</label>
            <input v-model="form.hinhAnh" placeholder="https://..."
              class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-yellow-400"/>
            <img v-if="form.hinhAnh" :src="form.hinhAnh" class="w-full h-40 object-cover rounded-xl mt-2" @error="form.hinhAnh = ''" />
          </div>

          <!-- Nội Dung -->
          <div class="space-y-1.5">
            <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Nội Dung <span class="text-red-500">*</span></label>
            <textarea v-model="form.noiDung" rows="8" placeholder="Nhập nội dung bài viết..."
              class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-yellow-400 resize-y"></textarea>
          </div>

          <!-- Trạng Thái -->
          <div class="flex items-center gap-3">
            <input type="checkbox" id="trangThaiCheck" v-model="form.trangThai" class="w-4 h-4 accent-yellow-600"/>
            <label for="trangThaiCheck" class="text-sm font-medium text-gray-700">Xuất bản ngay (hiển thị cho khách hàng)</label>
          </div>
        </div>

        <!-- Footer -->
        <div class="flex justify-end gap-3 px-6 py-4 border-t border-gray-100 bg-gray-50 rounded-b-2xl">
          <button @click="dongModal"
            class="px-5 py-2.5 rounded-xl border border-gray-200 bg-white hover:bg-gray-50 text-sm font-medium text-gray-700 transition-colors">
            Hủy
          </button>
          <button @click="luuBaiViet" :disabled="dangLuu"
            class="px-5 py-2.5 rounded-xl bg-yellow-600 hover:bg-yellow-700 text-white text-sm font-semibold shadow-sm transition-colors disabled:opacity-60">
            {{ dangLuu ? 'Đang lưu...' : (form.maBV ? 'Cập Nhật' : 'Đăng Bài') }}
          </button>
        </div>
      </div>
    </div>

    <!-- MODAL THÊM LOẠI BÀI VIẾT -->
    <div v-if="hienModalLoai" class="fixed inset-0 z-[60] bg-black/50 flex items-center justify-center p-4" @click.self="dongModalLoai">
      <div class="bg-white rounded-2xl shadow-2xl w-full max-w-sm">
        <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
          <h3 class="font-bold text-gray-800">Thêm Loại Bài Viết</h3>
          <button @click="dongModalLoai" class="text-gray-400 hover:text-gray-600"><span class="material-symbols-outlined">close</span></button>
        </div>
        <div class="p-6">
          <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5 block">Tên Loại <span class="text-red-500">*</span></label>
          <input v-model="tenLoaiMoi" @keyup.enter="luuLoaiBaiViet" placeholder="Vd: Xu hướng 2024..."
            class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-yellow-400" autofocus />
        </div>
        <div class="flex justify-end gap-3 px-6 py-4 border-t border-gray-100 bg-gray-50 rounded-b-2xl">
          <button @click="dongModalLoai" class="px-4 py-2 rounded-xl border border-gray-200 bg-white text-sm font-medium">Hủy</button>
          <button @click="luuLoaiBaiViet" :disabled="dangLuuLoai" class="px-4 py-2 rounded-xl bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium disabled:opacity-60">
            {{ dangLuuLoai ? 'Đang lưu...' : 'Lưu' }}
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
      danhSach: [],
      danhSachLoai: [],
      tuKhoa: '',
      hienModal: false,
      hienModalLoai: false,
      dangLuu: false,
      dangLuuLoai: false,
      tenLoaiMoi: '',
      form: {
        maBV: null,
        tieuDe: '',
        noiDung: '',
        hinhAnh: '',
        maLoaiBV: '',
        trangThai: true
      }
    }
  },

  computed: {
    danhSachLocByKeyword() {
      if (!this.tuKhoa) return this.danhSach
      const kw = this.tuKhoa.toLowerCase()
      return this.danhSach.filter(b => (b.tieuDe || '').toLowerCase().includes(kw))
    }
  },

  async mounted() {
    await this.taiDuLieu()
  },

  methods: {
    async taiDuLieu() {
      try {
        const res = await axios.get('/admin/blogs', { withCredentials: true })
        if (res.data.thanhCong) {
          this.danhSach = res.data.danhSach || []
          this.danhSachLoai = res.data.loaiBaiViet || []
        }
      } catch (e) {
        console.error('Lỗi tải dữ liệu:', e)
      }
    },

    moModal() {
      this.form = { maBV: null, tieuDe: '', noiDung: '', hinhAnh: '', maLoaiBV: '', trangThai: true }
      this.hienModal = true
    },

    dongModal() {
      this.hienModal = false
    },

    suaBaiViet(bv) {
      this.form = {
        maBV: bv.maBV,
        tieuDe: bv.tieuDe || '',
        noiDung: bv.noiDung || '',
        hinhAnh: bv.hinhAnh || '',
        maLoaiBV: bv.loaiBaiViet?.maLoaiBV || '',
        trangThai: bv.trangThai !== false
      }
      // Tải nội dung đầy đủ
      axios.get(`/admin/blogs/${bv.maBV}`, { withCredentials: true }).then(r => {
        if (r.data.thanhCong) {
          this.form.noiDung = r.data.baiViet.noiDung || ''
        }
      })
      this.hienModal = true
    },

    async luuBaiViet() {
      if (!this.form.tieuDe?.trim() || !this.form.noiDung?.trim()) {
        window.$alert('Vui lòng nhập đầy đủ tiêu đề và nội dung!', 'Thông báo')
        return
      }

      this.dangLuu = true
      try {
        const payload = {
          tieuDe: this.form.tieuDe,
          noiDung: this.form.noiDung,
          hinhAnh: this.form.hinhAnh,
          maLoaiBV: this.form.maLoaiBV || null,
          trangThai: this.form.trangThai
        }

        let res
        if (this.form.maBV) {
          res = await axios.put(`/admin/blogs/${this.form.maBV}`, payload, { withCredentials: true })
        } else {
          res = await axios.post('/admin/blogs', payload, { withCredentials: true })
        }

        if (res.data.thanhCong) {
          window.$alert(res.data.thongBao || 'Thành công!', 'Thành công')
          this.dongModal()
          await this.taiDuLieu()
        } else {
          window.$alert('Lỗi: ' + (res.data.thongBao || 'Có lỗi xảy ra'), 'Lỗi')
        }
      } catch (e) {
        window.$alert('Lỗi kết nối: ' + e.message, 'Lỗi')
      } finally {
        this.dangLuu = false
      }
    },

    async xoaBaiViet(id) {
      const ok = await window.$confirm('Bạn có chắc muốn xóa bài viết này?')
      if (!ok) return
      try {
        const res = await axios.delete(`/admin/blogs/${id}`, { withCredentials: true })
        if (res.data.thanhCong) {
          this.danhSach = this.danhSach.filter(b => b.maBV !== id)
        } else {
          window.$alert('Lỗi: ' + res.data.thongBao, 'Lỗi')
        }
      } catch (e) {
        window.$alert('Lỗi khi xóa: ' + e.message, 'Lỗi')
      }
    },

    moModalThemLoai() {
      this.tenLoaiMoi = ''
      this.hienModalLoai = true
    },

    dongModalLoai() {
      this.hienModalLoai = false
    },

    async luuLoaiBaiViet() {
      if (!this.tenLoaiMoi.trim()) return
      this.dangLuuLoai = true
      try {
        const res = await axios.post('/admin/blogs/categories', { tenLoaiBV: this.tenLoaiMoi.trim() }, { withCredentials: true })
        if (res.data.thanhCong) {
          this.danhSachLoai.push(res.data.loaiBaiViet)
          this.form.maLoaiBV = res.data.loaiBaiViet.maLoaiBV
          this.dongModalLoai()
        } else {
          window.$alert('Lỗi: ' + res.data.thongBao, 'Lỗi')
        }
      } catch (e) {
        window.$alert('Lỗi kết nối: ' + e.message, 'Lỗi')
      } finally {
        this.dangLuuLoai = false
      }
    },

    formatDate(d) {
      if (!d) return '---'
      return new Date(d).toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' })
    }
  }
}
</script>