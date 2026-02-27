package com.example.projectend.controller.staff;

import com.example.projectend.entity.DonHang;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.service.BaiVietService;
import com.example.projectend.service.DonHangService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/staff")
@PreAuthorize("hasAnyRole('ADMIN','NHANVIEN')")
public class StaffDashboardController {

    @Autowired
    private DonHangService donHangService;

    @Autowired
    private BaiVietService baiVietService;

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @GetMapping("/dashboard")
    public Map<String, Object> dashboard(@AuthenticationPrincipal UserDetails userDetails) {

        Map<String, Object> response = new HashMap<>();

        if (userDetails == null) {
            response.put("error", "Unauthorized");
            return response;
        }

        String email = userDetails.getUsername();
        TaiKhoan nhanVien = taiKhoanRepository.findByEmail(email).orElse(null);

        long orderCount = donHangService.countAll();
        long pendingCount = donHangService.getPendingOrders(1000).size();

        long myPostCount = 0;
        if (nhanVien != null) {
            myPostCount = baiVietService.getAllBaiVietAdmin(
                            org.springframework.data.domain.PageRequest.of(0, 1000)
                    ).stream()
                    .filter(bv -> bv.getTaiKhoan() != null &&
                            bv.getTaiKhoan().getMaTK().equals(nhanVien.getMaTK()))
                    .count();
        }

        List<DonHang> recentOrders = donHangService.getPendingOrders(10);

        response.put("orderCount", orderCount);
        response.put("pendingCount", pendingCount);
        response.put("myPostCount", myPostCount);
        response.put("recentOrders", recentOrders);

        return response;
    }
}