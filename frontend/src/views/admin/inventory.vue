<template>
  <div class="p-8 space-y-6">

      <!-- TABS -->
      <div class="flex gap-1 bg-gray-100 p-1 rounded-2xl w-fit">
        <button @click="activeTab = 'nhap'"
          :class="activeTab === 'nhap' ? 'bg-white shadow-sm text-yellow-700' : 'text-gray-500 hover:text-gray-700'"
          class="px-6 py-2.5 rounded-xl text-sm font-bold transition-all flex items-center gap-2">
          <span class="material-symbols-outlined text-[20px]">inventory_2</span>
          Nhập Kho
        </button>
        <button @click="activeTab = 'ncc'"
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
          <div class="divide-y divide-gray-100">
            <div v-for="item in lowStock" :key="item.maBienThe"
              class="flex items-center gap-3 px-5 py-3 hover:bg-yellow-50/50 transition-colors">
              <span class="material-symbols-outlined text-yellow-500 text-[20px]">inventory_2</span>
              <div class="flex-1">
                <p class="text-sm font-semibold text-gray-800">{{ item.tenSP }}</p>
                <p class="text-xs text-gray-400">Size: {{ item.size || '—' }} &nbsp;|&nbsp; Màu: {{ item.mau || '—' }}</p>
              </div>
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
          <button @click="openModal"
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
          <select v-model="filter.maNV"
            class="border border-[#C8A97E]/50 rounded-2xl px-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 hover:border-[#C8A97E] transition-all shadow-sm min-w-[160px]">
            <option value="">Tất cả nhân viên</option>
            <option v-for="nv in nhanViens" :key="nv.maTK" :value="nv.maTK">{{ nv.hoTen }}</option>
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
            <button class="w-full mt-4 pt-3 border-t border-gray-100 text-sm font-semibold text-yellow-700 hover:text-yellow-800 transition-colors text-center">
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
      <div v-if="activeTab === 'ncc'" class="space-y-4">
        <!-- Header NCC -->
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
    </div>

    <!-- ====== MODAL TẠO PHIẾU NHẬP ====== -->
    <div v-if="showModal" class="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4" @click.self="closeModal">
      <div class="bg-white w-full max-w-4xl rounded-2xl shadow-2xl max-h-[92vh] flex flex-col">

        <!-- Modal Header -->
        <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100 flex-shrink-0">
          <div>
            <h2 class="text-base font-bold text-gray-800">Tạo Phiếu Nhập Kho</h2>
            <p class="text-xs text-gray-400 mt-0.5">Điền thông tin và thêm sản phẩm cần nhập</p>
          </div>
          <button @click="closeModal" class="text-gray-400 hover:text-gray-600 transition-colors p-1 rounded-lg hover:bg-gray-100">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>

        <!-- Modal Body (scrollable) -->
        <div class="flex-1 overflow-y-auto p-6 space-y-5">

          <!-- Thông tin phiếu -->
          <div class="bg-gray-50 rounded-2xl border border-[#C8A97E]/30 p-4 space-y-4">
            <p class="text-xs font-semibold text-gray-500 uppercase tracking-wider">Thông tin phiếu</p>
            <div class="grid grid-cols-2 gap-4">
              <div class="space-y-1.5">
                <label class="text-xs font-semibold text-gray-600">Nhà Cung Cấp <span class="text-red-500">*</span></label>
                <div class="flex items-center gap-2">
                  <select v-model="form.maNCC"
                    class="w-full border border-[#C8A97E] rounded-2xl px-3 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 transition-all">
                    <option value="">-- Chọn nhà cung cấp --</option>
                    <option v-for="ncc in suppliers" :key="ncc.maNCC" :value="ncc.maNCC">{{ ncc.tenNCC }}</option>
                  </select>
                  <button @click="addSupplier" class="p-2.5 border border-[#C8A97E] rounded-xl bg-yellow-50 text-yellow-700 hover:bg-yellow-100 transition-colors shrink-0" title="Thêm nhà cung cấp mới">
                     <span class="material-symbols-outlined text-sm">add</span>
                  </button>
                </div>
              </div>
              <div class="space-y-1.5">
                <label class="text-xs font-semibold text-gray-600">Ghi Chú</label>
                <input v-model="form.ghiChu" placeholder="Ghi chú phiếu nhập..."
                  class="w-full border border-[#C8A97E] rounded-2xl px-3 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 transition-all" />
              </div>
            </div>
          </div>

          <!-- Thêm sản phẩm -->
          <div class="bg-gray-50 rounded-2xl border border-[#C8A97E]/30 p-4 space-y-4">
            <p class="text-xs font-semibold text-gray-500 uppercase tracking-wider">Thêm Sản Phẩm</p>

            <div class="space-y-4">
              <!-- Category & Product Name Row -->
              <div class="grid grid-cols-2 gap-4">
                <div class="space-y-1.5">
                  <label class="text-xs font-semibold text-gray-600">Danh Mục (Thêm mới/Chọn)</label>
                  <div class="flex items-center gap-2">
                    <div class="relative w-full">
                      <input 
                        v-model="categorySearchText" 
                        @focus="showCategoryDropdown = true"
                        @blur="hideCategoryDropdown"
                        @input="filterCategorySearch"
                        placeholder="-- Chọn danh mục --"
                        class="w-full border border-[#C8A97E] rounded-xl px-3 py-2 border-r-0 rounded-r-none text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30"
                      />
                      <button @click="showCategoryDropdown = !showCategoryDropdown" class="absolute right-0 top-0 bottom-0 px-2 border border-[#C8A97E] border-l-0 rounded-r-xl bg-gray-50 text-gray-500 hover:bg-gray-100 flex items-center justify-center">
                        <span class="material-symbols-outlined text-lg">arrow_drop_down</span>
                      </button>

                      <div v-if="showCategoryDropdown" class="absolute z-10 w-full mt-1 bg-white border border-[#C8A97E] rounded-xl shadow-lg max-h-48 overflow-y-auto">
                        <div v-if="filteredCategoryList.length === 0" class="p-2 text-sm text-gray-500 text-center">Không tìm thấy danh mục.</div>
                         <div 
                           v-for="c in filteredCategoryList" 
                           :key="c.maLoai" 
                           @mousedown.prevent="selectCategory(c)"
                           class="px-3 py-2 text-sm hover:bg-yellow-50 cursor-pointer text-gray-800"
                           :class="{'font-bold text-yellow-700 bg-yellow-50': filterCategory === c.maLoai}"
                         >
                            {{ c.tenLoai }}
                         </div>
                      </div>
                    </div>
                    <button @click="addCategory" class="p-2 border border-[#C8A97E] rounded-xl bg-yellow-50 text-yellow-700 hover:bg-yellow-100 transition-colors shrink-0" title="Thêm danh mục mới">
                      <span class="material-symbols-outlined text-sm">add</span>
                    </button>
                  </div>
                </div>
                <div class="space-y-1.5 relative">
                  <label class="text-xs font-semibold text-gray-600">Tên Sản Phẩm (Đánh chữ để tìm kiếm hoặc thêm mới) <span class="text-red-500">*</span></label>
                  <div class="flex items-center gap-2">
                    <div class="relative w-full">
                       <!-- custom combo box replacement -->
                      <input 
                        v-model="productSearchText" 
                        @focus="showProductDropdown = true"
                        @blur="hideProductDropdown"
                        @input="filterProducts"
                        placeholder="-- Gõ tên sản phẩm... --"
                        class="w-full border border-[#C8A97E] rounded-xl px-3 py-2 border-r-0 rounded-r-none text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30"
                      />
                      <button @click="showProductDropdown = !showProductDropdown" class="absolute right-0 top-0 bottom-0 px-2 border border-[#C8A97E] border-l-0 rounded-r-xl bg-gray-50 text-gray-500 hover:bg-gray-100 flex items-center justify-center">
                        <span class="material-symbols-outlined text-lg">arrow_drop_down</span>
                      </button>

                      <div v-if="showProductDropdown" class="absolute z-10 w-full mt-1 bg-white border border-[#C8A97E] rounded-xl shadow-lg max-h-48 overflow-y-auto">
                        <div v-if="filteredProductsList.length === 0" class="p-2 text-sm text-gray-500 text-center">Không tìm thấy sản phẩm. Bạn có thể thêm mới.</div>
                         <div 
                           v-for="p in filteredProductsList" 
                           :key="p.maSP" 
                           @mousedown.prevent="selectProduct(p)"
                           class="px-3 py-2 text-sm hover:bg-yellow-50 cursor-pointer text-gray-800"
                           :class="{'font-bold text-yellow-700 bg-yellow-50': newItem.productId === p.maSP}"
                         >
                            {{ p.tenSP }}
                         </div>
                      </div>
                    </div>
                    <button @click="addNewProductAction" class="p-2 border border-[#C8A97E] rounded-xl bg-yellow-50 text-yellow-700 hover:bg-yellow-100 transition-colors" title="Thêm thông tin chung sản phẩm">
                      <span class="material-symbols-outlined text-sm">add</span>
                    </button>
                  </div>
                </div>
              </div>

              <!-- Product Details Configuration Row (Always visible now to define Variants) -->
              <div class="grid grid-cols-4 gap-3 bg-yellow-50/30 p-3 rounded-xl border border-yellow-100">
                <div class="space-y-1.5 flex flex-col justify-end">
                  <label class="text-xs font-semibold text-gray-600">Size <span class="text-red-500">*</span></label>
                  <select v-model="newItem.size" @change="checkExistingVariant" class="w-full border border-[#C8A97E] rounded-xl px-2.5 h-[42px] text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30">
                    <option value="">-- Chọn size --</option>
                    <option v-for="s in sizes" :key="s.maSize" :value="s.tenSize">{{ s.tenSize }}</option>
                  </select>
                </div>
                <div class="space-y-1.5 flex flex-col justify-end">
                  <label class="text-xs font-semibold text-gray-600">Màu Sắc <span class="text-red-500">*</span></label>
                  <div class="flex items-center gap-1 w-full h-[42px]">
                     <select v-model="newItem.color" @change="checkExistingVariant" class="flex-1 border border-[#C8A97E] rounded-xl px-2.5 h-full text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 truncate">
                        <option value="">-- Chọn màu --</option>
                        <option v-for="m in colors" :key="m.maMau" :value="m.tenMau">{{ m.tenMau }}</option>
                     </select>
                     <!-- Optional strict color picker -->
                     <input type="color" v-model="newItem.colorCode" class="w-10 h-full rounded-lg border border-[#C8A97E] cursor-pointer shrink-0" title="Phối màu (tùy chọn)"/>
                  </div>
                </div>

                <div class="space-y-1.5 flex flex-col justify-end">
                  <label class="text-xs font-semibold text-gray-600">Số Lượng <span class="text-red-500">*</span></label>
                  <input type="number" v-model.number="newItem.qty" min="1"
                    class="w-full border border-[#C8A97E] rounded-xl px-3 h-[42px] text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30" />
                </div>
                <div class="space-y-1.5 flex flex-col justify-end">
                  <label class="text-xs font-semibold text-gray-600">Giá Nhập <span class="text-red-500">*</span></label>
                  <input type="number" v-model.number="newItem.price" min="0" step="1000"
                    class="w-full border border-[#C8A97E] rounded-xl px-3 h-[42px] text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30" />
                </div>
              </div>

               <div v-if="isExistingVariant" class="text-xs font-bold text-green-600 flex items-center gap-1 bg-green-50 px-3 py-2 rounded-xl border border-green-200">
                  <span class="material-symbols-outlined text-sm">check_circle</span>
                  Sản phẩm đã tồn tại trong kho (Có thể cập nhật giá/số lượng)
               </div>
               <div v-else-if="newItem.productId && newItem.size && newItem.color" class="text-xs font-bold text-blue-600 flex items-center gap-1 bg-blue-50 px-3 py-2 rounded-xl border border-blue-200">
                  <span class="material-symbols-outlined text-sm">info</span>
                  Biến thể mới sẽ được tạo cho sản phẩm này
               </div>

              <div class="flex items-center justify-between pt-2">
                 <div class="text-sm font-bold text-gray-700">
                    Thành Tiền: <span class="text-yellow-700">{{ fmtCurrency(newItem.qty * newItem.price) }}</span>
                 </div>
                 
               <div class="flex gap-2">
                    <button @click="openDetailedProductModal" class="flex items-center gap-1 bg-white border-2 border-yellow-600 text-yellow-700 px-4 py-2 rounded-xl text-sm font-bold hover:bg-yellow-50 transition-colors">
                      <span class="material-symbols-outlined text-[18px]">post_add</span>
                      Thêm Phiếu Thông Tin Sản Phẩm
                    </button>
                    <button @click="addItem"
                      class="flex items-center gap-2 bg-yellow-600 hover:bg-yellow-700 text-white px-5 py-2 rounded-xl text-sm font-semibold shadow-sm transition-colors">
                      <span class="material-symbols-outlined text-[18px]">add_task</span>
                      Thêm vào phiếu
                    </button>
                 </div>
              </div>
            </div>
            
            <!-- Ghi chú dòng -->
            <p v-if="form.items.length > 0" class="text-xs text-gray-400 italic mt-2">* Bạn có thể thêm ghi chú cho từng sản phẩm trong bảng bên dưới.</p>
          </div>

          <!-- Bảng sản phẩm trong phiếu -->
          <div v-if="form.items.length > 0" class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm overflow-hidden">
            <div class="px-4 py-3 bg-gray-50 border-b border-gray-200">
              <p class="text-xs font-semibold text-gray-500 uppercase tracking-wider">Danh sách sản phẩm trong phiếu</p>
            </div>
            <table class="w-full text-sm">
              <thead class="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">#</th>
                  <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Sản phẩm</th>
                  <th class="px-4 py-3 text-center text-xs font-semibold text-gray-500 uppercase">Size</th>
                  <th class="px-4 py-3 text-center text-xs font-semibold text-gray-500 uppercase">Màu</th>
                  <th class="px-4 py-3 text-center text-xs font-semibold text-gray-500 uppercase">SL</th>
                  <th class="px-4 py-3 text-right text-xs font-semibold text-gray-500 uppercase">Giá nhập</th>
                  <th class="px-4 py-3 text-right text-xs font-semibold text-gray-500 uppercase">Thành tiền</th>
                  <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase">Ghi chú</th>
                  <th class="px-4 py-3"></th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-100">
                <tr v-for="(item, idx) in form.items" :key="idx" class="hover:bg-yellow-50/50 transition-colors">
                  <td class="px-4 py-3 text-gray-500 text-xs">{{ idx + 1 }}</td>
                  <td class="px-4 py-3 font-semibold text-gray-800">{{ item.displayName }}</td>
                  <td class="px-4 py-3 text-center text-gray-600">{{ item.size || '—' }}</td>
                  <td class="px-4 py-3 text-center text-gray-600">{{ item.color || '—' }}</td>
                  <td class="px-4 py-3 text-center font-bold">{{ item.qty }}</td>
                  <td class="px-4 py-3 text-right text-gray-600">{{ fmtCurrency(item.price) }}</td>
                  <td class="px-4 py-3 text-right font-bold text-gray-800">{{ fmtCurrency(item.qty * item.price) }}</td>
                  <td class="px-4 py-3 min-w-[120px]">
                    <input v-model="item.ghiChu" placeholder="Ghi chú..."
                      class="w-full border border-gray-200 rounded-xl px-2.5 py-1.5 text-xs focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 focus:border-[#C8A97E]" />
                  </td>
                  <td class="px-4 py-3 text-center">
                    <button @click="removeItem(idx)" class="text-red-400 hover:text-red-600 p-1 rounded-lg hover:bg-red-50 transition-all">
                      <span class="material-symbols-outlined text-[18px]">delete</span>
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Modal Footer -->
        <div class="flex items-center justify-between px-6 py-4 border-t border-gray-100 bg-gray-50 rounded-b-2xl flex-shrink-0">
          <div class="text-sm font-bold text-gray-800">
            Tổng tiền: <span class="text-yellow-700 text-base">{{ fmtCurrency(totalAmount) }}</span>
          </div>
          <div class="flex gap-3">
            <button @click="closeModal"
              class="px-5 py-2.5 rounded-xl border border-gray-200 bg-white hover:bg-gray-50 text-sm font-medium text-gray-700 transition-colors">
              Hủy
            </button>
            <button @click="submit"
              class="px-5 py-2.5 rounded-xl bg-yellow-600 hover:bg-yellow-700 text-white text-sm font-semibold shadow-sm transition-colors flex items-center gap-2">
              <span class="material-symbols-outlined text-[18px]">save</span>
              Lưu Phiếu
            </button>
          </div>
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

