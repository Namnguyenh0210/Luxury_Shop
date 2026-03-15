<template>
  <Transition name="modal-fade">
    <div v-if="state.show" class="fixed inset-0 z-[99999] flex items-center justify-center p-4">
      <!-- Backdrop -->
      <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" @click="handleCancel"></div>
      
      <!-- Modal Content -->
      <div class="bg-white rounded-[32px] shadow-2xl w-full max-w-sm relative z-10 overflow-hidden transform transition-all border border-gray-100">
        <!-- Top accent -->
        <div :class="['h-2 w-full', state.type === 'confirm' ? 'bg-yellow-400' : 'bg-blue-500']"></div>
        
        <div class="p-8">
          <!-- Icon -->
          <div :class="['w-16 h-16 rounded-2xl flex items-center justify-center mb-6 mx-auto shadow-lg', 
                       state.type === 'confirm' ? 'bg-yellow-50 text-yellow-600' : 'bg-blue-50 text-blue-600']">
            <span class="material-symbols-outlined text-3xl">
              {{ state.type === 'confirm' ? 'help_outline' : 'info' }}
            </span>
          </div>
          
          <!-- Text -->
          <div class="text-center space-y-2 mb-8">
            <h3 class="text-xl font-black text-gray-900 leading-tight">{{ state.title }}</h3>
            <p class="text-gray-500 font-medium text-sm leading-relaxed">{{ state.message }}</p>
          </div>
          
          <!-- Buttons -->
          <div class="flex gap-3">
            <button v-if="state.type === 'confirm'"
                    @click="handleCancel"
                    class="flex-1 py-3 px-4 bg-gray-50 text-gray-400 rounded-xl font-bold text-sm hover:bg-gray-100 hover:text-gray-600 transition-all active:scale-95">
              {{ state.cancelText }}
            </button>
            <button @click="handleConfirm"
                    :class="['flex-1 py-3 px-4 text-white rounded-xl font-bold text-sm transition-all shadow-lg active:scale-95',
                             state.type === 'confirm' ? 'bg-yellow-500 hover:bg-yellow-600 shadow-yellow-200' : 'bg-blue-500 hover:bg-blue-600 shadow-blue-200']">
              {{ state.confirmText }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </Transition>
</template>

<script>
import { modalState } from '../utils/modal'

export default {
  name: 'ConfirmModal',
  setup() {
    const handleConfirm = () => {
      if (modalState.onConfirm) modalState.onConfirm()
    }
    const handleCancel = () => {
      if (modalState.onCancel) modalState.onCancel()
    }
    return {
      state: modalState,
      handleConfirm,
      handleCancel
    }
  }
}
</script>

<style scoped>
.modal-fade-enter-active,
.modal-fade-leave-active {
  transition: opacity 0.3s ease;
}

.modal-fade-enter-from,
.modal-fade-leave-to {
  opacity: 0;
}

.modal-fade-enter-active .bg-white {
  animation: modal-pop 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

@keyframes modal-pop {
  0% { transform: scale(0.9); opacity: 0; }
  100% { transform: scale(1); opacity: 1; }
}
</style>
