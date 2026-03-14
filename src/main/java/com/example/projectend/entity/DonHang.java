package com.example.projectend.entity;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * ENTITY DON HANG - LUXURY FASHION (FIXED)
 * Bảng: DonHang (theo SQL)
 */
@JsonIgnoreProperties({"hibernateLazyInitializer","handler"})
@Entity
@Table(name = "DonHang")
public class DonHang {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaDH")
    private Long maDH;

    @JsonIgnoreProperties({"hibernateLazyInitializer","handler"})
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaTK")
    private TaiKhoan taiKhoan;

    @JsonIgnoreProperties({"hibernateLazyInitializer","handler"})
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaNhanVien")
    private TaiKhoan nhanVien;

    @Column(name = "NgayDat")
    private LocalDateTime ngayDat = LocalDateTime.now();

    @Column(name = "TongTien", precision = 18, scale = 2)
    private BigDecimal tongTien = BigDecimal.ZERO;

    @Column(name = "PhiShip", precision = 18, scale = 2)
    private BigDecimal phiShip = BigDecimal.ZERO;

    @JsonIgnoreProperties({"hibernateLazyInitializer","handler"})
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaDiaChiGiao")
    private DiaChi diaChiGiao;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaHinhThucTT")
    private PhuongThucThanhToan hinhThucThanhToan;

    @Column(name = "GhiChu", length = 500)
    private String ghiChu;

    @Column(name = "LyDoHuy", length = 255)
    private String lyDoHuy;

    @Column(name = "MaGiaoDich", length = 100)
    private String maGiaoDich;

    @Column(name = "TrangThaiDH", nullable = false)
    private Integer trangThaiDH = 0; // 0: Chờ xác nhận, 1: Đã xác nhận, 2: Đang giao, 3: Đã giao, 4: Hoàn tất, 5: Đã hủy

    @Column(name = "TrangThaiThanhToan", nullable = false)
    private Integer trangThaiThanhToan = 0; // 0: Chờ thanh toán, 1: Đã thanh toán

    @Column(name = "NgayThanhToan")
    private LocalDateTime ngayThanhToan;

    @Column(name = "NgayCapNhat")
    private LocalDateTime ngayCapNhat = LocalDateTime.now();

    @Column(name = "KhachBaoChuaNhan")
    private Boolean khachBaoChuaNhan = false;

    @Column(name = "LyDoChuaNhan", length = 255)
    private String lyDoChuaNhan;

    @Column(name = "MoTaChuaNhan", length = 1000)
    private String moTaChuaNhan;

    @OneToMany(mappedBy = "donHang", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnoreProperties("donHang")
    private List<DonHangChiTiet> chiTietList = new ArrayList<>();

    // Constructors
    public DonHang() {
    }

    public DonHang(TaiKhoan taiKhoan, DiaChi diaChiGiao, PhuongThucThanhToan hinhThucThanhToan) {
        this.taiKhoan = taiKhoan;
        this.diaChiGiao = diaChiGiao;
        this.hinhThucThanhToan = hinhThucThanhToan;
    }

    // Getters and Setters
    public Long getMaDH() {
        return maDH;
    }

    public void setMaDH(Long maDH) {
        this.maDH = maDH;
    }

    public TaiKhoan getTaiKhoan() {
        return taiKhoan;
    }

    public void setTaiKhoan(TaiKhoan taiKhoan) {
        this.taiKhoan = taiKhoan;
    }

    public TaiKhoan getNhanVien() {
        return nhanVien;
    }

    public void setNhanVien(TaiKhoan nhanVien) {
        this.nhanVien = nhanVien;
    }

    public LocalDateTime getNgayDat() {
        return ngayDat;
    }

    public void setNgayDat(LocalDateTime ngayDat) {
        this.ngayDat = ngayDat;
    }

    public BigDecimal getTongTien() {
        return tongTien;
    }

    public void setTongTien(BigDecimal tongTien) {
        this.tongTien = tongTien;
    }

    public BigDecimal getPhiShip() {
        return phiShip;
    }

    public void setPhiShip(BigDecimal phiShip) {
        this.phiShip = phiShip;
    }

    public DiaChi getDiaChiGiao() {
        return diaChiGiao;
    }

    public void setDiaChiGiao(DiaChi diaChiGiao) {
        this.diaChiGiao = diaChiGiao;
    }

    public PhuongThucThanhToan getHinhThucThanhToan() {
        return hinhThucThanhToan;
    }

    public void setHinhThucThanhToan(PhuongThucThanhToan hinhThucThanhToan) {
        this.hinhThucThanhToan = hinhThucThanhToan;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }

    public String getLyDoHuy() {
        return lyDoHuy;
    }

    public void setLyDoHuy(String lyDoHuy) {
        this.lyDoHuy = lyDoHuy;
    }

    public String getMaGiaoDich() {
        return maGiaoDich;
    }

    public void setMaGiaoDich(String maGiaoDich) {
        this.maGiaoDich = maGiaoDich;
    }

    public Integer getTrangThaiDH() {
        return trangThaiDH;
    }

    public void setTrangThaiDH(Integer trangThaiDH) {
        this.trangThaiDH = trangThaiDH;
    }

    public Integer getTrangThaiThanhToan() {
        return trangThaiThanhToan;
    }

    public void setTrangThaiThanhToan(Integer trangThaiThanhToan) {
        this.trangThaiThanhToan = trangThaiThanhToan;
    }

    public LocalDateTime getNgayThanhToan() {
        return ngayThanhToan;
    }

    public void setNgayThanhToan(LocalDateTime ngayThanhToan) {
        this.ngayThanhToan = ngayThanhToan;
    }

    public LocalDateTime getNgayCapNhat() {
        return ngayCapNhat;
    }

    public void setNgayCapNhat(LocalDateTime ngayCapNhat) {
        this.ngayCapNhat = ngayCapNhat;
    }

    public List<DonHangChiTiet> getChiTietList() {
        return chiTietList;
    }

    public void setChiTietList(List<DonHangChiTiet> chiTietList) {
        this.chiTietList = chiTietList;
    }

    // Helper method
    public String getTrangThaiDHText() {
        switch (trangThaiDH) {
            case 0: return "Chờ xác nhận";
            case 1: return "Đã xác nhận";
            case 2: return "Đang giao";
            case 3: return "Đã giao";
            case 4: return "Hoàn tất";
            case 5: return "Đã hủy";
            default: return "Không xác định";
        }
    }

    public String getTrangThaiDonHang() {
        return getTrangThaiDHText();
    }

    public Boolean getKhachBaoChuaNhan() {
        return khachBaoChuaNhan;
    }

    public void setKhachBaoChuaNhan(Boolean khachBaoChuaNhan) {
        this.khachBaoChuaNhan = khachBaoChuaNhan;
    }

    public String getLyDoChuaNhan() {
        return lyDoChuaNhan;
    }

    public void setLyDoChuaNhan(String lyDoChuaNhan) {
        this.lyDoChuaNhan = lyDoChuaNhan;
    }

    public String getMoTaChuaNhan() {
        return moTaChuaNhan;
    }

    public void setMoTaChuaNhan(String moTaChuaNhan) {
        this.moTaChuaNhan = moTaChuaNhan;
    }

    public String getTrangThaiThanhToanText() {
        switch (trangThaiThanhToan) {
            case 0: return "Chờ thanh toán";
            case 1: return "Đã thanh toán";
            default: return "Không xác định";
        }
    }
}
