package com.example.projectend.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "PhieuNhap")
public class PhieuNhap {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaPN")
    private Long maPN;

    // Người nhập (Nhân viên)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaNV")
    private TaiKhoan nhanVien;

    // Nhà cung cấp
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaNCC")
    private NhaCungCap nhaCungCap;

    @Column(name = "NgayNhap")
    private LocalDateTime ngayNhap = LocalDateTime.now();

    @Column(name = "TongTien", precision = 18, scale = 2)
    private BigDecimal tongTien = BigDecimal.ZERO;

    @Column(name = "GhiChu", length = 500)
    private String ghiChu;

    // Chi tiết phiếu nhập
    @OneToMany(mappedBy = "phieuNhap", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private List<NhapKhoChiTiet> chiTiet = new ArrayList<>();

    // Constructors
    public PhieuNhap() {
    }

    public PhieuNhap(TaiKhoan nhanVien, NhaCungCap nhaCungCap, BigDecimal tongTien, String ghiChu) {
        this.nhanVien = nhanVien;
        this.nhaCungCap = nhaCungCap;
        this.tongTien = tongTien;
        this.ghiChu = ghiChu;
        this.ngayNhap = LocalDateTime.now();
    }

    // Getters & Setters
    public Long getMaPN() {
        return maPN;
    }

    public void setMaPN(Long maPN) {
        this.maPN = maPN;
    }

    public TaiKhoan getNhanVien() {
        return nhanVien;
    }

    public void setNhanVien(TaiKhoan nhanVien) {
        this.nhanVien = nhanVien;
    }

    public NhaCungCap getNhaCungCap() {
        return nhaCungCap;
    }

    public void setNhaCungCap(NhaCungCap nhaCungCap) {
        this.nhaCungCap = nhaCungCap;
    }

    public LocalDateTime getNgayNhap() {
        return ngayNhap;
    }

    public void setNgayNhap(LocalDateTime ngayNhap) {
        this.ngayNhap = ngayNhap;
    }

    public BigDecimal getTongTien() {
        return tongTien;
    }

    public void setTongTien(BigDecimal tongTien) {
        this.tongTien = tongTien;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }

    public List<NhapKhoChiTiet> getChiTiet() {
        return chiTiet;
    }

    public void setChiTiet(List<NhapKhoChiTiet> chiTiet) {
        this.chiTiet = chiTiet;
    }
}