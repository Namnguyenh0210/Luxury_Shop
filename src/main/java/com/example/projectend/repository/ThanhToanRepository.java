package com.example.projectend.repository;

import com.example.projectend.entity.DonHang;
import com.example.projectend.entity.ThanhToan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ThanhToanRepository extends JpaRepository<ThanhToan, Long> {
    List<ThanhToan> findByDonHang(DonHang donHang);
}
