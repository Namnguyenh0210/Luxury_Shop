package com.example.projectend.repository;

import com.example.projectend.entity.DonHang;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import org.springframework.data.repository.query.Param;

/**
 * REPOSITORY ĐƠN HÀNG - FIXED
 */
@Repository
public interface DonHangRepository extends JpaRepository<DonHang, Long> {

    // COUNT FOR VOUCHER LOGIC
    @Query("SELECT COUNT(d) FROM DonHang d WHERE d.taiKhoan = :tk AND d.voucher = :v AND d.trangThaiDH != 5")
    long countByTaiKhoanAndVoucher(@Param("tk") com.example.projectend.entity.TaiKhoan tk, @Param("v") com.example.projectend.entity.Voucher v);

    @Query("SELECT COUNT(d) FROM DonHang d WHERE d.taiKhoan = :tk AND d.trangThaiDH != 5")
    long countByTaiKhoan(@Param("tk") com.example.projectend.entity.TaiKhoan tk);

    @Query("SELECT SUM(d.tongTien) FROM DonHang d WHERE d.taiKhoan.maTK = :maTK AND d.trangThaiDH = 4")
    BigDecimal sumTotalByTaiKhoan(@Param("maTK") Long maTK);

    List<DonHang> findTop10ByTrangThaiDHInOrderByNgayDatDesc(List<Integer> statuses);

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
    
    @Query("SELECT d FROM DonHang d JOIN d.taiKhoan e " +
           "WHERE (LOWER(e.hoTen) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(e.email) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
           "ORDER BY d.ngayDat DESC")
    Page<DonHang> findByKeyword(String keyword, Pageable pageable);

    @Query("SELECT d FROM DonHang d JOIN d.taiKhoan e " +
           "WHERE d.trangThaiDH = :trangThai " +
           "AND (LOWER(e.hoTen) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(e.email) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
           "ORDER BY d.ngayDat DESC")
    Page<DonHang> findByTrangThaiAndKeyword(Integer trangThai, String keyword, Pageable pageable);

    @Query("SELECT d FROM DonHang d JOIN d.taiKhoan e " +
           "WHERE (:trangThai IS NULL OR d.trangThaiDH = :trangThai) " +
           "AND (:keyword IS NULL OR (LOWER(e.hoTen) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(e.email) LIKE LOWER(CONCAT('%', :keyword, '%')))) " +
           "AND (:startDate IS NULL OR d.ngayDat >= :startDate) " +
           "AND (:endDate IS NULL OR d.ngayDat <= :endDate) " +
           "ORDER BY d.ngayDat DESC")
    Page<DonHang> searchAdvanced(String keyword, Integer trangThai, LocalDateTime startDate, LocalDateTime endDate, Pageable pageable);
    // Tính tổng doanh thu (Chỉ tính các đơn Hoàn tất = 4)
    @Query("SELECT SUM(d.tongTien) FROM DonHang d WHERE d.trangThaiDH = 4")
    BigDecimal sumTotalRevenue();

    @Query("SELECT SUM(d.tongTien) FROM DonHang d WHERE d.trangThaiDH = 4 AND d.ngayDat >= :startDate AND d.ngayDat <= :endDate")
    BigDecimal sumTotalRevenueBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

    Long countByTrangThaiDHAndNgayDatBetween(Integer trangThai, LocalDateTime startDate, LocalDateTime endDate);

    // Tìm đơn hàng để auto-complete
    List<DonHang> findByTrangThaiDHAndNgayCapNhatBefore(Integer trangThai, LocalDateTime ngayCapNhat);
}
