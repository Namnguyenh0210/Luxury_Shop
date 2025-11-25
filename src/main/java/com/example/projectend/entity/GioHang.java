package com.example.projectend.entity;

import jakarta.persistence.*;

/**
 * ENTITY GIO HANG - LUXURY FASHION
 * Bảng: GioHang (theo SQL)
 * Mỗi user có 1 giỏ hàng, chi tiết nằm ở GioHangChiTiet
 */
@Entity
@Table(name = "GioHang")
public class GioHang {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaGioHang")
    private Long maGioHang;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaTK", nullable = false, unique = true)
    private TaiKhoan taiKhoan;

    // Constructors
    public GioHang() {
    }

    public GioHang(TaiKhoan taiKhoan) {
        this.taiKhoan = taiKhoan;
    }

    // Getters and Setters
    public Long getMaGioHang() {
        return maGioHang;
    }

    public void setMaGioHang(Long maGioHang) {
        this.maGioHang = maGioHang;
    }

    public TaiKhoan getTaiKhoan() {
        return taiKhoan;
    }

    public void setTaiKhoan(TaiKhoan taiKhoan) {
        this.taiKhoan = taiKhoan;
    }
}
