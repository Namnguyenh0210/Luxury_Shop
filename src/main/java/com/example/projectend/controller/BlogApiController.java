package com.example.projectend.controller;

import com.example.projectend.entity.*;
import com.example.projectend.repository.*;
import com.example.projectend.service.auth.UserDetailsServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.*;

/**
 * API Blog Controller - Dành cho khách hàng xem bài viết, bình luận, like
 */
@RestController
@RequestMapping("/api/blog")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
@Transactional
public class BlogApiController {

    @Autowired
    private BaiVietRepository baiVietRepository;

    @Autowired
    private BinhLuanRepository binhLuanRepository;

    @Autowired
    private LoaiBaiVietRepository loaiBaiVietRepository;

    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    // =============================
    // 1. DANH SÁCH BÀI VIẾT (PUBLIC)
    // =============================
    @GetMapping
    public ResponseEntity<Map<String, Object>> getDanhSachBaiViet(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "9") int size,
            @RequestParam(required = false) String search) {

        Map<String, Object> response = new HashMap<>();
        try {
            Page<BaiViet> baiVietPage;
            PageRequest pageable = PageRequest.of(page, size);

            if (search != null && !search.trim().isEmpty()) {
                baiVietPage = baiVietRepository
                        .findByTieuDeContainingIgnoreCaseAndTrangThaiOrderByNgayDangDesc(search, true, pageable);
            } else {
                baiVietPage = baiVietRepository
                        .findByTrangThaiOrderByNgayDangDesc(true, pageable);
            }

            // Build DTO để tránh vòng lặp tuần hoàn JSON
            List<Map<String, Object>> baiVietList = new ArrayList<>();
            for (BaiViet bv : baiVietPage.getContent()) {
                Map<String, Object> dto = buildBaiVietDTO(bv, false);
                dto.put("soLuongBinhLuan", binhLuanRepository.countByBaiViet_MaBVAndTrangThaiTrue(bv.getMaBV()));
                baiVietList.add(dto);
            }

            response.put("thanhCong", true);
            response.put("danhSach", baiVietList);
            response.put("tongSo", baiVietPage.getTotalElements());
            response.put("tongTrang", baiVietPage.getTotalPages());
            response.put("trangHienTai", baiVietPage.getNumber());

            List<Map<String, Object>> loaiBaiVietList = new ArrayList<>();
            for (LoaiBaiViet l : loaiBaiVietRepository.findAll()) {
                Map<String, Object> lMap = new HashMap<>();
                lMap.put("maLoaiBV", l.getMaLoaiBV());
                lMap.put("tenLoaiBV", l.getTenLoaiBV());
                loaiBaiVietList.add(lMap);
            }
            response.put("loaiBaiViet", loaiBaiVietList);

            // Bài nổi bật (top 3 mới nhất)
            List<BaiViet> noiBat = baiVietRepository.findTop3ByTrangThaiTrueOrderByNgayDangDesc();
            List<Map<String, Object>> noiBatDTO = new ArrayList<>();
            for (BaiViet bv : noiBat) {
                noiBatDTO.add(buildBaiVietDTO(bv, false));
            }
            response.put("noiBat", noiBatDTO);

        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", "Lỗi: " + e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    // =============================
    // 2. CHI TIẾT BÀI VIẾT (PUBLIC)
    // =============================
    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getChiTietBaiViet(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            Optional<BaiViet> opt = baiVietRepository.findById(id);
            if (opt.isEmpty() || !Boolean.TRUE.equals(opt.get().getTrangThai())) {
                response.put("thanhCong", false);
                response.put("thongBao", "Bài viết không tồn tại");
                return ResponseEntity.ok(response);
            }

            BaiViet bv = opt.get();

            // Tăng lượt xem
            bv.setLuotXem((bv.getLuotXem() == null ? 0 : bv.getLuotXem()) + 1);
            baiVietRepository.save(bv);

            // Lấy bình luận
            List<BinhLuan> binhLuanList = binhLuanRepository
                    .findByBaiViet_MaBVAndTrangThaiTrueOrderByNgayBinhLuanDesc(id);

            List<Map<String, Object>> binhLuanDTOs = new ArrayList<>();
            for (BinhLuan bl : binhLuanList) {
                Map<String, Object> blDTO = new HashMap<>();
                blDTO.put("maBL", bl.getMaBL());
                blDTO.put("noiDung", bl.getNoiDung());
                blDTO.put("ngayBinhLuan", bl.getNgayBinhLuan());
                blDTO.put("soLuongLike", bl.getSoLuotThich());
                blDTO.put("tenNguoiDung", bl.getTaiKhoan() != null ? bl.getTaiKhoan().getHoTen() : "Khách");
                blDTO.put("avatar", bl.getTaiKhoan() != null ? bl.getTaiKhoan().getAvatar() : null);
                blDTO.put("phanHoiAdmin", bl.getPhanHoiAdmin());
                blDTO.put("ngayPhanHoiAdmin", bl.getNgayPhanHoiAdmin());
                binhLuanDTOs.add(blDTO);
            }

            // Bài viết liên quan (cùng loại, trừ bài hiện tại)
            List<BaiViet> lienQuan = baiVietRepository.findTop3ByTrangThaiTrueOrderByNgayDangDesc();
            List<Map<String, Object>> lienQuanDTOs = new ArrayList<>();
            for (BaiViet lq : lienQuan) {
                if (!lq.getMaBV().equals(id)) {
                    lienQuanDTOs.add(buildBaiVietDTO(lq, false));
                }
            }

            response.put("thanhCong", true);
            response.put("baiViet", buildBaiVietDTO(bv, true));
            response.put("binhLuan", binhLuanDTOs);
            response.put("soLuongBinhLuan", binhLuanList.size());
            response.put("lienQuan", lienQuanDTOs);

        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", "Lỗi: " + e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    // =============================
    // 3. ĐĂNG BÌNH LUẬN (Cần đăng nhập)
    // =============================
    @PostMapping("/{id}/binh-luan")
    public ResponseEntity<Map<String, Object>> dangBinhLuan(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {

        Map<String, Object> response = new HashMap<>();
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                response.put("thanhCong", false);
                response.put("thongBao", "Vui lòng đăng nhập để bình luận");
                return ResponseEntity.status(401).body(response);
            }

            String noiDung = body.get("noiDung");
            if (noiDung == null || noiDung.trim().isEmpty()) {
                response.put("thanhCong", false);
                response.put("thongBao", "Nội dung bình luận không được trống");
                return ResponseEntity.badRequest().body(response);
            }

            BaiViet baiViet = baiVietRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Bài viết không tồn tại"));

            TaiKhoan taiKhoan = userDetailsService.getTaiKhoanByEmail(auth.getName());

            BinhLuan binhLuan = new BinhLuan();
            binhLuan.setBaiViet(baiViet);
            binhLuan.setTaiKhoan(taiKhoan);
            binhLuan.setNoiDung(noiDung.trim());
            binhLuan.setNgayBinhLuan(LocalDateTime.now());
            binhLuan.setTrangThai(false); // Pending approval
            binhLuan.setSoLuotThich(0);

            BinhLuan saved = binhLuanRepository.save(binhLuan);

            Map<String, Object> blDTO = new HashMap<>();
            blDTO.put("maBL", saved.getMaBL());
            blDTO.put("noiDung", saved.getNoiDung());
            blDTO.put("ngayBinhLuan", saved.getNgayBinhLuan());
            blDTO.put("soLuongLike", 0);
            blDTO.put("tenNguoiDung", taiKhoan.getHoTen());
            blDTO.put("avatar", taiKhoan.getAvatar());

            response.put("thanhCong", true);
            response.put("thongBao", "Bình luận đã được đăng thành công!");
            response.put("binhLuan", blDTO);

        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", "Lỗi: " + e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    // =============================
    // 4. LIKE BÌNH LUẬN
    // =============================
    @PostMapping("/binh-luan/{maBL}/like")
    public ResponseEntity<Map<String, Object>> likeBinhLuan(@PathVariable Long maBL) {
        Map<String, Object> response = new HashMap<>();
        try {
            if (maBL == null) throw new IllegalArgumentException("maBL is null");
            BinhLuan bl = binhLuanRepository.findById(maBL)
                    .orElseThrow(() -> new RuntimeException("Bình luận không tồn tại"));

            bl.setSoLuotThich((bl.getSoLuotThich() == null ? 0 : bl.getSoLuotThich()) + 1);
            binhLuanRepository.save(bl);

            response.put("thanhCong", true);
            response.put("soLuongLike", bl.getSoLuotThich());
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", "Lỗi: " + e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    // =============================
    // 5. REPORT BÌNH LUẬN
    // =============================
    @PostMapping("/binh-luan/{maBL}/report")
    public ResponseEntity<Map<String, Object>> reportBinhLuan(@PathVariable Long maBL) {
        Map<String, Object> response = new HashMap<>();
        try {
            if (maBL == null) throw new IllegalArgumentException("maBL is null");
            BinhLuan bl = binhLuanRepository.findById(maBL)
                    .orElseThrow(() -> new RuntimeException("Bình luận không tồn tại"));

            bl.incrementReport();
            binhLuanRepository.save(bl);

            response.put("thanhCong", true);
            response.put("thongBao", "Đã báo cáo bình luận. Quản trị viên sẽ xem xét.");
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", "Lỗi: " + e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    // =============================
    // HELPER: Build DTO từ BaiViet
    // =============================
    private Map<String, Object> buildBaiVietDTO(BaiViet bv, boolean includeFullContent) {
        Map<String, Object> dto = new HashMap<>();
        dto.put("maBV", bv.getMaBV());
        dto.put("tieuDe", bv.getTieuDe());
        String hinhAnh = bv.getHinhAnh();
        if (hinhAnh != null && !hinhAnh.startsWith("http") && !hinhAnh.startsWith("/")) {
            hinhAnh = "/uploads/blogs/" + hinhAnh;
        }
        dto.put("hinhAnh", hinhAnh);
        dto.put("luotXem", bv.getLuotXem());
        dto.put("ngayDang", bv.getNgayDang());
        dto.put("slug", bv.getSlug());
        dto.put("tomTat", bv.getTomTat());
        dto.put("loaiBaiViet", bv.getLoaiBaiViet() != null ? Map.of("maLoaiBV", bv.getLoaiBaiViet().getMaLoaiBV(),
                "tenLoaiBV", bv.getLoaiBaiViet().getTenLoaiBV()) : null);

        if (bv.getTaiKhoan() != null) {
            dto.put("tacGia", bv.getTaiKhoan().getHoTen());
        } else {
            dto.put("tacGia", "Luxury Fashion");
        }

        if (includeFullContent) {
            dto.put("noiDung", bv.getNoiDung());
        }

        return dto;
    }
}
