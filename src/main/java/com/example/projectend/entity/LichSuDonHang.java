package com.example.projectend.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * ENTITY LỊCH SỬ ĐƠN HÀNG - LUXURY FASHION
 * Bảng: LichSuDonHang (theo SQL)
 * Ghi lại mọi thay đổi trạng thái của đơn hàng
 */
@Entity
@Table(name = "LichSuDonHang")
public class LichSuDonHang {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaLichSu")
    private Long maLichSu;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaDH", nullable = false)
    private DonHang donHang;

    @Column(name = "TrangThaiCu", nullable = false)
    private Integer trangThaiCu;

    @Column(name = "TrangThaiMoi", nullable = false)
    private Integer trangThaiMoi;

    @Column(name = "ThoiGian")
    private LocalDateTime thoiGian = LocalDateTime.now();

    @Column(name = "GhiChu")
    private String ghiChu;

    @Column(name = "NguoiCapNhat")
    private String nguoiCapNhat;

    // Constructors
    public LichSuDonHang() {
    }

    public LichSuDonHang(DonHang donHang, Integer trangThaiCu, Integer trangThaiMoi, String nguoiCapNhat, String ghiChu) {
        this.donHang = donHang;
        this.trangThaiCu = trangThaiCu;
        this.trangThaiMoi = trangThaiMoi;
        this.nguoiCapNhat = nguoiCapNhat;
        this.ghiChu = ghiChu;
        this.thoiGian = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getMaLichSu() {
        return maLichSu;
    }

    public void setMaLichSu(Long maLichSu) {
        this.maLichSu = maLichSu;
    }

    public DonHang getDonHang() {
        return donHang;
    }

    public void setDonHang(DonHang donHang) {
        this.donHang = donHang;
    }

    public Integer getTrangThaiCu() {
        return trangThaiCu;
    }

    public void setTrangThaiCu(Integer trangThaiCu) {
        this.trangThaiCu = trangThaiCu;
    }

    public Integer getTrangThaiMoi() {
        return trangThaiMoi;
    }

    public void setTrangThaiMoi(Integer trangThaiMoi) {
        this.trangThaiMoi = trangThaiMoi;
    }

    public LocalDateTime getThoiGian() {
        return thoiGian;
    }

    public void setThoiGian(LocalDateTime thoiGian) {
        this.thoiGian = thoiGian;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }

    public String getNguoiCapNhat() {
        return nguoiCapNhat;
    }

    public void setNguoiCapNhat(String nguoiCapNhat) {
        this.nguoiCapNhat = nguoiCapNhat;
    }

    // Helper method to get status text
    @Transient
    public String getTrangThaiCuText() {
        return getTrangThaiText(trangThaiCu);
    }

    @Transient
    public String getTrangThaiMoiText() {
        return getTrangThaiText(trangThaiMoi);
    }

    private String getTrangThaiText(Integer status) {
        if (status == null) return "Không xác định";
        switch (status) {
            case 0: return "Chờ xác nhận";
            case 1: return "Đã xác nhận";
            case 2: return "Đang giao";
            case 3: return "Đã giao";
            case 4: return "Hoàn tất";
            case 5: return "Đã hủy";
            default: return "Không xác định";
        }
    }
}

