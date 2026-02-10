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
							<p class="text-sm font-medium leading-normal">Dashboard</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/products">
							<span class="material-symbols-outlined">diamond</span>
							<p class="text-sm font-medium leading-normal">Sản Phẩm</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/inventory">
							<span class="material-symbols-outlined">inventory_2</span>
							<p class="text-sm font-medium leading-normal">Kho &amp; NCC</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 bg-accent/20 text-text-primary-light dark:text-text-primary-dark transition-colors" href="/admin/orders">
							<span class="material-symbols-outlined">receipt_long</span>
							<p class="text-sm font-medium leading-normal">Đơn Hàng</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/customers">
							<span class="material-symbols-outlined">group</span>
							<p class="text-sm font-medium leading-normal">Khách Hàng</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/blogs">
							<span class="material-symbols-outlined">article</span>
							<p class="text-sm font-medium leading-normal">Nội Dung</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/reports">
							<span class="material-symbols-outlined">bar_chart</span>
							<p class="text-sm font-medium leading-normal">Báo Cáo</p>
						</a>
					</nav>
				</div>

			</aside>

			<main class="flex flex-1 flex-col">
				<header class="sticky top-0 z-10 flex items-center justify-between whitespace-nowrap border-b border-border-light dark:border-border-dark px-10 py-3 bg-background-light/80 dark:bg-background-dark/80 backdrop-blur-sm">
					<div class="flex items-center gap-8">
						<h2 class="text-text-primary-light dark:text-text-primary-dark text-lg font-bold leading-tight tracking-[-0.015em]">Quản
							Lý Đơn Hàng</h2>
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

					<div class="flex flex-col md:flex-row justify-between items-center mb-6 gap-4">
						<h1 class="text-2xl font-bold text-slate-800 dark:text-white">Danh
							Sách Đơn Hàng</h1>
						<form method="get" class="flex flex-col sm:flex-row gap-2 w-full md:w-auto">
							<div class="relative">
								<input type="text" name="keyword" placeholder="Tìm kiếm..." class="pl-3 pr-10 py-2 rounded-lg border-slate-300 text-sm w-full sm:w-64">
								<button type="submit" class="absolute right-2 top-2 text-slate-400">
									<span class="material-symbols-outlined text-lg">search</span>
								</button>
							</div>
							<select name="status" onchange="this.form.submit()" class="rounded-lg border-slate-300 text-sm cursor-pointer">
								<option value="">Tất
									cả</option>
								<option value="0">Chờ
									xác nhận</option>
								<option value="1">Đã
									xác nhận</option>
								<option value="2">Đang
									giao</option>
								<option value="3">Hoàn
									tất</option>
								<option value="4">Đã
									hủy</option>
							</select>
						</form>
					</div>

					<div class="overflow-hidden rounded-xl border border-slate-200 dark:border-slate-700 shadow-sm bg-white dark:bg-slate-800">
						<table class="w-full text-left text-sm text-slate-600 dark:text-slate-400" v-if="not #lists.isEmpty(orders)">
							<thead class="bg-slate-50 dark:bg-slate-700/50 text-xs uppercase font-semibold text-slate-700 dark:text-slate-200">
								<tr>
									<th class="px-6 py-4">Mã ĐH</th>
									<th class="px-6 py-4">Khách Hàng</th>
									<th class="px-6 py-4">Ngày Đặt</th>
									<th class="px-6 py-4">Tổng Tiền</th>
									<th class="px-6 py-4">Trạng Thái</th>
									<th class="px-6 py-4 text-right">Hành Động</th>
								</tr>
							</thead>
							<tbody class="divide-y divide-slate-200 dark:divide-slate-700">
								<tr class="hover:bg-slate-50 dark:hover:bg-slate-700/30 transition-colors" v-for="order in orders" :key="order.id || index">
									<td class="px-6 py-4 font-mono font-medium text-blue-600">#<span>{{ order.maDH }}</span></td>
									<td class="px-6 py-4">
										<div class="flex items-center gap-3">
											<div class="size-8 rounded-full bg-slate-200 flex items-center justify-center text-xs font-bold">KH</div>
											<div>
												<p class="font-medium text-slate-900 dark:text-white">{{ order.taiKhoan?.hoTen }}</p>
												<p class="text-xs text-slate-500">{{ order.taiKhoan?.email }}</p>
											</div>
										</div>
									</td>
									<td class="px-6 py-4">{{ #temporals.format(order.ngayDat, 'dd/MM/yyyy HH:mm') }}</td>
									<td class="px-6 py-4 font-bold text-slate-900 dark:text-white">{{ #numbers.formatDecimal(order.tongTien, 0, 'COMMA', 0, 'POINT') + ' đ' }}</td>
									<td class="px-6 py-4"><span> <span class="inline-flex items-center rounded-md bg-gray-50 px-2 py-1 text-xs font-medium text-gray-600 ring-1 ring-inset ring-gray-500/10">Chờ
												xác nhận</span> <span class="inline-flex items-center rounded-md bg-blue-50 px-2 py-1 text-xs font-medium text-blue-700 ring-1 ring-inset ring-blue-700/10">Đã
												xác nhận</span> <span class="inline-flex items-center rounded-md bg-purple-50 px-2 py-1 text-xs font-medium text-purple-700 ring-1 ring-inset ring-purple-700/10">Đang
												giao</span> <span class="inline-flex items-center rounded-md bg-green-50 px-2 py-1 text-xs font-medium text-green-700 ring-1 ring-inset ring-green-600/20">Hoàn
												tất</span> <span class="inline-flex items-center rounded-md bg-red-50 px-2 py-1 text-xs font-medium text-red-700 ring-1 ring-inset ring-red-600/10">Đã
												hủy</span>
									</span></td>
									<td class="px-6 py-4 text-right"><a class="inline-flex items-center justify-center p-2 text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded-full transition-colors" href="/admin/orders/detail/{id(id=${order.maDH})}">
											<span class="material-symbols-outlined text-[20px]">visibility</span>
									</a></td>
								</tr>
							</tbody>
						</table>

						<div class="flex flex-col items-center justify-center py-12 text-center" v-if="#lists.isEmpty(orders)">
							<p class="text-slate-500 text-sm">Không tìm thấy đơn hàng
								nào.</p>
							<a class="mt-2 text-blue-600 hover:underline text-sm" href="/admin/orders">Xóa bộ
								lọc</a>
						</div>
					</div>

					<div class="mt-6 flex justify-end gap-1" v-if="orderPage.totalPages > 1">
						<a class="px-3 py-1 border rounded hover:bg-slate-50" v-if="!orderPage.first" href="/admin/orders(page=${orderPage.number - 1, keyword=${keyword}, status=${currentStatus})}">Trước</a> <span class="px-3 py-1 bg-blue-600 text-white rounded">{{ orderPage.number + 1 }}</span> <a class="px-3 py-1 border rounded hover:bg-slate-50" v-if="!orderPage.last" href="/admin/orders(page=${orderPage.number + 1, keyword=${keyword}, status=${currentStatus})}">Sau</a>
					</div>

				</div>
			</main>
		</div>
	</div>


</template>

<script>
export default {
  name: 'order-list',
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
