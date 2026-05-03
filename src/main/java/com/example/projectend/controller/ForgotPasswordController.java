package com.example.projectend.controller;

import com.example.projectend.entity.PasswordResetToken;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.PasswordResetTokenRepository;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Random;

@RestController
@RequestMapping("/api/password") // đổi prefix tránh trùng với /api/auth
@CrossOrigin(origins = "http://localhost:5173")
public class ForgotPasswordController {

    @Autowired
    private PasswordResetTokenRepository tokenRepository;

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private EmailService emailService; // gửi email thật thông qua app password

    // Gửi OTP
    @PostMapping("/forgot")
    public ResponseEntity<?> forgotPassword(@RequestBody Map<String, String> body) {
        String email = body.get("email");
        if (email == null || email.isBlank()) {
            return ResponseEntity.badRequest().body(Map.of("error", "Email không được để trống"));
        }

        TaiKhoan tk = taiKhoanRepository.findByEmail(email).orElse(null);
        if (tk == null) {
            return ResponseEntity.badRequest().body(Map.of("error", "Email không tồn tại"));
        }

        String otp = String.valueOf(new Random().nextInt(900000) + 100000); //tạo otp random gồm 6 chữ số

        PasswordResetToken token = new PasswordResetToken();
        token.setEmail(email);
        token.setOtp(otp);
        token.setExpiry(LocalDateTime.now().plusMinutes(5)); //thời gian thiết lập
        token.setTrangThai(true);

        tokenRepository.save(token);

        // gửi mail
        emailService.sendOtpEmail(email, otp);

        return ResponseEntity.ok(Map.of("message", "OTP đã được gửi tới email"));
    }

    // Xác thực OTP
    @PostMapping("/verify")
    public ResponseEntity<?> verifyOtp(@RequestBody Map<String, String> body) {
        String email = body.get("email");
        String otp = body.get("otp");

        if (email == null || otp == null) {
            return ResponseEntity.badRequest().body(Map.of("error", "Email hoặc OTP không hợp lệ"));
        }

        PasswordResetToken token = tokenRepository
                .findTopByEmailAndOtpAndTrangThaiTrueOrderByNgayTaoDesc(email, otp)
                .orElse(null);

        if (token == null) {
            return ResponseEntity.badRequest().body(Map.of("error", "OTP không đúng hoặc đã sử dụng"));
        }

        if (token.getExpiry().isBefore(LocalDateTime.now())) {
            return ResponseEntity.badRequest().body(Map.of("error", "OTP đã hết hạn"));
        }

        return ResponseEntity.ok(Map.of("message", "OTP hợp lệ"));
    }

    // Reset password
    @PostMapping("/reset")
    public ResponseEntity<?> resetPassword(@RequestBody Map<String, String> body) {
        String email = body.get("email");
        String otp = body.get("otp");
        String newPassword = body.get("newPassword");

        if (email == null || otp == null || newPassword == null || newPassword.length() < 6) {
            return ResponseEntity.badRequest().body(Map.of("error", "Dữ liệu không hợp lệ hoặc mật khẩu quá ngắn"));
        }

        PasswordResetToken token = tokenRepository
                .findTopByEmailAndOtpAndTrangThaiTrueOrderByNgayTaoDesc(email, otp)
                .orElse(null);

        if (token == null || token.getExpiry().isBefore(LocalDateTime.now())) {
            return ResponseEntity.badRequest().body(Map.of("error", "OTP không hợp lệ hoặc đã hết hạn"));
        }

        TaiKhoan tk = taiKhoanRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản"));

        tk.setMatKhau(passwordEncoder.encode(newPassword));
        taiKhoanRepository.save(tk);

        token.setTrangThai(false); // disable OTP
        tokenRepository.save(token);

        return ResponseEntity.ok(Map.of("message", "Đổi mật khẩu thành công"));
    }
}