package com.example.projectend.repository;

import com.example.projectend.entity.LoaiSanPham;
import com.example.projectend.entity.SanPham;
import com.example.projectend.entity.ThuongHieu;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * SAN PHAM REPOSITORY - LUXURY FASHION
 */
@Repository
public interface SanPhamRepository extends JpaRepository<SanPham, Long>, JpaSpecificationExecutor<SanPham> {

    // Lấy sản phẩm nổi bật (mới nhất)
    List<SanPham> findTop8ByOrderByNgayTaoDesc();

    // Lấy sản phẩm đang bán
    List<SanPham> findByTrangThaiSP(Integer trangThai);

    // Tìm kiếm theo tên
    List<SanPham> findTop10ByTenSPContainingIgnoreCaseOrderByNgayTaoDesc(String keyword);

    // Lấy sản phẩm cùng loại (sản phẩm liên quan)
    List<SanPham> findTop6ByLoaiSanPham_MaLoaiAndMaSPNotOrderByNgayTaoDesc(Long loaiId, Long excludeId);

    // Lấy sản phẩm liên quan không giới hạn
    List<SanPham> findByLoaiSanPham_MaLoaiAndMaSPNotOrderByNgayTaoDesc(Long loaiId, Long excludeId);

    // Tìm theo loại sản phẩm và trạng thái
    List<SanPham> findByLoaiSanPham_MaLoaiAndTrangThaiSP(Long maLoai, Integer trangThai);

    // Tìm theo loại sản phẩm
    List<SanPham> findByLoaiSanPham_MaLoaiOrderByNgayTaoDesc(Long maLoai);

    // Tìm kiếm theo tên
    List<SanPham> findByTenSPContainingIgnoreCaseOrderByNgayTaoDesc(String keyword);

    // Tìm theo thương hiệu
    List<SanPham> findByThuongHieu_MaTHAndTrangThaiSP(Long maTH, Integer trangThai);

    // Đếm số lượng sản phẩm
    long count();

    // Đếm số lượng sản phẩm theo trạng thái
    long countByTrangThaiSP(Integer trangThai);

    Optional<SanPham> findByTenSPAndLoaiSanPhamAndThuongHieu(String tenSP, LoaiSanPham loaiSanPham, ThuongHieu thuongHieu);

    Optional<SanPham> findByTenSP(String tenSP);
}
