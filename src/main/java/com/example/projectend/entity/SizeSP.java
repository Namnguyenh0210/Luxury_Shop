package com.example.projectend.entity;

import jakarta.persistence.*;

/**
 * ENTITY SIZE SAN PHAM
 * Bảng: SizeSP
 * Mô tả: Lưu các size (S, M, L, XL...)
 */
@Entity
@Table(name = "SizeSP")
public class SizeSP {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaSize")
    private Long maSize;

    @Column(name = "TenSize", unique = true, nullable = false, length = 20)
    private String tenSize;

    // Constructors
    public SizeSP() {
    }

    public SizeSP(String tenSize) {
        this.tenSize = tenSize;
    }

    // Getters and Setters
    public Long getMaSize() {
        return maSize;
    }

    public void setMaSize(Long maSize) {
        this.maSize = maSize;
    }

    public String getTenSize() {
        return tenSize;
    }

    public void setTenSize(String tenSize) {
        this.tenSize = tenSize;
    }

    @Override
    public String toString() {
        return "SizeSP{" +
                "maSize=" + maSize +
                ", tenSize='" + tenSize + '\'' +
                '}';
    }
}

