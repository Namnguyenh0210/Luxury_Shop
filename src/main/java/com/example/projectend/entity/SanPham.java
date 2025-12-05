package com.example.projectend.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * ENTITY SAN PHAM - LUXURY FASHION
 * Bảng: SanPham
 * Mô tả: Lưu thông tin sản phẩm chính (không có giá/tồn kho)
 * Giá và tồn kho nằm ở bảng SanPhamChiTiet (biến thể)
 */
@Entity
@Table(name = "SanPham")
public class SanPham {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaSP")
    private Long maSP;

    @Column(name = "TenSP", nullable = false, length = 255)
    private String tenSP;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaLoai")
    private LoaiSanPham loaiSanPham;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaTH")
    private ThuongHieu thuongHieu;

    @Column(name = "MoTa", columnDefinition = "NVARCHAR(MAX)")
    private String moTa;

    @Column(name = "AnhChinh", length = 255)
    private String anhChinh;

    @Column(name = "GioiTinh", nullable = false)
    private Integer gioiTinh = 2; // 0=Nam, 1=Nữ, 2=Unisex

    @Column(name = "TrangThaiSP", nullable = false)
    private Integer trangThaiSP = 1; // 1=Đang bán, 0=Ngừng bán

    @Column(name = "NgayTao")
    private LocalDateTime ngayTao = LocalDateTime.now();

    @Column(name = "NgayCapNhat")
    private LocalDateTime ngayCapNhat = LocalDateTime.now();

    @OneToMany(mappedBy = "sanPham", cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY)
    private java.util.List<SanPhamChiTiet> variants = new java.util.ArrayList<>();

    // Constructors
    public SanPham() {
    }

    public SanPham(String tenSP, LoaiSanPham loaiSanPham, ThuongHieu thuongHieu) {
        this.tenSP = tenSP;
        this.loaiSanPham = loaiSanPham;
        this.thuongHieu = thuongHieu;
    }

    // Getters and Setters
    public Long getMaSP() {
        return maSP;
    }

    public void setMaSP(Long maSP) {
        this.maSP = maSP;
    }

    public String getTenSP() {
        return tenSP;
    }

    public void setTenSP(String tenSP) {
        this.tenSP = tenSP;
    }

    public LoaiSanPham getLoaiSanPham() {
        return loaiSanPham;
    }

    public void setLoaiSanPham(LoaiSanPham loaiSanPham) {
        this.loaiSanPham = loaiSanPham;
    }

    public ThuongHieu getThuongHieu() {
        return thuongHieu;
    }

    public void setThuongHieu(ThuongHieu thuongHieu) {
        this.thuongHieu = thuongHieu;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public String getAnhChinh() {
        return anhChinh;
    }

    public void setAnhChinh(String anhChinh) {
        this.anhChinh = anhChinh;
    }

    public Integer getGioiTinh() {
        return gioiTinh;
    }

    public void setGioiTinh(Integer gioiTinh) {
        this.gioiTinh = gioiTinh;
    }

    public Integer getTrangThaiSP() {
        return trangThaiSP;
    }

    public void setTrangThaiSP(Integer trangThaiSP) {
        this.trangThaiSP = trangThaiSP;
    }

    public LocalDateTime getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(LocalDateTime ngayTao) {
        this.ngayTao = ngayTao;
    }

    public LocalDateTime getNgayCapNhat() {
        return ngayCapNhat;
    }

    public void setNgayCapNhat(LocalDateTime ngayCapNhat) {
        this.ngayCapNhat = ngayCapNhat;
    }

    public java.util.List<SanPhamChiTiet> getVariants() {
        return variants;
    }

    public void setVariants(java.util.List<SanPhamChiTiet> variants) {
        this.variants = variants;
    }

    @Override
    public String toString() {
        return "SanPham{" +
                "maSP=" + maSP +
                ", tenSP='" + tenSP + '\'' +
                ", gioiTinh=" + gioiTinh +
                ", trangThaiSP=" + trangThaiSP +
                '}';
    }
}
