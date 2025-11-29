package com.example.projectend.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "NhaCungCap")
public class NhaCungCap {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaNCC")
    private Long maNCC;

    @Column(name = "TenNCC", nullable = false, length = 100)
    private String tenNCC;

    @Column(name = "SoDienThoai", length = 20)
    private String soDienThoai;

    @Column(name = "DiaChi", length = 255)
    private String diaChi;

    // Constructors
    public NhaCungCap() {
    }

    public NhaCungCap(String tenNCC, String soDienThoai, String diaChi) {
        this.tenNCC = tenNCC;
        this.soDienThoai = soDienThoai;
        this.diaChi = diaChi;
    }

    // Getters and Setters
    public Long getMaNCC() {
        return maNCC;
    }

    public void setMaNCC(Long maNCC) {
        this.maNCC = maNCC;
    }

    public String getTenNCC() {
        return tenNCC;
    }

    public void setTenNCC(String tenNCC) {
        this.tenNCC = tenNCC;
    }

    public String getSoDienThoai() {
        return soDienThoai;
    }

    public void setSoDienThoai(String soDienThoai) {
        this.soDienThoai = soDienThoai;
    }

    public String getDiaChi() {
        return diaChi;
    }

    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }
}