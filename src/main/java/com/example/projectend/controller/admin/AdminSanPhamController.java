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
@PreAuthorize("hasRole('ADMIN')")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class AdminSanPhamController {

    @Autowired
    private SanPhamService sanPhamService;

    // =============================
    // LẤY DANH SÁCH
    // Sử dụng hàm findAll() đã có sẵn trong Service của bạn
    // =============================
    @GetMapping
    public List<SanPham> getAllProducts(@RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(required = false) Long brandId,
            @RequestParam(required = false) Integer status) {
    	// BỔ SUNG DÒNG NÀY: Khởi tạo pageable để lấy dữ liệu trang đầu tiên
        org.springframework.data.domain.Pageable pageable = org.springframework.data.domain.PageRequest.of(0, 1000);
        
        // Gọi hàm có sẵn trong Service của bạn
        return sanPhamService.findWithFilters(keyword, categoryId, null, brandId, null, null, null, pageable).getContent();
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