package com.example.projectend.repository;

import com.example.projectend.entity.SanPhamChiTiet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import jakarta.persistence.LockModeType;

@Repository
public interface SanPhamChiTietRepository extends JpaRepository<SanPhamChiTiet, Long> {

    // Lay tat ca bien the cua 1 san pham
    List<SanPhamChiTiet> findBySanPham_MaSP(Long maSP);

    // Tim bien the theo san pham + size + mau (tranh trung lap)
    Optional<SanPhamChiTiet> findBySanPhamAndSizeSPAndMauSacSP(
            com.example.projectend.entity.SanPham sanPham,
            com.example.projectend.entity.SizeSP sizeSP,
            com.example.projectend.entity.MauSacSP mauSacSP
    );

    // Lay gia re nhat cua 1 san pham
    @Query("SELECT MIN(spct.giaBan) FROM SanPhamChiTiet spct WHERE spct.sanPham.maSP = :maSP AND spct.trangThai = true")
    BigDecimal findMinPriceBySanPham(@Param("maSP") Long maSP);

    // Lay gia dat nhat cua 1 san pham
    @Query("SELECT MAX(spct.giaBan) FROM SanPhamChiTiet spct WHERE spct.sanPham.maSP = :maSP AND spct.trangThai = true")
    BigDecimal findMaxPriceBySanPham(@Param("maSP") Long maSP);

    // Lay tong ton kho cua 1 san pham
    @Query("SELECT SUM(spct.soLuongTon) FROM SanPhamChiTiet spct WHERE spct.sanPham.maSP = :maSP AND spct.trangThai = true")
    Integer findTotalStockBySanPham(@Param("maSP") Long maSP);

    // Lay bien the con hang dau tien
    Optional<SanPhamChiTiet> findTop1BySanPham_MaSPAndSoLuongTonGreaterThanAndTrangThaiTrueOrderBySoLuongTonDesc(Long maSP, Integer soLuongTon);

    // Lay ton kho hien tai truc tiep (tranh cache) - tra ve null neu khong co
    @Query(value = "SELECT SoLuongTon FROM SanPhamChiTiet WHERE MaBienThe = :id", nativeQuery = true)
    Integer findCurrentStockNative(@Param("id") Long maBienThe);

    // Khoa bi quan dong du lieu de tranh race condition
    @Lock(LockModeType.PESSIMISTIC_READ)
    @Query("SELECT spct FROM SanPhamChiTiet spct WHERE spct.maBienThe = :id")
    Optional<SanPhamChiTiet> findLockedById(@Param("id") Long maBienThe);

    // XOA TOAN BO BIEN THE CUA 1 SAN PHAM (dung truoc khi xoa san pham chinh)
    @Modifying
    @Transactional
    @Query("DELETE FROM SanPhamChiTiet spct WHERE spct.sanPham.maSP = :maSP")
    void deleteBySanPham_MaSP(@Param("maSP") Long maSP);

    interface PriceStockProjection {
        Long getMaSP();
        BigDecimal getMinPrice();
        BigDecimal getMaxPrice();
        Long getTotalStock(); // Change Integer to Long for SUM result
    }

    @Query("SELECT spct.sanPham.maSP as maSP, " +
           "MIN(spct.giaBan) as minPrice, " +
           "MAX(spct.giaBan) as maxPrice, " +
           "SUM(spct.soLuongTon) as totalStock " +
           "FROM SanPhamChiTiet spct " +
           "WHERE spct.sanPham.maSP IN :ids AND spct.trangThai = true " +
           "GROUP BY spct.sanPham.maSP")
    List<PriceStockProjection> aggregateForProducts(@Param("ids") List<Long> ids);
}
