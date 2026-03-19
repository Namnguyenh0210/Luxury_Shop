package com.example.projectend.service;

import com.example.projectend.entity.SanPham;
import com.example.projectend.entity.SanPhamYeuThich;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.SanPhamRepository;
import com.example.projectend.repository.SanPhamYeuThichRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SanPhamYeuThichService {

    @Autowired
    private SanPhamYeuThichRepository sanPhamYeuThichRepository;

    @Autowired
    private SanPhamRepository sanPhamRepository;

    /**
     * Lấy danh sách yêu thích theo user
     */
    public List<SanPhamYeuThich> getFavorites(Long maTK) {
        return sanPhamYeuThichRepository.findByTaiKhoan_MaTKOrderByNgayThemDesc(maTK);
    }

    /**
     * Check sản phẩm đã được yêu thích chưa
     */
    public boolean isFavorite(Long maTK, Long maSP) {
        return sanPhamYeuThichRepository
                .existsByTaiKhoan_MaTKAndSanPham_MaSP(maTK, maSP);
    }

    /**
     * Toggle yêu thích (thêm / xóa)
     */
    public boolean toggleFavorite(TaiKhoan tk, Long maSP) {

        // ✅ FIX 1: check tk null
        if (tk == null) {
            throw new RuntimeException("User không tồn tại");
        }

        boolean exists = sanPhamYeuThichRepository
                .existsByTaiKhoan_MaTKAndSanPham_MaSP(tk.getMaTK(), maSP);

        if (exists) {
            sanPhamYeuThichRepository
                    .deleteByTaiKhoan_MaTKAndSanPham_MaSP(tk.getMaTK(), maSP);
            return false;
        } else {

            // ✅ FIX 2: check sản phẩm rõ ràng
            SanPham sp = sanPhamRepository.findById(maSP)
                    .orElseThrow(() -> new RuntimeException("Sản phẩm không tồn tại ID = " + maSP));

            SanPhamYeuThich fa = new SanPhamYeuThich(tk, sp);
            sanPhamYeuThichRepository.save(fa);

            return true;
        }
    }

    /**
     * Xóa yêu thích
     */
    public void removeFavorite(Long maTK, Long maSP) {
        sanPhamYeuThichRepository
                .deleteByTaiKhoan_MaTKAndSanPham_MaSP(maTK, maSP);
    }
}