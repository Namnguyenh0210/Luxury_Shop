package com.example.projectend.entity;

import jakarta.persistence.*;

/**
 * ENTITY LOAI SAN PHAM - LUXURY FASHION
 * Bảng: LoaiSanPham
 * Mô tả: Các loại sản phẩm (Áo Polo, T-Shirt, Quần, Áo Khoác...)
 */
@Entity
@Table(name = "LoaiSanPham")
public class LoaiSanPham {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaLoai")
    private Long maLoai;

    @Column(name = "TenLoai", nullable = false, length = 100)
    private String tenLoai;

    @Column(name = "MoTa", length = 255)
    private String moTa;

    // Constructors
    public LoaiSanPham() {
    }

    public LoaiSanPham(String tenLoai, String moTa) {
        this.tenLoai = tenLoai;
        this.moTa = moTa;
    }

    // Getters and Setters
    public Long getMaLoai() {
        return maLoai;
    }

    public void setMaLoai(Long maLoai) {
        this.maLoai = maLoai;
    }

    public String getTenLoai() {
        return tenLoai;
    }

    public void setTenLoai(String tenLoai) {
        this.tenLoai = tenLoai;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    @Override
    public String toString() {
        return "LoaiSanPham{" +
                "maLoai=" + maLoai +
                ", tenLoai='" + tenLoai + '\'' +
                '}';
    }
}
