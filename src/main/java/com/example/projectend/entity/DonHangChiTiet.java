package com.example.projectend.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Entity
@Table(name = "DonHangCT")
@JsonIgnoreProperties({"hibernateLazyInitializer","handler"})
public class DonHangChiTiet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaCT")
    private Long maCT;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaDH", nullable = false)
    @JsonIgnore
    private DonHang donHang;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaBienThe")
    private SanPhamChiTiet sanPhamChiTiet;

    @Column(name = "SoLuong")
    private Integer soLuong;

    @Column(name = "DonGia", precision = 18, scale = 2)
    private BigDecimal donGia;

    public DonHangChiTiet() {}

    public DonHangChiTiet(DonHang donHang, SanPhamChiTiet sanPhamChiTiet, Integer soLuong, BigDecimal donGia) {
        this.donHang = donHang;
        this.sanPhamChiTiet = sanPhamChiTiet;
        this.soLuong = soLuong;
        this.donGia = donGia;
    }

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

    @Transient
    public BigDecimal getThanhTien() {
        if (donGia != null && soLuong != null) {
            return donGia.multiply(BigDecimal.valueOf(soLuong));
        }
        return BigDecimal.ZERO;
    }
}