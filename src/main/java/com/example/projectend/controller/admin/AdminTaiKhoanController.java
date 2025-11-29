package com.example.projectend.controller.admin;

import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.entity.VaiTro;
import com.example.projectend.repository.VaiTroRepository;
import com.example.projectend.service.TaiKhoanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;

@Controller
@RequestMapping("/admin/customers") // Đã khớp với Sidebar
@PreAuthorize("hasRole('ADMIN')")
public class AdminTaiKhoanController { // Tên class khớp với tên file

    @Autowired
    private TaiKhoanService taiKhoanService;

    @Autowired
    private VaiTroRepository vaiTroRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // ==========================================
    // 1. HIỂN THỊ DANH SÁCH
    // ==========================================
    @GetMapping
    public String listCustomers(Model model, 
                                @RequestParam(required = false) String keyword) {
        
        List<TaiKhoan> list;
        
        if (keyword != null && !keyword.isEmpty()) {
            // Tạm thời dùng findAll, bạn có thể thay bằng taiKhoanService.search(keyword) sau
            list = taiKhoanService.findAll(); 
        } else {
            list = taiKhoanService.findAll();
        }

        List<VaiTro> vaiTros = vaiTroRepository.findAll();

        // Tên attribute "customers" khớp với th:each="kh : ${customers}" trong HTML
        model.addAttribute("customers", list); 
        model.addAttribute("vaiTros", vaiTros);
        
        // Active menu bên trái
        model.addAttribute("currentPage", "customers"); 
        model.addAttribute("keyword", keyword);

        // Trả về file HTML: src/main/resources/templates/admin/customer-list.html
        return "admin/customer-list"; 
    }

    // ==========================================
    // 2. LƯU TÀI KHOẢN
    // ==========================================
    @PostMapping("/save")
    public String saveAccount(@ModelAttribute TaiKhoan account,
                              @RequestParam(required = false) String matKhauMoi,
                              @RequestParam(required = false) Long vaiTroId,
                              RedirectAttributes ra) {
        try {
            // --- THÊM MỚI ---
            if (account.getMaTK() == null) {
                account.setNgayTao(LocalDateTime.now());
                account.setTrangThai(true);
                
                String rawPass = (matKhauMoi != null && !matKhauMoi.isEmpty()) ? matKhauMoi : "123456";
                account.setMatKhau(passwordEncoder.encode(rawPass));
            } 
            // --- CẬP NHẬT ---
            else {
                TaiKhoan oldAccount = taiKhoanService.findById(account.getMaTK()).orElse(null);
                if (oldAccount != null) {
                    account.setNgayTao(oldAccount.getNgayTao());
                    account.setTrangThai(oldAccount.getTrangThai());
                    
                    if (matKhauMoi != null && !matKhauMoi.isEmpty()) {
                        account.setMatKhau(passwordEncoder.encode(matKhauMoi));
                    } else {
                        account.setMatKhau(oldAccount.getMatKhau());
                    }
                    // Giữ roles cũ tạm thời trước khi set role mới bên dưới
                    account.setRoles(oldAccount.getRoles());
                }
            }
            
            // --- CẬP NHẬT ROLE ---
            if (vaiTroId != null) {
                VaiTro vaiTro = vaiTroRepository.findById(vaiTroId).orElse(null);
                if (vaiTro != null) {
                    if (account.getRoles() == null) {
                        account.setRoles(new HashSet<>());
                    }
                    account.getRoles().clear();
                    account.getRoles().add(vaiTro);
                }
            }

            account.setNgayCapNhat(LocalDateTime.now());
            taiKhoanService.save(account);
            
            ra.addFlashAttribute("success", "Lưu thông tin thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            ra.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        // Redirect về trang danh sách
        return "redirect:/admin/customers"; 
    }

    // ==========================================
    // 3. KHÓA / MỞ KHÓA
    // ==========================================
    @PostMapping("/{id}/toggle-status")
    public String toggleStatus(@PathVariable Long id, RedirectAttributes ra) {
        try {
            TaiKhoan account = taiKhoanService.findById(id).orElse(null);
            if (account != null) {
                boolean newStatus = !account.getTrangThai(); // Đảo ngược trạng thái
                account.setTrangThai(newStatus);
                taiKhoanService.save(account);
                
                ra.addFlashAttribute("success", newStatus ? "Đã mở khóa tài khoản!" : "Đã khóa tài khoản!");
            }
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/customers";
    }

    // ==========================================
    // 4. XÓA TÀI KHOẢN
    // ==========================================
    @PostMapping("/delete/{id}")
    public String deleteAccount(@PathVariable Long id, RedirectAttributes ra) {
        try {
            taiKhoanService.deleteById(id);
            ra.addFlashAttribute("success", "Xóa tài khoản thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Không thể xóa (Tài khoản đã có dữ liệu liên quan).");
        }
        return "redirect:/admin/customers";
    }
}