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
    public Page<DonHang> danhSach(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) Integer trangThai) {

        Pageable pageable = PageRequest.of(page, size, Sort.by("ngayDat").descending());

        if (trangThai != null) {
            return donHangService.getDonHangByTrangThai(trangThai, pageable);
        }

        return donHangService.getAllDonHangPage(pageable);
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
    public Map<String, String> capNhatTrangThai(
            @PathVariable Long id,
            @RequestParam Integer trangThaiMoi,
            Authentication auth) {

        String email = auth.getName();
        TaiKhoan currentUser = taiKhoanRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));

        DonHang donHang = donHangService.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng"));

        Integer trangThaiHienTai = donHang.getTrangThaiDH();

        // Không cho lùi trạng thái
        if (trangThaiMoi <= trangThaiHienTai && trangThaiHienTai != 0) {
            throw new RuntimeException("Không thể quay lại trạng thái trước đó!");
        }

        // Không cập nhật nếu đã hủy
        if (trangThaiHienTai == 4) {
            throw new RuntimeException("Đơn hàng đã hủy!");
        }

        // Gán nhân viên khi xác nhận lần đầu
        if (trangThaiHienTai == 0 && trangThaiMoi >= 1 && donHang.getNhanVien() == null) {
            donHang.setNhanVien(currentUser);
        }

        // Nếu đã có nhân viên khác
        if (donHang.getNhanVien() != null &&
                !donHang.getNhanVien().getMaTK().equals(currentUser.getMaTK())) {
            throw new RuntimeException("Đơn hàng đã có nhân viên khác phụ trách!");
        }

        donHang.setTrangThaiDH(trangThaiMoi);
        donHang.setNgayCapNhat(LocalDateTime.now());

        if (trangThaiMoi == 3) {
            donHang.setTrangThaiThanhToan(1);
            donHang.setNgayThanhToan(LocalDateTime.now());
        }

        donHangRepository.save(donHang);

        Map<String, String> res = new HashMap<>();
        res.put("message", "Cập nhật thành công!");
        return res;
    }

}