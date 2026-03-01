package com.example.projectend.controller.admin;

import com.example.projectend.entity.DonHang;
import com.example.projectend.service.DonHangService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin/orders")
@PreAuthorize("hasRole('ADMIN') or hasRole('NHANVIEN')")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class AdminDonHangController {

    @Autowired
    private DonHangService donHangService;

    // ==========================================
    // 1. DANH SÁCH ĐƠN HÀNG (JSON)
    // ==========================================
    @GetMapping
    public Page<DonHang> listOrders(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status) {

        Pageable pageable = PageRequest.of(page, size);
        String statusStr = (status != null) ? status.toString() : null;

        return donHangService.searchAdmin(keyword, statusStr, pageable);
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
    public String updateStatus(@PathVariable Long id,
                               @RequestParam Integer status) {

        boolean success = donHangService.updateOrderStatus(id, status, "ADMIN");

        if (success) {
            return "Cập nhật thành công";
        } else {
            throw new RuntimeException("Cập nhật thất bại");
        }
    }
}