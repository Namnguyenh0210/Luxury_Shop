<template>
<div class="relative flex min-h-screen w-full flex-col group/design-root bg-background-light dark:bg-background-dark text-text-primary-light dark:text-text-primary-dark font-display">
    <!-- Header Fragment -->
    <AppHeader />
    
    <main class="flex-grow">
        <div class="w-full px-4 md:px-[3.7cm] py-4">
            <div class="flex min-h-[60vh] flex-col items-center justify-center gap-6 rounded-lg bg-cover bg-center bg-no-repeat p-4 text-center md:gap-8" data-alt="A high-fashion model posing in a minimalist, modern setting, wearing an elegant outfit from the new collection." style="background-image: linear-gradient(rgba(0, 0, 0, 0.2) 0%, rgba(0, 0, 0, 0.5) 100%), url(&quot;https://lh3.googleusercontent.com/aida-public/AB6AXuA2RLsd-sCd1DS_TgR8LSOXwcPO_XfMapD3C5LhyLuf2p6bLLleNeiMm37yA5eAKO-GmDxoQclsNVZJxX_fRpxphaAoN8adFL6BnGC6nCdNHsNoZzXbnchw6JsZg6hvOSv1bNwRA1XKdm4JFROKCw3zojoJ7nr9xGQfcyRBMEqZ4ueW8fCGty1jzBEkobgbZXZ66LBrKIpVTjp85aUppDbXObeUM1zj_iI7dfgW3Ap4EJ9QVQ-F7hxAuVH8hEzE2yAYOUYJNcDdoNo&quot;);">
                <div class="flex flex-col gap-4">
                    <h1 class="font-serif text-4xl font-bold text-white md:text-6xl">Luxury Shop</h1>
                    <h2 class="text-base font-normal text-white md:text-lg">Thương hiệu thời trang dẫn đầu xu thế</h2>
                </div>
                <a class="flex min-w-[160px] max-w-[480px] cursor-pointer items-center justify-center overflow-hidden rounded-full h-12 px-8 bg-white text-black text-sm font-bold tracking-[0.2em] uppercase transition-all hover:bg-[#C8A97E] hover:text-white hover:scale-105 shadow-lg" href="/sanpham">
                    <span class="truncate">Khám phá ngay</span>
                </a>
            </div>
        </div>
      <div class="w-full px-4 md:px-[3.7cm] py-16">
        <h2 class="text-center font-serif text-3xl font-bold tracking-tight md:text-4xl">
          Featured Brands
        </h2>

        <div class="mt-8 grid gap-6 [grid-template-columns:repeat(auto-fit,minmax(250px,1fr))]">

          <!-- CHANEL -->
          <div
            @click="goBrand(2)"
            class="group relative cursor-pointer overflow-hidden rounded-lg border border-gray-200 hover:border-[#C8A97E] transition"
        >
          <div class="aspect-[3/4] w-full">
            <img src="/images/brand/logo-chanel.png"
                 class="w-full h-full object-cover transition duration-500 group-hover:scale-105" />
          </div>

          <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition flex items-center justify-center">
            <span class="text-white font-bold tracking-widest">CHANEL</span>
          </div>
        </div>

          <!-- GUCCI -->
          <div
              @click="goBrand(1)"
              class="group relative cursor-pointer overflow-hidden rounded-lg border border-gray-200 hover:border-[#C8A97E] transition"
          >
            <div class="aspect-[3/4] w-full">
              <img src="/images/banner/gucci-brand.png"
                   class="w-full h-full object-cover" />
            </div>

            <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition flex items-center justify-center">
              <span class="text-white font-bold tracking-widest">GUCCI</span>
            </div>
          </div>

          <!-- MLB -->
          <div
              @click="goBrand(3)"
              class="group relative cursor-pointer overflow-hidden rounded-lg border border-gray-200 hover:border-[#C8A97E] transition"
          >
            <div class="aspect-[3/4] w-full">
              <img src="/images/banner/mlb-brand.png"
                   class="w-full h-full object-cover" />
            </div>

            <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition flex items-center justify-center">
              <span class="text-white font-bold tracking-widest">MLB</span>
            </div>
          </div>
        </div>
        </div>
      <div class="container mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <h2 class="text-center font-serif text-3xl font-bold tracking-tight md:text-4xl">New Arrivals</h2>
        <div class="mt-8 grid grid-cols-2 gap-x-4 gap-y-8 sm:grid-cols-2 md:grid-cols-4 lg:gap-x-6">
          <div class="group relative">
            <div class="aspect-w-3 aspect-h-4 w-full overflow-hidden rounded-lg bg-secondary">
              <img class="h-full w-full object-cover object-center transition-opacity group-hover:opacity-75" data-alt="A tan leather handbag with gold hardware." src="https://lh3.googleusercontent.com/aida-public/AB6AXuC8j90vhR2OSz8gJqLtb8Se-tOP12G2NC5HCx8DPl5LRecqSKSYxv-rBI8eq0A-1mvLIHFSXXjQB60XcAzbGN_gIDv52Z-ZTnjR0vTIJutREgBYlPefiMt-AqybAwOXv-nWppPSlr2qWHx2rbScItTVybKAFcIEZ7v680QSTSMJH_b_2WRlfRufJSBd6R5PGP2cFreVQSwEfNQtHRUaiLy5SOBdVqwAzV82QlWJF4qpKa3sNHAe28BKvciJHwblT-DZuoWBBX_xNh4">
            </div>
            <div class="mt-4 flex justify-between">
              <div>
                <h3 class="text-sm font-medium">
                  <a href="/sanpham"><span aria-hidden="true" class="absolute inset-0"></span>The Classic
                    Tote</a>
                </h3>
                <p class="mt-1 text-sm text-text-primary-light/70 dark:text-text-primary-dark/70">Leather
                  Goods</p>
              </div>
              <p class="text-sm font-semibold">$890</p>
            </div>
          </div>
          <div class="group relative">
            <div class="aspect-w-3 aspect-h-4 w-full overflow-hidden rounded-lg bg-secondary">
              <img class="h-full w-full object-cover object-center transition-opacity group-hover:opacity-75" data-alt="A pair of stylish white sneakers with beige accents." src="https://lh3.googleusercontent.com/aida-public/AB6AXuDDi-BUNUHtshSAU9flWAwGmk08O4MW2cZ82zfILqudYylnNQEPzhbYxLYe48lpBEUiysgIrJ9aos-EMxH08vSUeV_5KVnFVbnq82C-3yvfxpqcezYhB5or0PE5lBoWQGWr76lv6cpOirR-RDA-d6e_PXz_iqZeIZggS07nDB4vShzShLJIyviL0hgTzjFyGfpmJeVYuyuYJZZEwocyHEmFi8N2eVOicxtHv0txdOPnjkcjjE3XJi4YE_8oRJwAPlP3YE9yWBOGZGw">
            </div>
            <div class="mt-4 flex justify-between">
              <div>
                <h3 class="text-sm font-medium">
                  <a href="/sanpham"><span aria-hidden="true" class="absolute inset-0"></span>Minimalist Sneaker</a>
                </h3>
                <p class="mt-1 text-sm text-text-primary-light/70 dark:text-text-primary-dark/70">
                  Footwear</p>
              </div>
              <p class="text-sm font-semibold">$450</p>
            </div>
          </div>
          <div class="group relative">
            <div class="aspect-w-3 aspect-h-4 w-full overflow-hidden rounded-lg bg-secondary">
              <img class="h-full w-full object-cover object-center transition-opacity group-hover:opacity-75" data-alt="A woman wearing a flowing silk midi dress in a neutral tone." src="https://lh3.googleusercontent.com/aida-public/AB6AXuC2N4z42RdmZMLIb-W5Q46VBWY6m0lerZnSGjUYqxpl0wYFXna18Ppg5GTC_CPa1B0S-wy4BQC-Xm3bqhlKVgbiUEA7LUCwHxAcXLzljHzHBM_mnQOJ7r0GZM0-yCKXojJTzzgUw6r2cz-hGT0_n2pfYO_BJM8uiKKXOgR5Iun6wkGwDRZomGs2kHp1NvGp2lv2iQA5kMA2-odCLou1tmt0oozBrsWyheZbGvkOaHBDQWlUYqNJjSg9NRv_Uj-Wu6qjU4DIOTjCrms">
            </div>
            <div class="mt-4 flex justify-between">
              <div>
                <h3 class="text-sm font-medium">
                  <a href="/sanpham"><span aria-hidden="true" class="absolute inset-0"></span>Silk Slip Dress</a>
                </h3>
                <p class="mt-1 text-sm text-text-primary-light/70 dark:text-text-primary-dark/70">
                  Dresses</p>
              </div>
              <p class="text-sm font-semibold">$620</p>
            </div>
          </div>
          <div class="group relative">
            <div class="aspect-w-3 aspect-h-4 w-full overflow-hidden rounded-lg bg-secondary">
              <img class="h-full w-full object-cover object-center transition-opacity group-hover:opacity-75" data-alt="A close-up of a classic trench coat in beige." src="https://lh3.googleusercontent.com/aida-public/AB6AXuABowtrLcV6USi_eNxlPfgRkm3nGmTL0Zi_0l6G8Dyfs6X7HkzfCJi7XG4oCv80A8NnLQyJLolfE0_LkhnpQHdhcKkNjehdegl90RBDmjRQ8KuECgch27nuzjPJBH9pIWdusfJmIa-fYcQnlnGL-oqHxAm9UeE1fIgKmKI_GRL4OY3lB23MvXwTI0LdxtUfqkQc4cE9HQc6j6gwrvBivr_H6CRwtDd9mwD94Z6o-ghthbJ-vH8cfPidsnx1cq7wvbLFIKz-svQT-g0">
            </div>
            <div class="mt-4 flex justify-between">
              <div>
                <h3 class="text-sm font-medium">
                  <a href="/sanpham"><span aria-hidden="true" class="absolute inset-0"></span>The London
                    Trench</a>
                </h3>
                <p class="mt-1 text-sm text-text-primary-light/70 dark:text-text-primary-dark/70">
                  Outerwear</p>
              </div>
              <p class="text-sm font-semibold">$1,250</p>
            </div>
          </div>
        </div>
      </div>
        <div class="bg-background-light dark:bg-background-dark py-16">
            <div class="w-full px-4 md:px-[3.7cm]">
                <div class="grid grid-cols-1 items-center gap-8 lg:grid-cols-2 lg:gap-16">
                    <div class="relative h-96 overflow-hidden rounded-lg lg:h-[32rem]">
                        <img class="h-full w-full object-cover" data-alt="An artistic, black and white shot of a designer sketching in a studio." src="https://lh3.googleusercontent.com/aida-public/AB6AXuAXiuB0kQSHby6ccYOmju4ElSbioXSvBbWzop5Nikd3QRA0q-L1pPSFupZo2Yuj8BiG9Y-JEp82UEzpmKC8DGb1C16c8ojcksklRm0OAEsj1UgVusuRyQFtYYsfyWP9ozIEfI3TUhwkfY5Twyo1VNcT4XZpw8GVHVoaVRyBIUzwlVToC2P62iIVFc8R9ZLiabJFzQQqeVNt7auKaGA80baXKiDugJADmVBROykiw5KmidXMFWg4zhHMm7asCiw0bMKDQToMzXJMEP8">
                    </div>
                    <div class="text-center lg:text-left">
                        <h2 class="font-serif text-3xl font-bold tracking-tight md:text-4xl">Tin tức thời trang</h2>
                        <p class="mt-4 text-text-primary-light/80 dark:text-text-primary-dark/80">
                            Tin thời trang sản phẩm cập nhật mới nhất 24/24 luôn nắm bắt xu thế và dẫ đầu trong lĩnh vực thời trang
                        </p>
                        <a class="mt-8 inline-block rounded-full bg-black px-10 py-4 text-sm font-bold uppercase tracking-widest text-white transition-all hover:bg-[#C8A97E] hover:scale-105 shadow-xl" href="/gioithieu">
                            Tìm hiểu thêm
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <!-- Footer Fragment -->
    <AppFooter />
</div>

</template>

<script>
import AppHeader from './fragments/AppHeader.vue'
import AppFooter from './fragments/AppFooter.vue'

export default {
  name: 'Home',
  components: {
    AppHeader,
    AppFooter
  },
  methods: {
    goBrand(brandId) {
      this.$router.push({
        path: '/sanpham',
        query: {
          thuongHieu: brandId
        }
      })
    }
  },
  data() {
    return {}
  },
  mounted() {
    // TODO: fetch data via axios or hydrate server state
  }
}
</script>

<style scoped>
@import '@/assets/css/Home.css';

body {
    font-family: 'Times New Roman', Times, serif;
}
h1, h2, h3, h4, h5, h6 {
    font-family: 'Times New Roman', Times, serif;
}
.material-symbols-outlined {
    font-variation-settings:
                    'FILL' 0,
                    'wght' 300,
                    'GRAD' 0,
                    'opsz' 24
}
</style>
