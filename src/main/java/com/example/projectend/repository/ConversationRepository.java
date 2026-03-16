package com.example.projectend.repository;

import com.example.projectend.entity.Conversation;
import com.example.projectend.entity.TaiKhoan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ConversationRepository extends JpaRepository<Conversation, Long> {

    // Tìm cuộc hội thoại gần nhất của một user
    Optional<Conversation> findFirstByTaiKhoanOrderByNgayCapNhatDesc(TaiKhoan taiKhoan);

    // Dành cho Admin/Staff xem toàn bộ cuộc hội thoại
    List<Conversation> findAllByOrderByNgayCapNhatDesc();

    // Lấy các cuộc gọi theo trạng thái (HUMAN - cần nhân viên)
    List<Conversation> findByTrangThaiOrderByNgayCapNhatDesc(String trangThai);
}
