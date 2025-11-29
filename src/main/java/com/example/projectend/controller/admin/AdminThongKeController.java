package com.example.projectend.controller.admin;

import com.example.projectend.repository.DonHangChiTietRepository;
import com.example.projectend.repository.DonHangRepository;
import com.example.projectend.repository.TaiKhoanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

@Controller
@RequestMapping("/admin/reports")
@PreAuthorize("hasRole('ADMIN')")
public class AdminThongKeController {

    @Autowired
    private DonHangRepository donHangRepository;

    @Autowired
    private DonHangChiTietRepository donHangChiTietRepository;

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @GetMapping
    public String showDashboard(Model model) {
        // 1. Lấy số liệu thống kê thực tế
        BigDecimal totalRevenue = donHangRepository.sumTotalRevenue();
        long newOrders = donHangRepository.countByTrangThaiDH(0); // 0: Chờ xác nhận
        long soldProducts = donHangChiTietRepository.countTotalSold();
        long totalCustomers = taiKhoanRepository.count();

        // Xử lý nếu chưa có doanh thu (null) -> trả về 0
        if (totalRevenue == null) totalRevenue = BigDecimal.ZERO;

        // 2. Đẩy số liệu sang View
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("newOrders", newOrders);
        model.addAttribute("soldProducts", soldProducts);
        model.addAttribute("totalCustomers", totalCustomers);

        // 3. Dữ liệu biểu đồ (Giả lập cho Demo - Thực tế cần query theo tháng/ngày)
        // Gửi list số liệu doanh thu 7 ngày gần nhất
        List<Integer> chartData = Arrays.asList(15, 25, 18, 30, 22, 40, 55); 
        List<String> chartLabels = Arrays.asList("T2", "T3", "T4", "T5", "T6", "T7", "CN");
        
        model.addAttribute("chartData", chartData);
        model.addAttribute("chartLabels", chartLabels);

        model.addAttribute("currentPage", "reports");
        
        // Trả về file: templates/admin/report-analytics.html
        return "admin/report-analytics"; 
    }
}