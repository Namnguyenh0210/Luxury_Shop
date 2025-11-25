package com.example.projectend.repository;

import com.example.projectend.entity.KhuyenMaiChiTiet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface KhuyenMaiChiTietRepository extends JpaRepository<KhuyenMaiChiTiet, Long> {

    /**
     * Lấy tất cả chi tiết khuyến mãi theo mã khuyến mãi
     */
    List<KhuyenMaiChiTiet> findByKhuyenMai_MaKM(Long maKM);

    /**
     * Lấy tất cả chi tiết khuyến mãi theo sản phẩm
     */
    List<KhuyenMaiChiTiet> findBySanPham_MaSP(Long maSP);
}

