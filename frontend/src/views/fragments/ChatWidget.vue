<template>
  <div v-if="isVisible" class="luxury-chat-root">
    <!-- Chat Window Container -->
    <transition name="chat-window">
      <div v-if="isOpen" class="chat-window-box">
        <!-- HEADER (Style: Thế Giới Di Động) -->
        <div class="chat-header">
          <div class="header-left">
            <div class="logo-circle">
              <span class="material-symbols-outlined">diamond</span>
            </div>
            <div class="header-info">
              <span class="header-name">Luxury Shop Support</span>
              <div class="status-indicator">
                <span class="status-dot" :class="statusColorClass"></span>
                <transition name="fade-status" mode="out-in">
                  <span class="status-text" :key="status">{{ statusLabel }}</span>
                </transition>
              </div>
            </div>
          </div>
          <div class="header-actions">
            <!-- Gold Support Button -->
            <button v-if="status === 'AI'" @click="requestHuman" class="support-btn" title="Hỗ trợ 1:1">
               Hỗ trợ 1:1
            </button>
            <button @click="resetConversation" class="action-btn" title="Làm mới">
              <span class="material-symbols-outlined">refresh</span>
            </button>
            <button @click="isOpen = false" class="action-btn" title="Thu nhỏ">
              <span class="material-symbols-outlined">remove</span>
            </button>
          </div>
        </div>

        <!-- Messages Area -->
        <div class="messages-area custom-scroll" ref="messageContainer">
          <div v-for="(msg, idx) in messages" :key="idx" 
            class="message-group animate-fade-in" :class="msg.loaiNguoiGui === 'USER' ? 'user' : 'ai'">
            
            <!-- Avatar for AI/Staff -->
            <div v-if="msg.loaiNguoiGui !== 'USER'" class="message-avatar">
               <div class="mini-logo">
                 <span class="material-symbols-outlined">diamond</span>
               </div>
            </div>

            <div class="bubble-container">
              <!-- Sender label (Premium) -->
              <div v-if="msg.loaiNguoiGui !== 'USER'" class="sender-label">
                {{ msg.loaiNguoiGui === 'AI' ? '🤖 AI Assistant đang trả lời' : ('👨💼 Nhân viên ' + (assignedStaff || 'Luxury') + ' đang hỗ trợ') }}
              </div>

              <div class="message-bubble">
                  {{ msg.noiDung }}
              </div>
              <!-- Like/Heart icon like TGDĐ -->
              <div v-if="msg.loaiNguoiGui !== 'USER'" class="bubble-heart">
                <span class="material-symbols-outlined">favorite</span>
              </div>
            </div>
          </div>
          
          <div v-if="isTyping" class="message-group ai">
             <div class="message-avatar">
               <div class="mini-logo">
                 <span class="material-symbols-outlined">diamond</span>
               </div>
            </div>
             <div class="message-bubble typing">
                <span class="dot"></span><span class="dot"></span><span class="dot"></span>
             </div>
          </div>
        </div>

        <!-- Input Area -->
        <div class="chat-input-container">
          <!-- Quick Actions -->
          <div class="quick-actions custom-scroll-h">
            <button @click="sendQuickAction('🛍 Sản phẩm mới')" class="qa-btn">🛍 Sản phẩm mới</button>
            <button @click="sendQuickAction('📏 Tư vấn size')" class="qa-btn">📏 Tư vấn size</button>
            <button @click="sendQuickAction('📦 Đơn hàng của tôi')" class="qa-btn">📦 Đơn hàng của tôi</button>
            <button @click="requestHuman" class="qa-btn highlight">👩💼 Gặp nhân viên</button>
          </div>

          <form @submit.prevent="sendMessage" class="input-form">
            <input 
              v-model="inputContent" 
              placeholder="Nhập tin nhắn..." 
              class="tgdd-input"
              @keydown.enter.exact.prevent="sendMessage"
            />
            <button type="submit" :disabled="!inputContent.trim() || isSending" class="tgdd-send-btn">
              <span class="material-symbols-outlined">send</span>
            </button>
          </form>
          <p class="disclaimer">Thông tin chỉ mang tính tham khảo, được tư vấn bởi Trí Tuệ Nhân Tạo</p>
        </div>
      </div>
    </transition>

    <!-- Floating Toggle Button -->
    <button 
      @click="toggleChat"
      class="luxury-toggle-btn-final"
      :class="{ 'hidden-btn': isOpen }"
    >
      <!-- Status Badge -->
      <div class="status-badge-dot" :class="statusColorClass"></div>

      <!-- 24/7 Badge -->
      <div class="badge-bubble">
         <span>24/7</span>
      </div>

      <!-- Main Box -->
      <div class="btn-yellow-box">
        <span class="btn-text" v-if="status === 'AI'">TRỢ LÝ AI</span>
        <span class="btn-text" v-else-if="status === 'PENDING'">ĐANG CHỜ</span>
        <span class="btn-text" v-else>HỖ TRỢ</span>
      </div>
    </button>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'ChatWidget',
  data() {
    return {
      isOpen: false,
      messages: [
        {
          loaiNguoiGui: 'AI',
          noiDung: 'Xin chào Anh/Chị! Em là trợ lý AI của Luxury Shop.',
          ngayGui: new Date()
        },
        {
          loaiNguoiGui: 'AI',
          noiDung: 'Em rất sẵn lòng hỗ trợ Anh/Chị 😊',
          ngayGui: new Date()
        }
      ],
      inputContent: '',
      isSending: false,
      isTyping: false,
      conversationId: null,
      status: 'AI',
      pollingInterval: null,
      assignedStaff: null
    }
  },
  computed: {
    isVisible() {
      // 1. Không hiển thị cho Admin/Nhân viên nếu đã đăng nhập
      const userStr = localStorage.getItem('user');
      if (userStr) {
        try {
          const user = JSON.parse(userStr);
          if (user.vaiTros?.some(v => v.tenVaiTro === 'ADMIN' || v.tenVaiTro === 'NHANVIEN')) {
            return false;
          }
        } catch (e) {}
      }

      const path = this.$route.path;
      // 2. Chỉ hiển thị ở: Home, Sản phẩm, Chi tiết sản phẩm, Liên hệ
      return (
        path === '/' || 
        path === '/home' || 
        path === '/gioithieu' ||
        path.startsWith('/sanpham') || 
        path.startsWith('/product') || 
        path === '/nam' || 
        path === '/nu' ||
        path === '/lienhe'
      );
    },
    statusLabel() {
      if (this.status === 'AI') return '🤖 AI đang hỗ trợ';
      if (this.status === 'PENDING') return '⏳ Đang chờ nhân viên hỗ trợ';
      if (this.status === 'HUMAN') return '👨💼 Nhân viên: ' + (this.assignedStaff || 'Luxury Staff');
      if (this.status === 'CLOSED') return '⏸ Đã kết thúc';
      return 'Online';
    },
    statusColorClass() {
      return {
        'is-ai': this.status === 'AI',
        'is-pending': this.status === 'PENDING',
        'is-human': this.status === 'HUMAN',
        'is-closed': this.status === 'CLOSED'
      };
    }
  },
  methods: {
    sendQuickAction(text) {
      if (!this.conversationId) return;
      this.inputContent = text;
      this.sendMessage();
    },
    async requestHuman() {
      if (!this.conversationId) return;
      if (this.status === 'PENDING' || this.status === 'HUMAN') {
        alert("Chúng tôi đang kết nối bạn với nhân viên rồi ạ!");
        return;
      }

      // 2. Gọi API switch-human
      try {
        await axios.post('/chat/switch-human', { conversationId: this.conversationId });
        this.status = 'PENDING';
        // Luôn gọi initChat để đồng bộ toàn bộ lịch sử và trạng thái mới nhất
        await this.initChat();
      } catch (e) {
        console.error("Switch human error:", e);
      }
    },
    toggleChat() {
      this.isOpen = !this.isOpen;
      if (this.isOpen && !this.conversationId) {
        this.initChat();
      }
    },
    async initChat() {
      try {
        const res = await axios.get('/chat/my-conversation');
        this.conversationId = res.data.maCuocTroChuyen;
        this.status = res.data.trangThai;
        this.assignedStaff = res.data.nhanVien?.hoTen;
        const hist = await axios.get(`/chat/history/${this.conversationId}`);
        if (hist.data && hist.data.length > 0) {
          this.messages = hist.data;
        }
        this.scrollToBottom();
      } catch (e) {
        console.error("Chat init error:", e);
      }
    },
    async sendMessage() {
      if (!this.inputContent.trim() || this.isSending) return;
      const content = this.inputContent.trim();
      this.inputContent = '';
      this.isSending = true;
      this.isTyping = true;
      
      const userMsg = { loaiNguoiGui: 'USER', noiDung: content, ngayGui: new Date() };
      this.messages.push(userMsg);
      this.scrollToBottom();

      try {
        const res = await axios.post('/chat/send', { content });
        if (res.data.reply) {
          this.messages.push(res.data.reply);
        }
        this.status = res.data.status;
        this.scrollToBottom();
      } catch (e) {
        console.error("Send message error:", e);
      } finally { 
        this.isSending = false; 
        this.isTyping = false;
      }
    },
    async resetConversation() {
       if (confirm('Làm mới cuộc hội thoại này?')) {
          try {
             await axios.post('/chat/reset');
             this.messages = [
               {
                 loaiNguoiGui: 'AI',
                 noiDung: 'Xin chào Anh/Chị! Em là trợ lý AI của Luxury Shop.',
                 ngayGui: new Date()
               }
             ];
             this.conversationId = null;
             this.status = 'AI';
             this.assignedStaff = null;
             await this.initChat();
          } catch (e) {
             console.error("Reset chat error:", e);
          }
       }
    },
    formatTime(d) {
      if (!d) return '';
      return new Date(d).toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
    },
    scrollToBottom() {
      this.$nextTick(() => {
        if (this.$refs.messageContainer) {
          this.$refs.messageContainer.scrollTop = this.$refs.messageContainer.scrollHeight;
        }
      });
    },
    startPolling() {
      this.stopPolling();
      this.pollingInterval = setInterval(() => {
        if (this.isOpen && this.conversationId) {
          this.fetchMessagesSilently();
        }
      }, 5000);
    },
    stopPolling() {
      if (this.pollingInterval) {
        clearInterval(this.pollingInterval);
        this.pollingInterval = null;
      }
    },
    async fetchMessagesSilently() {
      try {
        const res = await axios.get(`/chat/history/${this.conversationId}`);
        // Cập nhật nếu số lượng tin nhắn khác nhau hoặc có tin nhắn mới
        if (res.data.length !== this.messages.length) {
          this.messages = res.data;
          this.scrollToBottom();
          
          // Sau khi có tin nhắn mới, cập nhật lại trạng thái hội thoại
          const convRes = await axios.get('/chat/my-conversation');
          this.status = convRes.data.trangThai;
          this.assignedStaff = convRes.data.nhanVien?.hoTen;
        }
      } catch (e) {}
    }
  },
  mounted() {
    this.startPolling();
  },
  beforeUnmount() {
    this.stopPolling();
  }
}
</script>

