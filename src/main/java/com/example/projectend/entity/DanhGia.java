
package com.example.projectend.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * ENTITY DANH GIA
 * Bảng: DanhGia
 */
@Entity
@Table(name = "DanhGia")
public class DanhGia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaDG")
    private Long maDG;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaCT", nullable = false, unique = true)
    private DonHangChiTiet donHangChiTiet;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaTK", nullable = false)
    private TaiKhoan taiKhoan;

    @Column(name = "NoiDung", length = 500)
    private String noiDung;

    @Column(name = "Diem", nullable = false)
    private Integer diem;

    @Column(name = "NgayDanhGia")
    private LocalDateTime ngayDanhGia;

    // ===== Constructor =====
    public DanhGia() {
        this.ngayDanhGia = LocalDateTime.now();
    }

    public DanhGia(DonHangChiTiet donHangChiTiet, TaiKhoan taiKhoan, Integer diem, String noiDung) {
        this.donHangChiTiet = donHangChiTiet;
        this.taiKhoan = taiKhoan;
        this.diem = diem;
        this.noiDung = noiDung;
        this.ngayDanhGia = LocalDateTime.now();
    }

    // ===== Getter & Setter =====
    public Long getMaDG() {
        return maDG;
    }

    public void setMaDG(Long maDG) {
        this.maDG = maDG;
    }

    public DonHangChiTiet getDonHangChiTiet() {
        return donHangChiTiet;
    }

    public void setDonHangChiTiet(DonHangChiTiet donHangChiTiet) {
        this.donHangChiTiet = donHangChiTiet;
    }

    public TaiKhoan getTaiKhoan() {
        return taiKhoan;
    }

    public void setTaiKhoan(TaiKhoan taiKhoan) {
        this.taiKhoan = taiKhoan;
    }

    public String getNoiDung() {
        return noiDung;
    }

    public void setNoiDung(String noiDung) {
        this.noiDung = noiDung;
    }

    public Integer getDiem() {
        return diem;
    }

    public void setDiem(Integer diem) {
        this.diem = diem;
    }

    public LocalDateTime getNgayDanhGia() {
        return ngayDanhGia;
    }

    public void setNgayDanhGia(LocalDateTime ngayDanhGia) {
        this.ngayDanhGia = ngayDanhGia;
    }
}