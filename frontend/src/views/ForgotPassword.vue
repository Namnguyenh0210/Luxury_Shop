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
  <div class="min-h-screen flex items-center justify-center bg-gray-100">
    <div class="bg-white p-8 rounded-2xl shadow-lg w-[400px]">

      <h2 class="text-2xl font-bold mb-2 text-center text-gray-800">
        Forgot Password
      </h2>

      <p class="text-sm text-gray-500 text-center mb-6">
        Enter your email to receive a reset link
      </p>

      <input
          v-model="email"
          type="email"
          placeholder="Enter your email"
          class="w-full border border-gray-300 p-2 rounded mb-4 focus:outline-none focus:ring-2 focus:ring-black"
      />

      <button
          @click="sendRequest"
          class="w-full bg-black text-white py-2 rounded hover:bg-gray-800 transition"
      >
        Send Request
      </button>

      <!-- messages -->
      <p v-if="errorMessage" class="text-red-500 text-sm mt-2 text-center">
        {{ errorMessage }}
      </p>
      <p v-if="successMessage" class="text-green-500 text-sm mt-2 text-center">
        {{ successMessage }}.
        <!-- link thủ công -->
        <router-link
            v-if="successMessage"
            :to="{ path: '/verify-otp', query: { email: email.value } }"
            class="text-black font-medium hover:underline ml-1"
        >
          Nhấn vào đây để nhập OTP
        </router-link>
      </p>

      <!-- back login -->
      <p class="text-center text-sm mt-4 text-gray-500">
        Remember your password?
        <router-link to="/login" class="text-black font-medium hover:underline">
          Login
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