package com.example.projectend.entity;

import jakarta.persistence.*;

/**
 * ENTITY HINH THUC THANH TOAN - LUXURY FASHION
 * Bảng: HinhThucThanhToan (theo SQL)
 */
@Entity
@Table(name = "HinhThucThanhToan")
public class PhuongThucThanhToan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaHinhThucTT")
    private Long maHinhThucTT;

    @Column(name = "TenHinhThuc", nullable = false, unique = true, length = 100)
    private String tenHinhThuc;

    @Column(name = "MoTa", length = 255)
    private String moTa;

    @Column(name = "TrangThai")
    private Boolean trangThai = true;

    // Constructors
    public PhuongThucThanhToan() {
    }

    public PhuongThucThanhToan(String tenHinhThuc) {
        this.tenHinhThuc = tenHinhThuc;
    }

    // Getters and Setters
    public Long getMaHinhThucTT() {
        return maHinhThucTT;
    }

    public void setMaHinhThucTT(Long maHinhThucTT) {
        this.maHinhThucTT = maHinhThucTT;
    }

    public String getTenHinhThuc() {
        return tenHinhThuc;
    }

    // Alias method for template compatibility
    public String getTenPhuongThuc() {
        return tenHinhThuc;
    }

    public void setTenHinhThuc(String tenHinhThuc) {
        this.tenHinhThuc = tenHinhThuc;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public Boolean getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(Boolean trangThai) {
        this.trangThai = trangThai;
    }

    // Helper: icon name cho Material Symbols để hiển thị trong checkout (tránh biểu thức phức tạp ở view)
    @Transient
    public String getIcon() {
        String name = tenHinhThuc != null ? tenHinhThuc.toLowerCase() : "";
        if (name.contains("cod") || name.contains("tiền mặt") || name.contains("cash")) {
            return "local_atm"; // thanh toán khi nhận hàng / tiền mặt
        }
        if (name.contains("payos") || name.contains("qr")) {
            return "qr_code_2"; // quét mã QR PayOS
        }
        if (name.contains("momo")) {
            return "account_balance_wallet"; // ví điện tử khác (ví dụ)
        }
        return "credit_card"; // mặc định là thẻ / online
    }
}
