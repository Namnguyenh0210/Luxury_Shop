<template>
  <div class="flex h-full overflow-hidden bg-white">
    <!-- LEFT PANEL: Conversation List -->
    <div class="flex w-80 flex-col border-r border-gray-100 bg-gray-50/30">
      <div class="p-4 bg-white border-b border-gray-100">
        <div class="relative group">
          <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-[18px] group-focus-within:text-gold transition-colors">search</span>
          <input 
            type="text" 
            v-model="searchKeyword" 
            placeholder="Tìm khách hàng..." 
            class="w-full pl-10 pr-4 py-2.5 bg-gray-50 border-none rounded-xl text-sm focus:ring-2 focus:ring-gold/20 transition-all font-medium" 
          />
        </div>
      </div>
      
      <!-- Filter Tabs -->
      <div class="p-3 bg-white">
        <div class="flex gap-1 bg-gray-100 p-1 rounded-2xl w-fit overflow-x-auto no-scrollbar">
          <button v-for="tab in tabs" :key="tab.id" @click="activeTab = tab.id"
            class="px-4 py-2 rounded-xl text-xs font-bold whitespace-nowrap transition-all duration-300"
            :class="activeTab === tab.id ? 
              'bg-white shadow-sm text-yellow-700' : 
              'text-gray-500 hover:text-gray-700'">
            {{ tab.label }}
          </button>
        </div>
      </div>

      <!-- Conversations Loop -->
      <div class="flex-1 overflow-y-auto custom-scroll p-3 space-y-2">
        <div v-for="conv in filteredConversations" :key="conv.maCuocTroChuyen" @click="selectConversation(conv)"
          class="group flex items-center gap-3 p-3 rounded-2xl cursor-pointer transition-all duration-300 relative border border-transparent"
          :class="selectedConv?.maCuocTroChuyen === conv.maCuocTroChuyen ? 
            'bg-white border-gray-100 shadow-md scale-[1.02] z-10' : 
            'hover:bg-white hover:border-gray-50 hover:shadow-sm'">
          
          <div class="relative flex-shrink-0">
            <div class="size-11 rounded-2xl bg-slate-800 text-white flex items-center justify-center font-bold text-sm shadow-sm overflow-hidden border-2 border-white">
              <img v-if="conv.taiKhoan?.avatar" :src="conv.taiKhoan.avatar" class="size-full object-cover" />
              <span v-else>{{ getInitials(conv.taiKhoan?.hoTen || 'K') }}</span>
            </div>
            <div class="absolute -bottom-1 -right-1 size-3.5 rounded-full border-2 border-white" 
              :class="conv.trangThai === 'HUMAN' ? 'bg-orange-500' : (conv.trangThai === 'PENDING' ? 'bg-red-500 animate-pulse' : (conv.trangThai === 'CLOSED' ? 'bg-gray-400' : 'bg-blue-500'))"></div>
          </div>

          <div class="flex-1 min-w-0">
            <div class="flex justify-between items-start mb-0.5">
              <h4 class="text-sm font-bold text-gray-800 truncate">{{ conv.taiKhoan?.hoTen || 'Khách Vô Danh' }}</h4>
              <span class="text-[10px] text-gray-400 font-medium tabular-nums">{{ formatTimeShort(conv.ngayCapNhat) }}</span>
            </div>
            <p class="text-xs text-gray-500 truncate" :class="{'text-gray-900 font-bold': (conv.trangThai === 'HUMAN' || conv.trangThai === 'PENDING') && selectedConv?.maCuocTroChuyen !== conv.maCuocTroChuyen}">
              {{ conv.lastMessage || 'Bắt đầu trò chuyện...' }}
            </p>
          </div>

          <div v-if="conv.trangThai === 'HUMAN' || conv.trangThai === 'PENDING'" class="absolute right-3 top-1/2 -translate-y-1/2 size-2 rounded-full bg-orange-500 shadow-sm animate-pulse"></div>
        </div>

        <div v-if="filteredConversations.length === 0" class="flex flex-col items-center justify-center py-20 text-gray-300">
          <span class="material-symbols-outlined text-4xl mb-3 opacity-20">forum</span>
          <p class="text-xs font-bold uppercase tracking-widest text-gray-400">Không có hội thoại</p>
        </div>
      </div>
      
      <!-- Last Sync Info -->
      <div class="p-4 border-t border-gray-100 bg-white flex items-center justify-between">
        <div class="flex items-center gap-2">
           <span class="size-1.5 rounded-full bg-green-500"></span>
           <span class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Live Sync</span>
        </div>
        <button @click="fetchConversations" class="p-1.5 hover:bg-gray-100 rounded-lg transition-colors group" :disabled="isFetching">
           <span class="material-symbols-outlined text-[18px] text-gray-400 group-hover:rotate-180 transition-transform duration-500" :class="{'animate-spin': isFetching}">refresh</span>
        </button>
      </div>
    </div>

    <!-- MIDDLE PANEL: Chat Window -->
    <div class="flex-1 flex flex-col bg-white relative">
      <template v-if="selectedConv">
        <!-- Chat Header -->
        <div class="h-20 px-6 border-b border-gray-100 flex items-center justify-between bg-white/80 backdrop-blur-md sticky top-0 z-20">
          <div class="flex items-center gap-4">
            <div class="size-10 rounded-xl bg-gray-900 text-yellow-400 flex items-center justify-center font-bold text-sm shadow-lg">
               <img v-if="selectedConv.taiKhoan?.avatar" :src="selectedConv.taiKhoan.avatar" class="size-full object-cover" />
               <span v-else>{{ getInitials(selectedConv.taiKhoan?.hoTen) }}</span>
            </div>
            <div>
              <h3 class="text-base font-bold text-gray-900 tracking-tight">{{ selectedConv.taiKhoan?.hoTen || 'Khách Vô Danh' }}</h3>
              <div class="flex items-center gap-2 mt-0.5">
                <div class="flex items-center gap-1">
                  <span class="size-2 rounded-full" :class="selectedConv.trangThai === 'HUMAN' || selectedConv.trangThai === 'PENDING' ? 'bg-orange-500' : 'bg-blue-500'"></span>
                  <span class="text-[10px] font-bold text-gray-500 uppercase tracking-widest">{{ selectedConv.trangThai === 'HUMAN' ? 'Nhân viên trực' : (selectedConv.trangThai === 'PENDING' ? 'Đang chờ...' : 'AI Online') }}</span>
                </div>
                <span class="text-gray-300 text-[10px]">•</span>
                <span class="text-[9px] font-bold text-gray-400 uppercase tracking-widest tabular-nums">{{ selectedConv.taiKhoan?.email || 'Guest' }}</span>
              </div>
            </div>
          </div>
          
          <div class="flex items-center gap-2">
            <button @click="showRightPanel = !showRightPanel" class="p-2.5 hover:bg-gray-100 rounded-xl transition-all group" :class="{'bg-gold/10 text-gold': showRightPanel}">
               <span class="material-symbols-outlined text-[20px] group-hover:scale-110 transition-transform">person_search</span>
            </button>
            <div class="w-px h-6 bg-gray-100 mx-1"></div>
            <button v-if="selectedConv.trangThai !== 'CLOSED'" @click="closeConv" class="flex items-center gap-2 px-4 py-2 bg-red-50 text-red-600 hover:bg-red-600 hover:text-white rounded-xl text-[10px] font-black uppercase tracking-widest transition-all shadow-sm shadow-red-100 border border-red-100/50">
               <span class="material-symbols-outlined text-[18px]">done_all</span>
               Đóng đơn
            </button>
          </div>
        </div>

        <!-- Messages Area -->
        <div class="flex-1 overflow-y-auto p-8 space-y-8 bg-gray-50/20 custom-scroll" ref="historyContainer">
          <div v-for="(msg, idx) in currentMessages" :key="idx" 
            class="flex flex-col group/msg" :class="msg.loaiNguoiGui === 'USER' ? 'items-start' : 'items-end'">
            
            <div v-if="isNewGroup(idx)" class="flex items-center gap-2 mb-3 px-1" :class="msg.loaiNguoiGui === 'USER' ? 'flex-row' : 'flex-row-reverse'">
              <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">
                {{ msg.loaiNguoiGui === 'USER' ? (selectedConv.taiKhoan?.hoTen || 'Khách hàng') : (msg.loaiNguoiGui === 'AI' ? '🤖 AI Trợ lý' : '👩💼 Nhân viên tư vấn') }}
              </span>
              <div class="h-px w-6 bg-gray-100"></div>
            </div>

            <div class="max-w-[70%] group relative">
              <div class="px-5 py-3.5 rounded-3xl text-[13px] font-medium leading-relaxed shadow-sm transition-all duration-300"
                :class="msg.loaiNguoiGui === 'USER' ? 
                  'bg-white text-gray-800 rounded-tl-none border border-gray-100' : 
                  (msg.loaiNguoiGui === 'AI' ? 
                    'bg-slate-100 text-slate-800 rounded-tr-none border border-slate-200' : 
                    (role === 'ADMIN' ? 'bg-slate-900 text-white rounded-tr-none shadow-xl shadow-slate-200 border border-slate-800' : 'bg-blue-600 text-white rounded-tr-none shadow-xl shadow-blue-100'))">
                  {{ msg.noiDung }}
              </div>
              
              <div class="absolute top-1/2 -translate-y-1/2 opacity-0 group-hover/msg:opacity-100 transition-opacity duration-300 flex items-center gap-1"
                :class="msg.loaiNguoiGui === 'USER' ? 'left-full ml-3' : 'right-full mr-3'">
                <span class="text-[9px] font-bold text-gray-400 bg-white px-2 py-1 rounded-full shadow-sm border border-gray-100 tabular-nums">
                  {{ formatTimeVeryShort(msg.ngayGui) }}
                </span>
              </div>
            </div>
          </div>
          
          <!-- Loading State inside messages -->
          <div v-if="loadingHistory" class="flex flex-col items-center justify-center py-10 gap-3">
             <div class="size-6 border-2 border-yellow-200 border-t-yellow-500 rounded-full animate-spin"></div>
             <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Đang tải lịch sử...</p>
          </div>
        </div>

        <!-- Input Area -->
        <div v-if="selectedConv.trangThai !== 'CLOSED'" class="p-6 bg-white border-t border-gray-100 shadow-[0_-10px_30px_-15px_rgba(0,0,0,0.05)] z-20">
          <div class="flex flex-wrap gap-2 mb-4">
             <button v-for="q in quickReplies" :key="q" @click="replyText = q" class="px-3.5 py-1.5 bg-gray-50 hover:bg-gold hover:text-white rounded-xl text-[10px] font-black uppercase tracking-widest text-gray-400 border border-gray-100 transition-all active:scale-95 shadow-sm">
                {{ q }}
             </button>
             <button @click="autoComplete" class="ml-auto flex items-center gap-1 px-3 py-1.5 bg-slate-900 text-gold rounded-xl text-[9px] font-black uppercase tracking-widest hover:scale-105 transition-all shadow-lg active:scale-95">
                <span class="material-symbols-outlined text-[14px]">auto_awesome</span>
                Gợi ý AI
             </button>
          </div>
          
          <form @submit.prevent="sendReply" class="flex gap-3 items-end bg-gray-50 p-3 rounded-[24px] border border-gray-100 focus-within:border-gold/30 focus-within:bg-white focus-within:shadow-xl focus-within:shadow-gold/5 transition-all duration-500">
             <textarea 
               v-model="replyText" 
               placeholder="Nhập nội dung phản hồi khách hàng..." 
               class="flex-1 bg-transparent border-none resize-none text-[13px] font-medium p-2 focus:ring-0 max-h-40 min-h-[44px] custom-scroll" 
               rows="1" 
               @keydown.enter.exact.prevent="sendReply"
             ></textarea>
             
             <button type="submit" :disabled="!replyText.trim() || replying" 
                class="size-12 rounded-2xl flex items-center justify-center transition-all duration-500 shadow-xl bg-yellow-400 text-yellow-900 shadow-yellow-100 hover:shadow-yellow-200 hover:-translate-y-1 active:scale-90 disabled:opacity-30">
                <span v-if="!replying" class="material-symbols-outlined text-2xl">arrow_upward</span>
                <div v-else class="size-5 border-2 border-current border-t-transparent rounded-full animate-spin"></div>
             </button>
          </form>
        </div>
        
        <div v-else class="p-8 bg-gray-50 border-t border-gray-100 flex flex-col items-center justify-center gap-3">
           <div class="flex items-center gap-2 px-6 py-3 rounded-full bg-white border border-gray-100 shadow-sm">
              <span class="material-symbols-outlined text-gray-400">lock</span>
              <span class="text-xs font-black text-gray-500 uppercase tracking-widest">Cuộc hội thoại đã kết thúc</span>
           </div>
           <p class="text-[11px] text-gray-400 font-medium italic">Bạn không thể gửi thêm tin nhắn vào lúc này.</p>
        </div>
      </template>

      <!-- EMPTY STATE -->
      <div v-else class="flex-1 flex flex-col items-center justify-center bg-gray-50/10 p-12 text-center">
        <div class="relative mb-8">
           <div class="size-32 rounded-[48px] bg-white shadow-2xl flex items-center justify-center text-slate-100">
              <span class="material-symbols-outlined text-7xl">chat_bubble</span>
           </div>
           <div class="absolute -bottom-2 -right-2 size-10 rounded-2xl bg-yellow-400 text-yellow-900 shadow-xl flex items-center justify-center animate-bounce">
              <span class="material-symbols-outlined">support_agent</span>
           </div>
        </div>
        <h2 class="text-2xl font-black text-slate-800 uppercase tracking-tight mb-2">Trung tâm điều hành Chat</h2>
        <p class="text-sm font-medium text-gray-400 max-w-sm mb-8 leading-relaxed">Chọn một cuộc hội thoại từ danh sách bên trái để bắt đầu hỗ trợ khách hàng theo tiêu chuẩn Luxury.</p>
        
        <div class="grid grid-cols-2 gap-4 w-full max-w-md">
           <div class="bg-white p-5 rounded-3xl shadow-sm border border-gray-100 text-left group hover:border-yellow-400/30 transition-all cursor-default">
              <div class="size-8 rounded-xl bg-orange-50 text-orange-600 flex items-center justify-center mb-3 group-hover:bg-orange-600 group-hover:text-white transition-all">
                 <span class="material-symbols-outlined text-[20px]">priority_high</span>
              </div>
              <p class="text-[11px] font-bold text-gray-400 uppercase tracking-widest mb-1">Cần hỗ trợ</p>
              <p class="text-sm font-bold text-gray-800 tabular-nums">{{ stats.pending + stats.human }} khách đang chờ</p>
           </div>
           <div class="bg-white p-5 rounded-3xl shadow-sm border border-gray-100 text-left group hover:border-yellow-400/30 transition-all cursor-default">
              <div class="size-8 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center mb-3 group-hover:bg-blue-600 group-hover:text-white transition-all">
                 <span class="material-symbols-outlined text-[20px]">robot_2</span>
              </div>
              <p class="text-[11px] font-bold text-gray-400 uppercase tracking-widest mb-1">AI đang trực</p>
              <p class="text-sm font-bold text-gray-800 tabular-nums">{{ stats.ai }} khách đang chat</p>
           </div>
        </div>
      </div>
    </div>

    <!-- RIGHT PANEL: Customer Info (Dynamic/Collapsible) -->
    <transition name="panel">
      <div v-if="showRightPanel && selectedConv?.taiKhoan" class="w-80 border-l border-gray-100 bg-white flex flex-col shadow-2xl z-30 overflow-y-auto custom-scroll">
        <!-- Close Button for Mobile/Drawer feel -->
        <div class="p-6 border-b border-gray-100 flex items-center justify-between sticky top-0 bg-white/90 backdrop-blur-md z-10">
           <h4 class="text-[11px] font-black text-slate-800 uppercase tracking-widest">Thông tin khách hàng</h4>
           <button @click="showRightPanel = false" class="p-1.5 hover:bg-gray-100 rounded-lg transition-colors">
              <span class="material-symbols-outlined text-[20px] text-gray-400">close</span>
           </button>
        </div>

        <div class="p-8 flex flex-col items-center text-center">
           <div class="size-24 rounded-[36px] bg-slate-800 text-gold flex items-center justify-center text-3xl font-black shadow-2xl mb-6 relative group overflow-hidden border-4 border-white">
              <img v-if="selectedConv.taiKhoan.avatar" :src="selectedConv.taiKhoan.avatar" class="size-full object-cover group-hover:scale-110 transition-transform duration-700" />
              <span v-else>{{ getInitials(selectedConv.taiKhoan.hoTen) }}</span>
           </div>
           <h3 class="text-lg font-black text-gray-800 mb-1 leading-tight">{{ selectedConv.taiKhoan.hoTen }}</h3>
           <span class="px-3 py-1 bg-gold/10 text-gold rounded-full text-[10px] font-black uppercase tracking-widest border border-gold/10">Silver Member</span>
        </div>

        <div class="px-6 space-y-6 pb-12">
           <div class="space-y-4">
              <div class="bg-gray-50 rounded-2xl p-4 border border-gray-100/50 group hover:bg-white hover:shadow-lg hover:border-gold/20 transition-all duration-300">
                 <label class="text-[9px] font-black text-gray-400 uppercase tracking-widest block mb-1">Email liên hệ</label>
                 <p class="text-xs font-bold text-gray-700 break-all">{{ selectedConv.taiKhoan.email }}</p>
              </div>
              <div class="bg-gray-50 rounded-2xl p-4 border border-gray-100/50 group hover:bg-white hover:shadow-lg hover:border-gold/20 transition-all duration-300">
                 <label class="text-[9px] font-black text-gray-400 uppercase tracking-widest block mb-1">Số điện thoại</label>
                 <p class="text-xs font-bold text-gray-700">{{ selectedConv.taiKhoan.soDienThoai || 'Chưa cập nhật' }}</p>
              </div>
           </div>

           <div class="pt-2">
              <div class="flex items-center justify-between mb-4">
                 <h5 class="text-[10px] font-black text-slate-800 uppercase tracking-widest">Đơn hàng gần đây</h5>
                 <span class="text-[10px] font-bold text-gray-400 tabular-nums">{{ customerOrders.length }} đơn</span>
              </div>
              
              <div v-if="customerOrders.length > 0" class="space-y-2">
                 <div v-for="o in customerOrders" :key="o.maDH" class="group flex justify-between items-center p-3.5 bg-gray-50 rounded-2xl border border-gray-100/50 hover:bg-slate-900 transition-all duration-500">
                    <div class="flex flex-col">
                       <span class="text-[11px] font-black text-slate-800 group-hover:text-gold transition-colors italic">#{{ o.maDH }}</span>
                       <span class="text-[9px] font-bold text-gray-400 tabular-nums uppercase">{{ formatDate(o.ngayDat) }}</span>
                    </div>
                    <span class="text-[11px] font-black text-slate-900 group-hover:text-white tabular-nums">{{ fmtCurrency(o.tongTien) }}</span>
                 </div>
              </div>
              <div v-else class="py-8 flex flex-col items-center justify-center bg-gray-50 rounded-3xl border border-dashed border-gray-200">
                 <span class="material-symbols-outlined text-gray-200 text-3xl mb-1">shopping_bag</span>
                 <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest">Chưa có giao dịch</p>
              </div>
           </div>
           
           <button class="w-full py-4 bg-slate-900 text-gold rounded-2xl text-[10px] font-black uppercase tracking-widest shadow-xl shadow-slate-200 hover:-translate-y-1 transition-all active:scale-95 flex items-center justify-center gap-2">
              <span class="material-symbols-outlined text-[18px]">open_in_new</span>
              Xem chi tiết hồ sơ
           </button>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'ChatManagement',
  props: {
    role: {
      type: String,
      default: 'ADMIN' // ADMIN or STAFF
    }
  },
  data() {
    return {
      conversations: [],
      selectedConv: null,
      currentMessages: [],
      customerOrders: [],
      loadingHistory: false,
      isFetching: false,
      searchKeyword: '',
      activeTab: 'HUMAN',
      replyText: '',
      replying: false,
      showRightPanel: true,
      pollingInterval: null,
      tabs: [
        { id: 'HUMAN', label: 'Cần hỗ trợ' },
        { id: 'AI', label: 'AI đang trực' },
        { id: 'ALL', label: 'Tất cả' },
        { id: 'CLOSED', label: 'Lịch sử' }
      ],
      quickReplies: ['Xin chào!', 'Dạ vâng ạ', 'Sản phẩm này còn hàng', 'Vui lòng chờ giây lát', 'Cảm ơn bạn!']
    }
  },
  computed: {
    filteredConversations() {
      let filtered = this.conversations;
      if (this.activeTab !== 'ALL') {
        if (this.activeTab === 'HUMAN') {
          // Tab "Cần hỗ trợ" hiện cả PENDING và HUMAN
          filtered = filtered.filter(c => c.trangThai === 'HUMAN' || c.trangThai === 'PENDING');
        } else {
          filtered = filtered.filter(c => c.trangThai === this.activeTab);
        }
      }
      if (this.searchKeyword) {
        const kw = this.searchKeyword.toLowerCase();
        filtered = filtered.filter(c => 
          (c.taiKhoan?.hoTen || '').toLowerCase().includes(kw) ||
          (c.taiKhoan?.email || '').toLowerCase().includes(kw)
        );
      }
      return filtered;
    },
    stats() {
       return {
          human: this.conversations.filter(c => c.trangThai === 'HUMAN').length,
          pending: this.conversations.filter(c => c.trangThai === 'PENDING').length,
          ai: this.conversations.filter(c => c.trangThai === 'AI').length
       }
    }
  },
  methods: {
    async fetchConversations(silent = false) {
      if (!silent) this.isFetching = true;
      try {
        const res = await axios.get('/chat/admin/all', { withCredentials: true });
        this.conversations = res.data;
      } catch (e) {
        console.error('Fetch error:', e);
      } finally {
        this.isFetching = false;
      }
    },
    async selectConversation(conv) {
      if (this.selectedConv?.maCuocTroChuyen === conv.maCuocTroChuyen) return;
      this.selectedConv = conv;
      this.loadingHistory = true;
      this.currentMessages = [];
      try {
        const res = await axios.get(`/chat/history/${conv.maCuocTroChuyen}`, { withCredentials: true });
        this.currentMessages = res.data;
        if (conv.taiKhoan) this.fetchOrders(conv.taiKhoan.email);
        this.scrollToBottom();
      } catch (e) {
        console.error('History error:', e);
      } finally {
        this.loadingHistory = false;
      }
    },
    async fetchOrders(email) {
       try {
          const res = await axios.get('/admin/orders', { params: { keyword: email, size: 5 }, withCredentials: true });
          this.customerOrders = res.data.content || [];
       } catch (e) {}
    },
    async sendReply() {
      if (!this.replyText.trim() || !this.selectedConv || this.replying) return;
      const text = this.replyText.trim();
      this.replying = true;
      try {
        const res = await axios.post('/chat/admin/reply', 
          { conversationId: this.selectedConv.maCuocTroChuyen, content: text }, 
          { withCredentials: true }
        );
        this.currentMessages.push(res.data);
        this.replyText = '';
        this.scrollToBottom();
      } catch (e) {
        console.error('Reply error:', e);
        alert('Lỗi gửi tin nhắn');
      } finally {
        this.replying = false;
      }
    },
    async closeConv() {
       if (!confirm('Bạn có chắc chắn muốn kết thúc cuộc hỗ trợ này?')) return;
       try {
          const res = await axios.post('/chat/admin/status', 
             { conversationId: this.selectedConv.maCuocTroChuyen, status: 'CLOSED' },
             { withCredentials: true }
          );
          this.selectedConv.trangThai = 'CLOSED';
          this.fetchConversations(true);
       } catch (e) {}
    },
    autoComplete() {
       this.replying = true;
       setTimeout(() => {
          this.replyText = 'Rất xin lỗi vì sự bất tiện này. Sản phẩm bạn quan tâm hiện đang có sẵn tại cửa hàng. Bạn có muốn đặt hàng ngay không?';
          this.replying = false;
       }, 800);
    },
    startGlobalPolling() {
      this.stopPolling();
      this.pollingInterval = setInterval(() => {
        this.fetchConversations(true);
        if (this.selectedConv) {
          this.fetchMessagesSilently();
        }
      }, 5000);
    },
    async fetchMessagesSilently() {
      if (this.replying) return;
      try {
        const res = await axios.get(`/chat/history/${this.selectedConv.maCuocTroChuyen}`, { withCredentials: true });
        if (res.data.length > this.currentMessages.length) {
          this.currentMessages = res.data;
          this.scrollToBottom();
        }
      } catch (e) {}
    },
    stopPolling() {
      if (this.pollingInterval) clearInterval(this.pollingInterval);
    },
    getInitials(name) {
      if (!name) return 'K';
      return name.split(' ').map(n => n[0]).join('').toUpperCase().substring(0, 2);
    },
    formatTimeShort(d) {
      if (!d) return '';
      const date = new Date(d);
      const today = new Date();
      if (date.toDateString() === today.toDateString()) {
         return date.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
      }
      return date.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit' });
    },
    formatTimeVeryShort(d) {
      return d ? new Date(d).toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' }) : '';
    },
    formatDate(d) {
       return d ? new Date(d).toLocaleDateString('vi-VN') : '';
    },
    fmtCurrency(v) {
      return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(v || 0);
    },
    isNewGroup(idx) {
      if (idx === 0) return true;
      return this.currentMessages[idx].loaiNguoiGui !== this.currentMessages[idx-1].loaiNguoiGui;
    },
    scrollToBottom() {
      this.$nextTick(() => {
        if (this.$refs.historyContainer) {
          this.$refs.historyContainer.scrollTo({
             top: this.$refs.historyContainer.scrollHeight,
             behavior: 'smooth'
          });
        }
      });
    }
  },
  mounted() {
    this.fetchConversations();
    this.startGlobalPolling();
  },
  beforeUnmount() {
    this.stopPolling();
  }
}
</script>

<style scoped>
.gold { color: #854d0e; }
.bg-gold { background-color: #facc15; }
.border-gold { border-color: #facc15; }
.focus\:ring-gold:focus { --tw-ring-color: #ca8a04; }
.ring-gold { --tw-ring-color: #ca8a04; }

.custom-scroll::-webkit-scrollbar {
  width: 5px;
}
.custom-scroll::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scroll::-webkit-scrollbar-thumb {
  background: rgba(0,0,0,0.05);
  border-radius: 10px;
}
.custom-scroll:hover::-webkit-scrollbar-thumb {
  background: rgba(0,0,0,0.1);
}

.no-scrollbar::-webkit-scrollbar {
  display: none;
}

/* Panel Transitions */
.panel-enter-active, .panel-leave-active {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}
.panel-enter-from, .panel-leave-to {
  transform: translateX(100%);
  opacity: 0;
}

/* Message groups */
.group\/msg:hover {
   transform: translateY(-1px);
}
</style>
