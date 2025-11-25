package com.example.projectend.controller;

import com.example.projectend.dto.CheckoutItemDTO;
import com.example.projectend.entity.*;
import com.example.projectend.service.DiaChiService;
import com.example.projectend.service.DonHangService;
import com.example.projectend.service.GioHangService;
import com.example.projectend.service.TaiKhoanService;
import com.example.projectend.repository.PhuongThucThanhToanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.*;

/**
 * Controller xử lý thanh toán và đặt hàng
 */
@Controller
@RequestMapping("/checkout")
public class CheckoutController extends BaseController {

    @Autowired
    private GioHangService gioHangService;

    @Autowired
    private TaiKhoanService taiKhoanService;

    @Autowired
    private DiaChiService diaChiService;

    @Autowired
    private DonHangService donHangService;

    @Autowired
    private PhuongThucThanhToanRepository phuongThucThanhToanRepository;

    /**
     * Hiển thị trang thanh toán - SỬ DỤNG DTO ĐỂ TRÁNH LAZY
     */
    @GetMapping("")
    public String checkout(Model model, Principal principal) {
        try {
            // Kiểm tra đăng nhập
            if (principal == null) {
                return "redirect:/login?returnUrl=/checkout";
            }

            TaiKhoan tk = taiKhoanService.findByEmail(principal.getName());
            if (tk == null) {
                return "redirect:/login";
            }

            // Lấy giỏ hàng và chuyển sang DTO
            List<GioHangChiTiet> items = gioHangService.getGioHangByTaiKhoan(tk);
            if (items.isEmpty()) {
                return "redirect:/giohang?error=empty";
            }

            // Chuyển Entity → DTO
            List<CheckoutItemDTO> itemDTOs = new ArrayList<>();
            BigDecimal tongTien = BigDecimal.ZERO;

            for (GioHangChiTiet item : items) {
                SanPhamChiTiet spct = item.getSanPhamChiTiet();
                BigDecimal thanhTien = spct.getGiaBan().multiply(BigDecimal.valueOf(item.getSoLuong()));
                tongTien = tongTien.add(thanhTien);

                String anh = spct.getAnhBienThe();
                if (anh == null || anh.isEmpty()) {
                    anh = spct.getSanPham().getAnhChinh();
                }
                if (anh == null || anh.isEmpty()) {
                    anh = "placeholder.png";
                }

                CheckoutItemDTO dto = new CheckoutItemDTO(
                    spct.getMaBienThe(),
                    spct.getSanPham().getTenSP(),
                    spct.getSanPham().getThuongHieu() != null ? spct.getSanPham().getThuongHieu().getTenTH() : "BRAND",
                    spct.getSizeSP() != null ? spct.getSizeSP().getTenSize() : "",
                    spct.getMauSacSP() != null ? spct.getMauSacSP().getTenMau() : "",
                    item.getSoLuong(),
                    spct.getGiaBan(),
                    thanhTien,
                    anh
                );
                itemDTOs.add(dto);
            }

            model.addAttribute("cartItems", itemDTOs);
            model.addAttribute("orderSubtotal", tongTien);
            model.addAttribute("orderTotal", tongTien);

            // Lấy danh sách địa chỉ
            List<DiaChi> diaChiList = diaChiService.getDiaChiByTaiKhoan(tk);
            model.addAttribute("diaChiList", diaChiList);

            // Địa chỉ mặc định
            Optional<DiaChi> defaultAddress = diaChiService.getDiaChiMacDinh(tk);
            if (defaultAddress.isPresent()) {
                model.addAttribute("defaultAddress", defaultAddress.get());
            }

            // Lấy danh sách phương thức thanh toán
            List<PhuongThucThanhToan> paymentMethods = phuongThucThanhToanRepository.findByTrangThai(true);
            model.addAttribute("paymentMethods", paymentMethods);

            model.addAttribute("user", tk);

            // Breadcrumb
            Map<String, String> breadcrumb1 = new HashMap<>();
            breadcrumb1.put("name", "Giỏ hàng");
            breadcrumb1.put("url", "/giohang");
            Map<String, String> breadcrumb2 = new HashMap<>();
            breadcrumb2.put("name", "Thanh toán");
            breadcrumb2.put("url", null);
            model.addAttribute("breadcrumbItems", List.of(breadcrumb1, breadcrumb2));

            model.addAttribute("currentPage", "checkout");
            model.addAttribute("pageTitle", "Thanh toán");

            return "Checkout";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/giohang";
        }
    }

    /**
     * Xử lý đặt hàng
     */
    @PostMapping("/place-order")
    public String processCheckout(
            @RequestParam Long diaChiId,
            @RequestParam(name = "paymentMethod", required = false, defaultValue = "1") Long phuongThucId,
            @RequestParam(required = false) String ghiChu,
            Principal principal,
            RedirectAttributes redirectAttributes) {

        try {
            if (principal == null) {
                return "redirect:/login";
            }

            TaiKhoan tk = taiKhoanService.findByEmail(principal.getName());
            if (tk == null) {
                return "redirect:/login";
            }

            List<GioHangChiTiet> items = gioHangService.getGioHangByTaiKhoan(tk);
            if (items.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Giỏ hàng trống!");
                return "redirect:/giohang";
            }

            DonHang donHang = donHangService.createDonHang(tk, diaChiId, phuongThucId, items, ghiChu);
            if (donHang == null) {
                redirectAttributes.addFlashAttribute("error", "Đặt hàng thất bại!");
                return "redirect:/checkout";
            }

            // Lấy thông tin phương thức để xác định PayOS thay vì dùng ID cố định
            boolean isPayOS = phuongThucThanhToanRepository.findById(phuongThucId)
                    .map(pt -> pt.getTenHinhThuc() != null && pt.getTenHinhThuc().toLowerCase().contains("payos"))
                    .orElse(false);

            if (isPayOS) {
                // Không clear giỏ hàng ngay; chờ thanh toán thành công rồi mới xóa
                redirectAttributes.addFlashAttribute("success", "Đơn hàng đã được tạo. Vui lòng quét mã QR để thanh toán!");
                return "redirect:/payment/payos/create?orderId=" + donHang.getMaDH();
            }

            // Các phương thức khác (COD, VNPay, ...): clear giỏ hàng ngay
            gioHangService.clearGioHang(tk);
            redirectAttributes.addFlashAttribute("success", "Đặt hàng thành công!");
            return "redirect:/checkout/success?orderId=" + donHang.getMaDH();

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
            return "redirect:/checkout";
        }
    }

    /**
     * Trang cảm ơn sau khi đặt hàng thành công
     */
    @GetMapping("/success")
    public String checkoutSuccess(@RequestParam Long orderId, Model model, Principal principal) {

        if (principal == null) {
            return "redirect:/login";
        }

        TaiKhoan tk = taiKhoanService.findByEmail(principal.getName());
        if (tk == null) {
            return "redirect:/login";
        }

        // Lấy thông tin đơn hàng
        Optional<DonHang> donHangOpt = donHangService.findByIdAndKhachHang(orderId, tk);
        if (!donHangOpt.isPresent()) {
            return "redirect:/profile";
        }

        DonHang donHang = donHangOpt.get();
        model.addAttribute("donHang", donHang);

        // Lấy chi tiết đơn hàng
        List<DonHangChiTiet> chiTiet = donHangService.getChiTietDonHang(donHang);
        model.addAttribute("chiTiet", chiTiet);

        model.addAttribute("pageTitle", "Đặt hàng thành công");
        model.addAttribute("currentPage", "checkout-success");
        return "Checkout-success";
    }
}
