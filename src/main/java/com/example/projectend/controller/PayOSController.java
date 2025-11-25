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
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * ✨ PAYOS PAYMENT CONTROLLER
 * Controller xử lý thanh toán qua PayOS
 *
 * Endpoints:
 * - POST /payment/payos/create: Tạo link thanh toán và hiển thị QR code
 * - GET /payment/payos/return: Xử lý khi khách hàng quay lại sau khi thanh toán
 * - GET /payment/payos/cancel: Xử lý khi khách hàng hủy thanh toán
 * - POST /payment/payos/webhook: Nhận thông báo từ PayOS (IPN)
 * - GET /payment/payos/check/{orderId}: Kiểm tra trạng thái thanh toán
 */
@Controller
@RequestMapping("/payment/payos")
public class PayOSController {

    private static final Logger logger = LoggerFactory.getLogger(PayOSController.class);

    @Autowired
    private PayOSService payOSService;

    @Autowired
    private DonHangService donHangService;

    @Autowired
    private TaiKhoanService taiKhoanService;

    @Autowired
    private GioHangService gioHangService;

    /**
     * ✅ TẠO LINK THANH TOÁN VÀ HIỂN THỊ QR CODE
     * Endpoint này được gọi từ trang checkout khi khách chọn thanh toán PayOS
     */
    @RequestMapping(value = "/create", method = {RequestMethod.GET, RequestMethod.POST})
    public String createPayment(
            @RequestParam Long orderId,
            Principal principal,
            Model model,
            RedirectAttributes redirectAttributes) {

        try {
            logger.info("🎯 Tạo thanh toán PayOS cho đơn hàng #{}", orderId);

            // Bước 1: Kiểm tra đăng nhập
            if (principal == null) {
                return "redirect:/login";
            }

            TaiKhoan taiKhoan = taiKhoanService.findByEmail(principal.getName());
            if (taiKhoan == null) {
                return "redirect:/login";
            }

            // Bước 2: Lấy thông tin đơn hàng
            Optional<DonHang> donHangOpt = donHangService.findByIdAndKhachHang(orderId, taiKhoan);
            if (donHangOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy đơn hàng!");
                return "redirect:/profile";
            }

            DonHang donHang = donHangOpt.get();

            // Bước 3: Kiểm tra đơn hàng đã thanh toán chưa
            if (donHang.getTrangThaiThanhToan() == 1) {
                // Đã thanh toán: chuyển thẳng tới trang cảm ơn
                return "redirect:/checkout/success?orderId=" + orderId;
            }

            // Bước 4: Gọi PayOS API để tạo link thanh toán
            PayOSResponse payOSResponse = payOSService.createPaymentLink(donHang);

            if (payOSResponse == null || !payOSResponse.isSuccess()) {
                redirectAttributes.addFlashAttribute("error",
                    "Không thể tạo link thanh toán. Vui lòng thử lại!");
                return "redirect:/checkout?orderId=" + orderId;
            }

            // Lưu thông tin giao dịch (sử dụng orderCode trả về để truy vết chính xác)
            donHang.setMaGiaoDich("PAYOS_" + payOSResponse.getData().getOrderCode());
            donHang.setNgayCapNhat(LocalDateTime.now());
            donHangService.save(donHang);

            String rawQr = payOSResponse.getData().getQrCode();
            String renderQr = rawQr;
            if (!QRCodeUtil.isRenderableDirect(rawQr)) {
                String base64 = QRCodeUtil.generateBase64Png(rawQr, 300);
                if (base64 != null) {
                    renderQr = QRCodeUtil.toDataUri(base64);
                }
            }
            // Bước 6: Hiển thị trang thanh toán với QR code
            model.addAttribute("donHang", donHang);
            model.addAttribute("checkoutUrl", payOSResponse.getData().getCheckoutUrl());
            model.addAttribute("qrCode", renderQr); // always renderable
            model.addAttribute("orderCode", payOSResponse.getData().getOrderCode());
            model.addAttribute("amount", payOSResponse.getData().getAmount());
            model.addAttribute("pageTitle", "Thanh toán PayOS");

            return "Pay"; // Hiển thị trang Pay.html với QR code

        } catch (Exception e) {
            logger.error("❌ Lỗi khi tạo thanh toán PayOS", e);
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/checkout";
        }
    }

