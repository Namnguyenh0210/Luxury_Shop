<template>
  <div class="staff-chat-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="h4 mb-0"><i class="fas fa-headset text-warning mr-2"></i> Hỗ Trợ Trực Tuyến</h2>
      <div>
        <span class="badge badge-warning text-dark mr-2">Cần hỗ trợ: {{ humanConversations.length }}</span>
        <button class="btn btn-sm btn-outline-secondary" @click="fetchConversations">
          <i class="fas fa-sync-alt"></i> Làm mới
        </button>
      </div>
    </div>

    <div class="row">
      <!-- Chat List Sidebar (Chỉ lọc status HUMAN) -->
      <div class="col-md-4 mb-4">
        <div class="card shadow-sm h-100 border-warning">
          <div class="card-header bg-warning text-dark">
            <h6 class="mb-0"><i class="fas fa-exclamation-circle"></i> Khách Đang Chờ</h6>
          </div>
          <div class="list-group list-group-flush chat-list-scroll">
            
            <div 
              v-for="conv in humanConversations" 
              :key="conv.maCuocTroChuyen"
              @click="selectConversation(conv)"
              class="list-group-item list-group-item-action cursor-pointer"
              :class="{'active-chat': selectedConv?.maCuocTroChuyen === conv.maCuocTroChuyen}"
            >
              <div class="d-flex w-100 justify-content-between">
                <h6 class="mb-1 fw-bold text-dark">
                  <i class="fas fa-user text-primary"></i> 
                  {{ conv.taiKhoan ? conv.taiKhoan.hoTen : 'Khách Vô Danh' }}
                </h6>
                <small class="text-danger fw-bold">{{ formatTimeOnly(conv.ngayCapNhat) }}</small>
              </div>
              <small class="text-muted d-block mt-1" v-if="conv.taiKhoan">Email: {{ conv.taiKhoan.email }}</small>
            </div>
            
            <div v-if="humanConversations.length === 0" class="p-5 text-center text-success">
              <i class="fas fa-check-circle fa-2x mb-2"></i><br>
              Tất cả yêu cầu đã được xử lý.
            </div>
            
          </div>
        </div>
      </div>

      <!-- Chat Detail Window (Dùng chung code giao diện với Admin) -->
      <div class="col-md-8 mb-4">
        <div class="card shadow-sm h-100 border-warning" v-if="selectedConv">
          <!-- Giao diện Chat Detail giống hệt bên admin, tôi dùng chung cấu trúc -->
          <div class="card-header bg-white d-flex justify-content-between align-items-center border-bottom-warning">
            <div>
              <h6 class="mb-0 text-dark">
                Đang chat với: <strong class="text-primary">{{ selectedConv.taiKhoan ? selectedConv.taiKhoan.hoTen : 'Khách Vô Danh' }}</strong>
              </h6>
              <small class="text-muted">Chat ID: #{{ selectedConv.maCuocTroChuyen }}</small>
            </div>
            <button class="btn btn-sm btn-outline-success" @click="markAsResolved">
              <i class="fas fa-check"></i> Đánh dấu xong
            </button>
          </div>
          
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
                  class="p-2 rounded text-wrap max-w-75 shadow-sm"
                  :class="{
                    'bg-white border': msg.loaiNguoiGui === 'USER',
                    'bg-warning text-dark': msg.loaiNguoiGui === 'STAFF',
                    'bg-secondary text-white': msg.loaiNguoiGui === 'AI'
                  }"
                >
                  <div class="small fw-bold mb-1" style="font-size: 0.70rem; opacity: 0.8">
                    {{ msg.loaiNguoiGui === 'USER' ? 'Khách hàng' : (msg.loaiNguoiGui === 'AI' ? 'Trợ lý AI' : 'Bạn (Nhân viên)') }}
                  </div>
                  <div style="white-space: pre-wrap; font-size: 0.95rem;">{{ msg.noiDung }}</div>
                  <div class="text-right mt-1" style="font-size: 0.7rem; opacity: 0.6">
                    {{ formatTime(msg.ngayGui) }}
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <div class="card-footer bg-white border-top">
            <form @submit.prevent="sendReply" class="d-flex">
              <input 
                type="text" 
                class="form-control mr-2 border-warning" 
                placeholder="Nhập câu trả lời..." 
                v-model="replyText"
                :disabled="replying"
              >
              <button 
                type="submit" 
                class="btn btn-warning px-4 text-dark font-weight-bold"
                :disabled="!replyText.trim() || replying"
              >
                <i class="fas fa-paper-plane mr-1"></i> Gửi
              </button>
            </form>
          </div>
        </div>
        
        <div class="card shadow-sm h-100 d-flex align-items-center justify-content-center bg-light" v-else>
          <div class="text-center text-muted">
            <i class="fas fa-headset fa-4x mb-3 text-warning opacity-50"></i>
            <h4>Sẵn sàng hỗ trợ</h4>
            <p>Chọn một khách hàng đang chờ ở cột bên trái</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'StaffChat',
  data() {
    return {
      allConversations: [],
      selectedConv: null,
      currentMessages: [],
      loadingHistory: false,
      replyText: '',
      replying: false,
      pollingInterval: null
    }
  },
  computed: {
    humanConversations() {
      return this.allConversations.filter(c => c.trangThai === 'HUMAN')
    }
  },
  mounted() {
    this.fetchConversations()
    this.pollingInterval = setInterval(() => {
      this.fetchConversations(false)
      if (this.selectedConv) {
        this.fetchHistorySilently()
      }
    }, 5000) // Staff refresh nhanh hơn (5s)
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
        this.allConversations = res.data
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
        console.error('Lỗi lấy chi tiết chat:', error)
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
        
        this.fetchConversations(false)
        this.scrollToBottom()
      } catch (error) {
        console.error('Lỗi gửi reply:', error)
      } finally {
        this.replying = false
      }
    },
    
    async markAsResolved() {
      if(!confirm("Đánh dấu kết thúc hỗ trợ cho khách này?")) return;
      // Trong db chỉ có AI hay HUMAN, nhưng ta có thể báo AI nó có quyền tự close 
      // hoặc staff nói 1 câu rồi thôi. Để đơn giản thì gửi 1 tin nhắn cuối 
      // rồi chuyển lại chế độ AI hoặc tạo trạng thái CLOSED (tương tự)
      alert("Tính năng đang phát triển... Hãy nói lời tạm biệt với khách thay vì kết thúc vội.");
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
    },
    formatTimeOnly(dateStr) {
      if (!dateStr) return ''
      const d = new Date(dateStr)
      return d.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' })
    }
  }
}
</script>

<style scoped>
.staff-chat-container {
  padding: 20px;
}

.chat-list-scroll {
  height: 600px;
  overflow-y: auto;
}

.chat-history-scroll {
  height: 500px;
  overflow-y: auto;
  background-color: #fcfcfc;
}

.cursor-pointer {
  cursor: pointer;
}

.active-chat {
  background-color: #fff3cd; /* Warning light */
  border-left: 4px solid #ffc107;
}

.max-w-75 {
  max-width: 75%;
}

.border-warning {
  border-color: #ffc107 !important;
}

.border-bottom-warning {
  border-bottom: 2px solid #ffc107;
}

/* Custom scrollbar */
.chat-list-scroll::-webkit-scrollbar,
.chat-history-scroll::-webkit-scrollbar {
  width: 6px;
}
.chat-list-scroll::-webkit-scrollbar-thumb,
.chat-history-scroll::-webkit-scrollbar-thumb {
  background-color: #ffc107;
  border-radius: 3px;
}
</style>
