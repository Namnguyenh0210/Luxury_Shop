package com.example.projectend.repository;

import com.example.projectend.entity.DiaChi;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * REPOSITORY DIA CHI - LUXURY FASHION
 */
@Repository
public interface DiaChiRepository extends JpaRepository<DiaChi, Long> {

    // Lấy tất cả địa chỉ của user
    List<DiaChi> findByTaiKhoan_MaTK(Long maTK);

    // Lấy địa chỉ mặc định của user
    Optional<DiaChi> findByTaiKhoan_MaTKAndLaMacDinh(Long maTK, Boolean laMacDinh);
}