<style scoped>
.luxury-chat-root {
  position: fixed;
  bottom: 30px;
  right: 30px;
  z-index: 999999;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
}

/* Chat Window Container */
.chat-window-box {
  width: 400px;
  height: 650px;
  background: white;
  border-radius: 20px;
  display: flex;
  flex-direction: column;
  box-shadow: 0 10px 40px rgba(0,0,0,0.15);
  margin-bottom: 15px;
  overflow: hidden;
  border: 1px solid #eee;
}

/* Header - Thế Giới Di Động Style */
.chat-header {
  height: 60px;
  background: #4a4a4a;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 15px;
  color: white;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.logo-circle {
  width: 36px;
  height: 36px;
  background: white;
  color: #d4af37;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.logo-circle span { font-size: 20px; }

.header-name {
  font-size: 16px;
  font-weight: 600;
}

.header-actions {
  display: flex;
  gap: 8px;
}

.action-btn {
  background: rgba(255,255,255,0.1);
  border: none;
  width: 32px;
  height: 32px;
  border-radius: 8px;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: background 0.2s;
}

.action-btn:hover { background: rgba(255,255,255,0.2); }
.action-btn span { font-size: 18px; }

/* Messages Area */
.messages-area {
  flex: 1;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 15px;
  background: white;
  overflow-y: auto;
}

.message-group {
  display: flex;
  gap: 10px;
  max-width: 90%;
}

.message-group.user {
  align-self: flex-end;
  flex-direction: row-reverse;
}

.message-avatar {
  flex-shrink: 0;
  margin-top: 4px;
}

.mini-logo {
  width: 24px;
  height: 24px;
  background: #ffcc00;
  color: #333;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.mini-logo span { font-size: 14px; }

.bubble-container {
  position: relative;
}

.message-bubble {
  padding: 12px 16px;
  border-radius: 18px;
  font-size: 14px;
  line-height: 1.4;
}

.ai .message-bubble {
  background: #f1f1f1;
  color: #333;
  border-top-left-radius: 4px;
}

.user .message-bubble {
  background: #4a4a4a;
  color: white;
  border-top-right-radius: 4px;
}

.bubble-heart {
  position: absolute;
  bottom: -10px;
  right: -5px;
  background: white;
  width: 22px;
  height: 22px;
  border-radius: 50%;
  border: 1px solid #eee;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.bubble-heart span {
  font-size: 12px;
  color: #999;
}

/* Typing Indicator */
.typing .dot {
  display: inline-block;
  width: 4px;
  height: 4px;
  background: #999;
  border-radius: 50%;
  margin: 0 2px;
}

/* Input Area */
.chat-input-container {
  padding: 15px;
  border-top: 1px solid #eee;
  background: white;
}

.input-form {
  display: flex;
  align-items: center;
  background: #f5f5f5;
  border-radius: 30px;
  padding: 5px 5px 5px 20px;
  border: 1px solid #eee;
}

.tgdd-input {
  flex: 1;
  border: none;
  background: transparent;
  padding: 10px 0;
  font-size: 14px;
  outline: none;
}

.tgdd-send-btn {
  width: 36px;
  height: 36px;
  background: #eee;
  border: none;
  border-radius: 50%;
  color: #999;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

.tgdd-send-btn span { font-size: 20px; }

.disclaimer {
  text-align: center;
  font-size: 11px;
  color: #999;
  margin-top: 10px;
}

/* Final Toggle Button (Exactly as image in Step 118) */
.luxury-toggle-btn-final {
  width: 100px;
  height: 100px;
  background: transparent;
  border: none;
  cursor: pointer;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
}

.hidden-btn {
  display: none !important;
}

.badge-bubble {
  position: absolute;
  top: 6px;
  left: 6px;
  background: white;
  padding: 2px 5px;
  border-radius: 8px 8px 8px 3px;
  box-shadow: none;
  z-index: 20;
}

.badge-bubble span {
  font-size: 10px;
  font-weight: 900;
  color: #333;
  font-style: italic;
  font-family: 'Times New Roman', Times, serif;
}

.btn-yellow-box {
  width: 80px;
  height: 80px;
  background: #ffcc00;
  border-radius: 35px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  z-index: 10;
}

.btn-text {
  font-size: 14px;
  font-weight: 900;
  color: #1a1a1a;
  font-family: 'Times New Roman', Times, serif;
  letter-spacing: -0.5px;
}



/* Animations */
.animate-fade-in {
  animation: fadeIn 0.3s ease forwards;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(5px); }
  to { opacity: 1; transform: translateY(0); }
}

.chat-window-enter-active, .chat-window-leave-active {
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
.chat-window-enter-from, .chat-window-leave-to {
  opacity: 0;
  transform: translateY(20px) scale(0.9);
}

.custom-scroll::-webkit-scrollbar { width: 4px; }
.custom-scroll::-webkit-scrollbar-thumb { background: #ddd; border-radius: 10px; }

/* New Styles for Premium Features */
/* Smooth Status Transition */
.fade-status-enter-active, .fade-status-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}
.fade-status-enter-from {
  opacity: 0;
  transform: translateX(-5px);
}
.fade-status-leave-to {
  opacity: 0;
  transform: translateX(5px);
}

.header-info {
  display: flex;
  flex-direction: column;
}

.status-indicator {
  display: flex;
  align-items: center;
  gap: 5px;
  margin-top: 2px;
}

.status-dot.is-ai {
  background: #4cd137;
  box-shadow: 0 0 8px rgba(76, 209, 55, 0.8);
  animation: pulse-green 2s infinite;
}

.status-dot.is-pending {
  background: #ff9f43;
  box-shadow: 0 0 8px rgba(255, 159, 67, 0.8);
  animation: pulse-orange 2s infinite;
}

.status-dot.is-human {
  background: #00d2ff;
  box-shadow: 0 0 8px rgba(0, 210, 255, 0.8);
  animation: pulse-blue 2s infinite;
}

.status-dot.is-closed {
  background: #95a5a6;
  box-shadow: none;
}

@keyframes pulse-green {
  0% { box-shadow: 0 0 0 0 rgba(76, 209, 55, 0.7); }
  70% { box-shadow: 0 0 0 8px rgba(76, 209, 55, 0); }
  100% { box-shadow: 0 0 0 0 rgba(76, 209, 55, 0); }
}

@keyframes pulse-orange {
  0% { box-shadow: 0 0 0 0 rgba(255, 159, 67, 0.7); }
  70% { box-shadow: 0 0 0 8px rgba(255, 159, 67, 0); }
  100% { box-shadow: 0 0 0 0 rgba(255, 159, 67, 0); }
}

@keyframes pulse-blue {
  0% { box-shadow: 0 0 0 0 rgba(0, 210, 255, 0.7); }
  70% { box-shadow: 0 0 0 8px rgba(0, 210, 255, 0); }
  100% { box-shadow: 0 0 0 0 rgba(0, 210, 255, 0); }
}

.status-text {
  font-size: 10px;
  color: rgba(255,255,255,0.7);
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

/* Floating button status badge */
.status-badge-dot {
  position: absolute;
  top: 12px;
  right: 12px;
  width: 14px;
  height: 14px;
  border-radius: 50%;
  border: 2px solid white;
  z-index: 30;
}

.status-badge-dot.is-ai { background: #4cd137; }
.status-badge-dot.is-pending { background: #ff9f43; }
.status-badge-dot.is-human { background: #00d2ff; }
.status-badge-dot.is-closed { background: #95a5a6; }

.support-btn {
  background: #ffcc00;
  color: #1a1a1a;
  border: none;
  padding: 6px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 700;
  cursor: pointer;
  margin-right: 5px;
  transition: all 0.2s;
}

.support-btn:hover {
  background: #e6b800;
  transform: translateY(-1px);
}

.sender-label {
  font-size: 11px;
  color: #888;
  margin-bottom: 4px;
  margin-left: 2px;
  font-weight: 600;
}

.quick-actions {
  display: flex;
  gap: 10px;
  padding-bottom: 12px;
  overflow-x: auto;
  white-space: nowrap;
}

.qa-btn {
  background: white;
  border: 1px solid #eee;
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 13px;
  color: #555;
  cursor: pointer;
  transition: all 0.2s;
  flex-shrink: 0;
}

.qa-btn:hover {
  border-color: #ffcc00;
  background: #fffdf5;
}

.qa-btn.highlight {
  border-color: #ffcc00;
  color: #1a1a1a;
  font-weight: 600;
}

.custom-scroll-h::-webkit-scrollbar { height: 4px; }
.custom-scroll-h::-webkit-scrollbar-thumb { background: #eee; border-radius: 10px; }
</style>
