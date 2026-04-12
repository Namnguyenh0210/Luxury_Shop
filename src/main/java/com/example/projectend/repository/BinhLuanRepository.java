package com.example.projectend.repository;

import com.example.projectend.entity.BinhLuan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository cho BinhLuan
 */
@Repository
public interface BinhLuanRepository extends JpaRepository<BinhLuan, Long> {

    // Lấy tất cả bình luận của một bài viết (đang hiển thị), mới nhất trước
    List<BinhLuan> findByBaiViet_MaBVAndTrangThaiTrueOrderByNgayBinhLuanDesc(Long maBV);

    // Đếm số bình luận của bài viết
    long countByBaiViet_MaBVAndTrangThaiTrue(Long maBV);

    // ADMIN: Query tìm kiếm bình luận
    @org.springframework.data.jpa.repository.Query("SELECT b FROM BinhLuan b WHERE " +
           "(:tuKhoa IS NULL OR LOWER(b.noiDung) LIKE LOWER(CONCAT('%', :tuKhoa, '%')) " +
           "OR LOWER(b.taiKhoan.hoTen) LIKE LOWER(CONCAT('%', :tuKhoa, '%')) " +
           "OR LOWER(b.baiViet.tieuDe) LIKE LOWER(CONCAT('%', :tuKhoa, '%'))) " +
           "AND (:trangThai IS NULL OR b.trangThai = :trangThai) " +
           "AND (:startDate IS NULL OR b.ngayBinhLuan >= :startDate) " +
           "AND (:endDate IS NULL OR b.ngayBinhLuan <= :endDate) " +
           "ORDER BY b.ngayBinhLuan DESC")
    org.springframework.data.domain.Page<BinhLuan> searchBinhLuanAdmin(
            @org.springframework.data.repository.query.Param("tuKhoa") String tuKhoa, 
            @org.springframework.data.repository.query.Param("trangThai") Boolean trangThai, 
            @org.springframework.data.repository.query.Param("startDate") java.time.LocalDateTime startDate,
            @org.springframework.data.repository.query.Param("endDate") java.time.LocalDateTime endDate,
            org.springframework.data.domain.Pageable pageable);

    // ADMIN: Thống kê số lượng bài viết nào được comment nhiều nhất
    @org.springframework.data.jpa.repository.Query("SELECT b.baiViet.tieuDe as tieuDe, COUNT(b) as tongBL " +
           "FROM BinhLuan b " +
           "WHERE b.trangThai = true " +
           "GROUP BY b.baiViet.tieuDe " +
           "ORDER BY COUNT(b) DESC")
    List<Object[]> getTopBlogsByComments();
}