    /**
     * ✅ XỬ LÝ KHI KHÁCH HÀNG QUAY LẠI SAU KHI THANH TOÁN
     * PayOS redirect về URL này khi khách hàng thanh toán xong
     */
    @GetMapping("/return")
    public String paymentReturn(
            @RequestParam(required = false) Long orderCode,
            @RequestParam(required = false) String status,
            Principal principal,
            Model model,
            RedirectAttributes redirectAttributes) {

        try {
            logger.info("🔙 Khách hàng quay lại từ PayOS - OrderCode: {}, Status: {}",
                orderCode, status);

            if (orderCode == null) {
                redirectAttributes.addFlashAttribute("error", "Thiếu thông tin đơn hàng!");
                return "redirect:/profile";
            }

            // Kiểm tra trạng thái thanh toán từ PayOS
            PayOSResponse payOSResponse = payOSService.getPaymentStatus(orderCode);

            if (payOSResponse != null && payOSResponse.isSuccess()) {
                String paymentStatus = payOSResponse.getData().getStatus();

                if ("PAID".equalsIgnoreCase(paymentStatus)) {
                    // Thanh toán thành công
                    logger.info("✅ Thanh toán thành công cho đơn hàng #{}", orderCode);

                    boolean updated = updateOrderPaymentStatus(orderCode, true);
                    if (updated) {
                        // Clear cart sau khi thanh toán thành công (nếu còn items do chưa clear ở checkout)
                        Optional<DonHang> dhOpt = donHangService.findById(orderCode);
                        dhOpt.ifPresent(dh -> gioHangService.clearGioHang(dh.getTaiKhoan()));
                    }

                    redirectAttributes.addFlashAttribute("success",
                        "Thanh toán thành công! Cảm ơn bạn.");
                    return "redirect:/checkout/success?orderId=" + orderCode;

                } else if ("CANCELLED".equalsIgnoreCase(paymentStatus)) {
                    // Thanh toán bị hủy
                    logger.warn("⚠️ Thanh toán bị hủy cho đơn hàng #{}", orderCode);
                    redirectAttributes.addFlashAttribute("warning",
                        "Thanh toán đã bị hủy. Vui lòng thử lại!");
                    return "redirect:/profile";

                } else {
                    // Chờ thanh toán
                    logger.info("⏳ Đơn hàng #{} đang chờ thanh toán", orderCode);
                    redirectAttributes.addFlashAttribute("info",
                        "Đơn hàng đang chờ thanh toán. Vui lòng kiểm tra lại sau.");
                    return "redirect:/payment/payos/create?orderId=" + orderCode;
                }
            } else {
                redirectAttributes.addFlashAttribute("error",
                    "Không thể kiểm tra trạng thái thanh toán!");
                return "redirect:/profile";
            }

        } catch (Exception e) {
            logger.error("❌ Lỗi khi xử lý payment return", e);
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/profile";
        }
    }

    /**
     * ✅ XỬ LÝ KHI KHÁCH HÀNG HỦY THANH TOÁN
     */
    @GetMapping("/cancel")
    public String paymentCancel(
            @RequestParam(required = false) Long orderCode,
            RedirectAttributes redirectAttributes) {

        logger.info("❌ Khách hàng hủy thanh toán cho đơn hàng #{}", orderCode);

        redirectAttributes.addFlashAttribute("warning",
            "Bạn đã hủy thanh toán. Vui lòng thử lại nếu muốn tiếp tục đặt hàng.");

        return "redirect:/profile";
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
                    true
                );

                if (updated) {
                    logger.info("✅ Đã cập nhật trạng thái đơn hàng #{} thành PAID",
                        webhookData.getOrderCode());

                    // Clear cart khi webhook xác nhận thành công
                    Optional<DonHang> dhOpt = donHangService.findById(webhookData.getOrderCode());
                    dhOpt.ifPresent(dh -> gioHangService.clearGioHang(dh.getTaiKhoan()));

                    return ResponseEntity.ok(Map.of(
                        "success", true,
                        "message", "Webhook processed successfully"
                    ));
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
                    "message", "Payment not successful"
                ));
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
                donHang.setNgayThanhToan(LocalDateTime.now());
                // KHÔNG tự chuyển trạng thái đơn hàng sang "Đã xác nhận" để giữ nguyên "Chờ xác nhận" như yêu cầu
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

