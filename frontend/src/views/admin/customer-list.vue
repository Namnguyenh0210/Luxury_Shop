<template>
  <div class="relative flex min-h-screen w-full flex-col">
    <div class="flex h-full w-full grow">

      <!-- SIDEBAR -->
      <aside class="flex h-screen w-64 flex-col justify-between border-r p-4 sticky top-0 bg-white">
        <div class="flex flex-col gap-8">

          <!-- USER -->
          <div class="flex items-center gap-3 px-3">
            <div class="size-10 rounded-full bg-slate-900 text-white flex items-center justify-center font-bold text-lg uppercase">
              {{ userInitial }}
            </div>

            <div>
              <h1 class="text-sm font-bold truncate w-32">
                {{ user.name || "Admin" }}
              </h1>
              <p class="text-xs text-gray-500">
                {{ user.role || "ROLE_ADMIN" }}
              </p>
            </div>
          </div>

          <!-- NAV -->
          <nav class="flex flex-col gap-2">
            <router-link class="sidebar-link" to="/admin/dashboard">Dashboard</router-link>
            <router-link class="sidebar-link" to="/admin/products">Sản Phẩm</router-link>
            <router-link class="sidebar-link" to="/admin/inventory">Kho & NCC</router-link>
            <router-link class="sidebar-link" to="/admin/orders">Đơn Hàng</router-link>
            <router-link class="sidebar-link bg-blue-100" to="/admin/customers">Tài Khoản</router-link>
            <router-link class="sidebar-link" to="/admin/blogs">Nội Dung</router-link>
            <router-link class="sidebar-link" to="/admin/reports">Báo Cáo</router-link>
          </nav>

        </div>
      </aside>

      <!-- MAIN -->
      <main class="flex flex-1 flex-col bg-gray-50">

        <header class="sticky top-0 flex items-center justify-between px-10 py-3 bg-white border-b">
          <h2 class="text-lg font-bold">Quản Lý Tài Khoản</h2>
        </header>

        <div class="p-10 space-y-6">

          <!-- ACTION BAR -->
          <div class="flex justify-between">
            <input
                v-model="keyword"
                placeholder="Tìm kiếm..."
                class="border px-4 py-2 rounded-lg w-64"
            />

            <button
                @click="openModal()"
                class="bg-blue-600 text-white px-4 py-2 rounded-lg">
              Thêm Mới
            </button>
          </div>

          <!-- TABLE -->
          <div class="bg-white rounded-xl shadow overflow-hidden">
            <table class="w-full text-sm">
              <thead class="bg-gray-100">
              <tr>
                <th class="p-4">ID</th>
                <th>Họ Tên</th>
                <th>Email</th>
                <th>SĐT</th>
                <th>Vai Trò</th>
                <th>Trạng Thái</th>
                <th class="text-center">Hành Động</th>
              </tr>
              </thead>

              <tbody>
              <tr
                  v-for="u in filteredCustomers"
                  :key="u.maTK"
                  class="border-t">

                <td class="p-4 font-mono">#{{ u.maTK }}</td>
                <td>{{ u.hoTen }}</td>
                <td>{{ u.email }}</td>
                <td>{{ u.soDienThoai || '---' }}</td>

                <td>
                    <span
                        v-for="r in u.roles"
                        :key="r.id"
                        class="bg-purple-100 text-purple-700 px-2 py-1 rounded text-xs mr-1">
                      {{ r.tenRole }}
                    </span>

                  <span
                      v-if="!u.roles || u.roles.length === 0"
                      class="text-gray-400 text-xs">
                      Chưa cấp quyền
                    </span>
                </td>

                <td>
                    <span
                        v-if="u.trangThai"
                        class="text-green-600 font-bold">
                      Hoạt động
                    </span>

                  <span
                      v-else
                      class="text-red-600 font-bold">
                      Đã khóa
                    </span>
                </td>

                <td class="text-center space-x-2">
                  <button
                      @click="editUser(u)"
                      class="text-blue-600">
                    Sửa
                  </button>

                  <button
                      @click="toggleStatus(u)"
                      class="text-yellow-600">
                    {{ u.trangThai ? 'Khóa' : 'Mở khóa' }}
                  </button>

                  <button
                      @click="deleteUser(u.maTK)"
                      class="text-red-600">
                    Xóa
                  </button>
                </td>

              </tr>
              </tbody>
            </table>

            <div v-if="customers.length === 0" class="p-6 text-center text-gray-400">
              Chưa có tài khoản nào.
            </div>
          </div>

        </div>
      </main>
    </div>

    <!-- MODAL -->
    <div
        v-if="showModal"
        class="fixed inset-0 bg-black/50 flex items-center justify-center">

      <div class="bg-white p-6 rounded-xl w-[500px] space-y-4">

        <h3 class="font-bold text-lg">
          {{ form.maTK ? 'Cập nhật tài khoản' : 'Thêm tài khoản' }}
        </h3>

        <input v-model="form.hoTen" placeholder="Họ tên" class="input" />
        <input v-model="form.email" placeholder="Email" class="input" />
        <input v-model="form.soDienThoai" placeholder="SĐT" class="input" />
        <input v-model="form.diaChi" placeholder="Địa chỉ" class="input" />
        <input v-model="form.matKhauMoi" placeholder="Mật khẩu mới" class="input" />

        <div class="flex justify-end gap-2">
          <button @click="closeModal" class="px-4 py-2 bg-gray-200 rounded">
            Hủy
          </button>

          <button
              @click="saveUser"
              class="px-4 py-2 bg-blue-600 text-white rounded">
            Lưu
          </button>
        </div>

      </div>
    </div>

  </div>
</template>

<script>
import axios from "axios"

export default {
  name: "CustomerList",

  data() {
    return {
      customers: [],
      user: { name: "", role: "" },
      keyword: "",
      showModal: false,
      form: {}
    }
  },

  computed: {
    userInitial() {
      return this.user.name
          ? this.user.name.charAt(0).toUpperCase()
          : "A"
    },

    filteredCustomers() {
      if (!this.keyword) return this.customers
      return this.customers.filter(u =>
          u.hoTen.toLowerCase().includes(this.keyword.toLowerCase())
      )
    }
  },

  async mounted() {
    const res = await axios.get("http://localhost:8080/admin/customers", {
      withCredentials: true
    })
    this.customers = res.data.customers
    this.user = res.data.user
  },

  methods: {
    openModal() {
      this.form = {}
      this.showModal = true
    },

    closeModal() {
      this.showModal = false
    },

    editUser(user) {
      this.form = { ...user }
      this.showModal = true
    },

    async saveUser() {
      await axios.post(
          "http://localhost:8080/admin/customers/save",
          this.form,
          { withCredentials: true }
      )
      this.showModal = false
      this.mounted()
    },

    async deleteUser(id) {
      if (!confirm("Xóa tài khoản này?")) return
      await axios.post(
          `http://localhost:8080/admin/customers/delete/${id}`,
          {},
          { withCredentials: true }
      )
      this.mounted()
    },

    async toggleStatus(user) {
      await axios.post(
          `http://localhost:8080/admin/customers/toggle/${user.maTK}`,
          {},
          { withCredentials: true }
      )
      this.mounted()
    }
  }
}
</script>

<style scoped>
.sidebar-link {
  padding: 8px 12px;
  border-radius: 8px;
}
.sidebar-link:hover {
  background: #f3f4f6;
}
.input {
  width: 100%;
  border: 1px solid #ddd;
  padding: 8px;
  border-radius: 8px;
}
</style>