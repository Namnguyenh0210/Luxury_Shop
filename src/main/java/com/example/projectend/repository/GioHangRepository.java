package com.example.projectend.repository;

import com.example.projectend.entity.GioHang;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * REPOSITORY GIO HANG - LUXURY FASHION
 */
@Repository
public interface GioHangRepository extends JpaRepository<GioHang, Long> {

    // Tìm giỏ hàng theo user
    Optional<GioHang> findByTaiKhoan_MaTK(Long maTK);

    // Kiểm tra user đã có giỏ hàng chưa
    boolean existsByTaiKhoan_MaTK(Long maTK);
}
