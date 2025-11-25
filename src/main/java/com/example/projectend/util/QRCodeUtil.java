package com.example.projectend.util;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;

import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

/**
 * Utility tạo ảnh QR code Base64 để hiển thị trực tiếp trong <img src="data:image/png;base64,..." />
 */
public class QRCodeUtil {

    /**
     * Tạo ảnh QR code từ payload (URL hoặc chuỗi EMV) trả về chuỗi base64 PNG.
     * @param payload nội dung QR
     * @param size kích thước chiều rộng/chiều cao (px)
     * @return base64 PNG (không kèm tiền tố data URI)
     */
    public static String generateBase64Png(String payload, int size) {
        if (payload == null || payload.isBlank()) return null;
        try {
            Map<EncodeHintType, Object> hints = new HashMap<>();
            hints.put(EncodeHintType.CHARACTER_SET, StandardCharsets.UTF_8.name());
            hints.put(EncodeHintType.MARGIN, 1);
            BitMatrix matrix = new MultiFormatWriter().encode(payload, BarcodeFormat.QR_CODE, size, size, hints);
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            MatrixToImageWriter.writeToStream(matrix, "PNG", baos);
            return Base64.getEncoder().encodeToString(baos.toByteArray());
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Trả về chuỗi hoàn chỉnh dùng trực tiếp trong thẻ <img src="..." />
     */
    public static String toDataUri(String base64Png) {
        if (base64Png == null) return null;
        return "data:image/png;base64," + base64Png;
    }

    /**
     * Phát hiện xem chuỗi trả về từ PayOS có phải là data URI hay URL sẵn dùng không.
     */
    public static boolean isRenderableDirect(String qr) {
        if (qr == null) return false;
        String lower = qr.toLowerCase();
        return lower.startsWith("http://") || lower.startsWith("https://") || lower.startsWith("data:image");
    }
}

