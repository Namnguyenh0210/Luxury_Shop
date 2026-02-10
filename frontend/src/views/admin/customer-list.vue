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
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 bg-accent/20 text-text-primary-light dark:text-text-primary-dark transition-colors" href="/admin/customers">
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
						<h2 class="text-text-primary-light dark:text-text-primary-dark text-lg font-bold leading-tight">Quản
							Lý Tài Khoản</h2>
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
						<h1 class="text-2xl font-bold text-slate-800 dark:text-white">Danh
							Sách Người Dùng</h1>

						<div class="flex gap-2">
							<form method="get" class="relative">
								<input type="text" name="keyword" placeholder="Tìm kiếm..." class="pl-10 pr-4 py-2 rounded-lg border border-slate-300 text-sm focus:ring-blue-500 w-64">
								<button type="submit" class="absolute left-3 top-2.5 text-slate-400">
									<span class="material-symbols-outlined text-[18px]">search</span>
								</button>
							</form>
							<button onclick="openModal()" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium flex items-center gap-2">
								<span class="material-symbols-outlined">add</span> Thêm Mới
							</button>
						</div>
					</div>

					<div class="p-4 bg-green-100 text-green-700 rounded-lg flex items-center gap-2" v-if="success">
						<span class="material-symbols-outlined">check_circle</span> <span>{{ success }}</span>
					</div>
					<div class="p-4 bg-red-100 text-red-700 rounded-lg flex items-center gap-2" v-if="error">
						<span class="material-symbols-outlined">error</span> <span>{{ error }}</span>
					</div>

					<div class="overflow-hidden rounded-xl border border-slate-200 dark:border-slate-700 shadow-sm bg-white dark:bg-slate-800">
						<table class="w-full text-left text-sm text-slate-600 dark:text-slate-400">
							<thead class="bg-slate-50 dark:bg-slate-700/50 text-xs uppercase font-semibold text-slate-700 dark:text-slate-200">
								<tr>
									<th class="px-6 py-4">ID</th>
									<th class="px-6 py-4">Họ Tên</th>
									<th class="px-6 py-4">Email</th>
									<th class="px-6 py-4">SĐT</th>
									<th class="px-6 py-4">Vai Trò</th>
									<th class="px-6 py-4">Trạng Thái</th>
									<th class="px-6 py-4 text-center">Hành Động</th>
								</tr>
							</thead>
							<tbody class="divide-y divide-slate-200 dark:divide-slate-700">

								<tr class="hover:bg-slate-50 dark:hover:bg-slate-700/30 transition-colors" v-for="u in customers" :key="u.id || index">
									<td class="px-6 py-4 font-mono">#<span>{{ u.maTK }}</span></td>
									<td class="px-6 py-4 font-medium text-slate-900 dark:text-white">{{ u.hoTen }}</td>
									<td class="px-6 py-4">{{ u.email }}</td>
									<td class="px-6 py-4">{{ u.soDienThoai ?: '---' }}</td>
									<td class="px-6 py-4">
										<div class="flex gap-1">
											<span class="bg-purple-100 text-purple-700 px-2 py-1 rounded text-xs border border-purple-200" v-for="r in u.roles" :key="r.id || index">{{ r.tenRole }}</span> <span class="text-gray-400 italic text-xs" v-if="#lists.isEmpty(u.roles)">Chưa cấp quyền</span>
										</div>
									</td>
									<td class="px-6 py-4"><span class="text-green-600 bg-green-50 px-2 py-1 rounded text-xs font-bold border border-green-200" v-if="u.trangThai">Hoạt
											động</span> <span class="text-red-600 bg-red-50 px-2 py-1 rounded text-xs font-bold border border-red-200" v-if="!(u.trangThai)">Đã
											khóa</span></td>
									<td class="px-6 py-4 text-center">
										<div class="flex justify-center gap-2">
											<button type="button" onclick="editUser(this)" class="text-blue-600 hover:bg-blue-50 p-2 rounded transition-colors" title="Sửa">
												<span class="material-symbols-outlined text-[20px]">edit</span>
											</button>

											<form method="post" class="inline">
												<button type="submit" class="p-2 rounded transition-colors">
													<span class="material-symbols-outlined text-[20px]">{{ u.trangThai }} ? 'lock' : 'lock_open'</span>
												</button>
											</form>

											<form method="post" class="inline">
												<button type="submit" onclick="return confirm('Xóa tài khoản này?')" class="text-red-600 hover:bg-red-50 p-2 rounded transition-colors" title="Xóa">
													<span class="material-symbols-outlined text-[20px]">delete</span>
												</button>
											</form>
										</div>
									</td>
								</tr>
							</tbody>
						</table>

						<div class="p-8 text-center text-slate-500" v-if="#lists.isEmpty(customers)">Chưa có tài khoản
							nào.</div>
					</div>
				</div>
			</main>
		</div>

		<div id="userModal" class="fixed inset-0 z-50 hidden bg-black/50 backdrop-blur-sm flex items-center justify-center p-4">
			<div class="bg-white dark:bg-slate-800 rounded-xl shadow-xl w-full max-w-2xl overflow-hidden animate-fade-in">
				<div class="px-6 py-4 border-b border-slate-200 dark:border-slate-700 flex justify-between items-center">
					<h3 class="text-lg font-bold text-slate-900 dark:text-white" id="modalTitle">Thêm Tài Khoản Mới</h3>
					<button onclick="closeModal()" class="text-slate-400 hover:text-slate-600">
						<span class="material-symbols-outlined">close</span>
					</button>
				</div>

				<form method="post" class="p-6 space-y-4">
					<input type="hidden" id="userId" name="maTK">

					<div class="grid grid-cols-2 gap-4">
						<div class="col-span-2">
							<label class="block text-sm font-medium mb-1">Họ tên</label> <input type="text" id="userName" name="hoTen" required="" class="w-full rounded-lg border-slate-300 dark:bg-slate-900 py-2 px-3 text-sm">
						</div>
						<div>
							<label class="block text-sm font-medium mb-1">Email</label> <input type="email" id="userEmail" name="email" required="" class="w-full rounded-lg border-slate-300 dark:bg-slate-900 py-2 px-3 text-sm">
						</div>
						<div>
							<label class="block text-sm font-medium mb-1">Số điện
								thoại</label> <input type="text" id="userPhone" name="soDienThoai" class="w-full rounded-lg border-slate-300 dark:bg-slate-900 py-2 px-3 text-sm">
						</div>
						<div class="col-span-2">
							<label class="block text-sm font-medium mb-1">Địa chỉ</label> <input type="text" id="userAddress" name="diaChi" class="w-full rounded-lg border-slate-300 dark:bg-slate-900 py-2 px-3 text-sm">
						</div>
						<div class="col-span-2">
							<label class="block text-sm font-medium mb-1">Mật khẩu <span class="text-xs text-slate-400 font-normal">(Để trống nếu
									giữ nguyên)</span></label> <input type="password" name="matKhauMoi" placeholder="******" class="w-full rounded-lg border-slate-300 dark:bg-slate-900 py-2 px-3 text-sm">
						</div>
						<div class="col-span-2">
							<label class="block text-sm font-medium mb-1">Vai Trò</label> <select id="userRole" name="vaiTroId" class="w-full rounded-lg border-slate-300 dark:bg-slate-900 py-2 px-3 text-sm">
								<option value="">-- Chọn vai trò --</option>
								<option v-for="r in vaiTros" :key="r.id || index">{{ r.tenRole }}</option>
							</select>
						</div>
					</div>

					<div class="pt-4 flex justify-end gap-2 border-t border-slate-200 dark:border-slate-700 mt-4">
						<button type="button" onclick="closeModal()" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg text-sm font-medium">Hủy</button>
						<button type="submit" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-sm font-medium">Lưu
							lại</button>
					</div>
				</form>
			</div>
		</div>

		<script>
        const modal = document.getElementById('userModal');
        const modalTitle = document.getElementById('modalTitle');
        const formId = document.getElementById('userId');
        const formName = document.getElementById('userName');
        const formEmail = document.getElementById('userEmail');
        const formPhone = document.getElementById('userPhone');
        const formAddress = document.getElementById('userAddress');
        const formRole = document.getElementById('userRole');

        function openModal() {
            modalTitle.textContent = "Thêm Tài Khoản Mới";
            formId.value = "";
            formName.value = "";
            formEmail.value = "";
            formPhone.value = "";
            formAddress.value = "";
            formRole.value = ""; 
            formEmail.readOnly = false;
            formEmail.classList.remove('bg-gray-100');
            modal.classList.remove('hidden');
        }

        function closeModal() {
            modal.classList.add('hidden');
        }

        function editUser(button) {
            const id = button.getAttribute('data-id');
            const name = button.getAttribute('data-name');
            const email = button.getAttribute('data-email');
            const phone = button.getAttribute('data-phone');
            const address = button.getAttribute('data-address');
            const role = button.getAttribute('data-role');

            modalTitle.textContent = "Cập Nhật Tài Khoản #" + id;
            formId.value = id;
            formName.value = name;
            formEmail.value = email;
            formPhone.value = phone;
            formAddress.value = address;
            if(role) formRole.value = role;
            
            formEmail.readOnly = true;
            formEmail.classList.add('bg-gray-100');
            
            modal.classList.remove('hidden');
        }
    </script>
	</div>


</template>

<script>
export default {
  name: 'customer-list',
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
