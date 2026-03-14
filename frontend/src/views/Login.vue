<template>

    <main class="flex min-h-screen items-center justify-center py-8 px-4 sm:px-6 lg:px-8 bg-[papayawhip] breakout-full">
        <div class="w-full max-w-md">
            <!-- Logo và tiêu đề -->
            <div class="text-center mb-8 logo-animation">
                <div class="flex justify-center mb-4">
                    <div class="w-16 h-16 bg-white rounded-full flex items-center justify-center shadow-lg">
                        <svg class="w-10 h-10 text-[#D5BFA3]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path>
                        </svg>
                    </div>
                </div>
                <h1 class="text-4xl font-bold text-[#8B5E3C] mb-2 font-serif">Luxury Fashion</h1>
                <p class="text-[#A67C52] text-sm">Đăng nhập để tiếp tục</p>
            </div>

            <!-- Card đăng nhập -->
            <div class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-2xl p-8">
                <div class="text-center mb-6">
                    <h2 class="text-2xl font-bold text-gray-800 font-serif">Chào mừng trở lại!</h2>
                    <p class="text-gray-500 text-sm mt-1">Đăng nhập vào tài khoản của bạn</p>
                </div>

                <!-- Error/Success Messages -->
                <div class="mb-4 p-4 bg-red-50 border-l-4 border-red-500 rounded-r-lg flex items-start gap-3 animate-pulse" v-if="errorMessage">
                    <svg class="w-5 h-5 text-red-500 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path>
                    </svg>
                    <p class="text-red-700 text-sm">{{ errorMessage }}</p>
                </div>
                <div class="mb-4 p-4 bg-green-50 border-l-4 border-green-500 rounded-r-lg flex items-start gap-3 animate-pulse" v-if="successMessage">
                    <svg class="w-5 h-5 text-green-500 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                    </svg>
                    <p class="text-green-700 text-sm">{{ successMessage }}</p>
                </div>

                <!-- Login Form -->
                <form @submit.prevent="handleSubmit" class="space-y-5">
                    <!-- Username field -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            <span class="flex items-center gap-2">
                                <svg class="w-4 h-4 text-[#D5BFA3]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                </svg>
                                Email hoặc Số điện thoại
                            </span>
                        </label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                                </svg>
                            </span>
                            <input name="username" type="text" class="input-field w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#D5BFA3] focus:border-transparent outline-none" placeholder="Nhập email hoặc số điện thoại" required>
                        </div>
                    </div>

                    <!-- Password field -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            <span class="flex items-center gap-2">
                                <svg class="w-4 h-4 text-[#D5BFA3]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                                </svg>
                                Mật khẩu
                            </span>
                        </label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-400">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"></path>
                                </svg>
                            </span>
                            <input name="password" id="password" type="password" class="input-field w-full pl-10 pr-12 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#D5BFA3] focus:border-transparent outline-none" placeholder="Nhập mật khẩu" required>
                            <button type="button" @click="togglePassword" class="absolute inset-y-0 right-0 flex items-center pr-3 text-gray-400 hover:text-[#D5BFA3] transition-colors">
                                <svg id="eye-icon" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path v-if="showPassword" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268-2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/>
                                    <template v-else>
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268-2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                    </template>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <!-- Remember me & Forgot password -->
                    <div class="flex items-center justify-between">
                        <label class="flex items-center gap-2 cursor-pointer group">
                            <input name="remember-me" type="checkbox" class="w-4 h-4 text-[#D5BFA3] border-gray-300 rounded focus:ring-[#D5BFA3] focus:ring-2 cursor-pointer">
                            <span class="text-sm text-gray-600 group-hover:text-[#D5BFA3] transition-colors">Ghi nhớ đăng nhập</span>
                        </label>
                        <a class="text-sm text-[#8B5E3C] hover:text-[#5D3E28] font-medium hover:underline transition-colors" href="/quen-mat-khau">
                            Quên mật khẩu?
                        </a>
                    </div>

                    <!-- Submit button -->
                    <button type="submit" :disabled="isLoading" class="bg-[#D5BFA3] hover:bg-[#8B5E3C] w-full py-3 rounded-lg text-white font-semibold text-base shadow-lg transition-all" :class="{ 'opacity-50 cursor-not-allowed': isLoading }">
                        <span class="flex items-center justify-center gap-2">
                            <svg v-if="!isLoading" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"></path>
                            </svg>
                            <svg v-else class="animate-spin h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                            </svg>
                            {{ isLoading ? 'Đang đăng nhập...' : 'Đăng nhập' }}
                        </span>
                    </button>
                </form>

                <!-- Divider -->
                <div class="relative my-6">
                    <div class="absolute inset-0 flex items-center">
                        <div class="w-full border-t border-gray-300"></div>
                    </div>
                    <div class="relative flex justify-center text-sm">
                        <span class="px-4 bg-white/90 text-gray-500 rounded-full">hoặc đăng nhập với</span>
                    </div>
                </div>

                <!-- Google Login -->
                <a class="w-full flex items-center justify-center gap-3 py-3 px-4 border border-gray-300 rounded-lg bg-white hover:bg-gray-50 transition-all hover:shadow-md group" href="/oauth2/authorization/google">
                    <svg class="w-5 h-5" viewBox="0 0 24 24">
                        <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"></path>
                        <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"></path>
                        <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z"></path>
                        <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"></path>
                    </svg>
                    <span class="text-gray-700 font-medium group-hover:text-gray-900">Đăng nhập với Google</span>
                </a>

                <!-- Register link -->
                <div class="mt-8 text-center border-t border-gray-200 pt-6">
                    <p class="text-gray-600 text-sm">
                        Chưa có tài khoản?
                        <a class="text-[#8B5E3C] font-semibold hover:text-[#5D3E28] hover:underline transition-colors" href="/dang-ky">
                            Đăng ký ngay
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </main>

</template>

<script>
import axios from 'axios'

export default {
  name: 'Login',
  data() {
    return {
      showPassword: false,
      errorMessage: '',
      successMessage: '',
      isLoading: false
    }
  },
  methods: {
    togglePassword() {
      this.showPassword = !this.showPassword
      const passwordInput = document.getElementById('password')
      if (passwordInput) {
        passwordInput.type = this.showPassword ? 'text' : 'password'
      }
    },
    async handleSubmit(event) {
      event.preventDefault()
      
      this.errorMessage = ''
      this.successMessage = ''
      this.isLoading = true
      
      const formData = new FormData(event.target)
      const username = formData.get('username')
      const password = formData.get('password')
      
      try {
        const response = await axios.post('/auth/login', null, {
          params: {
            username,
            password
          }
        })
        
        if (response.data.success) {
          this.successMessage = response.data.message
          
          // Redirect after successful login
          setTimeout(() => {
            window.location.href = response.data.redirectUrl || '/'
          }, 500)
        } else {
          this.errorMessage = response.data.message || 'Đăng nhập thất bại'
        }
      } catch (error) {
        if (error.response && error.response.data) {
          this.errorMessage = error.response.data.message || 'Email hoặc mật khẩu không đúng!'
        } else {
          this.errorMessage = 'Có lỗi xảy ra khi đăng nhập. Vui lòng thử lại.'
        }
      } finally {
        this.isLoading = false
      }
    }
  },
  mounted() {
    // Check for URL parameters
    const urlParams = new URLSearchParams(window.location.search)
    if (urlParams.get('error')) {
      this.errorMessage = 'Email hoặc mật khẩu không đúng!'
    }
    if (urlParams.get('logout')) {
      this.successMessage = 'Đăng xuất thành công!'
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
