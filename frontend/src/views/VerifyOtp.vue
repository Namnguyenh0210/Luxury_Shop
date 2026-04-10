<script setup lang="ts">
import { ref, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";

const router = useRouter();
const route = useRoute();

const email = ref("");
const otp = ref("");
const errorMessage = ref("");

onMounted(() => {
  // nếu có email từ query param thì điền tự động
  email.value = route.query.email as string || "";
});

async function verifyOtp() {
  errorMessage.value = "";

  if (!email.value || !otp.value) {
    errorMessage.value = "Email và OTP không được để trống!";
    return;
  }

  try {
    const res = await fetch("http://localhost:8080/api/password/verify", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: email.value, otp: otp.value }),
    });

    if (!res.ok) {
      // backend trả text chứ không phải JSON
      const text = await res.text();
      errorMessage.value = text || "Có lỗi xảy ra";
      return;
    }

    alert("OTP hợp lệ! Chuyển sang đổi mật khẩu");
    router.push({
      path: "/reset-password",
      query: { email: email.value, otp: otp.value },
    });
  } catch (err) {
    console.error(err);
    errorMessage.value = "Không thể kết nối đến server";
  }
}
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-100">
    <div class="bg-white p-8 rounded-2xl shadow-lg w-[400px]">
      <h2 class="text-2xl font-bold mb-4 text-center">Xác thực OTP</h2>

      <input
          v-model="email"
          type="email"
          placeholder="Email"
          class="w-full mb-2 p-2 border rounded"
          readonly
      />
      <input
          v-model="otp"
          type="text"
          placeholder="Nhập mã OTP"
          class="w-full mb-2 p-2 border rounded"
      />

      <p v-if="errorMessage" class="text-red-500 text-sm mb-2 text-center">{{ errorMessage }}</p>

      <button
          @click="verifyOtp"
          class="w-full bg-black text-white py-2 rounded hover:bg-gray-800"
      >
        Xác nhận OTP
      </button>
    </div>
  </div>
</template>

<style scoped>
</style>