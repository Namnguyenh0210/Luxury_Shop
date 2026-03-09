package com.example.projectend.controller;

import com.example.projectend.entity.Conversation;
import com.example.projectend.entity.Message;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.ConversationRepository;
import com.example.projectend.service.ChatService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/chat")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class ChatController {

    @Autowired
    private ChatService chatService;

    @Autowired
    private ConversationRepository conversationRepository;

    private TaiKhoan getCurrentUser(HttpSession session) {
        return (TaiKhoan) session.getAttribute("user");
    }

    /**
     * Lấy Conversation hiện tại của session (hoặc tạo mới nếu chưa có)
     */
    @GetMapping("/my-conversation")
    public ResponseEntity<?> getMyConversation(HttpSession session) {
        TaiKhoan user = getCurrentUser(session);

        // Cần lưu ID hội thoại vào session cho người dùng ẩn danh (chưa đăng nhập)
        Long conversationId = (Long) session.getAttribute("current_conversation_id");
        Conversation conv;

        if (conversationId != null) {
            conv = conversationRepository.findById(conversationId)
                    .orElseGet(() -> createAndSaveSessionConv(session, user));
        } else {
            conv = createAndSaveSessionConv(session, user);
        }

        // Nếu đã đăng nhập, liên kết hội thoại với user nếu nó đang là NULL
        if (user != null && conv.getTaiKhoan() == null) {
            conv.setTaiKhoan(user);
            conversationRepository.save(conv);
        }

        return ResponseEntity.ok(conv);
    }

    private Conversation createAndSaveSessionConv(HttpSession session, TaiKhoan user) {
        Conversation conv = chatService.getOrCreateConversation(user);
        session.setAttribute("current_conversation_id", conv.getMaCuocTroChuyen());
        return conv;
    }

    /**
     * Lấy danh sách tin nhắn của 1 hội thoại
     */
    @GetMapping("/history/{conversationId}")
    public ResponseEntity<?> getHistory(@PathVariable Long conversationId) {
        List<Message> messages = chatService.getMessages(conversationId);
        return ResponseEntity.ok(messages);
    }

    /**
     * Gửi tin nhắn từ người dùng
     */
    @PostMapping("/send")
    public ResponseEntity<?> sendMessage(@RequestBody Map<String, String> payload, HttpSession session) {
        String msgContent = payload.get("content");
        if (msgContent == null || msgContent.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Tin nhắn không hợp lệ");
        }

        TaiKhoan user = getCurrentUser(session);
        Long conversationId = (Long) session.getAttribute("current_conversation_id");

        Conversation conv;
        if (conversationId != null) {
            conv = conversationRepository.findById(conversationId)
                    .orElseGet(() -> createAndSaveSessionConv(session, user));
        } else {
            conv = createAndSaveSessionConv(session, user);
        }

        Message aiResponse = chatService.processUserMessage(conv, msgContent);

        Map<String, Object> response = new HashMap<>();
        response.put("conversationId", conv.getMaCuocTroChuyen());
        response.put("reply", aiResponse); // Có thể null nếu trạng thái là HUMAN
        response.put("status", conv.getTrangThai());

        return ResponseEntity.ok(response);
    }

    /**
     * Khách hàng yêu cầu chuyển sang nhân viên
     */
    @PostMapping("/switch-human")
    public ResponseEntity<?> switchToHuman(@RequestBody Map<String, Long> payload) {
        Long conversationId = payload.get("conversationId");
        if (conversationId != null) {
            chatService.switchToHuman(conversationId);
            return ResponseEntity.ok("Đã chuyển trạng thái sang HUMAN");
        }
        return ResponseEntity.badRequest().body("Thiếu conversationId");
    }

    // ===================================
    // API DÀNH CHO ADMIN / NHANVIEN
    // ===================================

    @GetMapping("/admin/all")
    public ResponseEntity<?> getAllConversations(HttpSession session) {
        TaiKhoan nv = getCurrentUser(session);
        if (nv == null || !hasRoles(nv, "ADMIN", "NHANVIEN")) {
            return ResponseEntity.status(403).body("Không có quyền truy cập");
        }

        List<Conversation> convs = chatService.getAllConversations();
        return ResponseEntity.ok(convs);
    }

    @PostMapping("/admin/reply")
    public ResponseEntity<?> adminReply(@RequestBody Map<String, String> payload, HttpSession session) {
        TaiKhoan nv = getCurrentUser(session);
        if (nv == null || !hasRoles(nv, "ADMIN", "NHANVIEN")) {
            return ResponseEntity.status(403).body("Không có quyền truy cập");
        }

        Long conversationId = Long.parseLong(payload.get("conversationId"));
        String content = payload.get("content");

        Message reply = chatService.staffReply(conversationId, content);
        return ResponseEntity.ok(reply);
    }

    private boolean hasRoles(TaiKhoan user, String... rolesAllowed) {
        if (user == null || user.getRoles() == null)
            return false;
        return user.getRoles().stream()
                .anyMatch(r -> {
                    for (String allowed : rolesAllowed) {
                        if (r.getTenRole().equals("ROLE_" + allowed))
                            return true;
                    }
                    return false;
                });
    }
}
