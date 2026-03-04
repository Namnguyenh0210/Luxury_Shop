package com.example.projectend.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.example.projectend.entity.SanPham;
import com.example.projectend.entity.SanPhamChiTiet;
import com.example.projectend.service.SanPhamService;
import com.example.projectend.repository.SanPhamChiTietRepository;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * SanPhamController — GET routes redirect về Vue SPA.
 * API endpoints (search, variants) giữ nguyên @ResponseBody.
 */
@Controller
public class SanPhamController {

    @Autowired
    private SanPhamService sanPhamService;
    @Autowired
    private SanPhamChiTietRepository sanPhamChiTietRepository;

    // ─── Vue SPA redirects ────────────────────────────────────────────

    @GetMapping("/sanpham")
    public String sanPham(HttpServletRequest req) {
        // Giữ nguyên query string (search, page, loai...) khi redirect
        String qs = req.getQueryString();
        String target = "http://localhost:5173/sanpham";
        if (qs != null && !qs.isEmpty())
            target += "?" + qs;
        return "redirect:" + target;
    }

    @GetMapping("/sanpham/{id}")
    public String chiTietSanPham(@PathVariable Long id) {
        return "redirect:http://localhost:5173/sanpham/" + id;
    }

    /** /nam, /nu, /unisex — redirect về Vue với query gioiTinh */
    @GetMapping({ "/nam", "/nu", "/unisex" })
    public String sanPhamTheoGioiTinh(HttpServletRequest req) {
        String uri = req.getRequestURI();
        String qs = req.getQueryString();
        String target = "http://localhost:5173" + uri;
        if (qs != null && !qs.isEmpty())
            target += "?" + qs;
        return "redirect:" + target;
    }

    /** /brand/{id} — redirect về Vue */
    @GetMapping("/brand/{id}")
    public String sanPhamTheoThuongHieu(@PathVariable Long id, HttpServletRequest req) {
        String qs = req.getQueryString();
        String target = "http://localhost:5173/sanpham?thuongHieu=" + id;
        if (qs != null && !qs.isEmpty())
            target += "&" + qs;
        return "redirect:" + target;
    }

    // ─── REST API (vẫn giữ, Vue dùng trực tiếp) ──────────────────────

    @GetMapping("/api/sanpham/search")
    @ResponseBody
    public List<SanPham> quickSearch(@RequestParam String q) {
        return sanPhamService.searchByKeyword(q, 10);
    }

    @GetMapping("/api/sanpham/{id}/variants")
    @ResponseBody
    public List<SanPhamChiTiet> getProductVariants(@PathVariable Long id) {
        return sanPhamChiTietRepository.findBySanPham_MaSP(id);
    }

    @GetMapping("/api/sanpham/{id}/available-variant")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getFirstAvailableVariant(@PathVariable Long id) {
        Optional<SanPham> spOpt = sanPhamService.findById(id);
        if (spOpt.isEmpty()) {
            return ResponseEntity.ok(Map.of("success", false, "message", "Sản phẩm không tồn tại"));
        }
        Optional<SanPhamChiTiet> variantOpt = sanPhamChiTietRepository
                .findTop1BySanPham_MaSPAndSoLuongTonGreaterThanOrderBySoLuongTonDesc(id, 0);
        if (variantOpt.isEmpty()) {
            return ResponseEntity.ok(Map.of("success", false, "message", "Sản phẩm tạm hết hàng"));
        }
        SanPhamChiTiet v = variantOpt.get();
        return ResponseEntity.ok(Map.of(
                "success", true,
                "variant", Map.of(
                        "maBienThe", v.getMaBienThe(),
                        "size", v.getSizeSP() != null ? v.getSizeSP().getTenSize() : null,
                        "mau", v.getMauSacSP() != null ? v.getMauSacSP().getTenMau() : null,
                        "giaBan", v.getGiaBan(),
                        "soLuongTon", v.getSoLuongTon())));
    }
}
