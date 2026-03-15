package com.example.projectend.repository;

import com.example.projectend.entity.CuocTroChuyen;
import com.example.projectend.entity.TinNhan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TinNhanRepository extends JpaRepository<TinNhan, Long> {

    // Lấy tất cả tin nhắn của một cuộc hội thoại, sắp xếp theo thời gian tăng dần
    List<TinNhan> findByCuocTroChuyenOrderByNgayGuiAsc(CuocTroChuyen cuocTroChuyen);

    // Lấy tin nhắn mới nhất của một cuộc hội thoại
    TinNhan findFirstByCuocTroChuyenOrderByNgayGuiDesc(CuocTroChuyen cuocTroChuyen);
}
