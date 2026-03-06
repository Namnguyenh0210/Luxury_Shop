package com.example.projectend.controller;

import com.example.projectend.entity.DiaChi;
import com.example.projectend.entity.DonHang;
import com.example.projectend.entity.DonHangChiTiet;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.DiaChiRepository;
import com.example.projectend.repository.DonHangRepository;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.service.DiaChiService;
import com.example.projectend.service.DonHangService;
import com.example.projectend.service.GioHangService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.List;
import java.util.Optional;

/**
 * ProfileController — GET renders redirect to Vue SPA.
 * POST endpoints (update, address, order) redirect to Vue after action.
 */
@Controller
public class ProfileController {

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

    // ─── GET Redirects ────────────────────────────────────────────────

    @GetMapping("/profile")
    public String profile(Principal principal) {
        if (principal == null)
            return "redirect:http://localhost:5173/login";
        return "redirect:http://localhost:5173/profile";
    }

    @GetMapping("/order-detail/{id}")
    public String orderDetail(@PathVariable Long id, Principal principal) {
        if (principal == null)
            return "redirect:http://localhost:5173/login";
        return "redirect:http://localhost:5173/profile/order/" + id;
    }

    // ─── POST Actions (vẫn chạy logic, redirect về Vue sau) ──────────

    @PostMapping("/profile/update")
    public String updateProfile(
            @RequestParam String hoTen,
            @RequestParam(required = false) String soDienThoai,
            Principal principal,
            RedirectAttributes ra) {

        if (principal == null)
            return "redirect:http://localhost:5173/login";
        try {
            TaiKhoan tk = taiKhoanRepository.findByEmail(principal.getName()).orElse(null);
            if (tk == null) {
                ra.addFlashAttribute("error", "Không tìm thấy tài khoản!");
                return "redirect:http://localhost:5173/profile";
            }
            tk.setHoTen(hoTen);
            tk.setSoDienThoai(soDienThoai);
            taiKhoanRepository.save(tk);
            ra.addFlashAttribute("success", "Cập nhật thông tin thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Có lỗi: " + e.getMessage());
        }
        return "redirect:http://localhost:5173/profile";
    }

    @PostMapping("/profile/change-password")
    public String changePassword(
            @RequestParam("oldPassword") String currentPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            Principal principal,
            RedirectAttributes ra) {

        if (principal == null)
            return "redirect:http://localhost:5173/login";
        try {
            TaiKhoan tk = taiKhoanRepository.findByEmail(principal.getName()).orElse(null);
            if (tk == null) {
                ra.addFlashAttribute("errorPassword", "Không tìm thấy tài khoản!");
                return "redirect:http://localhost:5173/profile";
            }
            if (!tk.getMatKhau().equals(currentPassword)) {
                ra.addFlashAttribute("errorPassword", "Mật khẩu hiện tại không đúng!");
                return "redirect:http://localhost:5173/profile";
            }
            if (!newPassword.equals(confirmPassword)) {
                ra.addFlashAttribute("errorPassword", "Mật khẩu mới không khớp!");
                return "redirect:http://localhost:5173/profile";
            }
            tk.setMatKhau(newPassword);
            taiKhoanRepository.save(tk);
            ra.addFlashAttribute("successPassword", "Đổi mật khẩu thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorPassword", "Có lỗi: " + e.getMessage());
        }
        return "redirect:http://localhost:5173/profile";
    }

    @PostMapping("/profile/address/add")
    public String addAddress(@RequestParam String diaChiChiTiet,
            @RequestParam(required = false, defaultValue = "false") Boolean macDinh,
            Principal principal, RedirectAttributes ra) {
        if (principal == null)
            return "redirect:http://localhost:5173/login";
        TaiKhoan tk = taiKhoanRepository.findByEmail(principal.getName()).orElse(null);
        if (tk == null)
            return "redirect:http://localhost:5173/login";
        try {
            DiaChi dc = new DiaChi();
            dc.setTaiKhoan(tk);
            dc.setDiaChiChiTiet(diaChiChiTiet.trim());
            dc.setHoTenNguoiNhan(tk.getHoTen());
            dc.setSoDienThoai(tk.getSoDienThoai() != null ? tk.getSoDienThoai() : "");
            dc.setLaMacDinh(false);
            diaChiRepository.save(dc);
            if (Boolean.TRUE.equals(macDinh))
                diaChiService.setMacDinh(dc.getMaDiaChi(), tk);
            ra.addFlashAttribute("successAddress", "Thêm địa chỉ thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorAddress", "Lỗi: " + e.getMessage());
        }
        return "redirect:http://localhost:5173/profile";
    }

