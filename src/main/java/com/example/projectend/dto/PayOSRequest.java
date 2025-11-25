package com.example.projectend.dto;

import java.math.BigDecimal;
import java.util.List;

/**
 * ✨ DTO YÊU CẦU TẠO THANH TOÁN PAYOS
 * Class này chứa thông tin cần thiết để tạo link thanh toán trên PayOS
 */
public class PayOSRequest {

    /**
     * Mã đơn hàng (orderCode) - PHẢI LÀ UNIQUE
     * PayOS yêu cầu orderCode là số nguyên dương
     */
    private Long orderCode;

    /**
     * Số tiền thanh toán (đơn vị: VNĐ)
     * PayOS yêu cầu amount là số nguyên
     */
    private Integer amount;

    /**
     * Mô tả đơn hàng
     */
    private String description;

    /**
     * URL trả về sau khi thanh toán thành công
     */
    private String returnUrl;

    /**
     * URL trả về khi hủy thanh toán
     */
    private String cancelUrl;

    /**
     * Danh sách sản phẩm trong đơn hàng
     */
    private List<PayOSItem> items;

    /**
     * Tên người mua
     */
    private String buyerName;

    /**
     * Email người mua
     */
    private String buyerEmail;

    /**
     * Số điện thoại người mua
     */
    private String buyerPhone;

    /**
     * Địa chỉ người mua
     */
    private String buyerAddress;

    // ========== CONSTRUCTORS ==========

    public PayOSRequest() {
    }

    public PayOSRequest(Long orderCode, Integer amount, String description) {
        this.orderCode = orderCode;
        this.amount = amount;
        this.description = description;
    }

    // ========== GETTERS AND SETTERS ==========

    public Long getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(Long orderCode) {
        this.orderCode = orderCode;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getReturnUrl() {
        return returnUrl;
    }

    public void setReturnUrl(String returnUrl) {
        this.returnUrl = returnUrl;
    }

    public String getCancelUrl() {
        return cancelUrl;
    }

    public void setCancelUrl(String cancelUrl) {
        this.cancelUrl = cancelUrl;
    }

    public List<PayOSItem> getItems() {
        return items;
    }

    public void setItems(List<PayOSItem> items) {
        this.items = items;
    }

    public String getBuyerName() {
        return buyerName;
    }

    public void setBuyerName(String buyerName) {
        this.buyerName = buyerName;
    }

    public String getBuyerEmail() {
        return buyerEmail;
    }

    public void setBuyerEmail(String buyerEmail) {
        this.buyerEmail = buyerEmail;
    }

    public String getBuyerPhone() {
        return buyerPhone;
    }

    public void setBuyerPhone(String buyerPhone) {
        this.buyerPhone = buyerPhone;
    }

    public String getBuyerAddress() {
        return buyerAddress;
    }

    public void setBuyerAddress(String buyerAddress) {
        this.buyerAddress = buyerAddress;
    }
}

