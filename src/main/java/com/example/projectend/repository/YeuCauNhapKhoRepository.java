package com.example.projectend.repository;

import com.example.projectend.entity.YeuCauNhapKho;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface YeuCauNhapKhoRepository extends JpaRepository<YeuCauNhapKho, Long> {
    List<YeuCauNhapKho> findByTrangThai(Integer trangThai);
}
