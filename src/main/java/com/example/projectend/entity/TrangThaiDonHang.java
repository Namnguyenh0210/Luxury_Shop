package com.example.projectend.entity;

import jakarta.persistence.*;

/**
 * ENTITY TRANG THAI DON HANG
 * PHÂN CÔNG:
 * - THÀNH VIÊN 1: Mapping (ĐÃ HOÀN THÀNH)
 * - THÀNH VIÊN 4: Sử dụng khi cập nhật trạng thái đơn (DonHangService)
 * - THÀNH VIÊN 3: Chỉ đọc để hiển thị lịch sử
 */
@Entity
@Table(name = "TrangThaiDonHang")
public class TrangThaiDonHang {

    @Id
    @Column(name = "MaTTDH")
    private Integer maTTDH;

    @Column(name = "TenTTDH", nullable = false, length = 50)
    private String tenTTDH;

    // ✅ Hệ thống hằng số Trạng thái Đơn hàng (Đồng bộ toàn dự án)
    public static final int CHO_XAC_NHAN = 0;   // Đơn mới, chờ admin duyệt
    public static final int DA_XAC_NHAN = 1;    // Admin đã duyệt
    public static final int DANG_GIAO = 2;       // Shipper đang đi giao
    public static final int DA_GIAO = 3;         // Đã giao hàng
    public static final int HOAN_TAT = 4;        // Đã hoàn tất (Thanh toán xong)
    public static final int DA_HUY = 5;          // Đơn hàng đã bị hủy
    public static final int DA_DANH_GIA = 6;    // Đã đánh giá đơn hàng
    public static final int CHO_THANH_TOAN = 7; // Đang chờ khách quét mã QR
    public static final int LOI_THANH_TOAN = 8;  // Thanh toán PayOS thất bại

    public TrangThaiDonHang() {
    }

    public TrangThaiDonHang(String tenTTDH) {
        this.tenTTDH = tenTTDH;
    }

    public Integer getMaTTDH() {
        return maTTDH;
    }

    public void setMaTTDH(Integer maTTDH) {
        this.maTTDH = maTTDH;
    }

    public String getTenTTDH() {
        return tenTTDH;
    }

    public void setTenTTDH(String tenTTDH) {
        this.tenTTDH = tenTTDH;
    }
}
