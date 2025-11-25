package com.example.projectend.dto;

import java.math.BigDecimal;

/**
 * DTO phẳng cho 1 item giỏ hàng dùng để render view an toàn
 * Tránh LazyInitializationException khi Thymeleaf truy cập sâu vào entity.
 */
public class CartItemDTO {
    private Long id;              // maGHCT hoặc maBienThe (session)
    private boolean dbItem;       // true nếu từ DB
    private Long maBienThe;       // Mã biến thể
    private String tenSP;         // Tên sản phẩm
    private String thuongHieu;    // Tên thương hiệu
    private String size;          // Size
    private String mau;           // Màu
    private Integer soLuong;      // Số lượng
    private BigDecimal giaBan;    // Giá bán đơn chiếc
    private BigDecimal thanhTien; // Thành tiền = giaBan * soLuong
    private String anh;           // Đường dẫn ảnh

    public CartItemDTO() {}

    public CartItemDTO(Long id, boolean dbItem, Long maBienThe, String tenSP, String thuongHieu,
                       String size, String mau, Integer soLuong, BigDecimal giaBan, BigDecimal thanhTien, String anh) {
        this.id = id;
        this.dbItem = dbItem;
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
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public boolean isDbItem() { return dbItem; }
    public void setDbItem(boolean dbItem) { this.dbItem = dbItem; }
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

