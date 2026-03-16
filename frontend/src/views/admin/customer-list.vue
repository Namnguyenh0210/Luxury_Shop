<template>
  
    <div class="p-8 space-y-6">

      <!-- ACTION BAR -->
      <div class="flex flex-wrap items-center justify-between gap-4">
        <div class="flex items-center gap-3">
          <div class="relative w-72">
            <span class="absolute inset-y-0 left-3 flex items-center text-gray-400">
              <span class="material-symbols-outlined text-[20px]">search</span>
            </span>
            <input
              v-model="keyword"
              placeholder="Tìm kiếm tài khoản..."
              class="w-full border border-[#C8A97E]/50 rounded-2xl pl-10 pr-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 hover:border-[#C8A97E] transition-all shadow-sm"
            />
          </div>
          <!-- Lọc theo vai trò -->
          <div class="flex items-center bg-gray-100 p-1 rounded-2xl shadow-inner">
            <button @click="filterRole = ''"
              class="px-4 py-2 text-xs font-bold rounded-xl transition-all whitespace-nowrap"
              :class="filterRole === '' ? 'bg-white text-yellow-700 shadow-sm' : 'text-gray-500 hover:text-gray-700'">
              Tất cả
            </button>
            <button v-for="role in allRoles" :key="role.id" @click="filterRole = role.tenRole"
              class="px-4 py-2 text-xs font-bold rounded-xl transition-all whitespace-nowrap"
              :class="filterRole === role.tenRole ? 'bg-white text-yellow-700 shadow-sm' : 'text-gray-500 hover:text-gray-700'">
              {{ role.tenRole }}
            </button>
          </div>
        </div>
        <button @click="openModal()"
          class="flex items-center gap-2 bg-yellow-600 hover:bg-yellow-700 text-white px-5 py-2.5 rounded-xl text-sm font-semibold shadow-sm transition-colors">
          <span class="material-symbols-outlined text-[18px]">person_add</span>
          Thêm Tài Khoản
        </button>
      </div>

      <!-- TABLE -->
      <div class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm overflow-hidden">
        <table class="w-full text-sm">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">ID</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Họ Tên</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Email</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">SĐT</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Vai Trò</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Trạng Thái</th>
              <th class="px-6 py-4 text-center text-xs font-semibold text-gray-500 uppercase tracking-wider">Hành Động</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr v-for="u in filteredCustomers" :key="u.maTK" class="hover:bg-yellow-50/50 transition-colors">
              <td class="px-6 py-4 font-mono text-xs text-gray-500">#{{ u.maTK }}</td>
              <td class="px-6 py-4">
                <div class="flex items-center gap-3">
                  <div class="size-8 rounded-full bg-slate-200 flex items-center justify-center text-xs font-bold text-slate-600 uppercase flex-shrink-0">
                    {{ (u.hoTen || 'U').charAt(0) }}
                  </div>
                  <span class="font-medium text-gray-800">{{ u.hoTen }}</span>
                </div>
              </td>
              <td class="px-6 py-4 text-gray-600">{{ u.email }}</td>
              <td class="px-6 py-4 text-gray-600">{{ u.soDienThoai || '---' }}</td>
              <td class="px-6 py-4">
                <span v-for="r in u.roles" :key="r.id"
                  class="inline-block bg-purple-100 text-purple-700 px-2.5 py-1 rounded-full text-xs font-medium mr-1">
                  {{ r.tenRole }}
                </span>
                <span v-if="!u.roles || u.roles.length === 0" class="text-gray-400 text-xs italic">Chưa cấp</span>
              </td>
              <td class="px-6 py-4">
                <span class="inline-flex items-center gap-1.5 text-xs font-medium"
                  :class="u.trangThai ? 'text-green-600' : 'text-red-500'">
                  <span class="size-2 rounded-full" :class="u.trangThai ? 'bg-green-500' : 'bg-red-400'"></span>
                  {{ u.trangThai ? 'Hoạt động' : 'Đã khóa' }}
                </span>
              </td>
              <td class="px-6 py-4 text-center">
                <div class="flex items-center justify-center gap-2">
                  <button @click="editUser(u)"
                    class="text-xs font-medium text-yellow-700 bg-yellow-50 hover:bg-yellow-100 px-3 py-1.5 rounded-lg transition-colors">
                    Sửa
                  </button>
                  <button @click="toggleStatus(u)"
                    class="text-xs font-medium px-3 py-1.5 rounded-lg transition-colors"
                    :class="u.trangThai ? 'text-orange-600 bg-orange-50 hover:bg-orange-100' : 'text-green-600 bg-green-50 hover:bg-green-100'">
                    {{ u.trangThai ? 'Khóa' : 'Mở khóa' }}
                  </button>
                  <button @click="deleteUser(u.maTK)"
                    class="text-xs font-medium text-red-600 bg-red-50 hover:bg-red-100 px-3 py-1.5 rounded-lg transition-colors">
                    Xóa
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>

        <div v-if="filteredCustomers.length === 0" class="flex flex-col items-center justify-center py-16 text-gray-400">
          <span class="material-symbols-outlined text-5xl mb-3">group</span>
          <p class="text-sm">Chưa có tài khoản nào</p>
        </div>
      </div>
    </div>

    <!-- MODAL -->
	<div v-if="showModal" class="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4" @click.self="closeModal">
	  <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md">
	    <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100">
	      <h3 class="text-base font-bold text-gray-800">
	        {{ form.maTK ? 'Cập nhật tài khoản' : 'Thêm tài khoản mới' }}
	      </h3>
	      <button @click="closeModal" class="text-gray-400 hover:text-gray-600 transition-colors">
	        <span class="material-symbols-outlined">close</span>
	      </button>
	    </div>
	    
	    <div class="p-6 space-y-4 max-h-[70vh] overflow-y-auto">
	      <div class="space-y-1.5">
	        <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Họ Tên</label>
	        <input v-model="form.hoTen" placeholder="Nguyễn Văn A"
	          class="w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 transition-all"/>
	      </div>

	      <div class="space-y-1.5">
	        <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Email</label>
	        <input v-model="form.email" placeholder="email@example.com" type="email"
	          class="w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 transition-all"/>
	      </div>

	      <div class="space-y-1.5">
	        <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Số Điện Thoại</label>
	        <input v-model="form.soDienThoai" placeholder="0912 345 678"
	          class="w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 transition-all"/>
	      </div>

	      <div class="space-y-1.5">
	        <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Mật Khẩu Mới</label>
	        <input v-model="form.matKhauMoi" placeholder="Để trống nếu không đổi" type="password"
	          class="w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 transition-all"/>
	      </div>

	      <div class="space-y-2">
	        <label class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Vai Trò Hệ Thống</label>
	        <div class="grid grid-cols-2 gap-2 p-3 border border-gray-100 rounded-xl bg-gray-50/50">
	          <label v-for="role in allRoles" :key="role.id" 
	            class="flex items-center gap-2 cursor-pointer bg-white p-2 rounded-lg border border-gray-200 hover:border-yellow-400 transition-colors">
	            <input 
	              type="checkbox" 
	              :value="role" 
	              v-model="form.roles" 
	              class="size-4 rounded accent-yellow-600 border-gray-300"
	            />
	            <span class="text-sm font-medium text-gray-700">{{ role.tenRole }}</span>
	          </label>
	        </div>
	        <p v-if="form.roles && form.roles.length === 0" class="text-[10px] text-red-400 italic">* Vui lòng chọn ít nhất 1 vai trò</p>
	      </div>
	    </div>

	    <div class="flex justify-end gap-3 px-6 py-4 border-t border-gray-100 bg-gray-50 rounded-b-2xl">
	      <button @click="closeModal"
	        class="px-5 py-2.5 rounded-xl border border-gray-200 bg-white hover:bg-gray-50 text-sm font-medium text-gray-700 transition-colors">
	        Hủy
	      </button>
	      <button @click="saveUser"
	        class="px-5 py-2.5 rounded-xl bg-yellow-600 hover:bg-yellow-700 text-white text-sm font-semibold shadow-sm transition-colors">
	        Lưu
	      </button>
	    </div>
	  </div>
	</div>
  
