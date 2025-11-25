package com.example.projectend.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * ENTITY GIO HANG CHI TIET - LUXURY FASHION
 * Bảng: GioHangChiTiet (theo SQL)
 * Lưu các sản phẩm (biến thể) trong giỏ hàng
 */
@Entity
@Table(name = "GioHangChiTiet")
public class GioHangChiTiet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaGH_CT")
    private Long maGHCT;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaGioHang", nullable = false)
    private GioHang gioHang;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaBienThe", nullable = false)
    private SanPhamChiTiet sanPhamChiTiet;

    @Column(name = "SoLuong")
    private Integer soLuong = 1;

    @Column(name = "NgayThem")
    private LocalDateTime ngayThem = LocalDateTime.now();

    // Constructors
    public GioHangChiTiet() {
    }

    public GioHangChiTiet(GioHang gioHang, SanPhamChiTiet sanPhamChiTiet, Integer soLuong) {
        this.gioHang = gioHang;
        this.sanPhamChiTiet = sanPhamChiTiet;
        this.soLuong = soLuong;
    }

    // Getters and Setters
    public Long getMaGHCT() {
        return maGHCT;
    }

    public void setMaGHCT(Long maGHCT) {
        this.maGHCT = maGHCT;
    }

    public GioHang getGioHang() {
        return gioHang;
    }

    public void setGioHang(GioHang gioHang) {
        this.gioHang = gioHang;
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

    public LocalDateTime getNgayThem() {
        return ngayThem;
    }

    public void setNgayThem(LocalDateTime ngayThem) {
        this.ngayThem = ngayThem;
    }
}
