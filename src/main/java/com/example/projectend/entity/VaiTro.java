package com.example.projectend.entity;

import jakarta.persistence.*;

/**
 * ENTITY ROLE - LUXURY FASHION
 * Bảng: Role (theo SQL)
 * Quan hệ Many-to-Many với TaiKhoan
 */
@Entity
@Table(name = "Role")
public class VaiTro {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaRole")
    private Long maRole;

    @Column(name = "TenRole", nullable = false, unique = true, length = 50)
    private String tenRole;

    // Constructors
    public VaiTro() {
    }

    public VaiTro(String tenRole) {
        this.tenRole = tenRole;
    }

    // Getters and Setters
    public Long getMaRole() {
        return maRole;
    }

    public void setMaRole(Long maRole) {
        this.maRole = maRole;
    }

    public String getTenRole() {
        return tenRole;
    }

    public void setTenRole(String tenRole) {
        this.tenRole = tenRole;
    }
}
