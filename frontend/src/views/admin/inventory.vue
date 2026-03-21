<template>
  <div class="p-8 space-y-6">

    <Transition name="page-fade" mode="out-in">
      <div v-if="!showModal" key="list" class="space-y-6">

      <!-- TABS -->
      <div class="flex gap-1 bg-gray-100 p-1 rounded-2xl w-fit">
        <button @click="activeTab = 'nhap'"
          :class="activeTab === 'nhap' ? 'bg-white shadow-sm text-yellow-700' : 'text-gray-500 hover:text-gray-700'"
          class="px-6 py-2.5 rounded-xl text-sm font-bold transition-all flex items-center gap-2">
          <span class="material-symbols-outlined text-[20px]">inventory_2</span>
          Nhập Kho
        </button>
        <button v-if="isAdmin" @click="activeTab = 'ncc'"
          :class="activeTab === 'ncc' ? 'bg-white shadow-sm text-yellow-700' : 'text-gray-500 hover:text-gray-700'"
          class="px-6 py-2.5 rounded-xl text-sm font-bold transition-all flex items-center gap-2">
          <span class="material-symbols-outlined text-[20px]">storefront</span>
          Nhà Cung Cấp
        </button>
        
      </div>

      <!-- ====== TAB NHẬP KHO ====== -->
      <div v-if="activeTab === 'nhap'" class="space-y-6">

        <!-- STAT CARDS -->
        <div class="grid grid-cols-3 gap-4">
          <div class="bg-white rounded-2xl border border-[#C8A97E]/40 shadow-sm p-5">
            <p class="text-xs text-gray-500 mb-2">Tổng số phiếu nhập</p>
            <p class="text-3xl font-black text-gray-800">{{ danhSachPhieu.length }}</p>
          </div>
          <div class="bg-white rounded-2xl border border-[#C8A97E]/40 shadow-sm p-5">
            <p class="text-xs text-gray-500 mb-2">Tổng số sản phẩm nhập</p>
            <p class="text-3xl font-black text-[#C8A97E]">{{ totalItems }}</p>
          </div>
          <div class="bg-white rounded-2xl border border-[#C8A97E]/40 shadow-sm p-5">
            <p class="text-xs text-gray-500 mb-2">Nhà cung cấp</p>
            <p class="text-3xl font-black text-[#C8A97E]">{{ supplierCount }}</p>
          </div>
        </div>

        <!-- LOW STOCK PANEL -->
        <div v-if="lowStock.length > 0" class="bg-white rounded-2xl border border-yellow-300 shadow-sm overflow-hidden">
          <div class="bg-yellow-50 px-5 py-3 flex items-center gap-2 border-b border-yellow-200">
            <span class="material-symbols-outlined text-yellow-600 text-[22px]">warning</span>
            <span class="text-sm font-bold text-yellow-800">Sản phẩm tồn kho thấp (dưới 5 sản phẩm)</span>
            <span class="ml-auto px-2.5 py-0.5 bg-yellow-200 text-yellow-800 text-xs font-black rounded-full">{{ lowStock.length }}</span>
          </div>
          <div class="divide-y divide-gray-100 max-h-[320px] overflow-y-auto custom-scrollbar">
            <div v-for="item in lowStock" :key="item.maBienThe"
              class="flex items-center gap-3 px-5 py-3 hover:bg-yellow-50/50 transition-colors">
              <span class="material-symbols-outlined text-yellow-500 text-[20px]">inventory_2</span>
              <div class="flex-1">
                <p class="text-sm font-semibold text-gray-800">{{ item.tenSP }}</p>
                <p class="text-xs text-gray-400">Size: {{ item.size || '—' }} &nbsp;|&nbsp; Màu: {{ item.mau || '—' }}</p>
              </div>
              <button v-if="isStaff" @click="requestStock(item)"
                class="px-3 py-1 bg-yellow-600 hover:bg-yellow-700 text-white text-[10px] font-bold rounded-lg transition-colors flex items-center gap-1">
                <span class="material-symbols-outlined text-[14px]">send</span>
                Yêu cầu nhập
              </button>
              <span :class="item.soLuongTon === 0
                ? 'bg-red-100 text-red-700'
                : 'bg-yellow-100 text-yellow-700'"
                class="px-2.5 py-0.5 rounded-full text-xs font-black">
                {{ item.soLuongTon }} sp
              </span>
            </div>
          </div>
        </div>

        <!-- SECTION HEADER -->
        <div class="flex items-center justify-between">
          <h3 class="text-base font-bold text-gray-700">Phiếu Nhập Kho</h3>
          <button v-if="isAdmin" @click="openModal"
            class="flex items-center gap-2 bg-yellow-600 hover:bg-yellow-700 text-white px-5 py-2.5 rounded-xl text-sm font-semibold shadow-sm transition-colors">
            <span class="material-symbols-outlined text-[18px]">add</span>
            Tạo Phiếu Nhập
          </button>
        </div>

        <!-- BỘ LỌC -->
        <div class="flex flex-wrap items-center gap-3">
          <select v-model="filter.maNCC"
            class="border border-[#C8A97E]/50 rounded-2xl px-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 hover:border-[#C8A97E] transition-all shadow-sm min-w-[160px]">
            <option value="">Tất cả NCC</option>
            <option v-for="ncc in suppliers" :key="ncc.maNCC" :value="ncc.maNCC">{{ ncc.tenNCC }}</option>
          </select>
          <div class="flex items-center bg-gray-100 p-1 rounded-2xl shadow-inner">
            <button v-for="r in timeRanges" :key="r.value" @click="filter.timeRange = r.value"
              class="px-4 py-2 text-xs font-bold rounded-xl transition-all whitespace-nowrap"
              :class="filter.timeRange === r.value ? 'bg-white text-yellow-700 shadow-sm' : 'text-gray-500 hover:text-gray-700'">
              {{ r.label }}
            </button>
          </div>
          <button @click="resetFilter"
            class="flex items-center justify-center size-10 rounded-2xl border border-[#C8A97E]/30 bg-white text-[#C8A97E] hover:bg-[#C8A97E] hover:text-white transition-all shadow-sm group"
            title="Đặt lại bộ lọc">
            <span class="material-symbols-outlined text-[22px] group-hover:rotate-180 transition-transform duration-500">refresh</span>
          </button>
        </div>

        <!-- DANH SÁCH PHIẾU (CARD) -->
        <div v-if="filteredPhieu.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
          <div v-for="phieu in filteredPhieu" :key="phieu.maPN"
            class="bg-white rounded-2xl border border-[#C8A97E]/40 shadow-sm hover:shadow-md hover:border-[#C8A97E] transition-all p-5">
            <!-- Card Top -->
            <div class="flex items-start justify-between mb-4">
              <div>
                <p class="text-[10px] text-gray-400 uppercase tracking-widest font-bold">PHIẾU NHẬP</p>
                <p class="text-lg font-black text-yellow-700">PN{{ phieu.maPN }}</p>
              </div>
              <span class="material-symbols-outlined text-[#C8A97E] text-[26px]">receipt_long</span>
            </div>
            <!-- Info Rows -->
            <div class="space-y-2.5">
              <div class="flex gap-2 items-start">
                <span class="material-symbols-outlined text-gray-400 text-[18px] mt-0.5">storefront</span>
                <div>
                  <p class="text-[10px] text-gray-400 uppercase leading-3">Nhà Cung Cấp</p>
                  <p class="text-sm font-semibold text-gray-700">{{ phieu.nhaCungCap?.tenNCC || '—' }}</p>
                </div>
              </div>
              <div class="flex gap-2 items-start">
                <span class="material-symbols-outlined text-gray-400 text-[18px] mt-0.5">person</span>
                <div>
                  <p class="text-[10px] text-gray-400 uppercase leading-3">Nhân Viên</p>
                  <p class="text-sm font-semibold text-gray-700">{{ phieu.nhanVien?.hoTen || '—' }}</p>
                </div>
              </div>
              <div class="flex gap-2 items-start">
                <span class="material-symbols-outlined text-gray-400 text-[18px] mt-0.5">calendar_today</span>
                <div>
                  <p class="text-[10px] text-gray-400 uppercase leading-3">Ngày Nhập</p>
                  <p class="text-sm font-semibold text-gray-700">{{ formatDateTime(phieu.ngayNhap) }}</p>
                </div>
              </div>
              <div class="flex gap-2 items-start">
                <span class="material-symbols-outlined text-green-600 text-[18px] mt-0.5">payments</span>
                <div>
                  <p class="text-[10px] text-gray-400 uppercase leading-3">Tổng Tiền</p>
                  <p class="text-sm font-black text-green-600">{{ fmtCurrency(phieu.tongTien) }}</p>
                </div>
              </div>
              <div v-if="phieu.ghiChu" class="flex gap-2 items-start">
                <span class="material-symbols-outlined text-gray-400 text-[18px] mt-0.5">notes</span>
                <div>
                  <p class="text-[10px] text-gray-400 uppercase leading-3">Ghi Chú</p>
                  <p class="text-xs text-gray-600">{{ phieu.ghiChu }}</p>
                </div>
              </div>
            </div>
            <button @click="openDetail(phieu)"
              class="w-full mt-4 pt-3 border-t border-gray-100 text-sm font-semibold text-yellow-700 hover:text-yellow-800 transition-colors text-center">
              Xem chi tiết →
            </button>
          </div>
        </div>

        <!-- EMPTY STATE -->
        <div v-else class="flex flex-col items-center justify-center py-16 text-gray-400">
          <span class="material-symbols-outlined text-5xl mb-3">inventory_2</span>
          <p class="text-sm">Chưa có phiếu nhập kho nào</p>
        </div>
      </div>

      <!-- ====== TAB NHÀ CUNG CẤP ====== -->
      <div v-if="activeTab === 'ncc' && isAdmin" class="space-y-6">
        <div class="flex items-center justify-between">
          <h3 class="text-base font-bold text-gray-700">Danh Sách Nhà Cung Cấp</h3>
          <button @click="openNccModal()"
            class="flex items-center gap-2 bg-yellow-600 hover:bg-yellow-700 text-white px-5 py-2.5 rounded-xl text-sm font-semibold shadow-sm transition-colors">
            <span class="material-symbols-outlined text-[18px]">add</span>
            Thêm NCC
          </button>
        </div>
        <div v-if="suppliers.length > 0" class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm overflow-hidden">
          <table class="w-full text-sm">
            <thead class="bg-gray-50 border-b border-gray-200">
              <tr>
                <th class="px-5 py-4 text-left text-xs font-semibold text-gray-500 uppercase">ID</th>
                <th class="px-5 py-4 text-left text-xs font-semibold text-gray-500 uppercase">Tên NCC</th>
                <th class="px-5 py-4 text-left text-xs font-semibold text-gray-500 uppercase">SĐT</th>
                <th class="px-5 py-4 text-left text-xs font-semibold text-gray-500 uppercase">Email</th>
                <th class="px-5 py-4 text-left text-xs font-semibold text-gray-500 uppercase">Địa chỉ</th>
                <th class="px-5 py-4 text-center text-xs font-semibold text-gray-500 uppercase">Hành động</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr v-for="ncc in suppliers" :key="ncc.maNCC" class="hover:bg-yellow-50/50 transition-colors">
                <td class="px-5 py-4 font-mono text-xs text-gray-500">#{{ ncc.maNCC }}</td>
                <td class="px-5 py-4 font-semibold text-gray-800">{{ ncc.tenNCC }}</td>
                <td class="px-5 py-4 text-gray-600">{{ ncc.soDienThoai || '—' }}</td>
                <td class="px-5 py-4 text-gray-600">{{ ncc.email || '—' }}</td>
                <td class="px-5 py-4 text-gray-600">{{ ncc.diaChi || '—' }}</td>
                <td class="px-5 py-4">
                  <div class="flex items-center justify-center gap-1">
                    <button @click="openNccModal(ncc)" class="text-yellow-600 hover:text-yellow-800 p-1.5 rounded-lg hover:bg-yellow-50 transition-all" title="Sửa">
                      <span class="material-symbols-outlined text-[18px]">edit</span>
                    </button>
                    <button @click="deleteNcc(ncc)" class="text-red-400 hover:text-red-600 p-1.5 rounded-lg hover:bg-red-50 transition-all" title="Xóa">
                      <span class="material-symbols-outlined text-[18px]">delete</span>
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div v-else class="flex flex-col items-center justify-center py-16 text-gray-400">
          <span class="material-symbols-outlined text-5xl mb-3">storefront</span>
          <p class="text-sm">Chưa có nhà cung cấp nào</p>
        </div>
      </div>
    </div>

    <div v-else key="form" class="space-y-6">
      <!-- Header Trang Tạo Phiếu -->
      <div class="flex items-center justify-between bg-white px-6 py-5 rounded-3xl border border-gray-100 shadow-sm">
        <div class="flex items-center gap-4">
          <button @click="closeModal" class="p-2.5 rounded-2xl hover:bg-gray-50 text-gray-400 hover:text-gray-800 transition-all border border-transparent hover:border-gray-200">
            <span class="material-symbols-outlined text-2xl">arrow_back</span>
          </button>
          <div>
            <h2 class="text-xl font-black text-gray-900 tracking-tight">Tạo Phiếu Nhập Kho Mới</h2>
            <p class="text-xs text-gray-400 font-medium">Hoàn tất biểu mẫu để cập nhật số lượng tồn kho</p>
          </div>
        </div>
        <div class="flex items-center gap-3">
          <button @click="closeModal" class="px-5 py-2.5 rounded-xl border-2 border-gray-100 text-gray-500 font-bold text-sm hover:bg-gray-50 transition-all">
            Hủy Bỏ
          </button>
        </div>
      </div>

      <div class="space-y-6">
        <!-- SECTION 1: NHÀ CUNG CẤP -->
        <div class="bg-white rounded-2xl border border-[#C8A97E]/30 shadow-sm p-6">
          <div class="flex items-center gap-2 mb-4">
            <span class="w-6 h-6 rounded-full bg-yellow-600 text-white text-xs font-black flex items-center justify-center">1</span>
            <p class="text-sm font-black text-gray-700 uppercase tracking-wider">Nhà Cung Cấp</p>
          </div>
          <div class="flex items-center gap-3">
            <div class="relative flex-1">
              <input
                v-model="supplierSearchText"
                @focus="showSupplierDropdown = true"
                @blur="hideSupplierDropdown"
                @input="filterSupplierSearch"
                placeholder="Tìm hoặc nhập tên nhà cung cấp..."
                class="w-full border border-[#C8A97E]/40 rounded-2xl px-4 py-3 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 transition-all shadow-sm font-medium"
              />
              <div v-if="showSupplierDropdown && filteredSupplierList.length > 0"
                class="absolute z-[50] w-full mt-2 bg-white border border-[#C8A97E]/20 rounded-xl shadow-2xl max-h-48 overflow-y-auto animate-[pop_0.2s_ease-out]">
                <div v-for="ncc in filteredSupplierList" :key="ncc.maNCC" @mousedown.prevent="selectSupplier(ncc)"
                  class="px-4 py-2.5 text-sm hover:bg-yellow-50 cursor-pointer text-gray-700 border-b border-gray-50 last:border-0 font-medium">
                  {{ ncc.tenNCC }}
                </div>
              </div>
            </div>
            <button @click="addSupplier" class="px-4 py-3 border border-yellow-200 rounded-2xl bg-yellow-50 text-yellow-700 hover:bg-yellow-100 transition-all shadow-sm shrink-0 flex items-center gap-1.5 text-sm font-bold">
              <span class="material-symbols-outlined text-[18px]">add</span>
              Tạo mới NCC
            </button>
          </div>
          <p v-if="form.maNCC" class="mt-2 text-xs text-green-600 font-semibold flex items-center gap-1">
            <span class="material-symbols-outlined text-[14px]">check_circle</span>
            Đã chọn: {{ supplierSearchText }}
          </p>
        </div>

        <!-- SECTION 2: THÊM SẢN PHẨM -->
        <div class="bg-white rounded-2xl border border-[#C8A97E]/30 shadow-sm p-6 space-y-5">
          <div class="flex items-center gap-2">
            <span class="w-6 h-6 rounded-full bg-yellow-600 text-white text-xs font-black flex items-center justify-center">2</span>
            <p class="text-sm font-black text-gray-700 uppercase tracking-wider">Thông Tin Sản Phẩm</p>
          </div>

          <!-- ROW 1: Thương hiệu + Danh mục + Tên SP + Giới tính -->
          <div class="grid grid-cols-2 gap-4">
            <!-- Nhà cung cấp -->
            <div class="space-y-1.5 relative">
              <label class="text-xs font-bold text-gray-500 uppercase tracking-wider">Thương Hiệu <span class="text-red-500">*</span></label>
              <div class="relative">
                <input
                  v-model="brandSearchText"
                  @focus="showBrandDropdown = true"
                  @blur="hideBrandDropdown"
                  @input="filterBrandSearch"
                  placeholder="Gõ tên hoặc chọn thương hiệu..."
                  :disabled="!newItem.isNewProduct && newItem.productId"
                  class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 transition-all font-medium disabled:bg-gray-50"
                />
                <div v-if="showBrandDropdown" class="absolute z-[40] w-full mt-1 bg-white border border-[#C8A97E]/20 rounded-xl shadow-2xl max-h-48 overflow-y-auto animate-[pop_0.2s_ease-out]">
                  <div v-for="b in filteredBrandList" :key="b.maTH" @mousedown.prevent="selectBrand(b)"
                    class="px-4 py-2.5 text-sm hover:bg-yellow-50 cursor-pointer text-gray-700 border-b border-gray-50 last:border-0 font-medium">
                    {{ b.tenTH }}
                  </div>
                </div>
              </div>
            </div>

            <!-- Danh mục -->
            <div class="space-y-1.5 relative">
              <label class="text-xs font-bold text-gray-500 uppercase tracking-wider">Danh Mục <span class="text-red-500">*</span></label>
              <div class="relative">
                <input
                  v-model="categorySearchText"
                  @focus="showCategoryDropdown = true"
                  @blur="hideCategoryDropdown"
                  @input="filterCategorySearch"
                  placeholder="Gõ tên hoặc chọn danh mục..."
                  :disabled="!newItem.isNewProduct && newItem.productId"
                  class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 transition-all font-medium disabled:bg-gray-50"
                />
                <div v-if="showCategoryDropdown" class="absolute z-[40] w-full mt-1 bg-white border border-[#C8A97E]/20 rounded-xl shadow-2xl max-h-48 overflow-y-auto animate-[pop_0.2s_ease-out]">
                  <div v-for="c in filteredCategoryList" :key="c.maLoai" @mousedown.prevent="selectCategory(c)"
                    class="px-4 py-2.5 text-sm hover:bg-yellow-50 cursor-pointer text-gray-700 border-b border-gray-50 last:border-0 font-medium">
                    {{ c.tenLoai }}
                  </div>
                </div>
              </div>
            </div>

            <!-- Tên sản phẩm -->
            <div class="space-y-1.5 relative">
              <label class="text-xs font-bold text-gray-500 uppercase tracking-wider">Tên Sản Phẩm <span class="text-red-500">*</span></label>
              <div class="relative">
                <input
                  v-model="productSearchText"
                  @focus="showProductDropdown = true"
                  @blur="hideProductDropdown"
                  @input="filterProducts"
                  placeholder="Nhập tên SP mới hoặc chọn có sẵn..."
                  class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 transition-all font-semibold text-gray-800"
                />
                <div v-if="showProductDropdown" class="absolute z-[35] w-full mt-1 bg-white border border-[#C8A97E]/20 rounded-xl shadow-2xl max-h-48 overflow-y-auto animate-[pop_0.2s_ease-out]">
                  <div v-for="p in filteredProductsList" :key="p.maSP" @mousedown.prevent="selectProduct(p)"
                    class="px-4 py-2.5 text-sm hover:bg-yellow-50 cursor-pointer text-gray-700 border-b border-gray-50 last:border-0 font-semibold">
                    {{ p.tenSP }}
                  </div>
                </div>
              </div>
              <p v-if="newItem.isNewProduct && productSearchText" class="text-[10px] text-yellow-600 font-semibold mt-0.5">✦ Sẽ tạo sản phẩm mới</p>
            </div>

            <!-- Giới tính -->
            <div class="space-y-1.5">
              <label class="text-xs font-bold text-gray-500 uppercase tracking-wider">Giới Tính</label>
              <select v-model.number="newItem.gender" :disabled="!newItem.isNewProduct && newItem.productId"
                class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 transition-all font-medium disabled:bg-gray-50">
                <option :value="0">Nam</option>
                <option :value="1">Nữ</option>
                <option :value="2">Unisex</option>
              </select>
            </div>
          </div>

          <!-- SECTION SIZE / MÀU / SỐ LƯỢNG -->
          <div class="space-y-3 bg-gray-50 rounded-2xl p-4 border border-gray-100">
            <div class="flex items-center justify-between">
              <label class="text-xs font-bold text-gray-500 uppercase tracking-wider">Size / Màu sắc / Số lượng</label>
              <button @click="addSizeRow"
                class="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-yellow-50 border border-yellow-200 text-yellow-700 text-xs font-bold hover:bg-yellow-100 transition-all">
                <span class="material-symbols-outlined text-[15px]">add</span>
                Thêm size
              </button>
            </div>

            <div v-for="(row, idx) in newItem.sizeRows" :key="idx"
              class="grid gap-3 items-center bg-white rounded-xl p-3 border border-gray-100 shadow-sm"
              style="grid-template-columns: 1fr 1fr 1fr auto;">
              <div>
                <label class="text-[10px] text-gray-400 font-semibold mb-1 block">Size</label>
                <select v-model="row.size" @change="checkExistingVariantRow(idx)"
                  class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm bg-white focus:border-[#C8A97E] transition-all outline-none font-medium">
                  <option value="">-- Size --</option>
                  <option v-for="s in sizes" :key="s.maSize" :value="s.tenSize">{{ s.tenSize }}</option>
                </select>
              </div>
              <div>
                <label class="text-[10px] text-gray-400 font-semibold mb-1 block">Màu sắc</label>
                <select v-model="row.color" @change="checkExistingVariantRow(idx)"
                  class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm bg-white focus:border-[#C8A97E] transition-all outline-none font-medium">
                  <option value="">-- Màu --</option>
                  <option v-for="m in colors" :key="m.maMau" :value="m.tenMau">{{ m.tenMau }}</option>
                </select>
              </div>
              <div>
                <label class="text-[10px] text-gray-400 font-semibold mb-1 block">Số lượng</label>
                <input type="number" v-model.number="row.qty" min="1"
                  class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm bg-white focus:border-[#C8A97E] transition-all outline-none font-black text-gray-800" />
              </div>
              <button v-if="newItem.sizeRows.length > 1" @click="removeSizeRow(idx)"
                class="mt-5 p-2 rounded-lg text-red-400 hover:text-red-600 hover:bg-red-50 transition-all">
                <span class="material-symbols-outlined text-[18px]">delete</span>
              </button>
              <div v-else class="mt-5 w-9"></div>
            </div>
          </div>

          <!-- GIÁ NHẬP & GIÁ BÁN LẺ + MÔ TẢ -->
          <div class="grid grid-cols-3 gap-4">
            <div class="space-y-1.5">
              <label class="text-xs font-bold text-gray-500 uppercase tracking-wider">Giá Nhập <span class="text-red-500">*</span></label>
              <div class="relative">
                <input type="number" v-model.number="newItem.price" min="0"
                  class="w-full border border-gray-200 rounded-xl pl-4 pr-8 py-2.5 text-sm bg-white focus:border-[#C8A97E] focus:outline-none transition-all font-bold text-gray-700" />
                <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[10px] text-gray-400 font-bold">đ</span>
              </div>
            </div>
            <div class="space-y-1.5">
              <label class="text-xs font-bold text-gray-500 uppercase tracking-wider">Giá Bán Lẻ <span v-if="newItem.isNewProduct" class="text-red-500">*</span></label>
              <div class="relative">
                <input type="number" v-model.number="newItem.giaBan" min="0"
                  :disabled="!newItem.isNewProduct && newItem.productId"
                  class="w-full border border-gray-200 rounded-xl pl-4 pr-8 py-2.5 text-sm bg-white focus:border-[#C8A97E] focus:outline-none transition-all font-bold text-yellow-800 disabled:bg-gray-50" />
                <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[10px] text-gray-400 font-bold">đ</span>
              </div>
            </div>
            <div class="space-y-1.5">
              <label class="text-xs font-bold text-gray-500 uppercase tracking-wider">Mô Tả SP</label>
              <input v-model="newItem.moTa"
                placeholder="Mô tả (cho SP mới)..."
                :disabled="!newItem.isNewProduct && newItem.productId"
                class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm bg-white focus:border-[#C8A97E] focus:outline-none transition-all font-medium disabled:bg-gray-50" />
            </div>
          </div>

          <!-- NÚT LƯU & THÊM SP KHÁC -->
          <div class="flex items-center justify-between bg-gradient-to-r from-yellow-50 to-amber-50 p-5 rounded-2xl border border-yellow-200">
            <div>
              <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Tổng cộng (SP này)</p>
              <p class="text-2xl font-black text-yellow-700 leading-tight">
                {{ fmtCurrency(newItem.sizeRows.reduce((s,r) => s + (r.qty || 0), 0) * (newItem.price || 0)) }}
              </p>
              <p class="text-xs text-gray-400 mt-0.5">{{ newItem.sizeRows.reduce((s,r) => s + (r.qty || 0), 0) }} sản phẩm</p>
            </div>
            <button @click="addItem"
              class="px-8 py-4 bg-yellow-600 hover:bg-yellow-700 text-white rounded-2xl text-sm font-black shadow-lg transition-all transform hover:-translate-y-0.5 active:scale-95 flex items-center gap-2">
              <span class="material-symbols-outlined text-xl">save</span>
              Lưu &amp; Thêm SP khác
            </button>
          </div>
        </div>

        <!-- SECTION 3: BẢNG SẢN PHẨM ĐÃ THÊM -->
        <div class="bg-white rounded-2xl border border-[#C8A97E]/30 shadow-sm overflow-hidden">
          <div class="px-6 py-4 bg-gray-50 border-b border-gray-100 flex items-center gap-2">
            <span class="w-6 h-6 rounded-full bg-yellow-600 text-white text-xs font-black flex items-center justify-center">3</span>
            <p class="text-sm font-black text-gray-700 uppercase tracking-wider">Danh Sách Sản Phẩm Trong Phiếu</p>
            <span class="ml-auto px-2.5 py-0.5 bg-yellow-100 text-yellow-700 text-xs font-black rounded-full">{{ form.items.length }} dòng</span>
          </div>
          <table class="w-full text-sm">
            <thead>
              <tr class="bg-yellow-700/90 text-white">
                <th class="px-5 py-3 text-left text-[10px] font-black uppercase tracking-widest">Sản phẩm</th>
                <th class="px-5 py-3 text-center text-[10px] font-black uppercase tracking-widest">Danh mục</th>
                <th class="px-5 py-3 text-center text-[10px] font-black uppercase tracking-widest">Brand</th>
                <th class="px-5 py-3 text-center text-[10px] font-black uppercase tracking-widest">Giới tính</th>
                <th class="px-5 py-3 text-center text-[10px] font-black uppercase tracking-widest">Biến thể</th>
                <th class="px-5 py-3 text-center text-[10px] font-black uppercase tracking-widest">SL</th>
                <th class="px-5 py-3 text-right text-[10px] font-black uppercase tracking-widest">Đơn giá</th>
                <th class="px-5 py-3 text-right text-[10px] font-black uppercase tracking-widest">Thành tiền</th>
                <th class="px-5 py-3 text-center text-[10px] font-black uppercase tracking-widest">Xóa</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-50">
              <tr v-for="(item, idx) in form.items" :key="idx" class="hover:bg-yellow-50/30 transition-colors">
                <td class="px-5 py-4">
                  <p class="font-bold text-gray-900 text-sm">{{ item.displayName }}</p>
                  <input v-model="item.ghiChu" placeholder="Ghi chú dòng..." class="mt-0.5 text-[10px] text-gray-400 border-0 bg-transparent p-0 w-full focus:ring-0 italic" />
                </td>
                <td class="px-5 py-4 text-center">
                  <span class="text-xs text-gray-500">{{ item.categoryName || '—' }}</span>
                </td>
                <td class="px-5 py-4 text-center">
                  <span class="text-xs font-semibold text-gray-700">{{ item.brandName || '—' }}</span>
                </td>
                <td class="px-5 py-4 text-center">
                  <span class="px-2 py-0.5 rounded-full text-[10px] font-black uppercase"
                    :class="item.gender === 0 ? 'bg-blue-100 text-blue-600' : (item.gender === 1 ? 'bg-pink-100 text-pink-600' : 'bg-gray-100 text-gray-600')">
                    {{ item.gender === 0 ? 'Nam' : (item.gender === 1 ? 'Nữ' : 'Unisex') }}
                  </span>
                </td>
                <td class="px-5 py-4 text-center">
                  <span class="px-2 py-1 bg-gray-100 rounded-lg text-xs font-bold text-gray-600">{{ item.size }} / {{ item.color }}</span>
                </td>
                <td class="px-5 py-4 text-center font-black text-gray-900">{{ item.qty }}</td>
                <td class="px-5 py-4 text-right text-gray-500 text-sm">{{ fmtCurrency(item.price) }}</td>
                <td class="px-5 py-4 text-right font-black text-gray-900">{{ fmtCurrency(item.qty * item.price) }}</td>
                <td class="px-5 py-4 text-center">
                  <button @click="removeItem(idx)" class="text-red-400 hover:text-red-600 p-1.5 rounded-lg hover:bg-red-50 transition-all">
                    <span class="material-symbols-outlined text-[18px]">delete</span>
                  </button>
                </td>
              </tr>
              <tr v-if="form.items.length === 0">
                <td colspan="9" class="px-6 py-14 text-center">
                  <span class="material-symbols-outlined text-5xl block mb-3 text-gray-200">inventory_2</span>
                  <p class="text-sm text-gray-400">Chưa có sản phẩm — Điền thông tin trên và nhấn "Lưu &amp; Thêm SP khác"</p>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- SECTION 4: GHI CHÚ PHIẾU + LƯU PHIẾU -->
        <div class="bg-white rounded-2xl border border-[#C8A97E]/30 shadow-sm p-6 space-y-4">
          <div class="flex items-center gap-2 mb-2">
            <span class="w-6 h-6 rounded-full bg-yellow-600 text-white text-xs font-black flex items-center justify-center">4</span>
            <p class="text-sm font-black text-gray-700 uppercase tracking-wider">Hoàn Tất Phiếu Nhập</p>
          </div>
          <div class="grid grid-cols-2 gap-6 items-end">
            <div class="space-y-1.5">
              <label class="text-xs font-bold text-gray-600">Ghi Chú Phiếu Nhập</label>
              <textarea v-model="form.ghiChu" rows="4"
                placeholder="Ghi chú thêm cho toàn bộ phiếu nhập (tùy chọn)..."
                class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 focus:border-[#C8A97E] transition-all resize-none">
              </textarea>
            </div>
            <div class="space-y-3">
              <div class="flex justify-between items-center py-2 border-b border-gray-100">
                <span class="text-sm text-gray-500">Tổng số lượng</span>
                <span class="font-black text-gray-900">{{ form.items.reduce((s,i) => s + i.qty, 0) }} sp</span>
              </div>
              <div class="flex justify-between items-center py-2 border-b border-gray-100">
                <span class="text-sm text-gray-500">Số dòng sản phẩm</span>
                <span class="font-black text-gray-900">{{ form.items.length }} dòng</span>
              </div>
              <div class="flex justify-between items-center py-2">
                <span class="text-sm font-bold text-gray-700">Tổng giá trị phiếu</span>
                <span class="text-2xl font-black text-yellow-700">{{ fmtCurrency(totalAmount) }}</span>
              </div>
              <button @click="submit"
                :disabled="form.items.length === 0 || !form.maNCC"
                class="w-full py-4 bg-yellow-600 hover:bg-yellow-700 disabled:bg-gray-200 disabled:text-gray-400 disabled:cursor-not-allowed text-white rounded-2xl text-base font-black shadow-lg transition-all transform hover:scale-[1.01] active:scale-95 flex items-center justify-center gap-3">
                <span class="material-symbols-outlined text-[22px]">verified_user</span>
                Lưu Phiếu Nhập
              </button>
            </div>
          </div>
        </div>
      </div>

    </div>
  </Transition>

      <!-- ====== MODAL THÊM/SỬA NCC ====== -->
      <div v-if="showNccModal" class="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4" @click.self="closeNccModal">
        <div class="bg-white w-full max-w-lg rounded-2xl shadow-2xl flex flex-col">
          <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100">
            <h2 class="text-base font-bold text-gray-800">{{ nccForm.maNCC ? 'Sửa Nhà Cung Cấp' : 'Thêm Nhà Cung Cấp Mới' }}</h2>
            <button @click="closeNccModal" class="text-gray-400 hover:text-gray-600 transition-colors p-1 rounded-lg hover:bg-gray-100">
              <span class="material-symbols-outlined">close</span>
            </button>
          </div>
          <div class="p-6 space-y-4">
            <div class="space-y-1.5">
              <label class="text-xs font-semibold text-gray-600">Tên NCC <span class="text-red-500">*</span></label>
              <input v-model="nccForm.tenNCC" placeholder="Nhập tên nhà cung cấp..."
                class="w-full border border-[#C8A97E] rounded-xl px-3 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 transition-all" />
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div class="space-y-1.5">
                <label class="text-xs font-semibold text-gray-600">Số Điện Thoại</label>
                <input v-model="nccForm.soDienThoai" placeholder="0xxx xxx xxx"
                  class="w-full border border-[#C8A97E] rounded-xl px-3 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 transition-all" />
              </div>
              <div class="space-y-1.5">
                <label class="text-xs font-semibold text-gray-600">Email</label>
                <input v-model="nccForm.email" placeholder="email@ncc.com"
                  class="w-full border border-[#C8A97E] rounded-xl px-3 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 transition-all" />
              </div>
            </div>
            <div class="space-y-1.5">
              <label class="text-xs font-semibold text-gray-600">Địa chỉ</label>
              <input v-model="nccForm.diaChi" placeholder="Nhập địa chỉ..."
                class="w-full border border-[#C8A97E] rounded-xl px-3 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 transition-all" />
            </div>
          </div>
          <div class="flex items-center justify-end gap-3 px-6 py-4 border-t border-gray-100 bg-gray-50 rounded-b-2xl">
            <button @click="closeNccModal"
              class="px-5 py-2.5 rounded-xl border border-gray-200 bg-white hover:bg-gray-50 text-sm font-medium text-gray-700 transition-colors">
              Hủy
            </button>
            <button @click="saveNcc"
              class="px-5 py-2.5 rounded-xl bg-yellow-600 hover:bg-yellow-700 text-white text-sm font-semibold shadow-sm transition-colors flex items-center gap-2">
              <span class="material-symbols-outlined text-[18px]">save</span>
              {{ nccForm.maNCC ? 'Cập Nhật' : 'Lưu' }}
            </button>
          </div>
      </div>
    </div>
    
    <!-- ====== MODAL CHI TIẾT PHIẾU NHẬP ====== -->
    <div v-if="showDetailModal && !showModal" class="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4" @click.self="showDetailModal = false">
      <div class="bg-white w-full max-w-3xl rounded-2xl shadow-2xl flex flex-col max-h-[90vh]">
        <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100">
           <div>
             <h2 class="text-base font-bold text-gray-800">Chi Tiết Phiếu Nhập #{{ selectedPhieu?.maPN }}</h2>
             <p class="text-[10px] text-gray-400">Thời gian: {{ selectedPhieu?.ngayNhap ? formatDateTime(selectedPhieu.ngayNhap) : '—' }}</p>
           </div>
           <button @click="showDetailModal = false" class="text-gray-400 hover:text-gray-600 transition-colors p-1 rounded-lg hover:bg-gray-100">
              <span class="material-symbols-outlined">close</span>
           </button>
        </div>
        
        <div class="p-6 overflow-y-auto space-y-6">
           <div class="grid grid-cols-2 gap-4">
              <div class="bg-gray-50 p-4 rounded-xl border border-gray-100">
                 <p class="text-[10px] text-gray-400 uppercase font-black mb-2">Thông tin chung</p>
                 <div class="space-y-1">
                    <p class="text-sm"><b>Nhân viên:</b> {{ selectedPhieu?.nhanVien?.hoTen }}</p>
                    <p class="text-sm"><b>Nhà cung cấp:</b> {{ selectedPhieu?.nhaCungCap?.tenNCC }}</p>
                    <p class="text-sm"><b>Tổng tiền:</b> <span class="text-green-600 font-bold">{{ fmtCurrency(selectedPhieu?.tongTien) }}</span></p>
                 </div>
              </div>
              <div class="bg-gray-50 p-4 rounded-xl border border-gray-100">
                 <p class="text-[10px] text-gray-400 uppercase font-black mb-2">Ghi chú</p>
                 <p class="text-sm text-gray-600 italic">"{{ selectedPhieu?.ghiChu || 'Không có ghi chú' }}"</p>
              </div>
           </div>

           <div class="border border-gray-200 rounded-xl overflow-hidden shadow-sm">
              <table class="w-full text-sm">
                 <thead class="bg-gray-50">
                    <tr>
                       <th class="px-4 py-3 text-left text-xs font-bold text-gray-500">Sản phẩm</th>
                       <th class="px-4 py-3 text-center text-xs font-bold text-gray-500">Size</th>
                       <th class="px-4 py-3 text-center text-xs font-bold text-gray-500">Màu</th>
                       <th class="px-4 py-3 text-center text-xs font-bold text-gray-500">SL</th>
                       <th class="px-4 py-3 text-right text-xs font-bold text-gray-500">Đơn giá</th>
                       <th class="px-4 py-3 text-right text-xs font-bold text-gray-500">Thành tiền</th>
                    </tr>
                 </thead>
                 <tbody class="divide-y divide-gray-100 bg-white">
                    <tr v-for="item in selectedPhieu?.chiTiet" :key="item.maNK_CT">
                       <td class="px-4 py-3 font-medium text-gray-800">{{ item.sanPhamChiTiet?.sanPham?.tenSP }}</td>
                       <td class="px-4 py-3 text-center text-gray-600">{{ item.sanPhamChiTiet?.sizeSP?.tenSize }}</td>
                       <td class="px-4 py-3 text-center text-gray-600">{{ item.sanPhamChiTiet?.mauSacSP?.tenMau }}</td>
                       <td class="px-4 py-3 text-center font-bold text-yellow-700">{{ item.soLuong }}</td>
                       <td class="px-4 py-3 text-right text-gray-500">{{ fmtCurrency(item.donGiaNhap) }}</td>
                       <td class="px-4 py-3 text-right font-black text-green-600">{{ fmtCurrency(item.thanhTien) }}</td>
                    </tr>
                 </tbody>
              </table>
           </div>
        </div>
        
        <div class="px-6 py-4 border-t border-gray-100 bg-gray-50 flex justify-end rounded-b-2xl">
           <button @click="showDetailModal = false" class="px-6 py-2 rounded-xl bg-gray-800 text-white font-bold text-sm hover:bg-black transition-colors shadow-md">Đóng</button>
        </div>
      </div>
    </div>

    <!-- Global Dialog (Alert / Prompt) -->
    <div v-if="dialog.show" class="fixed inset-0 z-[60] bg-black/50 flex items-center justify-center p-4 transition-opacity" @click.self="closeDialog">
      <div class="bg-white w-full max-w-md rounded-2xl shadow-2xl flex flex-col overflow-hidden animate-[pop_0.2s_ease-out]">
        <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100 bg-gray-50/50">
          <h2 class="text-base font-bold" :class="dialog.isError ? 'text-red-600' : 'text-gray-800'">
            {{ dialog.title }}
          </h2>
          <button @click="closeDialog" class="text-gray-400 hover:text-gray-600 transition-colors p-1 rounded-lg hover:bg-gray-100">
            <span class="material-symbols-outlined text-[20px]">close</span>
          </button>
        </div>
        <div class="p-6">
          <p class="text-sm text-gray-700 mb-4">{{ dialog.message }}</p>
          <input v-if="dialog.type === 'prompt'" v-model="dialog.input" @keyup.enter="submitDialog" ref="dialogInputRef"
            class="w-full border border-[#C8A97E]/60 rounded-xl px-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 focus:border-[#C8A97E] transition-all" />
        </div>
        <div class="flex items-center justify-end gap-3 px-6 py-4 border-t border-gray-100 bg-gray-50/50">
          <button v-if="dialog.type === 'prompt' || dialog.type === 'confirm'" @click="closeDialog"
            class="px-5 py-2 rounded-xl text-sm font-medium text-gray-600 bg-white border border-gray-200 hover:bg-gray-50 transition-colors">
            Hủy
          </button>
          <button @click="submitDialog"
            class="px-5 py-2 rounded-xl text-white text-sm font-semibold shadow-sm transition-colors"
            :class="dialog.isError ? 'bg-red-600 hover:bg-red-700' : 'bg-yellow-600 hover:bg-yellow-700'">
            Xác nhận
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { authState } from '@/utils/auth'

export default {
  name: 'InventoryPage',


  data() {
    return {
      activeTab: 'nhap',
      showModal: false,
      showDetailModal: false,
      selectedPhieu: null,
      showNccModal: false,
      nccForm: { maNCC: '', tenNCC: '', soDienThoai: '', email: '', diaChi: '' },
      supplierSearchText: '',
      showSupplierDropdown: false,
      filteredSupplierList: [],
      suppliers: [],
      products: [],
      categories: [],
      brands: [],
      sizes: [],
      colors: [],
      nhanViens: [],
      danhSachPhieu: [],
      lowStock: [],
      totalItems: 0,
      supplierCount: 0,
      activeProducts: 0,
      variantOptions: [],
      filteredProducts: [],
      filterCategory: '',
      filteredProductsList: [],
      categorySearchText: '',
      showCategoryDropdown: false,
      filteredCategoryList: [],
      productSearchText: '',
      showProductDropdown: false,
      brandSearchText: '',
      showBrandDropdown: false,
      filteredBrandList: [],
      isExistingVariant: false,
      timeRanges: [
        { label: 'Tất cả', value: '' },
        { label: 'Hôm nay', value: 'today' },
        { label: 'Tuần này', value: 'week' },
        { label: 'Tháng này', value: 'month' },
        { label: 'Năm nay', value: 'year' },
      ],
      stockRequests: [],
      currentRequestId: null,
      dialog: { show: false, type: 'alert', title: '', message: '', input: '', isError: false, resolve: null },
      filter: { maNCC: '', maNV: '', timeRange: '' },
      form: { maNCC: '', ghiChu: '', items: [] },
      newItem: {
        productId: '', maBienThe: '',
        tenSP: '', categoryId: '', brandId: '', gender: 2, isNewProduct: false,
        sizeRows: [{ size: '', color: '', qty: 1, maBienThe: '', isExisting: false }],
        price: 0, giaBan: 0, moTa: ''
      }
    }
  },

  computed: {
    totalAmount() {
      return this.form.items.reduce((s, i) => s + i.qty * i.price, 0)
    },
    isAdmin() {
      return authState.user?.roles?.includes('ADMIN')
    },
    isStaff() {
      return authState.user?.roles?.includes('NHANVIEN') && !this.isAdmin
    },
    pendingRequestCount() {
       return this.stockRequests.filter(r => r.trangThai === 0).length
    },
    filteredRequests() {
      if (this.isAdmin) return this.stockRequests
      return this.stockRequests.filter(r => r.nhanVien?.maTK === authState.user?.maTK)
    },
    filteredPhieu() {
      let list = [...this.danhSachPhieu]
      if (this.filter.maNCC) list = list.filter(p => p.nhaCungCap?.maNCC == this.filter.maNCC)
      if (this.filter.maNV)  list = list.filter(p => p.nhanVien?.maTK == this.filter.maNV)
      if (this.filter.timeRange) {
        const now = new Date()
        list = list.filter(p => {
          const d = new Date(p.ngayNhap)
          if (this.filter.timeRange === 'today')  return d.toDateString() === now.toDateString()
          if (this.filter.timeRange === 'week')   { const s = new Date(now); s.setDate(now.getDate() - now.getDay()); return d >= s }
          if (this.filter.timeRange === 'month')  return d.getMonth() === now.getMonth() && d.getFullYear() === now.getFullYear()
          if (this.filter.timeRange === 'year')   return d.getFullYear() === now.getFullYear()
          return true
        })
      }
      return list
    }
  },

  async mounted() {
    try {
      const res = await axios.get('/admin/inventory', { withCredentials: true })
      this.suppliers       = res.data.suppliers     || []
      this.filteredSupplierList = this.suppliers
      this.products        = res.data.products      || []
      this.filteredProducts= this.products
      this.filteredProductsList = this.products
      this.categories      = res.data.categories    || []
      this.filteredCategoryList = this.categories
      this.brands          = res.data.brands        || []
      this.filteredBrandList = this.brands
      this.sizes           = res.data.sizes         || []
      this.colors          = res.data.colors        || []
      this.nhanViens       = res.data.nhanViens     || []
      this.danhSachPhieu   = res.data.phieuNhaps    || []
      this.lowStock        = res.data.lowStock      || []
      this.totalItems      = res.data.totalItems    || 0
      this.supplierCount   = res.data.supplierCount || 0
      this.activeProducts  = res.data.activeProducts|| 0
      this.stockRequests   = res.data.stockRequests || []
    } catch (e) { console.error('Lỗi lấy dữ liệu:', e) }
  },

  methods: {
    async showAppDialog({ type = 'alert', title = 'Thông báo', message = '', defaultValue = '', isError = false }) {
       return new Promise((resolve) => {
           this.dialog = {
              show: true,
              type,
              title,
              message,
              input: defaultValue,
              isError,
              resolve
           };
           if (type === 'prompt') {
              this.$nextTick(() => { if (this.$refs.dialogInputRef) this.$refs.dialogInputRef.focus(); });
           }
       });
    },
    closeDialog() {
       if (this.dialog.resolve) this.dialog.resolve(this.dialog.type === 'prompt' ? null : false);
       this.dialog.show = false;
    },
    submitDialog() {
       if (this.dialog.type === 'prompt') {
          if (!this.dialog.input.trim()) {
             if (this.$refs.dialogInputRef) this.$refs.dialogInputRef.focus();
             return;
          }
          this.dialog.resolve(this.dialog.input.trim());
       } else {
          this.dialog.resolve(true); 
       }
       this.dialog.show = false;
    },
    openDetail(phieu) {
       this.selectedPhieu = phieu
       this.showDetailModal = true
    },
    openModal() { this.showModal = true },
    closeModal() { this.showModal = false; this.resetForm() },
    resetForm() {
      this.form = { maNCC: '', ghiChu: '', items: [] }
      this.currentRequestId = null
      this.resetNewItemFields()
    },
    resetNewItemFields() {
      this.newItem = {
        productId: '', maBienThe: '',
        brandId: '', gender: 2, isNewProduct: false,
        sizeRows: [{ size: '', color: '', qty: 1, maBienThe: '', isExisting: false }],
        price: 0, giaBan: 0, moTa: ''
      }
      this.productSearchText = ''
      this.categorySearchText = ''
      this.brandSearchText = ''
      this.filterCategory = ''
      this.variantOptions = []
      this.isExistingVariant = false
      this.showBrandDropdown = false
    },
    filterProductsByCategory() {
      this.filteredProducts = this.filterCategory
        ? this.products.filter(p => p.loaiSanPham?.maLoai == this.filterCategory)
        : this.products
      this.filteredProductsList = this.filteredProducts
      this.productSearchText = ''
      this.newItem.productId = ''
      this.newItem.maBienThe = ''
      this.isExistingVariant = false
      this.variantOptions = []
    },
    filterCategorySearch() {
      this.filterCategory = ''
      this.newItem.categoryId = ''
      if (!this.categorySearchText.trim()) {
         this.filteredCategoryList = this.categories
         this.filterProductsByCategory()
         return
      }
      const lower = this.categorySearchText.toLowerCase()
      this.filteredCategoryList = this.categories.filter(c => c.tenLoai.toLowerCase().includes(lower))
    },
    selectCategory(c) {
      this.filterCategory = c.maLoai
      this.newItem.categoryId = c.maLoai
      this.categorySearchText = c.tenLoai
      this.showCategoryDropdown = false
      this.filterProductsByCategory()
    },
    hideCategoryDropdown() {
       setTimeout(() => { this.showCategoryDropdown = false }, 200)
    },
    filterProducts() {
      this.newItem.productId = '' // Reset ID when typing
      this.newItem.isNewProduct = true
      this.newItem.tenSP = this.productSearchText
      
      if (!this.productSearchText.trim()) {
         this.filteredProductsList = this.filteredProducts
         return
      }
      const lower = this.productSearchText.toLowerCase()
      this.filteredProductsList = this.filteredProducts.filter(p => p.tenSP.toLowerCase().includes(lower))
    },
    selectProduct(p) {
      this.newItem.productId = p.maSP
      this.newItem.tenSP = p.tenSP
      this.newItem.isNewProduct = false
      this.productSearchText = p.tenSP
      
      // Populate metadata from existing product
      this.newItem.categoryId = p.loaiSanPham?.maLoai || ''
      this.categorySearchText = p.loaiSanPham?.tenLoai || ''
      this.newItem.brandId = p.thuongHieu?.maTH || ''
      this.brandSearchText = p.thuongHieu?.tenTH || ''
      this.newItem.gender = p.gioiTinh ?? 2
      this.newItem.moTa = p.moTa || ''
      
      this.showProductDropdown = false
      this.loadVariants()
    },
    hideProductDropdown() {
       setTimeout(() => { this.showProductDropdown = false }, 200)
    },
    filterBrandSearch() {
      if (!this.brandSearchText.trim()) {
         this.filteredBrandList = this.brands
         return
      }
      const lower = this.brandSearchText.toLowerCase()
      this.filteredBrandList = this.brands.filter(b => b.tenTH.toLowerCase().includes(lower))
    },
    selectBrand(b) {
      this.newItem.brandId = b.maTH
      this.brandSearchText = b.tenTH
      this.showBrandDropdown = false
    },
    hideBrandDropdown() {
       setTimeout(() => { this.showBrandDropdown = false }, 200)
    },
    // ===== SUPPLIER SEARCH =====
    filterSupplierSearch() {
      this.form.maNCC = ''
      if (!this.supplierSearchText.trim()) {
        this.filteredSupplierList = this.suppliers
        return
      }
      const lower = this.supplierSearchText.toLowerCase()
      this.filteredSupplierList = this.suppliers.filter(n => n.tenNCC.toLowerCase().includes(lower))
    },
    selectSupplier(ncc) {
      this.form.maNCC = ncc.maNCC
      this.supplierSearchText = ncc.tenNCC
      this.showSupplierDropdown = false
    },
    hideSupplierDropdown() {
      setTimeout(() => { this.showSupplierDropdown = false }, 200)
    },
    // ===== SIZE ROWS =====
    addSizeRow() {
      this.newItem.sizeRows.push({ size: '', color: '', qty: 1, maBienThe: '', isExisting: false })
    },
    removeSizeRow(idx) {
      if (this.newItem.sizeRows.length > 1) this.newItem.sizeRows.splice(idx, 1)
    },
    checkExistingVariantRow(idx) {
      const row = this.newItem.sizeRows[idx]
      row.maBienThe = ''
      row.isExisting = false
      if (this.newItem.productId && row.size && row.color && this.variantOptions.length > 0) {
        const match = this.variantOptions.find(v => v.size === row.size && v.mau === row.color)
        if (match) {
          row.isExisting = true
          row.maBienThe = match.maBienThe
          if (match.giaNhap && !this.newItem.price) this.newItem.price = parseFloat(match.giaNhap)
        }
      }
    },
    async addSupplier() {
       this.openNccModal()
    },
    openNccModal(ncc) {
      if (ncc) {
        this.nccForm = { maNCC: ncc.maNCC, tenNCC: ncc.tenNCC || '', soDienThoai: ncc.soDienThoai || '', email: ncc.email || '', diaChi: ncc.diaChi || '' }
      } else {
        this.nccForm = { maNCC: '', tenNCC: '', soDienThoai: '', email: '', diaChi: '' }
      }
      this.showNccModal = true
    },
    closeNccModal() {
      this.showNccModal = false
      this.nccForm = { maNCC: '', tenNCC: '', soDienThoai: '', email: '', diaChi: '' }
    },
    async saveNcc() {
      if (!this.nccForm.tenNCC.trim()) {
        await this.showAppDialog({ isError: true, message: 'Vui lòng điền đầy đủ thông tin.' }); return
      }
      try {
        if (this.nccForm.maNCC) {
          await axios.put(`/admin/inventory/supplier/${this.nccForm.maNCC}`, this.nccForm, { withCredentials: true })
          await this.showAppDialog({ title: 'Thành công', message: 'Cập nhật nhà cung cấp thành công!' })
        } else {
          await axios.post('/admin/inventory/supplier', this.nccForm, { withCredentials: true })
          await this.showAppDialog({ title: 'Thành công', message: 'Thêm nhà cung cấp thành công!' })
        }
        const res = await axios.get('/admin/inventory', { withCredentials: true })
        this.suppliers = res.data.suppliers || []
        this.supplierCount = res.data.supplierCount || this.suppliers.length
        this.closeNccModal()
      } catch (e) {
        console.error(e)
        await this.showAppDialog({ isError: true, message: 'Lỗi khi lưu nhà cung cấp.' })
      }
    },
    async deleteNcc(ncc) {
      const confirmed = await this.showAppDialog({ type: 'confirm', title: 'Xác nhận xóa', message: `Bạn có chắc chắn muốn xóa nhà cung cấp "${ncc.tenNCC}"?` })
      if (!confirmed) return
      try {
        await axios.delete(`/admin/inventory/supplier/${ncc.maNCC}`, { withCredentials: true })
        await this.showAppDialog({ title: 'Thành công', message: 'Xóa nhà cung cấp thành công!' })
        const res = await axios.get('/admin/inventory', { withCredentials: true })
        this.suppliers = res.data.suppliers || []
        this.supplierCount = res.data.supplierCount || this.suppliers.length
      } catch (e) {
        console.error(e)
        await this.showAppDialog({ isError: true, message: 'Lỗi khi xóa nhà cung cấp.' })
      }
    },
    async addCategory() {
       const newCat = await this.showAppDialog({ type: 'prompt', title: 'Thêm Danh Mục Mới', message: 'Nhập tên danh mục mới:' })
       if(newCat) {
          await this.showAppDialog({ message: 'Chức năng thêm danh mục đang phát triển, sẽ thêm \'' + newCat + '\' vào db sau.' })
       }
    },
    async addNewProductAction() {
       const newProd = await this.showAppDialog({ type: 'prompt', title: 'Thêm Sản Phẩm Mới', message: 'Nhập tên sản phẩm mới nhanh:', defaultValue: this.productSearchText })
       if(newProd) {
          this.productSearchText = newProd
          this.newItem.productId = ''
          this.newItem.tenSP = newProd
          this.newItem.isNewProduct = true
          this.newItem.categoryId = this.filterCategory
       }
    },
    checkExistingVariant() {
       this.isExistingVariant = false
       this.newItem.maBienThe = ''
       if(this.newItem.productId && this.newItem.size && this.newItem.color && this.variantOptions.length > 0) {
          const match = this.variantOptions.find(v => v.size === this.newItem.size && v.mau === this.newItem.color)
          if(match) {
             this.isExistingVariant = true
             this.newItem.maBienThe = match.maBienThe
             this.fillVariantPrice()
          }
       }
    },
    async openDetailedProductModal() {
       await this.showAppDialog({ message: 'Mở form nhập chi tiết đầy đủ cho sản phẩm (mô tả, giới tính, ảnh, SEO...) - Chức năng đang phát triển.' });
    },
    async loadVariants() {
      this.newItem.maBienThe = ''
      this.variantOptions = []
      if (!this.newItem.productId) return
      try {
        const res = await axios.get(`/admin/inventory/variants/${this.newItem.productId}`, { withCredentials: true })
        this.variantOptions = res.data
      } catch (e) { console.error(e) }
    },
    fillVariantPrice() {
      const v = this.variantOptions.find(x => x.maBienThe == this.newItem.maBienThe)
      if (v && v.giaNhap) this.newItem.price = parseFloat(v.giaNhap)
    },
    async addItem() {
      if (!this.newItem.tenSP) {
        await this.showAppDialog({ isError: true, message: 'Vui lòng nhập tên sản phẩm.' }); return
      }
      const validRows = this.newItem.sizeRows.filter(r => r.size && r.color && r.qty >= 1)
      if (validRows.length === 0) {
        await this.showAppDialog({ isError: true, message: 'Vui lòng điền ít nhất một dòng size/màu/số lượng hợp lệ.' }); return
      }

      for (const row of validRows) {
        if (row.isExisting && row.maBienThe) {
          this.form.items.push({
            itemType: 'existing',
            maBienThe: row.maBienThe,
            displayName: this.newItem.tenSP,
            categoryName: this.categorySearchText,
            brandName: this.brandSearchText,
            gender: this.newItem.gender,
            size: row.size,
            color: row.color,
            qty: row.qty,
            price: this.newItem.price,
            ghiChu: ''
          })
        } else {
          this.form.items.push({
            itemType: this.newItem.productId ? 'new_variant' : 'new_product',
            productId: this.newItem.productId,
            tenSP: this.newItem.tenSP,
            categoryId: this.newItem.categoryId,
            categoryName: this.categorySearchText,
            brandId: this.newItem.brandId,
            brandName: this.brandSearchText,
            gender: this.newItem.gender,
            size: row.size,
            color: row.color,
            colorCode: '#000000',
            qty: row.qty,
            price: this.newItem.price,
            giaBan: this.newItem.giaBan || (this.newItem.price * 1.5),
            moTa: this.newItem.moTa || '',
            displayName: this.newItem.tenSP,
            ghiChu: ''
          })
        }
      }
      // Reset product form (keep supplier)
      this.resetNewItemFields()
    },
    removeItem(idx) { this.form.items.splice(idx, 1) },
    fmtCurrency(v) {
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(v || 0)
    },
    formatDateTime(d) {
      if (!d) return '—'
      return new Date(d).toLocaleString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' })
    },
    resetFilter() { this.filter = { maNCC: '', maNV: '', timeRange: '' } },
    async requestStock(item) {
      const qtyStr = await this.showAppDialog({ 
        type: 'prompt', 
        title: 'Yêu cầu nhập hàng', 
        message: `Nhập số lượng bạn muốn yêu cầu cho "${item.tenSP}" (${item.size}, ${item.mau}):`,
        defaultValue: '10'
      })
      if (!qtyStr) return
      const qty = parseInt(qtyStr)
      if (isNaN(qty) || qty < 1) return await this.showAppDialog({ isError: true, message: 'Số lượng không hợp lệ' })

      try {
        await axios.post('/admin/inventory/request', {
          maBienThe: item.maBienThe,
          qty: qty,
          ghiChu: 'Yêu cầu tự động từ màn hình tồn kho thấp'
        }, { withCredentials: true })
        await this.showAppDialog({ title: 'Thành công', message: 'Đã gửi yêu cầu cho Admin.' })
        // Refresh requests
        const res = await axios.get('/admin/inventory', { withCredentials: true })
        this.stockRequests = res.data.stockRequests || []
      } catch (e) { console.error(e) }
    },
    async processRequest(req) {
       this.resetForm()
       this.currentRequestId = req.maYeuCau
       // Pre-fill the modal
       this.form.items.push({
          itemType: 'existing',
          maBienThe: req.sanPhamChiTiet.maBienThe,
          displayName: req.sanPhamChiTiet.sanPham.tenSP,
          size: req.sanPhamChiTiet.sizeSP.tenSize,
          color: req.sanPhamChiTiet.mauSacSP.tenMau,
          qty: req.soLuongYeuCau,
          price: req.sanPhamChiTiet.giaNhap || 0,
          ghiChu: `Nhập hàng theo yêu cầu #${req.maYeuCau} của ${req.nhanVien?.hoTen}`
       })
       this.showModal = true
    },
    async rejectRequest(req) {
       const ok = await this.showAppDialog({ type: 'confirm', message: 'Bạn chắc chắn muốn từ chối yêu cầu nhập hàng này?' })
       if (!ok) return
       try {
          await axios.put(`/admin/inventory/request/${req.maYeuCau}/reject`, {}, { withCredentials: true })
          const res = await axios.get('/admin/inventory', { withCredentials: true })
          this.stockRequests = res.data.stockRequests || []
       } catch (e) { console.error(e) }
    },
    async submit() {
      if (!this.form.maNCC || this.form.items.length === 0) {
        await this.showAppDialog({ isError: true, message: 'Vui lòng điền đầy đủ thông tin.' }); return
      }
      try {
        const payload = { ...this.form, maYeuCau: this.currentRequestId }
        await axios.post('/admin/inventory/import', payload, { withCredentials: true })
        await this.showAppDialog({ title: 'Thành công', message: 'Tạo phiếu thành công!' })
        const res = await axios.get('/admin/inventory', { withCredentials: true })
        this.danhSachPhieu = res.data.phieuNhaps || []
        this.lowStock      = res.data.lowStock   || []
        this.totalItems    = res.data.totalItems || 0
        this.stockRequests = res.data.stockRequests || []
        this.closeModal()
      } catch (e) { console.error(e); await this.showAppDialog({ isError: true, message: 'Lỗi khi lưu phiếu' }) }
    }
  }
}
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 6px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #e5e7eb;
  border-radius: 10px;
}
.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: #d1d5db;
}
</style>
<style scoped>
/* Page Transition (Synchronized with AdminLayout.vue) */
.page-fade-enter-active,
.page-fade-leave-active {
  transition: all 0.3s ease;
}

.page-fade-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

.page-fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

@keyframes pop {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}
</style>
