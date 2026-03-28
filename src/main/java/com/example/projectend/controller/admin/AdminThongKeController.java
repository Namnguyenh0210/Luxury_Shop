package com.example.projectend.controller.admin;

import com.example.projectend.entity.DonHang;
import com.example.projectend.repository.DonHangChiTietRepository;
import com.example.projectend.repository.DonHangRepository;
import com.example.projectend.repository.TaiKhoanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@RestController
@RequestMapping("/api/admin/reports")
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
        if (totalRevenue == null)
            totalRevenue = BigDecimal.ZERO;

        long newOrders = donHangRepository.countByTrangThaiDH(0);
        long soldProducts = donHangChiTietRepository.countTotalSold();
        long totalCustomers = taiKhoanRepository.count();

        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        LocalDateTime endOfDay = LocalDateTime.of(LocalDate.now(), LocalTime.MAX);

        BigDecimal todayRevenue = donHangRepository.sumTotalRevenueBetween(startOfDay, endOfDay);
        if (todayRevenue == null) todayRevenue = BigDecimal.ZERO;

        Long todayOrders = donHangRepository.countByTrangThaiDHAndNgayDatBetween(0, startOfDay, endOfDay);
        if (todayOrders == null) todayOrders = 0L;

        Long todaySoldProducts = donHangChiTietRepository.countTotalSoldBetween(startOfDay, endOfDay);
        if (todaySoldProducts == null) todaySoldProducts = 0L;

        Long todayNewCustomers = taiKhoanRepository.countByNgayTaoBetween(startOfDay, endOfDay);
        if (todayNewCustomers == null) todayNewCustomers = 0L;

        // TODO: Sau này query thật theo ngày/tháng
        LocalDate today = LocalDate.now();
        LocalDate startWeek = today.minusDays(6);

        LocalDateTime start = startWeek.atStartOfDay();
        LocalDateTime end = today.atTime(LocalTime.MAX);

        List<DonHang> orders = donHangRepository.findByNgayDatBetween(start, end);

        // Map ngày -> doanh thu
        Map<LocalDate, BigDecimal> revenueMap = new HashMap<>();

        for (int i = 0; i < 7; i++) {
            revenueMap.put(startWeek.plusDays(i), BigDecimal.ZERO);
        }

        // Cộng tiền theo ngày
        for (DonHang dh : orders) {
            LocalDate date = dh.getNgayDat().toLocalDate();
            revenueMap.put(date,
                revenueMap.get(date).add(dh.getTongTien()));
        }

        // Convert sang list
        List<String> chartLabels = new ArrayList<>();
        List<Double> chartData = new ArrayList<>();

        for (int i = 0; i < 7; i++) {
            LocalDate d = startWeek.plusDays(i);
            chartLabels.add("T" + d.getDayOfWeek().getValue());
            chartData.add(revenueMap.get(d).doubleValue());
        }
        

        Map<String, Object> response = new HashMap<>();
        response.put("totalRevenue", totalRevenue);
        response.put("newOrders", newOrders);
        response.put("soldProducts", soldProducts);
        response.put("totalCustomers", totalCustomers);
        
        response.put("todayRevenue", todayRevenue);
        response.put("todayOrders", todayOrders);
        response.put("todaySoldProducts", todaySoldProducts);
        response.put("todayNewCustomers", todayNewCustomers);

        response.put("chartData", chartData);
        response.put("chartLabels", chartLabels);

        return response;
    }
    
    @GetMapping("/by-date")
    public Map<String, Object> getByDate(
            @RequestParam String startDate,
            @RequestParam String endDate) {

        LocalDateTime start = LocalDate.parse(startDate).atStartOfDay();
        LocalDateTime end = LocalDate.parse(endDate).atTime(LocalTime.MAX);

        List<DonHang> orders = donHangRepository.findByNgayDatBetween(start, end);

        Map<LocalDate, BigDecimal> revenueMap = new HashMap<>();

        // init ngày
        LocalDate current = start.toLocalDate();
        while (!current.isAfter(end.toLocalDate())) {
            revenueMap.put(current, BigDecimal.ZERO);
            current = current.plusDays(1);
        }

        // cộng tiền
        for (DonHang dh : orders) {
            LocalDate d = dh.getNgayDat().toLocalDate();
            revenueMap.put(d,
                revenueMap.get(d).add(dh.getTongTien()));
        }

        // convert
        List<String> labels = new ArrayList<>();
        List<Double> data = new ArrayList<>();

        for (Map.Entry<LocalDate, BigDecimal> entry : revenueMap.entrySet()) {
            labels.add(entry.getKey().toString()); // yyyy-MM-dd
            data.add(entry.getValue().doubleValue());
        }

        Map<String, Object> res = new HashMap<>();
        res.put("chartLabels", labels);
        res.put("chartData", data);

        return res;
    }
}