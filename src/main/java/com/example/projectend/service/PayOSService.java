package com.example.projectend.service;

import com.example.projectend.config.PayOSConfig;
import com.example.projectend.dto.*;
import com.example.projectend.entity.DonHang;
import com.example.projectend.entity.DonHangChiTiet;
import com.google.gson.Gson;
import okhttp3.*;
import org.apache.commons.codec.digest.HmacUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.stream.Collectors;

/**
 * ✨ PAYOS SERVICE
 * Service xử lý tất cả logic liên quan đến thanh toán PayOS
 *
 * Chức năng chính:
 * 1. Tạo link thanh toán (checkout URL) và QR code
 * 2. Xác thực webhook từ PayOS (verify signature)
 * 3. Kiểm tra trạng thái thanh toán
 * 4. Hủy thanh toán
 */
@Service
public class PayOSService {

    private static final Logger logger = LoggerFactory.getLogger(PayOSService.class);

    @Autowired
    private PayOSConfig payOSConfig;

    private final OkHttpClient httpClient = new OkHttpClient();
    private final Gson gson = new Gson();

    /**
     * ✅ TẠO LINK THANH TOÁN PAYOS
     *
     * @param donHang Đơn hàng cần thanh toán
     * @return PayOSResponse chứa checkout URL và QR code
     */
    public PayOSResponse createPaymentLink(DonHang donHang) {
        try {
            logger.info("🔄 Bắt đầu tạo link thanh toán PayOS cho đơn hàng #{}", donHang.getMaDH());

            // Bước 1: Chuẩn bị dữ liệu request
            PayOSRequest request = new PayOSRequest();
            request.setOrderCode(donHang.getMaDH()); // Mã đơn hàng (unique)
            request.setAmount(donHang.getTongTien().intValue()); // Tổng tiền (VNĐ)
            request.setDescription("Thanh toan don hang #" + donHang.getMaDH());
            request.setReturnUrl(payOSConfig.getReturnUrl());
            request.setCancelUrl(payOSConfig.getCancelUrl());

            // Bước 2: Thêm thông tin người mua
            if (donHang.getTaiKhoan() != null) {
                request.setBuyerName(donHang.getTaiKhoan().getHoTen());
                request.setBuyerEmail(donHang.getTaiKhoan().getEmail());
                request.setBuyerPhone(donHang.getTaiKhoan().getSoDienThoai());
            }

            // Bước 3: Thêm danh sách sản phẩm
            List<PayOSItem> items = new ArrayList<>();
            if (donHang.getChiTietList() != null && !donHang.getChiTietList().isEmpty()) {
                for (DonHangChiTiet ct : donHang.getChiTietList()) {
                    PayOSItem item = new PayOSItem();

                    // Lấy tên sản phẩm
                    String tenSP = "Sản phẩm";
                    if (ct.getSanPhamChiTiet() != null && ct.getSanPhamChiTiet().getSanPham() != null) {
                        tenSP = ct.getSanPhamChiTiet().getSanPham().getTenSP();

                        // Thêm thông tin size và màu
                        if (ct.getSanPhamChiTiet().getSizeSP() != null) {
                            tenSP += " - Size " + ct.getSanPhamChiTiet().getSizeSP().getTenSize();
                        }
                        if (ct.getSanPhamChiTiet().getMauSacSP() != null) {
                            tenSP += " - " + ct.getSanPhamChiTiet().getMauSacSP().getTenMau();
                        }
                    }

                    item.setName(tenSP);
                    item.setQuantity(ct.getSoLuong());
                    item.setPrice(ct.getDonGia().intValue());
                    items.add(item);
                }
            } else {
                // Nếu không có chi tiết, tạo 1 item tổng quát
                PayOSItem item = new PayOSItem();
                item.setName("Đơn hàng #" + donHang.getMaDH());
                item.setQuantity(1);
                item.setPrice(donHang.getTongTien().intValue());
                items.add(item);
            }
            request.setItems(items);

            // Bước 4: Tạo chữ ký (signature) để xác thực request
            String signature = generateSignature(request);

            // Bước 5: Tạo JSON request body
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("orderCode", request.getOrderCode());
            requestBody.put("amount", request.getAmount());
            requestBody.put("description", request.getDescription());
            requestBody.put("returnUrl", request.getReturnUrl());
            requestBody.put("cancelUrl", request.getCancelUrl());
            requestBody.put("items", request.getItems());
            requestBody.put("signature", signature);

            // Thêm thông tin buyer nếu có
            if (request.getBuyerName() != null) {
                requestBody.put("buyerName", request.getBuyerName());
            }
            if (request.getBuyerEmail() != null) {
                requestBody.put("buyerEmail", request.getBuyerEmail());
            }
            if (request.getBuyerPhone() != null) {
                requestBody.put("buyerPhone", request.getBuyerPhone());
            }

            String jsonBody = gson.toJson(requestBody);
            logger.debug("📤 Request body: {}", jsonBody);

            // Bước 6: Gọi API PayOS để tạo link thanh toán
            RequestBody body = RequestBody.create(
                jsonBody,
                MediaType.parse("application/json; charset=utf-8")
            );

            Request httpRequest = new Request.Builder()
                .url(payOSConfig.getApiUrl() + "/v2/payment-requests")
                .post(body)
                .addHeader("x-client-id", payOSConfig.getClientId())
                .addHeader("x-api-key", payOSConfig.getApiKey())
                .addHeader("Content-Type", "application/json")
                .build();

            // Bước 7: Thực hiện request và xử lý response
            try (Response response = httpClient.newCall(httpRequest).execute()) {
                String responseBody = response.body().string();
                logger.debug("📥 Response body: {}", responseBody);

                if (response.isSuccessful()) {
                    PayOSResponse payOSResponse = gson.fromJson(responseBody, PayOSResponse.class);

                    if (payOSResponse.isSuccess()) {
                        logger.info("✅ Tạo link thanh toán thành công: {}",
                            payOSResponse.getData().getCheckoutUrl());
                        return payOSResponse;
                    } else {
                        logger.error("❌ PayOS trả về lỗi: {} - {}",
                            payOSResponse.getCode(), payOSResponse.getDesc());
                        return null;
                    }
                } else {
                    logger.error("❌ HTTP Error {}: {}", response.code(), responseBody);
                    return null;
                }
            }

        } catch (Exception e) {
            logger.error("❌ Lỗi khi tạo link thanh toán PayOS", e);
            return null;
        }
    }

