package com.example.projectend.controller;

import com.example.projectend.dto.PayOSResponse;
import com.example.projectend.dto.PayOSWebhookData;
import com.example.projectend.entity.DonHang;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.service.DonHangService;
import com.example.projectend.service.GioHangService;
import com.example.projectend.service.PayOSService;
import com.example.projectend.service.TaiKhoanService;
import com.example.projectend.util.QRCodeUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

/**
 * ✨ PAYOS PAYMENT CONTROLLER
 */
@Controller
@RequestMapping("/payment/payos")
public class PayOSController {

    private static final Logger logger = LoggerFactory.getLogger(PayOSController.class);

    // Cache dữ liệu thanh toán tạm thời theo orderId
    // orderId → {checkoutUrl, qrDataUri, orderCode, amount}
    private static final Map<Long, Map<String, Object>> paymentCache = new ConcurrentHashMap<>();

    @Autowired
    private PayOSService payOSService;
    @Autowired
    private DonHangService donHangService;
    @Autowired
    private TaiKhoanService taiKhoanService;
    @Autowired
    private GioHangService gioHangService;

    /**
     * ✅ TẠO LINK THANH TOÁN
     * Gọi PayOS API → cache data → redirect Vue /payment?orderId=X
     */
    @RequestMapping(value = "/create", method = { RequestMethod.GET, RequestMethod.POST })
    public String createPayment(@RequestParam Long orderId, Principal principal) {
        try {
            logger.info("🎯 Tạo thanh toán PayOS cho đơn hàng #{}", orderId);

            if (principal == null)
                return "redirect:http://localhost:5173/login";

            TaiKhoan taiKhoan = taiKhoanService.findByEmail(principal.getName());
            if (taiKhoan == null)
                return "redirect:http://localhost:5173/login";

            Optional<DonHang> donHangOpt = donHangService.findByIdAndKhachHang(orderId, taiKhoan);
            if (donHangOpt.isEmpty()) {
                logger.warn("Không tìm thấy đơn hàng #{} cho user {}", orderId, taiKhoan.getEmail());
                return "redirect:http://localhost:5173/profile?error=order-not-found";
            }

            DonHang donHang = donHangOpt.get();

            if (donHang.getTrangThaiThanhToan() == 1) {
                return "redirect:http://localhost:5173/checkout-success?orderId=" + orderId;
            }

            // Tạo orderCode unique = timestamp trong ngày (max 9 chữ số) + orderId mod 1000
            // PayOS chỉ chấp nhận số nguyên dương, không được trùng
            long now = System.currentTimeMillis();
            long uniqueCode = (now % 1_000_000_000L) * 1000 + (orderId % 1000);
            // Lưu mapping để tìm lại đơn hàng khi PayOS callback
            donHang.setMaGiaoDich("PAYOS_CODE_" + uniqueCode);
            donHangService.save(donHang);

            PayOSResponse payOSResponse = payOSService.createPaymentLink(donHang, uniqueCode);
            if (payOSResponse == null || !payOSResponse.isSuccess()) {
                logger.error("PayOS tạo link thất bại cho đơn hàng #{}", orderId);
                return "redirect:http://localhost:5173/checkout?error=payos-failed";
            }

            // (maGiaoDich đã được lưu trước khi gọi API PayOS ở trên)
            donHang.setNgayCapNhat(LocalDateTime.now());
            donHangService.save(donHang);

            // ✅ Convert QR string → renderable image (data URI hoặc URL)
            String rawQr = payOSResponse.getData().getQrCode();
            String renderQr = rawQr;
            if (rawQr != null && !QRCodeUtil.isRenderableDirect(rawQr)) {
                String base64 = QRCodeUtil.generateBase64Png(rawQr, 300);
                if (base64 != null) {
                    renderQr = QRCodeUtil.toDataUri(base64);
                }
            }

            // ✅ Lưu vào cache theo orderId
            Map<String, Object> cacheData = new HashMap<>();
            cacheData.put("checkoutUrl", payOSResponse.getData().getCheckoutUrl());
            cacheData.put("qrCode", renderQr);
            cacheData.put("orderCode", payOSResponse.getData().getOrderCode());
            cacheData.put("amount", payOSResponse.getData().getAmount());
            cacheData.put("orderId", orderId);
            paymentCache.put(orderId, cacheData);

            // ✅ Chỉ redirect với orderId — Vue sẽ fetch data từ
            // /payment/payos/data/{orderId}
            return "redirect:http://localhost:5173/payment?orderId=" + orderId;

        } catch (Exception e) {
            logger.error("❌ Lỗi tạo thanh toán PayOS cho đơn #{}", orderId, e);
            return "redirect:http://localhost:5173/checkout?error=server-error";
        }
    }

