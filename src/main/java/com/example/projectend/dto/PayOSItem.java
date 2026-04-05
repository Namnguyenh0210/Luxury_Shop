package com.example.projectend.dto;

/**
 * ✨ DTO SẢN PHẨM TRONG ĐON HÀNG PAYOS
 * Thông tin chi tiết về từng sản phẩm trong đơn hàng
 */
public class PayOSItem {

    /**
     * Tên sản phẩm
     */
    private String name;

    /**
     * Số lượng
     */
    private Integer quantity;

    /**
     * Đơn giá (VNĐ) - Dùng Long để tránh tràn số cho sản phẩm giá trị cao
     */
    private Long price;

    // ========== CONSTRUCTORS ==========

    public PayOSItem() {
    }

    public PayOSItem(String name, Integer quantity, Long price) {
        this.name = name;
        this.quantity = quantity;
        this.price = price;
    }

    // ========== GETTERS AND SETTERS ==========

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Long getPrice() {
        return price;
    }

    public void setPrice(Long price) {
        this.price = price;
    }
}

