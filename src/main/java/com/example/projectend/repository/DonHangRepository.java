package com.example.projectend.repository;

import com.example.projectend.entity.DonHang;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * REPOSITORY ĐƠN HÀNG - FIXED
 */
@Repository
public interface DonHangRepository extends JpaRepository<DonHang, Long> {

    // Tìm đơn hàng theo khách hàng
    List<DonHang> findByTaiKhoan_MaTKOrderByNgayDatDesc(Long maTK);

    // Tìm đơn hàng theo ID và khách hàng
    Optional<DonHang> findByMaDHAndTaiKhoan_MaTK(Long maDH, Long maTK);

    // Tìm đơn hàng theo trạng thái
    List<DonHang> findByTrangThaiDHOrderByNgayDatDesc(Integer trangThai);

    // Lấy tất cả đơn hàng sắp xếp theo ngày đặt
    List<DonHang> findAllByOrderByNgayDatDesc();

    // Lấy tất cả đơn hàng với phân trang
    Page<DonHang> findAllByOrderByNgayDatDesc(Pageable pageable);

    // Đếm số đơn hàng
    long count();

    // Đếm số đơn hàng theo trạng thái
    long countByTrangThaiDH(Integer trangThai);

    // ================= BỔ SUNG CHO TÌM KIẾM ADMIN =================
    Page<DonHang> findByTrangThaiDHOrderByNgayDatDesc(Integer trangThai, Pageable pageable);
    Page<DonHang> findByTaiKhoan_EmailContainingIgnoreCaseOrderByNgayDatDesc(String email, Pageable pageable);
    Page<DonHang> findByTrangThaiDHAndTaiKhoan_EmailContainingIgnoreCaseOrderByNgayDatDesc(Integer trangThai, String email, Pageable pageable);
}
