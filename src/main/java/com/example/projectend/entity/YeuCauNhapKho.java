package com.example.projectend.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "YeuCauNhapKho")
public class YeuCauNhapKho {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaYeuCau")
    private Long maYeuCau;

    @ManyToOne
    @JoinColumn(name = "MaNV")
    private TaiKhoan nhanVien;

    @ManyToOne
    @JoinColumn(name = "MaBienThe")
    private SanPhamChiTiet sanPhamChiTiet;

    @Column(name = "SoLuongYeuCau")
    private Integer soLuongYeuCau;

    @Column(name = "NgayYeuCau")
    private LocalDateTime ngayYeuCau = LocalDateTime.now();

    @Column(name = "TrangThai")
    private Integer trangThai = 0; // 0: Chờ duyệt, 1: Đã duyệt, 2: Từ chối

    @Column(name = "GhiChu", length = 500)
    private String ghiChu;

    public YeuCauNhapKho() {}

    public Long getMaYeuCau() { return maYeuCau; }
    public void setMaYeuCau(Long maYeuCau) { this.maYeuCau = maYeuCau; }

    public TaiKhoan getNhanVien() { return nhanVien; }
    public void setNhanVien(TaiKhoan nhanVien) { this.nhanVien = nhanVien; }

    public SanPhamChiTiet getSanPhamChiTiet() { return sanPhamChiTiet; }
    public void setSanPhamChiTiet(SanPhamChiTiet sanPhamChiTiet) { this.sanPhamChiTiet = sanPhamChiTiet; }

    public Integer getSoLuongYeuCau() { return soLuongYeuCau; }
    public void setSoLuongYeuCau(Integer soLuongYeuCau) { this.soLuongYeuCau = soLuongYeuCau; }

    public LocalDateTime getNgayYeuCau() { return ngayYeuCau; }
    public void setNgayYeuCau(LocalDateTime ngayYeuCau) { this.ngayYeuCau = ngayYeuCau; }

    public Integer getTrangThai() { return trangThai; }
    public void setTrangThai(Integer trangThai) { this.trangThai = trangThai; }

    public String getGhiChu() { return ghiChu; }
    public void setGhiChu(String ghiChu) { this.ghiChu = ghiChu; }
}
