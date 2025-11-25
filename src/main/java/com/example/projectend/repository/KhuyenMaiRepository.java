package com.example.projectend.repository;

import com.example.projectend.entity.KhuyenMai;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface KhuyenMaiRepository extends JpaRepository<KhuyenMai, Long> {

    /**
     * Tìm khuyến mãi theo mã code
     */
    Optional<KhuyenMai> findByMaCode(String maCode);

    /**
     * Lấy tất cả khuyến mãi đang hoạt động
     */
    @Query("SELECT km FROM KhuyenMai km WHERE km.trangThai = true AND km.ngayBatDau <= :now AND (km.ngayKetThuc IS NULL OR km.ngayKetThuc >= :now)")
    List<KhuyenMai> findActivePromotions(@Param("now") LocalDateTime now);

    /**
     * Kiểm tra sản phẩm có khuyến mãi không
     */
    @Query("SELECT km FROM KhuyenMai km JOIN KhuyenMaiChiTiet kmct ON km.maKM = kmct.khuyenMai.maKM " +
           "WHERE kmct.sanPham.maSP = :maSP AND km.trangThai = true " +
           "AND km.ngayBatDau <= :now AND (km.ngayKetThuc IS NULL OR km.ngayKetThuc >= :now)")
    List<KhuyenMai> findActivePromotionsByProduct(@Param("maSP") Long maSP, @Param("now") LocalDateTime now);
}

