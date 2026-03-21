<template>
<footer class="bg-[papayawhip] border-t border-secondary/50">
    <div class="w-full px-4 md:px-[3.7cm] py-8 max-w-full">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-8">
            <!-- Col 1: Logo & Info -->
            <div class="flex flex-col items-center text-center -mt-16">
                <a href="/" class="block -mb-10">
                    <img src="@/assets/img/freepik-vintage-ornamental-royal-place-hotel-logo-20260313155730GfDx (1).png" alt="Luxury Shop Logo" class="h-64 object-contain mix-blend-multiply" />
                </a>
                <p class="text-[15px] md:text-[16px] whitespace-nowrap font-bold text-text-primary-light dark:text-text-primary-dark tracking-wide leading-relaxed">
                    Cửa hàng<br/>Chuyên bán quần áo cao cấp
                </p>
            </div>

            <!-- Col 2: Support & Payment -->
            <div>
                <h3 class="text-sm font-bold uppercase tracking-wider text-text-primary-light dark:text-text-primary-dark mb-5 border-l-2 border-gray-900 pl-2">Bạn cần hỗ trợ</h3>
                <div class="space-y-1 mb-8 text-[15px] text-text-primary-light/80 dark:text-text-primary-dark/80">
                    <p class="font-black text-2xl text-gray-900 mb-2">0799 191 940</p>
                    <p><span class="font-bold mr-1">Email:</span> luxury@fashion.vn</p>
                </div>
                
                <h3 class="text-sm font-bold uppercase tracking-wider text-text-primary-light dark:text-text-primary-dark mb-4 border-l-2 border-gray-900 pl-2">Hỗ trợ hình thức thanh toán</h3>
                <div class="flex gap-2 items-center">
                    <span class="px-3 py-1.5 bg-white border border-gray-200 rounded-lg text-xs font-black text-gray-800 shadow-sm flex items-center justify-center">COD</span>
                    <span class="px-3 py-1.5 bg-gradient-to-r from-blue-700 to-blue-500 border border-transparent rounded-lg text-xs font-black text-white shadow-sm flex items-center justify-center italic tracking-wider">PayOS</span>
                </div>
            </div>

            <!-- Col 3: Hướng dẫn mua hàng -->
            <div>
                <h3 class="text-sm font-bold uppercase tracking-wider text-text-primary-light dark:text-text-primary-dark mb-5 border-l-2 border-gray-900 pl-2">Hướng dẫn mua hàng</h3>
                <ul class="space-y-3">
                    <li><a class="text-[14.5px] text-text-primary-light/80 dark:text-text-primary-dark/80 nav-link transition-colors font-medium  " href="/">Trang chủ</a></li>
                    <li><a class="text-[14.5px] text-text-primary-light/80 dark:text-text-primary-dark/80 nav-link transition-colors font-medium  " href="/sanpham">Tất cả sản phẩm</a></li>
                    <li><a class="text-[14.5px] text-text-primary-light/80 dark:text-text-primary-dark/80 nav-link transition-colors font-medium  " href="/kienthuc">Báo chí</a></li>
                    <li><a class="text-[14.5px] text-text-primary-light/80 dark:text-text-primary-dark/80 nav-link transition-colors font-medium  cursor-pointer " @click.prevent="openChatBox">Hỏi đáp cùng AI</a></li>
                    <li><a class="text-[14.5px] text-text-primary-light/80 dark:text-text-primary-dark/80 nav-link transition-colors font-medium  cursor-pointer " @click.prevent="openChatBox">Liên hệ</a></li>
                </ul>
            </div>

            <!-- Col 4: Chăm sóc khách hàng -->
            <div>
                <h3 class="text-sm font-bold uppercase tracking-wider text-text-primary-light dark:text-text-primary-dark mb-5 border-l-2 border-gray-900 pl-2">Chăm sóc khách hàng</h3>
                <ul class="space-y-3">
                    <li><a class="text-[14.5px] text-text-primary-light/80 dark:text-text-primary-dark/80 nav-link transition-colors font-medium  " href="/">Trang chủ</a></li>
                    <li><a class="text-[14.5px] text-text-primary-light/80 dark:text-text-primary-dark/80 nav-link transition-colors font-medium  cursor-pointer " @click.prevent="openChatBox">Hỏi đáp cùng AI</a></li>
                    <li><a class="text-[14.5px] text-text-primary-light/80 dark:text-text-primary-dark/80 nav-link transition-colors font-medium  cursor-pointer " @click.prevent="openChatBox">Liên hệ</a></li>
                </ul>
            </div>

            <!-- Col 5: Đăng ký -->
            <div>
                <h3 class="text-sm font-bold uppercase tracking-wider text-text-primary-light dark:text-text-primary-dark mb-5 border-l-2 border-gray-900 pl-2">Đăng ký nhận bản tin</h3>
                <p class="text-[14.5px] text-text-primary-light/80 dark:text-text-primary-dark/80 leading-relaxed mb-5">Nhận thông tin cập nhật độc quyền, sản phẩm mới và ưu đãi nội bộ.</p>
                <form class="flex w-full flex-col gap-3">
                    <label class="sr-only" for="email-address">Địa chỉ Email</label>
                    <input autocomplete="email" class="w-full appearance-none rounded-full border border-gray-300 bg-white px-5 py-3 text-[14.5px] text-gray-900 shadow-sm focus:border-gray-900 focus:ring-1 focus:ring-gray-900 outline-none transition-all placeholder-gray-400" id="email-address" name="email-address" placeholder="Địa chỉ Email" required="" type="email">
                    <button class="w-full rounded-full bg-gray-900 px-5 py-3 text-[14.5px] font-bold text-white shadow-sm hover:bg-black transition-colors" type="submit">Đăng ký</button>
                </form>
            </div>
        </div>
        <div class="mt-8 border-t border-secondary/50 pt-6 flex justify-center text-center items-center">
            <p class="text-sm font-medium text-text-primary-light/60 dark:text-text-primary-dark/60">© 2026 LUXURY SHOP. Bảo lưu mọi quyền.</p>
        </div>
    </div>
</footer>

</template>

<script>
export default {
  name: 'AppFooter',
  data() {
    return {}
  },
  methods: {
      openChatBox() {
          window.dispatchEvent(new Event('open-chat'));
      }
  },
  mounted() {
    // TODO: fetch data via axios or hydrate server state
  }
}
</script>

<style scoped>
/* TODO: import or copy CSS from original static/css */
</style>
