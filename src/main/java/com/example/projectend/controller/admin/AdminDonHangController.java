package com.example.projectend.controller.admin;

import com.example.projectend.entity.DonHang;
import com.example.projectend.repository.DonHangRepository;
import com.example.projectend.service.DonHangService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/orders")
@PreAuthorize("hasRole('ADMIN') or hasRole('NHANVIEN')")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class AdminDonHangController {

    @Autowired
    private DonHangService donHangService;

    @Autowired
    private DonHangRepository donHangRepository;

    // ==========================================
    // 1. DANH SÁCH ĐƠN HÀNG (JSON)
    // ==========================================
    @GetMapping
    public Page<DonHang> listOrders(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String timeRange) {

        Pageable pageable = PageRequest.of(page, size);
        String statusStr = (status != null) ? status.toString() : null;

        return donHangService.searchAdmin(keyword, statusStr, timeRange, pageable);
    }

    // ==========================================
    // 2. CHI TIẾT ĐƠN HÀNG
    // ==========================================
    @GetMapping("/{id}")
    public DonHang orderDetail(@PathVariable Long id) {
        return donHangService.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng"));
    }

    // ==========================================
    // 3. CẬP NHẬT TRẠNG THÁI
    // ==========================================
    @PutMapping("/{id}/status")
    public Map<String, Object> updateStatus(
            @PathVariable Long id,
            @RequestParam Integer status,
            @RequestParam(required = false) String reason) {

        Map<String, Object> res = new HashMap<>();

        try {
            String nguoiCapNhat = "ADMIN";
            String ghiChu = (status == 5) ? "Hủy đơn: " + reason : "Cập nhật qua Admin";
            
            boolean updated = donHangService.capNhatTrangThai(id, status, nguoiCapNhat, ghiChu);
            
            if (updated && reason != null && !reason.isBlank()) {
                DonHang dh = donHangRepository.findById(id).orElse(null);
                if (dh != null) {
                    dh.setLyDoHuy(reason);
                    donHangRepository.save(dh);
                }
            }

            res.put("success", updated);
            res.put("message", updated ? "Cập nhật trạng thái thành công!" : "Không thể cập nhật trạng thái!");
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "Lỗi: " + e.getMessage());
        }
        return res;
    }
}