package com.example.projectend.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * LienHeController — GET redirect về Vue SPA.
 * POST /lienhe/gui xử lý form và trả JSON (Vue gọi qua axios).
 */
@Controller
public class LienHeController {

    @GetMapping("/lienhe")
    public String lienHe() {
        return "redirect:http://localhost:5173/lienhe";
    }

    /**
     * POST /lienhe/gui — Vue gửi form qua axios, trả về JSON.
     * (Nếu muốn gửi email thật thì inject EmailService ở đây)
     */
    @PostMapping("/lienhe/gui")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> guiLienHe(
            @RequestParam(required = false) String hoTen,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String tieuDe,
            @RequestParam(required = false) String noiDung) {

        // Log thông tin (có thể gửi email ở đây)
        System.out.println("=== LIÊN HỆ MỚI ===");
        System.out.println("Họ tên : " + hoTen);
        System.out.println("Email  : " + email);
        System.out.println("Tiêu đề: " + tieuDe);
        System.out.println("Nội dung: " + noiDung);

        return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi trong vòng 24 giờ."));
    }
}
