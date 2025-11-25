package com.example.projectend.entity;

import jakarta.persistence.*;

/**
 * ENTITY KHUYEN MAI CHI TIET - LUXURY FASHION
 * Bảng: KhuyenMai_ChiTiet
 * Liên kết khuyến mãi với sản phẩm hoặc biến thể
 */
@Entity
@Table(name = "KhuyenMai_ChiTiet")
public class KhuyenMaiChiTiet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaKM", nullable = false)
    private KhuyenMai khuyenMai;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaSP")
    private SanPham sanPham;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaBienThe")
    private SanPhamChiTiet sanPhamChiTiet;

    // Constructors
    public KhuyenMaiChiTiet() {
    }

    public KhuyenMaiChiTiet(KhuyenMai khuyenMai, SanPham sanPham) {
        this.khuyenMai = khuyenMai;
        this.sanPham = sanPham;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public KhuyenMai getKhuyenMai() {
        return khuyenMai;
    }

    public void setKhuyenMai(KhuyenMai khuyenMai) {
        this.khuyenMai = khuyenMai;
    }

    public SanPham getSanPham() {
        return sanPham;
    }

    public void setSanPham(SanPham sanPham) {
        this.sanPham = sanPham;
    }

    public SanPhamChiTiet getSanPhamChiTiet() {
        return sanPhamChiTiet;
    }

    public void setSanPhamChiTiet(SanPhamChiTiet sanPhamChiTiet) {
        this.sanPhamChiTiet = sanPhamChiTiet;
    }
}

