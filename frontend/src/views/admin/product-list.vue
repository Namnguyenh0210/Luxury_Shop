<template>
  <AdminLayout page-title="Quản Lý Sản Phẩm & Danh Mục">
    <div class="w-full mx-auto p-8 space-y-6">
      
      <!-- NAVIGATION TABS -->
      <div class="flex gap-1 bg-gray-100 p-1 rounded-2xl w-fit">
        <button 
          @click="activeTab = 'products'"
          :class="activeTab === 'products' ? 'bg-white shadow-sm text-yellow-700' : 'text-gray-500 hover:text-gray-700'"
          class="px-6 py-2.5 rounded-xl text-sm font-bold transition-all flex items-center gap-2"
        >
          <span class="material-symbols-outlined text-[20px]">inventory_2</span>
          Sản phẩm
        </button>
        <button 
          @click="activeTab = 'categories'"
          :class="activeTab === 'categories' ? 'bg-white shadow-sm text-yellow-700' : 'text-gray-500 hover:text-gray-700'"
          class="px-6 py-2.5 rounded-xl text-sm font-bold transition-all flex items-center gap-2"
        >
          <span class="material-symbols-outlined text-[20px]">category</span>
          Danh mục
        </button>
        <button 
          @click="activeTab = 'brands'"
          :class="activeTab === 'brands' ? 'bg-white shadow-sm text-yellow-700' : 'text-gray-500 hover:text-gray-700'"
          class="px-6 py-2.5 rounded-xl text-sm font-bold transition-all flex items-center gap-2"
        >
          <span class="material-symbols-outlined text-[20px]">diamond</span>
          Thương hiệu
        </button>
      </div>

      <!-- PRODUCT TAB -->
      <div v-if="activeTab === 'products'" class="space-y-6">
        <!-- ACTION BAR -->
          <div class="flex items-center gap-4 flex-wrap">
            <!-- Tìm kiếm -->
            <div class="relative">
              <span class="absolute inset-y-0 left-3 flex items-center text-gray-400">
                <span class="material-symbols-outlined text-[20px]">search</span>
              </span>
              <input
                v-model="filters.keyword"
                @input="fetchProducts"
                placeholder="Tìm sản phẩm..."
                class="border border-[#C8A97E]/50 rounded-2xl pl-10 pr-4 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 hover:border-[#C8A97E] transition-all w-64 shadow-sm"
              />
            </div>

            <!-- Custom Category Dropdown -->
            <div class="relative min-w-[190px]">
              <button @click.stop="openDropdown = openDropdown === 'category' ? null : 'category'"
                class="w-full border border-[#C8A97E]/50 rounded-2xl pl-4 pr-10 py-2.5 text-sm bg-white text-left focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 hover:border-[#C8A97E] transition-all flex items-center justify-between shadow-sm">
                <span class="truncate font-medium text-gray-700">{{ categories.find(c => c.maLoai === filters.categoryId)?.tenLoai || 'Tất cả danh mục' }}</span>
                <span class="material-symbols-outlined text-[20px] absolute right-3 text-[#C8A97E]">expand_more</span>
              </button>
              <div v-if="openDropdown === 'category'" @click.stop class="absolute z-50 w-full mt-2 bg-white border border-[#C8A97E]/30 rounded-2xl shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-200">
                <div @click="filters.categoryId = ''; fetchProducts(); openDropdown = null" 
                  class="px-4 py-3 text-sm cursor-pointer transition-colors border-b border-gray-50 bg-yellow-50/30" 
                  :class="!filters.categoryId ? 'font-bold text-[#C8A97E]' : 'text-gray-500 hover:bg-[#C8A97E]/10'">
                  Tất cả danh mục
                </div>
                <div class="max-h-60 overflow-y-auto custom-scrollbar">
                  <div v-for="c in categories" :key="c.maLoai" @click="filters.categoryId = c.maLoai; fetchProducts(); openDropdown = null" 
                    class="px-4 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="filters.categoryId === c.maLoai ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">
                    {{ c.tenLoai }}
                  </div>
                </div>
              </div>
            </div>

            <!-- Custom Brand Dropdown -->
            <div class="relative min-w-[190px]">
              <button @click.stop="openDropdown = openDropdown === 'brand' ? null : 'brand'"
                class="w-full border border-[#C8A97E]/50 rounded-2xl pl-4 pr-10 py-2.5 text-sm bg-white text-left focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 hover:border-[#C8A97E] transition-all flex items-center justify-between shadow-sm">
                <span class="truncate font-medium text-gray-700">{{ brands.find(b => b.maTH === filters.brandId)?.tenTH || 'Tất cả thương hiệu' }}</span>
                <span class="material-symbols-outlined text-[20px] absolute right-3 text-[#C8A97E]">expand_more</span>
              </button>
              <div v-if="openDropdown === 'brand'" @click.stop class="absolute z-50 w-full mt-2 bg-white border border-[#C8A97E]/30 rounded-2xl shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-200">
                <div @click="filters.brandId = ''; fetchProducts(); openDropdown = null" 
                  class="px-4 py-3 text-sm cursor-pointer transition-colors border-b border-gray-50 bg-yellow-50/30" 
                  :class="!filters.brandId ? 'font-bold text-[#C8A97E]' : 'text-gray-500 hover:bg-[#C8A97E]/10'">
                  Tất cả thương hiệu
                </div>
                <div class="max-h-60 overflow-y-auto custom-scrollbar">
                  <div v-for="b in brands" :key="b.maTH" @click="filters.brandId = b.maTH; fetchProducts(); openDropdown = null" 
                    class="px-4 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="filters.brandId === b.maTH ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">
                    {{ b.tenTH }}
                  </div>
                </div>
              </div>
            </div>

            <!-- Custom Gender Dropdown -->
            <div class="relative min-w-[170px]">
              <button @click.stop="openDropdown = openDropdown === 'gender' ? null : 'gender'"
                class="w-full border border-[#C8A97E]/50 rounded-2xl pl-4 pr-10 py-2.5 text-sm bg-white text-left focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 hover:border-[#C8A97E] transition-all flex items-center justify-between shadow-sm">
                <span class="truncate font-medium text-gray-700">{{ filters.gioiTinh === '0' ? 'Nam' : filters.gioiTinh === '1' ? 'Nữ' : filters.gioiTinh === '2' ? 'Unisex' : 'Tất cả giới tính' }}</span>
                <span class="material-symbols-outlined text-[20px] absolute right-3 text-[#C8A97E]">expand_more</span>
              </button>
              <div v-if="openDropdown === 'gender'" @click.stop class="absolute z-50 w-full mt-2 bg-white border border-[#C8A97E]/30 rounded-2xl shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-200">
                <div @click="filters.gioiTinh = ''; fetchProducts(); openDropdown = null" 
                  class="px-4 py-3 text-sm cursor-pointer transition-colors border-b border-gray-50 bg-yellow-50/30" 
                  :class="!filters.gioiTinh ? 'font-bold text-[#C8A97E]' : 'text-gray-500 hover:bg-[#C8A97E]/10'">
                  Tất cả giới tính
                </div>
                <div @click="filters.gioiTinh = '0'; fetchProducts(); openDropdown = null" class="px-4 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="filters.gioiTinh === '0' ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">Nam</div>
                <div @click="filters.gioiTinh = '1'; fetchProducts(); openDropdown = null" class="px-4 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="filters.gioiTinh === '1' ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">Nữ</div>
                <div @click="filters.gioiTinh = '2'; fetchProducts(); openDropdown = null" class="px-4 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="filters.gioiTinh === '2' ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">Unisex</div>
              </div>
            </div>

            <!-- Custom Status Dropdown -->
            <div class="relative min-w-[170px]">
              <button @click.stop="openDropdown = openDropdown === 'status' ? null : 'status'"
                class="w-full border border-[#C8A97E]/50 rounded-2xl pl-4 pr-10 py-2.5 text-sm bg-white text-left focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 hover:border-[#C8A97E] transition-all flex items-center justify-between shadow-sm">
                <span class="truncate font-medium text-gray-700">{{ filters.status === '1' ? 'Đang bán' : filters.status === '0' ? 'Ngừng bán' : 'Tất cả trạng thái' }}</span>
                <span class="material-symbols-outlined text-[20px] absolute right-3 text-[#C8A97E]">expand_more</span>
              </button>
              <div v-if="openDropdown === 'status'" @click.stop class="absolute z-50 w-full mt-2 bg-white border border-[#C8A97E]/30 rounded-2xl shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-200">
                <div @click="filters.status = ''; fetchProducts(); openDropdown = null" 
                  class="px-4 py-3 text-sm cursor-pointer transition-colors border-b border-gray-50 bg-yellow-50/30" 
                  :class="!filters.status ? 'font-bold text-[#C8A97E]' : 'text-gray-500 hover:bg-[#C8A97E]/10'">
                  Tất cả trạng thái
                </div>
                <div @click="filters.status = '1'; fetchProducts(); openDropdown = null" class="px-4 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="filters.status === '1' ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">Đang bán</div>
                <div @click="filters.status = '0'; fetchProducts(); openDropdown = null" class="px-4 py-2.5 text-sm hover:bg-[#C8A97E]/10 cursor-pointer transition-colors text-gray-600" :class="filters.status === '0' ? 'bg-[#C8A97E]/10 font-bold text-[#C8A97E]' : ''">Ngừng bán</div>
              </div>
            </div>

            <!-- Nút Làm mới -->
            <button @click="resetFilters" 
              class="flex items-center justify-center size-10 rounded-2xl border border-[#C8A97E]/30 bg-white text-[#C8A97E] hover:bg-[#C8A97E] hover:text-white transition-all shadow-sm group"
              title="Làm mới bộ lọc">
              <span class="material-symbols-outlined text-[22px] group-hover:rotate-180 transition-transform duration-500">refresh</span>
            </button>
          </div>

        <!-- PRODUCT TABLE -->
        <div class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm overflow-hidden">
          <table class="w-full text-sm border-collapse" style="table-layout: fixed;">
            <thead class="bg-gray-50 border-b border-gray-200">
              <tr>
                <th class="px-4 py-4 text-xs font-semibold text-gray-500 uppercase w-[5%] text-center">ID</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-left w-[25%]">Tên Sản Phẩm</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[12%]">Phân Loại</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[12%]">Thương Hiệu</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[10%]">Giới Tính</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[10%]">Số lượng</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[12%]">Trạng Thái</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[14%]">Hành Động</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr v-for="p in products" :key="p.id" class="hover:bg-yellow-50/50 transition-colors cursor-pointer" @click="openDetails(p.maSP)">
                <td class="px-4 py-4 font-mono text-xs text-gray-500 text-center">#{{ p.maSP }}</td>
                <td class="px-6 py-4 font-semibold text-gray-800 text-left truncate">{{ p.tenSP }}</td>
                <td class="px-6 py-4 text-gray-600 text-center truncate">{{ p.loaiSanPham?.tenLoai }}</td>
                <td class="px-6 py-4 text-gray-600 text-center truncate">{{ p.thuongHieu?.tenTH }}</td>
                <td class="px-6 py-4 text-center">
                  <span class="px-2 py-1 rounded-lg bg-gray-100 text-[11px] font-bold text-gray-600">
                    {{ p.gioiTinh === 0 ? 'Nam' : p.gioiTinh === 1 ? 'Nữ' : 'Unisex' }}
                  </span>
                </td>
                <td class="px-6 py-4 text-center">
                  <span :class="p.totalStock < 10 ? 'text-red-600 font-black animate-pulse' : 'text-gray-800 font-bold'">
                    {{ p.totalStock }}
                  </span>
                </td>
                <td class="px-6 py-4 text-center">
                  <span class="inline-flex items-center px-2.5 py-1 text-xs font-medium rounded-full"
                    :class="p.trangThaiSP == 1 ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'">
                    <span class="size-1.5 rounded-full mr-1.5" :class="p.trangThaiSP == 1 ? 'bg-green-500' : 'bg-red-500'"></span>
                    {{ p.trangThaiSP == 1 ? 'Đang bán' : 'Ngừng bán' }}
                  </span>
                </td>
                <td class="px-6 py-4" @click.stop>
                  <div class="flex justify-center gap-2">
                    <button @click="toggleStatus(p)" class="p-2 rounded-lg hover:bg-gray-100 text-gray-600 transition-all" :title="p.trangThaiSP == 1 ? 'Ẩn sản phẩm' : 'Hiện sản phẩm'">
                      <span class="material-symbols-outlined text-[20px]">
                        {{ p.trangThaiSP == 1 ? 'visibility' : 'visibility_off' }}
                      </span>
                    </button>
                    <button @click="editProduct(p)" class="p-2 rounded-lg hover:bg-yellow-50 text-yellow-700 transition-all" title="Sửa">
                      <span class="material-symbols-outlined text-[20px]">edit</span>
                    </button>
                    <button @click="deleteProduct(p.maSP)" class="p-2 rounded-lg hover:bg-red-50 text-red-600 transition-all" title="Xóa">
                      <span class="material-symbols-outlined text-[20px]">delete</span>
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <div v-if="products.length === 0" class="flex flex-col items-center justify-center py-16 text-gray-400">
            <span class="material-symbols-outlined text-5xl mb-3">inventory_2</span>
            <p class="text-sm">Không có sản phẩm nào</p>
          </div>
        </div>
      </div>

      <!-- CATEGORY TAB -->
      <div v-else-if="activeTab === 'categories'" class="space-y-6">
        <!-- ACTION BAR -->
        <div class="flex justify-end hidden">
          <button @click="openCategoryModal()" class="flex items-center gap-2 px-6 py-2.5 bg-yellow-400 hover:bg-yellow-500 text-yellow-900 font-bold rounded-xl shadow-lg shadow-yellow-100 transition-all">
            <span class="material-symbols-outlined text-[20px]">add_circle</span>
            Thêm danh mục
          </button>
        </div>

        <!-- CATEGORY TABLE -->
        <div class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm overflow-hidden">
          <table class="w-full text-sm border-collapse" style="table-layout: fixed;">
            <thead class="bg-gray-50 border-b border-gray-200">
              <tr>
                <th class="px-4 py-4 text-xs font-semibold text-gray-500 uppercase w-[10%] text-center">ID</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-left w-[20%]">Tên danh mục</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[10%] text-blue-600">SP Nam</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[10%] text-pink-600">SP Nữ</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[10%] text-gray-600">Unisex</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-left w-[20%]">Mô tả</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[10%]">Trạng thái</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[10%]">Hành động</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr v-for="c in categories" :key="c.maLoai" class="hover:bg-yellow-50/50 transition-colors cursor-pointer" @click="openCategoryModal(c)">
                <td class="px-4 py-4 font-mono text-xs text-gray-500 text-center">#{{ c.maLoai }}</td>
                <td class="px-6 py-4 font-bold text-gray-800 text-left truncate">{{ c.tenLoai }}</td>
                <td class="px-6 py-4 text-center font-bold text-blue-600">{{ c.countNam || 0 }}</td>
                <td class="px-6 py-4 text-center font-bold text-pink-600">{{ c.countNu || 0 }}</td>
                <td class="px-6 py-4 text-center font-bold text-gray-600">{{ c.countUnisex || 0 }}</td>
                <td class="px-6 py-4 text-gray-500 italic text-left text-xs truncate pr-4">{{ c.moTa || 'Chưa có mô tả' }}</td>
                <td class="px-6 py-4 text-center">
                  <span class="inline-flex items-center px-2.5 py-1 text-[10px] font-bold rounded-full"
                    :class="c.trangThai == 1 ? 'bg-blue-50 text-blue-600' : 'bg-gray-100 text-gray-500'">
                    {{ c.trangThai == 1 ? 'Hiển thị' : 'Đang ẩn' }}
                  </span>
                </td>
                <td class="px-6 py-4 text-center" @click.stop>
                   <div class="flex justify-center gap-2">
                    <button @click="toggleCategoryStatus(c)" class="p-2 rounded-lg hover:bg-gray-100 text-gray-600 transition-all" :title="c.trangThai == 1 ? 'Ẩn danh mục' : 'Hiện danh mục'">
                      <span class="material-symbols-outlined text-[20px]">
                        {{ c.trangThai == 1 ? 'visibility' : 'visibility_off' }}
                      </span>
                    </button>
                    <button @click="openCategoryModal(c)" class="p-2 rounded-lg hover:bg-blue-50 text-blue-600 transition-all" title="Sửa">
                      <span class="material-symbols-outlined text-[20px]">edit</span>
                    </button>
                    <button @click="deleteCategory(c.maLoai)" class="p-2 rounded-lg hover:bg-red-50 text-red-600 transition-all" title="Xóa">
                      <span class="material-symbols-outlined text-[20px]">delete</span>
                    </button>
                   </div>
                </td>
              </tr>
            </tbody>
          </table>
          <div v-if="categories.length === 0" class="flex flex-col items-center justify-center py-16 text-gray-400">
            <span class="material-symbols-outlined text-5xl mb-3">category</span>
            <p class="text-sm">Không có danh mục nào</p>
          </div>
        </div>
      </div>

      <!-- BRAND TAB -->
      <div v-else class="space-y-6">
        <!-- ACTION BAR -->
        <div class="flex justify-end hidden">
          <button @click="openBrandModal()" class="flex items-center gap-2 px-6 py-2.5 bg-yellow-400 hover:bg-yellow-500 text-yellow-900 font-bold rounded-xl shadow-lg shadow-yellow-100 transition-all">
            <span class="material-symbols-outlined text-[20px]">add_circle</span>
            Thêm thương hiệu
          </button>
        </div>

        <!-- BRAND TABLE -->
        <div class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm overflow-hidden">
          <table class="w-full text-sm border-collapse" style="table-layout: fixed;">
            <thead class="bg-gray-50 border-b border-gray-200">
              <tr>
                <th class="px-4 py-4 text-xs font-semibold text-gray-500 uppercase w-[10%] text-center">ID</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-left w-[20%]">Tên thương hiệu</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[10%] text-blue-600">SP Nam</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[10%] text-pink-600">SP Nữ</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[10%] text-gray-600">Unisex</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-left w-[20%]">Mô tả</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[10%]">Trạng thái</th>
                <th class="px-6 py-4 text-xs font-semibold text-gray-500 uppercase text-center w-[10%]">Hành động</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr v-for="b in brands" :key="b.maTH" class="hover:bg-yellow-50/50 transition-colors cursor-pointer" @click="openBrandModal(b)">
                <td class="px-4 py-4 font-mono text-xs text-gray-500 text-center">#{{ b.maTH }}</td>
                <td class="px-6 py-4 font-bold text-gray-800 text-left truncate">{{ b.tenTH }}</td>
                <td class="px-6 py-4 text-center font-bold text-blue-600">{{ b.countNam || 0 }}</td>
                <td class="px-6 py-4 text-center font-bold text-pink-600">{{ b.countNu || 0 }}</td>
                <td class="px-6 py-4 text-center font-bold text-gray-600">{{ b.countUnisex || 0 }}</td>
                <td class="px-6 py-4 text-gray-500 italic text-left text-xs truncate pr-4">{{ b.moTa || 'Chưa có mô tả' }}</td>
                <td class="px-6 py-4 text-center">
                  <span class="inline-flex items-center px-2.5 py-1 text-[10px] font-bold rounded-full"
                    :class="b.trangThai == 1 ? 'bg-green-50 text-green-600' : 'bg-gray-100 text-gray-500'">
                    {{ b.trangThai == 1 ? 'Hoạt động' : 'Đang ẩn' }}
                  </span>
                </td>
                <td class="px-6 py-4 text-center" @click.stop>
                   <div class="flex justify-center gap-2">
                    <button @click="toggleBrandStatus(b)" class="p-2 rounded-lg hover:bg-gray-100 text-gray-600 transition-all" :title="b.trangThai == 1 ? 'Ẩn thương hiệu' : 'Hiện thương hiệu'">
                      <span class="material-symbols-outlined text-[20px]">
                        {{ b.trangThai == 1 ? 'visibility' : 'visibility_off' }}
                      </span>
                    </button>
                    <button @click="openBrandModal(b)" class="p-2 rounded-lg hover:bg-blue-50 text-blue-600 transition-all" title="Sửa">
                      <span class="material-symbols-outlined text-[20px]">edit</span>
                    </button>
                    <button @click="deleteBrand(b.maTH)" class="p-2 rounded-lg hover:bg-red-50 text-red-600 transition-all" title="Xóa">
                      <span class="material-symbols-outlined text-[20px]">delete</span>
                    </button>
                   </div>
                </td>
              </tr>
            </tbody>
          </table>
          <div v-if="brands.length === 0" class="flex flex-col items-center justify-center py-16 text-gray-400">
            <span class="material-symbols-outlined text-5xl mb-3">diamond</span>
            <p class="text-sm">Không có thương hiệu nào</p>
          </div>
        </div>
      </div>
    </div>

    <!-- PRODUCT DETAIL MODAL -->
    <div v-if="showDetails" class="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4" @click.self="showDetails=false">
      <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg overflow-hidden">
        <div class="flex items-center justify-between px-6 py-4 border-b border-gray-100 bg-gray-50">
          <h3 class="text-base font-bold text-gray-800">{{ selectedProduct?.tenSP }}</h3>
          <button @click="showDetails=false" class="text-gray-400 hover:text-gray-600 transition-colors">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>
        <div class="p-6 space-y-3 text-sm">
          <div v-if="loadingDetails" class="flex justify-center py-8 text-gray-400">
            <span class="material-symbols-outlined animate-spin text-3xl">progress_activity</span>
          </div>
          <template v-else>
            <div class="flex justify-center mb-6">
              <img v-if="selectedProduct?.anhChinh" :src="selectedProduct.anhChinh" class="h-48 w-48 object-cover rounded-xl shadow-md border" alt="Product image" />
              <div v-else class="h-48 w-48 bg-gray-100 rounded-xl flex items-center justify-center text-gray-300">
                <span class="material-symbols-outlined text-5xl">image_not_supported</span>
              </div>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div class="p-3 bg-gray-50 rounded-xl">
                <p class="text-[10px] text-gray-400 uppercase font-bold mb-1">Danh mục</p>
                <p class="font-medium text-gray-800">{{ selectedProduct?.loaiSanPham?.tenLoai }}</p>
              </div>
              <div class="p-3 bg-gray-50 rounded-xl">
                <p class="text-[10px] text-gray-400 uppercase font-bold mb-1">Thương hiệu</p>
                <p class="font-medium text-gray-800">{{ selectedProduct?.thuongHieu?.tenTH }}</p>
              </div>
            </div>
            <div class="p-4 bg-gray-50 rounded-xl">
              <p class="text-[10px] text-gray-400 uppercase font-bold mb-2">Mô tả sản phẩm</p>
              <p class="text-gray-700 leading-relaxed text-xs">{{ selectedProduct?.moTa || 'Chưa có mô tả chi tiết' }}</p>
            </div>
          </template>
        </div>
        <div class="px-6 py-4 border-t border-gray-100 flex justify-end">
          <button @click="showDetails=false" class="px-6 py-2 rounded-xl bg-gray-100 hover:bg-gray-200 text-sm font-bold text-gray-600 transition-all">Đóng</button>
        </div>
      </div>
    </div>

    <!-- CATEGORY MODAL (CRUD) -->
    <div v-if="categoryModal.show" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
      <div class="bg-white rounded-3xl shadow-2xl w-full max-w-md overflow-hidden transform transition-all scale-100">
        <div class="p-6 border-b border-gray-100 flex items-center justify-between bg-gray-50/50">
          <h3 class="text-lg font-bold text-gray-800">
            {{ categoryModal.form.maLoai ? 'Cập nhật danh mục' : 'Thêm danh mục mới' }}
          </h3>
          <button @click="categoryModal.show = false" class="text-gray-400 hover:text-gray-600">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>
        <form @submit.prevent="saveCategory" class="p-6 space-y-5">
          <div class="space-y-2">
            <label class="text-sm font-bold text-gray-700">Tên danh mục</label>
            <input 
              v-model="categoryModal.form.tenLoai"
              type="text" 
              required
              placeholder="VD: Áo Polo, Quần Tây..."
              class="w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-yellow-400 outline-none transition-all"
            />
          </div>
          <div class="space-y-2">
            <label class="text-sm font-bold text-gray-700">Mô tả</label>
            <textarea 
              v-model="categoryModal.form.moTa"
              rows="3"
              placeholder="Nhập mô tả ngắn cho danh mục..."
              class="w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-yellow-400 outline-none transition-all resize-none"
            ></textarea>
          </div>
          <div class="flex items-center justify-end gap-3 pt-4">
            <button type="button" @click="categoryModal.show = false" class="px-5 py-2.5 rounded-xl border border-gray-200 text-gray-500 font-bold hover:bg-gray-50 transition-all">Hủy</button>
            <button type="submit" class="px-6 py-2.5 rounded-xl bg-yellow-400 hover:bg-yellow-500 text-yellow-900 font-bold shadow-lg shadow-yellow-100 transition-all">
              {{ categoryModal.form.maLoai ? 'Lưu thay đổi' : 'Tạo ngay' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- BRAND MODAL (CRUD) -->
    <div v-if="brandModal.show" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
      <div class="bg-white rounded-3xl shadow-2xl w-full max-w-md overflow-hidden transform transition-all scale-100">
        <div class="p-6 border-b border-gray-100 flex items-center justify-between bg-gray-50/50">
          <h3 class="text-lg font-bold text-gray-800">
            {{ brandModal.form.maTH ? 'Cập nhật thương hiệu' : 'Thêm thương hiệu mới' }}
          </h3>
          <button @click="brandModal.show = false" class="text-gray-400 hover:text-gray-600">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>
        <form @submit.prevent="saveBrand" class="p-6 space-y-5">
          <div class="space-y-2">
            <label class="text-sm font-bold text-gray-700">Tên thương hiệu</label>
            <input 
              v-model="brandModal.form.tenTH"
              type="text" 
              required
              placeholder="VD: Gucci, Chanel..."
              class="w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-yellow-400 outline-none transition-all"
            />
          </div>
          <div class="space-y-2">
            <label class="text-sm font-bold text-gray-700">Mô tả</label>
            <textarea 
              v-model="brandModal.form.moTa"
              rows="3"
              placeholder="Nhập mô tả thương hiệu..."
              class="w-full border border-gray-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-yellow-400 outline-none transition-all resize-none"
            ></textarea>
          </div>
          <div class="flex items-center justify-end gap-3 pt-4">
            <button type="button" @click="brandModal.show = false" class="px-5 py-2.5 rounded-xl border border-gray-200 text-gray-500 font-bold hover:bg-gray-50 transition-all">Hủy</button>
            <button type="submit" class="px-6 py-2.5 rounded-xl bg-yellow-400 hover:bg-yellow-500 text-yellow-900 font-bold shadow-lg shadow-yellow-100 transition-all">
              {{ brandModal.form.maTH ? 'Lưu thay đổi' : 'Thêm mới' }}
            </button>
          </div>
        </form>
      </div>
    </div>

  </AdminLayout>
</template>

<script>
import AdminLayout from './AdminLayout.vue'
import axios from 'axios'

export default {
  name: 'ProductList',
  components: { AdminLayout },

  data() {
    return {
      activeTab: 'products', // 'products' or 'categories'
      products: [],
      categories: [],
      brands: [],
      filters: { keyword: '', categoryId: '', brandId: '', gioiTinh: '', status: '' },
      
      // Product details
      showDetails: false,
      selectedProduct: null,
      loadingDetails: false,

      // Category CRUD modal
      categoryModal: {
        show: false,
        form: { maLoai: null, tenLoai: '', moTa: '', trangThai: 1 }
      },

      // Brand CRUD modal
      brandModal: {
        show: false,
        form: { maTH: null, tenTH: '', moTa: '', trangThai: 1 }
      },

      // Dropdown UI state
      openDropdown: null, // 'category', 'brand', 'gender', 'status'
    }
  },

  methods: {
    // PRODUCTS
    async fetchProducts() {
      try {
        const res = await axios.get('/admin/products', { params: this.filters })
        this.products = res.data
      } catch (e) { console.error(e) }
    },

    async toggleStatus(product) {
      const newStatus = product.trangThaiSP == 1 ? 0 : 1;
      try {
        await axios.post('/admin/products', {
          ...product,
          trangThaiSP: newStatus
        });
        this.fetchProducts();
      } catch (e) { alert('Lỗi khi thay đổi trạng thái sản phẩm'); }
    },

    async openDetails(id) {
      this.showDetails = true
      this.loadingDetails = true
      try {
        const res = await axios.get(`/admin/products/${id}`)
        this.selectedProduct = res.data
      } catch (e) { console.error(e) }
      finally { this.loadingDetails = false }
    },

    editProduct(product) {
      this.$router.push(`/admin/products/edit/${product.maSP}`)
    },

    async deleteProduct(id) {
      const ok = await window.$confirm('Xác nhận xóa sản phẩm này? Nội dung sẽ biến mất vĩnh viễn.')
      if (!ok) return
      try {
        await axios.delete(`/admin/products/${id}`)
        this.fetchProducts()
      } catch(e) { window.$alert('Không thể xóa sản phẩm này!', 'Lỗi') }
    },

    // CATEGORIES
    async fetchCategories() {
      try {
        const res = await axios.get('/admin/categories')
        this.categories = res.data
      } catch (e) { console.error(e) }
    },

    async toggleCategoryStatus(category) {
      const newStatus = category.trangThai == 1 ? 0 : 1;
      try {
        await axios.post('/admin/categories', {
          ...category,
          trangThai: newStatus
        });
        this.fetchCategories();
      } catch (e) { alert('Lỗi khi thay đổi trạng thái danh mục'); }
    },

    async fetchBrands() {
      try {
        const res = await axios.get('/admin/brands')
        this.brands = res.data
      } catch (e) { console.error(e) }
    },

    openCategoryModal(category = null) {
      if (category) {
        this.categoryModal.form = { ...category }
      } else {
        this.categoryModal.form = { maLoai: null, tenLoai: '', moTa: '', trangThai: 1 }
      }
      this.categoryModal.show = true
    },

    async saveCategory() {
      try {
        await axios.post('/admin/categories', this.categoryModal.form)
        window.$alert(this.categoryModal.form.maLoai ? 'Cập nhật thành công!' : 'Thêm mới thành công!', 'Thành công')
        this.categoryModal.show = false
        this.fetchCategories()
      } catch (e) {
        window.$alert('Lỗi: ' + (e.response?.data?.message || 'Không thể lưu danh mục'), 'Lỗi')
      }
    },

    async deleteCategory(id) {
      const ok = await window.$confirm('Xóa danh mục này có thể ảnh hưởng đến các sản phẩm thuộc danh mục. Bạn chắc chắn chứ?')
      if (!ok) return
      try {
        await axios.delete(`/admin/categories/${id}`)
        this.fetchCategories()
      } catch(e) {
        window.$alert('Không thể xóa danh mục này (có thể do đang chứa sản phẩm)', 'Lỗi')
      }
    },

    // BRANDS
    async toggleBrandStatus(brand) {
      const newStatus = brand.trangThai == 1 ? 0 : 1;
      try {
        await axios.post('/admin/brands', {
          ...brand,
          trangThai: newStatus
        });
        this.fetchBrands();
      } catch (e) { alert('Lỗi khi thay đổi trạng thái thương hiệu'); }
    },

    openBrandModal(brand = null) {
      if (brand) {
        this.brandModal.form = { ...brand }
      } else {
        this.brandModal.form = { maTH: null, tenTH: '', moTa: '', trangThai: 1 }
      }
      this.brandModal.show = true
    },

    async saveBrand() {
      try {
        await axios.post('/admin/brands', this.brandModal.form)
        alert(this.brandModal.form.maTH ? 'Cập nhật thành công!' : 'Thêm mới thành công!')
        this.brandModal.show = false
        this.fetchBrands()
      } catch (e) {
        alert('Lỗi: ' + (e.response?.data?.message || 'Không thể lưu thương hiệu'))
      }
    },

    async deleteBrand(id) {
      const ok = await window.$confirm('Xác nhận xóa thương hiệu này? Bạn chắc chắn chứ?')
      if (!ok) return
      try {
        await axios.delete(`/admin/brands/${id}`)
        this.fetchBrands()
      } catch(e) {
        window.$alert('Không thể xóa thương hiệu này (có thể do đang chứa sản phẩm)', 'Lỗi')
      }
    },

    resetFilters() {
      this.filters = { keyword: '', categoryId: '', brandId: '', gioiTinh: '', status: '' }
      this.fetchProducts()
    },

    closeDropdowns() {
      this.openDropdown = null
    }
  },

  mounted() {
    window.addEventListener('click', this.closeDropdowns)
    this.fetchProducts()
    this.fetchCategories()
    this.fetchBrands()
  },

  beforeUnmount() {
    window.removeEventListener('click', this.closeDropdowns)
  }
}
</script>