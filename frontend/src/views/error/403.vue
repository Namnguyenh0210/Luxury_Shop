<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 px-4">
    <div class="max-w-md w-full text-center">
      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm p-10">
        <div class="flex items-center justify-center size-20 rounded-full bg-red-100 text-red-500 mx-auto mb-6">
          <span class="material-symbols-outlined text-5xl">block</span>
        </div>
        <h1 class="text-6xl font-extrabold text-gray-800 mb-2">403</h1>
        <h2 class="text-xl font-bold text-gray-700 mb-3">Truy Cập Bị Từ Chối</h2>
        <p class="text-gray-500 text-sm leading-relaxed mb-8">
          Bạn không có quyền truy cập vào trang này.<br/>
          Vui lòng đăng nhập với tài khoản có quyền phù hợp.
        </p>
        <div class="flex flex-col sm:flex-row gap-3 justify-center">
          <router-link to="/"
            class="flex items-center justify-center gap-2 px-6 py-3 rounded-xl bg-amber-700 text-white font-semibold hover:bg-amber-800 transition-colors">
            <span class="material-symbols-outlined text-[18px]">home</span>
            Về Trang Chủ
          </router-link>
          <router-link to="/login"
            class="flex items-center justify-center gap-2 px-6 py-3 rounded-xl border border-gray-300 bg-white text-gray-700 font-semibold hover:bg-gray-50 transition-colors">
            <span class="material-symbols-outlined text-[18px]">login</span>
            Đăng nhập lại
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Error403'
}
</script>
