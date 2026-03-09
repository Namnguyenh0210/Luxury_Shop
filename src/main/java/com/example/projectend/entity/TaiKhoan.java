package com.example.projectend.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * ENTITY TAI KHOAN - LUXURY FASHION
 * Bảng: TaiKhoan (theo SQL)
 * Quan hệ Many-to-Many với Role qua bảng TaiKhoan_Role
 *
 * CẬP NHẬT: Thêm field Provider cho Google OAuth2 Login
 */
@JsonIgnoreProperties({"hibernateLazyInitializer","handler"})
@Entity
@Table(name = "TaiKhoan")
public class TaiKhoan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaTK")
    @JsonProperty("maTK")
    private Long maTK;

    @Column(name = "HoTen", nullable = false, length = 100)
    @JsonProperty("hoTen")
    private String hoTen;

    @Column(name = "Email", nullable = false, unique = true, length = 100)
    private String email;

    @Column(name = "MatKhau", length = 255)  // Nullable cho Google OAuth2
    private String matKhau;

    @Column(name = "SoDienThoai", length = 20)
    @JsonProperty("soDienThoai")
    private String soDienThoai;

    @Column(name = "DiaChi", length = 255)
    private String diaChi;

    @Column(name = "Avatar", length = 255)
    private String avatar;

    @Column(name = "LastLogin")
    private LocalDateTime lastLogin;

    @Column(name = "TrangThai", nullable = false)
    @JsonProperty("trangThai")
    private Boolean trangThai = true;

    @Column(name = "NgayTao")
    private LocalDateTime ngayTao = LocalDateTime.now();

    @Column(name = "NgayCapNhat")
    private LocalDateTime ngayCapNhat = LocalDateTime.now();

    // ✨ MỚI: Thêm field Provider (LOCAL hoặc GOOGLE)
    @Column(name = "Provider", length = 20)
    private String provider = "LOCAL";  // Mặc định là LOCAL

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "TaiKhoan_Role",
        joinColumns = @JoinColumn(name = "MaTK"),
        inverseJoinColumns = @JoinColumn(name = "MaRole")
    )
    private Set<VaiTro> roles = new HashSet<>();

    // Constructors
    public TaiKhoan() {
    }

    public TaiKhoan(String hoTen, String email, String matKhau) {
        this.hoTen = hoTen;
        this.email = email;
        this.matKhau = matKhau;
    }
    
    // Trường tạm để nhận mật khẩu từ giao diện, không lưu vào DB
    @Transient
    @JsonProperty("matKhauMoi")
    private String matKhauMoi;
    public String getMatKhauMoi() { return matKhauMoi; }
    public void setMatKhauMoi(String matKhauMoi) { this.matKhauMoi = matKhauMoi; }

    // Getters and Setters
    public Long getMaTK() {
        return maTK;
    }

    public void setMaTK(Long maTK) {
        this.maTK = maTK;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
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

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public LocalDateTime getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(LocalDateTime lastLogin) {
        this.lastLogin = lastLogin;
    }

    public Boolean getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(Boolean trangThai) {
        this.trangThai = trangThai;
    }

    public LocalDateTime getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(LocalDateTime ngayTao) {
        this.ngayTao = ngayTao;
    }

    public LocalDateTime getNgayCapNhat() {
        return ngayCapNhat;
    }

    public void setNgayCapNhat(LocalDateTime ngayCapNhat) {
        this.ngayCapNhat = ngayCapNhat;
    }

    // ✨ MỚI: Getter/Setter cho Provider
    public String getProvider() {
        return provider;
    }

    public void setProvider(String provider) {
        this.provider = provider;
    }

    public Set<VaiTro> getRoles() {
        return roles;
    }

    public void setRoles(Set<VaiTro> roles) {
        this.roles = roles;
    }

    // Helper methods
    public void addRole(VaiTro role) {
        this.roles.add(role);
    }

    public void removeRole(VaiTro role) {
        this.roles.remove(role);
    }

    @Override
    public String toString() {
        return "TaiKhoan{" +
                "maTK=" + maTK +
                ", hoTen='" + hoTen + '\'' +
                ", email='" + email + '\'' +
                ", provider='" + provider + '\'' +
                ", trangThai=" + trangThai +
                '}';
    }
    
}
