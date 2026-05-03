package com.example.projectend.controller;

import com.example.projectend.entity.PasswordResetToken;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.entity.VaiTro;
import com.example.projectend.repository.DiaChiRepository;
import com.example.projectend.entity.DiaChi;
import com.example.projectend.repository.PasswordResetTokenRepository;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.repository.VaiTroRepository;
import com.example.projectend.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Random;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "http://localhost:5173") // dev Vue
public class AuthController {

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @Autowired
    private VaiTroRepository vaiTroRepository;

    @Autowired
    private PasswordResetTokenRepository tokenRepository;

    @Autowired
    private EmailService emailService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private DiaChiRepository diaChiRepository;
    // ================= REGISTER API =================
    @PostMapping("/register")
    public ResponseEntity<?> registerApi(@RequestBody Map<String, String> body) {
        String hoTen = body.get("hoTen");
        String email = body.get("email");
        String matKhau = body.get("matKhau");
        String confirmPassword = body.get("confirmPassword");
        String soDienThoai = body.get("soDienThoai");
        String diaChi = body.get("diaChi");

        if (hoTen == null || hoTen.trim().isEmpty()) return ResponseEntity.badRequest().body("Họ tên không được để trống");
        if (email == null || email.trim().isEmpty()) return ResponseEntity.badRequest().body("Email không được để trống");
        if (matKhau == null || matKhau.length() < 6) return ResponseEntity.badRequest().body("Mật khẩu phải có ít nhất 6 ký tự");
        if (!matKhau.equals(confirmPassword)) return ResponseEntity.badRequest().body("Mật khẩu xác nhận không khớp");
        if (taiKhoanRepository.existsByEmail(email)) return ResponseEntity.badRequest().body("Email đã tồn tại");
        if (diaChi == null || diaChi.trim().isEmpty()) return ResponseEntity.badRequest().body("Địa chỉ không được để trống");
        try {
            VaiTro vaiTroUser = vaiTroRepository.findByTenVaiTro("KHACHHANG")
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy vai trò KHACHHANG"));

            TaiKhoan taiKhoanMoi = new TaiKhoan();
            taiKhoanMoi.setHoTen(hoTen.trim());
            taiKhoanMoi.setEmail(email.trim().toLowerCase());
            taiKhoanMoi.setMatKhau(passwordEncoder.encode(matKhau));
            taiKhoanMoi.setSoDienThoai(soDienThoai);
            taiKhoanMoi.addVaiTro(vaiTroUser);
            taiKhoanMoi.setTrangThai(true);
            taiKhoanMoi.setNgayTao(LocalDateTime.now());
            taiKhoanMoi.setDiaChi(diaChi.trim());

            TaiKhoan savedUser = taiKhoanRepository.save(taiKhoanMoi);

            DiaChi address = new DiaChi();
            address.setTaiKhoan(savedUser);
            address.setHoTenNguoiNhan(savedUser.getHoTen());
            address.setSoDienThoai(savedUser.getSoDienThoai());
            address.setDiaChiChiTiet(savedUser.getDiaChi());

            diaChiRepository.save(address);

            return ResponseEntity.ok("Đăng ký thành công");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Có lỗi xảy ra khi đăng ký: " + e.getMessage());
        }
    }

    // ================= FORGOT PASSWORD =================
    @PostMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(@RequestBody Map<String, String> body) {
        String email = body.get("email");
        if (email == null || email.isEmpty()) return ResponseEntity.badRequest().body("Email không hợp lệ");

        TaiKhoan tk = taiKhoanRepository.findByEmail(email).orElse(null);
        if (tk == null) return ResponseEntity.badRequest().body("Email không tồn tại");

        String otp = String.valueOf(new Random().nextInt(900000) + 100000);

        PasswordResetToken token = new PasswordResetToken();
        token.setEmail(email);
        token.setOtp(otp);
        token.setExpiry(LocalDateTime.now().plusMinutes(5));
        token.setTrangThai(true);
        tokenRepository.save(token);

        emailService.sendOtpEmail(email, otp);

        return ResponseEntity.ok("OTP đã được gửi (check email console)");
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<?> verifyOtp(@RequestBody Map<String, String> body) {
        String email = body.get("email");
        String otp = body.get("otp");

        PasswordResetToken token = tokenRepository
                .findTopByEmailAndOtpAndTrangThaiTrueOrderByNgayTaoDesc(email, otp)
                .orElse(null);

        if (token == null) return ResponseEntity.badRequest().body("OTP không đúng");
        if (token.getExpiry().isBefore(LocalDateTime.now())) return ResponseEntity.badRequest().body("OTP đã hết hạn");

        return ResponseEntity.ok("OTP hợp lệ");
    }

    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody Map<String, String> body) {
        String email = body.get("email");
        String otp = body.get("otp");
        String newPassword = body.get("newPassword");

        PasswordResetToken token = tokenRepository
                .findTopByEmailAndOtpAndTrangThaiTrueOrderByNgayTaoDesc(email, otp)
                .orElse(null);

        if (token == null) return ResponseEntity.badRequest().body("OTP không hợp lệ");
        if (token.getExpiry().isBefore(LocalDateTime.now())) return ResponseEntity.badRequest().body("OTP đã hết hạn");

        TaiKhoan tk = taiKhoanRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản"));

        tk.setMatKhau(passwordEncoder.encode(newPassword));
        taiKhoanRepository.save(tk);

        token.setTrangThai(false);
        tokenRepository.save(token);

        return ResponseEntity.ok("Đổi mật khẩu thành công");
    }
}