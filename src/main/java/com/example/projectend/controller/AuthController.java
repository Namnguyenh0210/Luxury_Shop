package com.example.projectend.controller;

import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.entity.VaiTro;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.repository.VaiTroRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpServletRequest;

import java.time.LocalDateTime;

/**
 * Controller xử lý đăng nhập và đăng ký tài khoản
 */
@Controller
public class AuthController extends BaseController {

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @Autowired
    private VaiTroRepository vaiTroRepository;

    /**
     * GET /login — Redirect về Vue SPA
     * (SPA Vue tự xử lý route /login via Vue Router)
     */
    @GetMapping("/login")
    public String loginPage(
            @RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "logout", required = false) String logout,
            HttpServletRequest request) {
        // Detect Vite dev server (port 5173) vs production
        String origin = request.getHeader("Origin");
        String referer = request.getHeader("Referer");
        boolean isDevMode = (origin != null && origin.contains("5173"))
                || (referer != null && referer.contains("5173"));

        String suffix = "";
        if (error != null)
            suffix = "?error=true";
        else if (logout != null)
            suffix = "?logout=success";

        if (isDevMode) {
            return "redirect:http://localhost:5173/login" + suffix;
        }
        // Production: Vue SPA served from Spring Boot, forward to SPA index
        return "redirect:/login" + suffix;
    }

    /**
     * GET /register — Redirect về Vue SPA
     */
    @GetMapping("/register")
    public String registerPage(HttpServletRequest request) {
        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("5173")) {
            return "redirect:http://localhost:5173/register";
        }
        return "redirect:/register";
    }

    /**
     * Xử lý đăng ký tài khoản mới
     */
    @PostMapping("/register")
    public String registerSubmit(@RequestParam String hoTen,
            @RequestParam String email,
            @RequestParam String matKhau,
            @RequestParam String confirmPassword,
            @RequestParam(required = false) String soDienThoai,
            RedirectAttributes redirectAttributes) {

        // Kiểm tra họ tên
        if (hoTen == null || hoTen.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Họ tên không được để trống!");
            return "redirect:/register";
        }

        // Kiểm tra email
        if (email == null || email.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Email không được để trống!");
            return "redirect:/register";
        }

        // Kiểm tra mật khẩu
        if (matKhau == null || matKhau.length() < 6) {
            redirectAttributes.addFlashAttribute("errorMessage", "Mật khẩu phải có ít nhất 6 ký tự!");
            return "redirect:/register";
        }

        // Kiểm tra xác nhận mật khẩu
        if (!matKhau.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
            return "redirect:/register";
        }

        // Kiểm tra email đã tồn tại
        if (taiKhoanRepository.existsByEmail(email)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Email đã tồn tại trong hệ thống!");
            return "redirect:/register";
        }

        try {
            // Lấy vai trò khách hàng (KHACHHANG trong database - khớp với db.sql)
            VaiTro vaiTroUser = vaiTroRepository.findByTenVaiTro("KHACHHANG")
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy vai trò KHACHHANG"));

            // Tạo tài khoản mới
            TaiKhoan taiKhoanMoi = new TaiKhoan();
            taiKhoanMoi.setHoTen(hoTen.trim());
            taiKhoanMoi.setEmail(email.trim().toLowerCase());
            taiKhoanMoi.setMatKhau(matKhau); // Plain text password (NoOpPasswordEncoder)
            taiKhoanMoi.setSoDienThoai(soDienThoai);
            // Thêm vai trò vào Set (Many-to-Many)
            taiKhoanMoi.addVaiTro(vaiTroUser);
            taiKhoanMoi.setTrangThai(true);
            taiKhoanMoi.setNgayTao(LocalDateTime.now());

            // Lưu vào database
            taiKhoanRepository.save(taiKhoanMoi);

            redirectAttributes.addFlashAttribute("successMessage",
                    "Đăng ký thành công! Bạn có thể đăng nhập ngay bây giờ.");
            return "redirect:/login";

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Có lỗi xảy ra khi đăng ký: " + e.getMessage());
            return "redirect:/register";
        }
    }

    /**
     * GET /403 — Redirect về Vue SPA error page
     */
    @GetMapping("/403")
    public String accessDenied(HttpServletRequest request) {
        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("5173")) {
            return "redirect:http://localhost:5173/403";
        }
        return "redirect:/403";
    }
}
