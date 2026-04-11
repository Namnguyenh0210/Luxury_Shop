// Bổ sung vào file DonHangChiTietRepository.java
package com.example.projectend.repository;

import com.example.projectend.entity.DonHangChiTiet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.time.LocalDateTime;
import org.springframework.data.repository.query.Param;

/**
 * REPOSITORY DON HANG CHI TIET - LUXURY FASHION
 */
@Repository
public interface DonHangChiTietRepository extends JpaRepository<DonHangChiTiet, Long> {

    // Lấy chi tiết đơn hàng
    List<DonHangChiTiet> findByDonHang_MaDH(Long maDH);
    
    // Lấy chi tiết đơn hàng của user + trạng thái đơn + sản phẩm cụ thể (dùng cho đánh giá)
    List<DonHangChiTiet> findByDonHang_TaiKhoan_MaTKAndDonHang_TrangThaiDHAndSanPhamChiTiet_SanPham_MaSP(
            Long maTK, Integer trangThaiDH, Long maSP);

    @Query("SELECT COALESCE(SUM(d.soLuong), 0) FROM DonHangChiTiet d WHERE d.donHang.trangThaiDH IN (4, 6)")
    Long countTotalSold();

    @Query("SELECT COALESCE(SUM(d.soLuong), 0) FROM DonHangChiTiet d WHERE d.donHang.trangThaiDH IN (4, 6) AND d.donHang.ngayDat >= :startDate AND d.donHang.ngayDat <= :endDate")
    Long countTotalSoldBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
}
