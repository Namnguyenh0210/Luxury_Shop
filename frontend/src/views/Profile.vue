<template>
  <div class="relative flex min-h-screen w-full flex-col bg-gray-50">
    <AppHeader />

    <main class="flex-grow">
      <div class="flex flex-1 max-w-7xl mx-auto w-full">
        <!-- Sidebar -->
        <aside class="w-64 flex-shrink-0 bg-white border-r border-gray-200 p-6 hidden md:block sticky top-0 h-screen overflow-y-auto">
          <div class="flex flex-col gap-6">
            <div>
              <h2 class="text-gray-900 text-lg font-bold mb-1">Tài khoản của tôi</h2>
              <p class="text-sm text-gray-500">Quản lý thông tin cá nhân</p>
            </div>
            <div class="flex flex-col gap-1">
              <button @click="activeTab = 'info'"
                      :class="['flex items-center gap-3 px-4 py-3 rounded-lg group cursor-pointer transition-all',
                               activeTab === 'info' ? 'bg-yellow-50 border-l-4 border-yellow-600' : 'hover:bg-gray-50']">
                <span class="material-symbols-outlined"
                      :class="[activeTab === 'info' ? 'text-yellow-600' : 'text-gray-600']"
                      style="font-size: 20px;">person</span>
                <p :class="['text-sm font-medium', activeTab === 'info' ? 'text-yellow-600' : 'text-gray-700']">
                  Thông tin tài khoản
                </p>
              </button>

              <button @click="activeTab = 'password'"
                      :class="['flex items-center gap-3 px-4 py-3 rounded-lg group cursor-pointer transition-all',
                               activeTab === 'password' ? 'bg-yellow-50 border-l-4 border-yellow-600' : 'hover:bg-gray-50']">
                <span class="material-symbols-outlined"
                      :class="[activeTab === 'password' ? 'text-yellow-600' : 'text-gray-600']"
                      style="font-size: 20px;">lock</span>
                <p :class="['text-sm font-medium', activeTab === 'password' ? 'text-yellow-600' : 'text-gray-700']">
                  Đổi mật khẩu
                </p>
              </button>

              <button @click="activeTab = 'orders'"
                      :class="['flex items-center gap-3 px-4 py-3 rounded-lg group cursor-pointer transition-all',
                               activeTab === 'orders' ? 'bg-yellow-50 border-l-4 border-yellow-600' : 'hover:bg-gray-50']">
                <span class="material-symbols-outlined"
                      :class="[activeTab === 'orders' ? 'text-yellow-600' : 'text-gray-600']"
                      style="font-size: 20px;">receipt_long</span>
                <p :class="['text-sm font-medium', activeTab === 'orders' ? 'text-yellow-600' : 'text-gray-700']">
                  Đơn hàng của tôi
                </p>
              </button>
              <button
                  @click="activeTab = 'address'; window.location.hash='address'"
                  :class="[
    'flex items-center gap-3 px-4 py-3 rounded-lg group cursor-pointer transition-all',
    activeTab === 'address'
      ? 'bg-yellow-50 border-l-4 border-yellow-600'
      : 'hover:bg-gray-50'
  ]"
              >
  <span
      class="material-symbols-outlined"
      :class="activeTab === 'address' ? 'text-yellow-600' : 'text-gray-600'"
      style="font-size:20px"
  >
    location_on
  </span>

                <p
                    :class="[
      'text-sm font-medium',
      activeTab === 'address' ? 'text-yellow-600' : 'text-gray-700'
    ]"
                >
                  Số địa chỉ
                </p>
              </button>
            </div>

            <div class="mt-auto pt-6 border-t border-gray-200">
              <a href="/api/auth/logout" class="flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-red-50 group transition-all">
                <span class="material-symbols-outlined text-red-600 group-hover:text-red-700" style="font-size: 20px;">logout</span>
                <p class="text-sm font-medium text-red-600 group-hover:text-red-700">Đăng xuất</p>
              </a>
            </div>
          </div>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 p-6 md:p-10 bg-gray-50">
          <div class="max-w-4xl">
            <!-- Loading State -->
            <div v-if="loading" class="flex flex-col items-center justify-center py-20">
              <div class="animate-spin rounded-full h-16 w-16 border-b-2 border-yellow-600 mb-4"></div>
              <p class="text-gray-600">Đang tải thông tin...</p>
            </div>

            <!-- Error State -->
            <div v-else-if="error" class="bg-white rounded-xl shadow-sm border border-red-200 p-8 text-center">
              <div class="flex flex-col items-center">
                <div class="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mb-4">
                  <span class="material-symbols-outlined text-3xl text-red-600">error</span>
                </div>
                <h3 class="text-lg font-semibold text-gray-900 mb-2">Có lỗi xảy ra</h3>
                <p class="text-red-600 mb-6">{{ error }}</p>
                <button @click="fetchUserData"
                        class="px-6 py-2.5 bg-yellow-600 text-white rounded-lg hover:bg-yellow-700 transition-colors font-medium">
                  Thử lại
                </button>
              </div>
            </div>

            <!-- Content Tabs -->
            <div v-else class="space-y-6">
              <!-- Account Information Tab -->
              <section v-if="activeTab === 'info'">
                <div>
                  <h1 class="text-3xl font-bold text-gray-900 mb-2">Thông tin tài khoản</h1>
                  <p class="text-gray-600">Cập nhật thông tin cá nhân của bạn</p>
                </div>

                <!-- Success/Error Messages -->
                <div v-if="successMessage" class="bg-green-50 border border-green-200 text-green-800 px-4 py-3 rounded-lg flex items-center gap-3 animate-fade-in">
                  <span class="material-symbols-outlined text-green-600">check_circle</span>
                  <p class="font-medium">{{ successMessage }}</p>
                </div>
                <div v-if="errorMessage" class="bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-lg flex items-center gap-3">
                  <span class="material-symbols-outlined text-red-600">error</span>
                  <p class="font-medium">{{ errorMessage }}</p>
                </div>

                <form @submit.prevent="updateProfile" class="space-y-6">
                  <!-- Profile Card -->
                  <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
                    <div class="flex flex-col md:flex-row gap-6 items-start md:items-center justify-between">
                      <div class="flex gap-6 items-center">
                        <!-- Avatar -->
                        <div class="relative group">
                          <div class="bg-gradient-to-br from-yellow-400 to-yellow-600 rounded-full h-20 w-20 flex items-center justify-center text-white font-bold text-2xl shadow-lg"
                               :style="user.avatar ? `background-image: url('${user.avatar}'); background-size: cover;` : ''">
                            <span v-if="!user.avatar">{{ user.hoTen ? user.hoTen.charAt(0).toUpperCase() : 'U' }}</span>
                          </div>
                        </div>
                        <div class="flex flex-col gap-2">
                          <input type="text" v-model="user.hoTen" required
                                 class="text-xl font-bold text-gray-900 border-b-2 border-transparent hover:border-gray-300 focus:border-yellow-600 focus:outline-none bg-transparent pb-1 transition-colors"
                                 placeholder="Tên của bạn" />
                          <p class="text-sm text-gray-500 flex items-center gap-2">
                            <span class="material-symbols-outlined" style="font-size: 16px;">mail</span>
                            {{ user.email }}
                          </p>
                        </div>
                      </div>
                      <button type="submit" :disabled="isUpdating"
                              class="px-6 py-2.5 bg-yellow-600 text-white rounded-lg hover:bg-yellow-700 transition-colors font-medium disabled:opacity-50 disabled:cursor-not-allowed whitespace-nowrap shadow-sm">
                        <span v-if="!isUpdating">Lưu thay đổi</span>
                        <span v-else class="flex items-center gap-2">
                          <svg class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                          </svg>
                          Đang lưu...
                        </span>
                      </button>
                    </div>
                  </div>

                  <!-- Additional Info -->
                  <div class="bg-white rounded-xl shadow-sm border border-gray-200 divide-y divide-gray-200">
                    <div class="p-6 flex flex-col md:flex-row md:items-center gap-4">
                      <div class="md:w-1/3">
                        <label class="text-sm font-medium text-gray-700 flex items-center gap-2">
                          <span class="material-symbols-outlined text-gray-500" style="font-size: 18px;">phone</span>
                          Số điện thoại
                        </label>
                      </div>
                      <input type="tel" v-model="user.soDienThoai"
                             class="flex-1 px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-600 focus:border-transparent transition-all"
                             placeholder="Nhập số điện thoại" />
                    </div>

                    <div class="p-6 flex flex-col md:flex-row md:items-center gap-4">
                      <div class="md:w-1/3">
                        <label class="text-sm font-medium text-gray-700 flex items-center gap-2">
                          <span class="material-symbols-outlined text-gray-500" style="font-size: 18px;">lock</span>
                          Mật khẩu
                        </label>
                      </div>
                      <div class="flex-1 flex justify-between items-center">
                        <p class="text-gray-500">••••••••</p>
                        <button type="button" @click="activeTab = 'password'"
                                class="text-yellow-600 hover:text-yellow-700 font-medium text-sm">
                          Đổi mật khẩu →
                        </button>
                      </div>
                    </div>
                  </div>
                </form>
              </section>

              <!-- Change Password Tab -->
              <section v-show="activeTab === 'password'" class="space-y-6">
                <div>
                  <h1 class="text-3xl font-bold text-gray-900 mb-2">Đổi mật khẩu</h1>
                  <p class="text-gray-600">Cập nhật mật khẩu để bảo mật tài khoản</p>
                </div>

                <div v-if="passwordSuccess" class="bg-green-50 border border-green-200 text-green-800 px-4 py-3 rounded-lg flex items-center gap-3 animate-fade-in">
                  <span class="material-symbols-outlined text-green-600">check_circle</span>
                  <p class="font-medium">{{ passwordSuccess }}</p>
                </div>
                <div v-if="passwordError" class="bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-lg flex items-center gap-3">
                  <span class="material-symbols-outlined text-red-600">error</span>
                  <p class="font-medium">{{ passwordError }}</p>
                </div>

                <form @submit.prevent="changePassword" class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 space-y-5">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Mật khẩu hiện tại</label>
                    <input type="password" v-model="passwordForm.currentPassword" required
                           class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-600 focus:border-transparent"
                           placeholder="Nhập mật khẩu hiện tại" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Mật khẩu mới</label>
                    <input type="password" v-model="passwordForm.newPassword" required minlength="6"
                           class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-600 focus:border-transparent"
                           placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Xác nhận mật khẩu mới</label>
                    <input type="password" v-model="passwordForm.confirmPassword" required minlength="6"
                           class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-600 focus:border-transparent"
                           placeholder="Nhập lại mật khẩu mới" />
                  </div>
                  <button type="submit" :disabled="isChangingPassword"
                          class="w-full py-2.5 bg-yellow-600 text-white rounded-lg hover:bg-yellow-700 transition-colors font-medium disabled:opacity-50 disabled:cursor-not-allowed shadow-sm">
                    <span v-if="!isChangingPassword">Cập nhật mật khẩu</span>
                    <span v-else class="flex items-center justify-center gap-2">
                      <svg class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                      </svg>
                      Đang cập nhật...
                    </span>
                  </button>
                </form>
              </section>

              <!-- Orders Tab -->
              <section v-show="activeTab === 'orders'" class="space-y-6">
                <div>
                  <h1 class="text-3xl font-bold text-gray-900 mb-2">Đơn hàng của tôi</h1>
                  <p class="text-gray-600">Theo dõi trạng thái đơn hàng của bạn</p>
                </div>

                <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-12 text-center">
                  <div class="flex flex-col items-center">
                    <div class="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mb-4">
                      <span class="material-symbols-outlined text-4xl text-gray-400">shopping_bag</span>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">Chưa có đơn hàng</h3>
                    <p class="text-gray-500 mb-6">Bạn chưa có đơn hàng nào. Hãy bắt đầu mua sắm ngay!</p>
                    <a href="/sanpham" class="px-6 py-2.5 bg-yellow-600 text-white rounded-lg hover:bg-yellow-700 transition-colors font-medium shadow-sm">
                      Khám phá sản phẩm
                    </a>
                  </div>
                </div>
              </section>

              <!-- Address Tab -->
              <section v-show="activeTab === 'address'" class="space-y-6">

                <div>
                  <h1 class="text-3xl font-bold text-gray-900 mb-2">
                    Số địa chỉ
                  </h1>
                  <p class="text-gray-600">
                    Quản lý địa chỉ giao hàng của bạn
                  </p>
                </div>

                <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">

                  <div class="flex justify-between items-center mb-4">
                    <h3 class="text-lg font-semibold text-gray-900">
                      Danh sách địa chỉ
                    </h3>

                    <button
                        @click="showAddAddress = true"
                        class="px-4 py-2 bg-yellow-600 text-white rounded-lg hover:bg-yellow-700 text-sm"
                    >
                      + Thêm địa chỉ
                    </button>
                  </div>

                  <!-- Address item -->
                  <div
                      v-for="addr in addresses"
                      :key="addr.maDiaChi"
                      class="border rounded-lg p-4 mb-3"
                  >

                    <p class="font-semibold">{{ addr.hoTenNguoiNhan }}</p>
                    <p class="text-gray-600">{{ addr.soDienThoai }}</p>
                    <p class="text-gray-600">{{ addr.diaChiChiTiet }}</p>

                    <span
                        v-if="addr.laMacDinh"
                        class="text-xs bg-yellow-100 text-yellow-700 px-2 py-1 rounded mt-2 inline-block"
                    >
                      Mặc định
                    </span>

                  </div>

                </div>

              </section>
              <!-- Popup Add Address -->
              <div v-if="showAddAddress" class="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50">

                <div class="bg-white rounded-xl shadow-lg p-6 w-96">

                  <h3 class="text-lg font-semibold mb-4">
                    Thêm địa chỉ mới
                  </h3>

                  <div class="space-y-3">
                    <input
                        v-model="newAddress.ten"
                        type="text"
                        placeholder="Họ tên"
                        class="w-full border rounded-lg px-3 py-2"
                    />

                    <input
                        v-model="newAddress.phone"
                        type="text"
                        placeholder="Số điện thoại"
                        class="w-full border rounded-lg px-3 py-2"
                    />

                    <input
                        v-model="newAddress.diaChi"
                        type="text"
                        placeholder="Địa chỉ"
                        class="w-full border rounded-lg px-3 py-2"
                    />
                  </div>

                  <div class="flex justify-end gap-2 mt-5">

                    <button
                        @click="showAddAddress = false"
                        class="px-4 py-2 border rounded-lg"
                    >
                      Hủy
                    </button>

                    <button
                        @click="saveAddress"
                        class="px-4 py-2 bg-yellow-600 text-white rounded-lg hover:bg-yellow-700"
                    >
                      Lưu
                    </button>

                  </div>

                </div>

              </div>
            </div>
          </div>
        </div>
      </div>
    </main>

    <AppFooter />
  </div>
