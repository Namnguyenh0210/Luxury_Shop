package com.example.projectend.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * ENTITY KHUYEN MAI - LUXURY FASHION
 * Bảng: KhuyenMai
 */
@Entity
@Table(name = "KhuyenMai")
public class KhuyenMai {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaKM")
    private Long maKM;

    @Column(name = "TenKM", nullable = false, length = 100)
    private String tenKM;

    @Column(name = "MaCode", nullable = false, unique = true, length = 50)
    private String maCode;

    @Column(name = "LoaiKM", length = 50)
    private String loaiKM;

    @Column(name = "LoaiGiaTri")
    private Integer loaiGiaTri = 0; // 0: %, 1: VND

    @Column(name = "GiaTri", precision = 18, scale = 2)
    private BigDecimal giaTri;

    @Column(name = "NgayBatDau", nullable = false)
    private LocalDateTime ngayBatDau;

    @Column(name = "NgayKetThuc")
    private LocalDateTime ngayKetThuc;

    @Column(name = "MaGoi")
    private Long maGoi;

    @Column(name = "TrangThai")
    private Boolean trangThai = true;

    @Column(name = "SoLanSuDung")
    private Integer soLanSuDung = 0;

    // Constructors
    public KhuyenMai() {
    }

    // Getters and Setters
    public Long getMaKM() {
        return maKM;
    }

    public void setMaKM(Long maKM) {
        this.maKM = maKM;
    }

    public String getTenKM() {
        return tenKM;
    }

    public void setTenKM(String tenKM) {
        this.tenKM = tenKM;
    }

    public String getMaCode() {
        return maCode;
    }

    public void setMaCode(String maCode) {
        this.maCode = maCode;
    }

    public String getLoaiKM() {
        return loaiKM;
    }

    public void setLoaiKM(String loaiKM) {
        this.loaiKM = loaiKM;
    }

    public Integer getLoaiGiaTri() {
        return loaiGiaTri;
    }

    public void setLoaiGiaTri(Integer loaiGiaTri) {
        this.loaiGiaTri = loaiGiaTri;
    }

    public BigDecimal getGiaTri() {
        return giaTri;
    }

    public void setGiaTri(BigDecimal giaTri) {
        this.giaTri = giaTri;
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

    public Long getMaGoi() {
        return maGoi;
    }

    public void setMaGoi(Long maGoi) {
        this.maGoi = maGoi;
    }

    public Boolean getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(Boolean trangThai) {
        this.trangThai = trangThai;
    }

    public Integer getSoLanSuDung() {
        return soLanSuDung;
    }

    public void setSoLanSuDung(Integer soLanSuDung) {
        this.soLanSuDung = soLanSuDung;
    }

    /**
     * Kiểm tra khuyến mãi có còn hiệu lực không
     */
    public boolean isActive() {
        if (!trangThai) return false;
        LocalDateTime now = LocalDateTime.now();
        if (ngayBatDau != null && now.isBefore(ngayBatDau)) return false;
        if (ngayKetThuc != null && now.isAfter(ngayKetThuc)) return false;
        return true;
    }

    /**
     * Tính giá sau giảm
     */
    public BigDecimal calculateDiscountedPrice(BigDecimal originalPrice) {
        if (!isActive() || originalPrice == null || giaTri == null) {
            return originalPrice;
        }

        if (loaiGiaTri == 0) {
            // Giảm theo %
            BigDecimal discount = originalPrice.multiply(giaTri).divide(BigDecimal.valueOf(100));
            return originalPrice.subtract(discount);
        } else {
            // Giảm theo VND
            BigDecimal result = originalPrice.subtract(giaTri);
            return result.compareTo(BigDecimal.ZERO) < 0 ? BigDecimal.ZERO : result;
        }
    }

    /**
     * Lấy % giảm giá để hiển thị
     */
    public BigDecimal getDiscountPercent() {
        if (!isActive() || giaTri == null) return BigDecimal.ZERO;
        if (loaiGiaTri == 0) {
            return giaTri;
        }
        return BigDecimal.ZERO;
    }
}

