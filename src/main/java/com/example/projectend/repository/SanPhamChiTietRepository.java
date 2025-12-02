package com.example.projectend.repository;

import com.example.projectend.entity.SanPhamChiTiet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.Lock;
import jakarta.persistence.LockModeType;

@Repository
public interface SanPhamChiTietRepository extends JpaRepository<SanPhamChiTiet, Long> {

    // Lấy tất cả biến thể của 1 sản phẩm
    List<SanPhamChiTiet> findBySanPham_MaSP(Long maSP);

    // Tìm biến thể theo sản phẩm + size + màu (tránh trùng lặp)
    Optional<SanPhamChiTiet> findBySanPhamAndSizeSPAndMauSacSP(
            com.example.projectend.entity.SanPham sanPham,
            com.example.projectend.entity.SizeSP sizeSP,
            com.example.projectend.entity.MauSacSP mauSacSP
    );

    // Lấy giá rẻ nhất của 1 sản phẩm
    @Query("SELECT MIN(spct.giaBan) FROM SanPhamChiTiet spct WHERE spct.sanPham.maSP = :maSP")
    BigDecimal findMinPriceBySanPham(@Param("maSP") Long maSP);

    // Lấy giá đắt nhất của 1 sản phẩm
    @Query("SELECT MAX(spct.giaBan) FROM SanPhamChiTiet spct WHERE spct.sanPham.maSP = :maSP")
    BigDecimal findMaxPriceBySanPham(@Param("maSP") Long maSP);

    // Lấy tổng tồn kho của 1 sản phẩm
    @Query("SELECT SUM(spct.soLuongTon) FROM SanPhamChiTiet spct WHERE spct.sanPham.maSP = :maSP")
    Integer findTotalStockBySanPham(@Param("maSP") Long maSP);

    // Lấy biến thể còn hàng đầu tiên của một sản phẩm
    java.util.Optional<SanPhamChiTiet> findTop1BySanPham_MaSPAndSoLuongTonGreaterThanOrderBySoLuongTonDesc(Long maSP, Integer soLuongTon);

    // Lấy tồn kho hiện tại trực tiếp (tránh cache) - trả về null nếu không có
    @Query(value = "SELECT SoLuongTon FROM SanPhamChiTiet WHERE MaBienThe = :id", nativeQuery = true)
    Integer findCurrentStockNative(@Param("id") Long maBienThe);

    // Khóa bi quan dòng dữ liệu để tránh race condition giữa nhiều phiên thêm vào giỏ
    @Lock(LockModeType.PESSIMISTIC_READ)
    @Query("SELECT spct FROM SanPhamChiTiet spct WHERE spct.maBienThe = :id")
    Optional<SanPhamChiTiet> findLockedById(@Param("id") Long maBienThe);

    interface PriceStockProjection {
        Long getMaSP();
        BigDecimal getMinPrice();
        BigDecimal getMaxPrice();
        Integer getTotalStock();
    }

    @Query("SELECT spct.sanPham.maSP as maSP, MIN(spct.giaBan) as minPrice, MAX(spct.giaBan) as maxPrice, SUM(spct.soLuongTon) as totalStock FROM SanPhamChiTiet spct WHERE spct.sanPham.maSP IN :ids GROUP BY spct.sanPham.maSP")
    List<PriceStockProjection> aggregateForProducts(@Param("ids") List<Long> ids);
}