    /**
     * ✅ API: Lấy dữ liệu thanh toán từ cache (Vue gọi sau khi redirect)
     * GET /payment/payos/data/{orderId}
     */
    @GetMapping("/data/{orderId}")
    @ResponseBody
    public ResponseEntity<?> getPaymentData(@PathVariable Long orderId) {
        Map<String, Object> data = paymentCache.get(orderId);
        if (data == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("error", "Không tìm thấy dữ liệu thanh toán. Vui lòng thử lại."));
        }
        return ResponseEntity.ok(data);
    }

    /**
     * ✅ XỬ LÝ KHI KHÁCH HÀNG QUAY LẠI SAU KHI THANH TOÁN
     * PayOS redirect về URL này khi khách hàng thanh toán xong
     */
    @GetMapping("/return")
    public String paymentReturn(
            @RequestParam(required = false) Long orderCode,
            @RequestParam(required = false) String status) {

        try {
            logger.info("Khách hàng quay lại từ PayOS - OrderCode: {}, Status: {}", orderCode, status);

            if (orderCode == null) {
                return "redirect:http://localhost:5173/profile?error=missing-order";
            }

            // Tìm đơn hàng qua maGiaoDich (PAYOS_CODE_xxx)
            Optional<DonHang> dhLookup = findOrderByPayOSCode(orderCode);
            if (dhLookup.isEmpty()) {
                logger.warn("Không tìm thấy đơn hàng cho PayOS orderCode #{}", orderCode);
                return "redirect:http://localhost:5173/profile?error=order-not-found";
            }
            Long orderId = dhLookup.get().getMaDH();

            PayOSResponse payOSResponse = payOSService.getPaymentStatus(orderCode);

            if (payOSResponse != null && payOSResponse.isSuccess()) {
                String paymentStatus = payOSResponse.getData().getStatus();

                if ("PAID".equalsIgnoreCase(paymentStatus)) {
                    logger.info("✅ Thanh toán thành công cho đơn hàng #{}", orderId);
                    boolean updated = updateOrderPaymentStatus(orderId, true);
                    if (updated) {
                        dhLookup.ifPresent(dh -> gioHangService.clearGioHang(dh.getTaiKhoan()));
                    }
                    return "redirect:http://localhost:5173/checkout-success?orderId=" + orderId;

                } else if ("CANCELLED".equalsIgnoreCase(paymentStatus)) {
                    logger.warn("⚠️ Thanh toán bị hủy cho đơn hàng #{}", orderId);
                    updateOrderAsFailed(orderId, "Thanh toán bị hủy từ phía khách hàng (PayOS)");
                    return "redirect:http://localhost:5173/profile?warning=payment-cancelled";

                } else {
                    logger.info("⏳ Đơn hàng #{} đang chờ thanh toán", orderId);
                    return "redirect:http://localhost:5173/payment?orderId=" + orderId + "&status=PENDING";
                }
            } else {
                return "redirect:http://localhost:5173/profile?error=payment-check-failed";
            }

        } catch (Exception e) {
            logger.error("❌ Lỗi khi xử lý payment return", e);
            return "redirect:http://localhost:5173/profile?error=server-error";
        }
    }

    /**
     * ✅ XỬ LÝ KHI KHÁCH HÀNG HỦY THANH TOÁN
     */
    @GetMapping("/cancel")
    public String paymentCancel(@RequestParam(required = false) Long orderCode) {
        logger.info("❌ Khách hàng hủy thanh toán cho đơn hàng PayOS #{}", orderCode);
        if (orderCode != null) {
            Optional<DonHang> dhLookup = findOrderByPayOSCode(orderCode);
            dhLookup.ifPresent(dh -> updateOrderAsFailed(dh.getMaDH(), "Khách hàng bấm Hủy thanh toán tại trang PayOS"));
        }
        return "redirect:http://localhost:5173/profile?warning=payment-cancelled";
    }

    /**
     * ✅ WEBHOOK - NHẬN THÔNG BÁO TỪ PAYOS
     * PayOS gửi POST request đến endpoint này khi có thay đổi trạng thái thanh toán
     * Đây là cách chính thức để cập nhật trạng thái đơn hàng
     */
    @PostMapping("/webhook")
    @ResponseBody
    public ResponseEntity<?> webhook(@RequestBody PayOSWebhookData webhookData) {

        try {
            logger.info("📩 Nhận webhook từ PayOS cho đơn hàng #{}",
                    webhookData.getOrderCode());
            logger.debug("Webhook data: {}", webhookData);

            // Bước 1: Xác thực chữ ký webhook
            boolean isValid = payOSService.verifyWebhookSignature(webhookData);

            if (!isValid) {
                logger.error("⚠️ Chữ ký webhook KHÔNG hợp lệ! Có thể là giả mạo.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("error", "Invalid signature"));
            }

            // Bước 2: Kiểm tra trạng thái thanh toán
            if (webhookData.isSuccess()) {
                logger.info("✅ Webhook xác nhận thanh toán thành công cho đơn hàng #{}",
                        webhookData.getOrderCode());

                // Bước 3: Tìm đơn hàng qua PAYOS_CODE_xxx trong maGiaoDich
                Long orderCode = webhookData.getOrderCode();
                Optional<DonHang> dhLookup = findOrderByPayOSCode(orderCode);
                if (dhLookup.isEmpty()) {
                    logger.error("❌ Không tìm thấy đơn hàng cho PayOS orderCode #{}", orderCode);
                    return ResponseEntity.status(HttpStatus.NOT_FOUND)
                            .body(Map.of("error", "Order not found for orderCode " + orderCode));
                }
                Long orderId = dhLookup.get().getMaDH();

                boolean updated = updateOrderPaymentStatus(orderId, true);

                if (updated) {
                    logger.info("✅ Đã cập nhật trạng thái đơn hàng #{} thành PAID", orderId);

                    // Clear cart khi webhook xác nhận thành công
                    dhLookup.ifPresent(dh -> gioHangService.clearGioHang(dh.getTaiKhoan()));

                    return ResponseEntity.ok(Map.of(
                            "success", true,
                            "message", "Webhook processed successfully"));
                } else {
                    logger.error("❌ Không thể cập nhật đơn hàng #{}", orderId);
                    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                            .body(Map.of("error", "Failed to update order"));
                }
            } else {
                logger.warn("⚠️ Webhook báo thanh toán KHÔNG thành công: Code = {}",
                        webhookData.getCode());
                return ResponseEntity.ok(Map.of(
                        "success", false,
                        "message", "Payment not successful"));
            }

        } catch (Exception e) {
            logger.error("❌ Lỗi khi xử lý webhook PayOS", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * ✅ KIỂM TRA TRẠNG THÁI THANH TOÁN (API)
     * Endpoint này cho phép kiểm tra trạng thái thanh toán theo thời gian thực
     */
    @GetMapping("/check/{orderId}")
    @ResponseBody
    public ResponseEntity<?> checkPaymentStatus(@PathVariable Long orderId) {

        try {
            logger.info("🔍 Kiểm tra trạng thái thanh toán cho đơn hàng #{}", orderId);

            // Gọi API PayOS để lấy trạng thái
            PayOSResponse payOSResponse = payOSService.getPaymentStatus(orderId);

            if (payOSResponse != null && payOSResponse.isSuccess()) {
                String status = payOSResponse.getData().getStatus();

                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("orderCode", orderId);
                result.put("status", status);
                result.put("amount", payOSResponse.getData().getAmount());

                // Nếu đã thanh toán, cập nhật database
                if ("PAID".equalsIgnoreCase(status)) {
                    updateOrderPaymentStatus(orderId, true);
                    result.put("message", "Thanh toán thành công!");
                } else if ("PENDING".equalsIgnoreCase(status)) {
                    result.put("message", "Đang chờ thanh toán...");
                } else if ("CANCELLED".equalsIgnoreCase(status)) {
                    result.put("message", "Thanh toán đã bị hủy");
                }

                return ResponseEntity.ok(result);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("error", "Không tìm thấy thông tin thanh toán"));
            }

        } catch (Exception e) {
            logger.error("❌ Lỗi khi kiểm tra trạng thái thanh toán", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", e.getMessage()));
        }
    }

    // ===== PRIVATE HELPERS =====

    /**
     * Tìm đơn hàng bằng PayOS orderCode (lưu trong maGiaoDich dạng "PAYOS_CODE_xxx")
     */
    private Optional<DonHang> findOrderByPayOSCode(Long payosOrderCode) {
        return donHangService.findByMaGiaoDich("PAYOS_CODE_" + payosOrderCode);
    }

    /**
     * Cập nhật trạng thái thanh toán của đơn hàng
     */
    private boolean updateOrderPaymentStatus(Long orderId, boolean isPaid) {
        try {
            Optional<DonHang> donHangOpt = donHangService.findById(orderId);
            if (donHangOpt.isEmpty()) return false;
            DonHang donHang = donHangOpt.get();

            if (isPaid) {
                // ✅ Sử dụng Service đã được đồng bộ để xử lý PAID
                donHangService.confirmPaymentAndDeductStock(orderId);
            } else {
                donHang.setTrangThaiThanhToan(0); // PENDING (0)
                donHang.setNgayCapNhat(LocalDateTime.now());
                donHangService.save(donHang);
            }
            return true;
        } catch (Exception e) {
            logger.error("❌ Lỗi updateOrderPaymentStatus đơn #{}", orderId, e);
            return false;
        }
    }

    private void updateOrderAsFailed(Long orderId, String reason) {
        try {
            Optional<DonHang> dhOpt = donHangService.findById(orderId);
            if (dhOpt.isEmpty()) return;
            DonHang dh = dhOpt.get();
            
            dh.setTrangThaiDH(6);        // Lỗi thanh toán (6)
            dh.setTrangThaiThanhToan(2); // FAILED (2)
            dh.setNgayCapNhat(LocalDateTime.now());
            donHangService.save(dh);

            donHangService.capNhatTrangThai(orderId, 6, "PayOS System", reason);
        } catch (Exception e) {
            logger.error("❌ Lỗi updateOrderAsFailed đơn #{}", orderId, e);
        }
    }
}
