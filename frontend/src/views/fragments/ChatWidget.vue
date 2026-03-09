<template>
  <div class="chat-wrapper">
    <!-- Floating Button (Luxury Yellow Squirclce) -->
    <button 
      class="chat-float-btn" 
      @click="toggleChat" 
      v-if="!isOpen"
    >
      <div class="chat-btn-content">
        <div class="badge-247">24/7</div>
        <div class="robot-icon-container">
          <i class="fa fa-robot"></i>
        </div>
        <span class="chat-btn-text">Trợ lý AI</span>
      </div>
    </button>

    <!-- Chat Panel -->
    <div class="chat-panel" v-if="isOpen">
      <!-- Header TGDĐ Style -->
      <div class="chat-header">
        <div class="header-info">
          <div class="header-avatar">
            <i class="fa fa-robot text-dark"></i>
            <div class="status-dot"></div>
          </div>
          <div>
            <h5 class="header-title">Luxury AI</h5>
            <div class="header-subtitle">Luôn sẵn sàng hỗ trợ bạn</div>
          </div>
        </div>
        <div class="header-actions">
          <button class="action-btn" @click="resetChat" title="Tạo hội thoại mới">
            <i class="fa fa-sync-alt"></i>
          </button>
          <button class="action-btn" @click="toggleChat" title="Thu nhỏ">
            <i class="fa fa-times"></i>
          </button>
        </div>
      </div>

      <!-- Messages Area -->
      <div class="chat-messages" ref="messagesContainer">
        <!-- Lời chào đầu tiên -->
        <div v-if="messages.length === 0" class="message-bubble-wrapper ai mt-2">
          <div class="ai-avatar">
            <i class="fa fa-robot"></i>
          </div>
          <div class="message-bubble">
            <div style="white-space: pre-wrap;">Dạ em chào anh/chị, em là trợ lý AI của Luxury Shop. Em có thể hỗ trợ thông tin sản phẩm hay chính sách nào cho anh/chị ạ?</div>
          </div>
        </div>

        <div 
          v-for="(msg, index) in messages" 
          :key="index"
          class="message-bubble-wrapper"
          :class="{
            'user': msg.loaiNguoiGui === 'USER', 
            'ai': msg.loaiNguoiGui === 'AI',
            'staff': msg.loaiNguoiGui === 'STAFF'
          }"
        >
          <!-- Avatar AI / Staff bên trái -->
          <div class="ai-avatar" v-if="msg.loaiNguoiGui === 'AI' || msg.loaiNguoiGui === 'STAFF'">
            <i class="fa fa-robot" v-if="msg.loaiNguoiGui === 'AI'"></i>
            <i class="fa fa-headset" v-if="msg.loaiNguoiGui === 'STAFF'"></i>
          </div>

          <div class="message-content-group">
            <div v-if="msg.loaiNguoiGui === 'STAFF'" class="staff-label mb-1">
              Nhân viên hỗ trợ
            </div>
            
            <div class="message-bubble">
              <div style="white-space: pre-wrap;">{{ msg.noiDung }}</div>
            </div>
            <div class="message-time">
              {{ formatTime(msg.ngayGui) }}
            </div>
          </div>
        </div>
        
        <!-- Loading state -->
        <div v-if="isTyping" class="message-bubble-wrapper ai">
          <div class="ai-avatar">
            <i class="fa fa-robot"></i>
          </div>
          <div class="message-content-group">
            <div class="message-bubble typing-indicator">
              <span></span><span></span><span></span>
            </div>
          </div>
        </div>
      </div>

      <!-- Switch to Human Notice -->
      <div v-if="status === 'HUMAN'" class="human-notice">
        <i class="fa fa-headphones mr-1"></i> Đang chờ nhân viên phản hồi...
      </div>

      <!-- Input Area & Footer -->
      <div class="chat-input-area">
        <!-- Nút gọi nhân viên -->
        <div class="switch-human-wrap mb-3" v-if="status === 'AI' && messages.length > 0">
          <button class="btn-switch-human" @click="switchToHuman">
            Chuyển nhân viên tư vấn
          </button>
        </div>

        <form @submit.prevent="sendMessage" class="chat-input-wrapper">
          <input 
            type="text" 
            class="chat-input" 
            placeholder="Nhập tin nhắn..." 
            v-model="newMessage"
            :disabled="isTyping"
          >
          <button 
            type="submit" 
            class="chat-send-btn" 
            :disabled="!newMessage.trim() || isTyping"
          >
            <i class="fa fa-paper-plane"></i>
          </button>
        </form>
        
        <!-- Disclaimer Text -->
        <div class="chat-footer-text mt-2">
          Thông tin chỉ mang tính tham khảo, được tư vấn bởi Trí Tuệ Nhân Tạo
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'ChatWidget',
  data() {
    return {
      isOpen: false,
      messages: [],
      newMessage: '',
      conversationId: null,
      status: 'AI', // 'AI' | 'HUMAN' | 'CLOSED'
      isTyping: false,
      pollingInterval: null
    }
  },
  methods: {
    toggleChat() {
      this.isOpen = !this.isOpen
      if (this.isOpen && this.conversationId === null && this.messages.length === 0) {
        this.fetchConversation()
      }
      
      // Bật/tắt polling khi mở/đóng
      if (this.isOpen && this.status === 'HUMAN') {
        this.startPolling()
      } else {
        this.stopPolling()
      }
    },
    
    resetChat() {
      // Xóa lịch sử hiện tại ở frontend để bắt đầu hội thoại mới
      this.messages = [];
      this.conversationId = null;
      this.status = 'AI';
      this.stopPolling();
    },

    async fetchConversation() {
      try {
        const res = await axios.get('/chat/my-conversation')
        if (res.data && res.data.maCuocTroChuyen) {
            this.conversationId = res.data.maCuocTroChuyen
            this.status = res.data.trangThai
            
            const histRes = await axios.get(`/chat/history/${this.conversationId}`)
            this.messages = histRes.data || []
            
            this.scrollToBottom()
            
            if (this.status === 'HUMAN') {
            this.startPolling()
            }
        }
      } catch (error) {
        console.error('Lỗi tải cuộc hội thoại:', error)
      }
    },

    async sendMessage() {
      if (!this.newMessage.trim()) return

      const text = this.newMessage.trim()
      this.newMessage = ''
      
      this.messages.push({
        loaiNguoiGui: 'USER',
        noiDung: text,
        ngayGui: new Date().toISOString()
      })
      this.scrollToBottom()

      this.isTyping = true
      try {
        const res = await axios.post('/chat/send', { 
            // Nếu gửi conversationId = null, server sẽ tự động tạo cuộc trò chuyện mới
            conversationId: this.conversationId,
            content: text 
        })
        
        this.conversationId = res.data.conversationId
        this.status = res.data.status
        
        if (res.data.reply) {
          this.messages.push(res.data.reply)
        }
        
        this.scrollToBottom()
      } catch (error) {
        console.error('Lỗi gửi tin nhắn:', error)
      } finally {
        this.isTyping = false
      }
    },
    
    async switchToHuman() {
      if (!this.conversationId) return
      
      try {
        await axios.post('/chat/switch-human', { conversationId: this.conversationId })
        this.status = 'HUMAN'
        
        this.messages.push({
          loaiNguoiGui: 'AI',
          noiDung: 'Dạ vâng, em đã thông báo cho nhân viên. Anh/chị chờ một lát nhân viên sẽ vào hỗ trợ ngay nhé.',
          ngayGui: new Date().toISOString()
        })
        
        this.startPolling()
        this.scrollToBottom()
      } catch (error) {
        console.error('Lỗi chuyển trạng thái:', error)
      }
    },

    startPolling() {
      this.stopPolling()
      this.pollingInterval = setInterval(async () => {
        if (!this.conversationId || !this.isOpen) return
        
        try {
          const histRes = await axios.get(`/chat/history/${this.conversationId}`)
          const newMessages = histRes.data || []
          
          if (newMessages.length > this.messages.length) {
            this.messages = newMessages
            this.scrollToBottom()
          }
        } catch (error) {
          console.log('Lỗi polling:', error)
        }
      }, 3000)
    },

    stopPolling() {
      if (this.pollingInterval) {
        clearInterval(this.pollingInterval)
        this.pollingInterval = null
      }
    },

    scrollToBottom() {
      setTimeout(() => {
        if (this.$refs.messagesContainer) {
          const container = this.$refs.messagesContainer
          container.scrollTop = container.scrollHeight
        }
      }, 100)
    },

    formatTime(dateString) {
      if (!dateString) return ''
      const d = new Date(dateString)
      return d.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' })
    }
  },
  beforeUnmount() {
    this.stopPolling()
  }
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');

