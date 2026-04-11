package com.example.projectend.repository;

import com.example.projectend.entity.TaiKhoan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.time.LocalDateTime;

/**
 * REPOSITORY TAI KHOAN - LUXURY FASHION
 */
@Repository
public interface TaiKhoanRepository extends JpaRepository<TaiKhoan, Long> {

    // Tìm theo email (dùng cho login)
    Optional<TaiKhoan> findByEmail(String email);

    // Tìm theo số điện thoại (dùng cho login)
    Optional<TaiKhoan> findBySoDienThoai(String soDienThoai);

    // Kiểm tra email đã tồn tại (dùng cho đăng ký)
    boolean existsByEmail(String email);

    // Lấy danh sách tài khoản active
    List<TaiKhoan> findByTrangThaiTrue();

    // Tìm kiếm tài khoản theo tên hoặc email
    @Query("SELECT t FROM TaiKhoan t WHERE t.hoTen LIKE %:keyword% OR t.email LIKE %:keyword%")
    List<TaiKhoan> searchByKeyword(@Param("keyword") String keyword);

    Long countByNgayTaoBetween(LocalDateTime startDate, LocalDateTime endDate);

    @Query("SELECT COUNT(t) FROM TaiKhoan t JOIN t.vaiTros r WHERE r.tenVaiTro LIKE '%USER%'")
    long countUsersOnly();

    @Query("SELECT COUNT(t) FROM TaiKhoan t JOIN t.vaiTros r WHERE r.tenVaiTro LIKE '%USER%' AND t.ngayTao >= :startDate AND t.ngayTao <= :endDate")
    long countUsersByNgayTaoBetween(@Param("startDate") java.time.LocalDateTime startDate,
            @Param("endDate") java.time.LocalDateTime endDate);
}
