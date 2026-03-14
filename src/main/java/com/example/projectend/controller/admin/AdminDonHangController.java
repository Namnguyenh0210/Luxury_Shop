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
@RequestMapping("/admin/orders")
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
    public Map<String, Object> updateStatus(
            @PathVariable Long id,
            @RequestParam Integer status,
            @RequestParam(required = false) String reason) {

        Map<String, Object> res = new HashMap<>();

        DonHang donHang = donHangRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng"));

        Integer trangThaiHienTai = donHang.getTrangThaiDH();

        // Đơn đã kết thúc → không thay đổi
        if (trangThaiHienTai == 4 || trangThaiHienTai == 5) {
            res.put("success", "false");
            res.put("message", "Đơn hàng đã kết thúc, không thể thay đổi!");
            return res;
        }

        // Chỉ hủy (5) khi đang chờ xác nhận (0) HOẶC khi khách báo chưa nhận hàng
        boolean canCancel = (status == 5 && (trangThaiHienTai == 0 || donHang.getKhachBaoChuaNhan()));

        if (status == 5 && !canCancel) {
            res.put("success", false);
            res.put("message", "Không thể hủy đơn đã xác nhận! Liên hệ khách hàng trực tiếp.");
            return res;
        }

        // Bắt buộc tuần tự: 0→1→2→3→4
        boolean isSequence = (status == trangThaiHienTai + 1);

        if (status != 5 && !isSequence) {
            res.put("success", false);
            res.put("message", "Chỉ được chuyển sang trạng thái kế tiếp!");
            return res;
        }

        donHang.setTrangThaiDH(status);
        donHang.setNgayCapNhat(LocalDateTime.now());
        
        if (reason != null && !reason.isBlank()) {
            donHang.setLyDoHuy(reason);
        }

        if (status == 4) {
            donHang.setTrangThaiThanhToan(1);
            donHang.setNgayThanhToan(LocalDateTime.now());
        }

        donHangRepository.save(donHang);

        res.put("success", true);
        res.put("message", "Cập nhật trạng thái thành công!");
        return res;
    }
}