package com.example.projectend.entity;

import jakarta.persistence.*;

/**
 * ENTITY MAU SAC SAN PHAM
 * Bảng: MauSacSP
 * Mô tả: Lưu các màu sắc (Đen, Trắng, Be...)
 */
@Entity
@Table(name = "MauSacSP")
public class MauSacSP {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaMau")
    private Long maMau;

    @Column(name = "TenMau", unique = true, nullable = false, length = 50)
    private String tenMau;

    @Column(name = "MaHex", length = 7)
    private String maHex;

    // Constructors
    public MauSacSP() {
    }

    public MauSacSP(String tenMau, String maHex) {
        this.tenMau = tenMau;
        this.maHex = maHex;
    }

    // Getters and Setters
    public Long getMaMau() {
        return maMau;
    }

    public void setMaMau(Long maMau) {
        this.maMau = maMau;
    }

    public String getTenMau() {
        return tenMau;
    }

    public void setTenMau(String tenMau) {
        this.tenMau = tenMau;
    }

    public String getMaHex() {
        return maHex;
    }

    public void setMaHex(String maHex) {
        this.maHex = maHex;
    }

    @Override
    public String toString() {
        return "MauSacSP{" +
                "maMau=" + maMau +
                ", tenMau='" + tenMau + '\'' +
                ", maHex='" + maHex + '\'' +
                '}';
    }
}

