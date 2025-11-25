package com.example.projectend.controller;

import com.example.projectend.entity.DiaChi;
import com.example.projectend.entity.DonHang;
import com.example.projectend.entity.DonHangChiTiet;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.DiaChiRepository;
import com.example.projectend.repository.DonHangRepository;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.service.DonHangService;
import com.example.projectend.service.GioHangService;
import com.example.projectend.service.DiaChiService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Controller quản lý thông tin cá nhân và đơn hàng người dùng
 */
@Controller
public class ProfileController extends BaseController {

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @Autowired
    private DiaChiRepository diaChiRepository;

    @Autowired
    private DonHangRepository donHangRepository;

    @Autowired
    private DonHangService donHangService;

    @Autowired
    private GioHangService gioHangService;

    @Autowired
    private DiaChiService diaChiService;

    /**
     * Hiển thị trang thông tin cá nhân và đơn hàng
     */
    @GetMapping("/profile")
    public String profile(Model model, Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }

        model.addAttribute("currentPage", "profile");

        String email = principal.getName();
        TaiKhoan taiKhoan = taiKhoanRepository.findByEmail(email).orElse(null);
        if (taiKhoan == null) {
            model.addAttribute("error", "Không tìm thấy tài khoản của bạn.");
            return "error/403";
        }

        model.addAttribute("taiKhoan", taiKhoan);

        // Lấy danh sách địa chỉ
        List<DiaChi> diaChiList = diaChiRepository.findByTaiKhoan_MaTK(taiKhoan.getMaTK());
        model.addAttribute("diaChiList", diaChiList);

        // Lấy danh sách đơn hàng
        List<DonHang> donHangList = donHangRepository.findByTaiKhoan_MaTKOrderByNgayDatDesc(taiKhoan.getMaTK());
        model.addAttribute("donHangList", donHangList);

        // Breadcrumb
        Map<String, String> breadcrumbItem = new HashMap<>();
        breadcrumbItem.put("name", "Thông tin cá nhân");
        breadcrumbItem.put("url", null);
        model.addAttribute("breadcrumbItems", List.of(breadcrumbItem));
        model.addAttribute("pageTitle", "Thông tin cá nhân - Tết Market");

