package com.example.projectend.entity;

import jakarta.persistence.*;

import java.math.BigDecimal;

/**
 * ENTITY DON HANG CHI TIET - LUXURY FASHION
 * Bảng: DonHangCT (theo SQL)
 */
@Entity
@Table(name = "DonHangCT")
public class DonHangChiTiet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaCT")
    private Long maCT;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaDH", nullable = false)
    private DonHang donHang;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaBienThe", nullable = false)
    private SanPhamChiTiet sanPhamChiTiet;

    @Column(name = "SoLuong")
    private Integer soLuong;

    @Column(name = "DonGia", precision = 18, scale = 2)
    private BigDecimal donGia;

    // Constructors
    public DonHangChiTiet() {
    }

    public DonHangChiTiet(DonHang donHang, SanPhamChiTiet sanPhamChiTiet, Integer soLuong, BigDecimal donGia) {
        this.donHang = donHang;
        this.sanPhamChiTiet = sanPhamChiTiet;
        this.soLuong = soLuong;
        this.donGia = donGia;
    }

    // Getters and Setters
    public Long getMaCT() {
        return maCT;
    }

    public void setMaCT(Long maCT) {
        this.maCT = maCT;
    }

    public DonHang getDonHang() {
        return donHang;
    }

    public void setDonHang(DonHang donHang) {
        this.donHang = donHang;
    }

    public SanPhamChiTiet getSanPhamChiTiet() {
        return sanPhamChiTiet;
    }

    public void setSanPhamChiTiet(SanPhamChiTiet sanPhamChiTiet) {
        this.sanPhamChiTiet = sanPhamChiTiet;
    }

    public Integer getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(Integer soLuong) {
        this.soLuong = soLuong;
    }

    public BigDecimal getDonGia() {
        return donGia;
    }

    public void setDonGia(BigDecimal donGia) {
        this.donGia = donGia;
    }

    // Calculated field: ThanhTien = DonGia * SoLuong (không lưu DB)
    @Transient
    public BigDecimal getThanhTien() {
        if (donGia != null && soLuong != null) {
            return donGia.multiply(BigDecimal.valueOf(soLuong));
        }
        return BigDecimal.ZERO;
    }
}
