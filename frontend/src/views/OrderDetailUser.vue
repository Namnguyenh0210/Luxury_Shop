<template>
  <div class="min-h-screen bg-[#f5f4f0]">
    <AppHeader />

    <!-- Loading -->
    <div v-if="loading" class="flex flex-col items-center justify-center min-h-[60vh]">
      <div class="w-14 h-14 border-4 border-yellow-600 border-t-transparent rounded-full animate-spin mb-4"></div>
      <p class="text-gray-500 font-medium">Đang tải chi tiết đơn hàng...</p>
    </div>

    <!-- Content -->
    <div v-else-if="order" class="max-w-5xl mx-auto px-4 py-10 space-y-8">

      <!-- Top bar -->
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <button @click="$router.back()" class="flex items-center gap-2 text-sm font-bold text-gray-600 hover:text-yellow-700 transition-colors group">
          <span class="material-symbols-outlined text-[20px] group-hover:-translate-x-1 transition-transform">arrow_back</span>
          Quay lại đơn hàng
        </button>
        <div class="flex items-center gap-3">
          <span class="text-xs text-gray-400 font-bold uppercase tracking-widest">Trạng thái:</span>
          <span class="px-4 py-1.5 rounded-full text-xs font-black uppercase tracking-widest shadow-sm" :class="statusStyle(order.trangThaiDH).badge">
            {{ statusStyle(order.trangThaiDH).label }}
          </span>
        </div>
      </div>

      <!-- Order Headline with Stepper -->
      <div class="bg-white rounded-3xl border border-gray-100 shadow-sm p-8 flex flex-col md:flex-row md:items-center justify-between gap-6">
        <div class="flex items-center gap-5 shrink-0">
          <div class="w-16 h-16 rounded-2xl flex items-center justify-center shadow-lg" :class="statusStyle(order.trangThaiDH).iconBg">
            <span class="material-symbols-outlined text-3xl text-white">receipt_long</span>
          </div>
          <div>
            <p class="text-xs font-black text-gray-400 uppercase tracking-[0.25em] mb-1">Chi tiết đơn hàng</p>
            <h1 class="text-3xl font-black text-gray-900 italic">#{{ order.maDH }}</h1>
            <p class="text-xs text-gray-400 mt-1">Đặt lúc {{ formatDateTime(order.ngayDat) }}</p>
          </div>
        </div>

        <!-- Progress Stepper -->
        <div v-if="order.trangThaiDH !== 5 && order.trangThaiDH !== 7 && order.trangThaiDH !== 8" class="flex-1 max-w-lg">
          <div class="relative flex items-start justify-between">
            <div class="absolute left-0 right-0 h-[2px] bg-gray-100 rounded-full" style="top: 18px; margin-left: 18px; margin-right: 18px;">
              <div class="h-full bg-gradient-to-r from-yellow-400 to-yellow-600 rounded-full transition-all duration-700"
                   :style="{ width: stepperWidth + '%' }"></div>
            </div>
            <div v-for="(step, i) in steps" :key="i" class="relative z-10 flex flex-col items-center gap-2" style="flex: 1;">
              <div :class="['w-9 h-9 rounded-xl flex items-center justify-center border-2 transition-all duration-500',
                            isStepDone(i) ? 'bg-yellow-500 border-yellow-400 text-white shadow-md'
                                          : 'bg-white border-gray-200 text-gray-300']">
                <span v-if="isStepDone(i) && !isStepActive(i)" class="material-symbols-outlined font-bold" style="font-size: 16px;">check</span>
                <span v-else class="font-black text-xs">{{ i + 1 }}</span>
              </div>
              <span :class="['text-[9px] font-black uppercase tracking-wide text-center leading-tight',
                             isStepDone(i) ? 'text-yellow-600' : 'text-gray-300']" style="width: 52px;">{{ step }}</span>
            </div>
          </div>
        </div>

        <!-- Cancelled / Error State -->
        <div v-else-if="order.trangThaiDH === 5" class="flex items-center gap-3 bg-red-50 border border-red-100 rounded-2xl px-5 py-4">
          <span class="material-symbols-outlined text-red-500 text-2xl">cancel</span>
          <div>
            <p class="text-sm font-black text-red-600">Đơn hàng đã bị hủy</p>
            <p v-if="order.lyDoHuy" class="text-xs text-red-400 mt-0.5">{{ order.lyDoHuy }}</p>
          </div>
        </div>
      </div>

      <!-- Main Grid -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <!-- LEFT: Products + Actions -->
        <div class="lg:col-span-2 space-y-6">

          <!-- Product List Card -->
          <div class="bg-white rounded-3xl border border-gray-100 shadow-sm overflow-hidden">
            <div class="px-8 py-5 border-b border-gray-100 flex items-center justify-between">
              <h2 class="font-black text-gray-800 flex items-center gap-2">
                <span class="material-symbols-outlined text-yellow-600 text-xl">shopping_bag</span>
                Sản phẩm đã đặt
              </h2>
              <span class="bg-yellow-50 text-yellow-700 text-xs font-black px-3 py-1 rounded-full border border-yellow-100">
                {{ order.chiTiet?.length || 0 }} mặt hàng
              </span>
            </div>

            <!-- Empty state -->
            <div v-if="!order.chiTiet || order.chiTiet.length === 0" class="flex flex-col items-center py-12 text-gray-300">
              <span class="material-symbols-outlined text-5xl mb-2">inventory_2</span>
              <p class="text-sm">Không có sản phẩm nào</p>
            </div>

            <div class="divide-y divide-gray-50">
              <div v-for="item in order.chiTiet" :key="item.maCT" class="px-8 py-5">
                <div class="flex items-center gap-5">
                  <!-- Product Image -->
                  <div class="w-20 h-20 rounded-2xl border border-gray-100 bg-gray-50 overflow-hidden shrink-0 flex items-center justify-center">
                    <img v-if="item.anh" :src="item.anh" class="w-full h-full object-cover" :alt="item.tenSP"
                         @error="$event.target.src='/img/placeholder.png'">
                    <span v-else class="material-symbols-outlined text-gray-300 text-3xl">image</span>
                  </div>

                  <!-- Product Info -->
                  <div class="flex-1 min-w-0">
                    <p class="text-xs font-black text-yellow-600 uppercase tracking-widest mb-1">{{ item.thuongHieu || '' }}</p>
                    <p class="font-black text-gray-900 truncate text-base leading-tight">{{ item.tenSP || 'Sản phẩm' }}</p>
                    <div class="flex items-center gap-2 mt-2 flex-wrap">
                      <span v-if="item.size" class="text-[10px] font-black text-gray-500 uppercase tracking-wider bg-gray-100 px-2.5 py-1 rounded-lg border border-gray-200">
                        Size: {{ item.size }}
                      </span>
                      <span v-if="item.mau" class="text-[10px] font-black text-gray-500 uppercase tracking-wider bg-gray-100 px-2.5 py-1 rounded-lg border border-gray-200">
                        Màu: {{ item.mau }}
                      </span>
                      <span class="text-[10px] font-black text-gray-500 uppercase tracking-wider bg-gray-100 px-2.5 py-1 rounded-lg border border-gray-200">
                        SL: x{{ item.soLuong }}
                      </span>
                    </div>
                  </div>

                  <!-- Price -->
                  <div class="text-right shrink-0">
                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-1">Thành tiền</p>
                    <p class="font-black text-gray-900 text-lg tracking-tight">{{ fmtCurrency(item.donGia * item.soLuong) }}</p>
                    <p class="text-xs text-gray-400 mt-0.5">{{ fmtCurrency(item.donGia) }} / sp</p>
                  </div>
                </div>

                <!-- ★ REVIEW SECTION - Redesigned Luxury Version -->
                <div v-if="canReview" class="mt-5 ml-[100px]">
                  
                  <!-- State 1: Đã đánh giá -->
                  <div v-if="reviewedItems[item.maCT]" 
                       class="flex items-center gap-4 bg-white border border-[#C8A97E]/30 rounded-xl px-5 py-3 shadow-[0_2px_10px_-4px_rgba(200,169,126,0.2)]">
                    <div class="flex gap-0.5 shrink-0">
                      <span v-for="star in 5" :key="star"
                            class="material-symbols-outlined text-[16px]"
                            :class="reviewedItems[item.maCT].diem >= star ? 'text-yellow-500' : 'text-gray-200'"
                            :style="fillStyle(reviewedItems[item.maCT].diem >= star)">star</span>
                    </div>
                    <div class="w-[1px] h-6 bg-[#C8A97E]/20 shrink-0"></div>
                    <span class="text-[9px] font-black text-[#C8A97E] uppercase tracking-[0.2em] shrink-0">Đã đánh giá</span>
                    <span v-if="reviewedItems[item.maCT].noiDung" class="text-xs text-gray-500 italic truncate ml-1 flex-1">
                      "{{ reviewedItems[item.maCT].noiDung }}"
                    </span>
                    <span v-else class="flex-1"></span>
                    <button @click="openReviewModal(item, reviewedItems[item.maCT].diem, reviewedItems[item.maCT].noiDung, reviewedItems[item.maCT].maDG)"
                            class="flex items-center justify-center p-1.5 text-gray-400 hover:text-[#C8A97E] hover:bg-yellow-50 rounded-lg transition-colors border border-transparent hover:border-[#C8A97E]/20 shrink-0"
                            title="Chỉnh sửa đánh giá">
                      <span class="material-symbols-outlined text-[16px]">edit</span>
                    </button>
                  </div>

                  <!-- State 2: Chưa đánh giá -->
                  <div v-else 
                       class="flex flex-wrap sm:flex-nowrap items-center justify-between gap-4 bg-gray-50/50 border border-gray-100 rounded-xl px-5 py-3 transition-colors hover:border-gray-200 hover:bg-gray-50 group">
                    <div class="flex items-center gap-3">
                      <p class="text-[9px] font-black text-gray-400 uppercase tracking-widest hidden sm:block">Bạn thấy sản phẩm thế nào?</p>
                      <div class="flex gap-1">
                        <button v-for="star in 5" :key="star"
                                @click="quickRate(item, star)"
                                @mouseenter="item._hover = star; $forceUpdate()"
                                @mouseleave="item._hover = 0; $forceUpdate()"
                                class="p-0.5 transition-transform hover:-translate-y-0.5">
                          <span class="material-symbols-outlined text-[20px] transition-all"
                                :class="(item._hover || item._rating || 0) >= star ? 'text-yellow-500 drop-shadow-sm' : 'text-gray-200'"
                                :style="fillStyle((item._hover || item._rating || 0) >= star)">star</span>
                        </button>
                      </div>
                    </div>
                    <button @click="openReviewModal(item)"
                            class="flex items-center gap-1.5 px-4 py-2 bg-black text-[#C8A97E] rounded-lg font-black text-[9px] uppercase tracking-[0.15em] border border-black hover:bg-[#C8A97E] hover:border-[#C8A97E] hover:text-white transition-all duration-300 shadow-sm active:scale-95 shrink-0">
                      <span class="material-symbols-outlined text-[13px] group-hover:animate-pulse">rate_review</span>
                      Gửi đánh giá
                    </button>
                  </div>

                </div>
              </div>
            </div>

            <!-- Subtotal -->
            <div class="px-8 py-6 bg-yellow-50/40 border-t border-gray-100 space-y-3">
              <div class="flex justify-between text-sm text-gray-500">
                <span class="font-semibold text-gray-600">Tạm tính</span>
                <span class="font-bold text-gray-800">{{ fmtCurrency(subTotal) }}</span>
              </div>
              <div v-if="order.giamGia && order.giamGia > 0" class="flex justify-between text-sm text-red-600">
                <div class="flex items-center gap-1.5 opacity-70">
                  <span class="material-symbols-outlined text-sm">confirmation_number</span>
                  <span class="font-semibold">Chiết khấu (Voucher)</span>
                </div>
                <span class="font-bold">-{{ fmtCurrency(order.giamGia) }}</span>
              </div>
              <div class="flex justify-between text-sm text-gray-500">
                <span class="font-semibold text-gray-600">Phí vận chuyển</span>
                <span class="font-bold text-gray-800">{{ order.phiShip ? fmtCurrency(order.phiShip) : 'Miễn phí' }}</span>
              </div>
              <div class="flex justify-between items-center pt-3 border-t border-yellow-200">
                <div class="flex flex-col">
                  <span class="font-black text-gray-900 text-base">Tổng cộng</span>
                  <span v-if="order.voucher" class="text-[9px] text-[#C8A97E] font-black uppercase tracking-widest">
                    Đã áp dụng mã: {{ order.voucher.code }}
                  </span>
                </div>
                <span class="font-black text-yellow-700 text-2xl tracking-tight">{{ fmtCurrency(order.tongTien) }}</span>
              </div>
            </div>
          </div>

          <!-- Action Buttons -->
          <div v-if="order.trangThaiDH !== 5 && order.trangThaiDH !== 7 && order.trangThaiDH !== 8"
               class="bg-white rounded-3xl border border-gray-100 shadow-sm px-8 py-6 flex flex-wrap items-center gap-3">
            <h3 class="w-full text-[10px] font-black text-gray-400 uppercase tracking-widest mb-2">Hành động đơn hàng</h3>

            <button v-if="order.trangThaiDH === 0 && !showCancelForm" @click="showCancelForm = true"
                    class="flex items-center gap-2 px-5 py-3 bg-red-50 text-red-600 border border-red-100 rounded-xl font-black text-[10px] uppercase tracking-wider hover:bg-red-600 hover:text-white transition-all active:scale-95">
              <span class="material-symbols-outlined text-sm">cancel</span>
              Hủy đơn hàng
            </button>

            <div v-if="showCancelForm" class="w-full mt-4 p-6 bg-red-50/50 border border-red-100 rounded-3xl space-y-4">
              <p class="text-[10px] font-black text-red-700 uppercase tracking-widest">Vui lòng cung cấp lý do hủy đơn:</p>
              <textarea v-model="cancelReason" rows="3" placeholder="Lý do hủy..."
                class="w-full border border-red-200 rounded-2xl px-5 py-4 text-sm focus:ring-2 focus:ring-red-400 outline-none transition-all resize-none bg-white"></textarea>
              <div class="flex gap-4">
                <button @click="cancelOrder" :disabled="!cancelReason.trim()"
                  class="flex-1 py-3 bg-red-600 text-white rounded-xl font-black text-[10px] uppercase tracking-widest hover:bg-red-700 transition-all disabled:opacity-50">
                  Xác nhận hủy
                </button>
                <button @click="showCancelForm = false; cancelReason = ''"
                  class="flex-1 py-3 bg-white text-gray-400 border border-gray-200 rounded-xl font-black text-[10px] uppercase tracking-widest hover:bg-gray-50 transition-all">
                  Đóng
                </button>
              </div>
            </div>

            <button v-if="!order.khachBaoChuaNhan && order.trangThaiDH === 3" @click="confirmReceived"
                    class="flex items-center gap-2 px-6 py-3 bg-yellow-500 text-white rounded-xl font-black text-[10px] uppercase tracking-wider hover:bg-yellow-600 transition-all shadow-md active:scale-95">
              <span class="material-symbols-outlined text-sm">check_circle</span>
              Đã nhận hàng
            </button>

            <button v-if="!order.khachBaoChuaNhan && order.trangThaiDH === 3" @click="reportNotReceived"
                    class="flex items-center gap-2 px-5 py-3 bg-white border border-gray-200 text-gray-500 rounded-xl font-black text-[10px] uppercase tracking-wider hover:border-red-400 hover:text-red-500 transition-all active:scale-95">
              <span class="material-symbols-outlined text-sm">feedback</span>
              Chưa nhận hàng
            </button>

            <!-- Mua Lại (Repurchase - Only 4 or 6) -->
            <button v-if="order.trangThaiDH === 4 || order.trangThaiDH === 6" @click="muaLai(order)" 
                    class="flex items-center gap-2 px-5 py-3 bg-red-50 text-red-600 border border-red-100 rounded-xl font-black text-[10px] uppercase tracking-wider hover:bg-red-600 hover:text-white transition-all active:scale-95 ml-auto">
              <span class="material-symbols-outlined text-sm">shopping_cart</span>
              Mua lại
            </button>
          </div>

          <!-- Complaint warning -->
          <div v-if="order.khachBaoChuaNhan"
               class="bg-orange-50 border border-orange-200 rounded-3xl px-8 py-6 flex items-center gap-5">
            <div class="w-12 h-12 bg-orange-500 rounded-2xl flex items-center justify-center text-white shrink-0 animate-pulse">
              <span class="material-symbols-outlined text-2xl">warning</span>
            </div>
            <div>
              <p class="font-black text-orange-700 uppercase tracking-widest text-sm">Đang chờ xử lý khiếu nại</p>
              <p class="text-xs text-orange-500 mt-1">Shop đang xem xét và sẽ liên hệ với bạn sớm nhất có thể.</p>
            </div>
          </div>
        </div>

        <!-- RIGHT: Info sidebar -->
        <div>
          <div class="bg-white rounded-3xl border border-gray-100 shadow-sm overflow-hidden sticky top-6">
            <!-- Người nhận -->
            <div class="p-6 space-y-4">
              <h3 class="text-[10px] font-black text-gray-400 uppercase tracking-[0.25em] flex items-center gap-2">
                <span class="w-6 h-0.5 bg-yellow-500"></span>Thông tin người nhận
              </h3>
              <div class="flex items-start gap-3">
                <span class="material-symbols-outlined text-yellow-600 text-xl mt-0.5">person</span>
                <div>
                  <p class="text-[10px] font-black text-gray-400 uppercase tracking-wider mb-0.5">Họ và tên</p>
                  <p class="font-black text-gray-800">{{ order.diaChiGiao?.hoTenNguoiNhan || order.taiKhoan?.hoTen || 'Chưa cập nhật' }}</p>
                </div>
              </div>
              <div class="flex items-start gap-3">
                <span class="material-symbols-outlined text-yellow-600 text-xl mt-0.5">call</span>
                <div>
                  <p class="text-[10px] font-black text-gray-400 uppercase tracking-wider mb-0.5">Số điện thoại</p>
                  <p class="font-bold text-gray-700">{{ order.diaChiGiao?.soDienThoai || order.taiKhoan?.soDienThoai || '---' }}</p>
                </div>
              </div>
              <div class="flex items-start gap-3">
                <span class="material-symbols-outlined text-yellow-600 text-xl mt-0.5">location_on</span>
                <div>
                  <p class="text-[10px] font-black text-gray-400 uppercase tracking-wider mb-0.5">Địa chỉ giao hàng</p>
                  <p class="font-bold text-gray-700 text-sm leading-relaxed">{{ order.diaChiGiao?.diaChiChiTiet || 'Chưa xác định' }}</p>
                </div>
              </div>
            </div>

            <div class="border-t border-gray-100 mx-6"></div>

            <!-- Thanh toán -->
            <div class="p-6 space-y-3">
              <h3 class="text-[10px] font-black text-gray-400 uppercase tracking-[0.25em] flex items-center gap-2">
                <span class="w-6 h-0.5 bg-yellow-500"></span>Thanh toán
              </h3>
              <div class="flex justify-between items-center py-2 border-b border-gray-100">
                <span class="text-xs font-semibold text-gray-500">Phương thức</span>
                <span class="text-sm font-black text-gray-800 text-right max-w-[55%] leading-tight">{{ order.hinhThucThanhToan?.tenHinhThuc || 'Tiền mặt' }}</span>
              </div>
              <div class="flex justify-between items-center pt-1">
                <span class="text-xs font-semibold text-gray-500">Trạng thái</span>
                <span :class="order.trangThaiThanhToan === 1 ? 'bg-green-100 text-green-700 border border-green-200' : 'bg-red-100 text-red-600 border border-red-200'"
                      class="px-3 py-1.5 rounded-xl text-[10px] font-black uppercase tracking-widest">
                  {{ order.trangThaiThanhToan === 1 ? 'Đã thanh toán' : 'Chưa thanh toán' }}
                </span>
              </div>
            </div>

            <div class="border-t border-gray-100 mx-6"></div>

            <!-- Thông tin đơn -->
            <div class="p-6 space-y-3">
              <h3 class="text-[10px] font-black text-gray-400 uppercase tracking-[0.25em] flex items-center gap-2">
                <span class="w-6 h-0.5 bg-yellow-500"></span>Thông tin đơn hàng
              </h3>
              <div class="flex justify-between text-sm">
                <span class="font-semibold text-gray-500">Mã đơn hàng</span>
                <span class="font-black text-gray-900">#{{ order.maDH }}</span>
              </div>
              <div class="flex justify-between text-sm">
                <span class="font-semibold text-gray-500">Ngày đặt</span>
                <span class="font-bold text-gray-700">{{ formatDate(order.ngayDat) }}</span>
              </div>
              <div class="flex justify-between text-sm">
                <span class="font-semibold text-gray-500">Giờ đặt</span>
                <span class="font-bold text-gray-700">{{ formatTime(order.ngayDat) }}</span>
              </div>
              <div class="flex justify-between items-center pt-3 border-t border-gray-100">
                <span class="font-black text-gray-800 text-sm">Tổng tiền</span>
                <span class="font-black text-yellow-700 text-lg">{{ fmtCurrency(order.tongTien) }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Error state -->
    <div v-else class="flex flex-col items-center justify-center min-h-[60vh] text-center px-4">
      <span class="material-symbols-outlined text-gray-200 text-8xl mb-4">receipt_long</span>
      <h2 class="text-xl font-black text-gray-700 mb-2">Không tìm thấy đơn hàng</h2>
      <p class="text-gray-400 mb-6">Đơn hàng không tồn tại hoặc bạn không có quyền xem.</p>
      <button @click="$router.push('/profile')"
              class="px-6 py-3 bg-yellow-600 text-white rounded-xl font-bold hover:bg-yellow-700 transition-all">
        Quay lại đơn hàng của tôi
      </button>
    </div>

    <!-- ★ REVIEW MODAL - Luxury Design -->
    <div v-if="showReviewModal" class="fixed inset-0 bg-black/70 backdrop-blur-md flex items-center justify-center z-[99999] p-4" @click.self="closeReviewModal">
      <div class="bg-white rounded-[2.5rem] shadow-2xl max-w-lg w-full overflow-hidden border border-white/20" style="animation: fadeInUp 0.3s ease;">

        <!-- Modal Header - Light Luxury -->
        <div class="bg-[#FAFAFA] p-8 pb-6 text-gray-900 flex justify-between items-start border-b border-gray-100 relative">
          <div class="relative z-10 flex-1">
            <p class="text-[10px] font-black text-[#C8A97E] uppercase tracking-[0.3em] mb-2">Luxury Feedback</p>
            <h3 class="font-black text-2xl italic tracking-tight">Đánh giá sản phẩm</h3>
            <!-- Product preview in header -->
            <div v-if="reviewingItem" class="mt-5 flex items-center gap-4 bg-white p-3 rounded-2xl border border-gray-100 shadow-sm">
              <div class="w-14 h-14 rounded-xl overflow-hidden border border-gray-50 shrink-0 bg-gray-50 flex items-center justify-center">
                <img v-if="reviewingItem.anh" :src="reviewingItem.anh" class="w-full h-full object-cover" @error="$event.target.src='/img/placeholder.png'">
                <span v-else class="material-symbols-outlined text-gray-300">image</span>
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-[9px] text-[#C8A97E] font-black uppercase tracking-widest mb-0.5">{{ reviewingItem.thuongHieu || 'Sản phẩm' }}</p>
                <p class="text-xs font-bold text-gray-800 leading-snug truncate">{{ reviewingItem.tenSP }}</p>
              </div>
            </div>
          </div>
          <button @click="closeReviewModal" class="relative z-10 hover:bg-gray-100 rounded-full p-2 transition-all mt-1 -mr-2">
            <span class="material-symbols-outlined text-gray-400">close</span>
          </button>
        </div>

        <div class="p-8 space-y-6">
          <!-- Stars Rating -->
          <div class="text-center space-y-3">
            <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Mức độ hài lòng của bạn</p>
            <div class="flex justify-center gap-1">
              <button v-for="star in 5" :key="star"
                      @click="reviewRating = star"
                      @mouseenter="hoverRating = star"
                      @mouseleave="hoverRating = 0"
                      class="p-1 transition-transform hover:scale-110">
                <span class="material-symbols-outlined text-5xl cursor-pointer transition-all"
                      :class="(hoverRating || reviewRating) >= star ? 'text-[#C8A97E] drop-shadow-md' : 'text-gray-200'"
                      :style="fillStyle((hoverRating || reviewRating) >= star)">star</span>
              </button>
            </div>
            <p v-if="reviewRating" class="text-sm font-black italic" :class="ratingColor(reviewRating)">
              {{ ratingText(reviewRating) }}
            </p>
          </div>

          <!-- Comment -->
          <div>
            <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest block mb-2">Nhận xét của bạn</label>
            <textarea v-model="reviewContent" rows="4"
                      placeholder="Chia sẻ cảm nhận về chất lượng, kích cỡ, màu sắc sản phẩm..."
                      class="w-full border-2 border-gray-100 rounded-2xl px-6 py-4 text-sm focus:border-[#C8A97E] outline-none transition-all resize-none bg-gray-50"></textarea>
          </div>
        </div>

        <div class="px-8 pb-8 flex justify-end gap-3 border-t border-gray-50 pt-6">
          <button @click="closeReviewModal" class="px-8 py-3.5 border border-gray-200 rounded-xl text-gray-500 font-black text-[10px] uppercase tracking-widest hover:bg-gray-50 hover:text-gray-800 transition-all">
            Hủy
          </button>
          <button @click="submitReview" :disabled="!reviewRating || submittingReview"
                  class="px-8 py-3.5 bg-black text-[#C8A97E] rounded-xl font-black text-[10px] uppercase tracking-[0.15em] hover:bg-[#C8A97E] hover:text-white transition-all disabled:opacity-30 flex items-center justify-center gap-2 shadow-sm border border-black group">
            <span v-if="submittingReview" class="w-4 h-4 border-2 border-[#C8A97E] border-t-transparent rounded-full animate-spin"></span>
            <span v-else class="material-symbols-outlined text-[14px]">send</span>
            {{ submittingReview ? 'Đang gửi...' : 'Gửi đánh giá' }}
          </button>
        </div>
      </div>
    </div>

    <!-- Report Modal -->
    <div v-if="showReportModal" class="fixed inset-0 bg-black/60 backdrop-blur-md flex items-center justify-center z-[9999] p-4" @click.self="showReportModal = false">
      <div class="bg-white rounded-3xl shadow-2xl max-w-md w-full overflow-hidden">
        <div class="bg-red-600 p-6 text-white flex justify-between items-center">
          <h3 class="font-black text-lg flex items-center gap-2">
            <span class="material-symbols-outlined">report_problem</span>
            Báo cáo chưa nhận hàng
          </h3>
          <button @click="showReportModal = false" class="hover:bg-red-700 rounded-full p-1.5 transition-colors">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>
        <div class="p-6 space-y-4">
          <div class="space-y-2">
            <label class="text-sm font-black text-gray-700 uppercase tracking-wider">Lý do:</label>
            <label v-for="r in reportReasons" :key="r"
                   class="flex items-center gap-3 p-3 border rounded-xl cursor-pointer transition-colors"
                   :class="reportReason === r ? 'border-red-500 bg-red-50' : 'border-gray-200 hover:bg-gray-50'">
              <input type="radio" v-model="reportReason" :value="r" class="w-4 h-4 text-red-600">
              <span class="text-sm font-medium text-gray-700">{{ r }}</span>
            </label>
          </div>
          <div>
            <label class="text-sm font-black text-gray-700 uppercase tracking-wider mb-2 block">Mô tả thêm:</label>
            <textarea v-model="reportDesc" rows="3" placeholder="Chi tiết về vấn đề..."
                      class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-red-400 outline-none resize-none"></textarea>
          </div>
        </div>
        <div class="p-4 bg-gray-50 border-t flex gap-3">
          <button @click="showReportModal = false" class="flex-1 py-3 border border-gray-200 rounded-xl text-gray-600 font-bold text-sm hover:bg-white transition-all">Đóng</button>
          <button @click="submitReport" :disabled="!reportReason" class="flex-1 py-3 bg-red-600 text-white rounded-xl font-bold text-sm hover:bg-red-700 transition-all disabled:opacity-40">Gửi báo cáo</button>
        </div>
      </div>
    </div>

    <AppFooter />
  </div>
</template>

<script>
import AppHeader from './fragments/AppHeader.vue'
import AppFooter from './fragments/AppFooter.vue'
import axios from 'axios'

export default {
  name: 'OrderDetailUser',
  components: { AppHeader, AppFooter },

  data() {
    return {
      order: null,
      loading: true,
      showCancelForm: false,
      cancelReason: '',
      showReportModal: false,
      reportReason: '',
      reportDesc: '',
      reportReasons: ['Chưa thấy giao', 'Giao nhầm địa chỉ', 'Khác'],
      steps: ['Chờ xác nhận', 'Đã xác nhận', 'Đang giao', 'Đã giao', 'Hoàn tất', 'Đã đánh giá'],

      reviewedItems: {}, // stores { diem, noiDung, maDG } for each maCT if rated
      showReviewModal: false,
      reviewingItem: null,
      reviewRating: 0,
      hoverRating: 0,
      reviewContent: '',
      submittingReview: false,
      editMaDG: null // ID của review đang chỉnh sửa (nếu có)
    }
  },

  computed: {
    subTotal() {
      return (this.order?.chiTiet || []).reduce((acc, item) => acc + item.donGia * item.soLuong, 0)
    },
    canReview() {
      const s = this.order?.trangThaiDH
      return s === 3 || s === 4 || s === 6
    },
    stepperWidth() {
      const s = this.order?.trangThaiDH
      if (s === 6) return 100
      if (s >= 4) return 80
      if (s === 3) return 60
      if (s === 2) return 40
      if (s === 1) return 20
      return 0
    }
  },

  methods: {
    isStepDone(i) {
      const s = this.order?.trangThaiDH
      if (s === 6) return true
      return s >= i
    },
    isStepActive(i) {
      return this.order?.trangThaiDH === i
    },

    async fetchOrder() {
      this.loading = true
      try {
        const id = this.$route.params.id
        const res = await axios.get(`/orders/${id}`, { withCredentials: true })
        this.order = res.data
        // Load review status for each item
        await this.loadReviewStatus()
      } catch (e) {
        console.error(e)
        this.order = null
      } finally {
        this.loading = false
      }
    },

    async loadReviewStatus() {
      if (!this.canReview || !this.order?.chiTiet?.length) return
      try {
        const reviewMap = {}
        for (const item of this.order.chiTiet) {
          if (!item.maCT) continue
          try {
            const r = await axios.get(`/danh-gia/check?maCT=${item.maCT}`, { withCredentials: true })
            if (r.data && r.data.daDanhGia) {
              reviewMap[item.maCT] = r.data.danhGia || { diem: r.data.diem, noiDung: r.data.noiDung, maDG: r.data.danhGia?.maDG }
            }
          } catch (_) { /* item chưa được đánh giá */ }
        }
        this.reviewedItems = reviewMap
      } catch (e) {
        console.error('Không tải được trạng thái đánh giá', e)
      }
    },

    quickRate(item, star) {
      item._rating = star
      this.$forceUpdate()
      this.openReviewModal(item, star)
    },

    openReviewModal(item, preRating = 0, preContent = '', editMaDG = null) {
      this.reviewingItem = item
      this.reviewRating = preRating || item._rating || 0
      this.reviewContent = preContent || ''
      this.editMaDG = editMaDG || null
      this.hoverRating = 0
      this.showReviewModal = true
    },

    closeReviewModal() {
      if (this.submittingReview) return
      this.showReviewModal = false
      this.reviewingItem = null
    },

    async submitReview() {
      if (!this.reviewRating || !this.reviewingItem) return
      this.submittingReview = true
      try {
        const maSP = this.reviewingItem.maSP
        const payload = {
          diem: this.reviewRating,
          noiDung: this.reviewContent,
          maCT: this.reviewingItem.maCT
        }
        let res
        if (this.editMaDG) {
          res = await axios.put(`/san-pham/danh-gia/${this.editMaDG}`, payload, { withCredentials: true })
        } else {
          res = await axios.post(`/san-pham/${maSP}/danh-gia`, payload, { withCredentials: true })
        }

        if (res.data.thanhCong) {
          this.reviewedItems[this.reviewingItem.maCT] = { 
            diem: this.reviewRating, 
            noiDung: this.reviewContent, 
            maDG: this.editMaDG || res.data.danhGia?.maDG 
          }
          window.$toast?.success(this.editMaDG ? 'Cập nhật đánh giá thành công!' : 'Đánh giá của bạn đã được ghi nhận!')
          this.showReviewModal = false
          await this.fetchOrder()
        } else {
          window.$toast?.error(res.data.thongBao || 'Không thể gửi đánh giá')
        }
      } catch (e) {
        console.error(e)
        window.$toast?.error('Lỗi khi gửi đánh giá. Vui lòng thử lại.')
      } finally {
        this.submittingReview = false
      }
    },

    async cancelOrder() {
      if (!this.cancelReason.trim()) return
      const ok = await window.$confirm?.('Bạn có chắc muốn hủy đơn hàng này không?')
      if (!ok) return
      try {
        await axios.put(`/orders/update-status/${this.order.maDH}`, null, {
          params: { status: 5, reason: this.cancelReason },
          withCredentials: true
        })
        this.showCancelForm = false
        this.cancelReason = ''
        await this.fetchOrder()
      } catch (e) {
        window.$toast?.error('Không thể hủy đơn: ' + (e.response?.data?.message || 'Vui lòng thử lại.'))
      }
    },

    async confirmReceived() {
      try {
        await axios.put(`/orders/complete/${this.order.maDH}`, null, { withCredentials: true })
        window.$toast?.success('Xác nhận đã nhận hàng thành công!')
        await this.fetchOrder()
      } catch (e) {
        window.$toast?.error('Có lỗi xảy ra.')
      }
    },

    reportNotReceived() {
      this.reportReason = ''
      this.reportDesc = ''
      this.showReportModal = true
    },

    async submitReport() {
      try {
        await axios.put(`/orders/${this.order.maDH}/report-undelivered`, null, {
          params: { reason: this.reportReason, description: this.reportDesc },
          withCredentials: true
        })
        window.$toast?.success('Đã gửi báo cáo cho Shop!')
        this.showReportModal = false
        await this.fetchOrder()
      } catch (e) {
        window.$toast?.error('Không thể gửi báo cáo.')
      }
    },

    async muaLai(order) {
      if (!order.chiTiet || order.chiTiet.length === 0) return;
      
      try {
        let addedCount = 0;
        let failCount = 0;
        
        for (const item of order.chiTiet) {
          const params = {
             productId: item.maSP,
             quantity: item.soLuong,
             variantId: item.maBienThe
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
           window.$toast?.success(`Đã thêm lại ${addedCount} sản phẩm vào giỏ hàng!`);
           if (window.refreshCartCount) window.refreshCartCount();
           setTimeout(() => {
             this.$router.push('/cart');
           }, 500);
        }
        if (failCount > 0) {
           window.$toast?.warning(`Không thể thêm ${failCount} sản phẩm (có thể đã hết hàng).`);
        }
      } catch (err) {
         console.error('Error repurchasing', err);
         window.$toast?.error('Có lỗi xảy ra khi thêm lại giỏ hàng');
      }
    },

    ratingText(s) {
      return { 1: 'Rất không hài lòng', 2: 'Không hài lòng', 3: 'Bình thường', 4: 'Hài lòng', 5: 'Tuyệt vời!' }[s] || ''
    },
    fillStyle(filled) {
      return { fontVariationSettings: filled ? "'FILL' 1" : "'FILL' 0" }
    },
    ratingColor(s) {
      return 'text-[#C8A97E]'
    },

    statusStyle(s) {
      const map = {
        0: { label: 'Chờ xác nhận', badge: 'bg-yellow-100 text-yellow-700 border border-yellow-200', iconBg: 'bg-yellow-500' },
        1: { label: 'Đã xác nhận',  badge: 'bg-blue-100 text-blue-700 border border-blue-200',       iconBg: 'bg-blue-500' },
        2: { label: 'Đang giao',    badge: 'bg-purple-100 text-purple-700 border border-purple-200', iconBg: 'bg-purple-500' },
        3: { label: 'Đã giao',      badge: 'bg-teal-100 text-teal-700 border border-teal-200',       iconBg: 'bg-teal-500' },
        4: { label: 'Hoàn tất',     badge: 'bg-green-100 text-green-700 border border-green-200',    iconBg: 'bg-green-500' },
        5: { label: 'Đã hủy',       badge: 'bg-red-100 text-red-600 border border-red-200',          iconBg: 'bg-red-500' },
        6: { label: 'Đã đánh giá',  badge: 'bg-orange-100 text-orange-700 border border-orange-200', iconBg: 'bg-orange-500' },
        7: { label: 'Chờ thanh toán', badge: 'bg-pink-100 text-pink-700 border border-pink-200',     iconBg: 'bg-pink-500' },
        8: { label: 'Lỗi thanh toán', badge: 'bg-gray-100 text-gray-700 border border-gray-200',     iconBg: 'bg-gray-600' },
      }
      return map[s] ?? { label: 'Không xác định', badge: 'bg-gray-100 text-gray-500 border border-gray-200', iconBg: 'bg-gray-400' }
    },

    fmtCurrency(v) { return new Intl.NumberFormat('vi-VN').format(v || 0) + '₫' },
    formatDate(d) { return d ? new Date(d).toLocaleDateString('vi-VN') : '---' },
    formatTime(d) { return d ? new Date(d).toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' }) : '---' },
    formatDateTime(d) { return d ? new Date(d).toLocaleString('vi-VN') : '---' },
  },

  mounted() { this.fetchOrder() }
}
</script>

<style scoped>
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(24px); }
  to   { opacity: 1; transform: translateY(0); }
}
</style>
