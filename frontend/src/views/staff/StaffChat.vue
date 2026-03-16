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


