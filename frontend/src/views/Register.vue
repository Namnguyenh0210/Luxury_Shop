<template>
<main class="flex min-h-screen justify-center py-10 md:py-16 px-4 sm:px-6 lg:px-8">
                    <!-- Error/Success Messages -->
                    <div class="w-full mb-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded text-sm" v-if="errorMessage">
                        <p>{{ errorMessage }}</p>
                    </div>
                    <div class="w-full mb-4 p-3 bg-green-100 border border-green-400 text-green-700 rounded text-sm" v-if="successMessage">
                        <p>{{ successMessage }}</p>
                    </div>

                    <form method="post" class="flex w-full flex-col gap-5">
                        <label class="flex flex-col">
                            <p class="pb-2 text-sm font-medium leading-normal text-[#111111] dark:text-[#FAFAFA]">Họ tên *</p>
                            <input name="hoTen" required="" class="form-input h-12 w-full flex-1 resize-none overflow-hidden rounded border border-[#CFCFCF] bg-white/50 p-3 text-base font-normal leading-normal text-[#111111] placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3] dark:border-gray-600 dark:bg-black/30 dark:text-white dark:placeholder:text-gray-500" placeholder="Nhập họ và tên">
                        </label>
                        <label class="flex flex-col">
                            <p class="pb-2 text-sm font-medium leading-normal text-[#111111] dark:text-[#FAFAFA]">Email *</p>
                            <input name="email" type="email" required="" class="form-input h-12 w-full flex-1 resize-none overflow-hidden rounded border border-[#CFCFCF] bg-white/50 p-3 text-base font-normal leading-normal text-[#111111] placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3] dark:border-gray-600 dark:bg-black/30 dark:text-white dark:placeholder:text-gray-500" placeholder="Nhập email">
                        </label>
                        <label class="flex flex-col">
                            <p class="pb-2 text-sm font-medium leading-normal text-[#111111] dark:text-[#FAFAFA]">Mật khẩu * (ít nhất 6 ký tự)</p>
                            <div class="relative flex w-full flex-1 items-stretch">
                                <input name="matKhau" id="password" type="password" required="" minlength="6" class="form-input h-12 w-full flex-1 resize-none overflow-hidden rounded border border-[#CFCFCF] bg-white/50 p-3 pr-10 text-base font-normal leading-normal text-[#111111] placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3] dark:border-gray-600 dark:bg-black/30 dark:text-white dark:placeholder:text-gray-500" placeholder="Nhập mật khẩu">
                                <button id="togglePassword" class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 dark:text-gray-400 hover:text-[#111111] dark:hover:text-white" type="button">visibility</button>
                            </div>
                        </label>
                        <label class="flex flex-col">
                            <p class="pb-2 text-sm font-medium leading-normal text-[#111111] dark:text-[#FAFAFA]">Xác nhận mật khẩu *</p>
                            <div class="relative flex w-full flex-1 items-stretch">
                                <input name="confirmPassword" id="confirmPassword" type="password" required="" minlength="6" class="form-input h-12 w-full flex-1 resize-none overflow-hidden rounded border border-[#CFCFCF] bg-white/50 p-3 pr-10 text-base font-normal leading-normal text-[#111111] placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3] dark:border-gray-600 dark:bg-black/30 dark:text-white dark:placeholder:text-gray-500" placeholder="Nhập lại mật khẩu">
                                <button id="toggleConfirmPassword" class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 dark:text-gray-400 hover:text-[#111111] dark:hover:text-white" type="button">visibility</button>
                            </div>
                        </label>
                        <label class="flex flex-col">
                            <p class="pb-2 text-sm font-medium leading-normal text-[#111111] dark:text-[#FAFAFA]">Số điện thoại</p>
                            <input name="soDienThoai" type="tel" class="form-input h-12 w-full flex-1 resize-none overflow-hidden rounded border border-[#CFCFCF] bg-white/50 p-3 text-base font-normal leading-normal text-[#111111] placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3] dark:border-gray-600 dark:bg-black/30 dark:text-white dark:placeholder:text-gray-500" placeholder="Nhập số điện thoại (không bắt buộc)">
                        </label>
                        <button class="mt-4 flex h-12 w-full items-center justify-center rounded bg-[#000000] text-base font-bold text-white transition-opacity hover:opacity-90" type="submit">Đăng ký</button>
                        <div class="my-2 flex items-center gap-4">
                            <hr class="w-full border-t border-[#CFCFCF] dark:border-gray-700">
                            <p class="text-sm text-gray-500 dark:text-gray-400">hoặc</p>
                            <hr class="w-full border-t border-[#CFCFCF] dark:border-gray-700">
                        </div>
                        <button class="flex h-12 w-full items-center justify-center gap-3 rounded border border-[#CFCFCF] bg-white dark:bg-transparent dark:border-gray-600 dark:hover:bg-gray-800 text-base font-semibold text-[#111111] dark:text-white transition-colors hover:bg-gray-50" type="button">
                            <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"></path><path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"></path><path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z" fill="#FBBC05"></path><path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"></path></svg>
                            Đăng ký bằng Google
                        </button>
                    </form>
                    <div class="mt-8 text-center">
                        <p class="text-sm text-[#111111] dark:text-[#FAFAFA]">
                            Đã có tài khoản?
                            <a class="font-bold text-[#111111] hover:text-[#000000] dark:text-white dark:hover:text-primary" href="/login">Đăng nhập</a>
                        </p>
                    </div>
                
            
        
    </main>


<script>
    // Toggle password visibility
    document.addEventListener('DOMContentLoaded', function() {
        const togglePassword = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('password');
        const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');
        const confirmPasswordInput = document.getElementById('confirmPassword');

        if (togglePassword && passwordInput) {
            togglePassword.addEventListener('click', function() {
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                this.textContent = type === 'password' ? 'visibility' : 'visibility_off';
            });
        }

        if (toggleConfirmPassword && confirmPasswordInput) {
            toggleConfirmPassword.addEventListener('click', function() {
                const type = confirmPasswordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                confirmPasswordInput.setAttribute('type', type);
                this.textContent = type === 'password' ? 'visibility' : 'visibility_off';
            });
        }
    });
</script>



</template>

<script>
export default {
  name: 'ĐkiTk',
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
