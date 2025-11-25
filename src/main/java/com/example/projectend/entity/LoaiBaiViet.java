package com.example.projectend.entity;

import jakarta.persistence.*;

/**
 * ENTITY LOẠI BÀI VIẾT
 * Phân loại bài viết (Tin tức, Kiến thức, Hướng dẫn...)
 */
@Entity
@Table(name = "LoaiBaiViet")
public class LoaiBaiViet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaLoaiBV")
    private Long maLoaiBV;

    @Column(name = "TenLoaiBV", length = 100)
    private String tenLoaiBV;

    // Constructors
    public LoaiBaiViet() {
    }

    public LoaiBaiViet(String tenLoaiBV) {
        this.tenLoaiBV = tenLoaiBV;
    }

    // Getters & Setters
    public Long getMaLoaiBV() {
        return maLoaiBV;
    }

    public void setMaLoaiBV(Long maLoaiBV) {
        this.maLoaiBV = maLoaiBV;
    }

    public String getTenLoaiBV() {
        return tenLoaiBV;
    }

    public void setTenLoaiBV(String tenLoaiBV) {
        this.tenLoaiBV = tenLoaiBV;
    }
}

