<template>
  
    <div class="p-8 space-y-6">

      <!-- ACTION BAR & FILTERS -->
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div class="flex flex-wrap items-center gap-3">
          <!-- Search -->
          <div class="relative w-64 group">
            <span class="absolute inset-y-0 left-4 flex items-center text-[#C8A97E] group-focus-within:text-black transition-colors">
              <span class="material-symbols-outlined text-[20px]">search</span>
            </span>
            <input
              v-model="tuKhoa"
              placeholder="Tìm bài viết..."
              class="w-full border border-[#C8A97E]/50 rounded-2xl pl-12 pr-4 py-3 text-sm bg-white focus:outline-none focus:ring-4 focus:ring-[#C8A97E]/10 focus:border-[#C8A97E] transition-all shadow-sm font-bold text-gray-700 placeholder:text-gray-400"
            />
          </div>

          <!-- Date Filters -->
          <div class="flex items-center gap-2 bg-white rounded-2xl p-1.5 border border-[#C8A97E]/30 shadow-sm shadow-[#C8A97E]/5">
            <input type="date" v-model="tuNgay" class="bg-transparent border-none text-[11px] font-black text-gray-700 focus:ring-0 w-[115px] cursor-pointer">
            <span class="text-[#C8A97E] px-1 font-bold">→</span>
            <input type="date" v-model="denNgay" class="bg-transparent border-none text-[11px] font-black text-gray-700 focus:ring-0 w-[115px] cursor-pointer">
          </div>

          <!-- Category Filter -->
          <div class="relative min-w-[180px]">
            <button @click.stop="openDropdown = openDropdown === 'loai' ? null : 'loai'"
              class="w-full border border-[#C8A97E]/50 rounded-2xl px-5 py-3 pr-10 text-sm bg-white text-left focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/20 hover:border-[#C8A97E] transition-all shadow-sm flex items-center justify-between">
              <span class="truncate font-black text-gray-700 uppercase tracking-widest text-[11px]">
                {{ danhSachLoai.find(l => l.maLoaiBV == locLoai)?.tenLoaiBV || 'Tất cả loại' }}
              </span>
              <span class="material-symbols-outlined text-[20px] absolute right-3 text-[#C8A97E]">expand_more</span>
            </button>
            <div v-if="openDropdown === 'loai'" class="absolute z-50 w-full mt-2 bg-white border border-[#C8A97E]/30 rounded-2xl shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-200">
              <div @click="locLoai = ''; openDropdown = null" class="px-5 py-3 text-sm cursor-pointer hover:bg-[#C8A97E]/10 transition-colors text-gray-600 border-b border-gray-50" :class="!locLoai ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">Tất cả loại</div>
              <div v-for="loai in danhSachLoai" :key="loai.maLoaiBV" @click="locLoai = loai.maLoaiBV; openDropdown = null" 
                class="px-5 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="locLoai == loai.maLoaiBV ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">
                {{ loai.tenLoaiBV }}
              </div>
            </div>
          </div>

          <!-- Status Filter -->
          <div class="relative min-w-[160px]">
            <button @click.stop="openDropdown = openDropdown === 'status' ? null : 'status'"
              class="w-full border border-[#C8A97E]/50 rounded-2xl px-5 py-3 pr-10 text-sm bg-white text-left focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/20 hover:border-[#C8A97E] transition-all shadow-sm flex items-center justify-between">
              <span class="truncate font-black text-gray-700 uppercase tracking-widest text-[11px]">{{ getStatusLocLabel(trangThaiLoc) || 'Tất cả trạng thái' }}</span>
              <span class="material-symbols-outlined text-[20px] absolute right-3 text-[#C8A97E]">expand_more</span>
            </button>
            <div v-if="openDropdown === 'status'" class="absolute z-50 w-full mt-2 bg-white border border-[#C8A97E]/30 rounded-2xl shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-200">
              <div @click="trangThaiLoc = ''; openDropdown = null" class="px-5 py-3 text-sm cursor-pointer hover:bg-[#C8A97E]/10 transition-colors text-gray-600 border-b border-gray-50" :class="trangThaiLoc === '' ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">Tất cả trạng thái</div>
              <div @click="trangThaiLoc = 'true'; openDropdown = null" class="px-5 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="trangThaiLoc === 'true' ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">Đã xuất bản</div>
              <div @click="trangThaiLoc = 'false'; openDropdown = null" class="px-5 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="trangThaiLoc === 'false' ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">Đã ẩn (Bản nháp)</div>
            </div>
          </div>

          <button @click="resetFilters" class="size-11 flex items-center justify-center rounded-2xl border border-[#C8A97E]/30 text-[#C8A97E] hover:bg-[#C8A97E] hover:text-white transition-all group" title="Xóa lọc">
            <span class="material-symbols-outlined group-hover:rotate-180 transition-transform duration-500">refresh</span>
          </button>
        </div>

        <button @click="moModal()"
          class="flex items-center gap-2 bg-[#C8A97E] hover:bg-[#B88A00] text-white px-6 py-3 rounded-2xl text-sm font-black shadow-lg shadow-[#C8A97E]/20 transition-all active:scale-95">
          <span class="material-symbols-outlined text-[20px]">add</span>
          Thêm Bài Viết
        </button>
      </div>

      <!-- BẢNG DANH SÁCH -->
      <div class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm overflow-hidden">
        <table class="w-full text-sm">
          <thead class="bg-[#EFE9DB] border-b border-[#C8A97E]/30">
            <tr>
              <th class="px-6 py-4 text-left text-xs font-black text-black uppercase tracking-wider">ID</th>
              <th class="px-6 py-4 text-left text-xs font-black text-black uppercase tracking-wider">Hình Ảnh</th>
              <th class="px-6 py-4 text-left text-xs font-black text-black uppercase tracking-wider">Tiêu Đề</th>
              <th class="px-6 py-4 text-left text-xs font-black text-black uppercase tracking-wider">Loại</th>
              <th class="px-6 py-4 text-left text-xs font-black text-black uppercase tracking-wider">Người Đăng</th>
              <th class="px-6 py-4 text-left text-xs font-black text-black uppercase tracking-wider">Trạng Thái</th>
              <th class="px-6 py-4 text-left text-xs font-black text-black uppercase tracking-wider">Ngày Đăng</th>
              <th class="px-6 py-4 text-center text-xs font-black text-black uppercase tracking-wider">Hành Động</th>
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
              <td class="px-6 py-4 text-gray-600">{{ bv.nguoiDang || '---' }}</td>
              <td class="px-6 py-4">
                <span class="inline-flex items-center px-2.5 py-1 text-xs font-medium rounded-full"
                  :class="bv.trangThai ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'">
                  <span class="size-1.5 rounded-full mr-1.5" :class="bv.trangThai ? 'bg-green-500' : 'bg-yellow-500'"></span>
                  {{ bv.trangThai ? 'Đã xuất bản' : 'Bản nháp' }}
                </span>
              </td>
              <td class="px-6 py-4 text-gray-600">{{ formatDate(bv.ngayDang) }}</td>
              <td class="px-6 py-4 text-center">
                <div class="flex items-center justify-center gap-4">
                  <button @click="doiTrangThai(bv)" 
                    class="text-gray-400 hover:text-[#C8A97E] transition-colors"
                    :title="bv.trangThai ? 'Ẩn bài viết' : 'Hiện bài viết'">
                    <span class="material-symbols-outlined text-[22px]">
                      {{ bv.trangThai ? 'visibility' : 'visibility_off' }}
                    </span>
                  </button>
                  <button @click="suaBaiViet(bv)" 
                    class="text-blue-400 hover:text-blue-600 transition-colors"
                    title="Sửa bài viết">
                    <span class="material-symbols-outlined text-[22px]">edit_note</span>
                  </button>
                  <button @click="xoaBaiViet(bv.maBV)" 
                    class="text-red-400 hover:text-red-600 transition-colors"
                    title="Xóa bài viết">
                    <span class="material-symbols-outlined text-[22px]">delete</span>
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
		    <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">
		      Hình Ảnh
		    </label>
		    <input type="file" @change="chonAnh"
		      class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm"/>

		    <img v-if="previewAnh" :src="previewAnh"
		      class="w-full h-40 object-cover rounded-xl mt-2"/>
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

  
</template>

