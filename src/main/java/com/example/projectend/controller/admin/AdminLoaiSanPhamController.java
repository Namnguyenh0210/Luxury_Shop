package com.example.projectend.controller.admin;

import com.example.projectend.entity.LoaiSanPham;
import com.example.projectend.service.LoaiSanPhamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/categories")
@PreAuthorize("hasRole('ADMIN')")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class AdminLoaiSanPhamController {

    @Autowired
    private LoaiSanPhamService loaiSanPhamService;

    @GetMapping
    public List<LoaiSanPham> getAllCategories() {
        return loaiSanPhamService.findAll();
    }

    @GetMapping("/{id}")
    public LoaiSanPham getCategory(@PathVariable Long id) {
        return loaiSanPhamService.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy danh mục"));
    }

    @PostMapping
    public LoaiSanPham saveCategory(@RequestBody LoaiSanPham category) {
        return loaiSanPhamService.save(category);
    }

    @DeleteMapping("/{id}")
    public void deleteCategory(@PathVariable Long id) {
        loaiSanPhamService.deleteById(id);
    }
}
