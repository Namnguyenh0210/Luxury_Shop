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
    // =============================
    @GetMapping
    public List<SanPham> getAllProducts() {
        return sanPhamService.findAll();
    }

    // =============================
    // LẤY CHI TIẾT
    // =============================
    @GetMapping("/{id}")
    public SanPham getProduct(@PathVariable Long id) {
        return sanPhamService.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sản phẩm"));
    }

    // =============================
    // THÊM / CẬP NHẬT
    // =============================
    @PostMapping
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
    // XÓA
    // =============================
    @DeleteMapping("/{id}")
    public void deleteProduct(@PathVariable Long id) {
        sanPhamService.deleteById(id);
    }
}