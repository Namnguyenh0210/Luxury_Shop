package com.example.projectend.controller.admin;

import com.example.projectend.entity.BaiViet;
import com.example.projectend.entity.LoaiBaiViet;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.BaiVietRepository;
import com.example.projectend.repository.LoaiBaiVietRepository;
import com.example.projectend.service.auth.UserDetailsServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.*;

/**
 * Admin API - Quản lý bài viết blog
 */
@RestController
@RequestMapping("/api/admin/blogs")
@PreAuthorize("hasRole('ADMIN') or hasRole('NHANVIEN')")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
@Transactional
public class AdminBaiVietController {

    @Autowired
    private BaiVietRepository baiVietRepository;

    @Autowired
    private LoaiBaiVietRepository loaiBaiVietRepository;

    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    // Lấy tất cả bài viết (admin thấy cả bản nháp)
    @GetMapping
    public ResponseEntity<Map<String, Object>> getAll() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<BaiViet> danhSach = baiVietRepository.findAll();
            List<Map<String, Object>> result = new ArrayList<>();

            for (BaiViet bv : danhSach) {
                Map<String, Object> dto = new HashMap<>();
                dto.put("maBV", bv.getMaBV());
                dto.put("id", bv.getMaBV());
                dto.put("tieuDe", bv.getTieuDe());
                dto.put("hinhAnh", bv.getHinhAnh());
                dto.put("trangThai", bv.getTrangThai());
                dto.put("luotXem", bv.getLuotXem());
                dto.put("ngayDang", bv.getNgayDang());
                dto.put("ngayTao", bv.getNgayDang());
                dto.put("slug", bv.getSlug());
                dto.put("tomTat", bv.getTomTat());
                dto.put("tacGia", bv.getTaiKhoan() != null ? bv.getTaiKhoan().getHoTen() : "Admin");
                dto.put("loaiBaiViet",
                        bv.getLoaiBaiViet() != null ? Map.of("maLoaiBV", bv.getLoaiBaiViet().getMaLoaiBV(),
                                "tenLoaiBV", bv.getLoaiBaiViet().getTenLoaiBV(),
                                "tenLoai", bv.getLoaiBaiViet().getTenLoaiBV()) : null);
                result.add(dto);
            }

            response.put("thanhCong", true);
            response.put("danhSach", result);

