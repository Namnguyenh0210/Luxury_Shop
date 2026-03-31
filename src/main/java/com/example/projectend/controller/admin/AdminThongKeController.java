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
    public Map<String, Object> getDashboard(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {

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

        LocalDateTime start;
        LocalDateTime end;
        LocalDate startLocalDate;

        if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
            startLocalDate = LocalDate.parse(startDate);
            start = startLocalDate.atStartOfDay();
            end = LocalDate.parse(endDate).atTime(LocalTime.MAX);
        } else {
            LocalDate today = LocalDate.now();
            startLocalDate = today.minusDays(6);
            start = startLocalDate.atStartOfDay();
            end = today.atTime(LocalTime.MAX);
        }

        List<DonHang> orders = donHangRepository.findByNgayDatBetween(start, end);
        long totalDays = java.time.temporal.ChronoUnit.DAYS.between(startLocalDate, end.toLocalDate()) + 1;

        List<String> chartLabels = new ArrayList<>();
        List<Double> chartData = new ArrayList<>();

        if (totalDays <= 31) {
            Map<LocalDate, BigDecimal> revenueMap = new HashMap<>();
            LocalDate current = startLocalDate;
            while (!current.isAfter(end.toLocalDate())) {
                revenueMap.put(current, BigDecimal.ZERO);
                current = current.plusDays(1);
            }
            for (DonHang dh : orders) {
                LocalDate d = dh.getNgayDat().toLocalDate();
                if (revenueMap.containsKey(d)) {
                    revenueMap.put(d, revenueMap.get(d).add(dh.getTongTien() != null ? dh.getTongTien() : BigDecimal.ZERO));
                }
            }
            current = startLocalDate;
            while (!current.isAfter(end.toLocalDate())) {
                chartLabels.add(current.getDayOfMonth() + "/" + current.getMonthValue());
                chartData.add(revenueMap.get(current).doubleValue());
                current = current.plusDays(1);
            }
        } else {
            Map<String, BigDecimal> revenueMap = new HashMap<>();
            LocalDate current = startLocalDate.withDayOfMonth(1);
            while (!current.isBefore(startLocalDate.withDayOfMonth(1)) && !current.isAfter(end.toLocalDate())) {
                String monthKey = current.getMonthValue() + "/" + current.getYear();
                revenueMap.put(monthKey, BigDecimal.ZERO);
                current = current.plusMonths(1);
            }
            for (DonHang dh : orders) {
                LocalDate d = dh.getNgayDat().toLocalDate();
                String monthKey = d.getMonthValue() + "/" + d.getYear();
                if (revenueMap.containsKey(monthKey)) {
                    revenueMap.put(monthKey, revenueMap.get(monthKey).add(dh.getTongTien() != null ? dh.getTongTien() : BigDecimal.ZERO));
                }
            }
            current = startLocalDate.withDayOfMonth(1);
            while (!current.isAfter(end.toLocalDate())) {
                String monthKey = current.getMonthValue() + "/" + current.getYear();
                chartLabels.add("T" + current.getMonthValue());
                chartData.add(revenueMap.get(monthKey).doubleValue());
                current = current.plusMonths(1);
            }
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