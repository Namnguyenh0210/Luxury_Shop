package com.example.projectend.controller.admin;

import com.example.projectend.entity.DonHang;
import com.example.projectend.entity.DonHangChiTiet;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.service.DonHangService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
// import org.springframework.data.domain.Sort; // <-- Bỏ import này
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/orders")
@PreAuthorize("hasRole('ADMIN') or hasRole('NHANVIEN')")
public class AdminDonHangController {

    @Autowired
    private DonHangService donHangService;

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    private boolean isStaff(Authentication auth) {
        return auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_NHANVIEN"));
    }

    // ==========================================
    // 1. DANH SÁCH ĐƠN HÀNG (ĐÃ SỬA LỖI SORT)
    // ==========================================
    @GetMapping
    public String listOrders(@RequestParam(defaultValue = "0") int page,
                             @RequestParam(defaultValue = "10") int size,
                             @RequestParam(required = false) String keyword,
                             @RequestParam(required = false) Integer status, 
                             Model model) {

        // --- SỬA LỖI TẠI ĐÂY ---
        // Bỏ Sort.by("ngayDat") vì trong Service/Repository tên hàm đã có OrderByNgayDatDesc rồi
        // Nếu để cả 2 sẽ bị lỗi "A column has been specified more than once" trên SQL Server
        Pageable pageable = PageRequest.of(page, size); 

        String statusStr = (status != null) ? status.toString() : null;

        Page<DonHang> orderPage = donHangService.searchAdmin(keyword, statusStr, pageable);

        model.addAttribute("orders", orderPage.getContent());
        model.addAttribute("orderPage", orderPage);
        model.addAttribute("keyword", keyword);
        model.addAttribute("currentStatus", status);
        
        model.addAttribute("currentPage", "orders");

        return "admin/order-list";
    }

    // ==========================================
    // 2. CHI TIẾT ĐƠN HÀNG
    // ==========================================
    @GetMapping("/detail/{id}")
    public String orderDetail(@PathVariable Long id, Authentication auth, Model model) {
        Optional<DonHang> orderOpt = donHangService.findById(id);
        
        if (orderOpt.isEmpty()) {
            return "redirect:/admin/orders?error=notfound";
        }

        DonHang order = orderOpt.get();
        List<DonHangChiTiet> orderItems = donHangService.getOrderDetails(id);

        model.addAttribute("order", order);
        model.addAttribute("orderItems", orderItems);
        model.addAttribute("currentPage", "orders");

        return "admin/order-detail";
    }

    // ==========================================
    // 3. CẬP NHẬT TRẠNG THÁI
    // ==========================================
    @PostMapping("/update-status")
    public String updateStatus(@RequestParam Long orderId,
                               @RequestParam Integer status,
                               Authentication auth,
                               RedirectAttributes redirectAttributes) {
        try {
            String email = auth.getName();
            TaiKhoan currentUser = taiKhoanRepository.findByEmail(email).orElse(null);
            
            if (currentUser == null) {
                redirectAttributes.addFlashAttribute("error", "Lỗi xác thực người dùng.");
                return "redirect:/admin/orders/detail/" + orderId;
            }

            DonHang order = donHangService.findById(orderId)
                    .orElseThrow(() -> new Exception("Không tìm thấy đơn hàng"));
            
            Integer currentStatus = order.getTrangThaiDH();
            boolean isStaff = isStaff(auth);

            if (isStaff) {
                if (currentStatus == 0 && status > 0) {
                     order.setNhanVien(currentUser);
                     donHangService.save(order);
                }
                
                if (order.getNhanVien() != null && !order.getNhanVien().getMaTK().equals(currentUser.getMaTK())) {
                    redirectAttributes.addFlashAttribute("error", "Đơn hàng này thuộc về nhân viên: " + order.getNhanVien().getHoTen());
                    return "redirect:/admin/orders/detail/" + orderId;
                }

                if (!isValidTransition(currentStatus, status)) {
                    redirectAttributes.addFlashAttribute("error", "Không thể chuyển trạng thái sai quy trình!");
                    return "redirect:/admin/orders/detail/" + orderId;
                }
            }

            String updatedBy = currentUser.getHoTen();
            boolean success = donHangService.updateOrderStatus(orderId, status, updatedBy);

            if (success) {
                redirectAttributes.addFlashAttribute("success", "Cập nhật trạng thái thành công!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Cập nhật thất bại.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }

        return "redirect:/admin/orders/detail/" + orderId;
    }

    private boolean isValidTransition(Integer from, Integer to) {
        if (from == 0 && to == 1) return true;
        if (from == 1 && to == 2) return true; 
        if (from == 2 && to == 3) return true; 
        if (to == 4 && from < 2) return true;  
        return false;
    }
}