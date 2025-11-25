package com.example.projectend.controller.staff;

import com.example.projectend.entity.DonHang;
import com.example.projectend.entity.DonHangChiTiet;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.DonHangRepository;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.service.DonHangService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * STAFF DON HANG CONTROLLER - Quản lý đơn hàng (NHÂN VIÊN)
 */
@Controller
@RequestMapping("/staff/orders")
@PreAuthorize("hasAnyRole('NHANVIEN', 'ADMIN')")
public class StaffDonHangController {

    @Autowired
    private DonHangService donHangService;

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @Autowired
    private DonHangRepository donHangRepository;

    /**
     * Danh sách đơn hàng
     */
    @GetMapping("")
    public String danhSachDonHang(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) Integer trangThai,
            Authentication auth,
            Model model) {

        Pageable pageable = PageRequest.of(page, size, Sort.by("ngayDat").descending());

        Page<DonHang> donHangPage;
        if (trangThai != null) {
            donHangPage = donHangService.getDonHangByTrangThai(trangThai, pageable);
        } else {
            donHangPage = donHangService.getAllDonHangPage(pageable);
        }

        model.addAttribute("donHangPage", donHangPage);
        model.addAttribute("orders", donHangPage.getContent());
        model.addAttribute("trangThaiFilter", trangThai);
        model.addAttribute("currentPage", "donhang");
        model.addAttribute("pageTitle", "Quản lý đơn hàng");

        return "staff/orders";
    }

    /**
     * Chi tiết đơn hàng
     */
    @GetMapping("/detail/{id}")
    public String chiTietDonHang(@PathVariable Long id, Authentication auth, Model model) {

        Optional<DonHang> donHangOpt = donHangService.findById(id);
        if (donHangOpt.isEmpty()) {
            return "redirect:/staff/orders?error=notfound";
        }

        DonHang donHang = donHangOpt.get();

        // Lấy thông tin user hiện tại
        String email = auth.getName();
        TaiKhoan currentUser = taiKhoanRepository.findByEmail(email).orElse(null);

        List<DonHangChiTiet> chiTiet = donHangService.getChiTietDonHang(donHang);

        model.addAttribute("donHang", donHang);
        model.addAttribute("chiTiet", chiTiet);
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("currentPage", "donhang");
        model.addAttribute("pageTitle", "Chi tiết đơn hàng #" + id);

        return "staff/order_detail";
    }

    /**
     * Cập nhật trạng thái đơn hàng - CHỈ TIẾN LÊN, KHÔNG LÙI LẠI
     */
    @PostMapping("/update-status/{id}")
    public String capNhatTrangThai(
            @PathVariable Long id,
            @RequestParam Integer trangThaiMoi,
            Authentication auth,
            RedirectAttributes redirectAttributes) {

        try {
            // Lấy thông tin user hiện tại
            String email = auth.getName();
            TaiKhoan currentUser = taiKhoanRepository.findByEmail(email).orElse(null);

            if (currentUser == null) {
                redirectAttributes.addFlashAttribute("error", "❌ Không tìm thấy thông tin người dùng!");
                return "redirect:/staff/orders/detail/" + id;
            }

            // Lấy đơn hàng
            Optional<DonHang> donHangOpt = donHangService.findById(id);
            if (donHangOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "❌ Không tìm thấy đơn hàng!");
                return "redirect:/staff/orders";
            }

            DonHang donHang = donHangOpt.get();
            Integer trangThaiHienTai = donHang.getTrangThaiDH();

            // Kiểm tra: Không cho phép lùi lại trạng thái
            if (trangThaiMoi <= trangThaiHienTai && trangThaiHienTai != 0) {
                redirectAttributes.addFlashAttribute("error",
                    "❌ Không thể quay lại trạng thái trước đó! Đơn hàng chỉ có thể tiến lên.");
                return "redirect:/staff/orders/detail/" + id;
            }

            // Kiểm tra: Không cho phép cập nhật nếu đã hủy
            if (trangThaiHienTai == 4) {
                redirectAttributes.addFlashAttribute("error",
                    "❌ Đơn hàng đã hủy, không thể cập nhật!");
                return "redirect:/staff/orders/detail/" + id;
            }

            // Tự động gán nhân viên khi xác nhận đơn hàng lần đầu
            if (trangThaiHienTai == 0 && trangThaiMoi >= 1 && donHang.getNhanVien() == null) {
                donHang.setNhanVien(currentUser);
            }

            // Kiểm tra quyền: Nếu đơn hàng đã có nhân viên khác
            if (donHang.getNhanVien() != null &&
                !donHang.getNhanVien().getMaTK().equals(currentUser.getMaTK())) {
                redirectAttributes.addFlashAttribute("error",
                    "❌ Đơn hàng này đã được nhân viên " + donHang.getNhanVien().getHoTen() + " phụ trách!");
                return "redirect:/staff/orders/detail/" + id;
            }

            // Cập nhật trạng thái
            donHang.setTrangThaiDH(trangThaiMoi);
            donHang.setNgayCapNhat(LocalDateTime.now());

            // Nếu hoàn tất thì đánh dấu đã thanh toán
            if (trangThaiMoi == 3) {
                donHang.setTrangThaiThanhToan(1);
                donHang.setNgayThanhToan(LocalDateTime.now());
            }

            donHangRepository.save(donHang);

            redirectAttributes.addFlashAttribute("success",
                "✅ Cập nhật trạng thái thành công! Đơn hàng #" + id + " -> " + donHang.getTrangThaiDHText());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "⚠️ Lỗi: " + e.getMessage());
        }

        return "redirect:/staff/orders/detail/" + id;
    }
}
