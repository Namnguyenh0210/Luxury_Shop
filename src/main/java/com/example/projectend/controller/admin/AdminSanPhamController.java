package com.example.projectend.controller.admin;

import com.example.projectend.entity.SanPham;
import com.example.projectend.service.SanPhamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/admin/products")
@PreAuthorize("hasAnyRole('ADMIN', 'NHANVIEN')")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
@org.springframework.transaction.annotation.Transactional(readOnly = true)
public class AdminSanPhamController {

    @Autowired
    private SanPhamService sanPhamService;

    @Autowired
    private com.example.projectend.repository.SizeSPRepository sizeRepository;

    @Autowired
    private com.example.projectend.repository.MauSacSPRepository colorRepository;

    @Autowired
    private com.example.projectend.repository.SanPhamChiTietRepository sanPhamChiTietRepository;

    @GetMapping("/sizes")
    public List<com.example.projectend.entity.SizeSP> getAllSizes() {
        List<com.example.projectend.entity.SizeSP> sizes = sizeRepository.findAll();
        java.util.List<String> sizeOrder = java.util.Arrays.asList("S", "M", "L", "XL", "XXL", "2XL", "3XL");
        sizes.sort((s1, s2) -> {
            int i1 = sizeOrder.indexOf(s1.getTenSize().toUpperCase());
            int i2 = sizeOrder.indexOf(s2.getTenSize().toUpperCase());
            if (i1 == -1 && i2 == -1) return s1.getTenSize().compareToIgnoreCase(s2.getTenSize());
            if (i1 == -1) return 1;
            if (i2 == -1) return -1;
            return Integer.compare(i1, i2);
        });
        return sizes;
    }

    @GetMapping("/colors")
    public List<com.example.projectend.entity.MauSacSP> getAllColors() {
        return colorRepository.findAll();
    }

    // =============================
    // LAY DANH SACH
    // =============================
    @GetMapping
    public List<SanPham> getAllProducts(@RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Long brandId,
            @RequestParam(required = false) Integer gioiTinh,
            @RequestParam(required = false) Integer status) {
        org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(0, 1000,
                org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC, "maSP"));
        List<SanPham> products = sanPhamService
                .findWithFilters(keyword, categoryId, gioiTinh, brandId, null, null, status, null, pageable)
                .getContent();
        if (!products.isEmpty()) {
            java.util.Map<Long, com.example.projectend.service.SanPhamService.PriceStockInfo> statsMap = sanPhamService
                    .buildPriceStockMap(products);
            for (SanPham p : products) {
                if (statsMap.containsKey(p.getMaSP())) {
                    p.setTotalStock(statsMap.get(p.getMaSP()).getTotalStock());
                }
                p.getVariants().size();
            }
        }
        return products;
    }

    // =============================
    // LAY CHI TIET
    // =============================
    @GetMapping("/{id}")
    public SanPham getProduct(@PathVariable Long id) {
        SanPham product = sanPhamService.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay san pham"));
        java.util.List<com.example.projectend.entity.SanPhamChiTiet> variants =
                sanPhamChiTietRepository.findBySanPham_MaSP(id);
        product.setVariants(variants);
        return product;
    }

    // =============================
    // THEM / CAP NHAT
    // =============================
    @PostMapping
    @org.springframework.transaction.annotation.Transactional(readOnly = false)
    public SanPham saveProduct(@RequestBody SanPham product) {
        if (product.getMaSP() == null) {
            product.setNgayTao(LocalDateTime.now());
            if (product.getTrangThaiSP() == null)
                product.setTrangThaiSP(1);
        } else {
            product.setNgayCapNhat(LocalDateTime.now());
        }
        return sanPhamService.save(product);
    }

    // =============================
    // AN / HIEN SAN PHAM (AN TOAN - Endpoint rieng, chi can ID + trang thai)
    // =============================
    @PatchMapping("/{id}/status")
    @org.springframework.transaction.annotation.Transactional(readOnly = false)
    public SanPham toggleStatus(@PathVariable Long id, @RequestBody java.util.Map<String, Integer> body) {
        SanPham product = sanPhamService.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay san pham: " + id));
        Integer newStatus = body.get("trangThaiSP");
        if (newStatus != null) {
            product.setTrangThaiSP(newStatus);
            product.setNgayCapNhat(LocalDateTime.now());
        }
        return sanPhamService.save(product);
    }

    // =============================
    // XOA AN TOAN (Xoa bien the truoc de tranh loi Foreign Key)
    // =============================
    @DeleteMapping("/{id}")
    @org.springframework.transaction.annotation.Transactional(readOnly = false)
    public void deleteProduct(@PathVariable Long id) {
        sanPhamService.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay san pham: " + id));
        // Xoa bien the truoc
        sanPhamChiTietRepository.deleteBySanPham_MaSP(id);
        // Sau do xoa san pham
        sanPhamService.deleteById(id);
    }
}