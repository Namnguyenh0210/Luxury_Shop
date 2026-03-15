package com.example.projectend.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import java.math.BigDecimal;

/**
 * ENTITY SAN PHAM CHI TIET (PRODUCT VARIANT/SKU)
 * Bảng: SanPhamChiTiet
 * Mô tả: Lưu các biến thể sản phẩm (Size + Màu + Giá + Tồn kho)
 * ĐÂY LÀ BẢNG QUAN TRỌNG NHẤT!
 */
@Entity
@Table(name = "SanPhamChiTiet")
public class SanPhamChiTiet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaBienThe")
    private Long maBienThe;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaSP", nullable = false)
    @JsonIgnoreProperties({"variants"})
    private SanPham sanPham;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaSize")
    private SizeSP sizeSP;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaMau")
    private MauSacSP mauSacSP;

    @Column(name = "GiaBan", nullable = false, precision = 18, scale = 2)
    private BigDecimal giaBan;

    @Column(name = "GiaNhap", precision = 18, scale = 2)
    private BigDecimal giaNhap;

    @Column(name = "SoLuongTon")
    private Integer soLuongTon = 0;

    @Column(name = "SoLuongDaBan")
    private Integer soLuongDaBan = 0;

    @Column(name = "AnhBienThe", length = 255)
    private String anhBienThe;

    @Column(name = "SKU", length = 100, unique = true)
    private String sku;

    @Column(name = "TrangThai", nullable = false)
    private Boolean trangThai = true;

    // Constructors
    public SanPhamChiTiet() {
    }

    public SanPhamChiTiet(SanPham sanPham, SizeSP sizeSP, MauSacSP mauSacSP, BigDecimal giaBan) {
        this.sanPham = sanPham;
        this.sizeSP = sizeSP;
        this.mauSacSP = mauSacSP;
        this.giaBan = giaBan;
    }

    // Getters and Setters
    public Long getMaBienThe() {
        return maBienThe;
    }

    public void setMaBienThe(Long maBienThe) {
        this.maBienThe = maBienThe;
    }

    public SanPham getSanPham() {
        return sanPham;
    }

    public void setSanPham(SanPham sanPham) {
        this.sanPham = sanPham;
    }

    public SizeSP getSizeSP() {
        return sizeSP;
    }

    public void setSizeSP(SizeSP sizeSP) {
        this.sizeSP = sizeSP;
    }

    public MauSacSP getMauSacSP() {
        return mauSacSP;
    }

    public void setMauSacSP(MauSacSP mauSacSP) {
        this.mauSacSP = mauSacSP;
    }

    public BigDecimal getGiaBan() {
        return giaBan;
    }

    public void setGiaBan(BigDecimal giaBan) {
        this.giaBan = giaBan;
    }

    public BigDecimal getGiaNhap() {
        return giaNhap;
    }

    public void setGiaNhap(BigDecimal giaNhap) {
        this.giaNhap = giaNhap;
    }

    public Integer getSoLuongTon() {
        return soLuongTon;
    }

    public void setSoLuongTon(Integer soLuongTon) {
        this.soLuongTon = soLuongTon;
    }

    public Integer getSoLuongDaBan() {
        return soLuongDaBan;
    }

    public void setSoLuongDaBan(Integer soLuongDaBan) {
        this.soLuongDaBan = soLuongDaBan;
    }

    public String getAnhBienThe() {
        return anhBienThe;
    }

    public void setAnhBienThe(String anhBienThe) {
        this.anhBienThe = anhBienThe;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public Boolean getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(Boolean trangThai) {
        this.trangThai = trangThai;
    }

    @Override
    public String toString() {
        return "SanPhamChiTiet{" +
                "maBienThe=" + maBienThe +
                ", sku='" + sku + '\'' +
                ", sizeSP=" + (sizeSP != null ? sizeSP.getTenSize() : "N/A") +
                ", mauSacSP=" + (mauSacSP != null ? mauSacSP.getTenMau() : "N/A") +
                ", giaBan=" + giaBan +
                ", soLuongTon=" + soLuongTon +
                ", trangThai=" + trangThai +
                '}';
    }
}
