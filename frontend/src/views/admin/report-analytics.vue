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
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/orders">
							<span class="material-symbols-outlined">receipt_long</span>
							<p class="text-sm font-medium">Đơn Hàng</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/customers">
							<span class="material-symbols-outlined">group</span>
							<p class="text-sm font-medium">Khách Hàng</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 text-text-secondary-light hover:bg-black/5 dark:hover:bg-white/5 transition-colors" href="/admin/blogs">
							<span class="material-symbols-outlined">article</span>
							<p class="text-sm font-medium">Nội Dung</p>
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 bg-accent/20 text-text-primary-light dark:text-text-primary-dark transition-colors" href="/admin/reports">
							<span class="material-symbols-outlined">bar_chart</span>
							<p class="text-sm font-medium">Báo Cáo</p>
						</a>
					</nav>
				</div>

			</aside>

			<main class="flex flex-1 flex-col">
				<header class="sticky top-0 z-10 flex items-center justify-between whitespace-nowrap border-b border-border-light dark:border-border-dark px-10 py-3 bg-background-light/80 dark:bg-background-dark/80 backdrop-blur-sm">
					<div class="flex items-center gap-8">
						<h2 class="text-text-primary-light dark:text-text-primary-dark text-lg font-bold leading-tight">Báo
							Cáo Thống Kê</h2>
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

					<div class="flex justify-between items-center mb-6">
						<h1 class="text-2xl font-bold text-slate-800 dark:text-white">Tổng
							Quan Kinh Doanh</h1>
						<select class="bg-white border border-slate-300 rounded-lg px-3 py-2 text-sm dark:bg-slate-800 dark:border-slate-600">
							<option>7 ngày qua</option>
							<option>Tháng này</option>
							<option>Năm nay</option>
						</select>
					</div>

					<div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">

						<div class="bg-gradient-to-br from-blue-500 to-blue-600 text-white p-6 rounded-2xl shadow-lg shadow-blue-500/30">
							<p class="text-blue-100 text-sm font-medium">Tổng Doanh Thu</p>
							<h3 class="text-3xl font-bold mt-2">{{ #numbers.formatDecimal(totalRevenue, 0, 'COMMA', 0, 'POINT') + ' đ' }}</h3>
							<p class="text-sm mt-4 bg-white/20 inline-block px-2 py-1 rounded">Thực
								tế</p>
						</div>

						<div class="bg-white dark:bg-slate-800 p-6 rounded-2xl border border-slate-200 dark:border-slate-700">
							<p class="text-slate-500 text-sm font-medium">Đơn hàng mới
								(Chờ XN)</p>
							<h3 class="text-3xl font-bold mt-2 text-slate-800 dark:text-white">{{ newOrders }}</h3>
							<p class="text-sm mt-4 text-green-600 font-medium">Cần xử lý
								ngay</p>
						</div>

						<div class="bg-white dark:bg-slate-800 p-6 rounded-2xl border border-slate-200 dark:border-slate-700">
							<p class="text-slate-500 text-sm font-medium">Sản phẩm đã bán</p>
							<h3 class="text-3xl font-bold mt-2 text-slate-800 dark:text-white">{{ soldProducts }}</h3>
							<p class="text-sm mt-4 text-slate-400 font-medium">Tổng số
								lượng</p>
						</div>

						<div class="bg-white dark:bg-slate-800 p-6 rounded-2xl border border-slate-200 dark:border-slate-700">
							<p class="text-slate-500 text-sm font-medium">Tổng khách hàng</p>
							<h3 class="text-3xl font-bold mt-2 text-slate-800 dark:text-white">{{ totalCustomers }}</h3>
							<p class="text-sm mt-4 text-green-600 font-medium">↗ Tăng
								trưởng</p>
						</div>
					</div>

					<div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
						<div class="bg-white dark:bg-slate-800 p-6 rounded-xl border border-slate-200 dark:border-slate-700">
							<h3 class="text-lg font-bold mb-4 text-slate-800 dark:text-white">Biểu
								Đồ Doanh Thu (7 Ngày)</h3>
							<div class="relative h-64 w-full">
								<canvas id="revenueChart"></canvas>
							</div>
						</div>

						<div class="bg-white dark:bg-slate-800 p-6 rounded-xl border border-slate-200 dark:border-slate-700">
							<h3 class="text-lg font-bold mb-4 text-slate-800 dark:text-white">Tỷ
								Trọng Danh Mục</h3>
							<div class="relative h-64 w-full flex justify-center">
								<canvas id="categoryChart"></canvas>
							</div>
						</div>
					</div>

					<script>
                    document.addEventListener('DOMContentLoaded', function() {
                        // Lấy dữ liệu từ Controller thông qua Thymeleaf Inline
                        /*[[${chartLabels}]]*/
                        const labels = [[${chartLabels}]];
                        
                        /*[[${chartData}]]*/
                        const data = [[${chartData}]];

                        // 1. Revenue Chart
                        const ctx1 = document.getElementById('revenueChart');
                        if(ctx1) {
                            new Chart(ctx1, {
                                type: 'line',
                                data: {
                                    labels: labels,
                                    datasets: [{
                                        label: 'Doanh thu (Triệu VNĐ)',
                                        data: data,
                                        borderColor: '#2563eb',
                                        backgroundColor: 'rgba(37, 99, 235, 0.1)',
                                        fill: true,
                                        tension: 0.4
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false
                                }
                            });
                        }

                        // 2. Category Chart (Dummy Data)
                        const ctx2 = document.getElementById('categoryChart');
                        if(ctx2) {
                            new Chart(ctx2, {
                                type: 'doughnut',
                                data: {
                                    labels: ['Áo Thun', 'Áo Khoác', 'Quần', 'Phụ Kiện'],
                                    datasets: [{
                                        data: [30, 20, 15, 35],
                                        backgroundColor: [
                                            '#3b82f6',
                                            '#8b5cf6',
                                            '#10b981',
                                            '#f59e0b'
                                        ]
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false
                                }
                            });
                        }
                    });
                </script>

				</div>
			</main>
		</div>
	</div>


</template>

<script>
export default {
  name: 'report-analytics',
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
