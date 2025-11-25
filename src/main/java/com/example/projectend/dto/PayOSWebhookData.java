package com.example.projectend.dto;

/**
 * ✨ DTO WEBHOOK TỪ PAYOS
 * PayOS gửi thông báo về khi có thay đổi trạng thái thanh toán
 */
public class PayOSWebhookData {

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
     * Mã tài khoản (account number)
     */
    private String accountNumber;

    /**
     * Mã tham chiếu
     */
    private String reference;

    /**
     * Thời gian giao dịch
     */
    private String transactionDateTime;

    /**
     * Mã giao dịch ngân hàng
     */
    private String counterAccountBankId;

    /**
     * Số tài khoản ngân hàng
     */
    private String counterAccountBankName;

    /**
     * Tên tài khoản ngân hàng
     */
    private String counterAccountName;

    /**
     * Số tài khoản đối tác
     */
    private String counterAccountNumber;

    /**
     * Nội dung chuyển khoản
     */
    private String virtualAccountName;

    /**
     * Số tài khoản ảo
     */
    private String virtualAccountNumber;

    /**
     * Mã code (00 = thành công)
     */
    private String code;

    /**
     * Chữ ký từ PayOS (để xác thực)
     */
    private String signature;

    // ========== CONSTRUCTORS ==========

    public PayOSWebhookData() {
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

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getTransactionDateTime() {
        return transactionDateTime;
    }

    public void setTransactionDateTime(String transactionDateTime) {
        this.transactionDateTime = transactionDateTime;
    }

    public String getCounterAccountBankId() {
        return counterAccountBankId;
    }

    public void setCounterAccountBankId(String counterAccountBankId) {
        this.counterAccountBankId = counterAccountBankId;
    }

    public String getCounterAccountBankName() {
        return counterAccountBankName;
    }

    public void setCounterAccountBankName(String counterAccountBankName) {
        this.counterAccountBankName = counterAccountBankName;
    }

    public String getCounterAccountName() {
        return counterAccountName;
    }

    public void setCounterAccountName(String counterAccountName) {
        this.counterAccountName = counterAccountName;
    }

    public String getCounterAccountNumber() {
        return counterAccountNumber;
    }

    public void setCounterAccountNumber(String counterAccountNumber) {
        this.counterAccountNumber = counterAccountNumber;
    }

    public String getVirtualAccountName() {
        return virtualAccountName;
    }

    public void setVirtualAccountName(String virtualAccountName) {
        this.virtualAccountName = virtualAccountName;
    }

    public String getVirtualAccountNumber() {
        return virtualAccountNumber;
    }

    public void setVirtualAccountNumber(String virtualAccountNumber) {
        this.virtualAccountNumber = virtualAccountNumber;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getSignature() {
        return signature;
    }

    public void setSignature(String signature) {
        this.signature = signature;
    }

    /**
     * Kiểm tra thanh toán thành công
     */
    public boolean isSuccess() {
        return "00".equals(code);
    }
}