        return "Profile";
    }

    /**
     * Cập nhật thông tin cá nhân
     */
    @PostMapping("/profile/update")
    public String updateProfile(
            @RequestParam String hoTen,
            @RequestParam(required = false) String soDienThoai,
            Principal principal,
            RedirectAttributes redirectAttributes) {

        if (principal == null) {
            return "redirect:/login";
        }

        try {
            String email = principal.getName();
            TaiKhoan taiKhoan = taiKhoanRepository.findByEmail(email).orElse(null);

            if (taiKhoan == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy tài khoản!");
                return "redirect:/profile";
            }

            taiKhoan.setHoTen(hoTen);
            taiKhoan.setSoDienThoai(soDienThoai);
            taiKhoanRepository.save(taiKhoan);

            redirectAttributes.addFlashAttribute("success", "Cập nhật thông tin thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }

        return "redirect:/profile";
    }

    /**
     * Đổi mật khẩu
     */
    @PostMapping("/profile/change-password")
    public String changePassword(
            @RequestParam("oldPassword") String currentPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            Principal principal,
            RedirectAttributes redirectAttributes) {

        if (principal == null) {
            return "redirect:/login";
        }

        try {
            String email = principal.getName();
            TaiKhoan taiKhoan = taiKhoanRepository.findByEmail(email).orElse(null);

            if (taiKhoan == null) {
                redirectAttributes.addFlashAttribute("errorPassword", "Không tìm thấy tài khoản!");
                return "redirect:/profile#password";
            }

            // Kiểm tra mật khẩu hiện tại
            if (!taiKhoan.getMatKhau().equals(currentPassword)) {
                redirectAttributes.addFlashAttribute("errorPassword", "Mật khẩu hiện tại không đúng!");
                return "redirect:/profile#password";
            }

            // Kiểm tra mật khẩu mới khớp
            if (!newPassword.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("errorPassword", "Mật khẩu mới không khớp!");
                return "redirect:/profile#password";
            }

            taiKhoan.setMatKhau(newPassword);
            taiKhoanRepository.save(taiKhoan);

            redirectAttributes.addFlashAttribute("successPassword", "Đổi mật khẩu thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorPassword", "Có lỗi xảy ra: " + e.getMessage());
        }

        return "redirect:/profile#password";
    }

    /**
     * Hiển thị chi tiết đơn hàng
     */
    @GetMapping("/order-detail/{id}")
    public String orderDetail(@PathVariable Long id, Model model, Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }

        String email = principal.getName();
        TaiKhoan taiKhoan = taiKhoanRepository.findByEmail(email).orElse(null);
        if (taiKhoan == null) {
            return "redirect:/login";
        }

        // Lấy thông tin đơn hàng và kiểm tra quyền sở hữu
        Optional<DonHang> donHangOpt = donHangRepository.findByMaDHAndTaiKhoan_MaTK(id, taiKhoan.getMaTK());
        if (donHangOpt.isEmpty()) {
            model.addAttribute("error", "Không tìm thấy đơn hàng hoặc bạn không có quyền xem đơn hàng này!");
            return "redirect:/profile#orders";
        }

        DonHang donHang = donHangOpt.get();
        List<DonHangChiTiet> chiTiet = donHangService.getChiTietDonHang(donHang);

        model.addAttribute("donHang", donHang);
        model.addAttribute("chiTiet", chiTiet);
        model.addAttribute("currentPage", "order-detail");
        model.addAttribute("pageTitle", "Chi tiết đơn hàng #" + id);

        return "Order-detail";
    }

    @PostMapping("/profile/address/add")
    public String addAddress(@RequestParam String diaChiChiTiet,
                             @RequestParam(required = false, defaultValue = "false") Boolean macDinh,
                             Principal principal,
                             RedirectAttributes redirectAttributes) {
        if (principal == null) return "redirect:/login";
        TaiKhoan taiKhoan = taiKhoanRepository.findByEmail(principal.getName()).orElse(null);
        if (taiKhoan == null) return "redirect:/login";
        try {
            DiaChi dc = new DiaChi();
            dc.setTaiKhoan(taiKhoan);
            dc.setDiaChiChiTiet(diaChiChiTiet.trim());
            dc.setHoTenNguoiNhan(taiKhoan.getHoTen());
            dc.setSoDienThoai(taiKhoan.getSoDienThoai() != null ? taiKhoan.getSoDienThoai() : "");
            dc.setLaMacDinh(false);
            diaChiRepository.save(dc);
            if (macDinh != null && macDinh) {
                diaChiService.setMacDinh(dc.getMaDiaChi(), taiKhoan);
            }
            redirectAttributes.addFlashAttribute("successAddress", "Thêm địa chỉ thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorAddress", "Lỗi: " + e.getMessage());
        }
        return "redirect:/profile#addresses";
    }

    @PostMapping("/profile/address/delete")
    public String deleteAddress(@RequestParam Long id, Principal principal, RedirectAttributes redirectAttributes) {
        if (principal == null) return "redirect:/login";
        TaiKhoan tk = taiKhoanRepository.findByEmail(principal.getName()).orElse(null);
        if (tk == null) return "redirect:/login";
        try {
            diaChiService.delete(id, tk);
            redirectAttributes.addFlashAttribute("successAddress", "Đã xóa địa chỉ!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorAddress", "Lỗi: " + e.getMessage());
        }
        return "redirect:/profile#addresses";
    }

    @PostMapping("/profile/address/set-default")
    public String setDefaultAddress(@RequestParam Long id, Principal principal, RedirectAttributes redirectAttributes) {
        if (principal == null) return "redirect:/login";
        TaiKhoan tk = taiKhoanRepository.findByEmail(principal.getName()).orElse(null);
        if (tk == null) return "redirect:/login";
        try {
            diaChiService.setMacDinh(id, tk);
            redirectAttributes.addFlashAttribute("successAddress", "Đã đặt địa chỉ mặc định!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorAddress", "Lỗi: " + e.getMessage());
        }
        return "redirect:/profile#addresses";
    }

    /**
     * ✨ MỚI: Sửa địa chỉ
     */
    @PostMapping("/profile/address/edit")
    public String editAddress(@RequestParam Long id,
                              @RequestParam String hoTenNguoiNhan,
                              @RequestParam String soDienThoai,
                              @RequestParam String diaChiChiTiet,
                              Principal principal,
                              RedirectAttributes redirectAttributes) {
        if (principal == null) return "redirect:/login";

        TaiKhoan tk = taiKhoanRepository.findByEmail(principal.getName()).orElse(null);
        if (tk == null) return "redirect:/login";

        try {
            // Lấy địa chỉ và kiểm tra quyền sở hữu
            DiaChi diaChi = diaChiRepository.findById(id).orElse(null);

            if (diaChi == null) {
                redirectAttributes.addFlashAttribute("errorAddress", "Không tìm thấy địa chỉ!");
                return "redirect:/profile#addresses";
            }

            // Kiểm tra địa chỉ có thuộc về user hiện tại không
            if (!diaChi.getTaiKhoan().getMaTK().equals(tk.getMaTK())) {
                redirectAttributes.addFlashAttribute("errorAddress", "Bạn không có quyền sửa địa chỉ này!");
                return "redirect:/profile#addresses";
            }

            // Cập nhật thông tin
            diaChi.setHoTenNguoiNhan(hoTenNguoiNhan.trim());
            diaChi.setSoDienThoai(soDienThoai.trim());
            diaChi.setDiaChiChiTiet(diaChiChiTiet.trim());

            diaChiRepository.save(diaChi);

            redirectAttributes.addFlashAttribute("successAddress", "Cập nhật địa chỉ thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorAddress", "Lỗi: " + e.getMessage());
        }

        return "redirect:/profile#addresses";
    }

    @PostMapping("/profile/order/cancel")
    public String cancelOrder(@RequestParam Long id, Principal principal, RedirectAttributes redirectAttributes) {
        if (principal == null) return "redirect:/login";
        TaiKhoan tk = taiKhoanRepository.findByEmail(principal.getName()).orElse(null);
        if (tk == null) return "redirect:/login";
        try {
            boolean ok = donHangService.huyDonHang(id, tk);
            if (ok) redirectAttributes.addFlashAttribute("success", "Đã hủy đơn hàng #" + id);
            else redirectAttributes.addFlashAttribute("error", "Không thể hủy đơn hàng #" + id);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/profile#orders";
    }

    @PostMapping("/profile/order/reorder")
    public String reorder(@RequestParam Long id, Principal principal, RedirectAttributes redirectAttributes) {
        if (principal == null) return "redirect:/login";
        TaiKhoan tk = taiKhoanRepository.findByEmail(principal.getName()).orElse(null);
        if (tk == null) return "redirect:/login";
        Optional<DonHang> dhOpt = donHangRepository.findByMaDHAndTaiKhoan_MaTK(id, tk.getMaTK());
        if (dhOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy đơn hàng!");
            return "redirect:/profile#orders";
        }
        DonHang dh = dhOpt.get();
        try {
            List<DonHangChiTiet> ctList = donHangService.getChiTietDonHang(dh);
            for (DonHangChiTiet ct : ctList) {
                gioHangService.addToCart(tk, ct.getSanPhamChiTiet().getMaBienThe(), ct.getSoLuong());
            }
            redirectAttributes.addFlashAttribute("success", "Đã thêm sản phẩm vào giỏ hàng từ đơn #" + id);
            return "redirect:/giohang";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
            return "redirect:/profile#orders";
        }
    }
}
