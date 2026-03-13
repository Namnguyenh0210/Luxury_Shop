package com.example.projectend.repository;

import com.example.projectend.entity.SanPhamYeuThich;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SanPhamYeuThichRepository extends JpaRepository<SanPhamYeuThich, Long> {
    List<SanPhamYeuThich> findByTaiKhoan_MaTKOrderByNgayThemDesc(Long maTK);
    boolean existsByTaiKhoan_MaTKAndSanPham_MaSP(Long maTK, Long maSP);
    void deleteByTaiKhoan_MaTKAndSanPham_MaSP(Long maTK, Long maSP);
}
