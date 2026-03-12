package com.example.projectend.controller;

import com.example.projectend.entity.*;
import com.example.projectend.repository.*;
import com.example.projectend.service.DanhGiaService;
import com.example.projectend.service.auth.UserDetailsServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * API Controller cho Đánh giá sản phẩm
 * Base path: /api/san-pham/{maSP}/danh-gia
 */
@RestController
@RequestMapping("/api")
public class DanhGiaController {

    @Autowired
    private DanhGiaService danhGiaService;

    @Autowired
    private DonHangChiTietRepository donHangChiTietRepository;

    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    // =========================================================
    // GET /api/san-pham/{maSP}/danh-gia
    // Lấy tất cả đánh giá + thống kê sao của 1 sản phẩm
    // =========================================================
    @GetMapping("/san-pham/{maSP}/danh-gia")
    public ResponseEntity<Map<String, Object>> getDanhGia(@PathVariable Long maSP) {
        Map<String, Object> res = new HashMap<>();
        try {
            List<DanhGia> danhGiaList = danhGiaService.getDanhGiaBySanPham(maSP);
            Double avgRating = danhGiaService.getAverageRating(maSP);
            long totalCount = danhGiaService.countReviews(maSP);

            // Thống kê từng mức sao
            Map<Integer, Long> starStats = new LinkedHashMap<>();
            for (int i = 5; i >= 1; i--) {
                final int star = i;
                long count = danhGiaList.stream().filter(d -> d.getDiem() == star).count();
                starStats.put(star, count);
            }

            // Convert sang DTO
            List<Map<String, Object>> dtoList = new ArrayList<>();
            for (DanhGia dg : danhGiaList) {
                Map<String, Object> dto = new HashMap<>();
                dto.put("maDG", dg.getMaDG());
                dto.put("diem", dg.getDiem());
                dto.put("noiDung", dg.getNoiDung());
                dto.put("ngayDanhGia", dg.getNgayDanhGia() != null ? dg.getNgayDanhGia().format(FMT) : "");
                dto.put("phanHoi", dg.getPhanHoi());
                dto.put("ngayPhanHoi", dg.getNgayPhanHoi() != null ? dg.getNgayPhanHoi().format(FMT) : "");
                dto.put("tenNguoiDung", dg.getTaiKhoan() != null ? dg.getTaiKhoan().getHoTen() : "Khách");
                dto.put("avatar", dg.getTaiKhoan() != null ? dg.getTaiKhoan().getAvatar() : null);
                // Lấy tên sản phẩm từ chi tiết đơn hàng
                if (dg.getDonHangChiTiet() != null && dg.getDonHangChiTiet().getSanPhamChiTiet() != null) {
                    dto.put("tenBienThe", buildVariantName(dg.getDonHangChiTiet().getSanPhamChiTiet()));
                }
                dtoList.add(dto);
            }

            res.put("thanhCong", true);
            res.put("danhGiaList", dtoList);
            res.put("diemTrungBinh", avgRating != null ? Math.round(avgRating * 10.0) / 10.0 : 0.0);
            res.put("tongSoDanhGia", totalCount);
            res.put("thongKeSao", starStats);

            // Kiểm tra user hiện tại có thể đánh giá chưa
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
                TaiKhoan tk = userDetailsService.getTaiKhoanByEmail(auth.getName());
                List<Map<String, Object>> coTheReview = getCoTheReview(tk, maSP);
                res.put("coTheReview", coTheReview);
                res.put("daDangNhap", true);
            } else {
                res.put("coTheReview", new ArrayList<>());
                res.put("daDangNhap", false);
            }

            return ResponseEntity.ok(res);
        } catch (Exception e) {
            res.put("thanhCong", false);
            res.put("thongBao", e.getMessage());
            return ResponseEntity.ok(res);
        }
    }

    // =========================================================
    // POST /api/san-pham/{maSP}/danh-gia
    // Gửi đánh giá mới (cần đã mua + đơn đã giao)
    // =========================================================
    @PostMapping("/san-pham/{maSP}/danh-gia")
    public ResponseEntity<Map<String, Object>> guiDanhGia(
            @PathVariable Long maSP,
            @RequestBody Map<String, Object> body) {

        Map<String, Object> res = new HashMap<>();
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                res.put("thanhCong", false);
                res.put("thongBao", "Vui lòng đăng nhập để đánh giá sản phẩm");
                return ResponseEntity.status(401).body(res);
            }

            TaiKhoan tk = userDetailsService.getTaiKhoanByEmail(auth.getName());

            // Lấy dữ liệu từ body
            Integer diem = (Integer) body.get("diem");
            String noiDung = (String) body.get("noiDung");
            Long maCT = body.get("maCT") != null ? Long.valueOf(body.get("maCT").toString()) : null;

            if (diem == null || diem < 1 || diem > 5) {
                res.put("thanhCong", false);
                res.put("thongBao", "Vui lòng chọn số sao từ 1 đến 5");
                return ResponseEntity.ok(res);
            }
            if (maCT == null) {
                res.put("thanhCong", false);
                res.put("thongBao", "Không xác định được đơn hàng");
                return ResponseEntity.ok(res);
            }

            // Lấy DonHangChiTiet + kiểm tra hợp lệ
            DonHangChiTiet donHangCT = donHangChiTietRepository.findById(maCT).orElse(null);
            if (donHangCT == null) {
                res.put("thanhCong", false);
                res.put("thongBao", "Không tìm thấy chi tiết đơn hàng");
                return ResponseEntity.ok(res);
            }

            // Kiểm tra đơn hàng thuộc về user này và đã giao (trạng thái = 3)
            DonHang donHang = donHangCT.getDonHang();
            if (donHang == null || !donHang.getTaiKhoan().getMaTK().equals(tk.getMaTK())) {
                res.put("thanhCong", false);
                res.put("thongBao", "Bạn không có quyền đánh giá đơn hàng này");
                return ResponseEntity.ok(res);
            }
            if (donHang.getTrangThaiDH() != 3) {
                res.put("thanhCong", false);
                res.put("thongBao", "Chỉ có thể đánh giá sau khi đơn hàng đã được giao");
                return ResponseEntity.ok(res);
            }

            // Tạo đánh giá
            DanhGia danhGia = danhGiaService.createReview(donHangCT, tk, diem, noiDung);

            Map<String, Object> dto = new HashMap<>();
            dto.put("maDG", danhGia.getMaDG());
            dto.put("diem", danhGia.getDiem());
            dto.put("noiDung", danhGia.getNoiDung());
            dto.put("ngayDanhGia", danhGia.getNgayDanhGia() != null ? danhGia.getNgayDanhGia().format(FMT) : "");
            dto.put("tenNguoiDung", tk.getHoTen());
            dto.put("avatar", tk.getAvatar());

            res.put("thanhCong", true);
            res.put("thongBao", "Đánh giá của bạn đã được gửi thành công!");
            res.put("danhGia", dto);
            // Cập nhật điểm mới
            res.put("diemTrungBinhMoi", danhGiaService.getAverageRating(maSP));
            res.put("tongSoDanhGiaMoi", danhGiaService.countReviews(maSP));

            return ResponseEntity.ok(res);

        } catch (IllegalStateException e) {
            res.put("thanhCong", false);
            res.put("thongBao", e.getMessage());
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            res.put("thanhCong", false);
            res.put("thongBao", "Có lỗi xảy ra: " + e.getMessage());
            return ResponseEntity.ok(res);
        }
    }

    // =========================================================
    // POST /api/san-pham/danh-gia/{id}/report
    // Báo cáo đánh giá (Spam/Xúc phạm)
    // =========================================================
    @PostMapping("/san-pham/danh-gia/{id}/report")
    public ResponseEntity<Map<String, Object>> reportDanhGia(@PathVariable Long id) {
        Map<String, Object> res = new HashMap<>();
        try {
            DanhGia dg = danhGiaService.findById(id).orElse(null);
            if (dg == null) {
                res.put("thanhCong", false);
                res.put("thongBao", "Không tìm thấy đánh giá");
                return ResponseEntity.ok(res);
            }
            dg.incrementReport();
            danhGiaService.save(dg);
            
            res.put("thanhCong", true);
            res.put("thongBao", "Đã báo cáo đánh giá này cho Quản trị viên.");
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            res.put("thanhCong", false);
            res.put("thongBao", "Lỗi gửi báo cáo");
            return ResponseEntity.ok(res);
        }
    }

    // =========================================================
    // Helper: lấy danh sách DonHangChiTiet chưa được review của user cho sản phẩm maSP
    // =========================================================
    private List<Map<String, Object>> getCoTheReview(TaiKhoan tk, Long maSP) {
        List<Map<String, Object>> result = new ArrayList<>();
        try {
            // Tìm tất cả DonHangCT đã giao của user cho sản phẩm này
            List<DonHangChiTiet> chiTietList = donHangChiTietRepository
                    .findByDonHang_TaiKhoan_MaTKAndDonHang_TrangThaiDHAndSanPhamChiTiet_SanPham_MaSP(
                            tk.getMaTK(), 3, maSP);
            for (DonHangChiTiet ct : chiTietList) {
                if (!danhGiaService.hasReviewed(ct)) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("maCT", ct.getMaCT());
                    item.put("maDH", ct.getDonHang().getMaDH());
                    item.put("tenBienThe", buildVariantName(ct.getSanPhamChiTiet()));
                    result.add(item);
                }
            }
        } catch (Exception e) {
            // ignore
        }
        return result;
    }

    private String buildVariantName(SanPhamChiTiet spct) {
        if (spct == null) return "";
        StringBuilder sb = new StringBuilder();
        if (spct.getSizeSP() != null) sb.append("Size ").append(spct.getSizeSP().getTenSize());
        if (spct.getMauSacSP() != null) {
            if (sb.length() > 0) sb.append(" - ");
            sb.append("Màu ").append(spct.getMauSacSP().getTenMau());
        }
        return sb.toString();
    }
}