    /**
     * ✅ XÁC THỰC WEBHOOK TỪ PAYOS
     * Kiểm tra chữ ký (signature) để đảm bảo webhook đến từ PayOS
     *
     * @param webhookData Dữ liệu webhook
     * @return true nếu hợp lệ, false nếu không hợp lệ
     */
    public boolean verifyWebhookSignature(PayOSWebhookData webhookData) {
        try {
            logger.info("🔐 Xác thực chữ ký webhook cho đơn hàng #{}", webhookData.getOrderCode());

            // Tạo chuỗi data để verify (theo thứ tự alphabet của key)
            String dataStr = String.format(
                "amount=%d&code=%s&description=%s&orderCode=%d",
                webhookData.getAmount(),
                webhookData.getCode(),
                webhookData.getDescription(),
                webhookData.getOrderCode()
            );

            // Tạo signature từ data
            String calculatedSignature = hmacSHA256(dataStr, payOSConfig.getChecksumKey());

            // So sánh signature
            boolean isValid = calculatedSignature.equals(webhookData.getSignature());

            if (isValid) {
                logger.info("✅ Chữ ký webhook hợp lệ");
            } else {
                logger.warn("⚠️ Chữ ký webhook KHÔNG hợp lệ!");
                logger.debug("Expected: {}", calculatedSignature);
                logger.debug("Received: {}", webhookData.getSignature());
            }

            return isValid;

        } catch (Exception e) {
            logger.error("❌ Lỗi khi xác thực webhook", e);
            return false;
        }
    }

