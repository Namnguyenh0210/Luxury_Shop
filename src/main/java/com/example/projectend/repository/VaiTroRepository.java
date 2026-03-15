package com.example.projectend.repository;

import com.example.projectend.entity.VaiTro;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * REPOSITORY VAI TRO (ROLE) - LUXURY FASHION
 */
@Repository
public interface VaiTroRepository extends JpaRepository<VaiTro, Long> {

    // Tìm role theo tên (ADMIN, NHANVIEN, KHACHHANG)
    Optional<VaiTro> findByTenVaiTro(String tenVaiTro);
}