</template>

<script>
import axios from 'axios'

export default {
  name: 'InventoryPage',


  data() {
    return {
      activeTab: 'nhap',
      showModal: false,
      showNccModal: false,
      nccForm: { maNCC: '', tenNCC: '', soDienThoai: '', email: '', diaChi: '' },
      suppliers: [],
      products: [],
      categories: [],
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
      isExistingVariant: false,
      timeRanges: [
        { label: 'Tất cả', value: '' },
        { label: 'Hôm nay', value: 'today' },
        { label: 'Tuần này', value: 'week' },
        { label: 'Tháng này', value: 'month' },
        { label: 'Năm nay', value: 'year' },
      ],
      dialog: { show: false, type: 'alert', title: '', message: '', input: '', isError: false, resolve: null },
      filter: { maNCC: '', maNV: '', timeRange: '' },
      form: { maNCC: '', ghiChu: '', items: [] },
      newItem: {
        productId: '', maBienThe: '',
        tenSP: '', categoryId: '', gender: 2, isNewProduct: false,
        size: '', color: '', colorCode: '#000000',
        qty: 1, price: 0, giaBan: 0
      }
    }
  },

  computed: {
    totalAmount() {
      return this.form.items.reduce((s, i) => s + i.qty * i.price, 0)
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
      this.products        = res.data.products      || []
      this.filteredProducts= this.products
      this.filteredProductsList = this.products
      this.categories      = res.data.categories    || []
      this.filteredCategoryList = this.categories
      this.sizes           = res.data.sizes         || []
      this.colors          = res.data.colors        || []
      this.nhanViens       = res.data.nhanViens     || []
      this.danhSachPhieu   = res.data.phieuNhaps    || []
      this.lowStock        = res.data.lowStock      || []
      this.totalItems      = res.data.totalItems    || 0
      this.supplierCount   = res.data.supplierCount || 0
      this.activeProducts  = res.data.activeProducts|| 0
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
    openModal() { this.showModal = true },
    closeModal() { this.showModal = false; this.resetForm() },
    resetForm() {
      this.form = { maNCC: '', ghiChu: '', items: [] }
      this.resetNewItemFields()
    },
    resetNewItemFields() {
      this.newItem = {
        productId: '', maBienThe: '',
        tenSP: '', categoryId: '', gender: 2, isNewProduct: false,
        size: '', color: '', colorCode: '#000000',
        qty: 1, price: 0, giaBan: 0
      }
      this.productSearchText = ''
      this.categorySearchText = ''
      this.filterCategory = ''
      this.variantOptions = []
      this.isExistingVariant = false
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
      this.filterCategory = p.loaiSanPham?.maLoai || this.filterCategory
      this.showProductDropdown = false
      this.loadVariants()
    },
    hideProductDropdown() {
       setTimeout(() => { this.showProductDropdown = false }, 200)
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
      if (!this.newItem.tenSP || !this.newItem.size || !this.newItem.color || !this.newItem.qty || this.newItem.qty < 1) {
        await this.showAppDialog({ isError: true, message: 'Vui lòng điền đầy đủ thông tin.' }); return
      }

      // If we matched an existing variant
      if (this.isExistingVariant && this.newItem.maBienThe) {
        this.form.items.push({
          itemType: 'existing',
          maBienThe: this.newItem.maBienThe,
          displayName: this.newItem.tenSP,
          size: this.newItem.size,
          color: this.newItem.color,
          qty: this.newItem.qty,
          price: this.newItem.price,
          ghiChu: ''
        })
      } else {
        // Prepare to create NEW Variant (and optionally New Product if no productId)
        this.form.items.push({
          itemType: this.newItem.productId ? 'new_variant' : 'new_product',
          productId: this.newItem.productId, // Null if completely new product
          tenSP: this.newItem.tenSP,
          categoryId: this.filterCategory || this.newItem.categoryId,
          gender: this.newItem.gender,
          size: this.newItem.size, 
          color: this.newItem.color,
          colorCode: this.newItem.colorCode,
          qty: this.newItem.qty,
          price: this.newItem.price,
          giaBan: this.newItem.giaBan || (this.newItem.price * 1.5), // Estimate
          displayName: this.newItem.tenSP,
          ghiChu: ''
        })
      }
      // Khong reset toan bo nua ma chi reset bien the
      this.newItem.size = '';
      this.newItem.color = '';
      this.newItem.qty = 1;
      this.newItem.price = 0;
      this.isExistingVariant = false;
      this.newItem.maBienThe = '';
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
    async submit() {
      if (!this.form.maNCC || this.form.items.length === 0) {
        await this.showAppDialog({ isError: true, message: 'Vui lòng điền đầy đủ thông tin.' }); return
      }
      try {
        await axios.post('/admin/inventory/import', this.form, { withCredentials: true })
        await this.showAppDialog({ title: 'Thành công', message: 'Tạo phiếu thành công!' })
        const res = await axios.get('/admin/inventory', { withCredentials: true })
        this.danhSachPhieu = res.data.phieuNhaps || []
        this.lowStock      = res.data.lowStock   || []
        this.totalItems    = res.data.totalItems || 0
        this.closeModal()
      } catch (e) { console.error(e); await this.showAppDialog({ isError: true, message: 'Lỗi khi lưu phiếu' }) }
    }
  }
}
</script>