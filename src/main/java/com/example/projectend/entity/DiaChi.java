package com.example.projectend.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

/**
 * ENTITY SO DIA CHI - LUXURY FASHION
 * Bảng: SoDiaChi (theo SQL)
 */
@JsonIgnoreProperties({ "hibernateLazyInitializer", "handler" })
@Entity
@Table(name = "SoDiaChi")
public class DiaChi {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaDiaChi")
    private Long maDiaChi;

    @ManyToOne(fetch = FetchType.EAGER)
    @JsonIgnore
    @JoinColumn(name = "MaTK", nullable = false)
    private TaiKhoan taiKhoan;

    @Column(name = "HoTenNguoiNhan", nullable = false, length = 100)
    private String hoTenNguoiNhan;

    @Column(name = "SoDienThoai", nullable = false, length = 20)
    private String soDienThoai;

    @Column(name = "DiaChiChiTiet", nullable = false, length = 500)
    private String diaChiChiTiet;

    @Column(name = "GhiChu", length = 255)
    private String ghiChu;

    @Column(name = "LaMacDinh")
    private Boolean laMacDinh = false;

    public DiaChi() {
    }

    public DiaChi(TaiKhoan taiKhoan, String hoTenNguoiNhan, String soDienThoai, String diaChiChiTiet, String ghiChu) {
        this.taiKhoan = taiKhoan;
        this.hoTenNguoiNhan = hoTenNguoiNhan;
        this.soDienThoai = soDienThoai;
        this.diaChiChiTiet = diaChiChiTiet;
        this.ghiChu = ghiChu;
    }

    // Getters and Setters
    public Long getMaDiaChi() {
        return maDiaChi;
    }

    public void setMaDiaChi(Long maDiaChi) {
        this.maDiaChi = maDiaChi;
    }

    public TaiKhoan getTaiKhoan() {
        return taiKhoan;
    }

    public void setTaiKhoan(TaiKhoan taiKhoan) {
        this.taiKhoan = taiKhoan;
    }

    public String getHoTenNguoiNhan() {
        return hoTenNguoiNhan;
    }

    public void setHoTenNguoiNhan(String hoTenNguoiNhan) {
        this.hoTenNguoiNhan = hoTenNguoiNhan;
    }

    public String getSoDienThoai() {
        return soDienThoai;
    }

    public void setSoDienThoai(String soDienThoai) {
        this.soDienThoai = soDienThoai;
    }

    public String getDiaChiChiTiet() {
        return diaChiChiTiet;
    }

    public void setDiaChiChiTiet(String diaChiChiTiet) {
        this.diaChiChiTiet = diaChiChiTiet;
    }

    public Boolean getLaMacDinh() {
        return laMacDinh;
    }

    public void setLaMacDinh(Boolean laMacDinh) {
        this.laMacDinh = laMacDinh;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }
}
