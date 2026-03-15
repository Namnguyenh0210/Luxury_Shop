package com.example.projectend.entity;

import jakarta.persistence.*;

/**
 * ENTITY ROLE - LUXURY FASHION
 * Bảng: Role (theo SQL)
 * Quan hệ Many-to-Many với TaiKhoan
 */
@Entity
@Table(name = "VaiTro")
public class VaiTro {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaVaiTro")
    private Long maVaiTro;

    @Column(name = "TenVaiTro", nullable = false, unique = true, length = 50)
    private String tenVaiTro;

    // Constructors
    public VaiTro() {
    }

    public VaiTro(String tenVaiTro) {
        this.tenVaiTro = tenVaiTro;
    }

    // Getters and Setters
    public Long getMaVaiTro() {
        return maVaiTro;
    }

    public void setMaVaiTro(Long maVaiTro) {
        this.maVaiTro = maVaiTro;
    }

    public String getTenVaiTro() {
        return tenVaiTro;
    }

    public void setTenVaiTro(String tenVaiTro) {
        this.tenVaiTro = tenVaiTro;
    }
}
