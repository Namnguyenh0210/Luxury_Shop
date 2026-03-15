package com.example.projectend.repository;

import com.example.projectend.entity.CuocTroChuyen;
import com.example.projectend.entity.TaiKhoan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CuocTroChuyenRepository extends JpaRepository<CuocTroChuyen, Long> {

    // Tìm cuộc hội thoại gần nhất của một user
    Optional<CuocTroChuyen> findFirstByTaiKhoanOrderByNgayCapNhatDesc(TaiKhoan taiKhoan);

    // Dành cho Admin/Staff xem toàn bộ cuộc hội thoại
    List<CuocTroChuyen> findAllByOrderByNgayCapNhatDesc();

    // Lấy các cuộc gọi theo trạng thái (HUMAN - cần nhân viên)
    List<CuocTroChuyen> findByTrangThaiOrderByNgayCapNhatDesc(String trangThai);
}
