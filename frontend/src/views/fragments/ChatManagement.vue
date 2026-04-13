<template>
  <div class="flex h-full overflow-hidden bg-white">
    <!-- LEFT PANEL: Conversation List -->
    <div class="flex w-[22rem] flex-col border-r border-[#C8A97E]/30 bg-white">
      <div class="p-6 border-b border-[#C8A97E]/30 bg-[#EFE9DB]/30">
        <div class="relative group">
          <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-gray-500 text-[20px] group-focus-within:text-black transition-colors">search</span>
          <input 
            type="text" 
            v-model="searchKeyword" 
            placeholder="Tìm theo tên hoặc email..." 
            class="w-full pl-12 pr-4 py-3 bg-[#EFE9DB] border border-[#C8A97E]/20 rounded-2xl text-black font-black focus:ring-2 focus:ring-[#C8A97E]/40 focus:bg-white transition-all placeholder:text-gray-500 placeholder:font-medium" 
          />
        </div>
      </div>
      
      <!-- Filter Tabs: Luxury Minimalist -->
      <div class="px-6 py-4">
        <div class="flex gap-2 p-1 bg-gray-100/50 rounded-2xl overflow-x-auto no-scrollbar">
          <button v-for="tab in tabs" :key="tab.id" @click="activeTab = tab.id"
            class="flex-1 px-3 py-2 rounded-[0.9rem] text-[10px] font-black uppercase tracking-wider whitespace-nowrap transition-all duration-400"
            :class="activeTab === tab.id ? 
              'bg-white shadow-md text-[#C8A97E]' : 
              'text-gray-400 hover:text-gray-600'">
            {{ tab.label }}
          </button>
        </div>
      </div>

      <!-- Conversations Loop -->
      <div class="flex-1 overflow-y-auto custom-scroll-minimal px-4 space-y-3 py-4">
          <div v-if="filteredConversations.length === 0 && !isFetching" class="py-20 text-center flex flex-col items-center opacity-30">
             <span class="material-symbols-outlined text-5xl font-extralight mb-4">chat_bubble_outline</span>
             <p class="text-[10px] font-black uppercase tracking-widest text-slate-900">Không có hội thoại</p>
          </div>
          
          <div v-for="conv in filteredConversations" :key="conv.maCuocTroChuyen" @click="selectConversation(conv)"
            class="group flex items-center gap-4 p-4 rounded-3xl cursor-pointer transition-all duration-700 relative border border-transparent"
            :class="selectedConv?.maCuocTroChuyen === conv.maCuocTroChuyen ? 
              'bg-white border-[#C8A97E]/30 shadow-[0_20px_50px_rgba(0,0,0,0.06)] z-10' : 
              'hover:bg-gray-50/50'">
          
            <div class="relative flex-shrink-0">
              <div class="size-12 rounded-[1.1rem] bg-slate-900 text-white flex items-center justify-center shadow-lg overflow-hidden border-2 border-white ring-1 ring-gray-100">
                <img v-if="conv.taiKhoan?.avatar" :src="conv.taiKhoan.avatar" class="size-full object-cover" />
                <span v-else class="font-serif text-sm text-[#C8A97E]">{{ getInitials(conv.taiKhoan?.hoTen || 'K') }}</span>
              </div>
              <div class="absolute -bottom-0.5 -right-0.5 size-3 rounded-full border-2 border-white shadow-sm" 
                :class="conv.trangThai === 'HUMAN' ? 'bg-[#C8A97E]' : (conv.trangThai === 'PENDING' ? 'bg-red-500' : 'bg-blue-500')"></div>
            </div>
            <div class="flex-1 min-w-0">
              <div class="flex justify-between items-baseline mb-1">
                <h4 class="text-[13px] font-bold text-slate-800 truncate leading-none">
                  {{ conv.taiKhoan?.hoTen || conv.taiKhoan?.email || 'Guest #' + conv.maCuocTroChuyen }}
                </h4>
                <span class="text-[9px] text-gray-300 font-bold tabular-nums uppercase">{{ formatTimeShort(conv.ngayCapNhat) }}</span>
              </div>
              <p class="text-[11px] text-gray-400 truncate font-medium leading-tight" :class="{'text-[#C8A97E] font-bold': (conv.trangThai === 'PENDING') && selectedConv?.maCuocTroChuyen !== conv.maCuocTroChuyen}">
                {{ conv.lastMessage || 'Bắt đầu trò chuyện sang trọng...' }}
              </p>
            </div>
          </div>
      </div>
      
      <!-- Last Sync -->
      <div class="p-6 border-t border-gray-50 flex items-center justify-between">
        <span class="text-[10px] font-black text-gray-300 uppercase tracking-[0.2em] flex items-center gap-2">
           <span class="size-1 bg-[#C8A97E] rounded-full"></span>
           Live Syncing
        </span>
        <button @click="fetchConversations" class="p-1 hover:text-[#C8A97E] transition-colors">
           <span class="material-symbols-outlined text-[18px]" :class="{'animate-spin': isFetching}">refresh</span>
        </button>
      </div>
    </div>

    <!-- MIDDLE PANEL: Chat Window -->
    <div class="flex-1 flex flex-col bg-[#FDFDFD] relative">
      <template v-if="selectedConv">
        <!-- Chat Header: Premium Luxury Design -->
        <div class="h-24 px-10 border-b border-[#C8A97E]/30 flex items-center justify-between bg-white/80 backdrop-blur-md sticky top-0 z-20">
          <div class="flex items-center gap-6">
            <div class="relative group">
              <div class="size-14 rounded-2xl bg-slate-900 flex items-center justify-center shadow-2xl border-2 border-white ring-1 ring-[#C8A97E]/30 overflow-hidden">
                 <img v-if="selectedConv.taiKhoan?.avatar" :src="selectedConv.taiKhoan.avatar" class="size-full object-cover group-hover:scale-110 transition-transform duration-700" />
                 <span v-else class="text-[#C8A97E] font-serif text-xl">{{ getInitials(selectedConv.taiKhoan?.hoTen) }}</span>
              </div>
              <div class="absolute -bottom-1 -right-1 size-4 rounded-full border-2 border-white" 
                :class="selectedConv.trangThai === 'HUMAN' ? 'bg-[#C8A97E]' : 'bg-blue-500'"></div>
            </div>
            <div class="flex flex-col">
              <h3 class="text-xl font-serif font-bold text-slate-800 leading-tight">
                {{ selectedConv.taiKhoan?.hoTen || selectedConv.taiKhoan?.email || 'Khách vãng lai #' + selectedConv.maCuocTroChuyen }}
              </h3>
              <div class="flex items-center gap-2 mt-1">
                <span class="text-[10px] font-black uppercase tracking-[0.2em] text-[#C8A97E]">
                  {{ selectedConv.trangThai === 'HUMAN' ? 'Đang tư vấn trực tiếp' : 'AI Assistant Active' }}
                </span>
                <span class="size-1 rounded-full bg-gray-300"></span>
                <span class="text-[10px] font-bold text-gray-400 tabular-nums">{{ selectedConv.taiKhoan?.email || 'Guest' }}</span>
              </div>
            </div>
          </div>
          <div class="flex items-center gap-3">
            <button @click="showRightPanel = !showRightPanel" 
               class="flex items-center gap-2 px-5 py-2.5 rounded-full transition-all duration-300 border border-[#C8A97E]/20 text-slate-600 hover:bg-[#C8A97E] hover:text-white hover:shadow-lg hover:shadow-[#C8A97E]/20">
               <span class="material-symbols-outlined text-[20px]">person_outline</span>
               <span class="text-[11px] font-black uppercase tracking-widest">Hồ sơ</span>
            </button>
            <div class="w-px h-8 bg-gray-100 mx-2"></div>
            <button v-if="selectedConv.trangThai !== 'CLOSED'" @click="closeConv" 
               class="px-6 py-2.5 bg-slate-900 text-[#C8A97E] rounded-full text-[11px] font-black uppercase tracking-widest transition-all hover:bg-black hover:-translate-y-0.5 shadow-xl">
               Kết thúc
            </button>
          </div>
        </div>

        <!-- Messages: Elegant spacing -->
        <div class="flex-1 overflow-y-auto p-10 space-y-10 custom-scroll" ref="historyContainer">
          <div v-for="(msg, idx) in currentMessages" :key="idx" 
            class="flex flex-col" :class="msg.loaiNguoiGui === 'USER' ? 'items-start' : 'items-end'">
            
            <div class="max-w-[70%]">
              <div class="px-7 py-5 rounded-[2rem] text-[14px] leading-relaxed transition-all shadow-sm"
                :class="msg.loaiNguoiGui === 'USER' ? 
                  'bg-white text-slate-800 rounded-tl-none border border-gray-100' : 
                  (msg.loaiNguoiGui === 'AI' ? 
                    'bg-[#F8F5F0] text-slate-700 rounded-tr-none border border-[#C8A97E]/10 italic' : 
                    'bg-slate-900 text-[#C8A97E] rounded-tr-none shadow-2xl')">
                  {{ msg.noiDung }}
              </div>
              <p class="text-[9px] font-black text-gray-300 uppercase tracking-widest mt-2 px-2" :class="msg.loaiNguoiGui === 'USER' ? 'text-left' : 'text-right'">
                {{ formatDate(msg.ngayGui) }} • {{ msg.loaiNguoiGui === 'USER' ? 'KHÁCH HÀNG' : 'TƯ VẤN VIÊN' }}
              </p>
            </div>
          </div>
        </div>

        <!-- Input Area: Clean & Professional -->
        <div v-if="selectedConv.trangThai !== 'CLOSED'" class="p-8 bg-white border-t border-gray-50 shadow-[0_-20px_50px_rgba(0,0,0,0.03)]">
          <form @submit.prevent="sendReply" class="relative group">
             <textarea 
               v-model="replyText" 
               placeholder="Viết lời hồi âm tinh tế tại đây..." 
               class="w-full bg-gray-50 border-none rounded-[2rem] text-[14px] font-medium p-6 pr-20 focus:ring-2 focus:ring-[#C8A97E]/20 focus:bg-white focus:shadow-2xl transition-all duration-700 min-h-[70px] max-h-40 custom-scroll" 
               rows="1" 
               @keydown.enter.exact.prevent="sendReply"
             ></textarea>
             
             <button type="submit" :disabled="!replyText.trim() || replying" 
                class="absolute right-3 bottom-3 size-12 rounded-full flex items-center justify-center bg-slate-900 text-[#C8A97E] shadow-xl hover:scale-105 transition-all disabled:opacity-20 active:scale-95">
                <span v-if="!replying" class="material-symbols-outlined">send</span>
                <div v-else class="size-4 border-2 border-[#C8A97E] border-t-transparent rounded-full animate-spin"></div>
             </button>
          </form>
        </div>
      </template>

      <!-- EMPTY STATE: LUXURY VERSION -->
      <div v-else class="flex-1 flex flex-col items-center justify-center bg-white p-20 text-center relative overflow-hidden">
        <div class="absolute inset-0 opacity-[0.02] pointer-events-none italic font-serif text-[20rem] flex items-center justify-center select-none text-slate-900">Luxury</div>
        
        <div class="relative z-10 flex flex-col items-center max-w-2xl">
           <div class="size-28 rounded-[40px] bg-slate-900 flex items-center justify-center mb-10 shadow-[0_30px_60px_-15px_rgba(0,0,0,0.3)] relative group cursor-default">
              <span class="material-symbols-outlined text-[#C8A97E] text-5xl">auto_fix_high</span>
              <div class="absolute -inset-4 border border-[#C8A97E]/20 rounded-[50px] animate-pulse"></div>
           </div>
           
           <h2 class="text-4xl font-serif font-bold text-slate-800 tracking-tight mb-4">Command Center</h2>
           <div class="h-px w-20 bg-[#C8A97E] mb-6"></div>
           <p class="text-base text-gray-400 font-medium leading-relaxed mb-12">
              Chào mừng bạn đến với hệ thống quản lý hội thoại thời gian thực. Hãy lựa chọn một khách hàng để bắt đầu mang lại trải nghiệm mua sắm đẳng cấp nhất.
           </p>

           <div class="grid grid-cols-2 gap-8 w-full max-w-lg">
              <div class="p-8 bg-white rounded-[2.5rem] shadow-[0_20px_50px_rgba(0,0,0,0.05)] border border-gray-100 flex flex-col items-center group hover:border-[#C8A97E]/30 transition-all duration-700">
                 <div class="size-12 rounded-2xl bg-orange-50 text-orange-600 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                    <span class="material-symbols-outlined">notifications_active</span>
                 </div>
                 <p class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] mb-1">Cần hỗ trợ</p>
                 <p class="text-3xl font-serif font-bold text-slate-900 tabular-nums">{{ stats.pending + stats.human }}</p>
              </div>
              
              <div class="p-8 bg-white rounded-[2.5rem] shadow-[0_20px_50px_rgba(0,0,0,0.05)] border border-gray-100 flex flex-col items-center group hover:border-[#C8A97E]/30 transition-all duration-700">
                 <div class="size-12 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                    <span class="material-symbols-outlined">psychology</span>
                 </div>
                 <p class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] mb-1">AI Trợ lý</p>
                 <p class="text-3xl font-serif font-bold text-slate-900 tabular-nums">{{ stats.ai }}</p>
              </div>
           </div>
        </div>
      </div>
    </div>

    <!-- RIGHT PANEL: Customer Info (Dynamic/Collapsible) -->
    <transition name="panel">
      <div v-if="showRightPanel && selectedConv?.taiKhoan" class="w-[22rem] border-l border-[#C8A97E]/30 bg-white flex flex-col z-30 overflow-y-auto custom-scroll shadow-[-10px_0_30px_rgba(0,0,0,0.02)]">
        <!-- Close Button for Mobile/Drawer feel -->
        <div class="p-8 border-b border-gray-50 flex items-center justify-between sticky top-0 bg-white/90 backdrop-blur-md z-10">
           <h4 class="text-[10px] font-black text-slate-400 uppercase tracking-[0.25em]">Hồ sơ khách hàng</h4>
           <button @click="showRightPanel = false" class="size-8 flex items-center justify-center hover:bg-gray-50 rounded-full transition-colors">
              <span class="material-symbols-outlined text-[18px] text-gray-300">close</span>
           </button>
        </div>

        <div class="p-10 flex flex-col items-center text-center">
           <div class="size-28 rounded-[2.5rem] bg-slate-900 text-[#C8A97E] flex items-center justify-center text-3xl font-black shadow-2xl mb-8 relative group overflow-hidden border-4 border-white ring-1 ring-gray-100">
              <img v-if="selectedConv.taiKhoan.avatar" :src="selectedConv.taiKhoan.avatar" class="size-full object-cover group-hover:scale-110 transition-transform duration-700" />
              <span v-else class="font-serif text-3xl">{{ getInitials(selectedConv.taiKhoan.hoTen) }}</span>
           </div>
           <h3 class="text-2xl font-serif font-bold text-slate-800 mb-2 leading-tight">{{ selectedConv.taiKhoan.hoTen }}</h3>
            <span class="px-4 py-1 bg-slate-900 text-[#C8A97E] rounded-full text-[9px] font-black uppercase tracking-[0.2em] shadow-lg">Luxury VIP Member</span>
        </div>

        <div class="px-8 space-y-8 pb-12">
           <div class="space-y-5">
              <div class="group">
                 <label class="text-[9px] font-black text-gray-300 uppercase tracking-widest block mb-2 px-1">Email liên hệ</label>
                 <div class="bg-gray-50 rounded-2xl p-4 border border-transparent group-hover:bg-white group-hover:border-[#C8A97E]/20 group-hover:shadow-xl transition-all duration-500">
                    <p class="text-[13px] font-bold text-slate-700 break-all">{{ selectedConv.taiKhoan.email }}</p>
                 </div>
              </div>
              <div class="group">
                 <label class="text-[9px] font-black text-gray-300 uppercase tracking-widest block mb-2 px-1">Số điện thoại</label>
                 <div class="bg-gray-50 rounded-2xl p-4 border border-transparent group-hover:bg-white group-hover:border-[#C8A97E]/20 group-hover:shadow-xl transition-all duration-500">
                    <p class="text-[13px] font-bold text-slate-700">{{ selectedConv.taiKhoan.soDienThoai || 'Chưa cập nhật' }}</p>
                 </div>
              </div>
           </div>

           <div class="pt-4">
              <div class="flex items-center justify-between mb-6">
                 <h5 class="text-[10px] font-black text-slate-800 uppercase tracking-widest">Giao dịch gần nhất</h5>
                 <span class="px-2 py-1 bg-gray-100 rounded-lg text-[9px] font-bold text-gray-400 tabular-nums">{{ customerOrders.length }} đơn</span>
              </div>
              
              <div v-if="customerOrders.length > 0" class="space-y-3">
                 <div v-for="o in customerOrders" :key="o.maDH" class="group flex justify-between items-center p-4 bg-white border border-gray-50 rounded-[1.5rem] hover:bg-slate-900 hover:border-slate-900 transition-all duration-500 shadow-sm hover:shadow-2xl hover:-translate-y-1">
                    <div class="flex flex-col">
                       <span class="text-[12px] font-black text-slate-800 group-hover:text-[#C8A97E] transition-colors italic mb-0.5">#Order-{{ o.maDH }}</span>
                       <span class="text-[9px] font-bold text-gray-400 tabular-nums uppercase">{{ formatDate(o.ngayDat) }}</span>
                    </div>
                    <span class="text-[12px] font-black text-slate-900 group-hover:text-white tabular-nums">{{ fmtCurrency(o.tongTien) }}</span>
                 </div>
              </div>
              <div v-else class="py-12 flex flex-col items-center justify-center bg-gray-50/50 rounded-[2rem] border border-dashed border-gray-200">
                 <span class="material-symbols-outlined text-gray-200 text-4xl mb-2 font-extralight">shopping_bag</span>
                 <p class="text-[10px] text-gray-300 font-bold uppercase tracking-widest">Chưa có giao dịch</p>
              </div>
           </div>
           
           <button class="w-full py-5 bg-slate-900 text-[#C8A97E] rounded-[1.5rem] text-[10px] font-black uppercase tracking-[0.25em] shadow-2xl hover:bg-black hover:-translate-y-1 transition-all active:scale-95 flex items-center justify-center gap-2">
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
      activeTab: 'PENDING',
      replyText: '',
      replying: false,
      showRightPanel: true,
      pollingInterval: null,
      tabs: [
        { id: 'PENDING', label: 'Cần hỗ trợ' },
        { id: 'HUMAN', label: 'Đang xử lý' },
        { id: 'AI', label: 'AI đang trực' },
        { id: 'ALL', label: 'Tất cả' }
      ],
      quickReplies: ['Xin chào!', 'Dạ vâng ạ', 'Sản phẩm này còn hàng', 'Vui lòng chờ giây lát', 'Cảm ơn bạn!']
    }
  },
  computed: {
    filteredConversations() {
      let filtered = [...this.conversations];
      if (this.activeTab !== 'ALL') {
        // Tab cụ thể không hiện cuộc hội thoại đã CLOSED
        filtered = filtered.filter(c => c.trangThai !== 'CLOSED');

        if (this.activeTab === 'HUMAN') {
           filtered = filtered.filter(c => c.trangThai === 'HUMAN');
        } else if (this.activeTab === 'PENDING') {
           filtered = filtered.filter(c => c.trangThai === 'PENDING');
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
    async acceptConv() {
       if (!this.selectedConv) return;
       try {
          await axios.post('/chat/admin/accept', 
             { conversationId: this.selectedConv.maCuocTroChuyen },
             { withCredentials: true }
          );
          this.selectedConv.trangThai = 'HUMAN';
          this.fetchConversations(true);
       } catch (e) {
          window.$toast.error('Lỗi khi tiếp nhận cuộc trò chuyện');
       }
    },
    async closeConv() {
       const ok = await window.$confirm('Bạn có chắc chắn muốn kết thúc cuộc hỗ trợ này?');
       if (!ok) return;
       try {
          await axios.post('/chat/admin/status', 
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
.gold { color: #C8A97E; }
.bg-gold { background-color: #C8A97E; }
.border-gold { border-color: #C8A97E; }
.focus\:ring-gold:focus { --tw-ring-color: rgba(200, 169, 126, 0.4); }
.ring-gold { --tw-ring-color: rgba(200, 169, 126, 0.4); }

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
