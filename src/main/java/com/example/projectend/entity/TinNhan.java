package com.example.projectend.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

import java.time.LocalDateTime;

/**
 * ENTITY TIN NHẮN - LƯU TRỮ TIN NHẮN TRONG CUỘC HỘI THOẠI
 * Bảng: TinNhan
 */
@Entity
@Table(name = "TinNhan")
public class TinNhan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaTinNhan")
    private Long maTinNhan;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaCuocTroChuyen", nullable = false)
    @JsonIgnoreProperties("tinNhans")
    private CuocTroChuyen cuocTroChuyen;

    @Column(name = "LoaiNguoiGui", nullable = false, length = 10)
    private String loaiNguoiGui; // 'USER', 'AI', 'STAFF'

    @Column(name = "NoiDung", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String noiDung;

    @Column(name = "NgayGui")
    private LocalDateTime ngayGui = LocalDateTime.now();

    @Column(name = "DaDoc")
    private Boolean daDoc = false; // false: Chưa đọc, true: Đã đọc

    // Constructors
    public TinNhan() {
    }

    public TinNhan(CuocTroChuyen cuocTroChuyen, String loaiNguoiGui, String noiDung) {
        this.cuocTroChuyen = cuocTroChuyen;
        this.loaiNguoiGui = loaiNguoiGui;
        this.noiDung = noiDung;
    }

    // Getters and Setters
    public Long getMaTinNhan() {
        return maTinNhan;
    }

    public void setMaTinNhan(Long maTinNhan) {
        this.maTinNhan = maTinNhan;
    }

    public CuocTroChuyen getCuocTroChuyen() {
        return cuocTroChuyen;
    }

    public void setCuocTroChuyen(CuocTroChuyen cuocTroChuyen) {
        this.cuocTroChuyen = cuocTroChuyen;
    }

    public String getLoaiNguoiGui() {
        return loaiNguoiGui;
    }

    public void setLoaiNguoiGui(String loaiNguoiGui) {
        this.loaiNguoiGui = loaiNguoiGui;
    }

    public String getNoiDung() {
        return noiDung;
    }

    public void setNoiDung(String noiDung) {
        this.noiDung = noiDung;
    }

    public LocalDateTime getNgayGui() {
        return ngayGui;
    }

    public void setNgayGui(LocalDateTime ngayGui) {
        this.ngayGui = ngayGui;
    }

    public Boolean getDaDoc() {
        return daDoc;
    }

    public void setDaDoc(Boolean daDoc) {
        this.daDoc = daDoc;
    }
}
