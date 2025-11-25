package com.example.projectend.dto;

/**
 * ✨ DTO PHẢN HỒI TỪ PAYOS
 * Chứa thông tin phản hồi khi tạo link thanh toán hoặc kiểm tra trạng thái
 */
public class PayOSResponse {

    /**
     * Mã code phản hồi (00 = thành công)
     */
    private String code;

    /**
     * Thông báo
     */
    private String desc;

    /**
     * Dữ liệu phản hồi
     */
    private PayOSData data;

    /**
     * Chữ ký xác thực
     */
    private String signature;

    // ========== CONSTRUCTORS ==========

    public PayOSResponse() {
    }

    // ========== GETTERS AND SETTERS ==========

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public PayOSData getData() {
        return data;
    }

    public void setData(PayOSData data) {
        this.data = data;
    }

    public String getSignature() {
        return signature;
    }

    public void setSignature(String signature) {
        this.signature = signature;
    }

    /**
     * Kiểm tra xem giao dịch có thành công không
     */
    public boolean isSuccess() {
        return "00".equals(code);
    }
}

