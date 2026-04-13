import { reactive } from 'vue'

export const modalState = reactive({
  show: false,
  title: 'Xác nhận',
  message: '',
  type: 'confirm', // 'confirm', 'alert', or 'prompt'
  onConfirm: null,
  onCancel: null,
  confirmText: 'Đồng ý',
  cancelText: 'Hủy bỏ',
  promptText: '',
  promptPlaceholder: '',
})

export const $confirm = (message, options = {}) => {
  return new Promise((resolve) => {
    modalState.title = options.title || 'Luxury Shop - Xác nhận'
    modalState.message = message
    modalState.type = 'confirm'
    modalState.confirmText = options.confirmText || 'Đồng ý'
    modalState.cancelText = options.cancelText || 'Hủy bỏ'
    modalState.show = true
    
    modalState.onConfirm = () => {
      modalState.show = false
      resolve(true)
    }
    modalState.onCancel = () => {
      modalState.show = false
      resolve(false)
    }
  })
}

export const $alert = (message, title = 'Thông báo') => {
  modalState.title = title
  modalState.message = message
  modalState.type = 'alert'
  modalState.confirmText = 'Đóng'
  modalState.show = true
  modalState.onConfirm = () => {
    modalState.show = false
  }
}

export const $prompt = (message, options = {}) => {
  return new Promise((resolve) => {
    modalState.title = options.title || 'Luxury Shop - Nhập liệu'
    modalState.message = message
    modalState.type = 'prompt'
    modalState.confirmText = options.confirmText || 'Đồng ý'
    modalState.cancelText = options.cancelText || 'Hủy bỏ'
    modalState.promptText = options.defaultValue || ''
    modalState.promptPlaceholder = options.placeholder || ''
    modalState.show = true
    
    modalState.onConfirm = () => {
      modalState.show = false
      resolve(modalState.promptText)
    }
    modalState.onCancel = () => {
      modalState.show = false
      resolve(null)
    }
  })
}

// Global hook
if (typeof window !== 'undefined') {
  window.$confirm = $confirm
  window.$alert = $alert
  window.$prompt = $prompt
}
