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
public class AdminSanPhamController {

    @Autowired
    private SanPhamService sanPhamService;

    @Autowired
    private com.example.projectend.repository.SizeSPRepository sizeRepository;

    @Autowired
    private com.example.projectend.repository.MauSacSPRepository colorRepository;

    @GetMapping("/sizes")
    public List<com.example.projectend.entity.SizeSP> getAllSizes() {
        return sizeRepository.findAll();
    }

    @GetMapping("/colors")
    public List<com.example.projectend.entity.MauSacSP> getAllColors() {
        return colorRepository.findAll();
    }

    // =============================
    // LẤY DANH SÁCH
    // Sử dụng hàm findAll() đã có sẵn trong Service của bạn
    // =============================
    @GetMapping
    public List<SanPham> getAllProducts(@RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Long brandId,
            @RequestParam(required = false) Integer gioiTinh,
            @RequestParam(required = false) Integer status) {
        // BỔ SUNG DÒNG NÀY: Khởi tạo pageable để lấy dữ liệu trang đầu tiên và sắp xếp
        // mới nhất lên đầu
        org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(0, 1000,
                org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC, "maSP"));

        // Gọi hàm có sẵn trong Service của bạn
        List<SanPham> products = sanPhamService
                .findWithFilters(keyword, categoryId, gioiTinh, brandId, null, null, status, null, pageable)
                .getContent();

        // Populate total stock for Each product
        if (!products.isEmpty()) {
            java.util.Map<Long, com.example.projectend.service.SanPhamService.PriceStockInfo> statsMap = sanPhamService
                    .buildPriceStockMap(products);
            for (SanPham p : products) {
                if (statsMap.containsKey(p.getMaSP())) {
                    p.setTotalStock(statsMap.get(p.getMaSP()).getTotalStock());
                }
            }
        }

        return products;
    }

    // =============================
    // LẤY CHI TIẾT
    // =============================
    @GetMapping("/{id}")
    public SanPham getProduct(@PathVariable Long id) {
        // Service của bạn đã có hàm findById
        return sanPhamService.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sản phẩm"));
    }

    // =============================
    // THÊM / CẬP NHẬT
    // =============================
    @PostMapping
    public SanPham saveProduct(@RequestBody SanPham product) {
        // Logic xử lý ngày tạo và trạng thái
        if (product.getMaSP() == null) {
            product.setNgayTao(LocalDateTime.now());
            if (product.getTrangThaiSP() == null)
                product.setTrangThaiSP(1);
        } else {
            product.setNgayCapNhat(LocalDateTime.now());
        }

        // Service của bạn đã có hàm save
        return sanPhamService.save(product);
    }

    // =============================
    // XÓA
    // =============================
    @DeleteMapping("/{id}")
    public void deleteProduct(@PathVariable Long id) {
        // Service của bạn đã có hàm deleteById
        sanPhamService.deleteById(id);
    }
}