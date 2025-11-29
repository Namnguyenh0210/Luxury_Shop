package com.example.projectend.controller;

import com.example.projectend.repository.DonHangRepository;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.service.SanPhamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.math.BigDecimal;

@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN') or hasRole('NHANVIEN')") // Đảm bảo khớp với Role trong DB (thường là viết hoa)
public class DashboardController {

    @Autowired
    private SanPhamService sanPhamService;

    @Autowired
    private DonHangRepository donHangRepository;

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    /**
     * 1. Xử lý khi truy cập vào /admin
     * Tự động chuyển hướng dựa trên vai trò
     */
    @GetMapping("")
    public String index() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        // Kiểm tra nếu là ADMIN -> Vào Dashboard thống kê
        boolean isAdmin = auth.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .anyMatch(role -> role.equals("ROLE_ADMIN") || role.equals("ROLE_Admin")); // Check cả 2 trường hợp cho chắc

        if (isAdmin) {
            return "redirect:/admin/dashboard";
        } else {
            // Nếu là Nhân viên -> Vào trang Quản lý đơn hàng (Thay vì /staff/dashboard có thể chưa làm)
            return "redirect:/admin/orders";
        }
    }

    /**
     * 2. Dashboard chính cho ADMIN (/admin/dashboard)
     * Hiển thị số liệu thống kê thật từ Database
     */
    @GetMapping("/dashboard")
    @PreAuthorize("hasRole('ADMIN')") // Chỉ Admin mới xem được thống kê tiền nong
    public String adminDashboard(Model model) {
        
        // 1. TỔNG DOANH THU (Tính tổng đơn đã hoàn tất)
        BigDecimal totalRevenue = donHangRepository.sumTotalRevenue();
        if (totalRevenue == null) totalRevenue = BigDecimal.ZERO;

        // 2. ĐƠN HÀNG MỚI (Chờ xác nhận)
        long newOrdersCount = donHangRepository.countByTrangThaiDH(0);

        // 3. KHÁCH HÀNG (Tổng user)
        long totalCustomers = taiKhoanRepository.count();

        // 4. SẢN PHẨM (Tổng sp)
        long productCount = sanPhamService.countAll();
        
        // 5. VISITOR (Fake số liệu demo)
        long uniqueVisitors = 45890;

        // Đẩy dữ liệu ra View (admin.html)
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("newOrdersCount", newOrdersCount);
        model.addAttribute("totalCustomers", totalCustomers);
        model.addAttribute("productCount", productCount);
        model.addAttribute("uniqueVisitors", uniqueVisitors);

        // Để Sidebar sáng đèn
        model.addAttribute("currentPage", "dashboard");

        return "admin/admin"; // Trả về file admin.html
    }
}