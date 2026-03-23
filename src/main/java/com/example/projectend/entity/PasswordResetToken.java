package com.example.projectend.entity;


import jakarta.persistence.*;
import java.time.LocalDateTime;

    @Entity
    @Table(name = "PasswordResetToken")
    public class PasswordResetToken {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;

        private String email;

        private String otp;

        private LocalDateTime expiry;

        private Boolean trangThai = true;

        @Column(name = "NgayTao")
        @PrePersist
        public void prePersist() {
            ngayTao = LocalDateTime.now();
        } LocalDateTime ngayTao = LocalDateTime.now();

        // ===== GETTER SETTER =====

        public Long getId() {
            return id;
        }

        public String getEmail() {
            return email;
        }

        public String getOtp() {
            return otp;
        }

        public LocalDateTime getExpiry() {
            return expiry;
        }

        public Boolean getTrangThai() {
            return trangThai;
        }

        public LocalDateTime getNgayTao() {
            return ngayTao;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public void setOtp(String otp) {
            this.otp = otp;
        }

        public void setExpiry(LocalDateTime expiry) {
            this.expiry = expiry;
        }

        public void setTrangThai(Boolean trangThai) {
            this.trangThai = trangThai;
        }
    }