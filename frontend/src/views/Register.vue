<template>
    <main class="flex min-h-screen items-center justify-center py-10 md:py-16 px-4 sm:px-6 lg:px-8 bg-[papayawhip] breakout-full">
        <div class="w-full max-w-lg">
            <!-- Logo và tiêu đề -->
            <div class="text-center mb-8">
                <div class="flex justify-center mb-4">
                    <div class="w-16 h-16 bg-white rounded-full flex items-center justify-center shadow-lg">
                        <svg class="w-10 h-10 text-[#D5BFA3]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path>
                        </svg>
                    </div>
                </div>
                <h1 class="text-4xl font-bold text-[#8B5E3C] mb-2 font-serif">Luxury Fashion</h1>
                <p class="text-[#A67C52] text-sm">Tạo tài khoản mới</p>
            </div>

            <!-- Card đăng ký -->
            <div class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-2xl p-8 mb-8">
                <div class="text-center mb-6">
                    <h2 class="text-2xl font-bold text-gray-800 font-serif">Đăng ký ngay</h2>
                    <p class="text-gray-500 text-sm mt-1">Gia nhập cộng đồng Luxury Fashion</p>
                </div>

                <!-- Error/Success Messages -->
                <div class="w-full mb-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded text-sm" v-if="errorMessage">
                    <p>{{ errorMessage }}</p>
                </div>
                <div class="w-full mb-4 p-3 bg-green-100 border border-green-400 text-green-700 rounded text-sm" v-if="successMessage">
                    <p>{{ successMessage }}</p>
                </div>

                <form method="post" class="flex w-full flex-col gap-5">
                    <label class="flex flex-col">
                        <p class="pb-2 text-sm font-medium leading-normal text-[#111111]">Họ tên *</p>
                        <input name="hoTen" required="" class="form-input h-12 w-full flex-1 rounded border border-[#CFCFCF] bg-white p-3 text-base font-normal leading-normal text-[#111111] placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3]" placeholder="Nhập họ và tên">
                    </label>
                    <label class="flex flex-col">
                        <p class="pb-2 text-sm font-medium leading-normal text-[#111111]">Email *</p>
                        <input name="email" type="email" required="" class="form-input h-12 w-full flex-1 rounded border border-[#CFCFCF] bg-white p-3 text-base font-normal leading-normal text-[#111111] placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3]" placeholder="Nhập email">
                    </label>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <label class="flex flex-col">
                            <p class="pb-2 text-sm font-medium leading-normal text-[#111111]">Mật khẩu *</p>
                            <div class="relative flex w-full flex-1 items-stretch">
                                <input name="matKhau" id="password" type="password" required="" minlength="6" class="form-input h-12 w-full flex-1 rounded border border-[#CFCFCF] bg-white p-3 pr-10 text-base font-normal leading-normal text-[#111111] placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3]" placeholder="Mật khẩu">
                                <button id="togglePassword" class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-[#111111]" type="button">visibility</button>
                            </div>
                        </label>
                        <label class="flex flex-col">
                            <p class="pb-2 text-sm font-medium leading-normal text-[#111111]">Xác nhận mật khẩu *</p>
                            <div class="relative flex w-full flex-1 items-stretch">
                                <input name="confirmPassword" id="confirmPassword" type="password" required="" minlength="6" class="form-input h-12 w-full flex-1 rounded border border-[#CFCFCF] bg-white p-3 pr-10 text-base font-normal leading-normal text-[#111111] placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3]" placeholder="Xác nhận">
                                <button id="toggleConfirmPassword" class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-[#111111]" type="button">visibility</button>
                            </div>
                        </label>
                    </div>
                    <label class="flex flex-col">
                        <p class="pb-2 text-sm font-medium leading-normal text-[#111111]">Số điện thoại</p>
                        <input name="soDienThoai" type="tel" class="form-input h-12 w-full flex-1 rounded border border-[#CFCFCF] bg-white p-3 text-base font-normal leading-normal text-[#111111] placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3]" placeholder="Nhập số điện thoại (không bắt buộc)">
                    </label>
                    <button class="mt-4 flex h-12 w-full items-center justify-center rounded bg-[#D5BFA3] text-base font-bold text-white transition-all hover:bg-[#8B5E3C] shadow-lg shadow-[#D5BFA3]/20" type="submit">Đăng ký</button>
                    
                    <div class="my-2 flex items-center gap-4">
                        <hr class="w-full border-t border-[#CFCFCF]">
                        <p class="text-sm text-gray-500">hoặc</p>
                        <hr class="w-full border-t border-[#CFCFCF]">
                    </div>
                    
                    <button class="flex h-12 w-full items-center justify-center gap-3 rounded border border-[#CFCFCF] bg-white text-base font-semibold text-[#111111] transition-colors hover:bg-gray-50" type="button">
                        <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"></path><path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"></path><path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z" fill="#FBBC05"></path><path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"></path></svg>
                        Đăng ký bằng Google
                    </button>
                </form>

                <div class="mt-8 text-center border-t border-[#CFCFCF] pt-6">
                    <p class="text-sm text-[#111111]">
                        Đã có tài khoản?
                        <a class="font-bold text-[#8B5E3C] hover:text-[#5D3E28] transition-colors" href="/login">Đăng nhập ngay</a>
                    </p>
                </div>
            </div>
        </div>
    </main>
</template>

<script>
export default {
    name: 'Register',
    data() {
        return {
            errorMessage: '',
            successMessage: ''
        }
    },
    mounted() {
        // Toggle password visibility
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
    }
}
</script>

<style scoped>
.font-serif {
    font-family: 'Playfair Display', serif;
}
.breakout-full {
    margin-left: -2cm;
    margin-right: -2cm;
    width: calc(100% + 4cm);
    max-width: none;
}
@media (max-width: 1024px) {
    .breakout-full {
        margin-left: -1.5cm;
        margin-right: -1.5cm;
        width: calc(100% + 3cm);
    }
}
@media (max-width: 640px) {
    .breakout-full {
        margin-left: -0.75cm;
        margin-right: -0.75cm;
        width: calc(100% + 1.5cm);
    }
}
</style>
