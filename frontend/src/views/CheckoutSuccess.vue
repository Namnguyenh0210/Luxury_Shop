<template>

<div layout:fragment="content">
    <main class="flex flex-1 justify-center py-10 md:py-16 px-4 sm:px-6 lg:px-8">
        <div class="layout-content-container flex w-full flex-col max-w-4xl flex-1">
            <div class="flex flex-col items-center text-center">
                <div class="mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-green-100 text-green-600">
                    <span class="material-symbols-outlined text-4xl">check_circle</span>
                </div>
                <h1 class="text-4xl md:text-5xl font-bold tracking-tight text-primary-text dark:text-white">
                    Cảm ơn đã đặt hàng!
                </h1>
                <p class="mt-3 max-w-md text-base text-gray-500 dark:text-gray-400">
                    Đơn hàng của bạn đã được tiếp nhận. Chúng tôi sẽ xử lý và giao hàng sớm nhất có thể.
                </p>
            </div>

            <!-- Chi tiết đơn hàng -->
            <div class="mt-12 w-full rounded-xl border border-[#e9d5c7] dark:border-gray-700 bg-[#fef8f3] dark:bg-gray-800">
                <div class="p-6 md:p-8">
                    <h3 class="text-xl font-bold tracking-tight text-primary-text dark:text-white">Chi tiết đơn hàng</h3>
                    <div class="mt-6 grid grid-cols-1 gap-x-4 gap-y-6 sm:grid-cols-2">
                        <div class="flex flex-col gap-1">
                            <p class="text-sm text-gray-500 dark:text-gray-400">Mã đơn hàng</p>
                            <p class="text-sm font-medium text-primary-text dark:text-white">'#' + {{ donHang.maDH }}</p>
                        </div>
                        <div class="flex flex-col gap-1">
                            <p class="text-sm text-gray-500 dark:text-gray-400">Ngày đặt hàng</p>
                            <p class="text-sm font-medium text-primary-text dark:text-white">{{ #temporals.format(donHang.ngayDat, 'dd/MM/yyyy HH:mm') }}</p>
                        </div>
                        <div class="flex flex-col gap-1">
                            <p class="text-sm text-gray-500 dark:text-gray-400">Tên khách hàng</p>
                            <p class="text-sm font-medium text-primary-text dark:text-white">{{ donHang.taiKhoan.hoTen }}</p>
                        </div>
                        <div class="flex flex-col gap-1">
                            <p class="text-sm text-gray-500 dark:text-gray-400">Địa chỉ giao hàng</p>
                            <p class="text-sm font-medium text-primary-text dark:text-white">{{ donHang.diaChiGiao != null ? donHang.diaChiGiao.diaChiChiTiet : 'N/A' }}</p>
                        </div>
                        <div class="flex flex-col gap-1 sm:col-span-2">
                            <p class="text-sm text-gray-500 dark:text-gray-400">Phương thức thanh toán</p>
                            <p class="text-sm font-medium text-primary-text dark:text-white">{{ donHang.hinhThucThanhToan != null ? donHang.hinhThucThanhToan.tenPhuongThuc : 'COD' }}</p>
                        </div>
                        <div class="flex flex-col gap-1 sm:col-span-2" v-if="donHang.ghiChu != null and !donHang.ghiChu.isEmpty()">
                            <p class="text-sm text-gray-500 dark:text-gray-400">Ghi chú</p>
                            <p class="text-sm font-medium text-primary-text dark:text-white">{{ donHang.ghiChu }}</p>
                        </div>
                    </div>
                </div>

                <!-- Danh sách sản phẩm -->
                <div class="border-t border-[#e9d5c7] dark:border-gray-700 p-6 md:p-8">
                    <h3 class="text-xl font-bold tracking-tight text-primary-text dark:text-white">Sản phẩm đã đặt</h3>
                    <ul class="mt-6 space-y-6" role="list">
                        <li class="flex items-start gap-4" v-for="item in chiTiet" :key="item.id || index">
                            <img class="h-20 w-20 flex-shrink-0 rounded-lg object-cover" onerror="this.src='/img/placeholder.png'" src="${item.sanPhamChiTiet.anhBienThe != null ? item.sanPhamChiTiet.anhBienThe :
                                          (item.sanPhamChiTiet.sanPham.anhChinh != null ? item.sanPhamChiTiet.sanPham.anhChinh : '/img/placeholder.png')}">
                            <div class="flex-1">
                                <p class="text-sm font-bold text-primary-text dark:text-white">{{ item.sanPhamChiTiet.sanPham.thuongHieu != null ? item.sanPhamChiTiet.sanPham.thuongHieu.tenTH : 'BRAND' }}</p>
                                <p class="text-sm text-gray-500 dark:text-gray-400">{{ item.sanPhamChiTiet.sanPham.tenSP }}</p>
                                <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
                                    <span v-if="item.sanPhamChiTiet.sizeSP != null">
                                        Size: <span>{{ item.sanPhamChiTiet.sizeSP.tenSize }}</span>
                                    </span>
                                    <span v-if="item.sanPhamChiTiet.mauSacSP != null">
                                        / Màu: <span>{{ item.sanPhamChiTiet.mauSacSP.tenMau }}</span>
                                    </span>
                                    / Số lượng: <span>{{ item.soLuong }}</span>
                                </p>
                            </div>
                            <p class="text-sm font-medium text-primary-text dark:text-white">{{ #numbers.formatDecimal(item.donGia, 0, 'COMMA', 0, 'POINT') }} + '₫'</p>
                        </li>
                    </ul>
                </div>

                <!-- Tổng tiền -->
                <div class="border-t border-[#e9d5c7] dark:border-gray-700 p-6 md:p-8">
                    <div class="space-y-3 text-sm">
                        <div class="flex justify-between">
                            <span class="text-gray-500 dark:text-gray-400">Tạm tính</span>
                            <span class="text-primary-text dark:text-white">{{ #numbers.formatDecimal(donHang.tongTien, 0, 'COMMA', 0, 'POINT') }} + '₫'</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-gray-500 dark:text-gray-400">Phí vận chuyển</span>
                            <span class="text-primary-text dark:text-white">Miễn phí</span>
                        </div>
                        <div class="flex justify-between border-t border-[#e9d5c7] dark:border-gray-700 pt-3 text-base font-bold">
                            <span class="text-primary-text dark:text-white">Tổng cộng</span>
                            <span class="text-primary-text dark:text-white">{{ #numbers.formatDecimal(donHang.tongTien, 0, 'COMMA', 0, 'POINT') }} + '₫'</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Các nút action -->
            <div class="mt-12 flex flex-col items-center gap-4 sm:flex-row sm:justify-center">
                <a class="flex w-full cursor-pointer items-center justify-center overflow-hidden rounded-lg h-12 bg-hover-cta text-white gap-2 text-sm font-bold tracking-wide min-w-0 px-6 hover:opacity-90 sm:w-auto" href="/sanpham">
                    Tiếp tục mua sắm
                </a>
                <a class="flex w-full cursor-pointer items-center justify-center overflow-hidden rounded-lg h-12 bg-transparent text-primary-text dark:text-white border border-gray-300 dark:border-gray-600 gap-2 text-sm font-bold tracking-wide min-w-0 px-6 hover:bg-gray-100 dark:hover:bg-gray-800 sm:w-auto" href="/profile">
                    Xem đơn hàng của tôi
                </a>
            </div>
        </div>
    </main>
</div>



</template>

<script>
export default {
  name: 'Checkout-success',
  data() {
    return {}
  },
  mounted() {
    // TODO: fetch data via axios or hydrate server state
  }
}
</script>

<style scoped>
/* TODO: import or copy CSS from original static/css */
</style>
