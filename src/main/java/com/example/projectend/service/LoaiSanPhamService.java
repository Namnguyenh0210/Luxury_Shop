package com.example.projectend.service;

import com.example.projectend.entity.LoaiSanPham;
import com.example.projectend.repository.LoaiSanPhamRepository;
import com.example.projectend.repository.SanPhamRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Service quản lý danh mục sản phẩm
 */
@Service
public class LoaiSanPhamService {

    @Autowired
    private LoaiSanPhamRepository repo;

    @Autowired
    private SanPhamRepository sanPhamRepository;

    /**
     * Lấy tất cả danh mục sản phẩm
     */
    public List<LoaiSanPham> findAll() {
        return repo.findAll();
    }

    public Optional<LoaiSanPham> findById(Long id) {
        return repo.findById(id);
    }

    public LoaiSanPham save(LoaiSanPham loai) {
        return repo.save(loai);
    }

    @Transactional
    public void deleteById(Long id) {
        // 1. Tìm hoặc tạo danh mục "Chưa phân loại"
        LoaiSanPham uncategorized = repo.findByTenLoai("Chưa phân loại")
                .orElseGet(() -> {
                    LoaiSanPham lsp = new LoaiSanPham();
                    lsp.setTenLoai("Chưa phân loại");
                    lsp.setMoTa("Sản phẩm chưa được phân vào danh mục nào");
                    lsp.setTrangThai(1);
                    return repo.save(lsp);
                });

        // Nếu ID cần xóa trùng với ID "Chưa phân loại" thì không thể xóa (hoặc xử lý khác)
        if (uncategorized.getMaLoai().equals(id)) {
            throw new RuntimeException("Không thể xóa danh mục mặc định");
        }

        // 2. Cập nhật tất cả sản phẩm của danh mục cũ sang danh mục mới
        sanPhamRepository.updateCategory(id, uncategorized);

        // 3. Xóa danh mục
        repo.deleteById(id);
    }
}
