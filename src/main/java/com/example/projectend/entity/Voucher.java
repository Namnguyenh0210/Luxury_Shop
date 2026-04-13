package com.example.projectend.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * ENTITY VOUCHER - PHIÊN BẢN ADVANCED LUXURY
 * Hỗ trợ các điều kiện thông minh cho hệ thống thương mại chuyên nghiệp
 */
@Entity
@Table(name = "Voucher")
public class Voucher {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaVoucher")
    private Long maVoucher;

    @Column(name = "Code", nullable = false, unique = true, length = 50)
    private String code;

    @Column(name = "MoTa", columnDefinition = "NVARCHAR(1000)")
    private String moTa;

    // 0: %, 1: VND
    @Column(name = "LoaiGiamGia", nullable = false)
    private Integer loaiGiamGia;

    @Column(name = "GiaTri", nullable = false, precision = 18, scale = 2)
    private BigDecimal giaTri;

    @Column(name = "GiaTriToiThieu", precision = 18, scale = 2)
    private BigDecimal giaTriToiThieu = BigDecimal.ZERO;

    @Column(name = "GiaTriToiDa", precision = 18, scale = 2)
    private BigDecimal giaTriToiDa;

    // QUẢN LÝ SỐ LƯỢNG
    @Column(name = "SoLuong")
    private Integer soLuong = 100;

    @Column(name = "DaSuDung")
    private Integer daSuDung = 0;

    // GIỚI HẠN USER (Vd: Mỗi người chỉ dùng 1 lần)
    @Column(name = "GioiHanUser")
    private Integer gioiHanUser = 1;

    // PHÂN QUYỀN KHÁCH HÀNG (ALL, NEW, VIP, LIST)
    @Column(name = "ApDungCho", length = 50)
    private String apDungCho = "ALL";

    @Column(name = "MinTotalSpendingVIP", precision = 18, scale = 2)
    private BigDecimal minTotalSpendingVIP = BigDecimal.ZERO;

    // ĐIỀU KIỆN SẢN PHẨM (Lưu dạng chuỗi MaLoai hoặc MaTH cách nhau bởi dấu phẩy)
    @Column(name = "MaLoaiApDung", length = 255)
    private String maLoaiApDung;

    @Column(name = "MaTHApDung", length = 255)
    private String maTHApDung;

    @Column(name = "KhongApDungSale")
    private Boolean khongApDungSale = false;

    // THỜI HẠN
    @Column(name = "NgayBatDau")
    private LocalDateTime ngayBatDau;

    @Column(name = "NgayKetThuc")
    private LocalDateTime ngayKetThuc;

    // TRẠNG THÁI & SOFT DELETE
    @Column(name = "TrangThai")
    private Boolean trangThai = true;

    @Column(name = "HienThi")
    private Boolean hienThi = true;

    @Column(name = "IsDeleted")
    private Boolean isDeleted = false;

    public Voucher() {
    }

    // Getters and Setters
    public Long getMaVoucher() {
        return maVoucher;
    }

    public void setMaVoucher(Long maVoucher) {
        this.maVoucher = maVoucher;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public Integer getLoaiGiamGia() {
        return loaiGiamGia;
    }

    public void setLoaiGiamGia(Integer loaiGiamGia) {
        this.loaiGiamGia = loaiGiamGia;
    }

    public BigDecimal getGiaTri() {
        return giaTri;
    }

    public void setGiaTri(BigDecimal giaTri) {
        this.giaTri = giaTri;
    }

    public BigDecimal getGiaTriToiThieu() {
        return giaTriToiThieu;
    }

    public void setGiaTriToiThieu(BigDecimal giaTriToiThieu) {
        this.giaTriToiThieu = giaTriToiThieu;
    }

    public BigDecimal getGiaTriToiDa() {
        return giaTriToiDa;
    }

    public void setGiaTriToiDa(BigDecimal giaTriToiDa) {
        this.giaTriToiDa = giaTriToiDa;
    }

    public Integer getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(Integer soLuong) {
        this.soLuong = soLuong;
    }

    public Integer getDaSuDung() {
        return daSuDung;
    }

    public void setDaSuDung(Integer daSuDung) {
        this.daSuDung = daSuDung;
    }

    public Integer getGioiHanUser() {
        return gioiHanUser;
    }

    public void setGioiHanUser(Integer gioiHanUser) {
        this.gioiHanUser = gioiHanUser;
    }

    public String getApDungCho() {
        return apDungCho;
    }

    public void setApDungCho(String apDungCho) {
        this.apDungCho = apDungCho;
    }

    public BigDecimal getMinTotalSpendingVIP() {
        return minTotalSpendingVIP;
    }

    public void setMinTotalSpendingVIP(BigDecimal minTotalSpendingVIP) {
        this.minTotalSpendingVIP = minTotalSpendingVIP;
    }

    public String getMaLoaiApDung() {
        return maLoaiApDung;
    }

    public void setMaLoaiApDung(String maLoaiApDung) {
        this.maLoaiApDung = maLoaiApDung;
    }

    public String getMaTHApDung() {
        return maTHApDung;
    }

    public void setMaTHApDung(String maTHApDung) {
        this.maTHApDung = maTHApDung;
    }

    public Boolean getKhongApDungSale() {
        return khongApDungSale;
    }

    public void setKhongApDungSale(Boolean khongApDungSale) {
        this.khongApDungSale = khongApDungSale;
    }

    public LocalDateTime getNgayBatDau() {
        return ngayBatDau;
    }

    public void setNgayBatDau(LocalDateTime ngayBatDau) {
        this.ngayBatDau = ngayBatDau;
    }

    public LocalDateTime getNgayKetThuc() {
        return ngayKetThuc;
    }

    public void setNgayKetThuc(LocalDateTime ngayKetThuc) {
        this.ngayKetThuc = ngayKetThuc;
    }

    public Boolean getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(Boolean trangThai) {
        this.trangThai = trangThai;
    }

    public Boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(Boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public Boolean getHienThi() {
        return hienThi;
    }

    public void setHienThi(Boolean hienThi) {
        this.hienThi = hienThi;
    }
}
