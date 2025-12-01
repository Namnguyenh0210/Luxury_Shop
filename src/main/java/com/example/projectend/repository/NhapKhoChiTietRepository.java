package com.example.projectend.repository;

import com.example.projectend.entity.NhapKhoChiTiet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NhapKhoChiTietRepository extends JpaRepository<NhapKhoChiTiet, Long> {
    List<NhapKhoChiTiet> findByPhieuNhap_MaPN(Long maPN);
}

