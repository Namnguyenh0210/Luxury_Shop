package com.example.projectend.repository;

import com.example.projectend.entity.DanhGia;
import com.example.projectend.entity.DonHangChiTiet;
import com.example.projectend.entity.SanPham;
import com.example.projectend.entity.TaiKhoan;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * REPOSITORY ĐÁNH GIÁ - LUXURY FASHION (FIXED)
 * Quản lý đánh giá sản phẩm - dựa theo MaCT (DonHangChiTiet)
 */
@Repository
public interface DanhGiaRepository extends JpaRepository<DanhGia, Long> {

    // Tìm đánh giá theo sản phẩm (chỉ hiển thị Approved = 1 hoặc null cho dữ liệu cũ)
    @Query("SELECT d FROM DanhGia d WHERE d.donHangChiTiet.sanPhamChiTiet.sanPham.maSP = :maSP AND (d.trangThai = 1 OR d.trangThai IS NULL) ORDER BY d.ngayDanhGia DESC")
    List<DanhGia> findBySanPhamMaSP(@Param("maSP") Long maSP);

    // Tìm đánh giá theo khách hàng
    Page<DanhGia> findByTaiKhoanOrderByNgayDanhGiaDesc(TaiKhoan taiKhoan, Pageable pageable);

    // Kiểm tra đã đánh giá chi tiết đơn hàng chưa
    Optional<DanhGia> findByDonHangChiTiet(DonHangChiTiet donHangChiTiet);

    // Tính điểm trung bình của sản phẩm (chỉ tính Approved = 1)
    @Query("SELECT AVG(d.diem) FROM DanhGia d WHERE d.donHangChiTiet.sanPhamChiTiet.sanPham.maSP = :maSP AND (d.trangThai = 1 OR d.trangThai IS NULL)")
    Double findAverageRatingBySanPham(@Param("maSP") Long maSP);

    // Đếm số lượng đánh giá của sản phẩm (chỉ đếm Approved = 1)
    @Query("SELECT COUNT(d) FROM DanhGia d WHERE d.donHangChiTiet.sanPhamChiTiet.sanPham.maSP = :maSP AND (d.trangThai = 1 OR d.trangThai IS NULL)")
    long countBySanPham(@Param("maSP") Long maSP);

    // Lấy đánh giá theo số sao
    @Query("SELECT d FROM DanhGia d WHERE d.donHangChiTiet.sanPhamChiTiet.sanPham.maSP = :maSP AND d.diem = :diem AND (d.trangThai = 1 OR d.trangThai IS NULL) ORDER BY d.ngayDanhGia DESC")
    List<DanhGia> findBySanPhamAndDiem(@Param("maSP") Long maSP, @Param("diem") Integer diem);

    // Dành cho Admin: Tìm kiếm và lọc
    @Query("SELECT d FROM DanhGia d WHERE " +
           "(:tuKhoa IS NULL OR LOWER(d.noiDung) LIKE LOWER(CONCAT('%', :tuKhoa, '%')) " +
           "OR LOWER(d.taiKhoan.hoTen) LIKE LOWER(CONCAT('%', :tuKhoa, '%')) " +
           "OR LOWER(d.donHangChiTiet.sanPhamChiTiet.sanPham.tenSP) LIKE LOWER(CONCAT('%', :tuKhoa, '%'))) " +
           "AND (:trangThai IS NULL OR d.trangThai = :trangThai) " +
           "ORDER BY d.ngayDanhGia DESC")
    Page<DanhGia> searchDanhGiaAdmin(@Param("tuKhoa") String tuKhoa, @Param("trangThai") Integer trangThai, Pageable pageable);

    // Admin thống kê đánh giá
    @Query("SELECT d.donHangChiTiet.sanPhamChiTiet.sanPham.tenSP as tenSP, AVG(d.diem) as avgDiem, COUNT(d) as tongDG " +
           "FROM DanhGia d " +
           "WHERE (d.trangThai = 1 OR d.trangThai IS NULL) " +
           "GROUP BY d.donHangChiTiet.sanPhamChiTiet.sanPham.tenSP " +
           "ORDER BY AVG(d.diem) DESC")
    List<Object[]> getTopProductsByRating();
}
