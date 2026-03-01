<template>
  <div class="flex min-h-screen">

    <!-- SIDEBAR -->
    <aside class="w-64 border-r p-4 bg-white">
      <h2 class="font-bold text-lg mb-6">ADMIN</h2>

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

      <!-- HEADER -->
      <div class="flex justify-between items-center mb-6">
        <h1 class="text-2xl font-bold">Danh Sách Đơn Hàng</h1>

        <div class="flex gap-2">

          <!-- SEARCH -->
          <input
              v-model="keyword"
              @input="fetchOrders"
              placeholder="Tìm kiếm..."
              class="border px-3 py-2 rounded w-64 text-sm" />

          <!-- STATUS FILTER -->
          <select
              v-model="status"
              @change="fetchOrders"
              class="border px-3 py-2 rounded text-sm">

            <option value="">Tất cả</option>
            <option value="0">Chờ xác nhận</option>
            <option value="1">Đã xác nhận</option>
            <option value="2">Đang giao</option>
            <option value="3">Hoàn tất</option>
            <option value="4">Đã hủy</option>
          </select>

        </div>
      </div>

      <!-- TABLE -->
      <div class="border rounded-xl overflow-hidden bg-white">

        <table v-if="orders.length > 0" class="w-full text-sm">
          <thead class="bg-gray-50 text-xs uppercase">
          <tr>
            <th class="px-6 py-4">Mã</th>
            <th class="px-6 py-4">Khách</th>
            <th class="px-6 py-4">Ngày</th>
            <th class="px-6 py-4">Tổng</th>
            <th class="px-6 py-4">Trạng thái</th>
            <th class="px-6 py-4 text-right"></th>
          </tr>
          </thead>

          <tbody>
          <tr
              v-for="order in orders"
              :key="order.id"
              class="border-t hover:bg-gray-50">

            <td class="px-6 py-4 font-mono text-blue-600">
              #{{ order.maDH }}
            </td>

            <td class="px-6 py-4">
              <div>
                <p class="font-medium">
                  {{ order.taiKhoan?.hoTen || 'Khách vãng lai' }}
                </p>
                <p class="text-xs text-gray-500">
                  {{ order.taiKhoan?.email }}
                </p>
              </div>
            </td>

            <td class="px-6 py-4">
              {{ formatDate(order.ngayDat) }}
            </td>

            <td class="px-6 py-4 font-bold">
              {{ formatCurrency(order.tongTien) }}
            </td>

            <td class="px-6 py-4">
                <span
                    class="px-2 py-1 text-xs rounded-md"
                    :class="statusClass(order.trangThaiDH)">
                  {{ statusText(order.trangThaiDH) }}
                </span>
            </td>

            <td class="px-6 py-4 text-right">
              <RouterLink
                  :to="`/admin/orders/${order.id}`"
                  class="text-blue-600 hover:underline">
                Xem
              </RouterLink>
            </td>

          </tr>
          </tbody>
        </table>

        <!-- EMPTY -->
        <div v-else class="py-12 text-center text-gray-500">
          Không có đơn hàng nào
        </div>

      </div>

      <!-- PAGINATION -->
      <div
          v-if="totalPages > 1"
          class="flex justify-end gap-2 mt-6">

        <button
            v-if="page > 0"
            @click="changePage(page - 1)"
            class="px-3 py-1 border rounded">
          Trước
        </button>

        <span class="px-3 py-1 bg-blue-600 text-white rounded">
          {{ page + 1 }}
        </span>

        <button
            v-if="page < totalPages - 1"
            @click="changePage(page + 1)"
            class="px-3 py-1 border rounded">
          Sau
        </button>

      </div>

    </main>
  </div>
</template>