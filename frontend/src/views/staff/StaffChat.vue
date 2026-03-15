<template>
  <StaffLayout pageTitle="Chăm Sóc Khách Hàng">
    <ChatManagement role="STAFF" />
  </StaffLayout>
</template>

<script>
import StaffLayout from './StaffLayout.vue'
import ChatManagement from '../fragments/ChatManagement.vue'

export default {
  name: 'StaffChat',
  components: {
    StaffLayout,
    ChatManagement
  }
}
</script>

<style scoped>
/* Reset any layout constraints if needed */
:deep(.staff-breakout) {
   height: 100vh;
   overflow: hidden;
}
</style>
