package com.example.projectend.repository;

import com.example.projectend.entity.PhuongThucThanhToan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * REPOSITORY PHUONG THUC THANH TOAN - LUXURY FASHION
 */
@Repository
public interface PhuongThucThanhToanRepository extends JpaRepository<PhuongThucThanhToan, Long> {

    // Lấy các phương thức đang hoạt động
    List<PhuongThucThanhToan> findByTrangThai(Boolean trangThai);
}
