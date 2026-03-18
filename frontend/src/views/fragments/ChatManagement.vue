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
            class="px-5 py-2 rounded-xl text-[11px] font-black uppercase tracking-widest whitespace-nowrap transition-all duration-300"
            :class="activeTab === tab.id ? 
              'bg-white shadow-sm text-[#C8A97E]' : 
              'text-gray-400 hover:text-gray-600'">
            {{ tab.label }}
          </button>
        </div>
      </div>

      <!-- Conversations Loop -->
      <div class="flex-1 overflow-y-auto custom-scroll px-3 space-y-2 py-4 bg-gray-50/30">
          <div v-if="filteredConversations.length === 0 && !isFetching" class="py-12 text-center">
             <span class="material-symbols-outlined text-4xl text-gray-200 mb-2">inbox</span>
             <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Không có hội thoại</p>
          </div>
          
          <div v-if="isFetching" class="py-12 text-center space-y-3">
             <div class="size-6 border-2 border-[#C8A97E]/20 border-t-[#C8A97E] rounded-full animate-spin mx-auto"></div>
             <p class="text-[9px] font-black text-[#C8A97E] uppercase tracking-widest">Đang kết nối...</p>
          </div>

          <div v-for="conv in filteredConversations" :key="conv.maCuocTroChuyen" @click="selectConversation(conv)"
            class="group flex items-center gap-3 p-3.5 rounded-2xl cursor-pointer transition-all duration-500 relative border border-transparent"
            :class="selectedConv?.maCuocTroChuyen === conv.maCuocTroChuyen ? 
              'bg-white border-[#C8A97E]/30 shadow-xl scale-[1.02] z-10 ring-1 ring-[#C8A97E]/10' : 
              'hover:bg-white hover:border-gray-100 hover:shadow-md hover:scale-[1.01]'">
          
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
                <h4 class="text-sm font-bold text-gray-800 truncate">
                  {{ conv.taiKhoan?.hoTen || conv.taiKhoan?.email || 'Khách hàng #' + conv.maCuocTroChuyen }}
                </h4>
                <span class="text-[10px] text-gray-400 font-medium tabular-nums">{{ formatTimeShort(conv.ngayCapNhat) }}</span>
              </div>
              <p class="text-xs text-gray-500 truncate" :class="{'text-gray-900 font-bold': (conv.trangThai === 'HUMAN' || conv.trangThai === 'PENDING') && selectedConv?.maCuocTroChuyen !== conv.maCuocTroChuyen}">
                {{ conv.lastMessage || (conv.taiKhoan ? 'Bắt đầu trò chuyện...' : 'Phiên khách #' + conv.maCuocTroChuyen) }}
              </p>
            </div>

          <div v-if="conv.trangThai === 'HUMAN' || conv.trangThai === 'PENDING'" class="absolute right-3 top-1/2 -translate-y-1/2 size-2 rounded-full bg-orange-500 shadow-sm animate-pulse"></div>
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
        <!-- Chat Header: Premium Glassmorphism -->
        <div class="h-20 px-8 border-b border-gray-100 flex items-center justify-between bg-white/90 backdrop-blur-xl sticky top-0 z-20 shadow-[0_1px_10px_rgba(0,0,0,0.02)]">
          <div class="flex items-center gap-5">
            <div class="size-11 rounded-2xl bg-slate-900 text-[#C8A97E] flex items-center justify-center font-black text-sm shadow-2xl border-2 border-white ring-1 ring-[#C8A97E]/20 overflow-hidden group">
               <img v-if="selectedConv.taiKhoan?.avatar" :src="selectedConv.taiKhoan.avatar" class="size-full object-cover group-hover:scale-110 transition-transform duration-500" />
               <span v-else>{{ getInitials(selectedConv.taiKhoan?.hoTen) }}</span>
            </div>
            <div class="flex flex-col">
              <div class="flex items-center gap-2">
                <h3 class="text-[15px] font-black text-slate-800 tracking-tight leading-none">
                  {{ selectedConv.taiKhoan?.hoTen || selectedConv.taiKhoan?.email || 'Khách vãng lai #' + selectedConv.maCuocTroChuyen }}
                </h3>
                <span v-if="selectedConv.taiKhoan" class="px-2 py-0.5 bg-slate-100 text-slate-500 rounded-lg text-[9px] font-black uppercase tracking-widest border border-slate-200">Customer</span>
                <span v-else class="px-2 py-0.5 bg-orange-100 text-orange-600 rounded-lg text-[9px] font-black uppercase tracking-widest border border-orange-200">Guest Session</span>
              </div>
              <div class="flex items-center gap-2 mt-1.5">
                <div v-if="selectedConv.trangThai === 'CLOSED'" class="px-2 py-0.5 rounded-full border bg-gray-50 border-gray-200 text-[9px] font-black text-gray-400 uppercase tracking-widest">
                  Đã kết thúc
                </div>
                <div v-else class="flex items-center gap-1.5 px-2 py-0.5 rounded-full border" 
                  :class="selectedConv.trangThai === 'HUMAN' || selectedConv.trangThai === 'PENDING' ? 'bg-orange-50 border-orange-100' : 'bg-blue-50 border-blue-100'">
                  <span class="size-1.5 rounded-full animate-pulse" :class="selectedConv.trangThai === 'HUMAN' || selectedConv.trangThai === 'PENDING' ? 'bg-orange-500' : 'bg-blue-500'"></span>
                  <span class="text-[9px] font-black uppercase tracking-widest" :class="selectedConv.trangThai === 'HUMAN' || selectedConv.trangThai === 'PENDING' ? 'text-orange-600' : 'text-blue-600'">
                    {{ selectedConv.trangThai === 'HUMAN' ? 'Nhân viên trực' : (selectedConv.trangThai === 'PENDING' ? 'Chờ hỗ trợ' : 'AI Assistant') }}
                  </span>
                </div>
                <span class="text-gray-300 text-[10px] opacity-50">|</span>
                <span class="text-[9px] font-bold text-gray-400 uppercase tracking-widest tabular-nums">{{ selectedConv.taiKhoan?.email || 'Phiên #' + selectedConv.maCuocTroChuyen }}</span>
              </div>
            </div>
          </div>
          <div class="flex items-center gap-3">
            <button @click="showRightPanel = !showRightPanel" 
               class="flex items-center gap-2 px-4 py-2 rounded-xl transition-all duration-300 group relative overflow-hidden" 
               :class="showRightPanel ? 'bg-slate-900 text-[#C8A97E] shadow-lg' : 'bg-gray-50 text-slate-500 hover:bg-gray-100 border border-gray-100'">
               <span class="material-symbols-outlined text-[18px] group-hover:scale-110 transition-transform">analytics</span>
               <span class="text-[10px] font-black uppercase tracking-widest">Hồ sơ khách</span>
            </button>
            <div class="w-px h-6 bg-gray-100 mx-1"></div>
            <button v-if="selectedConv.trangThai === 'PENDING'" @click="acceptConv" 
               class="flex items-center gap-2 px-5 py-2.5 bg-[#C8A97E] text-slate-900 hover:bg-slate-900 hover:text-[#C8A97E] rounded-xl text-[10px] font-black uppercase tracking-widest transition-all duration-300 shadow-lg border border-[#C8A97E] hover:shadow-[#C8A97E]/20 hover:-translate-y-0.5">
               <span class="material-symbols-outlined text-[18px]">handshake</span>
               Tiếp nhận ngay
            </button>
            <button v-if="selectedConv.trangThai !== 'CLOSED'" @click="closeConv" 
               class="flex items-center gap-2 px-5 py-2.5 bg-red-50 text-red-600 hover:bg-red-600 hover:text-white rounded-xl text-[10px] font-black uppercase tracking-widest transition-all duration-300 shadow-sm border border-red-100/50 hover:shadow-red-200 hover:-translate-y-0.5">
               <span class="material-symbols-outlined text-[18px]">done_all</span>
               Kết thúc
            </button>
          </div>
        </div>

        <!-- Messages Area -->
        <div class="flex-1 overflow-y-auto p-8 space-y-8 bg-gray-50/20 custom-scroll" ref="historyContainer">
          <div v-for="(msg, idx) in currentMessages" :key="idx" 
            class="flex flex-col group/msg" :class="msg.loaiNguoiGui === 'USER' ? 'items-start' : 'items-end'">
            
            <div v-if="isNewGroup(idx)" class="flex items-center gap-2 mb-3 px-1" :class="msg.loaiNguoiGui === 'USER' ? 'flex-row' : 'flex-row-reverse'">
              <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">
                {{ msg.loaiNguoiGui === 'USER' ? (selectedConv.taiKhoan?.hoTen || selectedConv.taiKhoan?.email || 'Khách vãng lai #' + selectedConv.maCuocTroChuyen) : (msg.loaiNguoiGui === 'AI' ? '🤖 AI Trợ lý' : '👩💼 Nhân viên tư vấn') }}
              </span>
              <div class="h-px w-6 bg-gray-100"></div>
            </div>

            <div class="max-w-[75%] group relative">
              <div class="px-6 py-4 rounded-3xl text-[13px] font-medium leading-relaxed shadow-sm transition-all duration-300 transform"
                :class="msg.loaiNguoiGui === 'USER' ? 
                  'bg-white text-gray-800 rounded-tl-none border border-gray-100 hover:shadow-md' : 
                  (msg.loaiNguoiGui === 'AI' ? 
                    'bg-slate-50 text-slate-800 rounded-tr-none border border-slate-200 italic' : 
                    'bg-slate-900 text-[#C8A97E] rounded-tr-none shadow-2xl shadow-slate-200 border border-slate-800 hover:shadow-[#C8A97E]/10')">
                  {{ msg.noiDung }}
              </div>
              <div class="flex items-center gap-2 mt-2" :class="msg.loaiNguoiGui === 'USER' ? 'justify-start' : 'justify-end'">
                <span class="text-[9px] font-bold text-gray-300 tabular-nums uppercase">{{ formatDate(msg.ngayGui) }}</span>
                <span v-if="msg.loaiNguoiGui !== 'USER'" class="material-symbols-outlined text-[12px] text-[#C8A97E]">done_all</span>
              </div>
            </div>
          </div>
          
          <!-- Loading State inside messages -->
          <div v-if="loadingHistory" class="flex flex-col items-center justify-center py-10 gap-3">
             <div class="size-6 border-2 border-[#C8A97E]/20 border-t-[#C8A97E] rounded-full animate-spin"></div>
             <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Đang tải lịch sử...</p>
          </div>
        </div>

        <!-- Input Area -->
        <div v-if="selectedConv.trangThai !== 'CLOSED'" class="p-6 bg-white border-t border-gray-100 shadow-[0_-10px_30px_-15px_rgba(0,0,0,0.05)] z-20">
          <div class="flex flex-wrap gap-2 mb-4">
             <button v-for="q in quickReplies" :key="q" @click="replyText = q" class="px-3.5 py-1.5 bg-gray-50 hover:bg-[#C8A97E] hover:text-white rounded-xl text-[10px] font-black uppercase tracking-widest text-gray-400 border border-gray-100 transition-all active:scale-95 shadow-sm">
                {{ q }}
             </button>
             <button @click="autoComplete" class="ml-auto flex items-center gap-1 px-3 py-1.5 bg-slate-900 text-[#C8A97E] rounded-xl text-[9px] font-black uppercase tracking-widest hover:scale-105 transition-all shadow-lg active:scale-95 border border-[#C8A97E]/30">
                <span class="material-symbols-outlined text-[14px]">auto_awesome</span>
                AI Gợi ý
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
                class="size-12 rounded-2xl flex items-center justify-center transition-all duration-500 shadow-xl bg-[#C8A97E] text-white shadow-[#C8A97E]/20 hover:shadow-[#C8A97E]/40 hover:-translate-y-1 active:scale-90 disabled:opacity-30">
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
           <div class="size-32 rounded-[48px] bg-white shadow-2xl flex items-center justify-center text-slate-100 border border-[#C8A97E]/10">
              <span class="material-symbols-outlined text-7xl">chat_bubble</span>
           </div>
           <div class="absolute -bottom-2 -right-2 size-10 rounded-2xl bg-[#C8A97E] text-white shadow-xl flex items-center justify-center animate-bounce border-2 border-white">
              <span class="material-symbols-outlined">support_agent</span>
           </div>
        </div>
         <h2 class="text-2xl font-serif font-bold text-slate-800 uppercase tracking-tight mb-2">Trung tâm điều hành Chat</h2>
        <p class="text-sm font-medium text-gray-400 max-w-sm mb-8 leading-relaxed">Chọn một cuộc hội thoại từ danh sách bên trái để bắt đầu hỗ trợ khách hàng theo tiêu chuẩn Luxury.</p>
        
        <div class="grid grid-cols-2 gap-6 w-full max-w-xl">
           <div class="bg-white p-6 rounded-[32px] shadow-[0_10px_40px_-15px_rgba(0,0,0,0.05)] border border-gray-100 text-left group hover:border-[#C8A97E]/30 transition-all duration-500 cursor-default relative overflow-hidden">
              <div class="absolute top-0 right-0 size-24 bg-orange-50/30 rounded-full translate-x-12 -translate-y-12"></div>
              <div class="size-10 rounded-2xl bg-orange-50 text-orange-600 flex items-center justify-center mb-4 group-hover:bg-orange-600 group-hover:text-white transition-all transform group-hover:rotate-12">
                 <span class="material-symbols-outlined text-[22px]">priority_high</span>
              </div>
              <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-1">Cần hỗ trợ</p>
              <div class="flex items-baseline gap-2">
                 <p class="text-2xl font-serif font-bold text-slate-800 tabular-nums">{{ stats.pending + stats.human }}</p>
                 <p class="text-xs font-bold text-gray-400">Khách chờ</p>
              </div>
           </div>
           
           <div class="bg-white p-6 rounded-[32px] shadow-[0_10px_40px_-15px_rgba(0,0,0,0.05)] border border-gray-100 text-left group hover:border-[#C8A97E]/30 transition-all duration-500 cursor-default relative overflow-hidden">
              <div class="absolute top-0 right-0 size-24 bg-blue-50/30 rounded-full translate-x-12 -translate-y-12"></div>
              <div class="size-10 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center mb-4 group-hover:bg-blue-600 group-hover:text-white transition-all transform group-hover:-rotate-12">
                 <span class="material-symbols-outlined text-[22px]">auto_awesome</span>
              </div>
              <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-1">AI Đang trực</p>
              <div class="flex items-baseline gap-2">
                 <p class="text-2xl font-serif font-bold text-slate-800 tabular-nums">{{ stats.ai }}</p>
                 <p class="text-xs font-bold text-gray-400">Đang chat</p>
              </div>
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
           <div class="size-24 rounded-[36px] bg-slate-800 text-[#C8A97E] flex items-center justify-center text-3xl font-black shadow-2xl mb-6 relative group overflow-hidden border-4 border-white ring-2 ring-[#C8A97E]/20">
              <img v-if="selectedConv.taiKhoan.avatar" :src="selectedConv.taiKhoan.avatar" class="size-full object-cover group-hover:scale-110 transition-transform duration-700" />
              <span v-else>{{ getInitials(selectedConv.taiKhoan.hoTen) }}</span>
           </div>
           <h3 class="text-lg font-black text-gray-800 mb-1 leading-tight">{{ selectedConv.taiKhoan.hoTen }}</h3>
            <span class="px-3 py-1 bg-[#C8A97E]/10 text-[#C8A97E] rounded-full text-[10px] font-black uppercase tracking-widest border border-[#C8A97E]/20">Luxury VIP Member</span>
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
          alert('Lỗi khi tiếp nhận cuộc trò chuyện');
       }
    },
    async closeConv() {
       if (!confirm('Bạn có chắc chắn muốn kết thúc cuộc hỗ trợ này?')) return;
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
