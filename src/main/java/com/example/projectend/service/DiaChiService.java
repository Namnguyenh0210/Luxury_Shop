package com.example.projectend.service;

import com.example.projectend.entity.DiaChi;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.DiaChiRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Service quản lý địa chỉ giao hàng
 */
@Service
public class DiaChiService {

    @Autowired
    private DiaChiRepository diaChiRepository;

    /**
     * Lấy danh sách địa chỉ của người dùng
     */
    public List<DiaChi> getDiaChiByTaiKhoan(TaiKhoan tk) {
        return diaChiRepository.findByTaiKhoan_MaTK(tk.getMaTK());
    }

    /**
     * Lấy địa chỉ mặc định của người dùng
     */
    public Optional<DiaChi> getDiaChiMacDinh(TaiKhoan tk) {
        return diaChiRepository.findByTaiKhoan_MaTKAndLaMacDinh(tk.getMaTK(), true);
    }

    /**
     * Lưu hoặc cập nhật địa chỉ
     */
    public DiaChi save(DiaChi dc) {
        return diaChiRepository.save(dc);
    }

    /**
     * Đặt địa chỉ làm mặc định
     */
    public void setMacDinh(Long id, TaiKhoan tk) {
        List<DiaChi> allAddresses = getDiaChiByTaiKhoan(tk);
        for (DiaChi dc : allAddresses) {
            dc.setLaMacDinh(dc.getMaDiaChi().equals(id));
            diaChiRepository.save(dc);
        }
    }

    /**
     * Tìm địa chỉ theo ID
     */
    public Optional<DiaChi> findById(Long id) {
        return diaChiRepository.findById(id);
    }

    /**
     * Xóa địa chỉ (không cho xóa địa chỉ mặc định)
     */
    public void delete(Long id, TaiKhoan tk) {
        Optional<DiaChi> diaChi = findById(id);
        if (diaChi.isPresent() && !diaChi.get().getLaMacDinh()) {
            diaChiRepository.deleteById(id);
        }
    }
}