            List<Map<String, Object>> loaiBaiVietList = new ArrayList<>();
            for (LoaiBaiViet l : loaiBaiVietRepository.findAll()) {
                Map<String, Object> lMap = new HashMap<>();
                lMap.put("maLoaiBV", l.getMaLoaiBV());
                lMap.put("tenLoaiBV", l.getTenLoaiBV());
                loaiBaiVietList.add(lMap);
            }
            response.put("loaiBaiViet", loaiBaiVietList);
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    // Lấy chi tiết một bài viết
    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getOne(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            BaiViet bv = baiVietRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bài viết"));

            Map<String, Object> dto = new HashMap<>();
            dto.put("maBV", bv.getMaBV());
            dto.put("id", bv.getMaBV());
            dto.put("tieuDe", bv.getTieuDe());
            dto.put("noiDung", bv.getNoiDung());
            dto.put("hinhAnh", bv.getHinhAnh());
            dto.put("trangThai", bv.getTrangThai());
            dto.put("luotXem", bv.getLuotXem());
            dto.put("ngayDang", bv.getNgayDang());
            dto.put("slug", bv.getSlug());
            dto.put("maLoaiBV", bv.getLoaiBaiViet() != null ? bv.getLoaiBaiViet().getMaLoaiBV() : null);
            dto.put("loaiBaiViet", bv.getLoaiBaiViet() != null ? Map.of("maLoaiBV", bv.getLoaiBaiViet().getMaLoaiBV(),
                    "tenLoaiBV", bv.getLoaiBaiViet().getTenLoaiBV()) : null);

            response.put("thanhCong", true);
            response.put("baiViet", dto);
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    // Thêm bài viết mới
    @PostMapping
    public ResponseEntity<Map<String, Object>> create(@RequestBody Map<String, Object> body) {
        Map<String, Object> response = new HashMap<>();
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            TaiKhoan taiKhoan = userDetailsService.getTaiKhoanByEmail(auth.getName());

            BaiViet bv = new BaiViet();
            bv.setTieuDe((String) body.get("tieuDe"));
            bv.setNoiDung((String) body.get("noiDung"));
            bv.setHinhAnh((String) body.get("hinhAnh"));
            bv.setTrangThai(body.get("trangThai") == null || Boolean.TRUE.equals(body.get("trangThai")));
            bv.setNgayDang(LocalDateTime.now());
            bv.setTaiKhoan(taiKhoan);
            bv.setLuotXem(0);

            // Tạo slug tự động từ tiêu đề
            String slug = taoSlug((String) body.get("tieuDe"));
            bv.setSlug(slug + "-" + System.currentTimeMillis());

            // Set loại bài viết
            if (body.get("maLoaiBV") != null) {
                Long maLoaiBV = Long.valueOf(body.get("maLoaiBV").toString());
                loaiBaiVietRepository.findById(maLoaiBV).ifPresent(bv::setLoaiBaiViet);
            }

            BaiViet saved = baiVietRepository.save(bv);

            response.put("thanhCong", true);
            response.put("thongBao", "Đăng bài viết thành công!");
            response.put("maBV", saved.getMaBV());
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", "Lỗi khi lưu bài viết: " + e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    // Thêm Loại Bài Viết Mới
    @PostMapping("/categories")
    public ResponseEntity<Map<String, Object>> createCategory(@RequestBody Map<String, String> body) {
        Map<String, Object> response = new HashMap<>();
        try {
            String tenLoaiBV = body.get("tenLoaiBV");
            if (tenLoaiBV == null || tenLoaiBV.trim().isEmpty()) {
                throw new RuntimeException("Tên loại bài viết không được để trống!");
            }
            LoaiBaiViet loaiBaiViet = new LoaiBaiViet();
            loaiBaiViet.setTenLoaiBV(tenLoaiBV.trim());
            LoaiBaiViet saved = loaiBaiVietRepository.save(loaiBaiViet);

            response.put("thanhCong", true);
            response.put("thongBao", "Thêm loại bài viết thành công!");
            response.put("loaiBaiViet", Map.of(
                    "maLoaiBV", saved.getMaLoaiBV(),
                    "tenLoaiBV", saved.getTenLoaiBV()));
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    // Cập nhật bài viết
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> update(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body) {
        Map<String, Object> response = new HashMap<>();
        try {
            BaiViet bv = baiVietRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bài viết"));

            if (body.get("tieuDe") != null)
                bv.setTieuDe((String) body.get("tieuDe"));
            if (body.get("noiDung") != null)
                bv.setNoiDung((String) body.get("noiDung"));
            if (body.get("hinhAnh") != null)
                bv.setHinhAnh((String) body.get("hinhAnh"));
            if (body.get("trangThai") != null)
                bv.setTrangThai(Boolean.TRUE.equals(body.get("trangThai")));

            if (body.get("maLoaiBV") != null) {
                Long maLoaiBV = Long.valueOf(body.get("maLoaiBV").toString());
                loaiBaiVietRepository.findById(maLoaiBV).ifPresent(bv::setLoaiBaiViet);
            }

            baiVietRepository.save(bv);

            response.put("thanhCong", true);
            response.put("thongBao", "Cập nhật bài viết thành công!");
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", "Lỗi: " + e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    // Xóa bài viết
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> delete(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            BaiViet bv = baiVietRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy"));

            // ✅ XÓA FILE ẢNH
            if (bv.getHinhAnh() != null) {
                String fileName = bv.getHinhAnh().substring(bv.getHinhAnh().lastIndexOf("/") + 1);
                Path path = Paths.get("uploads/blogs/" + fileName);
                Files.deleteIfExists(path);
            }

            // ✅ XÓA DB
            baiVietRepository.deleteById(id);

            response.put("thanhCong", true);
            response.put("thongBao", "Đã xóa bài viết + ảnh!");
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    @PostMapping("/upload/{id}")
    public ResponseEntity<?> uploadAnh(
            @PathVariable Long id,
            @RequestParam("file") MultipartFile file) {

        try {
            String fileName = "baiviet_" + id + ".jpg";
            Path path = Paths.get("uploads/blogs/" + fileName);

            Files.createDirectories(path.getParent());
            Files.write(path, file.getBytes());

            String url = "http://localhost:8080/uploads/blogs/" + fileName;

            BaiViet bv = baiVietRepository.findById(id).orElseThrow();
            bv.setHinhAnh(url);
            baiVietRepository.save(bv);

            return ResponseEntity.ok(Map.of(
                    "thanhCong", true,
                    "hinhAnh", url
            ));

        } catch (Exception e) {
            return ResponseEntity.ok(Map.of(
                    "thanhCong", false,
                    "thongBao", e.getMessage()
            ));
        }
    }
    
    // Helper: tạo slug từ tiêu đề
    private String taoSlug(String tieuDe) {
        if (tieuDe == null)
            return "bai-viet";
        String slug = tieuDe.toLowerCase()
                .replaceAll("[àáảãạăắặằẳẵâấầẩẫậ]", "a")
                .replaceAll("[èéẻẽẹêếềểễệ]", "e")
                .replaceAll("[ìíỉĩị]", "i")
                .replaceAll("[òóỏõọôốồổỗộơớờởỡợ]", "o")
                .replaceAll("[ùúủũụưứừửữự]", "u")
                .replaceAll("[ỳýỷỹỵ]", "y")
                .replaceAll("[đ]", "d")
                .replaceAll("[^a-z0-9\\s-]", "")
                .replaceAll("[\\s]+", "-")
                .replaceAll("-+", "-")
                .replaceAll("^-|-$", "");
        return slug.isEmpty() ? "bai-viet" : slug;
    }
    
}