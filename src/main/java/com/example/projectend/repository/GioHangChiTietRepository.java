package com.example.projectend.repository;

import com.example.projectend.entity.GioHangChiTiet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * REPOSITORY GIO HANG CHI TIET - LUXURY FASHION
 */
@Repository
public interface GioHangChiTietRepository extends JpaRepository<GioHangChiTiet, Long> {

    // Lấy tất cả items trong giỏ hàng
    List<GioHangChiTiet> findByGioHang_MaGioHang(Long maGioHang);

    // Tìm item cụ thể trong giỏ (để update số lượng)
    Optional<GioHangChiTiet> findByGioHang_MaGioHangAndSanPhamChiTiet_MaBienThe(Long maGioHang, Long maBienThe);

    // Xóa tất cả items trong giỏ hàng (sau khi đặt hàng)
    void deleteByGioHang_MaGioHang(Long maGioHang);

    // Đếm số lượng items trong giỏ
    long countByGioHang_MaGioHang(Long maGioHang);
}

