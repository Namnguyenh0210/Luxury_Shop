package com.example.projectend.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import java.math.BigDecimal;

/**
 * ENTITY NHAP KHO CHI TIET
 * Bảng: NhapKhoChiTiet
 * Mô tả: Chi tiết từng sản phẩm trong phiếu nhập
 */
@Entity
@Table(name = "NhapKhoChiTiet")
public class NhapKhoChiTiet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaNK_CT")
    private Long maNKCT;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaPN", nullable = false)
    @JsonIgnoreProperties({"chiTiet"})
    private PhieuNhap phieuNhap;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaBienThe", nullable = false)
    private SanPhamChiTiet sanPhamChiTiet;

    @Column(name = "SoLuong")
    private Integer soLuong;

    @Column(name = "DonGiaNhap", precision = 18, scale = 2)
    private BigDecimal donGiaNhap;

    @Column(name = "ThanhTien", precision = 18, scale = 2)
    private BigDecimal thanhTien;

    // Constructors
    public NhapKhoChiTiet() {
    }

    public NhapKhoChiTiet(PhieuNhap phieuNhap, SanPhamChiTiet sanPhamChiTiet, Integer soLuong, BigDecimal donGiaNhap) {
        this.phieuNhap = phieuNhap;
        this.sanPhamChiTiet = sanPhamChiTiet;
        this.soLuong = soLuong;
        this.donGiaNhap = donGiaNhap;
        this.thanhTien = donGiaNhap.multiply(BigDecimal.valueOf(soLuong));
    }

    // Getters & Setters
    public Long getMaNKCT() {
        return maNKCT;
    }

    public void setMaNKCT(Long maNKCT) {
        this.maNKCT = maNKCT;
    }

    public PhieuNhap getPhieuNhap() {
        return phieuNhap;
    }

    public void setPhieuNhap(PhieuNhap phieuNhap) {
        this.phieuNhap = phieuNhap;
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
        if (this.donGiaNhap != null) {
            this.thanhTien = this.donGiaNhap.multiply(BigDecimal.valueOf(soLuong));
        }
    }

    public BigDecimal getDonGiaNhap() {
        return donGiaNhap;
    }

    public void setDonGiaNhap(BigDecimal donGiaNhap) {
        this.donGiaNhap = donGiaNhap;
        if (this.soLuong != null) {
            this.thanhTien = donGiaNhap.multiply(BigDecimal.valueOf(this.soLuong));
        }
    }

    public BigDecimal getThanhTien() {
        return thanhTien;
    }

    public void setThanhTien(BigDecimal thanhTien) {
        this.thanhTien = thanhTien;
    }
}

