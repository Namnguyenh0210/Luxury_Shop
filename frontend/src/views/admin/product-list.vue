<template>
 <div class="admin-products-view-root">
  <div class="w-full mx-auto p-8 space-y-6">
      
      <!-- NAVIGATION TABS -->
      <div class="flex gap-1 bg-gray-100 p-1 rounded-2xl w-fit">
        <button 
          @click="activeTab = 'products'"
          :class="activeTab === 'products' ? 'bg-white shadow-sm text-[#C8A97E]' : 'text-gray-500 hover:text-gray-700'"
          class="px-6 py-2.5 rounded-xl text-sm font-bold transition-all flex items-center gap-2"
        >
          <span class="material-symbols-outlined text-[20px]">inventory_2</span>
          Sản phẩm
        </button>
        <button 
          @click="activeTab = 'categories'"
          :class="activeTab === 'categories' ? 'bg-white shadow-sm text-[#C8A97E]' : 'text-gray-500 hover:text-gray-700'"
          class="px-6 py-2.5 rounded-xl text-sm font-bold transition-all flex items-center gap-2"
        >
          <span class="material-symbols-outlined text-[20px]">category</span>
          Danh mục
        </button>
        <button 
          @click="activeTab = 'brands'"
          :class="activeTab === 'brands' ? 'bg-white shadow-sm text-[#C8A97E]' : 'text-gray-500 hover:text-gray-700'"
          class="px-6 py-2.5 rounded-xl text-sm font-bold transition-all flex items-center gap-2"
        >
          <span class="material-symbols-outlined text-[20px]">diamond</span>
          Thương hiệu
        </button>
      </div>

      <!-- PRODUCT TAB -->
      <div v-if="activeTab === 'products'" class="space-y-6">
        <!-- LIST VIEW -->
        <template v-if="!showDetailView">
          <!-- ACTION BAR -->
            <div class="flex items-center justify-between flex-wrap gap-4 mb-4">
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

              <!-- Dropdowns (unchanged) -->
              <div class="relative min-w-[190px]">
                <button @click.stop="openDropdown = openDropdown === 'category' ? null : 'category'"
                  class="w-full border border-[#C8A97E]/50 rounded-2xl pl-4 pr-10 py-2.5 text-sm bg-white text-left focus:outline-none focus:ring-2 focus:ring-[#C8A97E]/30 hover:border-[#C8A97E] transition-all flex items-center justify-between shadow-sm">
                  <span class="truncate font-medium text-gray-700">{{ categories.find(c => c.maLoai === filters.categoryId)?.tenLoai || 'Tất cả danh mục' }}</span>
                  <span class="material-symbols-outlined text-[20px] absolute right-3 text-[#C8A97E]">expand_more</span>
                </button>
                <div v-if="openDropdown === 'category'" @click.stop class="absolute z-50 w-full mt-2 bg-white border border-[#C8A97E]/30 rounded-2xl shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-200">
                  <div @click="filters.categoryId = ''; fetchProducts(); openDropdown = null" 
                    class="px-4 py-3 text-sm cursor-pointer transition-colors border-b border-gray-50 bg-[#C8A97E]/10" 
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

              <button @click="resetFilters" 
                class="flex items-center justify-center size-10 rounded-full border border-[#C8A97E]/30 bg-white text-[#C8A97E] hover:bg-[#C8A97E] hover:text-white transition-all shadow-sm group"
                title="Làm mới bộ lọc">
                <span class="material-symbols-outlined text-[22px] group-hover:rotate-180 transition-transform duration-500">refresh</span>
              </button>
              </div>
              <button @click="openProductModal()" class="flex items-center gap-2 px-6 py-2.5 bg-[#C8A97E] hover:bg-[#B88A00] text-white font-bold rounded-xl shadow-lg shadow-[#C8A97E]/20 transition-all">
                <span class="material-symbols-outlined text-[20px]">add_circle</span>
                Thêm sản phẩm
              </button>
            </div>

          <!-- PRODUCT TABLE -->
          <div class="bg-white rounded-2xl border border-[#C8A97E]/30 shadow-sm overflow-hidden animate-in slide-in-from-bottom duration-500">
            <table class="w-full text-sm border-collapse" style="table-layout: fixed;">
                <thead class="bg-gray-50/50 border-b border-gray-200">
                <tr>
                  <th class="px-4 py-4 text-[11px] font-black text-gray-500 uppercase w-[6%] text-center tracking-widest">ID</th>
                  <th class="px-6 py-4 text-[11px] font-black text-gray-500 uppercase w-[32%] text-left tracking-widest">Tên Sản Phẩm</th>
                  <th class="px-4 py-4 text-[11px] font-black text-gray-500 uppercase w-[10%] text-center tracking-widest">Phân Loại</th>
                  <th class="px-4 py-4 text-[11px] font-black text-gray-500 uppercase w-[12%] text-center tracking-widest">Thương Hiệu</th>
                  <th class="px-4 py-4 text-[11px] font-black text-gray-500 uppercase w-[8%] text-center tracking-widest">Giới Tính</th>
                  <th class="px-4 py-4 text-[11px] font-black text-gray-500 uppercase w-[8%] text-center tracking-widest">Số lượng</th>
                  <th class="px-4 py-4 text-[11px] font-black text-gray-500 uppercase w-[12%] text-center tracking-widest">Trạng Thái</th>
                  <th class="px-4 py-4 text-[11px] font-black text-gray-500 uppercase w-[12%] text-center tracking-widest">Hành Động</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-100">
                <tr v-for="p in products" :key="p.id" class="hover:bg-[#C8A97E]/5 transition-colors cursor-pointer group" @click="openDetails(p.maSP)">
                  <td class="px-4 py-5 font-mono text-[11px] text-gray-400 text-center">#{{ p.maSP }}</td>
                  <td class="px-6 py-5">
                    <p class="font-bold text-gray-800 text-sm leading-tight line-clamp-2 hover:text-[#C8A97E] transition-colors transition-all">{{ p.tenSP }}</p>
                  </td>
                  <td class="px-4 py-5 font-medium text-gray-600 text-[13px] text-center whitespace-nowrap">{{ p.loaiSanPham?.tenLoai }}</td>
                  <td class="px-4 py-5 font-medium text-gray-600 text-[13px] text-center whitespace-nowrap">{{ p.thuongHieu?.tenTH }}</td>
                  <td class="px-4 py-5 text-center">
                    <span class="px-3 py-1.5 rounded-xl bg-gray-100 text-[10px] font-black text-gray-500 uppercase tracking-tighter whitespace-nowrap">
                      {{ p.gioiTinh === 0 ? 'Nam' : p.gioiTinh === 1 ? 'Nữ' : 'Unisex' }}
                    </span>
                  </td>
                  <td class="px-4 py-5 text-center">
                    <span :class="p.totalStock < 10 ? 'text-red-500 font-black animate-pulse' : 'text-gray-800 font-black text-base tabular-nums'">
                      {{ p.totalStock }}
                    </span>
                  </td>
                  <td class="px-4 py-5 text-center">
                    <span class="inline-flex items-center px-3 py-1.5 text-[10px] font-black uppercase rounded-full tracking-wider whitespace-nowrap"
                      :class="p.trangThaiSP == 1 ? 'bg-green-50 text-green-600' : 'bg-red-50 text-red-600'">
                      <span class="size-1.5 rounded-full mr-2" :class="p.trangThaiSP == 1 ? 'bg-green-500 shadow-sm' : 'bg-red-500'"></span>
                      {{ p.trangThaiSP == 1 ? 'Đang bán' : 'Ngừng bán' }}
                    </span>
                  </td>
                  <td class="px-4 py-5" @click.stop>
                    <div class="flex justify-center gap-1">
                      <button @click="toggleStatus(p)" class="size-9 rounded-xl hover:bg-white hover:shadow-md text-gray-400 hover:text-gray-800 transition-all flex items-center justify-center shrink-0" :title="p.trangThaiSP == 1 ? 'Ẩn sản phẩm' : 'Hiện sản phẩm'">
                        <span class="material-symbols-outlined text-[20px]">
                          {{ p.trangThaiSP == 1 ? 'visibility' : 'visibility_off' }}
                        </span>
                      </button>
                      <button @click="editProduct(p)" class="size-9 rounded-xl hover:bg-white hover:shadow-md text-blue-400 hover:text-blue-600 transition-all flex items-center justify-center shrink-0" title="Sửa">
                        <span class="material-symbols-outlined text-[20px]">edit</span>
                      </button>
                      <button @click="deleteProduct(p.maSP)" class="size-9 rounded-xl hover:bg-white hover:shadow-md text-red-400 hover:text-red-600 transition-all flex items-center justify-center shrink-0" title="Xóa">
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
        </template>

        <!-- INLINE DETAIL VIEW -->
        <div v-else class="space-y-8 animate-in slide-in-from-right duration-500">
           <!-- Navigation & Header -->
           <div class="flex items-center justify-between bg-white p-6 rounded-[2rem] border border-[#C8A97E]/20 shadow-sm">
              <div class="flex items-center gap-6">
                <button @click="showDetailView = false" class="size-12 rounded-2xl bg-gray-50 hover:bg-[#C8A97E]/10 text-gray-600 hover:text-[#C8A97E] transition-all flex items-center justify-center group">
                   <span class="material-symbols-outlined group-hover:-translate-x-1 transition-transform">arrow_back</span>
                </button>
                <div>
                  <h3 class="text-2xl font-black text-gray-800 tracking-tight">{{ selectedProduct?.tenSP }}</h3>
                  <p class="text-[10px] font-black text-[#C8A97E] uppercase tracking-widest mt-1">QUẢN LÝ BIẾN THỂ & TỒN KHO</p>
                </div>
              </div>
              <div class="flex gap-3">
                 <button @click="editProduct(selectedProduct)" class="px-6 py-3 rounded-full bg-gray-800 text-white font-black text-sm hover:bg-black transition-all shadow-lg flex items-center gap-2">
                    <span class="material-symbols-outlined text-[20px]">edit_square</span>
                    SỬA SẢN PHẨM
                 </button>
              </div>
           </div>

           <div class="bg-white rounded-[2.5rem] border border-[#C8A97E]/20 shadow-xl overflow-hidden p-8">
              <div v-if="loadingDetails" class="flex flex-col items-center justify-center py-20 gap-4">
                <span class="material-symbols-outlined animate-spin text-4xl text-[#C8A97E]">progress_activity</span>
                <p class="text-sm font-bold text-gray-400 italic">Đang tải thông tin sản phẩm...</p>
              </div>
              
              <template v-else>
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-10">
                    <!-- Left: Image -->
                    <div class="lg:col-span-4 space-y-6">
                        <div class="aspect-square rounded-[2rem] bg-gray-50 border border-gray-100 p-4 shadow-inner overflow-hidden group">
                            <img v-if="selectedProduct?.anhChinh" :src="selectedProduct.anhChinh" class="w-full h-full object-cover rounded-[1.5rem] transition-transform duration-700 group-hover:scale-110" />
                            <div v-else class="w-full h-full flex flex-col items-center justify-center text-gray-300">
                                 <span class="material-symbols-outlined text-6xl">image_not_supported</span>
                                 <p class="text-xs font-bold mt-2 font-mono italic">NO PHOTO</p>
                            </div>
                        </div>

                        <!-- Description Under Image -->
                        <div class="p-8 bg-gray-50/50 rounded-[2rem] border border-gray-100">
                            <h4 class="text-xs font-black text-gray-400 uppercase mb-4 flex items-center gap-2 tracking-widest">
                                <span class="material-symbols-outlined text-[20px]">subject</span>
                                Mô tả chi tiết
                            </h4>
                            <p class="text-gray-700 text-sm leading-relaxed italic font-medium">{{ selectedProduct?.moTa || 'Không có mô tả.' }}</p>
                        </div>
                    </div>

                    <!-- Right: Basic Info -->
                    <div class="lg:col-span-8 space-y-8">
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                            <div class="p-5 bg-gray-50/50 rounded-2xl border border-gray-100/50">
                                 <p class="text-xs text-gray-400 font-black uppercase mb-2 tracking-widest">Brand</p>
                                 <div class="flex items-center gap-2">
                                    <span class="material-symbols-outlined text-[#C8A97E] text-[20px]">verified</span>
                                    <p class="font-black text-gray-800 uppercase text-sm">{{ selectedProduct?.thuongHieu?.tenTH }}</p>
                                 </div>
                            </div>
                            <div class="p-5 bg-gray-50/50 rounded-2xl border border-gray-100/50">
                                 <p class="text-xs text-gray-400 font-black uppercase mb-2 tracking-widest">Type</p>
                                 <div class="flex items-center gap-2">
                                    <span class="material-symbols-outlined text-gray-600 text-[20px]">category</span>
                                    <p class="font-black text-gray-800 text-sm text-nowrap truncate">{{ selectedProduct?.loaiSanPham?.tenLoai }}</p>
                                 </div>
                            </div>
                            <div class="p-5 bg-gray-50/50 rounded-2xl border border-gray-100/50">
                                 <p class="text-xs text-gray-400 font-black uppercase mb-2 tracking-widest">Gender</p>
                                 <div class="flex items-center gap-2">
                                    <span class="material-symbols-outlined text-gray-600 text-[20px]">wc</span>
                                    <p class="font-black text-gray-800 text-sm uppercase">
                                         {{ selectedProduct?.gioiTinh === 0 ? 'NAM' : selectedProduct?.gioiTinh === 1 ? 'NỮ' : 'UNISEX' }}
                                    </p>
                                 </div>
                            </div>
                            <div class="p-5 bg-gray-50/50 rounded-2xl border border-gray-100/50">
                                 <p class="text-xs text-gray-400 font-black uppercase mb-2 tracking-widest">Status</p>
                                 <div class="flex items-center gap-3">
                                    <span class="size-2.5 rounded-full" :class="selectedProduct?.trangThaiSP == 1 ? 'bg-green-500 shadow-md animate-pulse' : 'bg-red-500'"></span>
                                    <p class="font-black text-sm" :class="selectedProduct?.trangThaiSP == 1 ? 'text-green-600' : 'text-red-600'">
                                         {{ selectedProduct?.trangThaiSP == 1 ? 'ACTIVE' : 'INACTIVE' }}
                                    </p>
                                 </div>
                            </div>
                        </div>

                        <!-- Variants Area -->
                        <div class="space-y-6">
                            <h4 class="text-lg font-black text-gray-800 flex items-center gap-3 uppercase tracking-wide border-b border-gray-100 pb-4">
                                <span class="material-symbols-outlined text-[#C8A97E] text-[24px]">inventory_2</span>
                                Bảng kích cỡ & Tồn kho
                            </h4>

                            <div v-if="Object.keys(groupedVariants).length === 0" class="py-12 bg-gray-50 rounded-3xl flex flex-col items-center justify-center text-gray-400">
                                <span class="material-symbols-outlined text-6xl">inventory</span>
                                <p class="text-base font-bold mt-2">Chưa có phân loại!</p>
                            </div>

                            <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div v-for="(variants, size) in groupedVariants" :key="size" class="bg-white rounded-[2rem] border border-gray-100 shadow-sm overflow-hidden hover:shadow-xl transition-all duration-300">
                                    <div class="bg-gray-50/80 px-5 py-4 border-b border-gray-100 flex items-center justify-between">
                                        <div class="flex items-center gap-3">
                                            <span class="text-xs font-black text-gray-400 uppercase tracking-widest">SIZE</span>
                                            <span class="size-10 rounded-2xl bg-gray-800 text-white flex items-center justify-center font-black text-base shadow-lg">{{ size }}</span>
                                        </div>
                                        <span class="text-xs font-bold text-gray-400 uppercase tracking-tight">{{ variants.length }} Màu</span>
                                    </div>
                                    <div class="p-4 space-y-3">
                                        <div v-for="v in variants" :key="v.maBienThe" class="flex items-center justify-between p-3 rounded-2xl hover:bg-gray-50 transition-colors">
                                            <div class="flex items-center gap-4">
                                                <div class="size-11 rounded-2xl border border-gray-100 flex items-center justify-center p-0.5 shadow-sm" :style="{ backgroundColor: v.mauSacSP?.maHex || '#ccc' }">
                                                    <div class="size-full rounded-[14px] bg-black/5 flex items-center justify-center">
                                                        <span v-if="isLightColor(v.mauSacSP?.maHex)" class="material-symbols-outlined text-[14px] text-black/20 font-bold">done</span>
                                                        <span v-else class="material-symbols-outlined text-[14px] text-white/40 font-bold">done</span>
                                                    </div>
                                                </div>
                                                <p class="text-sm font-black text-gray-800">{{ v.mauSacSP?.tenMau }}</p>
                                            </div>
                                            <div class="text-right">
                                                <p class="text-2xl font-black tabular-nums tracking-tighter" :class="v.soLuongTon < 5 ? 'text-red-500 animate-pulse' : 'text-gray-800'">
                                                    {{ v.soLuongTon }}
                                                </p>
                                                <p class="text-[9px] font-black text-gray-400 uppercase tracking-tighter">STOCK</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
              </template>
           </div>
        </div>
      </div>

      <!-- CATEGORY TAB -->
      <div v-else-if="activeTab === 'categories'" class="space-y-6">
        <!-- ACTION BAR -->
        <div class="flex justify-end gap-2 mb-4">
          <button @click="openCategoryModal()" class="flex items-center gap-2 px-6 py-2.5 bg-[#C8A97E] hover:bg-[#B88A00] text-white font-bold rounded-xl shadow-lg shadow-[#C8A97E]/20 transition-all">
            <span class="material-symbols-outlined text-[20px]">add_circle</span>
            Thêm danh mục
          </button>
        </div>

        <!-- CATEGORY TABLE -->
        <div class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm overflow-hidden">
          <table class="w-full text-sm border-collapse" style="table-layout: fixed;">
            <thead class="bg-gray-50 border-b border-gray-200">
              <tr>
                <th class="px-4 py-4 text-[11px] font-black text-gray-500 uppercase w-[8%] text-center tracking-widest">ID</th>
                <th class="px-6 py-4 text-[11px] font-black text-gray-500 uppercase text-left w-[20%] tracking-widest">Tên danh mục</th>
                <th class="px-4 py-4 text-[11px] font-black text-blue-600 uppercase text-center w-[10%] tracking-widest">SP Nam</th>
                <th class="px-4 py-4 text-[11px] font-black text-pink-600 uppercase text-center w-[10%] tracking-widest">SP Nữ</th>
                <th class="px-4 py-4 text-[11px] font-black text-gray-600 uppercase text-center w-[10%] tracking-widest">Unisex</th>
                <th class="px-6 py-4 text-[11px] font-black text-gray-500 uppercase text-left w-[22%] tracking-widest">Mô tả</th>
                <th class="px-4 py-4 text-[11px] font-black text-gray-500 uppercase text-center w-[10%] tracking-widest">Trạng thái</th>
                <th class="px-4 py-4 text-[11px] font-black text-gray-500 uppercase text-center w-[10%] tracking-widest">Hành động</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr v-for="c in categories" :key="c.maLoai" class="hover:bg-yellow-50/50 transition-colors cursor-pointer group" @click="openCategoryModal(c)">
                <td class="px-4 py-5 font-mono text-[11px] text-gray-400 text-center">#{{ c.maLoai }}</td>
                <td class="px-6 py-5 font-bold text-gray-800 text-sm text-left truncate">{{ c.tenLoai }}</td>
                <td class="px-4 py-5 text-center font-black text-blue-600 text-base tabular-nums">{{ c.countNam || 0 }}</td>
                <td class="px-4 py-5 text-center font-black text-pink-600 text-base tabular-nums">{{ c.countNu || 0 }}</td>
                <td class="px-4 py-5 text-center font-black text-gray-500 text-base tabular-nums">{{ c.countUnisex || 0 }}</td>
                <td class="px-6 py-5">
                  <p class="text-gray-500 italic text-left text-[13px] line-clamp-1 pr-4">{{ c.moTa || 'Chưa có mô tả' }}</p>
                </td>
                <td class="px-4 py-5 text-center">
                  <span class="inline-flex items-center px-3 py-1.5 text-[10px] font-black uppercase rounded-full tracking-wider"
                    :class="c.trangThai == 1 ? 'bg-blue-50 text-blue-600' : 'bg-gray-100 text-gray-500 text-nowrap'">
                    {{ c.trangThai == 1 ? 'Hiển thị' : 'Đang ẩn' }}
                  </span>
                </td>
                <td class="px-4 py-5 text-center" @click.stop>
                   <div class="flex justify-center gap-1">
                    <button @click="toggleCategoryStatus(c)" class="size-9 rounded-xl hover:bg-white hover:shadow-md text-gray-400 transition-all flex items-center justify-center">
                      <span class="material-symbols-outlined text-[20px]">
                        {{ c.trangThai == 1 ? 'visibility' : 'visibility_off' }}
                      </span>
                    </button>
                    <button @click="openCategoryModal(c)" class="size-9 rounded-xl hover:bg-white hover:shadow-md text-blue-400 transition-all flex items-center justify-center">
                      <span class="material-symbols-outlined text-[20px]">edit</span>
                    </button>
                    <button @click="deleteCategory(c.maLoai)" class="size-9 rounded-xl hover:bg-white hover:shadow-md text-red-400 transition-all flex items-center justify-center">
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
        <div class="flex justify-end gap-2 mb-4">
          <button @click="openBrandModal()" class="flex items-center gap-2 px-6 py-2.5 bg-[#C8A97E] hover:bg-[#B88A00] text-white font-bold rounded-xl shadow-lg shadow-[#C8A97E]/20 transition-all">
            <span class="material-symbols-outlined text-[20px]">add_circle</span>
            Thêm thương hiệu
          </button>
        </div>

        <!-- BRAND TABLE -->
        <div class="bg-white rounded-2xl border border-[#C8A97E] shadow-sm overflow-hidden">
          <table class="w-full text-sm border-collapse" style="table-layout: fixed;">
            <thead class="bg-gray-50 border-b border-gray-200">
              <tr>
                <th class="px-2 py-4 text-[11px] font-black text-gray-500 uppercase w-[5%] text-center tracking-widest">ID</th>
                <th class="px-4 py-4 text-[11px] font-black text-gray-500 uppercase text-left w-[23%] tracking-widest">Tên thương hiệu</th>
                <th class="px-2 py-4 text-[11px] font-black text-blue-600 uppercase text-center w-[8%] tracking-widest whitespace-nowrap">SP Nam</th>
                <th class="px-2 py-4 text-[11px] font-black text-pink-600 uppercase text-center w-[8%] tracking-widest whitespace-nowrap">SP Nữ</th>
                <th class="px-2 py-4 text-[11px] font-black text-gray-600 uppercase text-center w-[8%] tracking-widest whitespace-nowrap">Unisex</th>
                <th class="px-4 py-4 text-[11px] font-black text-gray-500 uppercase text-left w-[24%] tracking-widest">Mô tả</th>
                <th class="px-2 py-4 text-[11px] font-black text-gray-500 uppercase text-center w-[12%] tracking-widest whitespace-nowrap">Trạng thái</th>
                <th class="px-2 py-4 text-[11px] font-black text-gray-500 uppercase text-center w-[12%] tracking-widest whitespace-nowrap">Hành động</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr v-for="b in brands" :key="b.maTH" class="hover:bg-yellow-50/50 transition-colors cursor-pointer group" @click="openBrandModal(b)">
                <td class="px-2 py-5 font-mono text-[11px] text-gray-400 text-center">#{{ b.maTH }}</td>
                <td class="px-4 py-5">
                  <div class="flex items-center gap-4">
                    <div class="size-12 rounded-xl bg-white border border-gray-100 flex items-center justify-center p-2 overflow-hidden shadow-sm group-hover:scale-110 transition-transform shrink-0">
                      <img 
                        :src="getBrandLogo(b.tenTH)" 
                        @error="(e) => e.target.src = '/img/placeholder.png'"
                        class="max-w-full max-h-full object-contain"
                        alt="Brand logo"
                      />
                    </div>
                    <span class="font-bold text-gray-800 text-sm">{{ b.tenTH }}</span>
                  </div>
                </td>
                <td class="px-2 py-5 text-center font-black text-blue-600 text-base tabular-nums">{{ b.countNam || 0 }}</td>
                <td class="px-2 py-5 text-center font-black text-pink-600 text-base tabular-nums">{{ b.countNu || 0 }}</td>
                <td class="px-2 py-5 text-center font-black text-gray-500 text-base tabular-nums">{{ b.countUnisex || 0 }}</td>
                <td class="px-4 py-5">
                  <p class="text-gray-500 italic text-left text-[13px] line-clamp-1 pr-2">{{ b.moTa || 'Chưa có mô tả' }}</p>
                </td>
                <td class="px-2 py-5 text-center">
                  <span class="inline-flex items-center px-3 py-1.5 text-[10px] font-black uppercase rounded-full tracking-wider whitespace-nowrap"
                    :class="b.trangThai == 1 ? 'bg-green-50 text-green-600' : 'bg-gray-100 text-gray-500'">
                    {{ b.trangThai == 1 ? 'Hoạt động' : 'Đang ẩn' }}
                  </span>
                </td>
                <td class="px-4 py-5 text-center" @click.stop>
                   <div class="flex justify-center gap-1">
                    <button @click="toggleBrandStatus(b)" class="size-9 rounded-xl hover:bg-white hover:shadow-md text-gray-400 transition-all flex items-center justify-center">
                      <span class="material-symbols-outlined text-[20px]">
                        {{ b.trangThai == 1 ? 'visibility' : 'visibility_off' }}
                      </span>
                    </button>
                    <button @click="openBrandModal(b)" class="size-9 rounded-xl hover:bg-white hover:shadow-md text-blue-400 transition-all flex items-center justify-center">
                      <span class="material-symbols-outlined text-[20px]">edit</span>
                    </button>
                    <button @click="deleteBrand(b.maTH)" class="size-9 rounded-xl hover:bg-white hover:shadow-md text-red-400 transition-all flex items-center justify-center">
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
            <button type="button" @click="categoryModal.show = false" class="px-5 py-2.5 rounded-full border border-gray-200 text-gray-500 font-bold hover:bg-gray-50 transition-all">Hủy</button>
            <button type="submit" class="px-6 py-2.5 rounded-full bg-[#C8A97E] hover:bg-[#B88A00] text-white font-bold shadow-lg shadow-[#C8A97E]/20 transition-all">
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

        <div v-if="brandModal.form.tenTH" class="mt-6 flex justify-center">
            <div class="size-28 rounded-2xl bg-gray-50 border border-gray-100 flex items-center justify-center p-6 overflow-hidden shadow-inner group">
              <img 
                :src="getBrandLogo(brandModal.form.tenTH)" 
                @error="(e) => e.target.src = '/img/placeholder.png'"
                class="max-w-full max-h-full object-contain transition-transform duration-500 group-hover:scale-110"
                alt="Brand logo"
              />
            </div>
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
            <button type="button" @click="brandModal.show = false" class="px-5 py-2.5 rounded-full border border-gray-200 text-gray-500 font-bold hover:bg-gray-50 transition-all">Hủy</button>
            <button type="submit" class="px-6 py-2.5 rounded-full bg-[#C8A97E] hover:bg-[#B88A00] text-white font-bold shadow-lg shadow-[#C8A97E]/20 transition-all">
              {{ brandModal.form.maTH ? 'Lưu thay đổi' : 'Thêm mới' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- PRODUCT MODAL (QUICK ADD) -->
    <div v-if="productModal.show" class="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
      <div class="bg-white rounded-3xl shadow-2xl w-full max-w-2xl overflow-hidden transform transition-all scale-100 max-h-[90vh] flex flex-col">
        <div class="p-6 border-b border-gray-100 flex items-center justify-between bg-gray-50/50">
          <h3 class="text-lg font-bold text-gray-800">
            Thêm sản phẩm
          </h3>
          <button @click="productModal.show = false" class="text-gray-400 hover:text-gray-600">
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>
        
        <div class="overflow-y-auto custom-scrollbar flex-1">
          <form @submit.prevent="saveProduct" class="p-6 space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div class="space-y-2 md:col-span-2">
                <label class="text-sm font-semibold text-gray-700">Tên sản phẩm</label>
                <input v-model="productModal.form.tenSP" type="text" required placeholder="Nhập tên sản phẩm..."
                  class="w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 focus:ring-2 focus:ring-[#C8A97E]/30 outline-none transition-all" />
              </div>

              <div class="space-y-2">
                <label class="text-sm font-semibold text-gray-700">Danh mục</label>
                <select v-model="productModal.form.loaiSanPham.maLoai" required
                  class="w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 focus:ring-2 focus:ring-[#C8A97E]/30 outline-none transition-all bg-white">
                  <option value="" disabled>Chọn danh mục</option>
                  <option v-for="c in categories" :key="c.maLoai" :value="c.maLoai">{{ c.tenLoai }}</option>
                </select>
              </div>

              <div class="space-y-2">
                <label class="text-sm font-semibold text-gray-700">Thương hiệu</label>
                <select v-model="productModal.form.thuongHieu.maTH" required
                  class="w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 focus:ring-2 focus:ring-[#C8A97E]/30 outline-none transition-all bg-white">
                  <option value="" disabled>Chọn thương hiệu</option>
                  <option v-for="b in brands" :key="b.maTH" :value="b.maTH">{{ b.tenTH }}</option>
                </select>
              </div>

              <div class="space-y-2">
                <label class="text-sm font-semibold text-gray-700">Giới tính</label>
                <select v-model="productModal.form.gioiTinh" class="w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 focus:ring-2 focus:ring-[#C8A97E]/30 outline-none transition-all bg-white">
                  <option :value="0">Nam</option>
                  <option :value="1">Nữ</option>
                  <option :value="2">Unisex</option>
                </select>
              </div>

              <div class="space-y-2">
                <label class="text-sm font-semibold text-gray-700">Trạng thái kinh doanh</label>
                <div class="flex gap-4 p-1 bg-gray-100 rounded-xl w-fit">
                  <button type="button" @click="productModal.form.trangThaiSP = 1"
                    :class="productModal.form.trangThaiSP == 1 ? 'bg-white shadow-sm text-green-600' : 'text-gray-500'"
                    class="px-4 py-1.5 rounded-lg text-sm font-medium transition-all">Đang bán</button>
                  <button type="button" @click="productModal.form.trangThaiSP = 0"
                    :class="productModal.form.trangThaiSP == 0 ? 'bg-white shadow-sm text-red-600' : 'text-gray-500'"
                    class="px-4 py-1.5 rounded-lg text-sm font-medium transition-all">Ngừng bán</button>
                </div>
              </div>

              <div class="space-y-2 md:col-span-2">
                <label class="text-sm font-semibold text-gray-700">URL Ảnh chính</label>
                <div class="flex gap-2">
                  <input v-model="productModal.form.anhChinh" type="text" placeholder="https://..."
                    class="flex-1 w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 focus:ring-2 focus:ring-[#C8A97E]/30 outline-none transition-all" />
                  <input type="file" ref="fileInput" class="hidden" @change="uploadImage" accept="image/*" />
                  <button type="button" @click="$refs.fileInput.click()" class="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-600 rounded-xl font-medium transition-colors flex items-center justify-center min-w-[50px]">
                    <span class="material-symbols-outlined text-[20px]">upload</span>
                  </button>
                </div>
                <div v-if="productModal.uploadingImg" class="text-[11px] text-[#C8A97E] font-bold flex items-center gap-1 mt-1">
                  <span class="material-symbols-outlined animate-spin text-[14px]">progress_activity</span> Đang tải lên...
                </div>
              </div>

              <div class="space-y-2 md:col-span-2">
                <label class="text-sm font-semibold text-gray-700">Mô tả chi tiết</label>
                <textarea v-model="productModal.form.moTa" rows="3" placeholder="Nhập mô tả sản phẩm..."
                  class="w-full border border-[#C8A97E] rounded-2xl px-4 py-2.5 focus:ring-2 focus:ring-[#C8A97E]/30 outline-none transition-all resize-none"></textarea>
              </div>
            </div>

            <div class="flex items-center justify-end gap-3 pt-6 border-t border-gray-100">
              <button type="button" @click="productModal.show = false"
                class="px-6 py-2.5 rounded-xl border border-gray-200 text-gray-600 hover:bg-gray-50 font-medium transition-all">
                Hủy bỏ
              </button>
              <button type="submit" :disabled="productModal.saving"
                class="px-8 py-2.5 rounded-xl bg-yellow-400 hover:bg-yellow-500 text-yellow-900 font-bold shadow-lg shadow-yellow-200 transition-all disabled:opacity-50 flex items-center">
                <span v-if="productModal.saving" class="material-symbols-outlined animate-spin mr-2 text-sm">progress_activity</span>
                Thêm sản phẩm
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'ProductList',

  data() {
    return {
      activeTab: 'products', // 'products' or 'categories'
      products: [],
      categories: [],
      brands: [],
      filters: { keyword: '', categoryId: '', brandId: '', gioiTinh: '', status: '' },
      
      // Product details
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

      // Product Add modal
      productModal: {
        show: false,
        saving: false,
        uploadingImg: false,
        form: {
          maSP: null,
          tenSP: '',
          loaiSanPham: { maLoai: '' },
          thuongHieu: { maTH: '' },
          gioiTinh: 2,
          moTa: '',
          trangThaiSP: 1,
          anhChinh: ''
        }
      },

      // Dropdown UI state
      openDropdown: null, // 'category', 'brand', 'gender', 'status'

      showDetailView: false,
    }
  },

  computed: {
    groupedVariants() {
      if (!this.selectedProduct?.variants) return {}
      const groups = {}
      this.selectedProduct.variants.forEach(v => {
        const size = v.sizeSP?.tenSize || 'N/A'
        if (!groups[size]) groups[size] = []
        groups[size].push(v)
      })
      
      const sizeOrder = ['35','36','37','38','39','40','41','42','43','44','45','XS', 'S', 'M', 'L', 'XL', '2XL', '3XL']
      const sortedKeys = Object.keys(groups).sort((a, b) => {
        const indexA = sizeOrder.indexOf(a)
        const indexB = sizeOrder.indexOf(b)
        if (indexA !== -1 && indexB !== -1) return indexA - indexB
        return a.localeCompare(b)
      })
      
      const sortedGroups = {}
      sortedKeys.forEach(k => { sortedGroups[k] = groups[k] })
      return sortedGroups
    }
  },

  methods: {
    // PRODUCTS
    async fetchProducts() {
      try {
        const res = await axios.get('/admin/products', { params: this.filters })
        // Sắp xếp theo ID tăng dần (1, 2, 3...)
        this.products = res.data.sort((a, b) => Number(a.maSP) - Number(b.maSP))
      } catch (e) {
        console.error(e)
        // Optionally handle reset error or something
      }
    },

    openProductModal() {
      this.productModal.form = {
        maSP: null,
        tenSP: '',
        loaiSanPham: { maLoai: '' },
        thuongHieu: { maTH: '' },
        gioiTinh: 2,
        moTa: '',
        trangThaiSP: 1,
        anhChinh: ''
      }
      this.productModal.show = true
    },

    async saveProduct() {
      this.productModal.saving = true;
      try {
        const response = await axios.post('/admin/products', this.productModal.form);
        if (response.data) {
          if (window.$toast) window.$toast.success('Thêm sản phẩm thành công!')
          else alert('Thêm sản phẩm thành công!')
          this.productModal.show = false;
          this.fetchProducts();
        }
      } catch (e) {
        if (window.$toast) window.$toast.error('Lỗi: ' + (e.response?.data?.message || 'Không thể tạo sản phẩm'))
        else alert('Lỗi: ' + (e.response?.data?.message || 'Không thể tạo sản phẩm'))
      } finally {
        this.productModal.saving = false;
      }
    },

    async uploadImage(event) {
      const file = event.target.files[0];
      if (!file) return;

      const formData = new FormData();
      formData.append('file', file);

      this.productModal.uploadingImg = true;
      try {
        const res = await axios.post('/upload', formData, {
          headers: { 'Content-Type': 'multipart/form-data' }
        });
        if (res.data && res.data.success) {
          this.productModal.form.anhChinh = res.data.url;
          if (window.$toast) window.$toast.success('Tải ảnh lên thành công!');
        } else {
          throw new Error(res.data.message || 'Lỗi tải ảnh');
        }
      } catch (error) {
        console.error('Upload error:', error);
        if (window.$toast) window.$toast.error('Lỗi tải ảnh: ' + (error.response?.data?.message || error.message));
        else alert('Lỗi tải ảnh: ' + (error.response?.data?.message || error.message));
      } finally {
        this.productModal.uploadingImg = false;
        if (this.$refs.fileInput) this.$refs.fileInput.value = null;
      }
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
      this.showDetailView = true
      this.loadingDetails = true
      try {
        const res = await axios.get(`/admin/products/${id}`)
        this.selectedProduct = res.data
      } catch (e) {
        console.error(e)
        this.showDetailView = false
      }
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
    },

    getBrandLogo(name) {
      if (!name) return '/img/placeholder.png'
      const slug = name.toLowerCase().replace(/[\s-]+/g, '')
      return `/images/brand/logo-${slug}.png`
    },

    isLightColor(hex) {
      if (!hex) return true;
      const r = parseInt(hex.slice(1, 3), 16);
      const g = parseInt(hex.slice(3, 5), 16);
      const b = parseInt(hex.slice(5, 7), 16);
      const brightness = (r * 299 + g * 587 + b * 114) / 1000;
      return brightness > 155;
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
