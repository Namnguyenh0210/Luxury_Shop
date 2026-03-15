<template>
  <AdminLayout pageTitle="Quản Lý Hỗ Trợ & Phản Hồi">
    <!-- Wrapper with fixed height to prevent double scrollbars and match Dashboard 2.0 look -->
    <div class="h-[calc(100vh-84px)] p-6 bg-gray-50/50">
       <div class="bg-white rounded-2xl border border-gray-200 shadow-sm h-full overflow-hidden">
          <ChatManagement role="ADMIN" class="h-full" />
       </div>
    </div>
  </AdminLayout>
</template>

<script>
import AdminLayout from './AdminLayout.vue'
import ChatManagement from '../fragments/ChatManagement.vue'

export default {
  name: 'AdminChat',
  components: {
    AdminLayout,
    ChatManagement
  }
}
</script>

<style scoped>
/* Ensure height fills correctly */
:deep(.flex.h-full.overflow-hidden.bg-white) {
   height: 100% !important;
}
</style>
