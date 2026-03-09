package com.example.projectend.service;

import com.example.projectend.entity.Conversation;
import com.example.projectend.entity.DonHang;
import com.example.projectend.entity.Message;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.ConversationRepository;
import com.example.projectend.repository.DonHangRepository;
import com.example.projectend.repository.MessageRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class ChatService {

    private static final Logger logger = LoggerFactory.getLogger(ChatService.class);

    @Autowired
    private ConversationRepository conversationRepository;

    @Autowired
    private MessageRepository messageRepository;

    @Autowired
    private GroqService groqService;

    @Autowired
    private SanPhamService sanPhamService;

    @Autowired
    private DonHangService donHangService; // Import để query đơn hàng nếu cần thiết (hoặc DonHangRepository)

    /**
     * Lấy cuộc hội thoại hiện tại hoặc tạo mới nếu chưa có/đã đóng
     */
    @Transactional
    public Conversation getOrCreateConversation(TaiKhoan user) {
        if (user != null) {
            Optional<Conversation> existConvObj = conversationRepository
                    .findFirstByTaiKhoanOrderByNgayCapNhatDesc(user);
            if (existConvObj.isPresent()) {
                Conversation existConv = existConvObj.get();
                if (!"CLOSED".equals(existConv.getTrangThai())) {
                    return existConv; // Trả về cuộc trò chuyện đang mở
                }
            }
        }
        // Tạo cuộc trò chuyện mới
        Conversation newConv = new Conversation();
        newConv.setTaiKhoan(user);
        newConv.setTrangThai("AI");
        newConv.setNgayTao(LocalDateTime.now());
        newConv.setNgayCapNhat(LocalDateTime.now());
        return conversationRepository.save(newConv);
    }

    /**
     * Lấy tất cả messages của một cuộc hội thoại
     */
    public List<Message> getMessages(Long conversationId) {
        Conversation conv = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy hội thoại"));
        return messageRepository.findByConversationOrderByNgayGuiAsc(conv);
    }

    /**
     * Gửi tin nhắn từ người dùng, gọi Gemini nếu đang là trạng thái 'AI'
     */
    @Transactional
    public Message processUserMessage(Conversation conversation, String messageContent) {
        // Lưu tin nhắn của USER
        Message userMessage = new Message(conversation, "USER", messageContent);
        messageRepository.save(userMessage);

        conversation.setNgayCapNhat(LocalDateTime.now());
        conversationRepository.save(conversation);

        // Nếu trạng thái đang là AI -> phân tích và gọi Gemini
        if ("AI".equals(conversation.getTrangThai())) {
            String context = buildContextForAI(conversation.getTaiKhoan(), messageContent);

            // Gọi AI
            String aiReplyStr = groqService.generateResponse(messageContent, context);

            // Lưu tin nhắn của AI
            Message aiMessage = new Message(conversation, "AI", aiReplyStr);
            messageRepository.save(aiMessage);
            return aiMessage;
        }

        // Đang chat với HUMAN (staff) -> Không gọi AI, chờ staff reply
        return null;
    }

    private String buildContextForAI(TaiKhoan tk, String userMessage) {
        String msgLower = userMessage.toLowerCase();

        // Nhận diện ý định (Intent Detection)
        if (msgLower.contains("đơn hàng") || msgLower.contains("giao hàng chưa") || msgLower.contains("đơn của")
                || msgLower.contains("mua lúc")) {
            // Lấy thông tin đơn hàng nếu user đã login
            if (tk != null) {
                try {
                    List<DonHang> userOrders = donHangService.getDonHangByKhachHang(tk);
                    if (userOrders != null && !userOrders.isEmpty()) {
                        // Lấy 3 đơn hàng gần nhất
                        return groqService.buildOrderContext(userOrders.subList(0, Math.min(3, userOrders.size())));
                    } else {
                        return "KHÁCH HÀNG CHƯA CÓ ĐƠN HÀNG NÀO TRONG HỆ THỐNG.";
                    }
                } catch (Exception e) {
                    logger.error("Lỗi khi lấy đơn hàng của user cho AI", e);
                }
            }
            return "Hãy thông báo với khách rằng họ cần phải đăng nhập để tôi (AI) có thể kiểm tra trực tiếp đơn hàng của họ, hoặc họ có thể cung cấp mã đơn hàng để nhân viên kiểm tra.";
        }

        if (msgLower.contains("đổi trả") || msgLower.contains("chính sách") || msgLower.contains("tư vấn size")) {
            // Trả về context FAQs chung (Gemini system prompt đã có)
            return "";
        }

        // Tự động tìm kiếm sản phẩm theo từ khóa (dựa vào regex hoặc keyword extraction
        // đơn giản)
        // Lấy keyword đơn giản (loại bỏ mấy từ thừa)
        String keyword = extractKeyword(msgLower);
        if (!keyword.isBlank()) {
            try {
                var products = sanPhamService.searchByKeyword(keyword, 5);
                if (products != null && !products.isEmpty()) {
                    return groqService.buildProductContext(products);
                }
            } catch (Exception e) {
                logger.error("Lỗi khi search sản phẩm cho AI context", e);
            }
        }

        return "Bạn hãy cố gắng gợi ý vài sản phẩm nổi bật của cửa hàng nếu bạn thấy hợp lý.";
    }

    private String extractKeyword(String query) {
        // Một cách rút gọn keyword để gửi vào search (cho demo)
        String kw = query.replace("có áo", "").replace("cái nào", "")
                .replace("tiền", "").replace("giá", "")
                .replace("shop", "").replace("shop ơi", "").replace("tư vấn", "")
                .replace("không", "").replace("còn", "").replace("bao nhiêu", "").trim();
        return kw;
    }

    /**
     * Người dùng yêu cầu chuyển sang chat với nhân viên
     */
    @Transactional
    public void switchToHuman(Long conversationId) {
        Conversation conv = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy hội thoại"));
        conv.setTrangThai("HUMAN");
        conv.setNgayCapNhat(LocalDateTime.now());
        conversationRepository.save(conv);
    }

    /**
     * Nhân viên gửi tin nhắn
     */
    @Transactional
    public Message staffReply(Long conversationId, String content) {
        Conversation conv = conversationRepository.findById(conversationId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy hội thoại"));

        Message msg = new Message(conv, "STAFF", content);
        conv.setNgayCapNhat(LocalDateTime.now());

        messageRepository.save(msg);
        conversationRepository.save(conv);
        return msg;
    }

    /**
     * Admin/Staff lấy tất cả các cuộc hội thoại
     */
    public List<Conversation> getAllConversations() {
        return conversationRepository.findAllByOrderByNgayCapNhatDesc();
    }
}
