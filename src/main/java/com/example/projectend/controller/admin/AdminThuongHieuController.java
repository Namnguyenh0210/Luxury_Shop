package com.example.projectend.controller.admin;

import com.example.projectend.entity.ThuongHieu;
import com.example.projectend.service.ThuongHieuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/brands")
@PreAuthorize("hasRole('ADMIN')")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class AdminThuongHieuController {

    @Autowired
    private ThuongHieuService thuongHieuService;

    @GetMapping
    public List<ThuongHieu> getAllBrands() {
        return thuongHieuService.findAll();
    }

    @GetMapping("/{id}")
    public ThuongHieu getBrand(@PathVariable Long id) {
        return thuongHieuService.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thương hiệu"));
    }

    @PostMapping
    public ThuongHieu saveBrand(@RequestBody ThuongHieu brand) {
        return thuongHieuService.save(brand);
    }

    @DeleteMapping("/{id}")
    public void deleteBrand(@PathVariable Long id) {
        thuongHieuService.deleteById(id);
    }
}
