// Bổ sung vào file DonHangChiTietRepository.java
package com.example.projectend.repository;

import com.example.projectend.entity.DonHangChiTiet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

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

    @Query("SELECT COALESCE(SUM(d.soLuong), 0) FROM DonHangChiTiet d")
    Long countTotalSold();
}
