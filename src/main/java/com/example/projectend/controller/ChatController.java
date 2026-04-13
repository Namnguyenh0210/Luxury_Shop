package com.example.projectend.controller;

import com.example.projectend.entity.CuocTroChuyen;
import com.example.projectend.entity.TinNhan;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.CuocTroChuyenRepository;
import com.example.projectend.service.ChatService;
import com.example.projectend.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/chat")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class ChatController {

    @Autowired
    private AuthService authService;

    @Autowired
    private ChatService chatService;

    @Autowired
    private CuocTroChuyenRepository cuocTroChuyenRepository;

    private TaiKhoan getCurrentUser(HttpSession session) {
        // First try to get from AuthService (Spring Security Context)
        TaiKhoan user = authService.getCurrentUser();
        if (user != null)
            return user;

        // Fallback to session attribute (if any)
        return (TaiKhoan) session.getAttribute("user");
    }

    /**
     * Lấy CuocTroChuyen hiện tại của session (hoặc tạo mới nếu chưa có)
     */
    @GetMapping("/my-conversation")
    public ResponseEntity<?> getMyConversation(HttpSession session) {
        TaiKhoan user = getCurrentUser(session);
        CuocTroChuyen conv;

        if (user != null) {
            // Nếu đã đăng nhập, luôn ưu tiên lấy hội thoại từ DB cho user đó
            conv = chatService.getOrCreateConversation(user);
            session.setAttribute("current_conversation_id", conv.getMaCuocTroChuyen());
        } else {
            // Nếu là khách, sử dụng session để định danh
            Long conversationId = (Long) session.getAttribute("current_conversation_id");
            if (conversationId != null) {
                conv = cuocTroChuyenRepository.findById(conversationId).orElse(null);

                // Nếu không tìm thấy hoặc đã đóng, tạo mới
                if (conv == null || "CLOSED".equals(conv.getTrangThai())) {
                    conv = createAndSaveSessionConv(session, null);
                }
            } else {
                conv = createAndSaveSessionConv(session, null);
            }
        }

        return ResponseEntity.ok(conv);
    }

    private CuocTroChuyen createAndSaveSessionConv(HttpSession session, TaiKhoan user) {
        CuocTroChuyen conv = chatService.getOrCreateConversation(user);
        session.setAttribute("current_conversation_id", conv.getMaCuocTroChuyen());
        return conv;
    }

    /**
     * Lấy danh sách tin nhắn của 1 hội thoại
     */
    @GetMapping("/history/{conversationId}")
    public ResponseEntity<?> getHistory(@PathVariable Long conversationId) {
        List<TinNhan> messages = chatService.getMessages(conversationId);
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
        Long sessionConvId = (Long) session.getAttribute("current_conversation_id");

        CuocTroChuyen conv;
        if (user != null) {
            // Nếu đã đăng nhập, ưu tiên lấy hội thoại của User
            conv = chatService.getOrCreateConversation(user);
        } else if (sessionConvId != null) {
            // Nếu chưa đăng nhập, lấy từ session
            conv = cuocTroChuyenRepository.findById(sessionConvId)
                    .orElseGet(() -> createAndSaveSessionConv(session, null));
        } else {
            // Tạo mới hoàn toàn
            conv = createAndSaveSessionConv(session, null);
        }

        // Cập nhật lại session ID đề phòng trường hợp vừa login
        session.setAttribute("current_conversation_id", conv.getMaCuocTroChuyen());

        TinNhan aiResponse = chatService.processUserMessage(conv, msgContent);

        Map<String, Object> response = new HashMap<>();
        response.put("conversationId", conv.getMaCuocTroChuyen());
        response.put("reply", aiResponse);
        response.put("status", conv.getTrangThai());

        return ResponseEntity.ok(response);
    }

    @PostMapping("/switch-human")
    public ResponseEntity<?> switchToHuman(@RequestBody Map<String, Long> payload) {
        Long conversationId = payload.get("conversationId");
        if (conversationId != null) {
            chatService.switchToHuman(conversationId);
            return ResponseEntity.ok("Đã chuyển trạng thái sang HUMAN");
        }
        return ResponseEntity.badRequest().body("Thiếu conversationId");
    }

    @PostMapping("/reset")
    public ResponseEntity<?> resetChat(HttpSession session) {
        Long conversationId = (Long) session.getAttribute("current_conversation_id");
        if (conversationId != null) {
            chatService.updateStatus(conversationId, "CLOSED");
            session.removeAttribute("current_conversation_id");
            return ResponseEntity.ok("Hội thoại đã được đặt lại");
        }
        return ResponseEntity.ok("Không có hội thoại cần đặt lại");
    }

    // ===================================
    // API DÀNH CHO ADMIN / NHANVIEN
    // ===================================

    @GetMapping("/admin/all")
    public ResponseEntity<?> getAllConversations(HttpSession session) {
        if (!authService.isAdmin() && !authService.isStaff()) {
            return ResponseEntity.status(403).body("Không có quyền truy cập");
        }

        List<CuocTroChuyen> convs = chatService.getAllConversations();
        return ResponseEntity.ok(convs);
    }

    @PostMapping("/admin/reply")
    public ResponseEntity<?> adminReply(@RequestBody Map<String, String> payload, HttpSession session) {
        if (!authService.isAdmin() && !authService.isStaff()) {
            return ResponseEntity.status(403).body("Không có quyền truy cập");
        }

        Long conversationId = Long.parseLong(payload.get("conversationId"));
        String content = payload.get("content");
        TaiKhoan staff = getCurrentUser(session);

        TinNhan reply = chatService.staffReply(conversationId, content, staff);
        return ResponseEntity.ok(reply);
    }

    @PostMapping("/admin/status")
    public ResponseEntity<?> updateStatus(@RequestBody Map<String, String> payload, HttpSession session) {
        if (!authService.isAdmin() && !authService.isStaff()) {
            return ResponseEntity.status(403).body("Không có quyền truy cập");
        }

        Long conversationId = Long.parseLong(payload.get("conversationId"));
        String status = payload.get("status");

        chatService.updateStatus(conversationId, status);
        return ResponseEntity.ok("Cập nhật trạng thái thành công");
    }

    @PostMapping("/admin/accept")
    public ResponseEntity<?> acceptConversation(@RequestBody Map<String, Long> payload, HttpSession session) {
        if (!authService.isAdmin() && !authService.isStaff()) {
            return ResponseEntity.status(403).body("Không có quyền truy cập");
        }

        Long conversationId = payload.get("conversationId");
        TaiKhoan staff = getCurrentUser(session);

        chatService.updateStatusWithStaff(conversationId, "HUMAN", staff);
        return ResponseEntity.ok("Đã tiếp nhận cuộc trò chuyện");
    }

}
