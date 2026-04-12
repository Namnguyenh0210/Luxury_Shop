<template>
  <Transition name="modal-fade">
    <div v-if="state.show" class="fixed inset-0 z-[99999] flex items-center justify-center p-4">
      <!-- Backdrop -->
      <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" @click="handleCancel"></div>
      
      <!-- Modal Content -->
      <div class="bg-white rounded-[40px] shadow-[0_30px_100px_rgba(0,0,0,0.25)] w-full max-w-sm relative z-10 overflow-hidden transform transition-all border border-gray-100">
        <!-- Top accent -->
        <div class="h-2 w-full bg-[#C8A97E]"></div>
        
        <div class="p-10">
          <!-- Icon -->
          <div class="w-20 h-20 rounded-3xl flex items-center justify-center mb-8 mx-auto shadow-xl bg-[#FDF8F3] text-[#C8A97E] border border-[#C8A97E]/10">
            <span class="material-symbols-outlined text-4xl">
              {{ state.type === 'confirm' ? 'help' : 'info' }}
            </span>
          </div>
          
          <!-- Text -->
          <div class="text-center space-y-3 mb-10">
            <h3 class="text-2xl font-black text-gray-900 leading-tight uppercase tracking-wider">{{ state.title }}</h3>
            <p class="text-gray-500 font-medium text-sm leading-relaxed px-2">{{ state.message }}</p>
            
            <!-- Prompt Input -->
            <div v-if="state.type === 'prompt'" class="pt-4 px-2">
              <input v-model="state.promptText" 
                     :placeholder="state.promptPlaceholder" 
                     @keyup.enter="handleConfirm"
                     class="w-full text-center px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-[#C8A97E]/50 focus:border-[#C8A97E]/30 outline-none text-sm transition-all shadow-inner" />
            </div>
          </div>
          
          <!-- Buttons -->
          <div class="flex gap-4">
            <button v-if="state.type === 'confirm' || state.type === 'prompt'"
                    @click="handleCancel"
                    class="flex-1 py-4 px-6 bg-gray-50 text-gray-400 rounded-2xl font-bold text-xs uppercase tracking-widest hover:bg-gray-100 hover:text-gray-600 transition-all active:scale-95 border border-gray-200/50">
              {{ state.cancelText }}
            </button>
            <button @click="handleConfirm"
                    class="flex-1 py-4 px-6 bg-[#C8A97E] text-white rounded-2xl font-bold text-xs uppercase tracking-widest hover:bg-[#B8986E] transition-all shadow-lg shadow-[#C8A97E]/30 active:scale-95">
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
