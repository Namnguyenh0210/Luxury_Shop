<template>

	<div class="relative flex min-h-screen w-full flex-col">
		<div class="flex h-full w-full grow">

<!--			<aside class="flex h-screen min-h-full w-64 flex-col justify-between border-r border-border-light dark:border-border-dark bg-card-light dark:bg-card-dark p-4 sticky top-0">-->
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
						<a class="flex items-center gap-3 rounded-lg px-3 py-2 bg-accent/20 text-text-primary-light dark:text-text-primary-dark transition-colors" href="/admin/dashboard">
							<span class="material-symbols-outlined">dashboard</span>
							<p class="text-sm font-medium">Dashboard</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/products">
							<span class="material-symbols-outlined">diamond</span>
							<p class="text-sm font-medium">Sản Phẩm</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/inventory">
							<span class="material-symbols-outlined">inventory_2</span>
							<p class="text-sm font-medium">Kho &amp; NCC</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/orders">
							<span class="material-symbols-outlined">receipt_long</span>
							<p class="text-sm font-medium">Đơn Hàng</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/customers">
							<span class="material-symbols-outlined">group</span>
							<p class="text-sm font-medium">Tài Khoản</p>
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
						<h2 class="text-text-primary-light dark:text-text-primary-dark text-lg font-bold leading-tight tracking-[-0.015em]">Dashboard
							Tổng Quan</h2>
					</div>
					<div class="flex flex-1 justify-end gap-4 items-center">
						<div class="flex gap-2">
							<button class="flex h-10 w-10 items-center justify-center rounded-full hover:bg-black/5 text-text-secondary-light">
								<span class="material-symbols-outlined">notifications</span>
							</button>
						</div>
						<div class="flex flex-1 justify-end gap-4 items-center">
							<div class="flex gap-2">
								<button class="flex h-10 w-10 items-center justify-center rounded-full hover:bg-black/5 text-text-secondary-light">
									<span class="material-symbols-outlined">notifications</span>
								</button>

								<form method="post" class="flex items-center">
									<button type="submit" class="flex h-10 w-10 items-center justify-center rounded-full hover:bg-red-50 text-red-500 transition-colors" title="Đăng xuất">
										<span class="material-symbols-outlined">logout</span>
									</button>
								</form>
							</div>

							<div class="size-10 rounded-full bg-slate-300 overflow-hidden">
								<img src="https://ui-avatars.com/api/?name=Admin&amp;background=random" alt="Admin">
							</div>
						</div>
					</div>
				</header>

				<div class="flex flex-1 flex-col p-10 gap-10">

					<div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">

						<div class="flex flex-col gap-1 rounded-xl p-6 border border-border-light dark:border-border-dark bg-card-light dark:bg-card-dark">
							<p class="text-text-secondary-light dark:text-text-secondary-dark text-sm font-medium">Tổng
								Doanh Thu</p>
							<p class="text-text-primary-light dark:text-text-primary-dark text-3xl font-bold tracking-tight">{{ #numbers.formatDecimal(totalRevenue, 0, 'COMMA', 0, 'POINT') + ' đ' }}</p>
							<p class="text-green-600 dark:text-green-400 text-sm font-medium">+100%
								vs tháng trước</p>
						</div>

						<div class="flex flex-col gap-1 rounded-xl p-6 border border-border-light dark:border-border-dark bg-card-light dark:bg-card-dark">
							<p class="text-text-secondary-light dark:text-text-secondary-dark text-sm font-medium">Đơn
								Chờ Xử Lý</p>
							<p class="text-text-primary-light dark:text-text-primary-dark text-3xl font-bold tracking-tight">{{ newOrdersCount }}</p>
							<p class="text-blue-600 dark:text-blue-400 text-sm font-medium">Cần
								duyệt ngay</p>
						</div>

						<div class="flex flex-col gap-1 rounded-xl p-6 border border-border-light dark:border-border-dark bg-card-light dark:bg-card-dark">
							<p class="text-text-secondary-light dark:text-text-secondary-dark text-sm font-medium">Lượt
								Truy Cập</p>
							<p class="text-text-primary-light dark:text-text-primary-dark text-3xl font-bold tracking-tight">{{ #numbers.formatDecimal(uniqueVisitors, 0, 'COMMA', 0, 'POINT') }}</p>
							<p class="text-green-600 dark:text-green-400 text-sm font-medium">+5.4%
								tháng này</p>
						</div>

						<div class="flex flex-col gap-1 rounded-xl p-6 border border-border-light dark:border-border-dark bg-card-light dark:bg-card-dark">
							<p class="text-text-secondary-light dark:text-text-secondary-dark text-sm font-medium">Tổng
								Khách Hàng</p>
							<p class="text-text-primary-light dark:text-text-primary-dark text-3xl font-bold tracking-tight">{{ totalCustomers }}</p>
							<p class="text-green-600 dark:text-green-400 text-sm font-medium">+12
								người mới</p>
						</div>
					</div>

					<div class="flex flex-col">
						<h2 class="text-text-primary-light dark:text-text-primary-dark text-[22px] font-bold leading-tight tracking-[-0.015em] mb-5">Truy
							Cập Nhanh</h2>
						<div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">

							<div class="flex flex-col gap-4 rounded-xl p-6 border border-border-light dark:border-border-dark bg-card-light dark:bg-card-dark hover:shadow-lg hover:-translate-y-1 transition-all duration-300">
								<div class="flex items-center gap-4">
									<div class="flex items-center justify-center size-12 rounded-lg bg-accent/20 text-accent">
										<span class="material-symbols-outlined !text-3xl">diamond</span>
									</div>
									<h3 class="text-text-primary-light dark:text-text-primary-dark text-lg font-bold leading-tight">Quản
										Lý Sản Phẩm</h3>
								</div>
								<p class="text-text-secondary-light dark:text-text-secondary-dark text-sm font-normal leading-normal">Thêm
									mới, chỉnh sửa, và quản lý tất cả sản phẩm.</p>
								<a class="mt-auto flex items-center gap-2 text-sm font-medium leading-normal text-text-primary-light dark:text-text-primary-dark hover:text-primary dark:hover:text-accent group" href="/admin/products">
									<span>Truy cập module</span> <span class="material-symbols-outlined text-base group-hover:translate-x-1 transition-transform">arrow_forward</span>
								</a>
							</div>

							<div class="flex flex-col gap-4 rounded-xl p-6 border border-border-light dark:border-border-dark bg-card-light dark:bg-card-dark hover:shadow-lg hover:-translate-y-1 transition-all duration-300">
								<div class="flex items-center gap-4">
									<div class="flex items-center justify-center size-12 rounded-lg bg-accent/20 text-accent">
										<span class="material-symbols-outlined !text-3xl">inventory_2</span>
									</div>
									<h3 class="text-text-primary-light dark:text-text-primary-dark text-lg font-bold leading-tight">Kho
										&amp; Nhà Cung Cấp</h3>
								</div>
								<p class="text-text-secondary-light dark:text-text-secondary-dark text-sm font-normal leading-normal">Quản
									lý tồn kho, nhà cung cấp và nhập hàng.</p>
								<a class="mt-auto flex items-center gap-2 text-sm font-medium leading-normal text-text-primary-light dark:text-text-primary-dark hover:text-primary dark:hover:text-accent group" href="/admin/inventory">
									<span>Truy cập module</span> <span class="material-symbols-outlined text-base group-hover:translate-x-1 transition-transform">arrow_forward</span>
								</a>
							</div>

							<div class="flex flex-col gap-4 rounded-xl p-6 border border-border-light dark:border-border-dark bg-card-light dark:bg-card-dark hover:shadow-lg hover:-translate-y-1 transition-all duration-300">
								<div class="flex items-center gap-4">
									<div class="flex items-center justify-center size-12 rounded-lg bg-accent/20 text-accent">
										<span class="material-symbols-outlined !text-3xl">receipt_long</span>
									</div>
									<h3 class="text-text-primary-light dark:text-text-primary-dark text-lg font-bold leading-tight">Quản
										Lý Đơn Hàng</h3>
								</div>
								<p class="text-text-secondary-light dark:text-text-secondary-dark text-sm font-normal leading-normal">Xem
									và xử lý các đơn hàng của khách hàng.</p>
								<a class="mt-auto flex items-center gap-2 text-sm font-medium leading-normal text-text-primary-light dark:text-text-primary-dark hover:text-primary dark:hover:text-accent group" href="/admin/orders">
									<span>Truy cập module</span> <span class="material-symbols-outlined text-base group-hover:translate-x-1 transition-transform">arrow_forward</span>
								</a>
							</div>

							<div class="flex flex-col gap-4 rounded-xl p-6 border border-border-light dark:border-border-dark bg-card-light dark:bg-card-dark hover:shadow-lg hover:-translate-y-1 transition-all duration-300">
								<div class="flex items-center gap-4">
									<div class="flex items-center justify-center size-12 rounded-lg bg-accent/20 text-accent">
										<span class="material-symbols-outlined !text-3xl">group</span>
									</div>
									<h3 class="text-text-primary-light dark:text-text-primary-dark text-lg font-bold leading-tight">Khách
										Hàng &amp; KM</h3>
								</div>
								<p class="text-text-secondary-light dark:text-text-secondary-dark text-sm font-normal leading-normal">Quản
									lý thông tin khách hàng và các chiến dịch marketing.</p>
								<a class="mt-auto flex items-center gap-2 text-sm font-medium leading-normal text-text-primary-light dark:text-text-primary-dark hover:text-primary dark:hover:text-accent group" href="/admin/customers">
									<span>Truy cập module</span> <span class="material-symbols-outlined text-base group-hover:translate-x-1 transition-transform">arrow_forward</span>
								</a>
							</div>

							<div class="flex flex-col gap-4 rounded-xl p-6 border border-border-light dark:border-border-dark bg-card-light dark:bg-card-dark hover:shadow-lg hover:-translate-y-1 transition-all duration-300">
								<div class="flex items-center gap-4">
									<div class="flex items-center justify-center size-12 rounded-lg bg-accent/20 text-accent">
										<span class="material-symbols-outlined !text-3xl">article</span>
									</div>
									<h3 class="text-text-primary-light dark:text-text-primary-dark text-lg font-bold leading-tight">Nội
										Dung &amp; Tương Tác</h3>
								</div>
								<p class="text-text-secondary-light dark:text-text-secondary-dark text-sm font-normal leading-normal">Quản
									lý bài viết blog, banner và các trang tĩnh.</p>
								<a class="mt-auto flex items-center gap-2 text-sm font-medium leading-normal text-text-primary-light dark:text-text-primary-dark hover:text-primary dark:hover:text-accent group" href="/admin/blogs">
									<span>Truy cập module</span> <span class="material-symbols-outlined text-base group-hover:translate-x-1 transition-transform">arrow_forward</span>
								</a>
							</div>

							<div class="flex flex-col gap-4 rounded-xl p-6 border border-border-light dark:border-border-dark bg-card-light dark:bg-card-dark hover:shadow-lg hover:-translate-y-1 transition-all duration-300">
								<div class="flex items-center gap-4">
									<div class="flex items-center justify-center size-12 rounded-lg bg-accent/20 text-accent">
										<span class="material-symbols-outlined !text-3xl">bar_chart</span>
									</div>
									<h3 class="text-text-primary-light dark:text-text-primary-dark text-lg font-bold leading-tight">Báo
										Cáo &amp; Thống Kê</h3>
								</div>
								<p class="text-text-secondary-light dark:text-text-secondary-dark text-sm font-normal leading-normal">Xem
									các báo cáo chi tiết về hoạt động kinh doanh.</p>
								<a class="mt-auto flex items-center gap-2 text-sm font-medium leading-normal text-text-primary-light dark:text-text-primary-dark hover:text-primary dark:hover:text-accent group" href="/admin/reports">
									<span>Truy cập module</span> <span class="material-symbols-outlined text-base group-hover:translate-x-1 transition-transform">arrow_forward</span>
								</a>
							</div>

						</div>
					</div>
				</div>
			</main>
		</div>
	</div>


</template>

<script>
export default {
  name: 'admin',
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
