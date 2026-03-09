<template>
  <div class="admin-chat-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="h4 mb-0"><i class="fas fa-comments text-primary mr-2"></i> Quản Lý Hỗ Trợ Khách Hàng</h2>
      <div>
        <span class="badge badge-info mr-2">Tổng: {{ conversations.length }}</span>
        <button class="btn btn-sm btn-outline-secondary" @click="fetchConversations">
          <i class="fas fa-sync-alt"></i> Làm mới
        </button>
      </div>
    </div>

    <div class="row">
      <!-- Chat List Sidebar -->
      <div class="col-md-4 mb-4">
        <div class="card shadow-sm h-100">
          <div class="card-header bg-light">
            <h6 class="mb-0">Danh sách cuộc gọi</h6>
          </div>
          <div class="list-group list-group-flush chat-list-scroll">
            
            <div 
              v-for="conv in conversations" 
              :key="conv.maCuocTroChuyen"
              @click="selectConversation(conv)"
              class="list-group-item list-group-item-action cursor-pointer"
              :class="{'active-chat': selectedConv?.maCuocTroChuyen === conv.maCuocTroChuyen}"
            >
              <div class="d-flex w-100 justify-content-between">
                <h6 class="mb-1">
                  <i class="fas fa-user-circle text-muted"></i> 
                  {{ conv.taiKhoan ? conv.taiKhoan.hoTen : 'Khách Vô Danh' }}
                </h6>
                <small class="text-muted">{{ formatTime(conv.ngayCapNhat) }}</small>
              </div>
              <p class="mb-1 text-truncate small">
                Status: 
                <span class="badge" :class="{
                  'badge-primary': conv.trangThai === 'AI',
                  'badge-warning text-dark': conv.trangThai === 'HUMAN',
                  'badge-secondary': conv.trangThai === 'CLOSED'
                }">{{ conv.trangThai }}</span>
              </p>
              <small class="text-muted" v-if="conv.taiKhoan">Email: {{ conv.taiKhoan.email }}</small>
            </div>
            
            <div v-if="conversations.length === 0" class="p-4 text-center text-muted">
              Không có cuộc hội thoại nào.
            </div>
            
          </div>
        </div>
      </div>

      <!-- Chat Detail Window -->
      <div class="col-md-8 mb-4">
        <div class="card shadow-sm h-100" v-if="selectedConv">
          <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <div>
              <h6 class="mb-0">
                Đang chat với: <strong>{{ selectedConv.taiKhoan ? selectedConv.taiKhoan.hoTen : 'Khách Vô Danh' }}</strong>
              </h6>
              <small class="text-muted">ID Cuộc gọi: #{{ selectedConv.maCuocTroChuyen }}</small>
            </div>
            <span class="badge" :class="{
                'badge-primary': selectedConv.trangThai === 'AI',
                'badge-warning text-dark': selectedConv.trangThai === 'HUMAN',
                'badge-secondary': selectedConv.trangThai === 'CLOSED'
              }">{{ selectedConv.trangThai }}</span>
          </div>
          
          <!-- Messages -->
          <div class="card-body chat-history-scroll" ref="historyContainer">
            <div v-if="loadingHistory" class="text-center py-5">
              <i class="fas fa-spinner fa-spin fa-2x text-muted"></i>
            </div>
            <div v-else>
              <div 
                v-for="(msg, idx) in currentMessages" 
                :key="idx" 
                class="mb-3 d-flex"
                :class="{'justify-content-end': msg.loaiNguoiGui !== 'USER', 'justify-content-start': msg.loaiNguoiGui === 'USER'}"
              >
                <div 
                  class="p-2 rounded text-wrap max-w-75"
                  :class="{
                    'bg-light border': msg.loaiNguoiGui === 'USER',
                    'bg-primary text-white': msg.loaiNguoiGui === 'STAFF',
                    'bg-info text-white': msg.loaiNguoiGui === 'AI'
                  }"
                >
                  <div class="small fw-bold mb-1" style="font-size: 0.75rem; opacity: 0.8">
                    {{ msg.loaiNguoiGui === 'USER' ? 'Khách hàng' : (msg.loaiNguoiGui === 'AI' ? 'Trợ lý AI' : 'Nhân viên') }}
                  </div>
                  <div style="white-space: pre-wrap; font-size: 0.9rem;">{{ msg.noiDung }}</div>
                  <div class="text-right mt-1" style="font-size: 0.7rem; opacity: 0.7">
                    {{ formatTime(msg.ngayGui) }}
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Reply Input -->
          <div class="card-footer bg-white border-top">
            <form @submit.prevent="sendReply" class="d-flex">
              <input 
                type="text" 
                class="form-control mr-2" 
                placeholder="Nhập câu trả lời của nhân viên..." 
                v-model="replyText"
                :disabled="replying || selectedConv.trangThai === 'CLOSED'"
              >
              <button 
                type="submit" 
                class="btn btn-primary px-4"
                :disabled="!replyText.trim() || replying || selectedConv.trangThai === 'CLOSED'"
              >
                Gửi
              </button>
            </form>
          </div>
        </div>
        
        <div class="card shadow-sm h-100 d-flex align-items-center justify-content-center bg-light" v-else>
          <div class="text-center text-muted">
            <i class="fas fa-comment-dots fa-3x mb-3"></i>
            <h5>Chọn cuộc gọi để hỗ trợ</h5>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'AdminChat',
  data() {
    return {
      conversations: [],
      selectedConv: null,
      currentMessages: [],
      loadingHistory: false,
      replyText: '',
      replying: false,
      pollingInterval: null
    }
  },
  mounted() {
    this.fetchConversations()
    // Poll data cuộc gọi mới mỗi 10 giây
    this.pollingInterval = setInterval(() => {
      this.fetchConversations(false)
      if (this.selectedConv) {
        this.fetchHistorySilently()
      }
    }, 10000)
  },
  beforeUnmount() {
    if (this.pollingInterval) {
      clearInterval(this.pollingInterval)
    }
  },
  methods: {
    async fetchConversations(showLoading = true) {
      try {
        const res = await axios.get('/chat/admin/all')
        this.conversations = res.data
      } catch (error) {
        console.error('Lỗi lấy danh sách chat:', error)
      }
    },
    
    async selectConversation(conv) {
      this.selectedConv = conv
      this.loadingHistory = true
      
      try {
        const res = await axios.get(`/chat/history/${conv.maCuocTroChuyen}`)
        this.currentMessages = res.data
        this.scrollToBottom()
      } catch (error) {
        console.error('Lỗi lấy chi tiết chat:', error)
      } finally {
        this.loadingHistory = false
      }
    },
    
    async fetchHistorySilently() {
      if (!this.selectedConv) return
      try {
        const res = await axios.get(`/chat/history/${this.selectedConv.maCuocTroChuyen}`)
        if (res.data.length > this.currentMessages.length) {
          this.currentMessages = res.data
          this.scrollToBottom()
        }
      } catch (error) {
        console.error('Lỗi lấy chi tiết chat (silent):', error)
      }
    },
    
    async sendReply() {
      if (!this.replyText.trim() || !this.selectedConv) return
      
      this.replying = true
      try {
        const payload = {
          conversationId: this.selectedConv.maCuocTroChuyen,
          content: this.replyText.trim()
        }
        
        const res = await axios.post('/chat/admin/reply', payload)
        this.currentMessages.push(res.data)
        this.replyText = ''
        
        // Cập nhật lại list Conversations để hiển thị status/time mới rảnh
        this.fetchConversations(false)
        this.scrollToBottom()
      } catch (error) {
        console.error('Lỗi gửi reply:', error)
        alert('Có lỗi xảy ra khi gửi tin nhắn!')
      } finally {
        this.replying = false
      }
    },
    
    scrollToBottom() {
      setTimeout(() => {
        if (this.$refs.historyContainer) {
          const container = this.$refs.historyContainer
          container.scrollTop = container.scrollHeight
        }
      }, 100)
    },
    
    formatTime(dateStr) {
      if (!dateStr) return ''
      const d = new Date(dateStr)
      return d.toLocaleDateString('vi-VN') + ' ' + d.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' })
    }
  }
}
</script>

<style scoped>
.admin-chat-container {
  padding: 20px;
}

.chat-list-scroll {
  height: 600px;
  overflow-y: auto;
}

.chat-history-scroll {
  height: 500px;
  overflow-y: auto;
  background-color: #f8f9fa;
}

.cursor-pointer {
  cursor: pointer;
}

.active-chat {
  background-color: #e9ecef;
  border-left: 4px solid #0d6efd;
}

.max-w-75 {
  max-width: 75%;
}

/* Custom scrollbar */
.chat-list-scroll::-webkit-scrollbar,
.chat-history-scroll::-webkit-scrollbar {
  width: 6px;
}
.chat-list-scroll::-webkit-scrollbar-thumb,
.chat-history-scroll::-webkit-scrollbar-thumb {
  background-color: #cbd5e1;
  border-radius: 3px;
}
</style>
