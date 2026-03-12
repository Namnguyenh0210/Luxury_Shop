
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

    // ===== New Fields for Moderation =====
    @Column(name = "TrangThai")
    private Integer trangThai = 0; // 0 = Pending, 1 = Approved, 2 = Hidden

    @Column(name = "PhanHoi", length = 1000)
    private String phanHoi;

    @Column(name = "NgayPhanHoi")
    private LocalDateTime ngayPhanHoi;

    @Column(name = "ReportCount")
    private Integer reportCount = 0;

    public void incrementReport() {
        if (this.reportCount == null) this.reportCount = 0;
        this.reportCount++;
    }

    public Integer getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(Integer trangThai) {
        this.trangThai = trangThai;
    }

    public String getPhanHoi() {
        return phanHoi;
    }

    public void setPhanHoi(String phanHoi) {
        this.phanHoi = phanHoi;
    }

    public LocalDateTime getNgayPhanHoi() {
        return ngayPhanHoi;
    }

    public void setNgayPhanHoi(LocalDateTime ngayPhanHoi) {
        this.ngayPhanHoi = ngayPhanHoi;
    }

    public Integer getReportCount() {
        return reportCount;
    }

    public void setReportCount(Integer reportCount) {
        this.reportCount = reportCount;
    }
}