package com.example.projectend.controller.admin;

import com.example.projectend.repository.DonHangChiTietRepository;
import com.example.projectend.repository.DonHangRepository;
import com.example.projectend.repository.TaiKhoanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/admin/reports")
@PreAuthorize("hasRole('ADMIN')")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class AdminThongKeController {

    @Autowired
    private DonHangRepository donHangRepository;

    @Autowired
    private DonHangChiTietRepository donHangChiTietRepository;

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @GetMapping
    public Map<String, Object> getDashboard() {

        BigDecimal totalRevenue = donHangRepository.sumTotalRevenue();
        if (totalRevenue == null) totalRevenue = BigDecimal.ZERO;

        long newOrders = donHangRepository.countByTrangThaiDH(0);
        long soldProducts = donHangChiTietRepository.countTotalSold();
        long totalCustomers = taiKhoanRepository.count();

        // TODO: Sau này query thật theo ngày/tháng
        List<Integer> chartData = List.of(15, 25, 18, 30, 22, 40, 55);
        List<String> chartLabels = List.of("T2", "T3", "T4", "T5", "T6", "T7", "CN");

        Map<String, Object> response = new HashMap<>();
        response.put("totalRevenue", totalRevenue);
        response.put("newOrders", newOrders);
        response.put("soldProducts", soldProducts);
        response.put("totalCustomers", totalCustomers);
        response.put("chartData", chartData);
        response.put("chartLabels", chartLabels);

        return response;
    }
}