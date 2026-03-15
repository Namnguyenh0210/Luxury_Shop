package com.example.projectend.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * ENTITY CUỘC TRÒ CHUYỆN - LƯU TRỮ CUỘC HỘI THOẠI CHATBOT
 * Bảng: CuocTroChuyen
 */
@Entity
@Table(name = "CuocTroChuyen")
public class CuocTroChuyen {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaCuocTroChuyen")
    private Long maCuocTroChuyen;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaTK")
    @JsonIgnoreProperties({ "hibernateLazyInitializer", "handler", "matKhau", "vaiTros" })
    private TaiKhoan taiKhoan;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaNhanVien")
    @JsonIgnoreProperties({ "hibernateLazyInitializer", "handler", "matKhau", "vaiTros" })
    private TaiKhoan nhanVien;

    @Column(name = "TrangThai", nullable = false, length = 10)
    private String trangThai = "AI"; // 'AI', 'HUMAN', 'CLOSED'

    @Column(name = "NgayTao")
    private LocalDateTime ngayTao = LocalDateTime.now();

    @Column(name = "NgayCapNhat")
    private LocalDateTime ngayCapNhat = LocalDateTime.now();

    @OneToMany(mappedBy = "cuocTroChuyen", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonIgnoreProperties("cuocTroChuyen")
    private List<TinNhan> tinNhans = new ArrayList<>();

    @Transient
    private String lastMessage;

    // Constructors
    public CuocTroChuyen() {
    }

    public CuocTroChuyen(TaiKhoan taiKhoan) {
        this.taiKhoan = taiKhoan;
    }

    // Getters and Setters
    public Long getMaCuocTroChuyen() {
        return maCuocTroChuyen;
    }

    public void setMaCuocTroChuyen(Long maCuocTroChuyen) {
        this.maCuocTroChuyen = maCuocTroChuyen;
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

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public LocalDateTime getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(LocalDateTime ngayTao) {
        this.ngayTao = ngayTao;
    }

    public LocalDateTime getNgayCapNhat() {
        return ngayCapNhat;
    }

    public void setNgayCapNhat(LocalDateTime ngayCapNhat) {
        this.ngayCapNhat = ngayCapNhat;
    }

    public List<TinNhan> getTinNhans() {
        return tinNhans;
    }

    public void setTinNhans(List<TinNhan> tinNhans) {
        this.tinNhans = tinNhans;
    }

    public String getLastMessage() {
        return lastMessage;
    }

    public void setLastMessage(String lastMessage) {
        this.lastMessage = lastMessage;
    }
}