<script>
import axios from 'axios'

export default {
  name: 'BlogList',
  data() {
    return {
      danhSach: [],
      danhSachLoai: [],
      locLoai: '',
      tuNgay: '',
      denNgay: '',
      tuKhoa: '',
      hienModal: false,
      hienModalLoai: false,
      dangLuu: false,
      dangLuuLoai: false,
      tenLoaiMoi: '',
	  fileAnh: null,
	  previewAnh: '',
      form: {
        maBV: null,
        tieuDe: '',
        noiDung: '',
        hinhAnh: '',
        maLoaiBV: '',
        trangThai: true
      },
      trangThaiLoc: '',
      openDropdown: null
    }
  },

  computed: {
    danhSachLocByKeyword() {
      let ds = this.danhSach

      // 🔍 search theo tiêu đề
      if (this.tuKhoa) {
        const kw = this.tuKhoa.toLowerCase()
        ds = ds.filter(b => (b.tieuDe || '').toLowerCase().includes(kw))
      }

      // 📂 lọc theo loại
      if (this.locLoai) {
        ds = ds.filter(b => b.loaiBaiViet?.maLoaiBV == this.locLoai)
      }

      // 📅 từ ngày
      if (this.tuNgay) {
        ds = ds.filter(b => new Date(b.ngayDang) >= new Date(this.tuNgay))
      }

      // 📅 đến ngày
      if (this.denNgay) {
        ds = ds.filter(b => new Date(b.ngayDang) <= new Date(this.denNgay))
      }

      // 🚦 lọc theo trạng thái
      if (this.trangThaiLoc !== '') {
        const target = this.trangThaiLoc === 'true'
        ds = ds.filter(b => b.trangThai === target)
      }

      return ds
    }
  },

  async mounted() {
    window.addEventListener('click', this.closeDropdowns)
    await this.taiDuLieu()
  },

  beforeUnmount() {
    window.removeEventListener('click', this.closeDropdowns)
  },

  methods: {
    closeDropdowns() {
      this.openDropdown = null
    },

    resetFilters() {
      this.tuKhoa = ''
      this.tuNgay = ''
      this.denNgay = ''
      this.locLoai = ''
      this.trangThaiLoc = ''
    },

    getStatusLocLabel(val) {
      if (val === 'true') return 'Đã xuất bản'
      if (val === 'false') return 'Đã ẩn'
      return ''
    },

    async doiTrangThai(bv) {
      try {
        const confirmMsg = bv.trangThai ? 'Bạn có muốn ẩn bài viết này?' : 'Bạn có muốn xuất bản bài viết này?'
        const ok = await window.$confirm(confirmMsg)
        if (!ok) return

        const res = await axios.put(`/admin/blogs/${bv.maBV}`, {
          ...bv,
          maLoaiBV: bv.loaiBaiViet?.maLoaiBV || null,
          trangThai: !bv.trangThai
        }, { withCredentials: true })

        if (res.data.thanhCong) {
          bv.trangThai = !bv.trangThai
          // Optional: re-fetch or just update local
        }
      } catch (e) {
        window.$alert('Lỗi cập nhật trạng thái', 'Lỗi')
      }
    },
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
	  this.previewAnh = bv.hinhAnh || ''
	  this.fileAnh = null
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
		  
		  if (res.data.thanhCong && this.fileAnh) {
		      const formData = new FormData()
		      formData.append("file", this.fileAnh)

		      await axios.post(`/admin/blogs/upload/${this.form.maBV}`, formData, {
		        headers: { "Content-Type": "multipart/form-data" },
		        withCredentials: true
		      })
		    }
		} else {
		  const resCreate = await axios.post('/admin/blogs', payload, { withCredentials: true })

		  if (resCreate.data.thanhCong) {
		    const id = resCreate.data.maBV

		    if (this.fileAnh) {
		      const formData = new FormData()
		      formData.append("file", this.fileAnh)

		      await axios.post(`/admin/blogs/upload/${id}`, formData, {
		        headers: { "Content-Type": "multipart/form-data" },
		        withCredentials: true
		      })
		    }
		  }

		  res = resCreate // ✅ QUAN TRỌNG
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
	
	chonAnh(e) {
	  const file = e.target.files[0]
	  if (!file) return

	  this.fileAnh = file
	  this.previewAnh = URL.createObjectURL(file)
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
