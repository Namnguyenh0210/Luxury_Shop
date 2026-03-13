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

              <button @click="changeTab('favorites')"
                      :class="['flex items-center gap-3 px-4 py-3 rounded-lg group cursor-pointer transition-all',
                               activeTab === 'favorites' ? 'bg-yellow-50 border-l-4 border-yellow-600' : 'hover:bg-gray-50']">
                <span class="material-symbols-outlined"
                      :class="[activeTab === 'favorites' ? 'text-yellow-600' : 'text-gray-600']"
                      style="font-size: 20px;">favorite</span>
                <p :class="['text-sm font-medium', activeTab === 'favorites' ? 'text-yellow-600' : 'text-gray-700']">
                  Danh sách yêu thích
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
                  @click="changeTab('address')"
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
                  Địa chỉ nhận hàng
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

                <!-- Success/Error Messages -->
                <div v-if="successMessage" class="bg-green-50 border border-green-200 text-green-800 px-4 py-3 rounded-lg flex items-center gap-3 mb-6 animate-fade-in">
                  <span class="material-symbols-outlined text-green-600">check_circle</span>
                  <p class="font-medium">{{ successMessage }}</p>
                </div>
                <div v-if="errorMessage" class="bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-lg flex items-center gap-3 mb-6">
                  <span class="material-symbols-outlined text-red-600">error</span>
                  <p class="font-medium">{{ errorMessage }}</p>
                </div>

                <form @submit.prevent="updateProfile" enctype="multipart/form-data">
                  <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">

                    <!-- Header card -->
                    <div class="px-8 py-6 border-b border-gray-100 flex items-center justify-between">
                      <h2 class="text-2xl font-bold text-gray-900">Thông tin cá nhân</h2>
                      <div class="flex gap-3">
                        <button v-if="isEditingInfo" type="button" @click="cancelEdit"
                                class="px-5 py-2 text-sm font-medium text-gray-600 border border-gray-300 rounded-xl hover:bg-gray-50 transition-colors">
                          Huỷ
                        </button>
                        <button v-if="!isEditingInfo" type="button" @click="isEditingInfo = true"
                                class="px-5 py-2 text-sm font-medium text-white bg-yellow-500 hover:bg-yellow-600 rounded-xl transition-colors flex items-center gap-2 shadow-sm">
                          <span class="material-symbols-outlined" style="font-size:16px">edit</span>
                          Cập nhật
                        </button>
                        <button v-if="isEditingInfo" type="submit" :disabled="isUpdating"
                                class="px-5 py-2 text-sm font-medium text-white bg-yellow-600 hover:bg-yellow-700 rounded-xl transition-colors flex items-center gap-2 shadow-sm disabled:opacity-50">
                          <svg v-if="isUpdating" class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                          </svg>
                          <span class="material-symbols-outlined" v-else style="font-size:16px">save</span>
                          {{ isUpdating ? 'Đang lưu...' : 'Lưu thay đổi' }}
                        </button>
                      </div>
                    </div>

                    <!-- Avatar row -->
                    <div class="px-8 py-6 border-b border-gray-100 flex flex-col sm:flex-row sm:items-center gap-6">
                      <div class="sm:w-48 shrink-0">
                        <p class="text-sm font-medium text-gray-500">Ảnh đại diện</p>
                      </div>
                      <div class="flex items-center gap-5">
                        <!-- Avatar preview -->
                        <div class="relative h-20 w-20 shrink-0">
                          <div class="h-20 w-20 rounded-full overflow-hidden border-2 border-gray-200 flex items-center justify-center bg-gradient-to-br from-yellow-300 to-yellow-500 text-white text-2xl font-bold"
                               :style="avatarPreview ? `background-image:url('${avatarPreview}');background-size:cover;background-color:transparent;` : (user.avatar ? `background-image:url('${user.avatar}');background-size:cover;background-color:transparent;` : '')">
                            <span v-if="!avatarPreview && !user.avatar">{{ user.hoTen ? user.hoTen.charAt(0).toUpperCase() : 'U' }}</span>
                          </div>
                          <!-- Upload overlay when editing -->
                          <label v-if="isEditingInfo" for="avatarInput"
                                 class="absolute inset-0 flex items-center justify-center rounded-full bg-black bg-opacity-40 cursor-pointer hover:bg-opacity-50 transition">
                            <span class="material-symbols-outlined text-white" style="font-size:22px">photo_camera</span>
                          </label>
                          <input id="avatarInput" type="file" accept="image/*" class="hidden" @change="onAvatarChange" ref="avatarInput" />
                        </div>
                        <div v-if="isEditingInfo" class="text-sm text-gray-500">
                          <p class="font-medium text-gray-700 mb-1">Thay ảnh đại diện</p>
                          <p>Nhấn vào ảnh để chọn file mới. Hỗ trợ JPG, PNG (tối đa 5MB).</p>
                          <p v-if="avatarPreview" class="text-yellow-600 font-medium mt-1">✓ Đã chọn ảnh mới</p>
                        </div>
                        <div v-else class="text-sm text-gray-500">
                          <p class="text-base font-semibold text-gray-900">{{ user.hoTen }}</p>
                          <p>{{ user.email }}</p>
                        </div>
                      </div>
                    </div>

                    <!-- Họ và Tên -->
                    <div class="px-8 py-5 border-b border-gray-100 flex flex-col sm:flex-row sm:items-center gap-4">
                      <div class="sm:w-48 shrink-0">
                        <label class="text-sm font-medium text-gray-500" for="hoTenInput">Họ và tên</label>
                      </div>
                      <div class="flex-1">
                        <input v-if="isEditingInfo" id="hoTenInput" type="text" v-model="user.hoTen" required
                               class="w-full px-4 py-2.5 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-yellow-500 focus:border-transparent transition"
                               placeholder="Nhập họ và tên" />
                        <p v-else class="text-sm font-medium text-gray-900">{{ user.hoTen || 'Chưa cập nhật' }}</p>
                      </div>
                    </div>

                    <!-- Email -->
                    <div class="px-8 py-5 border-b border-gray-100 flex flex-col sm:flex-row sm:items-center gap-4">
                      <div class="sm:w-48 shrink-0">
                        <label class="text-sm font-medium text-gray-500">Email</label>
                      </div>
                      <div class="flex-1 flex items-center gap-3">
                        <p class="text-sm font-medium text-gray-900">{{ user.email }}</p>
                        <span class="text-xs bg-gray-100 text-gray-500 px-2 py-0.5 rounded-full">Không thể thay đổi</span>
                      </div>
                    </div>

                    <!-- Số điện thoại -->
                    <div class="px-8 py-5 border-b border-gray-100 flex flex-col sm:flex-row sm:items-center gap-4">
                      <div class="sm:w-48 shrink-0">
                        <label class="text-sm font-medium text-gray-500" for="phoneInput">Số điện thoại</label>
                      </div>
                      <div class="flex-1">
                        <input v-if="isEditingInfo" id="phoneInput" type="tel" v-model="user.soDienThoai"
                               class="w-full px-4 py-2.5 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-yellow-500 focus:border-transparent transition"
                               placeholder="Nhập số điện thoại" />
                        <p v-else class="text-sm font-medium text-gray-900">{{ user.soDienThoai || 'Chưa cập nhật' }}</p>
                      </div>
                    </div>

                    <!-- Ngày tham gia -->
                    <div class="px-8 py-5 border-b border-gray-100 flex flex-col sm:flex-row sm:items-center gap-4">
                      <div class="sm:w-48 shrink-0">
                        <p class="text-sm font-medium text-gray-500">Ngày tham gia</p>
                      </div>
                      <div class="flex-1">
                        <p class="text-sm font-medium text-gray-900">
                          {{ user.ngayTao ? new Date(user.ngayTao).toLocaleDateString('vi-VN', { year:'numeric', month:'long', day:'numeric' }) : 'Chưa cập nhật' }}
                        </p>
                      </div>
                    </div>

                    <!-- Trạng thái tài khoản -->
                    <div class="px-8 py-5 border-b border-gray-100 flex flex-col sm:flex-row sm:items-center gap-4">
                      <div class="sm:w-48 shrink-0">
                        <p class="text-sm font-medium text-gray-500">Trạng thái tài khoản</p>
                      </div>
                      <div class="flex-1">
                        <span v-if="user.trangThai" class="inline-flex items-center gap-1.5 text-sm font-medium text-green-700 bg-green-50 px-3 py-1 rounded-full">
                          <span class="h-1.5 w-1.5 rounded-full bg-green-500"></span>
                          Đang hoạt động
                        </span>
                        <span v-else class="inline-flex items-center gap-1.5 text-sm font-medium text-red-700 bg-red-50 px-3 py-1 rounded-full">
                          <span class="h-1.5 w-1.5 rounded-full bg-red-500"></span>
                          Bị khoá
                        </span>
                      </div>
                    </div>

                    <!-- Mật khẩu -->
                    <div class="px-8 py-5 flex flex-col sm:flex-row sm:items-center gap-4">
                      <div class="sm:w-48 shrink-0">
                        <p class="text-sm font-medium text-gray-500">Mật khẩu</p>
                      </div>
                      <div class="flex-1 flex items-center justify-between">
                        <p class="text-gray-400 tracking-widest text-lg leading-none">••••••••</p>
                        <button type="button" @click="showPasswordModal = true"
                                class="text-sm font-medium text-yellow-600 hover:text-yellow-700 border-b border-yellow-500 hover:border-yellow-700 transition leading-tight">
                          Đổi mật khẩu
                        </button>
                      </div>
                    </div>

                  </div>
                </form>
              </section>
              <!-- Change Password Popup (Modal) -->
              <div v-if="showPasswordModal" class="fixed inset-0 bg-black/60 backdrop-blur-md flex items-center justify-center z-[9999] p-4 animate-fade-in">
                <div class="bg-white rounded-xl shadow-lg p-6 w-full max-w-md">
                  <h3 class="text-2xl font-bold text-gray-900 mb-2">Đổi mật khẩu</h3>
                  <p class="text-gray-600 mb-6 text-sm">Cập nhật mật khẩu để bảo mật tài khoản</p>

                  <div v-if="passwordSuccess" class="bg-green-50 border border-green-200 text-green-800 px-4 py-3 rounded-lg flex items-center gap-3 mb-4 animate-fade-in">
                    <span class="material-symbols-outlined text-green-600">check_circle</span>
                    <p class="font-medium text-sm">{{ passwordSuccess }}</p>
                  </div>
                  <div v-if="passwordError" class="bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-lg flex items-center gap-3 mb-4">
                    <span class="material-symbols-outlined text-red-600">error</span>
                    <p class="font-medium text-sm">{{ passwordError }}</p>
                  </div>

                  <form @submit.prevent="changePassword" class="space-y-4">
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Mật khẩu hiện tại</label>
                      <input type="password" v-model="passwordForm.currentPassword" required
                             class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-600 focus:border-transparent"
                             placeholder="Nhập mật khẩu hiện tại" />
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Mật khẩu mới</label>
                      <input type="password" v-model="passwordForm.newPassword" required minlength="4"
                             class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-600 focus:border-transparent"
                             placeholder="Ít nhất 4 ký tự" />
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Xác nhận mật khẩu mới</label>
                      <input type="password" v-model="passwordForm.confirmPassword" required minlength="4"
                             class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-600 focus:border-transparent"
                             placeholder="Nhập lại mật khẩu mới" />
                    </div>

                    <div class="flex justify-end gap-3 mt-6">
                      <button type="button" @click="showPasswordModal = false"
                              class="px-5 py-2.5 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors font-medium">
                        Huỷ
                      </button>
                      <button type="submit" :disabled="isChangingPassword"
                              class="px-5 py-2.5 bg-yellow-600 text-white rounded-lg hover:bg-yellow-700 transition-colors font-medium disabled:opacity-50 disabled:cursor-not-allowed shadow-sm">
                        <span v-if="!isChangingPassword">Lưu mật khẩu</span>
                        <span v-else class="flex items-center justify-center gap-2">
                        <svg class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24">
                          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                        Lưu...
                      </span>
                      </button>
                    </div>
                  </form>
                </div>
              </div>

              <!-- Favorites Tab -->
              <section v-if="activeTab === 'favorites'">
                <div>
                  <h1 class="text-3xl font-bold text-gray-900 mb-2">Sản phẩm yêu thích</h1>
                  <p class="text-gray-600">Những sản phẩm bạn đã lưu lại</p>
                </div>

                <!-- Không có sản phẩm yêu thích -->
                <div v-if="favorites.length === 0" class="bg-white rounded-xl shadow-sm border border-gray-200 p-12 text-center mt-6">
                  <h3 class="text-lg font-semibold text-gray-900 mb-2">Chưa có sản phẩm yêu thích</h3>
                  <a href="/sanpham" class="px-6 py-2 bg-yellow-600 text-white rounded-lg inline-block mt-2 font-medium hover:bg-yellow-700 transition">Khám phá sản phẩm</a>
                </div>

                <!-- Danh sách sản phẩm yêu thích -->
                <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mt-6">
                  <div v-for="fav in favorites" :key="fav.maSPYT" class="bg-white border rounded-xl shadow-sm hover:shadow-md transition overflow-hidden group">
                    <div class="relative h-48 sm:h-56 bg-gray-100 flex items-center justify-center overflow-hidden">
                      <img v-if="fav.anhChinh" :src="`http://localhost:8080/products/images/${fav.anhChinh}`" :alt="fav.tenSP" class="w-full h-full object-cover mix-blend-multiply group-hover:scale-110 transition duration-500" />
                      <span v-else class="material-symbols-outlined text-gray-400 text-5xl">image</span>
                      
                      <!-- Nút xóa yêu thích (hiển thị khi hover) -->
                      <button @click="toggleFavorite(fav.maSP)" class="absolute top-3 right-3 bg-white p-2 text-red-500 rounded-full shadow-md opacity-0 group-hover:opacity-100 transition hover:bg-red-50">
                        <span class="material-symbols-outlined filled text-xl">favorite</span>
                      </button>
                    </div>
                    
                    <div class="p-4">
                      <p class="text-xs text-gray-500 font-medium uppercase tracking-wider mb-1">{{ fav.thuongHieu }}</p>
                      <h3 class="font-semibold text-gray-900 mb-2 line-clamp-2 min-h-[40px]">{{ fav.tenSP }}</h3>
                      <div class="flex items-center justify-between mt-4">
                        <p class="text-yellow-600 font-bold text-lg max-w-[50%] truncate">{{ fav.gia?.toLocaleString() }}₫</p>
                        <router-link :to="`/sanpham/${fav.maSP}`" class="text-sm font-medium border border-gray-300 rounded-xl px-4 py-1.5 hover:bg-gray-50 transition max-w-[45%] truncate">
                          Chi tiết
                        </router-link>
                      </div>
                    </div>
                  </div>
                </div>
              </section>

              <!-- Orders Tab -->
              <section v-if="activeTab === 'orders'">

                <div>
                  <h1 class="text-3xl font-bold text-gray-900 mb-2">Đơn hàng của tôi</h1>
                  <p class="text-gray-600">Theo dõi trạng thái đơn hàng của bạn</p>
                </div>

                <!-- Tabs trạng thái -->
                <div class="flex gap-6 border-b pb-2 mt-4">

                  <button
                      @click="orderStatus='all'"
                      :class="orderStatus==='all'
        ? 'text-yellow-600 border-b-2 border-yellow-600 pb-2 font-semibold'
        : 'text-gray-600'">
                    Tất cả ({{ orderCounts['all'] || 0 }})
                  </button>

                  <button
                      @click="orderStatus='0'"
                      :class="orderStatus==='0'
        ? 'text-yellow-600 border-b-2 border-yellow-600 pb-2 font-semibold'
        : 'text-gray-600'">
                    Chờ xác nhận ({{ orderCounts['0'] || 0 }})
                  </button>

                  <button
                      @click="orderStatus='1'"
                      :class="orderStatus==='1'
        ? 'text-yellow-600 border-b-2 border-yellow-600 pb-2 font-semibold'
        : 'text-gray-600'">
                    Đã xác nhận ({{ orderCounts['1'] || 0 }})
                  </button>

                  <button
                      @click="orderStatus='2'"
                      :class="orderStatus==='2'
        ? 'text-yellow-600 border-b-2 border-yellow-600 pb-2 font-semibold'
        : 'text-gray-600'">
                    Đang giao ({{ orderCounts['2'] || 0 }})
                  </button>
                  
                  <button
                      @click="orderStatus='3'"
                      :class="orderStatus==='3'
        ? 'text-yellow-600 border-b-2 border-yellow-600 pb-2 font-semibold'
        : 'text-gray-600'">
                    Đã giao ({{ orderCounts['3'] || 0 }})
                  </button>

                  <button
                      @click="orderStatus='4'"
                      :class="orderStatus==='4'
        ? 'text-yellow-600 border-b-2 border-yellow-600 pb-2 font-semibold'
        : 'text-gray-600'">
                    Hoàn thành ({{ orderCounts['4'] || 0 }})
                  </button>

                  <button
                      @click="orderStatus='5'"
                      :class="orderStatus==='5'
        ? 'text-yellow-600 border-b-2 border-yellow-600 pb-2 font-semibold'
        : 'text-gray-600'">
                    Đã huỷ ({{ orderCounts['5'] || 0 }})
                  </button>

                </div>

                <!-- Không có đơn -->
                <div
                    v-if="filteredOrders.length === 0"
                    class="bg-white rounded-xl shadow-sm border border-gray-200 p-12 text-center mt-6">

                  <h3 class="text-lg font-semibold text-gray-900 mb-2">
                    Chưa có đơn hàng
                  </h3>

                  <a href="/sanpham"
                     class="px-6 py-2 bg-yellow-600 text-white rounded-lg">
                    Khám phá sản phẩm
                  </a>

                </div>

                <!-- Danh sách đơn -->
                <div v-else class="space-y-4 mt-6">

                  <div
                      v-for="order in filteredOrders"
                      :key="order.maDH"
                      class="bg-white border rounded-lg p-5 shadow-sm">

                    <div class="flex justify-between mb-2">

                      <p class="font-semibold">
                        Mã đơn: #{{ order.maDH }}
                      </p>

                      <!-- Badge trạng thái -->
                      <span v-if="order.trangThaiDH == 0" class="text-yellow-600 font-medium">
                        Chờ xác nhận
                      </span>

                      <span v-if="order.trangThaiDH == 1" class="text-blue-500 font-medium">
                        Đã xác nhận
                      </span>

                      <span v-if="order.trangThaiDH == 2" class="text-indigo-600 font-medium">
                        Đang giao
                      </span>

                      <span v-if="order.trangThaiDH == 3" class="text-teal-600 font-medium">
                        Đã giao
                      </span>

                      <span v-if="order.trangThaiDH == 4" class="text-green-600 font-medium">
                        Hoàn thành
                      </span>

                      <span v-if="order.trangThaiDH == 5" class="text-red-600 font-medium">
                        Đã huỷ
                      </span>
                      
                      <span v-if="order.khachBaoChuaNhan" class="text-orange-600 font-bold ml-2 animate-pulse">
                        (Khách báo chưa nhận hàng)
                      </span>

                    </div>

                    <p class="text-gray-600 text-sm">
                      Ngày đặt: {{ new Date(order.ngayDat).toLocaleString() }}
                    </p>

                    <p class="text-gray-800 font-semibold mt-2">
                      Tổng tiền: {{ order.tongTien?.toLocaleString() }}₫
                    </p>

                    <!-- Nút huỷ đơn -->
                    <div v-if="order.trangThaiDH == 3" class="flex gap-3 mt-3">
                      <button
                          @click="updateOrderStatus(order.maDH, 4)"
                          class="bg-green-500 hover:bg-green-600 transition-colors text-white px-4 py-2 text-sm font-medium rounded shadow-sm flex-1">
                        📦 Đã nhận hàng
                      </button>
                      
                      <button
                          v-if="!order.khachBaoChuaNhan"
                          @click="openReportModal(order.maDH)"
                          class="bg-white border-2 border-red-500 hover:bg-red-50 transition-colors text-red-600 px-4 py-2 text-sm font-medium rounded shadow-sm flex-1">
                        ⚠️ Chưa nhận được hàng
                      </button>
                      
                      <span v-else class="text-orange-600 text-xs italic font-medium pt-2">
                        Đã báo lỗi cho Admin
                      </span>
                    </div>
                  </div>

                </div>

              </section>

              <section v-show="activeTab === 'address'" class="space-y-6">

                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                  <div>
                    <h1 class="text-3xl font-bold text-gray-900 mb-2">
                      Địa chỉ nhận hàng
                    </h1>
                    <p class="text-gray-600">
                      Quản lý các địa chỉ nhận hàng để đặt hàng nhanh chóng hơn
                    </p>
                  </div>
                  <button
                      @click="showAddAddress = true"
                      class="px-6 py-3 bg-yellow-600 text-white rounded-xl hover:bg-yellow-700 transition-all font-bold shadow-lg flex items-center justify-center gap-2 shrink-0 animate-fade-in"
                  >
                    <span class="material-symbols-outlined">add_location</span>
                    Thêm địa chỉ mới
                  </button>
                </div>

                <div class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
                  <div class="px-6 py-4 border-b border-gray-100 bg-gray-50/50">
                    <h3 class="font-bold text-gray-900 flex items-center gap-2">
                      <span class="material-symbols-outlined text-yellow-600">location_on</span>
                      Danh sách địa chỉ đã đăng kí
                    </h3>
                  </div>

                  <div class="p-6">
                    <div v-if="addresses.length === 0" class="text-center py-12">
                      <div class="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <span class="material-symbols-outlined text-3xl text-gray-400">address_home</span>
                      </div>
                      <p class="text-gray-500 font-medium">Bạn chưa có địa chỉ nhận hàng nào.</p>
                      <button @click="showAddAddress = true" class="text-yellow-600 font-bold mt-2 hover:underline">Thêm ngay!</button>
                    </div>

                    <!-- Address item -->
                    <div
                        v-for="addr in addresses"
                        :key="addr.maDiaChi"
                        class="border rounded-2xl p-6 mb-4 hover:border-yellow-400 hover:shadow-md transition-all group relative overflow-hidden"
                        :class="{'border-yellow-500 bg-yellow-50/20 ring-1 ring-yellow-500/20': addr.laMacDinh}"
                    >
                      <div class="flex flex-col md:flex-row md:items-start justify-between gap-6">
                        <div class="space-y-3 flex-1">
                          <div class="flex items-center gap-3">
                            <p class="font-bold text-gray-900 text-xl">{{ addr.hoTenNguoiNhan }}</p>
                            <span v-if="addr.laMacDinh" class="text-[10px] bg-yellow-600 text-white px-2.5 py-1 rounded-full font-bold uppercase tracking-widest shadow-sm">Mặc định</span>
                          </div>
                          
                          <div class="grid grid-cols-1 sm:grid-cols-2 gap-y-2 gap-x-6 text-gray-600">
                            <div class="flex items-center gap-2">
                              <span class="material-symbols-outlined text-yellow-600 text-lg">call</span>
                              <p class="text-sm font-semibold tracking-wide text-gray-800">{{ addr.soDienThoai }}</p>
                            </div>
                            <div class="flex items-start gap-2 sm:col-span-2">
                              <span class="material-symbols-outlined text-yellow-600 text-lg mt-0.5">location_on</span>
                              <p class="text-sm leading-relaxed">{{ addr.diaChiChiTiet }}</p>
                            </div>
                          </div>

                          <div v-if="addr.ghiChu" class="flex items-start gap-3 bg-white/50 border border-gray-100 p-3 rounded-xl mt-3">
                            <span class="material-symbols-outlined text-gray-400 text-lg mt-0.5">sticky_note_2</span>
                            <div class="flex-1">
                              <p class="text-[10px] uppercase font-bold text-gray-400 tracking-wider mb-0.5">Ghi chú</p>
                              <p class="text-xs text-gray-600 italic">{{ addr.ghiChu }}</p>
                            </div>
                          </div>
                        </div>

                        <div class="flex md:flex-col gap-2 shrink-0">
                          <button
                              v-if="!addr.laMacDinh"
                              @click="setDefaultAddress(addr.maDiaChi)"
                              class="flex-1 md:w-full text-xs font-bold text-yellow-700 hover:bg-yellow-600 hover:text-white bg-yellow-50 px-4 py-2.5 rounded-xl transition-all border border-yellow-200"
                          >
                            Đặt mặc định
                          </button>
                          <button
                              @click="deleteAddress(addr.maDiaChi)"
                              class="flex-1 md:w-full text-xs font-bold text-red-600 hover:bg-red-600 hover:text-white bg-red-50 px-4 py-2.5 rounded-xl transition-all border border-red-200"
                          >
                            Xóa địa chỉ
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </section>

              <!-- Popup Thêm địa chỉ mới -->
              <div v-if="showAddAddress" class="fixed inset-0 bg-black/60 backdrop-blur-md flex items-center justify-center z-[9999] p-4 animate-fade-in">
                <div class="bg-white rounded-3xl shadow-2xl w-full max-w-lg overflow-hidden transform transition-all scale-100">
                  <div class="bg-gradient-to-r from-yellow-500 to-yellow-600 px-8 py-6 text-white flex justify-between items-center">
                    <div>
                      <h3 class="text-2xl font-bold flex items-center gap-2">
                        <span class="material-symbols-outlined">add_location_alt</span>
                        Thêm địa chỉ mới
                      </h3>
                      <p class="text-yellow-50 text-xs mt-1">Vui lòng điền thông tin người nhận chính xác</p>
                    </div>
                    <button @click="showAddAddress = false" class="bg-white/20 hover:bg-white/40 p-2 rounded-full transition-colors">
                      <span class="material-symbols-outlined">close</span>
                    </button>
                  </div>

                  <div class="p-8 space-y-5">
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                      <div class="space-y-1.5">
                        <label class="text-xs font-bold text-gray-500 uppercase tracking-wider ml-1">Tên người nhận <span class="text-red-500">*</span></label>
                        <div class="relative">
                          <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-xl">person</span>
                          <input
                              v-model="newAddress.ten"
                              type="text"
                              placeholder="Họ và tên"
                              class="w-full bg-gray-50 border border-gray-200 rounded-2xl pl-11 pr-4 py-3 text-sm focus:ring-2 focus:ring-yellow-500 focus:border-yellow-500 focus:bg-white transition-all outline-none"
                          />
                        </div>
                      </div>
                      <div class="space-y-1.5">
                        <label class="text-xs font-bold text-gray-500 uppercase tracking-wider ml-1">Số điện thoại <span class="text-red-500">*</span></label>
                        <div class="relative">
                          <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-xl">call</span>
                          <input
                              v-model="newAddress.phone"
                              type="text"
                              placeholder="Số điện thoại"
                              class="w-full bg-gray-50 border border-gray-200 rounded-2xl pl-11 pr-4 py-3 text-sm focus:ring-2 focus:ring-yellow-500 focus:border-yellow-500 focus:bg-white transition-all outline-none"
                          />
                        </div>
                      </div>
                    </div>

                    <div class="space-y-1.5">
                      <label class="text-xs font-bold text-gray-500 uppercase tracking-wider ml-1">Địa chỉ nhận hàng <span class="text-red-500">*</span></label>
                      <div class="relative">
                        <span class="material-symbols-outlined absolute left-3 top-3 text-gray-400 text-xl">map</span>
                        <textarea
                            v-model="newAddress.diaChi"
                            rows="2"
                            placeholder="Số nhà, tên đường, Phường/Xã, Quận/Huyện, Tỉnh/Thành phố"
                            class="w-full bg-gray-50 border border-gray-200 rounded-2xl pl-11 pr-4 py-3 text-sm focus:ring-2 focus:ring-yellow-500 focus:border-yellow-500 focus:bg-white transition-all outline-none resize-none"
                        ></textarea>
                      </div>
                    </div>

                    <div class="space-y-1.5">
                      <label class="text-xs font-bold text-gray-500 uppercase tracking-wider ml-1">Ghi chú thêm</label>
                      <div class="relative">
                        <span class="material-symbols-outlined absolute left-3 top-3 text-gray-400 text-xl">description</span>
                        <textarea
                            v-model="newAddress.ghiChu"
                            rows="2"
                            placeholder="Ví dụ: Giao giờ hành chính, gọi trước khi đến..."
                            class="w-full bg-gray-50 border border-gray-200 rounded-2xl pl-11 pr-4 py-3 text-sm focus:ring-2 focus:ring-yellow-500 focus:border-yellow-500 focus:bg-white transition-all outline-none resize-none"
                        ></textarea>
                      </div>
                    </div>
                  </div>

                  <div class="px-8 py-6 bg-gray-50 flex gap-4">
                    <button
                        @click="showAddAddress = false"
                        class="flex-1 px-6 py-3 border border-gray-300 rounded-2xl text-gray-700 font-bold hover:bg-white transition-all active:scale-95"
                    >
                      Hủy bỏ
                    </button>
                    <button
                        @click="saveAddress"
                        class="flex-1 px-6 py-3 bg-yellow-600 text-white rounded-2xl font-bold hover:bg-yellow-700 transition-all shadow-lg shadow-yellow-600/20 active:scale-95 flex items-center justify-center gap-2"
                    >
                      <span class="material-symbols-outlined text-xl">save</span>
                      Lưu địa chỉ
                    </button>
                  </div>
                </div>
              </div>

              <!-- Modal Báo chưa nhận được hàng -->
              <div v-if="showReportModal" class="fixed inset-0 bg-black/60 backdrop-blur-md flex items-center justify-center z-[9999] p-4 animate-fade-in">
                <div class="bg-white rounded-2xl shadow-2xl max-w-md w-full overflow-hidden transform transition-all">
                  <div class="bg-red-600 p-4 text-white flex justify-between items-center">
                    <h3 class="font-bold text-lg flex items-center gap-2">
                      <span class="material-symbols-outlined">report_problem</span>
                      Bạn chưa nhận được hàng?
                    </h3>
                    <button @click="closeReportModal" class="hover:bg-red-700 rounded-full p-1 leading-none">
                      <span class="material-symbols-outlined">close</span>
                    </button>
                  </div>
                  
                  <div class="p-6 space-y-4">
                    <div>
                      <label class="block text-sm font-bold text-gray-700 mb-2">Lý do chưa nhận được:</label>
                      <div class="space-y-2">
                        <label class="flex items-center gap-3 p-3 border rounded-xl hover:bg-gray-50 cursor-pointer transition-colors"
                               :class="reportData.reason === 'Chưa thấy giao' ? 'border-red-500 bg-red-50' : 'border-gray-200'">
                          <input type="radio" v-model="reportData.reason" value="Chưa thấy giao" class="w-4 h-4 text-red-600">
                          <span class="text-sm font-medium">Chưa thấy giao</span>
                        </label>
                        <label class="flex items-center gap-3 p-3 border rounded-xl hover:bg-gray-50 cursor-pointer transition-colors"
                               :class="reportData.reason === 'Giao nhầm địa chỉ' ? 'border-red-500 bg-red-50' : 'border-gray-200'">
                          <input type="radio" v-model="reportData.reason" value="Giao nhầm địa chỉ" class="w-4 h-4 text-red-600">
                          <span class="text-sm font-medium">Giao nhầm địa chỉ</span>
                        </label>
                        <label class="flex items-center gap-3 p-3 border rounded-xl hover:bg-gray-50 cursor-pointer transition-colors"
                               :class="reportData.reason === 'Khác' ? 'border-red-500 bg-red-50' : 'border-gray-200'">
                          <input type="radio" v-model="reportData.reason" value="Khác" class="w-4 h-4 text-red-600">
                          <span class="text-sm font-medium">Khác</span>
                        </label>
                      </div>
                    </div>

                    <div>
                      <label class="block text-sm font-bold text-gray-700 mb-2">Mô tả thêm:</label>
                      <textarea 
                        v-model="reportData.description"
                        placeholder="Có thể ghi thêm thông tin chi tiết để shop hỗ trợ nhanh hơn..."
                        class="w-full border-gray-200 rounded-xl px-4 py-3 text-sm focus:ring-red-500 focus:border-red-500 min-h-[100px]"
                      ></textarea>
                    </div>

                    <p class="text-[11px] text-gray-500 italic leading-relaxed">
                      * Sau khi gửi, shop sẽ liên hệ với bạn để kiểm tra và xử lý hủy đơn/hoàn tiền nếu cần thiết.
                    </p>
                  </div>

                  <div class="p-4 bg-gray-50 border-t flex gap-3">
                    <button @click="closeReportModal" class="flex-1 px-4 py-3 border border-gray-300 rounded-xl text-gray-700 font-bold hover:bg-white transition-all">
                      Đóng
                    </button>
                    <button @click="submitReport" 
                      :disabled="!reportData.reason"
                      class="flex-1 px-4 py-3 bg-red-600 text-white rounded-xl font-bold hover:bg-red-700 transition-all shadow-lg disabled:opacity-50 disabled:cursor-not-allowed">
                      Gửi báo cáo
                    </button>
                  </div>
                </div>
              </div>

            </div><!-- end Content Tabs -->
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
      showPasswordModal: false,
      isEditingInfo: false,
      avatarPreview: null,
      userSnapshot: null,
      showAddAddress: false,
      addresses: [],
      orders: [],
      favorites: [],
      orderStatus: "all",
      showReportModal: false,
      reportOrderId: null,
      reportData: {
        reason: '',
        description: ''
      },
      newAddress: {
        ten: '',
        phone: '',
        diaChi: '',
        ghiChu: ''
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

  computed: {
    orderCounts() {
      const counts = { 'all': this.orders.length, '0': 0, '1': 0, '2': 0, '3': 0, '4': 0, '5': 0 }
      this.orders.forEach(order => {
        if (counts[order.trangThaiDH] !== undefined) {
          counts[order.trangThaiDH]++
        }
      })
      return counts
    },
    filteredOrders() {
      if (this.orderStatus === "all") {
        return this.orders
      }

      return this.orders.filter(
          order => order.trangThaiDH == this.orderStatus
      )
    }
  },

  methods: {

    changeTab(tab) {
      this.activeTab = tab
      window.location.hash = tab

      if (tab === "orders") {
        this.fetchOrders()
      }

      if (tab === "address") {
        this.fetchAddresses()
      }
      
      if (tab === "favorites") {
        this.fetchFavorites()
      }
    },

    async fetchUserData() {
      this.loading = true
      this.error = null

      try {
        const response = await axios.get("/auth/current-user")

        if (response.data) {
          this.user = {
            hoTen: response.data.hoTen || '',
            email: response.data.email || '',
            soDienThoai: response.data.soDienThoai || '',
            avatar: response.data.avatar || null,
            trangThai: response.data.trangThai !== false,
            ngayTao: response.data.ngayTao || null
          }
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
        const formData = new FormData()
        formData.append('hoTen', this.user.hoTen)
        if (this.user.soDienThoai) formData.append('soDienThoai', this.user.soDienThoai)
        if (this.$refs.avatarInput && this.$refs.avatarInput.files[0]) {
          formData.append('avatar', this.$refs.avatarInput.files[0])
        }

        const response = await axios.post('/api/profile/update', formData, {
          headers: { 'Content-Type': 'multipart/form-data' }
        })

        if (response.data.success) {
          this.successMessage = 'Cập nhật thông tin thành công!'
          if (response.data.avatar) this.user.avatar = response.data.avatar
          if (response.data.hoTen) this.user.hoTen = response.data.hoTen
          this.isEditingInfo = false
          this.avatarPreview = null
          this.userSnapshot = null
          setTimeout(() => { this.successMessage = '' }, 3000)
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

    cancelEdit() {
      if (this.userSnapshot) {
        this.user.hoTen = this.userSnapshot.hoTen
        this.user.soDienThoai = this.userSnapshot.soDienThoai
      }
      this.isEditingInfo = false
      this.avatarPreview = null
      this.userSnapshot = null
      if (this.$refs.avatarInput) this.$refs.avatarInput.value = ''
    },

    onAvatarChange(event) {
      const file = event.target.files[0]
      if (!file) return
      const reader = new FileReader()
      reader.onload = (e) => { this.avatarPreview = e.target.result }
      reader.readAsDataURL(file)
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
      if (!this.newAddress.ten || !this.newAddress.phone || !this.newAddress.diaChi) {
        alert("Vui lòng điền đầy đủ các thông tin bắt buộc!");
        return;
      }

      const formData = new FormData()
      formData.append("hoTenNguoiNhan", this.newAddress.ten)
      formData.append("soDienThoai", this.newAddress.phone)
      formData.append("diaChiChiTiet", this.newAddress.diaChi)
      if (this.newAddress.ghiChu) formData.append("ghiChu", this.newAddress.ghiChu)

      try {
        await axios.post("/profile/address/add", formData)
        this.newAddress = { ten: '', phone: '', diaChi: '', ghiChu: '' }
        this.showAddAddress = false // Đóng popup khi thêm thành công
        this.fetchAddresses()
        alert("Đã thêm địa chỉ mới!");
      } catch (err) {
        console.error("Save address error", err)
        alert("Lỗi khi thêm địa chỉ!");
      }
    },

    async setDefaultAddress(id) {
      try {
        const formData = new FormData()
        formData.append("id", id)
        await axios.post("/profile/address/set-default", formData)
        this.fetchAddresses()
      } catch (err) {
        console.error("Set default address error", err)
        alert("Lỗi khi đặt địa chỉ mặc định!");
      }
    },

    async deleteAddress(id) {
      if (!confirm("Bạn có chắc chắn muốn xóa địa chỉ này?")) return;
      try {
        const formData = new FormData()
        formData.append("id", id)
        // Dùng endpoint delete có sẵn trong ProfileController (nếu chạy qua Proxy)
        // Hoặc check xem ApiController có hỗ trợ delete không. 
        // ProfileController.java has @PostMapping("/profile/address/delete")
        await axios.post("/profile/address/delete", formData)
        this.fetchAddresses()
      } catch (err) {
        console.error("Delete address error", err)
        alert("Lỗi khi xóa địa chỉ!");
      }
    },

    async fetchOrders() {
      try {

        const res = await axios.get("http://localhost:8080/api/orders/my", {
          withCredentials: true
        })

        this.orders = res.data

      } catch (err) {
        console.error("Error loading orders", err)
      }
    },

    async cancelOrder(orderId) {
      if (!confirm('Bạn có chắc chắn muốn huỷ đơn hàng này?')) return;
      try {
        await axios.put(
            `http://localhost:8080/api/orders/update-status/${orderId}`,
            null,
            {
              params: { status: 5 },
              withCredentials: true
            }
        )
        this.fetchOrders()
      } catch (err) {
        console.error("Cancel order error", err)
      }
    },

    async updateOrderStatus(orderId, status) {
      try {
        await axios.put(
            `http://localhost:8080/api/orders/update-status/${orderId}`,
            null,
            {
              params: { status: status },
              withCredentials: true
            }
        )
        this.fetchOrders()
      } catch (err) {
        console.error("Update status error", err)
      }
    },

    async fetchFavorites() {
      try {
        const res = await axios.get("http://localhost:8080/api/favorites", {
          withCredentials: true
        })
        this.favorites = res.data
      } catch (err) {
        console.error("Error loading favorites", err)
      }
    },

    async toggleFavorite(maSP) {
      try {
        await axios.post(`http://localhost:8080/api/favorites/toggle`, null, {
          params: { maSP: maSP },
          withCredentials: true
        })
        this.fetchFavorites() 
      } catch (err) {
        console.error("Error toggling favorite", err)
      }
    },

    openReportModal(orderId) {
      this.reportOrderId = orderId
      this.reportData = { reason: '', description: '' }
      this.showReportModal = true
    },

    closeReportModal() {
      this.showReportModal = false
    },

    async submitReport() {
      if (!this.reportData.reason) return
      try {
        await axios.put(
          `http://localhost:8080/api/orders/${this.reportOrderId}/report-undelivered`,
          null,
          {
            params: { 
              reason: this.reportData.reason,
              description: this.reportData.description
            },
            withCredentials: true
          }
        )
        alert('Đã gửi báo cáo cho Admin!')
        this.closeReportModal()
        this.fetchOrders()
      } catch (err) {
        console.error('Submit report error', err)
        alert('Lỗi: ' + (err.response?.data?.message || 'Không thể gửi báo cáo'))
      }
    },
  },

  mounted() {
    this.fetchUserData()
    this.fetchOrders()
    this.fetchAddresses()
    this.fetchFavorites()

    const hash = window.location.hash.replace("#", "")

    if (hash) {
      this.activeTab = hash
    }

    window.addEventListener("hashchange", () => {
      const newHash = window.location.hash.replace("#", "")
      this.activeTab = newHash
      if (newHash === "favorites") this.fetchFavorites()
      if (newHash === "address") this.fetchAddresses()
    })
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
