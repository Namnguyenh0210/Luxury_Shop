package com.example.projectend.entity;

import jakarta.persistence.*;

/**
 * ENTITY THUONG HIEU (BRAND)
 * Bảng: ThuongHieu
 * Mô tả: Lưu thông tin các thương hiệu (Gucci, Chanel, MLB...)
 */
@Entity
@Table(name = "ThuongHieu")
public class ThuongHieu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaTH")
    private Long maTH;

    @Column(name = "TenTH", nullable = false, length = 100)
    private String tenTH;

    @Column(name = "MoTa", length = 255)
    private String moTa;

    @Column(name = "TrangThai", nullable = false)
    private Integer trangThai = 1;

    @Transient
    private Long countNam = 0L;
    @Transient
    private Long countNu = 0L;
    @Transient
    private Long countUnisex = 0L;

    // Constructors
    public ThuongHieu() {
    }

    public ThuongHieu(String tenTH, String moTa) {
        this.tenTH = tenTH;
        this.moTa = moTa;
        this.trangThai = 1;
    }

    // Getters and Setters
    public Long getMaTH() {
        return maTH;
    }

    public void setMaTH(Long maTH) {
        this.maTH = maTH;
    }

    public String getTenTH() {
        return tenTH;
    }

    public void setTenTH(String tenTH) {
        this.tenTH = tenTH;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public Integer getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(Integer trangThai) {
        this.trangThai = trangThai;
    }

    public Long getCountNam() {
        return countNam;
    }

    public void setCountNam(Long countNam) {
        this.countNam = countNam;
    }

    public Long getCountNu() {
        return countNu;
    }

    public void setCountNu(Long countNu) {
        this.countNu = countNu;
    }

    public Long getCountUnisex() {
        return countUnisex;
    }

    public void setCountUnisex(Long countUnisex) {
        this.countUnisex = countUnisex;
    }

    @Override
    public String toString() {
        return "ThuongHieu{" +
                "maTH=" + maTH +
                ", tenTH='" + tenTH + '\'' +
                ", moTa='" + moTa + '\'' +
                '}';
    }
}

