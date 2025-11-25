package com.example.projectend.dto;

import java.math.BigDecimal;

/**
 * DTO cho item trong checkout - tránh LazyInitialization
 */
public class CheckoutItemDTO {
    private Long maBienThe;
    private String tenSP;
    private String thuongHieu;
    private String size;
    private String mau;
    private Integer soLuong;
    private BigDecimal giaBan;
    private BigDecimal thanhTien;
    private String anh;

    public CheckoutItemDTO() {}

    public CheckoutItemDTO(Long maBienThe, String tenSP, String thuongHieu, String size, String mau,
                           Integer soLuong, BigDecimal giaBan, BigDecimal thanhTien, String anh) {
        this.maBienThe = maBienThe;
        this.tenSP = tenSP;
        this.thuongHieu = thuongHieu;
        this.size = size;
        this.mau = mau;
        this.soLuong = soLuong;
        this.giaBan = giaBan;
        this.thanhTien = thanhTien;
        this.anh = anh;
    }

    // Getters & Setters
    public Long getMaBienThe() { return maBienThe; }
    public void setMaBienThe(Long maBienThe) { this.maBienThe = maBienThe; }
    public String getTenSP() { return tenSP; }
    public void setTenSP(String tenSP) { this.tenSP = tenSP; }
    public String getThuongHieu() { return thuongHieu; }
    public void setThuongHieu(String thuongHieu) { this.thuongHieu = thuongHieu; }
    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }
    public String getMau() { return mau; }
    public void setMau(String mau) { this.mau = mau; }
    public Integer getSoLuong() { return soLuong; }
    public void setSoLuong(Integer soLuong) { this.soLuong = soLuong; }
    public BigDecimal getGiaBan() { return giaBan; }
    public void setGiaBan(BigDecimal giaBan) { this.giaBan = giaBan; }
    public BigDecimal getThanhTien() { return thanhTien; }
    public void setThanhTien(BigDecimal thanhTien) { this.thanhTien = thanhTien; }
    public String getAnh() { return anh; }
    public void setAnh(String anh) { this.anh = anh; }
}

