package com.example.projectend.repository;

import com.example.projectend.entity.LichSuDonHang;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * REPOSITORY CHO LỊCH SỬ ĐƠN HÀNG
 */
@Repository
public interface LichSuDonHangRepository extends JpaRepository<LichSuDonHang, Long> {

    /**
     * Lấy lịch sử theo đơn hàng, sắp xếp theo thời gian
     */
    List<LichSuDonHang> findByDonHang_MaDHOrderByThoiGianAsc(Long maDH);

    /**
     * Lấy lịch sử mới nhất của đơn hàng
     */
    LichSuDonHang findTopByDonHang_MaDHOrderByThoiGianDesc(Long maDH);
}

