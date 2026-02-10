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
						</a> <a class="flex items-center gap-3 rounded-lg px-3 py-2 bg-accent/20 text-text-primary-light dark:text-text-primary-dark transition-colors" href="/admin/blogs">
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
							Lý Nội Dung</h2>
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
						<h1 class="text-2xl font-bold text-slate-800 dark:text-white">Bài
							Viết &amp; Tin Tức</h1>
						<button onclick="openModal()" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium flex items-center gap-2 transition-colors">
							<span class="material-symbols-outlined text-[18px]">add</span>
							Viết bài mới
						</button>
					</div>

					<div class="p-4 bg-green-100 text-green-700 rounded-lg flex items-center gap-2" v-if="success">
						<span class="material-symbols-outlined">check_circle</span> <span>{{ success }}</span>
					</div>
					<div class="p-4 bg-red-100 text-red-700 rounded-lg flex items-center gap-2" v-if="error">
						<span class="material-symbols-outlined">error</span> <span>{{ error }}</span>
					</div>

					<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
						<div class="group bg-white dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700 overflow-hidden hover:shadow-lg transition-all" v-for="bv in posts" :key="bv.id || index">

							<div class="h-48 overflow-hidden relative">
								<img class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" src="${bv.hinhAnh != null ? bv.hinhAnh : 'https://placehold.co/600x400?text=No+Image'}">

								<span class="absolute top-3 right-3 bg-white/90 text-slate-800 px-2 py-1 rounded text-xs font-bold uppercase shadow-sm">{{ bv.loaiBaiViet?.tenLoaiBV ?: 'Tin tức' }}</span>
							</div>

							<div class="p-5">
								<h3 class="text-lg font-bold text-slate-900 dark:text-white mb-2 line-clamp-2">{{ bv.tieuDe }}</h3>

								<p class="text-sm text-slate-500 dark:text-slate-400 line-clamp-3 mb-4 h-[60px]">{{ bv.noiDung }}</p>

								<div class="flex items-center justify-between pt-4 border-t border-slate-100 dark:border-slate-700">
									<div class="flex items-center gap-2 text-xs text-slate-500">
										<span class="material-symbols-outlined text-sm">calendar_today</span>
										<span>{{ bv.ngayDang != null ? #temporals.format(bv.ngayDang, 'dd/MM/yyyy') : '---' }}</span>
									</div>
									<div class="flex gap-2">
										<button type="button" onclick="editBlog(this)" class="text-blue-600 hover:bg-blue-50 p-1.5 rounded transition-colors" title="Sửa">
											<span class="material-symbols-outlined text-lg">edit</span>
										</button>
										<a class="text-red-600 hover:bg-red-50 p-1.5 rounded transition-colors" onclick="return confirm('Xóa bài viết này?')" title="Xóa" href="/admin/blogs/delete/{id(id=${bv.maBV})}">
											<span class="material-symbols-outlined text-lg">delete</span>
										</a>
									</div>
								</div>
							</div>
						</div>

						<div class="col-span-full text-center py-12" v-if="#lists.isEmpty(posts)">
							<div class="bg-slate-50 inline-block p-4 rounded-full mb-3">
								<span class="material-symbols-outlined text-4xl text-slate-300">article</span>
							</div>
							<p class="text-slate-500">Chưa có bài viết nào.</p>
						</div>
					</div>
				</div>
			</main>
		</div>

		<div id="blogModal" class="fixed inset-0 z-50 hidden bg-black/50 backdrop-blur-sm flex items-center justify-center p-4">
			<div class="bg-white dark:bg-slate-800 rounded-xl shadow-xl w-full max-w-2xl overflow-hidden animate-fade-in">
				<div class="px-6 py-4 border-b border-slate-200 dark:border-slate-700 flex justify-between items-center">
					<h3 class="text-lg font-bold text-slate-900 dark:text-white" id="modalTitle">Viết Bài Mới</h3>
					<button onclick="closeModal()" class="text-slate-400 hover:text-slate-600">
						<span class="material-symbols-outlined">close</span>
					</button>
				</div>

				<form method="post" enctype="multipart/form-data" class="p-6 space-y-4">
					<input type="hidden" id="blogId" name="maBV">

					<div class="grid grid-cols-1 gap-4">
						<div>
							<label class="block text-sm font-medium mb-1">Tiêu đề bài
								viết</label> <input type="text" id="blogTitle" name="tieuDe" required="" class="w-full rounded-lg border-slate-300 dark:bg-slate-900 focus:ring-blue-500 py-2 px-3 text-sm">
						</div>

						<div>
							<label class="block text-sm font-medium mb-1">Danh mục</label> <select id="blogCategory" name="maLoaiBV" class="w-full rounded-lg border-slate-300 dark:bg-slate-900 py-2 px-3 text-sm">
								<option value="1">Tin tức</option>
								<option value="2">Xu hướng</option>
								<option value="3">Khuyến mãi</option>
							</select>
						</div>

						<div>
							<label class="block text-sm font-medium mb-1">Hình ảnh
								(URL hoặc Upload)</label> <input type="text" id="blogImage" name="hinhAnh" placeholder="https://example.com/image.jpg" class="w-full rounded-lg border-slate-300 dark:bg-slate-900 py-2 px-3 text-sm mb-2">
							<p class="text-xs text-gray-400">Hoặc chọn file (Tính năng
								nâng cao)</p>
							<input type="file" name="imageFile" class="block w-full text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
						</div>

						<div>
							<label class="block text-sm font-medium mb-1">Nội dung
								chi tiết</label>
							<textarea id="blogContent" name="noiDung" rows="6" class="w-full rounded-lg border-slate-300 dark:bg-slate-900 focus:ring-blue-500 py-2 px-3 text-sm"></textarea>
						</div>
					</div>

					<div class="pt-4 flex justify-end gap-2 border-t border-slate-200 dark:border-slate-700 mt-4">
						<button type="button" onclick="closeModal()" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg text-sm font-medium">Hủy</button>
						<button type="submit" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-sm font-medium">Đăng
							bài</button>
					</div>
				</form>
			</div>
		</div>

		<script>
        const modal = document.getElementById('blogModal');
        const modalTitle = document.getElementById('modalTitle');
        const formId = document.getElementById('blogId');
        const formTitle = document.getElementById('blogTitle');
        const formContent = document.getElementById('blogContent');
        const formImage = document.getElementById('blogImage');
        const formCat = document.getElementById('blogCategory');

        function openModal() {
            modalTitle.textContent = "Viết Bài Mới";
            formId.value = "";
            formTitle.value = "";
            formContent.value = "";
            formImage.value = "";
            modal.classList.remove('hidden');
        }

        function closeModal() {
            modal.classList.add('hidden');
        }

        function editBlog(btn) {
            modalTitle.textContent = "Sửa Bài Viết";
            formId.value = btn.getAttribute('data-id');
            formTitle.value = btn.getAttribute('data-title');
            formContent.value = btn.getAttribute('data-content');
            formImage.value = btn.getAttribute('data-image');
            
            const cat = btn.getAttribute('data-cat');
            if(cat) formCat.value = cat;

            modal.classList.remove('hidden');
        }
    </script>
	</div>


</template>

<script>
export default {
  name: 'blog-list',
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
