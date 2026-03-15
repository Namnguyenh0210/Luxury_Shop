package com.example.projectend.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * ENTITY BÌNH LUẬN - Hệ thống comment cho Bài Viết
 * Lưu bình luận của khách hàng trên bài viết blog
 */
@Entity
@Table(name = "BinhLuan")
public class BinhLuan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaBL")
    private Long maBL;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaBV")
    private BaiViet baiViet;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "MaTK", nullable = false)
    private TaiKhoan taiKhoan;

    @Column(name = "NoiDung", length = 500, nullable = false)
    private String noiDung;

    @Column(name = "NgayBinhLuan")
    private LocalDateTime ngayBinhLuan = LocalDateTime.now();

    @Column(name = "AnDanh")
    private Boolean anDanh = false;

    @Column(name = "TrangThai")
    private Boolean trangThai = true;

    @Column(name = "SoLuotThich")
    private Integer soLuotThich = 0;

    @Column(name = "SoLuongPhanHoi")
    private Integer soLuongPhanHoi = 0;

    // Constructors
    public BinhLuan() {
    }

    // Getters & Setters
    public Long getMaBL() {
        return maBL;
    }

    public void setMaBL(Long maBL) {
        this.maBL = maBL;
    }

    public BaiViet getBaiViet() {
        return baiViet;
    }

    public void setBaiViet(BaiViet baiViet) {
        this.baiViet = baiViet;
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

    public LocalDateTime getNgayBinhLuan() {
        return ngayBinhLuan;
    }

    public void setNgayBinhLuan(LocalDateTime ngayBinhLuan) {
        this.ngayBinhLuan = ngayBinhLuan;
    }

    public Boolean getAnDanh() {
        return anDanh;
    }

    public void setAnDanh(Boolean anDanh) {
        this.anDanh = anDanh;
    }

    public Boolean getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(Boolean trangThai) {
        this.trangThai = trangThai;
    }

    public Integer getSoLuotThich() {
        return soLuotThich;
    }

    public void setSoLuotThich(Integer soLuotThich) {
        this.soLuotThich = soLuotThich;
    }

    public Integer getSoLuongPhanHoi() {
        return soLuongPhanHoi;
    }

    public void setSoLuongPhanHoi(Integer soLuongPhanHoi) {
        this.soLuongPhanHoi = soLuongPhanHoi;
    }

    // ===== ADMIN MODERATION =====
    @Column(name = "PhanHoiAdmin", length = 1000)
    private String phanHoiAdmin;

    @Column(name = "NgayPhanHoiAdmin")
    private LocalDateTime ngayPhanHoiAdmin;

    @Column(name = "SoLuotBaoCao")
    private Integer soLuotBaoCao = 0;

    public void incrementReport() {
        if (this.soLuotBaoCao == null) this.soLuotBaoCao = 0;
        this.soLuotBaoCao++;
    }

    public String getPhanHoiAdmin() {
        return phanHoiAdmin;
    }

    public void setPhanHoiAdmin(String phanHoiAdmin) {
        this.phanHoiAdmin = phanHoiAdmin;
    }

    public LocalDateTime getNgayPhanHoiAdmin() {
        return ngayPhanHoiAdmin;
    }

    public void setNgayPhanHoiAdmin(LocalDateTime ngayPhanHoiAdmin) {
        this.ngayPhanHoiAdmin = ngayPhanHoiAdmin;
    }

    public Integer getSoLuotBaoCao() {
        return soLuotBaoCao;
    }

    public void setSoLuotBaoCao(Integer soLuotBaoCao) {
        this.soLuotBaoCao = soLuotBaoCao;
    }
}
