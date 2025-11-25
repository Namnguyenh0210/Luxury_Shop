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

    // Tìm đánh giá theo sản phẩm
    @Query("SELECT d FROM DanhGia d WHERE d.donHangChiTiet.sanPhamChiTiet.sanPham.maSP = :maSP ORDER BY d.ngayDanhGia DESC")
    List<DanhGia> findBySanPhamMaSP(@Param("maSP") Long maSP);

    // Tìm đánh giá theo khách hàng
    Page<DanhGia> findByTaiKhoanOrderByNgayDanhGiaDesc(TaiKhoan taiKhoan, Pageable pageable);

    // Kiểm tra đã đánh giá chi tiết đơn hàng chưa
    Optional<DanhGia> findByDonHangChiTiet(DonHangChiTiet donHangChiTiet);

    // Tính điểm trung bình của sản phẩm
    @Query("SELECT AVG(d.diem) FROM DanhGia d WHERE d.donHangChiTiet.sanPhamChiTiet.sanPham.maSP = :maSP")
    Double findAverageRatingBySanPham(@Param("maSP") Long maSP);

    // Đếm số lượng đánh giá của sản phẩm
    @Query("SELECT COUNT(d) FROM DanhGia d WHERE d.donHangChiTiet.sanPhamChiTiet.sanPham.maSP = :maSP")
    long countBySanPham(@Param("maSP") Long maSP);

    // Lấy đánh giá theo số sao
    @Query("SELECT d FROM DanhGia d WHERE d.donHangChiTiet.sanPhamChiTiet.sanPham.maSP = :maSP AND d.diem = :diem ORDER BY d.ngayDanhGia DESC")
    List<DanhGia> findBySanPhamAndDiem(@Param("maSP") Long maSP, @Param("diem") Integer diem);
}
