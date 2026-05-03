<template>
  <main class="flex min-h-screen items-center justify-center py-10 md:py-16 px-4 sm:px-6 lg:px-8 bg-[papayawhip]">
    <div class="w-full max-w-lg">
      <!-- Logo & Tiêu đề -->
      <div class="text-center mb-8">
        <div class="flex justify-center mb-4">
          <div class="w-16 h-16 bg-white rounded-full flex items-center justify-center shadow-lg">
            <svg class="w-10 h-10 text-[#D5BFA3]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
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

        <!-- Messages -->
        <div v-if="errorMessage" class="w-full mb-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded text-sm">
          <p>{{ errorMessage }}</p>
        </div>
        <div v-if="successMessage" class="w-full mb-4 p-3 bg-green-100 border border-green-400 text-green-700 rounded text-sm">
          <p>{{ successMessage }}</p>
        </div>

        <form @submit.prevent="register" class="flex w-full flex-col gap-5">
          <label class="flex flex-col">
            <p class="pb-2 text-sm font-medium leading-normal text-[#111111]">Họ tên *</p>
            <input v-model="form.hoTen" placeholder="Nhập họ và tên"
                   class="form-input h-12 w-full flex-1 rounded border border-[#CFCFCF] bg-white p-3 text-base placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3]"/>
          </label>

          <label class="flex flex-col">
            <p class="pb-2 text-sm font-medium leading-normal text-[#111111]">Email *</p>
            <input v-model="form.email" type="email" placeholder="Nhập email"
                   class="form-input h-12 w-full flex-1 rounded border border-[#CFCFCF] bg-white p-3 text-base placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3]"/>
          </label>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <label class="flex flex-col">
              <p class="pb-2 text-sm font-medium leading-normal text-[#111111]">Mật khẩu *</p>
              <div class="relative flex w-full flex-1 items-stretch">
                <input v-model="form.matKhau" id="password" type="password" minlength="6" placeholder="Mật khẩu"
                       class="form-input h-12 w-full flex-1 rounded border border-[#CFCFCF] bg-white p-3 pr-10 text-base placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3]"/>
                <button type="button" @click="togglePassword('password')"
                        class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-[#111111]">
                  {{ showPassword.password ? 'visibility_off' : 'visibility' }}
                </button>
              </div>
            </label>

            <label class="flex flex-col">
              <p class="pb-2 text-sm font-medium leading-normal text-[#111111]">Xác nhận mật khẩu *</p>
              <div class="relative flex w-full flex-1 items-stretch">
                <input v-model="form.confirmPassword" id="confirmPassword" type="password" minlength="6" placeholder="Xác nhận"
                       class="form-input h-12 w-full flex-1 rounded border border-[#CFCFCF] bg-white p-3 pr-10 text-base placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3]"/>
                <button type="button" @click="togglePassword('confirmPassword')"
                        class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-[#111111]">
                  {{ showPassword.confirmPassword ? 'visibility_off' : 'visibility' }}
                </button>
              </div>
            </label>
          </div>

          <label class="flex flex-col">
            <p class="pb-2 text-sm font-medium leading-normal text-[#111111]">Địa chỉ *</p>
            <input
                v-model="form.diaChi"
                type="text"
                placeholder="Nhập địa chỉ của bạn"
                required
                class="form-input h-12 w-full flex-1 rounded border border-[#CFCFCF] bg-white p-3 text-base placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3]"
            />
          </label>

          <label class="flex flex-col">
            <p class="pb-2 text-sm font-medium leading-normal text-[#111111]">Số điện thoại *</p>
            <input v-model="form.soDienThoai" type="tel" placeholder="Nhập 10 số, bắt đầu bằng 0 (vd: 09...)" required
                   class="form-input h-12 w-full flex-1 rounded border border-[#CFCFCF] bg-white p-3 text-base placeholder:text-[#CFCFCF] focus:border-[#D5BFA3] focus:outline-none focus:ring-1 focus:ring-[#D5BFA3]"/>
          </label>

          <button type="submit"
                  class="mt-4 flex h-12 w-full items-center justify-center rounded bg-[#D5BFA3] text-base font-bold text-white transition-all hover:bg-[#8B5E3C] shadow-lg shadow-[#D5BFA3]/20">
            Đăng ký
          </button>

          <div class="mt-8 text-center border-t border-[#CFCFCF] pt-6">
            <p class="text-sm text-[#111111]">
              Đã có tài khoản?
              <router-link class="font-bold text-[#8B5E3C] hover:text-[#5D3E28] transition-colors" to="/login">Đăng nhập ngay</router-link>
            </p>
          </div>
        </form>
      </div>
    </div>
  </main>
</template>

<script>
export default {
  name: 'Register',
  data() {
    return {
      form: {
        hoTen: '',
        email: '',
        matKhau: '',
        confirmPassword: '',
        soDienThoai: '',
        diaChi: ''
      },
      errorMessage: '',
      successMessage: '',
      showPassword: {
        password: false,
        confirmPassword: false
      }
    }
  },
  methods: {
    togglePassword(field) {
      this.showPassword[field] = !this.showPassword[field];
      const input = document.getElementById(field);
      input.type = this.showPassword[field] ? 'text' : 'password';
    },
    async register() {
      this.errorMessage = '';
      this.successMessage = '';

      // Kiểm tra client-side
      if (this.form.matKhau !== this.form.confirmPassword) {
        this.errorMessage = 'Mật khẩu xác nhận không khớp!';
        return;
      }

      const phoneRegex = /^(0)(3|5|7|8|9)[0-9]{8}$/;
      if (!this.form.soDienThoai || !phoneRegex.test(this.form.soDienThoai)) {
        this.errorMessage = 'Số điện thoại không hợp lệ. Vui lòng nhập đúng 10 chữ số chuẩn của Việt Nam!';
        return;
      }

      try {
        const res = await fetch('http://localhost:8080/api/auth/register', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(this.form)
        });

        const text = await res.text();

        if (!res.ok) {
          this.errorMessage = text || 'Có lỗi xảy ra!';
        } else {
          this.successMessage = 'Đăng ký thành công! Chuyển hướng đến trang đăng nhập...';
          setTimeout(() => {
            this.$router.push('/login');
          }, 1200);
        }
      } catch (err) {
        this.errorMessage = err.message || 'Lỗi kết nối server!';
      }
    }
  }
}
</script>

<style scoped>
.font-serif {
  font-family: 'Times New Roman', Times, serif;
}
</style>