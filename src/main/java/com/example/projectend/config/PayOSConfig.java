package com.example.projectend.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

/**
 * ✨ PAYOS CONFIGURATION CLASS
 * Quản lý thông tin cấu hình PayOS Payment Gateway
 *
 * PayOS là cổng thanh toán tích hợp ngân hàng Việt Nam,
 * cho phép thanh toán qua QR code, chuyển khoản nhanh.
 */
@Configuration
public class PayOSConfig {

    // ========== THÔNG TIN XÁC THỰC PAYOS ==========

    /**
     * Client ID - Định danh ứng dụng merchant trên PayOS
     */
    @Value("${payos.client-id}")
    private String clientId;

    /**
     * API Key - Key bí mật để gọi API PayOS
     */
    @Value("${payos.api-key}")
    private String apiKey;

    /**
     * Checksum Key - Key để tạo và xác thực chữ ký (signature) webhook
     * Đảm bảo tính toàn vẹn của dữ liệu từ PayOS
     */
    @Value("${payos.checksum-key}")
    private String checksumKey;

    // ========== ENDPOINTS VÀ URLS ==========

    /**
     * Base URL của PayOS API
     */
    @Value("${payos.api-url}")
    private String apiUrl;

    /**
     * URL callback khi thanh toán thành công
     * Người dùng sẽ được redirect về đây sau khi thanh toán
     */
    @Value("${payos.return-url}")
    private String returnUrl;

    /**
     * URL callback khi người dùng hủy thanh toán
     */
    @Value("${payos.cancel-url}")
    private String cancelUrl;

    /**
     * URL webhook để nhận thông báo từ PayOS
     * PayOS sẽ gửi POST request đến URL này khi có thay đổi trạng thái thanh toán
     */
    @Value("${payos.webhook-url}")
    private String webhookUrl;

    // ========== GETTERS ==========

    public String getClientId() {
        return clientId;
    }

    public String getApiKey() {
        return apiKey;
    }

    public String getChecksumKey() {
        return checksumKey;
    }

    public String getApiUrl() {
        return apiUrl;
    }

    public String getReturnUrl() {
        return returnUrl;
    }

    public String getCancelUrl() {
        return cancelUrl;
    }

    public String getWebhookUrl() {
        return webhookUrl;
    }
}

