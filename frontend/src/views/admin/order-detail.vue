<template>

	<div class="relative flex min-h-screen w-full flex-col">
		<div class="flex h-full w-full grow">

			<aside class="flex h-screen min-h-full w-64 flex-col justify-between border-r border-border-light dark:border-border-dark bg-card-light dark:bg-card-dark p-4 sticky top-0">
				<div class="flex flex-col gap-8">
					<div class="flex items-center gap-3 px-3">
						<div class="size-10 rounded-full bg-slate-900 text-white flex items-center justify-center font-bold text-lg uppercase">
							<span sec:authentication="name">{{ #strings.substring(#authentication.name, 0, 1) }}</span>
						</div>

						<div class="flex flex-col">
							<h1 class="text-text-primary-light dark:text-text-primary-dark text-sm font-bold leading-normal truncate w-32" sec:authentication="name">Admin User</h1>
							<p class="text-text-secondary-light dark:text-text-secondary-dark text-xs font-normal leading-normal">
								<span sec:authentication="principal.authorities">ROLE_ADMIN</span>
							</p>
						</div>
					</div>

					<nav class="flex flex-col gap-2">
						<a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/dashboard">
							<span class="material-symbols-outlined">dashboard</span>
							<p class="text-sm font-medium">Dashboard</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/products">
							<span class="material-symbols-outlined">diamond</span>
							<p class="text-sm font-medium">Sản Phẩm</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/inventory">
							<span class="material-symbols-outlined">inventory_2</span>
							<p class="text-sm font-medium">Kho &amp; NCC</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 bg-accent/20 text-text-primary-light dark:text-text-primary-dark transition-colors" href="/admin/orders">
							<span class="material-symbols-outlined">receipt_long</span>
							<p class="text-sm font-medium">Đơn Hàng</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/customers">
							<span class="material-symbols-outlined">group</span>
							<p class="text-sm font-medium">Khách Hàng</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/blogs">
							<span class="material-symbols-outlined">article</span>
							<p class="text-sm font-medium">Nội Dung</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/reports">
							<span class="material-symbols-outlined">bar_chart</span>
							<p class="text-sm font-medium">Báo Cáo</p>
						</a>
					</nav>
				</div>


			</aside>

			<main class="flex flex-1 flex-col">
				<header class="sticky top-0 z-10 flex items-center justify-between whitespace-nowrap border-b border-border-light dark:border-border-dark px-10 py-3 bg-background-light/80 dark:bg-background-dark/80 backdrop-blur-sm">
					<div class="flex items-center gap-8">
						<h2 class="text-text-primary-light dark:text-text-primary-dark text-lg font-bold leading-tight">Chi
							Tiết Đơn Hàng</h2>
					</div>
					<div class="flex flex-1 justify-end gap-4 items-center">
						<div class="flex gap-2">
							<button class="flex h-10 w-10 items-center justify-center rounded-full hover:bg-black/5 text-text-secondary-light">
								<span class="material-symbols-outlined">notifications</span>
							</button>
						</div>
						<form method="post" class="flex items-center">
							<button type="submit" class="flex h-10 w-10 items-center justify-center rounded-full hover:bg-red-50 text-red-500 transition-colors" title="Đăng xuất">
								<span class="material-symbols-outlined">logout</span>
							</button>
						</form>
					</div>
				</header>

				<div class="flex flex-1 flex-col p-10 gap-10">

					<div v-if="order != null">
						<div class="flex flex-col md:flex-row justify-between items-start mb-6 gap-4">
							<div>
								<a class="text-sm text-slate-500 hover:text-blue-600 mb-2 inline-flex items-center gap-1" href="/admin/orders">
									<span class="material-symbols-outlined text-[16px]">arrow_back</span>
									Quay lại danh sách
								</a>

								<h1 class="text-2xl font-bold text-slate-900 dark:text-white flex items-center gap-2 mt-1">
									Đơn hàng #<span>{{ order.maDH }}</span> <span> <span class="text-sm px-3 py-1 rounded-full bg-gray-100 text-gray-700 border border-gray-200">Chờ
											xác nhận</span> <span class="text-sm px-3 py-1 rounded-full bg-blue-100 text-blue-700 border border-blue-200">Đã
											xác nhận</span> <span class="text-sm px-3 py-1 rounded-full bg-purple-100 text-purple-700 border border-purple-200">Đang
											giao</span> <span class="text-sm px-3 py-1 rounded-full bg-green-100 text-green-700 border border-green-200">Hoàn
											tất</span> <span class="text-sm px-3 py-1 rounded-full bg-red-100 text-red-700 border border-red-200">Đã
											hủy</span> <span class="text-sm px-3 py-1 rounded-full bg-gray-100">...</span>
									</span>
								</h1>
								<p class="text-slate-500 text-sm mt-1">
									Ngày đặt: <span>{{ order.ngayDat != null ? #temporals.format(order.ngayDat, 'dd/MM/yyyy HH:mm') : '---' }}</span>
								</p>
							</div>

							<div class="flex gap-3">
								<form method="post" class="flex gap-2">
									<input type="hidden" name="orderId">

									<button name="status" value="1" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium shadow-sm flex items-center gap-2" v-if="order.trangThaiDH == 0">
										<span class="material-symbols-outlined text-[18px]">check</span>
										Xác nhận
									</button>
									<button name="status" value="2" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-lg font-medium shadow-sm flex items-center gap-2" v-if="order.trangThaiDH == 1">
										<span class="material-symbols-outlined text-[18px]">local_shipping</span>
										Giao hàng
									</button>
									<button name="status" value="3" class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg font-medium shadow-sm flex items-center gap-2" v-if="order.trangThaiDH == 2">
										<span class="material-symbols-outlined text-[18px]">done_all</span>
										Hoàn tất
									</button>
									<button name="status" value="4" class="bg-white border border-red-200 text-red-600 hover:bg-red-50 px-4 py-2 rounded-lg font-medium flex items-center gap-2" onclick="return confirm('Hủy đơn hàng?')" v-if="order.trangThaiDH < 3">
										<span class="material-symbols-outlined text-[18px]">cancel</span>
										Hủy đơn
									</button>
								</form>
							</div>
						</div>

						<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

							<div class="lg:col-span-2 space-y-6">
								<div class="bg-white dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700 shadow-sm p-6">
									<h3 class="text-lg font-bold mb-4 text-slate-800 dark:text-white">Danh
										Sách Sản Phẩm</h3>

									<div class="divide-y divide-slate-100 dark:divide-slate-700">
										<div class="py-4 flex items-center gap-4" v-for="item in orderItems" :key="item.id || index">
											<div class="size-16 rounded-lg overflow-hidden border border-slate-200 bg-slate-50 flex-shrink-0">
												<img class="w-full h-full object-cover" v-if="item.sanPhamChiTiet?.anhBienThe != null" src="${item.sanPhamChiTiet.anhBienThe}"> <img src="https://placehold.co/100x100?text=No+Img" class="w-full h-full object-cover opacity-50" v-if="!(item.sanPhamChiTiet?.anhBienThe != null)">
											</div>

											<div class="flex-1">
												<h4 class="font-medium text-slate-900 dark:text-white line-clamp-1">{{ item.sanPhamChiTiet?.sanPham?.tenSP ?: 'Sản phẩm lỗi' }}</h4>
												<div class="flex items-center gap-3 mt-1 text-sm text-slate-500">
													<span class="bg-slate-100 px-2 py-0.5 rounded text-xs">Size:
														<b>{{ item.sanPhamChiTiet?.sizeSP?.tenSize ?: '-' }}</b>
													</span> <span class="bg-slate-100 px-2 py-0.5 rounded text-xs">Màu:
														<b>{{ item.sanPhamChiTiet?.mauSacSP?.tenMau ?: '-' }}</b>
													</span>
												</div>
											</div>

											<div class="text-right min-w-[100px]">
												<p class="font-medium text-slate-900">{{ #numbers.formatDecimal(item.donGia ?: 0, 0, 'COMMA', 0, 'POINT') + ' đ' }}</p>
												<p class="text-sm text-slate-500">
													x <span>{{ item.soLuong }}</span>
												</p>
											</div>
										</div>
									</div>

									<div class="mt-6 pt-6 border-t border-slate-100 dark:border-slate-700 flex flex-col items-end gap-2">
										<div class="flex justify-between w-full max-w-xs text-sm">
											<span class="text-slate-500">Tạm tính:</span> <span class="font-medium">{{ #numbers.formatDecimal((order.tongTien != null ? order.tongTien : 0) - (order.phiShip != null ? order.phiShip : 0), 0, 'COMMA', 0, 'POINT') + ' đ' }}</span>
										</div>
										<div class="flex justify-between w-full max-w-xs text-sm">
											<span class="text-slate-500">Phí vận chuyển:</span> <span class="font-medium">{{ #numbers.formatDecimal(order.phiShip != null ? order.phiShip : 0, 0, 'COMMA', 0, 'POINT') + ' đ' }}</span>
										</div>
										<div class="flex justify-between w-full max-w-xs text-lg font-bold text-slate-900 dark:text-white mt-2 pt-2 border-t border-dashed border-slate-200">
											<span>Tổng cộng:</span> <span class="text-blue-600">{{ #numbers.formatDecimal(order.tongTien != null ? order.tongTien : 0, 0, 'COMMA', 0, 'POINT') + ' đ' }}</span>
										</div>
									</div>
								</div>
							</div>

							<div class="space-y-6">

								<div class="bg-white dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700 shadow-sm p-6">
									<h3 class="text-lg font-bold mb-4 text-slate-800 dark:text-white">Thông
										Tin Khách Hàng</h3>
									<div class="flex items-center gap-3 mb-4">
										<div class="size-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 font-bold">
											<span class="material-symbols-outlined">person</span>
										</div>
										<div>
											<p class="font-bold text-slate-900 dark:text-white">{{ order.taiKhoan?.hoTen ?: 'Khách vãng lai' }}</p>
											<p class="text-sm text-slate-500">{{ order.taiKhoan?.email ?: '---' }}</p>
										</div>
									</div>

									<div class="space-y-3 pt-4 border-t border-slate-100 dark:border-slate-700">
										<div>
											<p class="text-xs text-slate-500 uppercase font-semibold mb-1 flex items-center gap-1">
												<span class="material-symbols-outlined text-[14px]">location_on</span>
												Địa chỉ giao hàng
											</p>
											<p class="text-sm text-slate-800 dark:text-slate-300 font-medium">{{ order.diaChiGiao?.hoTenNguoiNhan ?: 'Người nhận' }}</p>
											<p class="text-sm text-slate-600 dark:text-slate-400 mt-0.5">{{ order.diaChiGiao?.diaChiChiTiet ?: 'Chưa cập nhật địa chỉ' }}</p>
											<p class="text-sm text-slate-600 dark:text-slate-400 mt-1">
												SĐT: <span class="font-mono">{{ order.diaChiGiao?.soDienThoai ?: '---' }}</span>
											</p>
										</div>
									</div>
								</div>

								<div class="bg-white dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700 shadow-sm p-6">
									<h3 class="text-lg font-bold mb-4 text-slate-800 dark:text-white">Thanh
										Toán</h3>
									<div class="flex justify-between items-center mb-3">
										<span class="text-sm text-slate-500">Hình thức:</span> <span class="text-sm font-medium bg-slate-100 px-2 py-1 rounded">{{ order.hinhThucThanhToan?.tenHinhThuc ?: '---' }}</span>
									</div>
									<div class="mt-4 p-3 rounded-lg flex items-center gap-2 border">
										<span class="material-symbols-outlined text-[20px]">{{ order.trangThaiThanhToan == 1 ? 'check_circle' : 'pending' }}</span>
										<span class="text-sm font-medium">{{ order.trangThaiThanhToan == 1 ? 'Đã thanh toán' : 'Chưa thanh toán' }}</span>
									</div>
								</div>

								<div class="bg-white dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700 shadow-sm p-6" v-if="order.nhanVien != null">
									<h3 class="text-sm font-bold mb-3 uppercase text-slate-500">Nhân
										viên phụ trách</h3>
									<div class="flex items-center gap-2">
										<div class="size-8 rounded-full bg-purple-100 text-purple-600 flex items-center justify-center font-bold text-xs">NV</div>
										<span class="font-medium text-slate-900">{{ order.nhanVien.hoTen }}</span>
									</div>
								</div>
							</div>
						</div>
					</div>

					<div class="text-center py-20" v-if="!(order != null)">
						<h3 class="text-xl text-red-500">Không tìm thấy thông tin đơn
							hàng này.</h3>
						<a class="text-blue-600 hover:underline mt-4 block" href="/admin/orders">Quay lại
							danh sách</a>
					</div>

				</div>
			</main>
		</div>
	</div>


</template>

<script>
export default {
  name: 'order-detail',
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
