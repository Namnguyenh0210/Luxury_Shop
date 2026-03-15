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
    @Autowired
    private com.example.projectend.repository.ThanhToanRepository thanhToanRepository;

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

            PayOSResponse payOSResponse = payOSService.createPaymentLink(donHang);
            if (payOSResponse == null || !payOSResponse.isSuccess()) {
                logger.error("PayOS tạo link thất bại cho đơn hàng #{}", orderId);
                return "redirect:http://localhost:5173/checkout?error=payos-failed";
            }

            donHang.setMaGiaoDich("PAYOS_" + payOSResponse.getData().getOrderCode());
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

            PayOSResponse payOSResponse = payOSService.getPaymentStatus(orderCode);

            if (payOSResponse != null && payOSResponse.isSuccess()) {
                String paymentStatus = payOSResponse.getData().getStatus();

                if ("PAID".equalsIgnoreCase(paymentStatus)) {
                    logger.info("✅ Thanh toán thành công cho đơn hàng #{}", orderCode);
                    boolean updated = updateOrderPaymentStatus(orderCode, true);
                    if (updated) {
                        Optional<DonHang> dhOpt = donHangService.findById(orderCode);
                        dhOpt.ifPresent(dh -> gioHangService.clearGioHang(dh.getTaiKhoan()));
                    }
                    return "redirect:http://localhost:5173/checkout-success?orderId=" + orderCode;

                } else if ("CANCELLED".equalsIgnoreCase(paymentStatus)) {
                    logger.warn("⚠️ Thanh toán bị hủy cho đơn hàng #{}", orderCode);
                    return "redirect:http://localhost:5173/profile?warning=payment-cancelled";

                } else {
                    logger.info("⏳ Đơn hàng #{} đang chờ thanh toán", orderCode);
                    return "redirect:http://localhost:5173/payment?orderId=" + orderCode + "&status=PENDING";
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
        logger.info("❌ Khách hàng hủy thanh toán cho đơn hàng #{}", orderCode);
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

                // Bước 3: Cập nhật trạng thái đơn hàng trong database
                boolean updated = updateOrderPaymentStatus(
                        webhookData.getOrderCode(),
                        true);

                if (updated) {
                    logger.info("✅ Đã cập nhật trạng thái đơn hàng #{} thành PAID",
                            webhookData.getOrderCode());

                    // Clear cart khi webhook xác nhận thành công
                    Optional<DonHang> dhOpt = donHangService.findById(webhookData.getOrderCode());
                    dhOpt.ifPresent(dh -> gioHangService.clearGioHang(dh.getTaiKhoan()));

                    return ResponseEntity.ok(Map.of(
                            "success", true,
                            "message", "Webhook processed successfully"));
                } else {
                    logger.error("❌ Không thể cập nhật đơn hàng #{}",
                            webhookData.getOrderCode());
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

    // ========== PRIVATE HELPER METHODS ==========

    /**
     * Cập nhật trạng thái thanh toán của đơn hàng
     */
    private boolean updateOrderPaymentStatus(Long orderId, boolean isPaid) {
        try {
            Optional<DonHang> donHangOpt = donHangService.findById(orderId);

            if (donHangOpt.isEmpty()) {
                return false;
            }

            DonHang donHang = donHangOpt.get();

            donHang.setTrangThaiThanhToan(isPaid ? 1 : 0); // 1 = Đã thanh toán

            if (isPaid) {
                // donHang.setNgayThanhToan(LocalDateTime.now()); - Đã xóa trong entity
                
                // Tạo bản ghi thanh toán chi tiết
                com.example.projectend.entity.ThanhToan tt = new com.example.projectend.entity.ThanhToan();
                tt.setDonHang(donHang);
                tt.setSoTien(donHang.getTongTien().add(donHang.getPhiShip()));
                tt.setTrangThai("COMPLETED");
                tt.setGateway("PayOS");
                tt.setTransactionID(donHang.getMaGiaoDich());
                tt.setNgayTao(LocalDateTime.now());
                thanhToanRepository.save(tt);
            }

            donHang.setNgayCapNhat(LocalDateTime.now());
            donHangService.save(donHang);

            logger.info("✅ Cập nhật trạng thái thanh toán đơn hàng #{} => {}", orderId, isPaid ? "PAID" : "PENDING");
            return true;
        } catch (Exception e) {
            logger.error("❌ Lỗi khi cập nhật trạng thái thanh toán đơn hàng #{}", orderId, e);
            return false;
        }
    }
}
