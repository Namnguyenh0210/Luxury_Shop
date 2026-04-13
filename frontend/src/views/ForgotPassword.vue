<script setup lang="ts">
import { ref } from "vue";
import { useRouter } from "vue-router";

// reactive variables
const email = ref("");
const errorMessage = ref("");
const successMessage = ref("");

const router = useRouter();

const sendRequest = async () => {
  // reset messages
  errorMessage.value = "";
  successMessage.value = "";

  if (!email.value) {
    errorMessage.value = "Vui lòng nhập email!";
    return;
  }

  try {
    const res = await fetch("http://localhost:8080/api/password/forgot", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: email.value }),
    });

    const data = await res.json();

    if (!res.ok) {
      errorMessage.value = data.error || "Có lỗi xảy ra";
    } else {
      successMessage.value = data.message || "OTP đã gửi";

      // 🚀 tự động chuyển sang Verify OTP sau 1 giây
      setTimeout(() => {
        router.push({ path: "/verify-otp", query: { email: email.value } });
      }, 1000);
    }
  } catch (err) {
    console.error(err);
    errorMessage.value = "Không thể kết nối đến server";
  }
};
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-[papayawhip]">

    <div class="bg-white p-8 rounded-2xl shadow-xl w-[400px] border border-[#F5F1ED]">

      <!-- Title -->
      <h2 class="text-2xl font-bold mb-2 text-center text-gray-900">
        Quên mật khẩu
      </h2>

      <p class="text-sm text-gray-600 text-center mb-6">
        Nhập email của bạn để nhận mã xác thực
      </p>

      <!-- Input -->
      <input
          v-model="email"
          type="email"
          placeholder="Địa chỉ Email"
          class="w-full border border-gray-300 p-3 rounded-lg mb-4
               focus:outline-none
               focus:ring-2 focus:ring-[#C8A97E]
               focus:border-[#C8A97E]
               transition"
      />

      <!-- Button -->
      <button
          @click="sendRequest"
          class="w-full bg-[#C8A97E] text-white py-2.5 rounded-lg
         hover:bg-[#B8986E] transition"
      >
        Gửi yêu cầu
      </button>

      <!-- Messages -->
      <p v-if="errorMessage" class="text-red-500 text-sm mt-3 text-center">
        {{ errorMessage }}
      </p>

      <p v-if="successMessage" class="text-green-600 text-sm mt-3 text-center">
        {{ successMessage }}
        <router-link
            :to="{ path: '/verify-otp', query: { email: email } }"
            class="text-[#C8A97E] font-medium hover:underline ml-1"
        >
          Nhấn vào đây
        </router-link>
      </p>

      <!-- Back login -->
      <p class="text-center text-sm mt-5 text-gray-600">
        Bạn đã nhớ mật khẩu?
        <router-link
            to="/login"
            class="text-[#C8A97E] font-medium hover:underline"
        >
          Đăng nhập
        </router-link>
      </p>

    </div>
  </div>
</template>

<style scoped>
.font-serif {
  font-family: 'Times New Roman', Times, serif;
}
</style>