<template>
  <div class="relative flex min-h-screen w-full flex-col bg-gray-50">
    <AppHeader />

    <main class="flex-grow">
      <div class="flex flex-1 w-full px-4 md:px-[2cm]">
        <!-- Sidebar -->
        <aside class="w-64 flex-shrink-0 bg-white border-r border-gray-200 p-6 hidden md:block sticky top-0 h-screen overflow-y-auto">
          <div class="flex flex-col gap-6">
            <div>
              <h2 class="text-gray-900 text-lg font-bold mb-1">Tài khoản của tôi</h2>
              <p class="text-sm text-gray-500">Quản lý thông tin cá nhân</p>
            </div>
            <div class="flex flex-col gap-1">
              <button @click="changeTab('info')"
                      :class="['flex items-center gap-3 px-4 py-3 rounded-lg group cursor-pointer transition-all',
                                activeTab === 'info' ? 'bg-yellow-50 border-l-4 border-yellow-600' : 'hover:bg-gray-50']">
                <span class="material-symbols-outlined"
                      :class="[activeTab === 'info' ? 'text-yellow-600' : 'text-gray-600']"
                      style="font-size: 20px;">person</span>
                <p :class="['text-sm font-medium', activeTab === 'info' ? 'text-yellow-600' : 'text-gray-700']">
                  Thông tin tài khoản
                </p>
              </button>

              <button @click="changeTab('orders')"
                      :class="['flex items-center gap-3 px-4 py-3 rounded-lg group cursor-pointer transition-all',
                                activeTab === 'orders' ? 'bg-yellow-50 border-l-4 border-yellow-600' : 'hover:bg-gray-50']">
                <span class="material-symbols-outlined"
                      :class="[activeTab === 'orders' ? 'text-yellow-600' : 'text-gray-600']"
                      style="font-size: 20px;">receipt_long</span>
                <p :class="['text-sm font-medium', activeTab === 'orders' ? 'text-yellow-600' : 'text-gray-700']">
                  Theo dõi đơn hàng
                </p>
              </button>

              <button @click="changeTab('wishlist')"
                      :class="['flex items-center gap-3 px-4 py-3 rounded-lg group cursor-pointer transition-all',
                                activeTab === 'wishlist' ? 'bg-yellow-50 border-l-4 border-yellow-600' : 'hover:bg-gray-50']">
                <span class="material-symbols-outlined"
                      :class="[activeTab === 'wishlist' ? 'text-yellow-600' : 'text-gray-600']"
                      style="font-size: 20px;">favorite</span>
                <p :class="['text-sm font-medium', activeTab === 'wishlist' ? 'text-yellow-600' : 'text-gray-700']">
                  Sản phẩm yêu thích
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
              <button @click="handleLogout" class="w-full flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-red-50 group transition-all text-left">
                <span class="material-symbols-outlined text-red-600 group-hover:text-red-700" style="font-size: 20px;">logout</span>
                <p class="text-sm font-medium text-red-600 group-hover:text-red-700">Đăng xuất</p>
              </button>
            </div>
          </div>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 p-6 md:p-10 bg-gray-50">
          <div class="w-full">
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

                <!-- Success/Error Messages Removed (Now using toasts) -->


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
                        <label class="text-sm font-medium text-gray-500" for="phoneInput">Số điện thoại *</label>
                      </div>
                      <div class="flex-1">
                        <input v-if="isEditingInfo" id="phoneInput" type="tel" v-model="user.soDienThoai" required
                               class="w-full px-4 py-2.5 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-yellow-500 focus:border-transparent transition"
                               placeholder="10 số (vd: 0912345678)" />
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
                                class="px-5 py-2 text-sm font-medium text-white bg-yellow-500 hover:bg-yellow-600 rounded-xl transition-colors flex items-center gap-2 shadow-sm">
                          <span class="material-symbols-outlined" style="font-size:16px">lock_reset</span>
                          Đổi mật khẩu
                        </button>
                      </div>
                    </div>

                  </div>
                </form>
              </section>

              <!-- Favorites (Wishlist) Tab -->
              <section v-if="activeTab === 'wishlist'">
                <div class="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-8">
                  <div>
                    <h1 class="text-3xl font-black text-gray-900 mb-2">Sản phẩm yêu thích ({{ filteredFavorites.length }})</h1>
                    <p class="text-gray-500 font-medium">Những sản phẩm bạn đã lưu lại để tham khảo sau</p>
                  </div>

                  <!-- Quick Filters (Admin Style) -->
                  <div v-if="favorites.length > 0" class="flex flex-wrap items-center gap-4">
                    <!-- Category Filter -->
                    <div class="relative min-w-[200px]">
                      <button @click.stop="openFavDropdown = openFavDropdown === 'category' ? null : 'category'"
                              class="w-full border border-[#C8A97E]/50 rounded-2xl pl-5 pr-10 py-3 text-sm bg-white text-left focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/20 hover:border-[#C8A97E] transition-all flex items-center justify-between shadow-sm">
                        <span class="truncate font-bold text-gray-700 uppercase tracking-wider text-[11px]">{{ favFilters.category === 'all' ? 'Tất cả danh mục' : favFilters.category }}</span>
                        <span class="material-symbols-outlined text-[20px] absolute right-3 text-[#C8A97E]">expand_more</span>
                      </button>
                      <div v-if="openFavDropdown === 'category'" class="absolute z-50 w-full mt-2 bg-white border border-[#C8A97E]/20 rounded-2xl shadow-2xl overflow-hidden animate-fade-in">
                        <div @click="favFilters.category = 'all'; openFavDropdown = null" 
                             class="px-5 py-3 text-[11px] font-black uppercase tracking-widest cursor-pointer hover:bg-[#C8A97E]/10 transition-colors border-b border-gray-50"
                             :class="favFilters.category === 'all' ? 'text-[#C8A97E] bg-[#C8A97E]/5' : 'text-gray-500'">
                          Tất cả danh mục
                        </div>
                        <div class="max-h-60 overflow-y-auto custom-scrollbar">
                          <div v-for="cat in favCategories" :key="cat" 
                               @click="favFilters.category = cat; openFavDropdown = null"
                               class="px-5 py-3 text-[11px] font-black uppercase tracking-widest hover:bg-[#C8A97E]/10 cursor-pointer transition-colors"
                               :class="favFilters.category === cat ? 'text-[#C8A97E] bg-[#C8A97E]/5' : 'text-gray-600'">
                            {{ cat }}
                          </div>
                        </div>
                      </div>
                    </div>

                    <!-- Brand Filter -->
                    <div class="relative min-w-[200px]">
                      <button @click.stop="openFavDropdown = openFavDropdown === 'brand' ? null : 'brand'"
                              class="w-full border border-[#C8A97E]/50 rounded-2xl pl-5 pr-10 py-3 text-sm bg-white text-left focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/20 hover:border-[#C8A97E] transition-all flex items-center justify-between shadow-sm">
                        <span class="truncate font-bold text-gray-700 uppercase tracking-wider text-[11px]">{{ favFilters.brand === 'all' ? 'Tất cả thương hiệu' : favFilters.brand }}</span>
                        <span class="material-symbols-outlined text-[20px] absolute right-3 text-[#C8A97E]">expand_more</span>
                      </button>
                      <div v-if="openFavDropdown === 'brand'" class="absolute z-50 w-full mt-2 bg-white border border-[#C8A97E]/20 rounded-2xl shadow-2xl overflow-hidden animate-fade-in">
                        <div @click="favFilters.brand = 'all'; openFavDropdown = null" 
                             class="px-5 py-3 text-[11px] font-black uppercase tracking-widest cursor-pointer hover:bg-[#C8A97E]/10 transition-colors border-b border-gray-50"
                             :class="favFilters.brand === 'all' ? 'text-[#C8A97E] bg-[#C8A97E]/5' : 'text-gray-500'">
                          Tất cả thương hiệu
                        </div>
                        <div class="max-h-60 overflow-y-auto custom-scrollbar">
                          <div v-for="br in favBrands" :key="br" 
                               @click="favFilters.brand = br; openFavDropdown = null"
                               class="px-5 py-3 text-[11px] font-black uppercase tracking-widest hover:bg-[#C8A97E]/10 cursor-pointer transition-colors"
                               :class="favFilters.brand === br ? 'text-[#C8A97E] bg-[#C8A97E]/5' : 'text-gray-600'">
                            {{ br }}
                          </div>
                        </div>
                      </div>
                    </div>

                    <!-- Gender Filter -->
                    <div class="relative min-w-[180px]">
                      <button @click.stop="openFavDropdown = openFavDropdown === 'gender' ? null : 'gender'"
                              class="w-full border border-[#C8A97E]/50 rounded-2xl pl-5 pr-10 py-3 text-sm bg-white text-left focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/20 hover:border-[#C8A97E] transition-all flex items-center justify-between shadow-sm">
                        <span class="truncate font-bold text-gray-700 uppercase tracking-wider text-[11px]">{{ favFilters.gender === 0 ? 'Nam' : (favFilters.gender === 1 ? 'Nữ' : (favFilters.gender === 2 ? 'Unisex' : 'Mọi giới tính')) }}</span>
                        <span class="material-symbols-outlined text-[20px] absolute right-3 text-[#C8A97E]">expand_more</span>
                      </button>
                      <div v-if="openFavDropdown === 'gender'" class="absolute z-50 w-full mt-2 bg-white border border-[#C8A97E]/20 rounded-2xl shadow-2xl overflow-hidden animate-fade-in">
                        <div @click="favFilters.gender = 'all'; openFavDropdown = null" class="px-5 py-3 text-[11px] font-black uppercase tracking-widest hover:bg-[#C8A97E]/10 cursor-pointer transition-colors border-b border-gray-50" :class="favFilters.gender === 'all' ? 'text-[#C8A97E] bg-[#C8A97E]/5' : 'text-gray-500'">Mọi giới tính</div>
                        <div @click="favFilters.gender = 0; openFavDropdown = null" class="px-5 py-3 text-[11px] font-black uppercase tracking-widest hover:bg-[#C8A97E]/10 cursor-pointer transition-colors" :class="favFilters.gender === 0 ? 'text-[#C8A97E] bg-[#C8A97E]/5' : 'text-gray-600'">Nam</div>
                        <div @click="favFilters.gender = 1; openFavDropdown = null" class="px-5 py-3 text-[11px] font-black uppercase tracking-widest hover:bg-[#C8A97E]/10 cursor-pointer transition-colors" :class="favFilters.gender === 1 ? 'text-[#C8A97E] bg-[#C8A97E]/5' : 'text-gray-600'">Nữ</div>
                        <div @click="favFilters.gender = 2; openFavDropdown = null" class="px-5 py-3 text-[11px] font-black uppercase tracking-widest hover:bg-[#C8A97E]/10 cursor-pointer transition-colors" :class="favFilters.gender === 2 ? 'text-[#C8A97E] bg-[#C8A97E]/5' : 'text-gray-600'">Unisex</div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Không có sản phẩm yêu thích -->
                <div v-if="favorites.length === 0" class="bg-white rounded-xl shadow-sm border border-gray-200 p-12 text-center mt-6">
                  <h3 class="text-lg font-semibold text-gray-900 mb-2">Chưa có sản phẩm yêu thích</h3>
                  <a href="/sanpham" class="px-6 py-2 bg-yellow-600 text-white rounded-lg inline-block mt-2 font-medium hover:bg-yellow-700 transition">Khám phá sản phẩm</a>
                </div>

                <!-- Danh sách sản phẩm yêu thích -->
                <div v-else class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                  <div v-for="fav in filteredFavorites" :key="fav.maSPYT" class="bg-white border rounded-[2rem] shadow-sm hover:shadow-xl hover:shadow-yellow-500/5 transition-all duration-300 overflow-hidden group border-gray-100 flex flex-col">
                    <div class="relative aspect-[4/5] bg-[#F7F7F7] flex items-center justify-center overflow-hidden p-4">
                      <img v-if="fav.anhChinh" :src="fav.anhChinh" :alt="fav.tenSP" class="w-full h-full object-contain mix-blend-multiply group-hover:scale-110 transition duration-700" />
                      <div v-else class="w-20 h-20 bg-gray-200 rounded-full flex items-center justify-center">
                        <span class="material-symbols-outlined text-gray-400 text-3xl">image</span>
                      </div>
                      
                      <!-- Overlay Actions -->
                      <div class="absolute inset-0 bg-black/5 opacity-0 group-hover:opacity-100 transition-opacity flex items-start justify-end p-4">
                        <button @click="toggleFavorite(fav.maSP)" 
                                class="bg-white/90 backdrop-blur-sm p-3 text-red-500 rounded-2xl shadow-xl hover:bg-red-500 hover:text-white transition-all transform hover:scale-110 active:scale-90"
                                title="Bỏ yêu thích">
                          <span class="material-symbols-outlined fill-icon text-xl">favorite</span>
                        </button>
                      </div>
                    </div>
                    
                    <div class="p-6 flex-1 flex flex-col">
                      <p class="text-[10px] text-[#C8A97E] font-black uppercase tracking-[2px] mb-2">{{ fav.thuongHieu }}</p>
                      <h3 class="font-black text-black text-sm mb-4 line-clamp-2 min-h-[40px] leading-tight">{{ fav.tenSP }}</h3>
                      
                      <div class="mt-auto pt-4 border-t border-gray-50 flex items-center justify-between">
                        <p class="text-black font-black text-base tracking-tighter">{{ fav.gia?.toLocaleString() }}₫</p>
                        <router-link :to="`/sanpham/${fav.maSP}`" class="w-10 h-10 rounded-xl bg-gray-50 flex items-center justify-center text-black hover:bg-black hover:text-white transition-all">
                          <span class="material-symbols-outlined text-xl">arrow_forward</span>
                        </router-link>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Section Khám phá thêm -->
                <div v-if="favorites.length > 0" class="mt-20 text-center py-12 border-t border-gray-100">
                   <p class="text-gray-400 text-xs italic mb-4">Hoặc bạn có thể tìm kiếm thêm nhiều phong cách mới tại cửa hàng công của chúng tôi</p>
                   <router-link to="/sanpham" class="inline-flex items-center gap-3 text-black font-black uppercase tracking-[3px] text-[11px] hover:text-[#C8A97E] transition-all group">
                        KHÁM PHÁ THÊM SẢN PHẨM
                        <span class="material-symbols-outlined text-lg group-hover:translate-x-2 transition-transform">east</span>
                   </router-link>
                </div>
              </section>

              <!-- Orders Tab -->
              <section v-if="activeTab === 'orders'" class="space-y-8">
                <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
                  <div>
                    <h1 class="text-3xl font-[900] text-gray-900 mb-2">Theo dõi đơn hàng ({{ orders.length }})</h1>
                    <p class="text-gray-500 font-medium">Theo dõi hành trình và xem lại lịch sử mua sắm của bạn</p>
                  </div>
                </div>

                <!-- 1. Latest Order -->
                <div v-if="latestOrder" class="bg-white rounded-[2.5rem] shadow-2xl border border-gray-100 overflow-hidden transform transition-all hover:shadow-yellow-500/5">
                  <div class="px-8 py-6 border-b border-gray-100 bg-gray-50/50 flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <div class="flex items-center gap-4">
                      <div class="w-12 h-12 bg-yellow-500 rounded-xl flex items-center justify-center text-white shadow-lg">
                        <span class="material-symbols-outlined text-2xl font-bold">local_shipping</span>
                      </div>
                      <div>
                        <h3 class="text-lg font-black text-gray-900">Đơn hàng mới nhất: #{{ latestOrder.maDH }}</h3>
                      </div>
                    </div>
                    <div class="flex items-center gap-3">
                      <span v-if="latestOrder.trangThaiDH === 5" class="bg-red-50 text-red-600 px-5 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest border border-red-100">Đã hủy</span>
                      <button @click="$router.push(`/profile/orders/${latestOrder.maDH}`)" class="px-6 py-3 bg-gray-900 text-white rounded-xl text-xs font-black uppercase tracking-widest hover:bg-yellow-600 transition-all shadow-lg active:scale-95">Chi tiết</button>
                    </div>
                  </div>

                  <div class="p-8 space-y-8">
                    <!-- Progress Stepper -->
                      <div v-if="latestOrder.trangThaiDH !== 5 && latestOrder.trangThaiDH !== 7 && latestOrder.trangThaiDH !== 8" class="relative py-4">
                        <div class="flex items-center justify-between w-full relative z-10 px-4">
                          <div v-for="(step, index) in ['Chờ xác nhận', 'Đã xác nhận', 'Đang giao', 'Đã giao', 'Hoàn tất', 'Đã đánh giá']" :key="index" class="flex flex-col items-center">
                            <div :class="['w-10 h-10 rounded-xl flex items-center justify-center border-2 transition-all duration-700', 
                                          latestOrder.trangThaiDH >= index ? 'bg-yellow-500 border-yellow-200 text-white shadow-lg scale-110' : 
                                          (latestOrder.trangThaiDH === 6 && index === 5) ? 'bg-yellow-500 border-yellow-200 text-white shadow-lg scale-110' :
                                          'bg-white border-gray-100 text-gray-300']">
                              <span v-if="latestOrder.trangThaiDH > index || (latestOrder.trangThaiDH === 6 && index < 5)" class="material-symbols-outlined text-xl font-bold">check</span>
                              <span v-else class="text-xs font-bold">{{ index + 1 }}</span>
                            </div>
                            <span :class="['mt-3 text-[9px] font-bold uppercase tracking-wider text-center w-20 transition-colors duration-500', 
                                          (latestOrder.trangThaiDH >= index || (latestOrder.trangThaiDH === 6 && index === 5)) ? 'text-yellow-600' : 'text-gray-400']">
                              {{ step }}
                            </span>
                          </div>
                        </div>
                        <div class="absolute top-9 left-0 w-full px-20 -z-0">
                          <div class="w-full h-1 bg-gray-50 rounded-full overflow-hidden">
                            <div class="h-full bg-gradient-to-r from-yellow-400 to-yellow-600 transition-all duration-1000 ease-out rounded-full" 
                                 :style="{ width: (latestOrder.trangThaiDH === 6 ? 100 : Math.min(latestOrder.trangThaiDH * 20, 100)) + '%' }"></div>
                          </div>
                        </div>
                      </div>

                      <!-- Special Banner for CHO_THANH_TOAN (7) or LOI_THANH_TOAN (8) -->
                      <div v-else-if="latestOrder.trangThaiDH === 7 || latestOrder.trangThaiDH === 8" class="relative py-2">
                        <div :class="['rounded-3xl p-6 border flex items-center justify-between gap-6 transition-all shadow-sm',
                                      latestOrder.trangThaiDH === 7 ? 'bg-cyan-50 border-cyan-100' : 'bg-orange-50 border-orange-100']">
                          <div class="flex items-center gap-5">
                            <div :class="['w-14 h-14 rounded-2xl flex items-center justify-center text-white shrink-0 shadow-lg animate-pulse',
                                          latestOrder.trangThaiDH === 7 ? 'bg-cyan-500' : 'bg-orange-500']">
                              <span class="material-symbols-outlined text-3xl font-bold">{{ latestOrder.trangThaiDH === 7 ? 'pending' : 'error' }}</span>
                            </div>
                            <div>
                              <p :class="['font-black uppercase tracking-widest text-sm mb-1',
                                          latestOrder.trangThaiDH === 7 ? 'text-cyan-700' : 'text-orange-700']">
                                {{ latestOrder.trangThaiDH === 7 ? 'Đang chờ thanh toán qua PayOS' : 'Thanh toán không thành công' }}
                              </p>
                              <p :class="['text-xs font-medium italic opacity-70',
                                          latestOrder.trangThaiDH === 7 ? 'text-cyan-600' : 'text-orange-600']">
                                {{ latestOrder.trangThaiDH === 7 ? 'Đơn hàng sẽ tự động hủy nếu không hoàn tất thanh toán trong 5 phút.' : (latestOrder.lyDoHuy || 'Đã có lỗi xảy ra trong quá trình xử lý giao dịch của bạn.') }}
                              </p>
                            </div>
                          </div>
                          <a :href="'http://localhost:8080/payment/payos/create?orderId=' + latestOrder.maDH" 
                             class="px-8 py-3.5 bg-gray-900 text-white rounded-xl text-[10px] font-black uppercase tracking-[0.2em] hover:bg-yellow-600 transition-all shadow-xl active:scale-95 flex items-center gap-2 shrink-0">
                            <span class="material-symbols-outlined text-sm font-bold">qr_code_2</span>
                            Thanh toán ngay
                          </a>
                        </div>
                      </div>

                    <!-- Detailed Order Content (New List View) -->
                    <div class="bg-gray-50/50 rounded-3xl p-6 border border-gray-100 space-y-4 mx-1">
                      <div v-for="item in latestOrder.chiTietList" :key="item.maCT" class="flex items-center gap-4 bg-white/50 p-3 rounded-2xl border border-gray-50 shadow-sm">
                        <!-- Image -->
                        <div class="w-16 h-16 bg-white rounded-xl border border-gray-100 overflow-hidden shrink-0">
                          <img :src="getBestImage(item)" 
                               class="w-full h-full object-cover"
                               @error="e => e.target.src='/img/placeholder.png'">
                        </div>
                        
                        <!-- Info -->
                        <div class="flex-1 min-w-0">
                          <p class="text-[11px] font-[1000] text-black truncate uppercase">{{ item.sanPhamChiTiet?.sanPham?.tenSP }}</p>
                          <div class="flex items-center gap-3 mt-1">
                            <span class="text-[9px] font-black text-black uppercase tracking-widest bg-gray-100 px-2 py-0.5 rounded-md border border-gray-200">
                              {{ item.sanPhamChiTiet?.sizeSP?.tenSize || 'N/A' }} 
                              - {{ item.sanPhamChiTiet?.mauSacSP?.tenMau || 'N/A' }}
                            </span>
                            <span class="text-[9px] font-black text-black uppercase tracking-widest">SL: x{{ item.soLuong }}</span>
                          </div>
                        </div>

                        <!-- Price -->
                        <div class="text-right">
                          <p class="text-[9px] font-black text-black uppercase tracking-widest mb-0.5">Thành tiền</p>
                          <p class="text-sm font-[1000] text-black tracking-tight">{{ (item.donGia * item.soLuong).toLocaleString() }}<span class="text-[10px] ml-0.5">₫</span></p>
                        </div>
                      </div>

                      <!-- Order Summary in Latest Card (New) -->
                      <div class="pt-4 border-t border-gray-100 px-2 mt-4 space-y-2">
                        <div class="flex justify-between items-center text-xs text-gray-500">
                          <span class="font-bold">Tạm tính:</span>
                          <span class="font-black text-black">{{ latestOrder.chiTietList.reduce((acc, i) => acc + i.donGia * i.soLuong, 0).toLocaleString() }}₫</span>
                        </div>
                        <div v-if="latestOrder.giamGia > 0" class="flex justify-between items-center text-xs text-red-500">
                          <span class="font-bold font-black italic">Chiết khấu (Voucher):</span>
                          <span class="font-black">-{{ latestOrder.giamGia.toLocaleString() }}₫</span>
                        </div>
                        <div class="flex justify-between items-center text-xs text-gray-500">
                          <span class="font-bold">Phí vận chuyển:</span>
                          <span class="font-black" :class="latestOrder.phiShip > 0 ? 'text-black' : 'text-green-600'">
                            {{ latestOrder.phiShip > 0 ? (latestOrder.phiShip.toLocaleString() + '₫') : 'Free' }}
                          </span>
                        </div>
                        <div class="flex justify-between items-center pt-2 border-t border-dashed border-gray-200">
                          <span class="text-sm font-black text-black uppercase tracking-widest">Tổng thanh toán:</span>
                          <span class="text-xl font-[1000] text-yellow-700 tracking-tighter">{{ latestOrder.tongTien?.toLocaleString() }}₫</span>
                        </div>
                      </div>

                      <!-- Order Time Info and Repurchase Action -->
                      <div class="pt-4 border-t border-gray-100 px-2 mt-2 flex flex-wrap items-center justify-between gap-y-4">
                        <div class="flex flex-wrap items-center gap-x-8 gap-y-2 opacity-50">
                          <div class="flex items-center gap-2">
                            <span class="text-[9px] font-black text-black uppercase tracking-widest">Ngày đặt:</span>
                            <span class="text-[10px] font-black text-black italic">{{ new Date(latestOrder.ngayDat).toLocaleDateString('vi-VN') }}</span>
                          </div>
                          <div class="flex items-center gap-2">
                            <span class="text-[9px] font-black text-black uppercase tracking-widest">Giờ đặt:</span>
                            <span class="text-[10px] font-black text-black italic">{{ new Date(latestOrder.ngayDat).toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' }) }}</span>
                          </div>
                        </div>
                        
                        <!-- Nút Mua Lại (Chỉ khi 4 hoặc 6) -->
                        <button v-if="latestOrder.trangThaiDH === 4 || latestOrder.trangThaiDH === 6" @click="muaLai(latestOrder)" 
                                class="px-5 py-2.5 bg-red-50 text-red-600 border border-red-100 rounded-xl font-bold text-[10px] uppercase tracking-wider hover:bg-red-600 hover:text-white transition-all transform active:scale-95 flex items-center gap-2 ml-auto shadow-sm">
                          <span class="material-symbols-outlined text-sm font-bold">shopping_cart</span> Mua lại
                        </button>
                      </div>
                    </div>

                    <!-- Sleeker Action Zone (Aligned right & moved up) -->
                    <div class="flex flex-wrap items-center justify-end gap-3 pt-2">
                      <!-- Nút Hủy (Chỉ khi 0) -->
                      <button v-if="latestOrder.trangThaiDH === 0" @click="cancelOrder(latestOrder.maDH)" 
                              class="px-5 py-2.5 bg-red-50 text-red-600 border border-red-100 rounded-xl font-bold text-[10px] uppercase tracking-wider hover:bg-red-600 hover:text-white transition-all transform active:scale-95 flex items-center gap-2">
                        <span class="material-symbols-outlined text-sm font-bold">cancel</span> Hủy đơn
                      </button>



                      <!-- Nút Đã nhận (Chỉ khi 3 - Đã giao) -->
                      <button v-if="!latestOrder.khachBaoChuaNhan && latestOrder.trangThaiDH === 3" @click="updateOrderStatus(latestOrder.maDH, 4)" 
                              class="px-5 py-2.5 bg-yellow-500 text-white rounded-xl font-bold text-[10px] uppercase tracking-wider hover:bg-yellow-600 transition-all shadow-md shadow-yellow-500/20 transform active:scale-95 flex items-center gap-2">
                        <span class="material-symbols-outlined text-sm font-bold">check_circle</span> Đã nhận hàng
                      </button>

                      <!-- Nút Chưa nhận (Chỉ khi 3 - Đã giao) -->
                      <button v-if="!latestOrder.khachBaoChuaNhan && latestOrder.trangThaiDH === 3" @click="openReportModal(latestOrder.maDH)" 
                              class="px-5 py-2.5 bg-white border border-gray-100 text-gray-400 rounded-xl font-bold text-[10px] uppercase tracking-wider hover:border-red-500 hover:text-red-500 transition-all transform active:scale-95 flex items-center gap-2">
                        <span class="material-symbols-outlined text-sm font-bold">feedback</span> Chưa nhận hàng
                      </button>

                      <div v-if="latestOrder.khachBaoChuaNhan" class="flex items-center gap-3 bg-orange-50 px-4 py-2 rounded-xl border border-orange-100">
                        <div class="w-8 h-8 bg-orange-500 rounded-lg flex items-center justify-center text-white animate-pulse">
                          <span class="material-symbols-outlined text-sm font-black">warning</span>
                        </div>
                        <p class="text-[10px] font-black text-orange-700 uppercase tracking-widest">Đang chờ xử lý khiếu nại</p>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- 2. Integrated History Frame -->
                <div class="bg-white rounded-[2.5rem] border border-blue-950/20 p-8 space-y-8 shadow-sm mt-8">
                  <!-- Control Row: Search & Filters -->
                  <div class="flex flex-col lg:flex-row gap-4 items-center justify-between pb-6 border-b border-gray-50">
                    <!-- Search Input -->
                    <div class="relative w-full lg:max-w-md group">
                      <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 group-focus-within:text-black transition-colors">search</span>
                      <input v-model="searchQuery" type="text" placeholder="Tìm kiếm đơn hàng..." 
                             class="w-full pl-12 pr-4 py-3 bg-gray-50 border border-gray-100 rounded-xl focus:ring-4 focus:ring-blue-950/5 focus:border-blue-950 outline-none transition-all text-sm font-black text-black placeholder:text-gray-400">
                    </div>
                    
                    <div class="flex gap-3 w-full lg:w-auto">
                      <!-- Status Dropdown -->
                      <div class="relative min-w-[160px]">
                        <select v-model="orderStatus" 
                                class="w-full appearance-none pl-4 pr-10 py-3 bg-white border border-gray-200 rounded-xl text-[10px] font-black text-black uppercase tracking-widest focus:ring-2 focus:ring-blue-950/20 focus:border-blue-950 outline-none cursor-pointer">
                          <option value="all">Tất cả trạng thái</option>
                          <option value="0">Chờ xác nhận</option>
                          <option value="1">Đã xác nhận</option>
                          <option value="2">Đang giao</option>
                          <option value="3">Đã giao</option>
                          <option value="4">Hoàn tất</option>
                          <option value="6">Đã đánh giá</option>
                          <option value="5">Đã hủy</option>
                        </select>
                        <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none">expand_more</span>
                      </div>

                      <!-- Time Dropdown -->
                      <div class="relative min-w-[140px]">
                        <select v-model="timeFilter" 
                                class="w-full appearance-none pl-4 pr-10 py-3 bg-white border border-gray-200 rounded-xl text-[10px] font-black text-black uppercase tracking-widest focus:ring-2 focus:ring-blue-950/20 focus:border-blue-950 outline-none cursor-pointer">
                          <option value="all">Mọi thời gian</option>
                          <option value="week">Tuần hiện tại</option>
                          <option value="month">Tháng hiện tại</option>
                          <option value="year">Năm hiện tại</option>
                        </select>
                        <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none">expand_more</span>
                      </div>
                    </div>
                  </div>

                  <!-- Orders List (Integrated Row View) -->
                  <div class="space-y-4">
                    <div v-for="order in filteredOrders" :key="order.maDH" 
                         class="bg-white rounded-2xl border border-gray-100 p-6 flex flex-col md:flex-row md:items-center justify-between gap-6 hover:border-blue-950/30 transition-all hover:bg-gray-50/30">
                      
                      <div class="flex flex-col md:flex-row gap-6 items-center flex-1 min-w-0">
                        <!-- Order Thumbnail -->
                        <div class="w-16 h-16 bg-white rounded-xl border border-gray-100 overflow-hidden shrink-0 shadow-sm">
                          <img :src="getBestImage(order.chiTietList?.[0])" 
                               class="w-full h-full object-cover"
                               @error="e => e.target.src='/img/placeholder.png'">
                        </div>

                        <!-- Order ID Badge -->
                        <div class="w-16 h-16 bg-gray-900 rounded-2xl flex flex-col items-center justify-center shrink-0 shadow-lg">
                          <p class="text-[8px] font-black text-gray-400 uppercase leading-none mb-1">Đơn hàng</p>
                          <p class="text-xl font-black text-white leading-none">#{{ order.maDH }}</p>
                        </div>

                        <!-- Order Info Summary -->
                        <div class="flex-1 min-w-0 space-y-1">
                          <div class="flex items-center gap-3">
                            <span :class="['px-3 py-1 rounded-lg text-[9px] font-black uppercase border', 
                                          order.trangThaiDH === 5 ? 'bg-red-50 text-red-600 border-red-100' : 
                                          order.trangThaiDH === 8 ? 'bg-orange-50 text-orange-600 border-orange-100' : 
                                          order.trangThaiDH === 7 ? 'bg-cyan-50 text-cyan-600 border-cyan-100' : 
                                          order.trangThaiDH === 4 ? 'bg-green-50 text-green-600 border-green-100' : 
                                          order.trangThaiDH === 0 ? 'bg-yellow-50 text-yellow-600 border-yellow-100' : 'bg-blue-50 text-blue-600 border-blue-100']">
                              {{ 
                                order.trangThaiDH === 6 ? 'Đã đánh giá' : 
                                (order.trangThaiDH === 5 ? 'Đã hủy' : 
                                (order.trangThaiDH === 8 ? 'Lỗi thanh toán' : 
                                (order.trangThaiDH === 7 ? 'Chờ thanh toán' : 
                                (order.trangThaiDH === 4 ? 'Hoàn tất' : 
                                (order.trangThaiDH === 0 ? 'Chờ xác nhận' : 
                                (order.trangThaiDH === 3 ? 'Đã giao' : 
                                (order.trangThaiDH === 1 ? 'Đã nhận' : 'Đang giao'))))))) 
                              }}
                            </span>
                            <span class="text-xs font-black text-black">{{ new Date(order.ngayDat).toLocaleDateString('vi-VN') }}</span>
                          </div>
                          <p class="text-sm font-black text-black truncate">
                            {{ order.chiTietList?.[0]?.sanPhamChiTiet?.sanPham?.tenSP || 'Đơn hàng mới' }}
                            <span v-if="order.chiTietList?.length > 1" class="text-gray-400"> +{{ order.chiTietList.length - 1 }} sản phẩm khác</span>
                          </p>
                          <p class="text-lg font-[1000] text-black tracking-tighter">{{ order.tongTien?.toLocaleString() }}₫</p>
                        </div>
                      </div>

                      <!-- Row Action -->
                      <div class="shrink-0 flex items-center gap-2">
                        <button v-if="order.trangThaiDH === 4 || order.trangThaiDH === 6" @click="muaLai(order)" class="whitespace-nowrap px-6 py-3 bg-red-50 border border-red-100 text-red-600 hover:bg-red-600 hover:text-white hover:border-red-600 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all active:scale-95 shadow-sm">
                          Mua lại
                        </button>
                        <button @click="$router.push(`/profile/orders/${order.maDH}`)" class="whitespace-nowrap px-6 py-3 bg-white border border-gray-200 text-black hover:bg-black hover:text-white hover:border-black rounded-xl text-[10px] font-black uppercase tracking-widest transition-all active:scale-95 shadow-sm">
                          Xem chi tiết
                        </button>
                      </div>
                    </div>

                    <!-- Empty State -->
                    <div v-if="filteredOrders.length === 0" class="py-20 text-center">
                      <span class="material-symbols-outlined text-gray-200 text-6xl mb-4">receipt_long</span>
                      <p class="text-xs font-black text-black uppercase tracking-widest">Không tìm thấy đơn hàng nào phù hợp</p>
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

            </div><!-- end Content Tabs -->
          </div>
        </div>
      </div>
    </main>

    <AppFooter />

    <!-- Popups moved to root for full overlay coverage -->
    
    <!-- Change Password Popup -->
    <div v-if="showPasswordModal" class="fixed inset-0 bg-black/60 backdrop-blur-md flex items-center justify-center z-[10000] p-4 animate-fade-in">
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
            <div class="relative">
              <input :type="showCurrentPassword ? 'text' : 'password'" v-model="passwordForm.currentPassword" required
                     class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-600 focus:border-transparent pr-12"
                     placeholder="Nhập mật khẩu hiện tại" />
              <button type="button" @click="showCurrentPassword = !showCurrentPassword"
                      class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600 transition-colors flex items-center">
                <span class="material-symbols-outlined" style="font-size: 20px;">
                  {{ showCurrentPassword ? 'visibility_off' : 'visibility' }}
                </span>
              </button>
            </div>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Mật khẩu mới</label>
            <div class="relative">
              <input :type="showNewPassword ? 'text' : 'password'" v-model="passwordForm.newPassword" required minlength="4"
                     class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-600 focus:border-transparent pr-12"
                     placeholder="Ít nhất 4 ký tự" />
              <button type="button" @click="showNewPassword = !showNewPassword"
                      class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600 transition-colors flex items-center">
                <span class="material-symbols-outlined" style="font-size: 20px;">
                  {{ showNewPassword ? 'visibility_off' : 'visibility' }}
                </span>
              </button>
            </div>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Xác nhận mật khẩu mới</label>
            <div class="relative">
              <input :type="showConfirmPassword ? 'text' : 'password'" v-model="passwordForm.confirmPassword" required minlength="4"
                     class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-yellow-600 focus:border-transparent pr-12"
                     placeholder="Nhập lại mật khẩu mới" />
              <button type="button" @click="showConfirmPassword = !showConfirmPassword"
                      class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600 transition-colors flex items-center">
                <span class="material-symbols-outlined" style="font-size: 20px;">
                  {{ showConfirmPassword ? 'visibility_off' : 'visibility' }}
                </span>
              </button>
            </div>
          </div>

          <div class="flex justify-end gap-3 mt-6">
            <button type="button" @click="showPasswordModal = false; showCurrentPassword = false; showNewPassword = false; showConfirmPassword = false"
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

    <!-- Add Address Popup -->
    <div v-if="showAddAddress" class="fixed inset-0 bg-black/60 backdrop-blur-md flex items-center justify-center z-[10000] p-4 animate-fade-in">
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

    <!-- Report Items Modal -->
    <div v-if="showReportModal" class="fixed inset-0 bg-black/60 backdrop-blur-md flex items-center justify-center z-[10000] p-4 animate-fade-in">
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
      showCurrentPassword: false,
      showNewPassword: false,
      showConfirmPassword: false,
      isEditingInfo: false,
      avatarPreview: null,
      userSnapshot: null,
      showAddAddress: false,
      addresses: [],
      orders: [],
      favorites: [],
      favFilters: {
        category: 'all',
        brand: 'all',
        gender: 'all'
      },
      favCategories: [],
      favBrands: [],
      openFavDropdown: null, 
      orderStatus: "all",
      showReportModal: false,
      reportOrderId: null,
      reportData: {
        reason: '',
        description: ''
      },
      searchQuery: '',
      timeFilter: 'all',
      selectedOrder: null,
      showOrderDetailModal: false,
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
      let filtered = this.orders;

      // Filter by status (exclude cancelled from stepper but show in list if selected)
      if (this.orderStatus !== "all") {
        filtered = filtered.filter(
            order => order.trangThaiDH == this.orderStatus
        )
      } else {
        // By default show everything in the list
      }

      // Search by Order ID, Product Name, Brand, Category
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase();
        filtered = filtered.filter(order => {
          // Check matching order ID
          if (order.maDH.toString().includes(query)) return true;

          // Check matching product details inside order
          if (order.chiTietList) {
            return order.chiTietList.some(item => {
              const sanPham = item.sanPhamChiTiet?.sanPham;
              if (!sanPham) return false;
              
              const brandName = sanPham.thuongHieu?.tenTH?.toLowerCase() || '';
              const categoryName = sanPham.loaiSanPham?.tenLoai?.toLowerCase() || '';
              const productName = sanPham.tenSP?.toLowerCase() || '';
              
              return brandName.includes(query) || 
                     categoryName.includes(query) || 
                     productName.includes(query);
            });
          }
          return false;
        });
      }

      // Filter by time
      if (this.timeFilter !== 'all') {
        const now = new Date();
        filtered = filtered.filter(order => {
          const orderDate = new Date(order.ngayDat);
          if (this.timeFilter === 'week') {
            const lastWeek = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
            return orderDate >= lastWeek;
          } else if (this.timeFilter === 'month') {
            const lastMonth = new Date(now.getFullYear(), now.getMonth() - 1, now.getDate());
            return orderDate >= lastMonth;
          } else if (this.timeFilter === 'year') {
            const lastYear = new Date(now.getFullYear() - 1, now.getMonth(), now.getDate());
            return orderDate >= lastYear;
          }
          return true;
        });
      }

      return filtered;
    },
    latestOrder() {
      return this.orders.length > 0 ? this.orders[0] : null;
    },
    filteredFavorites() {
      return this.favorites.filter(fav => {
        const matchesCat = this.favFilters.category === 'all' || fav.category === this.favFilters.category;
        const matchesBrand = this.favFilters.brand === 'all' || fav.thuongHieu === this.favFilters.brand;
        const matchesGender = this.favFilters.gender === 'all' || fav.gioiTinh === this.favFilters.gender;
        return matchesCat && matchesBrand && matchesGender;
      });
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
      
      if (tab === "wishlist") {
        this.fetchFavorites()
      }
    },

    viewOrderDetails(order) {
      this.selectedOrder = order
      this.showOrderDetailModal = true
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

      const phoneRegex = /^(0)(3|5|7|8|9)[0-9]{8}$/;
      if (!this.user.soDienThoai || !phoneRegex.test(this.user.soDienThoai)) {
        window.$toast.error('Số điện thoại không hợp lệ. Vui lòng nhập đúng 10 số (vd: 0912345678).');
        this.isUpdating = false;
        return;
      }

      try {
        const formData = new FormData()
        formData.append('hoTen', this.user.hoTen)
        if (this.user.soDienThoai) formData.append('soDienThoai', this.user.soDienThoai)
        if (this.$refs.avatarInput && this.$refs.avatarInput.files[0]) {
          formData.append('avatar', this.$refs.avatarInput.files[0])
        }

        const response = await axios.post('/profile/update', formData, {
          headers: { 'Content-Type': 'multipart/form-data' }
        })

        if (response.data.success) {
          window.$toast.success('Cập nhật thông tin thành công!')
          if (response.data.avatar) this.user.avatar = response.data.avatar
          if (response.data.hoTen) this.user.hoTen = response.data.hoTen
          this.isEditingInfo = false
          this.avatarPreview = null
          this.userSnapshot = null
        } else {
          window.$toast.error(response.data.message || 'Cập nhật thất bại')
        }
      } catch (err) {
        console.error('Error updating profile:', err)
        window.$toast.error('Có lỗi xảy ra khi cập nhật thông tin')
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
          window.$toast.success('Đổi mật khẩu thành công!')
          this.passwordForm = {
            currentPassword: '',
            newPassword: '',
            confirmPassword: ''
          }
          this.showCurrentPassword = false
          this.showNewPassword = false
          this.showConfirmPassword = false
          setTimeout(() => {
            this.showPasswordModal = false
          }, 1500)
        } else {
          window.$toast.error(response.data.message || 'Đổi mật khẩu thất bại')
        }
      } catch (err) {
        console.error('Error changing password:', err)
        window.$toast.error(err.response?.data?.message || 'Có lỗi xảy ra khi đổi mật khẩu')
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
        window.$alert("Vui lòng điền đầy đủ các thông tin bắt buộc!", "Thông báo");
        return;
      }

      const phoneRegex = /^(0)(3|5|7|8|9)[0-9]{8}$/;
      if (!phoneRegex.test(this.newAddress.phone)) {
        window.$alert("Số điện thoại không hợp lệ. Vui lòng nhập đúng 10 số chuẩn Việt Nam (vd: 0912345678)!", "Thông báo");
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
        window.$toast.success("Đã thêm địa chỉ mới!");
      } catch (err) {
        console.error("Save address error", err)
        window.$toast.error("Lỗi khi thêm địa chỉ!");
      }
    },

    async setDefaultAddress(id) {
      try {
        const formData = new FormData()
        formData.append("id", id)
        await axios.post("/profile/address/set-default", formData)
        this.fetchAddresses()
        window.$toast.success("Đã đặt địa chỉ mặc định!");
      } catch (err) {
        console.error("Set default address error", err)
        window.$toast.error("Lỗi khi đặt địa chỉ mặc định!");
      }
    },

    async deleteAddress(id) {
      const ok = await window.$confirm("Bạn có chắc chắn muốn xóa địa chỉ này?")
      if (!ok) return;
      try {
        const formData = new FormData()
        formData.append("id", id)
        await axios.post("/profile/address/delete", formData)
        this.fetchAddresses()
        window.$toast.success("Đã xóa địa chỉ!");
      } catch (err) {
        console.error("Delete address error", err)
        window.$toast.error("Lỗi khi xóa địa chỉ!");
      }
    },

    async fetchOrders() {
      try {
        const res = await axios.get("/orders/my", {
          withCredentials: true
        })
        this.orders = res.data
      } catch (err) {
        console.error("Error loading orders", err)
      }
    },

    async cancelOrder(orderId) {
      const ok = await window.$confirm('Bạn có chắc chắn muốn huỷ đơn hàng này?')
      if (!ok) return;
      try {
        await axios.put(
            `/orders/update-status/${orderId}`,
            null,
            {
              params: { status: 5, reason: "Khách hàng hủy đơn" },
              withCredentials: true
            }
        )
        this.fetchOrders()
      } catch (err) {
        console.error("Cancel order error", err)
      }
    },

    async muaLai(order) {
      if (!order.chiTietList || order.chiTietList.length === 0) return;
      
      try {
        let addedCount = 0;
        let failCount = 0;
        
        for (const item of order.chiTietList) {
          const params = {
             productId: item.sanPhamChiTiet.sanPham.maSP,
             quantity: item.soLuong,
             variantId: item.sanPhamChiTiet.maBienThe
          };
          try {
            const res = await axios.post('/cart/add-product', null, { params });
            if(res.data.success) {
              addedCount++;
            } else {
               failCount++;
            }
          } catch(e) {
             failCount++;
          }
        }
        
        if (addedCount > 0) {
           window.$toast.success(`Đã thêm lại ${addedCount} sản phẩm vào giỏ hàng!`);
           if (window.refreshCartCount) window.refreshCartCount();
           setTimeout(() => {
             this.$router.push('/cart');
           }, 500);
        }
        if (failCount > 0) {
           window.$toast.warning(`Không thể thêm ${failCount} sản phẩm (có thể đã hết hàng).`);
        }
      } catch (err) {
         console.error('Error repurchasing', err);
         window.$toast.error('Có lỗi xảy ra khi thêm lại giỏ hàng');
      }
    },

    async updateOrderStatus(orderId, status) {
      try {
        await axios.put(
            `/orders/update-status/${orderId}`,
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
        const res = await axios.get("/favorites", {
          withCredentials: true
        })
        this.favorites = res.data
        
        // 2. Fetch all system categories for the filter
        try {
          const catRes = await axios.get("/categories")
          this.favCategories = catRes.data.map(c => c.tenLoai).sort();
        } catch (catErr) {
          console.warn("Failed to load all categories, using fallback from favorites", catErr);
          this.favCategories = [...new Set(this.favorites.map(f => f.category).filter(Boolean))].sort()
        }

        // 3. Fetch all system brands for the filter
        try {
          const brandRes = await axios.get("/sanpham", { params: { size: 1 } })
          if (brandRes.data?.brands) {
            this.favBrands = brandRes.data.brands.map(b => b.tenTH).sort();
          }
        } catch (brandErr) {
          console.warn("Failed to load all brands, using fallback from favorites", brandErr);
          this.favBrands = [...new Set(this.favorites.map(f => f.thuongHieu).filter(Boolean))].sort()
        }
      } catch (err) {
        console.error("Error loading favorites", err)
      }
    },

    async toggleFavorite(maSP) {
      try {
        await axios.post(`/favorites/toggle`, null, {
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
          `/orders/${this.reportOrderId}/report-undelivered`,
          null,
          {
            params: { 
              reason: this.reportData.reason,
              description: this.reportData.description
            },
            withCredentials: true
          }
        )
        window.$toast.success('Đã gửi báo cáo cho Admin!')
        this.closeReportModal()
        this.fetchOrders()
      } catch (err) {
        console.error('Submit report error', err)
        window.$toast.error((err.response?.data?.message || 'Không thể gửi báo cáo'))
      }
    },
    
    async handleLogout() {
      try {
        console.log('🔴 Starting logout process in Profile...')
        
        // 1. Invalidate local session
        this.user = { hoTen: '', email: '', soDienThoai: '', avatar: null }
        
        // 2. Call logout function
        await axios.post('/auth/logout', null, { withCredentials: true })
        
        // 3. Force navigate to home
        window.location.href = '/'
        
      } catch (error) {
        console.error('🔴 Logout failed:', error)
        // Force reload even if error
        window.location.href = '/'
      }
    },

    getBestImage(item) {
      if (!item) return '/img/placeholder.png';
      const spct = item.sanPhamChiTiet;
      const sp = spct?.sanPham;
      
      // Ưu tiên anhChinh vì anhBienThe (Gucci) trên DB đang bị lỗi 404
      let url = sp?.anhChinh || spct?.anhBienThe || sp?.mainImage || item.anh;
      
      if (!url) return '/img/placeholder.png';
      
      // Fix Gucci dead link by forcing anhChinh if the variant has it
      if (url.includes('media.gucci.com') && sp?.anhChinh) {
        url = sp.anhChinh;
      }

      if (url.startsWith('http')) return url;
      return `/api/img/${url}`;
    },

    closeFavDropdowns() {
      this.openFavDropdown = null
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

    window.addEventListener("click", this.closeFavDropdowns)
  },

  beforeUnmount() {
    window.removeEventListener("click", this.closeFavDropdowns)
  },
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
