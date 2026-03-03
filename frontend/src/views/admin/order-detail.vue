<template>
  <div class="relative flex min-h-screen w-full flex-col">
    <div class="flex h-full w-full grow">

      <!-- SIDEBAR -->
      <aside class="w-64 border-r p-4 bg-white">

        <!-- USER INFO -->
        <div class="flex items-center gap-3 mb-8">
          <div class="size-10 rounded-full bg-slate-900 text-white flex items-center justify-center font-bold text-lg uppercase">
            {{ userInitial }}
          </div>
          <div>
            <h1 class="text-sm font-bold truncate w-32">
              {{ currentUser?.name }}
            </h1>
            <p class="text-xs text-gray-500">
              {{ currentUser?.role }}
            </p>
          </div>
        </div>

        <!-- NAV -->
        <nav class="flex flex-col gap-2 text-sm">
          <RouterLink to="/admin/dashboard">Dashboard</RouterLink>
          <RouterLink to="/admin/products">Sản Phẩm</RouterLink>
          <RouterLink to="/admin/inventory">Kho & NCC</RouterLink>
          <RouterLink to="/admin/orders" class="font-bold text-blue-600">
            Đơn Hàng
          </RouterLink>
        </nav>

      </aside>

      <!-- MAIN -->
      <main class="flex-1 p-10">

        <!-- LOADING -->
        <div v-if="loading" class="text-center py-20">
          Đang tải dữ liệu...
        </div>

        <!-- NOT FOUND -->
        <div v-else-if="!order" class="text-center py-20">
          <h3 class="text-xl text-red-500">
            Không tìm thấy đơn hàng
          </h3>
          <RouterLink to="/admin/orders" class="text-blue-600">
            Quay lại
          </RouterLink>
        </div>

        <!-- CONTENT -->
        <div v-else class="space-y-8">

          <!-- HEADER -->
          <div class="flex justify-between items-start">

            <div>
              <RouterLink
                  to="/admin/orders"
                  class="text-sm text-slate-500 hover:text-blue-600">
                ← Quay lại
              </RouterLink>

              <h1 class="text-2xl font-bold mt-2">
                Đơn hàng #{{ order.maDH }}
              </h1>

              <p class="text-sm text-gray-500">
                Ngày đặt: {{ formatDate(order.ngayDat) }}
              </p>

              <span
                  class="mt-2 inline-block px-3 py-1 rounded-full text-xs font-medium"
                  :class="statusClass">
                {{ statusText }}
              </span>
            </div>

            <!-- ACTION BUTTONS -->
            <div class="flex gap-2">
              <button
                  v-if="order.trangThaiDH === 0"
                  @click="updateStatus(1)"
                  class="bg-blue-600 text-white px-4 py-2 rounded">
                Xác nhận
              </button>

              <button
                  v-if="order.trangThaiDH === 1"
                  @click="updateStatus(2)"
                  class="bg-purple-600 text-white px-4 py-2 rounded">
                Giao hàng
              </button>

              <button
                  v-if="order.trangThaiDH === 2"
                  @click="updateStatus(3)"
                  class="bg-green-600 text-white px-4 py-2 rounded">
                Hoàn tất
              </button>

              <button
                  v-if="order.trangThaiDH < 3"
                  @click="cancelOrder"
                  class="border border-red-300 text-red-600 px-4 py-2 rounded">
                Hủy
              </button>
            </div>
          </div>

          <!-- PRODUCTS -->
          <div class="bg-white border rounded-xl p-6">

            <h3 class="text-lg font-bold mb-4">
              Danh sách sản phẩm
            </h3>

            <div
                v-for="item in orderItems"
                :key="item.id"
                class="flex items-center gap-4 py-4 border-b last:border-0">

              <img
                  :src="item.sanPhamChiTiet?.anhBienThe || placeholderImg"
                  class="w-16 h-16 object-cover rounded border"/>

              <div class="flex-1">
                <h4 class="font-medium">
                  {{ item.sanPhamChiTiet?.sanPham?.tenSP || 'Sản phẩm lỗi' }}
                </h4>
                <p class="text-sm text-gray-500">
                  Size: {{ item.sanPhamChiTiet?.sizeSP?.tenSize || '-' }} |
                  Màu: {{ item.sanPhamChiTiet?.mauSacSP?.tenMau || '-' }}
                </p>
              </div>

              <div class="text-right">
                <p class="font-medium">
                  {{ formatCurrency(item.donGia) }}
                </p>
                <p class="text-sm text-gray-500">
                  x {{ item.soLuong }}
                </p>
              </div>

            </div>

            <!-- TOTAL -->
            <div class="mt-6 text-right space-y-2">
              <p>Tạm tính: {{ formatCurrency(subTotal) }}</p>
              <p>Phí ship: {{ formatCurrency(order.phiShip) }}</p>
              <p class="font-bold text-blue-600 text-lg">
                Tổng: {{ formatCurrency(order.tongTien) }}
              </p>
            </div>

          </div>

        </div>
      </main>
    </div>
  </div>
</template>