package com.example.projectend.service;

import com.example.projectend.entity.DanhGia;
import com.example.projectend.entity.DonHangChiTiet;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.DanhGiaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * DANH GIA SERVICE - FIXED
 * Xử lý đánh giá sản phẩm theo cấu trúc database mới
 */
@Service
public class DanhGiaService {

    @Autowired
    private DanhGiaRepository danhGiaRepository;

    // Lưu đánh giá mới
    public DanhGia save(DanhGia danhGia) {
        return danhGiaRepository.save(danhGia);
    }

    // Tìm đánh giá theo ID
    public Optional<DanhGia> findById(Long id) {
        return danhGiaRepository.findById(id);
    }

    // Lấy đánh giá theo sản phẩm
    public List<DanhGia> getDanhGiaBySanPham(Long maSP) {
        return danhGiaRepository.findBySanPhamMaSP(maSP);
    }

    // Lấy đánh giá theo khách hàng
    public Page<DanhGia> getDanhGiaByKhachHang(TaiKhoan khachHang, Pageable pageable) {
        return danhGiaRepository.findByTaiKhoanOrderByNgayDanhGiaDesc(khachHang, pageable);
    }

    // Kiểm tra đã đánh giá chi tiết đơn hàng chưa
    public boolean hasReviewed(DonHangChiTiet donHangChiTiet) {
        return danhGiaRepository.findByDonHangChiTiet(donHangChiTiet).isPresent();
    }

    // Lấy đánh giá của chi tiết đơn hàng
    public Optional<DanhGia> getDanhGiaByDonHangChiTiet(DonHangChiTiet donHangChiTiet) {
        return danhGiaRepository.findByDonHangChiTiet(donHangChiTiet);
    }

    // Tính điểm trung bình của sản phẩm
    public Double getAverageRating(Long maSP) {
        Double avg = danhGiaRepository.findAverageRatingBySanPham(maSP);
        return avg != null ? avg : 0.0;
    }

    // Đếm số lượng đánh giá của sản phẩm
    public long countReviews(Long maSP) {
        return danhGiaRepository.countBySanPham(maSP);
    }

    // Lấy đánh giá theo số sao
    public List<DanhGia> getDanhGiaByDiem(Long maSP, Integer diem) {
        return danhGiaRepository.findBySanPhamAndDiem(maSP, diem);
    }

    // Xóa đánh giá
    public void deleteById(Long id) {
        danhGiaRepository.deleteById(id);
    }

    // Tạo đánh giá mới
    public DanhGia createReview(DonHangChiTiet donHangChiTiet, TaiKhoan taiKhoan, Integer diem, String noiDung, String hinhAnh) {
        // Kiểm tra đã đánh giá chưa
        if (hasReviewed(donHangChiTiet)) {
            throw new IllegalStateException("Sản phẩm này đã được đánh giá");
        }

        DanhGia danhGia = new DanhGia();
        danhGia.setDonHangChiTiet(donHangChiTiet);
        danhGia.setTaiKhoan(taiKhoan);
        danhGia.setDiem(diem);
        danhGia.setNoiDung(noiDung);
        danhGia.setHinhAnh(hinhAnh);

        return save(danhGia);
    }
}
