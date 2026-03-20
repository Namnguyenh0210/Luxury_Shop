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

        return donHangService.searchAdmin(keyword, statusStr, null, pageable);
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

        // Đơn đã kết thúc (Hoàn tất=4 hoặc Đã hủy=5) → không thay đổi được
        if (trangThaiHienTai == 4 || trangThaiHienTai == 5) {
            throw new RuntimeException("Đơn hàng đã kết thúc, không thể thay đổi trạng thái!");
        }

        // Chỉ được hủy (status=5) khi đang ở "Chờ xác nhận" (status=0) HOẶC khi khách
        // báo chưa nhận hàng
        boolean canCancel = (trangThaiMoi == 5 && (trangThaiHienTai == 0 || donHang.getKhachBaoChuaNhan()));

        if (trangThaiMoi == 5 && !canCancel) {
            throw new RuntimeException("Không thể hủy đơn đã xác nhận! Liên hệ khách hàng trực tiếp.");
        }

        // Bắt buộc đi tuần tự: 0→1→2→3→4
        boolean isSequence = (trangThaiMoi == trangThaiHienTai + 1);

        if (trangThaiMoi != 5 && !isSequence) {
            throw new RuntimeException("Chỉ được chuyển sang trạng thái kế tiếp!");
        }

        // Gán nhân viên khi xác nhận lần đầu (status 0 → 1)
        if (trangThaiHienTai == 0 && trangThaiMoi == 1 && donHang.getNhanVien() == null) {
            donHang.setNhanVien(currentUser);
        }

        // Kiểm tra nhân viên phụ trách (ADMIN bỏ qua kiểm tra này)
        boolean isAdmin = auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
        if (!isAdmin && donHang.getNhanVien() != null &&
                !donHang.getNhanVien().getMaTK().equals(currentUser.getMaTK())) {
            throw new RuntimeException("Đơn hàng đã có nhân viên khác phụ trách!");
        }

        donHang.setTrangThaiDH(trangThaiMoi);
        donHang.setNgayCapNhat(LocalDateTime.now());

        if (reason != null && !reason.isBlank()) {
            donHang.setLyDoHuy(reason);
        }

        // Hoàn tất → tự động đánh dấu đã thanh toán
        if (trangThaiMoi == 4) {
            donHang.setTrangThaiThanhToan(1);
            donHang.setNgayThanhToan(LocalDateTime.now());
        }

        donHangRepository.save(donHang);

        res.put("message", "Cập nhật thành công!");
        res.put("success", true);
        return res;
    }

}