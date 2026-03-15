<template>
  <div>
    <router-view />
    <ChatWidget />
    <ConfirmModal />
  </div>
</template>

<script>
import ChatWidget from './views/fragments/ChatWidget.vue'
import ConfirmModal from './components/ConfirmModal.vue'

export default {
  name: 'App',
  components: {
    ChatWidget,
    ConfirmModal
  }
}
</script>
