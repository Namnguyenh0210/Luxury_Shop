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
}
