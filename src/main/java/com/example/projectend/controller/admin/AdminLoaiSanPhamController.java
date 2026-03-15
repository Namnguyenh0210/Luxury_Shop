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

    @Autowired
    private com.example.projectend.repository.SanPhamRepository sanPhamRepository;

    @GetMapping
    public List<LoaiSanPham> getAllCategories() {
        List<LoaiSanPham> categories = loaiSanPhamService.findAll();
        for (LoaiSanPham c : categories) {
            c.setCountNam(sanPhamRepository.countByLoaiSanPham_MaLoaiAndGioiTinh(c.getMaLoai(), 0));
            c.setCountNu(sanPhamRepository.countByLoaiSanPham_MaLoaiAndGioiTinh(c.getMaLoai(), 1));
            c.setCountUnisex(sanPhamRepository.countByLoaiSanPham_MaLoaiAndGioiTinh(c.getMaLoai(), 2));
        }
        return categories;
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