    @PostMapping("/profile/address/delete")
    public String deleteAddress(@RequestParam Long id, Principal principal, RedirectAttributes ra) {
        if (principal == null)
            return "redirect:http://localhost:5173/login";
        TaiKhoan tk = taiKhoanRepository.findByEmail(principal.getName()).orElse(null);
        if (tk == null)
            return "redirect:http://localhost:5173/login";
        try {
            diaChiService.delete(id, tk);
            ra.addFlashAttribute("successAddress", "Đã xóa địa chỉ!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorAddress", "Lỗi: " + e.getMessage());
        }
        return "redirect:http://localhost:5173/profile";
    }

    @PostMapping("/profile/address/set-default")
    public String setDefaultAddress(@RequestParam Long id, Principal principal, RedirectAttributes ra) {
        if (principal == null)
            return "redirect:http://localhost:5173/login";
        TaiKhoan tk = taiKhoanRepository.findByEmail(principal.getName()).orElse(null);
        if (tk == null)
            return "redirect:http://localhost:5173/login";
        try {
            diaChiService.setMacDinh(id, tk);
            ra.addFlashAttribute("successAddress", "Đã đặt địa chỉ mặc định!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorAddress", "Lỗi: " + e.getMessage());
        }
        return "redirect:http://localhost:5173/profile";
    }

    @PostMapping("/profile/address/edit")
    public String editAddress(@RequestParam Long id,
            @RequestParam String hoTenNguoiNhan,
            @RequestParam String soDienThoai,
            @RequestParam String diaChiChiTiet,
            Principal principal, RedirectAttributes ra) {
        if (principal == null)
            return "redirect:http://localhost:5173/login";
        TaiKhoan tk = taiKhoanRepository.findByEmail(principal.getName()).orElse(null);
        if (tk == null)
            return "redirect:http://localhost:5173/login";
        try {
            DiaChi dc = diaChiRepository.findById(id).orElse(null);
            if (dc == null) {
                ra.addFlashAttribute("errorAddress", "Không tìm thấy địa chỉ!");
                return "redirect:http://localhost:5173/profile";
            }
            if (!dc.getTaiKhoan().getMaTK().equals(tk.getMaTK())) {
                ra.addFlashAttribute("errorAddress", "Không có quyền sửa!");
                return "redirect:http://localhost:5173/profile";
            }
            dc.setHoTenNguoiNhan(hoTenNguoiNhan.trim());
            dc.setSoDienThoai(soDienThoai.trim());
            dc.setDiaChiChiTiet(diaChiChiTiet.trim());
            diaChiRepository.save(dc);
            ra.addFlashAttribute("successAddress", "Cập nhật địa chỉ thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorAddress", "Lỗi: " + e.getMessage());
        }
        return "redirect:http://localhost:5173/profile";
    }

    @PostMapping("/profile/order/cancel")
    public String cancelOrder(@RequestParam Long id, Principal principal, RedirectAttributes ra) {
        if (principal == null)
            return "redirect:http://localhost:5173/login";
        TaiKhoan tk = taiKhoanRepository.findByEmail(principal.getName()).orElse(null);
        if (tk == null)
            return "redirect:http://localhost:5173/login";
        try {
            boolean ok = donHangService.huyDonHang(id, tk);
            if (ok)
                ra.addFlashAttribute("success", "Đã hủy đơn hàng #" + id);
            else
                ra.addFlashAttribute("error", "Không thể hủy đơn hàng #" + id);
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:http://localhost:5173/profile";
    }

    @PostMapping("/profile/order/reorder")
    public String reorder(@RequestParam Long id, Principal principal, RedirectAttributes ra) {
        if (principal == null)
            return "redirect:http://localhost:5173/login";
        TaiKhoan tk = taiKhoanRepository.findByEmail(principal.getName()).orElse(null);
        if (tk == null)
            return "redirect:http://localhost:5173/login";
        Optional<DonHang> dhOpt = donHangRepository.findByMaDHAndTaiKhoan_MaTK(id, tk.getMaTK());
        if (dhOpt.isEmpty()) {
            ra.addFlashAttribute("error", "Không tìm thấy đơn hàng!");
            return "redirect:http://localhost:5173/profile";
        }
        try {
            List<DonHangChiTiet> ctList = donHangService.getChiTietDonHang(dhOpt.get());
            for (DonHangChiTiet ct : ctList) {
                gioHangService.addToCart(tk, ct.getSanPhamChiTiet().getMaBienThe(), ct.getSoLuong());
            }
            ra.addFlashAttribute("success", "Đã thêm sản phẩm vào giỏ hàng từ đơn #" + id);
            return "redirect:http://localhost:5173/giohang";
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Lỗi: " + e.getMessage());
            return "redirect:http://localhost:5173/profile";
        }
    }
}
