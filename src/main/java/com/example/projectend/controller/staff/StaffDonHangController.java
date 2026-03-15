package com.example.projectend.controller.staff;

import com.example.projectend.entity.DonHang;
import com.example.projectend.entity.DonHangChiTiet;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.DonHangRepository;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.service.DonHangService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/staff/orders")
@PreAuthorize("hasAnyRole('NHANVIEN','ADMIN')")
@CrossOrigin(origins = "http://localhost:5173")
public class StaffDonHangController {

    @Autowired
    private DonHangService donHangService;

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @Autowired
    private DonHangRepository donHangRepository;

    // =============================
    // 1. Danh sách đơn hàng
    // =============================
    @GetMapping
    public Page<DonHang> listOrders(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status) {

        Pageable pageable = PageRequest.of(page, size);
        String statusStr = (status != null) ? status.toString() : null;

        return donHangService.searchAdmin(keyword, statusStr, pageable);
    }

    // =============================
    // 2. Chi tiết đơn hàng
    // =============================
    @GetMapping("/{id}")
    public Map<String, Object> chiTiet(@PathVariable Long id) {

        DonHang donHang = donHangService.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng"));

        List<DonHangChiTiet> chiTiet = donHangService.getChiTietDonHang(donHang);

        Map<String, Object> response = new HashMap<>();
        response.put("donHang", donHang);
        response.put("chiTiet", chiTiet);

        return response;
    }

    // =============================
    // 3. Cập nhật trạng thái
    // =============================
    @PutMapping("/{id}/status")
    public Map<String, Object> capNhatTrangThai(
            @PathVariable Long id,
            @RequestParam Integer trangThaiMoi,
            @RequestParam(required = false) String reason,
            Authentication auth) {

        Map<String, Object> res = new HashMap<>();
        String email = auth.getName();
        TaiKhoan currentUser = taiKhoanRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));

        DonHang donHang = donHangService.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng"));

        Integer trangThaiHienTai = donHang.getTrangThaiDH();

        try {
            String nguoiCapNhat = currentUser.getHoTen();
            String ghiChu = (trangThaiMoi == 5) ? "Hủy đơn: " + reason : "Cập nhật qua Staff";
            
            // Gán nhân viên khi xác nhận lần đầu (status 0 → 1)
            if (trangThaiHienTai == 0 && trangThaiMoi == 1 && donHang.getNhanVien() == null) {
                donHang.setNhanVien(currentUser);
                donHangRepository.save(donHang);
            }

            boolean updated = donHangService.capNhatTrangThai(id, trangThaiMoi, nguoiCapNhat, ghiChu);
            
            if (updated && reason != null && !reason.isBlank()) {
                DonHang dh = donHangRepository.findById(id).orElse(null);
                if (dh != null) {
                    dh.setLyDoHuy(reason);
                    donHangRepository.save(dh);
                }
            }

            res.put("success", updated);
            res.put("message", updated ? "Cập nhật thành công!" : "Không thể cập nhật!");
        } catch (Exception e) {
            res.put("success", false);
            res.put("message", "Lỗi: " + e.getMessage());
        }
        return res;
    }

}