</template>

<script>
import AppHeader from './fragments/AppHeader.vue'
import AppFooter from './fragments/AppFooter.vue'
import axios from 'axios'

export default {
  name: 'Profile',
  components: {
    AppHeader,
    AppFooter
  },
  data() {
    return {
      activeTab: 'info',
      loading: true,
      error: null,
      successMessage: '',
      errorMessage: '',
      passwordSuccess: '',
      passwordError: '',
      isUpdating: false,
      isChangingPassword: false,
      showAddAddress: false,
      addresses: [],
      newAddress: {
        ten: '',
        phone: '',
        diaChi: ''
      },
      user: {
        hoTen: '',
        email: '',
        soDienThoai: '',
        avatar: null
      },
      passwordForm: {
        currentPassword: '',
        newPassword: '',
        confirmPassword: ''
      }
    }
  },
  methods: {
    async fetchUserData() {
      this.loading = true
      this.error = null

      try {
        const response = await axios.get('/auth/current-user')

        if (response.data.authenticated) {
          // API trả về direct fields, không phải nested trong user object
          this.user = {
            hoTen: response.data.hoTen || '',
            email: response.data.email || '',
            soDienThoai: response.data.soDienThoai || '',
            avatar: response.data.avatar || null
          }
        } else {
          // Not authenticated, redirect to login
          window.location.href = '/login'
        }
      } catch (err) {
        console.error('Error fetching user data:', err)
        if (err.response?.status === 401) {
          window.location.href = '/login'
        } else {
          this.error = 'Không thể tải thông tin tài khoản. Vui lòng thử lại.'
        }
      } finally {
        this.loading = false
      }
    },

    async updateProfile() {
      this.isUpdating = true
      this.successMessage = ''
      this.errorMessage = ''

      try {
        const response = await axios.post('/profile/update', null, {
          params: {
            hoTen: this.user.hoTen,
            soDienThoai: this.user.soDienThoai
          }
        })

        if (response.data.success) {
          this.successMessage = 'Cập nhật thông tin thành công!'
          setTimeout(() => {
            this.successMessage = ''
          }, 3000)
        } else {
          this.errorMessage = response.data.message || 'Cập nhật thất bại'
        }
      } catch (err) {
        console.error('Error updating profile:', err)
        this.errorMessage = 'Có lỗi xảy ra khi cập nhật thông tin'
      } finally {
        this.isUpdating = false
      }
    },

    async changePassword() {
      this.isChangingPassword = true
      this.passwordSuccess = ''
      this.passwordError = ''

      if (this.passwordForm.newPassword !== this.passwordForm.confirmPassword) {
        this.passwordError = 'Mật khẩu mới không khớp!'
        this.isChangingPassword = false
        return
      }

      try {
        const response = await axios.post('/profile/change-password', null, {
          params: {
            oldPassword: this.passwordForm.currentPassword,
            newPassword: this.passwordForm.newPassword,
            confirmPassword: this.passwordForm.confirmPassword
          }
        })

        if (response.data.success) {
          this.passwordSuccess = 'Đổi mật khẩu thành công!'
          this.passwordForm = {
            currentPassword: '',
            newPassword: '',
            confirmPassword: ''
          }
          setTimeout(() => {
            this.passwordSuccess = ''
          }, 3000)
        } else {
          this.passwordError = response.data.message || 'Đổi mật khẩu thất bại'
        }
      } catch (err) {
        console.error('Error changing password:', err)
        this.passwordError = err.response?.data?.message || 'Có lỗi xảy ra khi đổi mật khẩu'
      } finally {
        this.isChangingPassword = false
      }
    },
    async fetchAddresses() {
      const res = await axios.get("/profile/addresses")
      this.addresses = res.data
    },

    async saveAddress() {

      const formData = new FormData()

      formData.append("hoTenNguoiNhan", this.newAddress.ten)
      formData.append("soDienThoai", this.newAddress.phone)
      formData.append("diaChiChiTiet", this.newAddress.diaChi)

      await axios.post("/profile/address/add", formData)

      this.showAddAddress = false
      this.fetchAddresses()
    }

  },

  mounted() {
    this.fetchUserData()
    this.fetchAddresses()
    const hash = window.location.hash.substring(1)

    if (['info','password','orders','address'].includes(hash)) {
      this.activeTab = hash
    }

    if (this.activeTab === "address") {
      this.fetchAddresses()
    }
  }

}
</script>

<style scoped>
@keyframes fade-in {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in {
  animation: fade-in 0.3s ease-out;
}
</style>
