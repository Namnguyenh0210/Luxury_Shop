package com.example.projectend.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "SanPhamYeuThich")
public class SanPhamYeuThich {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaSPYT")
    private Long maSPYT;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaTK", nullable = false)
    private TaiKhoan taiKhoan;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaSP", nullable = false)
    private SanPham sanPham;

    @Column(name = "NgayThem")
    private LocalDateTime ngayThem = LocalDateTime.now();

    public SanPhamYeuThich() {}

    public SanPhamYeuThich(TaiKhoan taiKhoan, SanPham sanPham) {
        this.taiKhoan = taiKhoan;
        this.sanPham = sanPham;
    }

    public Long getMaSPYT() {
        return maSPYT;
    }

    public void setMaSPYT(Long maSPYT) {
        this.maSPYT = maSPYT;
    }

    public TaiKhoan getTaiKhoan() {
        return taiKhoan;
    }

    public void setTaiKhoan(TaiKhoan taiKhoan) {
        this.taiKhoan = taiKhoan;
    }

    public SanPham getSanPham() {
        return sanPham;
    }

    public void setSanPham(SanPham sanPham) {
        this.sanPham = sanPham;
    }

    public LocalDateTime getNgayThem() {
        return ngayThem;
    }

    public void setNgayThem(LocalDateTime ngayThem) {
        this.ngayThem = ngayThem;
    }
}