</template>

<script>
import axios from 'axios'

const api = axios.create({
  baseURL: '/api',
  withCredentials: true
});

export default {
  name: 'CustomerList',
  data() {
    return {
      customers: [],
      allRoles: [],
      keyword: '',
      filterRole: '',
      showModal: false,
      form: {
        roles: []
      }
    }
  },
  computed: {
    filteredCustomers() {
      let list = this.customers
      if (this.keyword) {
        const kw = this.keyword.toLowerCase()
        list = list.filter(u =>
          (u.hoTen || '').toLowerCase().includes(kw) ||
          (u.email  || '').toLowerCase().includes(kw)
        )
      }
      if (this.filterRole) {
        list = list.filter(u =>
          u.roles && u.roles.some(r => r.tenRole === this.filterRole)
        )
      }
      return list
    }
  },
  async mounted() {
    this.loadData();
    this.fetchRoles(); // Lấy danh sách role khi component được gắn vào
  },
  methods: {
    async loadData() {
      try {
        const res = await api.get('/admin/customers')
        this.customers = res.data.customers || []
      } catch (e) { console.error("Lỗi load khách hàng:", e) }
    },
    async fetchRoles() {
      try {
        const res = await api.get('/admin/customers/vaiTros-list')
        this.allRoles = res.data
      } catch (e) { console.error("Lỗi load vai trò:", e) }
    },
    openModal()  { 
      this.form = { roles: [] }; 
      this.showModal = true 
    },
    closeModal() { 
      this.showModal = false 
    },
    editUser(u)  { 
      // Dùng JSON parse/stringify để tránh làm thay đổi trực tiếp dữ liệu trên bảng
      this.form = JSON.parse(JSON.stringify(u));
      if(!this.form.roles) this.form.roles = [];
      this.showModal = true 
    },

    async saveUser() {
      try {
        await api.post('/admin/customers/save', this.form)
        this.closeModal()
        this.loadData() 
      } catch (e) { 
        window.$alert("Lỗi lưu dữ liệu! Kiểm tra console để biết thêm chi tiết.", "Lỗi")
        console.error(e)
      }
    },
    async deleteUser(id) {
      const ok = await window.$confirm('Xóa tài khoản này?')
      if (!ok) return
      try {
        await api.post(`/admin/customers/delete/${id}`)
        this.loadData()
      } catch (e) { console.error(e) }
    },
    async toggleStatus(u) {
      try {
        await api.post(`/admin/customers/toggle/${u.maTK}`)
        u.trangThai = !u.trangThai
      } catch (e) { console.error(e) }
    }
  }
}
</script>