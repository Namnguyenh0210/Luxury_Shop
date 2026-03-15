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
        // Kiểm tra xem danh mục có sản phẩm nào không
        long count = sanPhamRepository.countByLoaiSanPham_MaLoai(id);
        if (count > 0) {
            throw new RuntimeException("Chỉ được xóa danh mục khi tổng số lượng sản phẩm bằng 0. Danh mục này đang có " + count + " sản phẩm.");
        }

        // Xóa danh mục
        repo.deleteById(id);
    }
}