.chat-wrapper {
  position: fixed;
  bottom: 25px;
  right: 25px;
  z-index: 9999;
  font-family: 'Inter', sans-serif;
}

/* NÚT FLOAT SANG TRỌNG */
.chat-float-btn {
  width: 100px;
  height: 100px;
  border-radius: 32px;
  background: linear-gradient(135deg, #ffd11a 0%, #ffaa00 100%);
  border: none;
  box-shadow: 0 10px 25px rgba(255, 170, 0, 0.4), inset 0 2px 5px rgba(255,255,255,0.5);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  position: relative;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.chat-float-btn:hover {
  transform: translateY(-8px) scale(1.05);
  box-shadow: 0 15px 35px rgba(255, 170, 0, 0.5), inset 0 2px 5px rgba(255,255,255,0.6);
}

.chat-btn-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 4px;
}

.badge-247 {
  position: absolute;
  top: -12px;
  left: -8px;
  background: white;
  color: #333;
  font-size: 11px;
  font-weight: 800;
  padding: 4px 10px;
  border-radius: 12px 12px 12px 0;
  box-shadow: 0 4px 10px rgba(0,0,0,0.15);
  transform: rotate(-8deg);
  letter-spacing: 0.5px;
}

.robot-icon-container {
  font-size: 44px;
  color: #1a1a1a;
  filter: drop-shadow(0 4px 4px rgba(0,0,0,0.15));
  margin-top: 4px;
}

.chat-btn-text {
  font-size: 14px;
  font-weight: 800;
  color: #1a1a1a;
  text-transform: uppercase;
  letter-spacing: 0.2px;
}

/* CHAT PANEL KIỂU TGDĐ */
.chat-panel {
  width: 420px;
  height: 650px;
  background: #ffffff;
  border-radius: 24px;
  box-shadow: 0 10px 40px rgba(0,0,0,0.2), 0 0 0 1px rgba(0,0,0,0.05);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  animation: slideUp 0.3s cubic-bezier(0.165, 0.84, 0.44, 1);
  transform-origin: bottom right;
}

@keyframes slideUp {
  from { opacity: 0; transform: scale(0.9) translateY(20px); }
  to { opacity: 1; transform: scale(1) translateY(0); }
}

/* HEADER KIỂU XÁM ĐEN BO GÓC */
.chat-header {
  background: #3a3a3c;
  color: #ffffff;
  padding: 16px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-shrink: 0;
}

.header-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.header-avatar {
  width: 38px;
  height: 38px;
  background: #ffd11a; /* Vàng luxury/TGDĐ */
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  color: #333;
  position: relative;
}

.status-dot {
  position: absolute;
  bottom: -2px;
  right: -2px;
  width: 12px;
  height: 12px;
  background: #28a745;
  border: 2px solid #3a3a3c;
  border-radius: 50%;
}

.header-title {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 0.3px;
  color: #fff;
}

.header-subtitle {
  font-size: 12px;
  color: #b3b3b3;
  margin-top: 2px;
}

.header-actions {
  display: flex;
  gap: 10px;
}

.action-btn {
  background: rgba(255,255,255,0.1);
  border: none;
  color: #fff;
  width: 32px;
  height: 32px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  cursor: pointer;
  transition: background 0.2s;
}
.action-btn:hover {
  background: rgba(255,255,255,0.2);
}

/* MESSAGES AREA */
.chat-messages {
  flex: 1;
  padding: 24px;
  background: #f8f9fa; /* Xám thật nhạt như TGDĐ */
  overflow-y: auto;
  scroll-behavior: smooth;
}

.chat-messages::-webkit-scrollbar {
  width: 6px;
}
.chat-messages::-webkit-scrollbar-thumb {
  background-color: #ddd;
  border-radius: 3px;
}

/* Cấu trúc bong bóng chat có avatar */
.message-bubble-wrapper {
  display: flex;
  margin-bottom: 24px;
  max-width: 90%;
}
.message-bubble-wrapper.ai, .message-bubble-wrapper.staff {
  align-self: flex-start;
  align-items: flex-start;
}
.message-bubble-wrapper.user {
  align-self: flex-end;
  margin-left: auto;
  align-items: flex-end;
  flex-direction: row-reverse; /* Đảo ngược để căn phải */
}

/* Avatar nhỏ cho từng dòng tin nhắn AI */
.ai-avatar {
  width: 28px;
  height: 28px;
  background: #ffd11a;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  color: #333;
  margin-right: 12px;
  margin-top: 4px;
  flex-shrink: 0;
}

.message-content-group {
  display: flex;
  flex-direction: column;
}
.user .message-content-group {
  align-items: flex-end;
}
.ai .message-content-group, .staff .message-content-group {
  align-items: flex-start;
}

.message-bubble {
  padding: 14px 18px;
  font-size: 15px;
  line-height: 1.5;
}

/* AI dùng xám nhạt bo góc tròn trịa */
.ai .message-bubble, .staff .message-bubble {
  background: #f1f2f4;
  color: #333;
  border-radius: 8px 24px 24px 24px;
}

/* User dùng xám đen bo góc */
.user .message-bubble {
  background: #4b4b4b;
  color: #fff;
  border-radius: 24px 8px 24px 24px;
}

.staff-label {
  font-size: 11px;
  font-weight: 600;
  color: #c5a133;
  margin-left: 4px;
}

.message-time {
  font-size: 11px;
  color: #aaa;
  margin-top: 6px;
  font-weight: 500;
}
.user .message-time {
  margin-right: 4px;
}
.ai .message-time, .staff .message-time {
  margin-left: 4px;
}

.human-notice {
  background: #fff7d6;
  color: #a37c00;
  text-align: center;
  padding: 10px;
  font-size: 12px;
  font-weight: 600;
  border-top: 1px solid #ffe885;
}

/* TYPING INDICATOR */
.typing-indicator {
  display: flex;
  gap: 4px;
  align-items: center;
  padding: 14px 18px !important;
}
.typing-indicator span {
  width: 6px;
  height: 6px;
  background: #888;
  border-radius: 50%;
  animation: typing 1s infinite alternate;
}
.typing-indicator span:nth-child(2) { animation-delay: 0.2s; }
.typing-indicator span:nth-child(3) { animation-delay: 0.4s; }

@keyframes typing {
  from { transform: translateY(0px); opacity: 0.4; }
  to { transform: translateY(-4px); opacity: 1; }
}

/* INPUT AREA */
.chat-input-area {
  padding: 16px 20px;
  background: #ffffff;
  border-top: 1px solid #eee;
  display: flex;
  flex-direction: column;
}

.switch-human-wrap {
  display: flex;
  justify-content: center;
}
.btn-switch-human {
  background: transparent;
  border: 1px solid #e0b435;
  color: #c5971a;
  border-radius: 20px;
  padding: 8px 20px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}
.btn-switch-human:hover {
  background: #fdfaf0;
}

/* Ô Input viền mảnh mượt mà */
.chat-input-wrapper {
  display: flex;
  align-items: center;
  background: #ffffff;
  border-radius: 30px;
  padding: 6px 6px 6px 20px;
  border: 1px solid #ddd;
  box-shadow: 0 2px 10px rgba(0,0,0,0.02);
  transition: all 0.3s ease;
}
.chat-input-wrapper:focus-within {
  border-color: #ccc;
  box-shadow: 0 4px 15px rgba(0,0,0,0.05);
}

.chat-input {
  flex: 1;
  border: none;
  background: transparent;
  outline: none;
  font-size: 15px;
  color: #333;
}
.chat-input::placeholder {
  color: #aaa;
}

/* NÚT GỬI MÀU XÁM TRONG Ô TRÒN */
.chat-send-btn {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: #f1f1f1;
  color: #777;
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
  flex-shrink: 0;
}
/* Khi có text, nút đổi sang đậm */
.chat-input-wrapper:focus-within .chat-send-btn:not(:disabled) {
  background: #4b4b4b;
  color: #fff;
}
.chat-send-btn:hover:not(:disabled) {
  transform: scale(1.05);
}
.chat-send-btn:disabled {
  background: #f1f1f1;
  cursor: not-allowed;
  color: #bbb;
}

/* DO DÒNG DISCLAIMER (FOOTER TEXT) */
.chat-footer-text {
  font-size: 11px;
  color: #a0a0a0;
  text-align: center;
}
</style>
