package com.example.projectend.controller.admin;

import com.example.projectend.repository.DonHangRepository;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.service.SanPhamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
@PreAuthorize("hasRole('ADMIN')")
public class AdminDashboardController {

    @Autowired
    private SanPhamService sanPhamService;

    @Autowired
    private DonHangRepository donHangRepository;

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @GetMapping("/dashboard")
    public Map<String, Object> dashboard() {

        BigDecimal totalRevenue = donHangRepository.sumTotalRevenue();
        if (totalRevenue == null) totalRevenue = BigDecimal.ZERO;

        long newOrdersCount = donHangRepository.countByTrangThaiDH(0);
        long totalCustomers = taiKhoanRepository.count();
        long productCount = sanPhamService.countAll();

        Map<String, Object> response = new HashMap<>();
        response.put("totalRevenue", totalRevenue);
        response.put("newOrdersCount", newOrdersCount);
        response.put("totalCustomers", totalCustomers);
        response.put("productCount", productCount);

        return response;
    }
}