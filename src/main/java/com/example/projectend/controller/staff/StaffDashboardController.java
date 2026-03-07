package com.example.projectend.controller.staff;

import com.example.projectend.entity.DonHang;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.service.BaiVietService;
import com.example.projectend.service.DonHangService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/staff")
@PreAuthorize("hasAnyRole('ADMIN','NHANVIEN')")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class StaffDashboardController {

    @Autowired
    private DonHangService donHangService;

    @Autowired
    private BaiVietService baiVietService;

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @GetMapping("/dashboard")
    public Map<String, Object> dashboard(@AuthenticationPrincipal UserDetails userDetails) {

        if (userDetails == null) {
            throw new RuntimeException("Unauthorized");
        }

        String email = userDetails.getUsername();
        TaiKhoan nhanVien = taiKhoanRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản"));

        long orderCount = donHangService.countAll();

        List<DonHang> pendingOrders = donHangService.getPendingOrders(10);

        long pendingCount = pendingOrders.size();

        long myPostCount = baiVietService.getAllBaiVietAdmin(PageRequest.of(0, 1000))
                .stream()
                .filter(bv -> bv.getTaiKhoan() != null &&
                        bv.getTaiKhoan().getMaTK().equals(nhanVien.getMaTK()))
                .count();

        // ⚠ Tránh trả full entity
        List<Map<String, Object>> recentOrders = pendingOrders.stream()
                .map(dh -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("maDH", dh.getMaDH());
                    //map.put("tenKhach", dh.getMaKM());
                    map.put("tongTien", dh.getTongTien());
                    map.put("trangThai", dh.getTrangThaiDH());
                    return map;
                })
                .collect(Collectors.toList());

        Map<String, Object> response = new HashMap<>();
        response.put("orderCount", orderCount);
        response.put("pendingCount", pendingCount);
        response.put("myPostCount", myPostCount);
        response.put("recentOrders", recentOrders);

        return response;
    }
}