<template>
  <div>
    <router-view />
    <ChatWidget />
    <ConfirmModal />
  </div>
</template>

<style>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.25s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>

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
