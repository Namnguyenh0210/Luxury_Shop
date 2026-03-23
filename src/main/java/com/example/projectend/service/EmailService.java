package com.example.projectend.service;

import com.example.projectend.entity.DonHang;
import com.example.projectend.entity.DonHangChiTiet;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;

/**
 * SERVICE GỬI EMAIL - Xác nhận đơn hàng & Thông báo
 */
@Service
public class EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    @Autowired
    private JavaMailSender mailSender;

    @Value("${app.mail.from:luxury@fashion.vn}")
    private String fromEmail;

    @Value("${app.mail.from-name:Luxury Fashion Shop}")
    private String fromName;

    /**
     * Gửi email xác nhận đơn hàng (async, không chặn luồng chính)
     */
    @Async
    public void sendOrderConfirmationEmail(DonHang donHang, List<DonHangChiTiet> chiTietList) {
        String toEmail = donHang.getTaiKhoan().getEmail();
        String customerName = donHang.getTaiKhoan().getHoTen();
        Long orderId = donHang.getMaDH();

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail, fromName);
            helper.setTo(toEmail);
            helper.setSubject("✅ Xác nhận đơn hàng #" + orderId + " - Luxury Fashion Shop");
            helper.setText(buildOrderConfirmationHtml(customerName, donHang, chiTietList), true);

            mailSender.send(message);
            log.info("✅ Email xác nhận đơn hàng #{} đã gửi tới {}", orderId, toEmail);

        } catch (MessagingException e) {
            log.error("❌ Không thể gửi email đơn hàng #{} tới {}: {}", orderId, toEmail, e.getMessage());
        } catch (Exception e) {
            log.error("❌ Lỗi gửi email: {}", e.getMessage());
        }
    }

    /**
     * Xây dựng nội dung HTML email xác nhận đơn hàng - Giao diện cao cấp
     */
    private String buildOrderConfirmationHtml(String customerName, DonHang donHang, List<DonHangChiTiet> chiTietList) {
        NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

        StringBuilder items = new StringBuilder();
        if (chiTietList != null) {
            for (DonHangChiTiet ct : chiTietList) {
                String tenSP = ct.getSanPhamChiTiet().getSanPham().getTenSP();
                String size = ct.getSanPhamChiTiet().getSizeSP() != null
                        ? ct.getSanPhamChiTiet().getSizeSP().getTenSize() : "";
                String mau = ct.getSanPhamChiTiet().getMauSacSP() != null
                        ? ct.getSanPhamChiTiet().getMauSacSP().getTenMau() : "";
                int soLuong = ct.getSoLuong();
                BigDecimal donGia = ct.getDonGia();
                BigDecimal thanhTien = donGia.multiply(BigDecimal.valueOf(soLuong));

                items.append("""
                        <tr>
                          <td style="padding:12px 16px;border-bottom:1px solid #F3F4F6;">
                            <div style="font-weight:600;color:#111827;font-size:14px;">%s</div>
                            <div style="color:#6B7280;font-size:12px;margin-top:3px;">%s%s</div>
                          </td>
                          <td style="padding:12px 16px;border-bottom:1px solid #F3F4F6;text-align:center;color:#374151;font-size:14px;">x%d</td>
                          <td style="padding:12px 16px;border-bottom:1px solid #F3F4F6;text-align:right;font-weight:600;color:#111827;font-size:14px;">%s₫</td>
                        </tr>
                        """.formatted(
                        tenSP,
                        size.isEmpty() ? "" : "Size: " + size,
                        mau.isEmpty() ? "" : (size.isEmpty() ? "" : " • ") + "Màu: " + mau,
                        soLuong,
                        currencyFormat.format(thanhTien)
                ));
            }
        }

        String diaChi = donHang.getDiaChiGiao() != null
                ? donHang.getDiaChiGiao().getDiaChiChiTiet() : "Chưa xác định";
        String nguoiNhan = donHang.getDiaChiGiao() != null
                ? donHang.getDiaChiGiao().getHoTenNguoiNhan() : customerName;
        String sdtNguoiNhan = donHang.getDiaChiGiao() != null
                ? donHang.getDiaChiGiao().getSoDienThoai() : "";
        String phuongThuc = donHang.getHinhThucThanhToan() != null
                ? donHang.getHinhThucThanhToan().getTenHinhThuc() : "COD";
        String ngayDat = donHang.getNgayDat() != null
                ? donHang.getNgayDat().format(dtf) : "N/A";
        String tongTien = currencyFormat.format(donHang.getTongTien());

        return """
                <!DOCTYPE html>
                <html lang="vi">
                <head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
                <title>Xác nhận đơn hàng</title></head>
                <body style="margin:0;padding:0;background-color:#F9FAFB;font-family:'Segoe UI',Arial,sans-serif;">
                  <table width="100%%" cellpadding="0" cellspacing="0" style="background-color:#F9FAFB;">
                    <tr><td align="center" style="padding:40px 20px;">
                      <table width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%%;background:#FFFFFF;border-radius:16px;overflow:hidden;box-shadow:0 4px 24px rgba(0,0,0,0.08);">

                        <!-- HEADER -->
                        <tr><td style="background:linear-gradient(135deg,#1a1a2e 0%%,#16213e 50%%,#0f3460 100%%);padding:40px 32px;text-align:center;">
                          <h1 style="margin:0;color:#FFFFFF;font-size:28px;font-weight:700;letter-spacing:2px;font-family:Georgia,serif;">
                            ✦ LUXURY SHOP ✦
                          </h1>
                          <p style="margin:8px 0 0;color:#D5BFA3;font-size:13px;letter-spacing:1px;">PREMIUM FASHION EXPERIENCE</p>
                        </td></tr>

                        <!-- SUCCESS BANNER -->
                        <tr><td style="background:linear-gradient(135deg,#065F46,#047857);padding:24px 32px;text-align:center;">
                          <div style="font-size:40px;margin-bottom:8px;">🎉</div>
                          <h2 style="margin:0;color:#FFFFFF;font-size:22px;font-weight:700;">Đặt hàng thành công!</h2>
                          <p style="margin:6px 0 0;color:#A7F3D0;font-size:14px;">Cảm ơn bạn đã tin tưởng mua sắm tại Luxury Shop</p>
                        </td></tr>

                        <!-- ORDER INFO -->
                        <tr><td style="padding:32px;">
                          <p style="margin:0 0 20px;color:#374151;font-size:15px;">Xin chào <strong style="color:#111827;">%s</strong>,</p>
                          <p style="margin:0 0 24px;color:#6B7280;font-size:14px;line-height:1.6;">
                            Đơn hàng của bạn đã được xác nhận và đang được xử lý. Chúng tôi sẽ thông báo ngay khi đơn hàng được giao đến bạn.
                          </p>

                          <!-- ORDER CARD -->
                          <div style="background:#F8F9FF;border:1px solid #E5E7EB;border-radius:12px;padding:20px;margin-bottom:24px;">
                            <table width="100%%" cellpadding="0" cellspacing="0">
                              <tr>
                                <td width="50%%">
                                  <div style="color:#6B7280;font-size:12px;text-transform:uppercase;letter-spacing:0.5px;">Mã đơn hàng</div>
                                  <div style="color:#111827;font-weight:700;font-size:18px;margin-top:4px;">#%d</div>
                                </td>
                                <td width="50%%" align="right">
                                  <span style="background:#FEF3C7;color:#92400E;font-size:12px;font-weight:600;padding:4px 12px;border-radius:20px;">⏳ Chờ xác nhận</span>
                                </td>
                              </tr>
                            </table>
                            <hr style="border:none;border-top:1px solid #E5E7EB;margin:16px 0;">
                            <table width="100%%" cellpadding="0" cellspacing="0">
                              <tr>
                                <td style="color:#6B7280;font-size:13px;padding-bottom:8px;">📅 Ngày đặt:</td>
                                <td style="color:#111827;font-size:13px;text-align:right;padding-bottom:8px;font-weight:500;">%s</td>
                              </tr>
                              <tr>
                                <td style="color:#6B7280;font-size:13px;padding-bottom:8px;">💳 Thanh toán:</td>
                                <td style="color:#111827;font-size:13px;text-align:right;padding-bottom:8px;font-weight:500;">%s</td>
                              </tr>
                              <tr>
                                <td style="color:#6B7280;font-size:13px;">📍 Giao đến:</td>
                                <td style="color:#111827;font-size:13px;text-align:right;font-weight:500;">%s</td>
                              </tr>
                            </table>
                          </div>

                          <!-- SHIPPING INFO -->
                          <div style="background:#EFF6FF;border-left:4px solid #3B82F6;border-radius:0 8px 8px 0;padding:16px;margin-bottom:24px;">
                            <div style="font-weight:600;color:#1D4ED8;font-size:13px;margin-bottom:4px;">📦 Thông tin giao hàng</div>
                            <div style="color:#374151;font-size:13px;">Người nhận: <strong>%s</strong></div>
                            <div style="color:#374151;font-size:13px;margin-top:3px;">SĐT: %s</div>
                            <div style="color:#374151;font-size:13px;margin-top:3px;">Địa chỉ: %s</div>
                          </div>

                          <!-- PRODUCTS TABLE -->
                          <h3 style="margin:0 0 16px;color:#111827;font-size:16px;font-weight:700;">🛍️ Sản phẩm đã đặt</h3>
                          <table width="100%%" cellpadding="0" cellspacing="0" style="border:1px solid #E5E7EB;border-radius:10px;overflow:hidden;">
                            <thead>
                              <tr style="background:#F3F4F6;">
                                <th style="padding:12px 16px;text-align:left;color:#6B7280;font-size:12px;text-transform:uppercase;font-weight:600;">Sản phẩm</th>
                                <th style="padding:12px 16px;text-align:center;color:#6B7280;font-size:12px;text-transform:uppercase;font-weight:600;">SL</th>
                                <th style="padding:12px 16px;text-align:right;color:#6B7280;font-size:12px;text-transform:uppercase;font-weight:600;">Thành tiền</th>
                              </tr>
                            </thead>
                            <tbody>
                              %s
                            </tbody>
                            <tfoot>
                              <tr style="background:#F9FAFB;">
                                <td colspan="2" style="padding:16px;text-align:right;color:#374151;font-size:14px;font-weight:600;">🚚 Phí vận chuyển:</td>
                                <td style="padding:16px;text-align:right;color:#059669;font-size:14px;font-weight:700;">Miễn phí</td>
                              </tr>
                              <tr style="background:#1a1a2e;">
                                <td colspan="2" style="padding:16px;text-align:right;color:#D5BFA3;font-size:15px;font-weight:700;">💰 Tổng cộng:</td>
                                <td style="padding:16px;text-align:right;color:#FFFFFF;font-size:18px;font-weight:900;">%s₫</td>
                              </tr>
                            </tfoot>
                          </table>

                          <!-- CTA BUTTON -->
                          <div style="text-align:center;margin-top:32px;">
                            <a href="http://localhost:5173/profile#orders"
                               style="display:inline-block;background:linear-gradient(135deg,#1a1a2e,#0f3460);color:#FFFFFF;font-size:15px;font-weight:700;text-decoration:none;padding:14px 36px;border-radius:50px;letter-spacing:0.5px;">
                              Theo dõi đơn hàng →
                            </a>
                          </div>
                        </td></tr>

                        <!-- FOOTER -->
                        <tr><td style="background:#F8F9FF;padding:24px 32px;text-align:center;border-top:1px solid #E5E7EB;">
                          <p style="margin:0;color:#6B7280;font-size:13px;">✦ Luxury Fashion Shop — Nâng tầm phong cách của bạn</p>
                          <p style="margin:8px 0 0;color:#9CA3AF;font-size:12px;">Hotline: 079 9191940 | luxury@fashion.vn</p>
                          <p style="margin:8px 0 0;color:#9CA3AF;font-size:11px;">Email này được gửi tự động, vui lòng không trả lời.</p>
                        </td></tr>

                      </table>
                    </td></tr>
                  </table>
                </body>
                </html>
                """.formatted(
                customerName, donHang.getMaDH(), ngayDat, phuongThuc, diaChi,
                nguoiNhan, sdtNguoiNhan, diaChi,
                items.toString(), tongTien
        );
    }
    @Async
    public void sendOtpEmail(String toEmail, String otp) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail, fromName);
            helper.setTo(toEmail);
            helper.setSubject("🔐 Mã xác nhận đổi mật khẩu - Luxury Fashion");

            String content = """
                <html>
                <body style="font-family:Arial,sans-serif;">
                    <h2>🔐 Xác nhận đổi mật khẩu</h2>
                    <p>Mã OTP của bạn là:</p>
                    <h1 style="color:#0f3460;">%s</h1>
                    <p>Mã có hiệu lực trong <b>5 phút</b>.</p>
                    <br>
                    <p>Nếu bạn không yêu cầu, hãy bỏ qua email này.</p>
                    <p>— Luxury Fashion</p>
                </body>
                </html>
                """.formatted(otp);

            helper.setText(content, true);

            mailSender.send(message);

            log.info("✅ Đã gửi OTP tới {}", toEmail);

        } catch (Exception e) {
            log.error("❌ Lỗi gửi OTP email: {}", e.getMessage());
        }
    }
}