    /**
     * ✅ KIỂM TRA TRẠNG THÁI THANH TOÁN
     * Gọi API PayOS để lấy thông tin trạng thái đơn hàng
     *
     * @param orderCode Mã đơn hàng
     * @return PayOSResponse chứa thông tin trạng thái
     */
    public PayOSResponse getPaymentStatus(Long orderCode) {
        try {
            logger.info("🔍 Kiểm tra trạng thái thanh toán cho đơn hàng #{}", orderCode);

            Request request = new Request.Builder()
                .url(payOSConfig.getApiUrl() + "/v2/payment-requests/" + orderCode)
                .get()
                .addHeader("x-client-id", payOSConfig.getClientId())
                .addHeader("x-api-key", payOSConfig.getApiKey())
                .build();

            try (Response response = httpClient.newCall(request).execute()) {
                String responseBody = response.body().string();

                if (response.isSuccessful()) {
                    PayOSResponse payOSResponse = gson.fromJson(responseBody, PayOSResponse.class);
                    logger.info("✅ Lấy trạng thái thành công: {}",
                        payOSResponse.getData().getStatus());
                    return payOSResponse;
                } else {
                    logger.error("❌ HTTP Error {}: {}", response.code(), responseBody);
                    return null;
                }
            }

        } catch (Exception e) {
            logger.error("❌ Lỗi khi kiểm tra trạng thái thanh toán", e);
            return null;
        }
    }

    /**
     * ✅ HỦY THANH TOÁN
     * Gọi API PayOS để hủy link thanh toán
     *
     * @param orderCode Mã đơn hàng
     * @return true nếu hủy thành công
     */
    public boolean cancelPayment(Long orderCode) {
        try {
            logger.info("❌ Hủy thanh toán cho đơn hàng #{}", orderCode);

            Request request = new Request.Builder()
                .url(payOSConfig.getApiUrl() + "/v2/payment-requests/" + orderCode + "/cancel")
                .post(RequestBody.create("", MediaType.parse("application/json")))
                .addHeader("x-client-id", payOSConfig.getClientId())
                .addHeader("x-api-key", payOSConfig.getApiKey())
                .build();

            try (Response response = httpClient.newCall(request).execute()) {
                if (response.isSuccessful()) {
                    logger.info("✅ Hủy thanh toán thành công");
                    return true;
                } else {
                    logger.error("❌ Hủy thanh toán thất bại: {}", response.code());
                    return false;
                }
            }

        } catch (Exception e) {
            logger.error("❌ Lỗi khi hủy thanh toán", e);
            return false;
        }
    }

    // ========== PRIVATE HELPER METHODS ==========

    /**
     * Tạo chữ ký (signature) cho request
     */
    private String generateSignature(PayOSRequest request) {
        try {
            // Tạo chuỗi data theo format của PayOS
            String dataStr = String.format(
                "amount=%d&cancelUrl=%s&description=%s&orderCode=%d&returnUrl=%s",
                request.getAmount(),
                request.getCancelUrl(),
                request.getDescription(),
                request.getOrderCode(),
                request.getReturnUrl()
            );

            return hmacSHA256(dataStr, payOSConfig.getChecksumKey());

        } catch (Exception e) {
            logger.error("❌ Lỗi khi tạo signature", e);
            return "";
        }
    }

    /**
     * Tạo HMAC SHA256 hash
     */
    private String hmacSHA256(String data, String key) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        SecretKeySpec secretKeySpec = new SecretKeySpec(
            key.getBytes(StandardCharsets.UTF_8),
            "HmacSHA256"
        );
        mac.init(secretKeySpec);

        byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));

        // Convert to hex string
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }

        return hexString.toString();
    }
}
