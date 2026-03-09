<template>
  <div>
    <router-view />
    <ChatWidget />
  </div>
</template>

<script>
import ChatWidget from './views/fragments/ChatWidget.vue'

export default {
  name: 'App',
  components: {
    ChatWidget
  }
}
</script>
