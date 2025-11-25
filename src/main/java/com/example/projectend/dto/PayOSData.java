package com.example.projectend.dto;

/**
 * ✨ DTO DỮ LIỆU THANH TOÁN PAYOS
 * Chứa thông tin chi tiết về link thanh toán và QR code
 */
public class PayOSData {

    /**
     * Link thanh toán (redirect người dùng đến trang này)
     */
    private String checkoutUrl;

    /**
     * Mã đơn hàng
     */
    private Long orderCode;

    /**
     * Số tiền
     */
    private Integer amount;

    /**
     * Mô tả
     */
    private String description;

    /**
     * Trạng thái thanh toán
     * PENDING: Chờ thanh toán
     * PAID: Đã thanh toán
     * CANCELLED: Đã hủy
     */
    private String status;

    /**
     * Mã giao dịch từ ngân hàng
     */
    private String transactionDateTime;

    /**
     * Thông tin QR code (base64 hoặc URL)
     */
    private String qrCode;

    // ========== CONSTRUCTORS ==========

    public PayOSData() {
    }

    // ========== GETTERS AND SETTERS ==========

    public String getCheckoutUrl() {
        return checkoutUrl;
    }

    public void setCheckoutUrl(String checkoutUrl) {
        this.checkoutUrl = checkoutUrl;
    }

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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTransactionDateTime() {
        return transactionDateTime;
    }

    public void setTransactionDateTime(String transactionDateTime) {
        this.transactionDateTime = transactionDateTime;
    }

    public String getQrCode() {
        return qrCode;
    }

    public void setQrCode(String qrCode) {
        this.qrCode = qrCode;
    }
}

