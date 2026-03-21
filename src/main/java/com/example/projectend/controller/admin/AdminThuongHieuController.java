package com.example.projectend.controller.admin;

import com.example.projectend.entity.ThuongHieu;
import com.example.projectend.service.ThuongHieuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/brands")
@PreAuthorize("hasAnyRole('ADMIN', 'NHANVIEN')")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class AdminThuongHieuController {

    @Autowired
    private ThuongHieuService thuongHieuService;

    @Autowired
    private com.example.projectend.repository.SanPhamRepository sanPhamRepository;

    @GetMapping
    public List<ThuongHieu> getAllBrands() {
        List<ThuongHieu> brands = thuongHieuService.findAll();
        for (ThuongHieu b : brands) {
            b.setCountNam(sanPhamRepository.countByThuongHieu_MaTHAndGioiTinh(b.getMaTH(), 0));
            b.setCountNu(sanPhamRepository.countByThuongHieu_MaTHAndGioiTinh(b.getMaTH(), 1));
            b.setCountUnisex(sanPhamRepository.countByThuongHieu_MaTHAndGioiTinh(b.getMaTH(), 2));
        }
        return brands;
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
    
    @PutMapping("/{id}/toggle-status")
    public ThuongHieu toggleStatus(@PathVariable Long id) {
        ThuongHieu th = thuongHieuService.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thương hiệu"));

        // đảo trạng thái
        th.setTrangThai(th.getTrangThai() == 1 ? 0 : 1);

        return thuongHieuService.save(th);
    }
}
