<script setup lang="ts">
import { ref } from "vue";
import { useRoute, useRouter } from "vue-router";

const route = useRoute();
const router = useRouter();

const email = ref(route.query.email as string || "");
const otp = ref(route.query.otp as string || "");
const newPassword = ref("");

async function resetPassword() {
  const res = await fetch("http://localhost:8080/api/auth/reset-password", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email: email.value, otp: otp.value, newPassword: newPassword.value }),
  });

  if (!res.ok) {
    const err = await res.json();
    alert(err.error || "Có lỗi xảy ra");
    return;
  }

  alert("Đổi mật khẩu thành công!");
  router.push("/login");
}
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-100">
    <div class="bg-white p-8 rounded-2xl shadow-lg w-[400px]">
      <h2 class="text-2xl font-bold mb-4 text-center">Đặt lại mật khẩu</h2>
      <input v-model="newPassword" type="password" placeholder="Mật khẩu mới" class="w-full mb-4 p-2 border rounded" />
      <button @click="resetPassword" class="w-full bg-black text-white py-2 rounded hover:bg-gray-800">
        Đổi mật khẩu
      </button>
    </div>
  </div>
</template>

<style scoped>

</style>