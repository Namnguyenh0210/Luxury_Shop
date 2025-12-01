package com.example.projectend.repository;

import com.example.projectend.entity.PhieuNhap;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

@Repository
public interface PhieuNhapRepository extends JpaRepository<PhieuNhap, Long> {
    // Bạn có thể thêm hàm tìm kiếm hoặc sắp xếp ở đây nếu cần sau này
    // Ví dụ: List<PhieuNhap> findAllByOrderByNgayNhapDesc();
    long countByNgayNhapBetween(LocalDateTime start, LocalDateTime end);
}