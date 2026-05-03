<template>
  <div>
    <router-view :key="$route.fullPath" />

    <ChatWidget />
    <ConfirmModal />

    <transition-group
        name="toast-fade"
        tag="div"
        class="fixed top-24 right-4 md:right-10 z-[99999] space-y-4 pointer-events-none"
    >
      <div
          v-for="toast in toasts"
          :key="toast.id"
          class="flex items-center gap-4 bg-white/95 backdrop-blur-md border-l-4 border-[#C8A97E] shadow-[0_20px_50px_rgba(0,0,0,0.15)] px-6 py-5 rounded-2xl min-w-[320px] md:min-w-[400px] pointer-events-auto transform transition-all duration-500 border border-gray-100"
      >
        ...
      </div>
    </transition-group>
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
  },
  data() {
    return {
      toasts: [],
      toastId: 0
    }
  },
  methods: {

    addToast(payload) {
      const id = ++this.toastId
      const toast = typeof payload === 'string' 
        ? { id, title: 'Thông báo', message: payload }
        : { id, ...payload }
      
      this.toasts.push(toast)
      setTimeout(() => this.removeToast(id), payload.duration || 4000)
    },
    removeToast(id) {
      this.toasts = this.toasts.filter(t => t.id !== id)
    }
  },
  mounted() {
    // Expose $toast globally via window
    window.$toast = (payload) => this.addToast(payload)
    window.$toast.success = (msg) => this.addToast({ title: 'THÀNH CÔNG', message: msg })
    window.$toast.error = (msg) => this.addToast({ title: 'LỖI HỆ THỐNG', message: msg })
    window.$toast.info = (msg) => this.addToast({ title: 'THÔNG BÁO', message: msg })
    window.$toast.warning = (msg) => this.addToast({ title: null, message: msg })
    
    // Listen to custom events from non-vue parts if needed
    window.addEventListener('show-toast', (e) => this.addToast(e.detail))
  }
}

</script>

<style>
/* Toast Animations */
.toast-fade-enter-active {
  transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
.toast-fade-leave-active {
  transition: all 0.3s ease-in;
}
.toast-fade-enter-from {
  opacity: 0;
  transform: translateX(50px) scale(0.9);
}
.toast-fade-leave-to {
  opacity: 0;
  transform: translateX(100%) scale(0.85);
}

/* Base Styles */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.25s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Luxury Icon Utilities */
.material-symbols-outlined.fill-icon {
  font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24 !important;
}
</style>
