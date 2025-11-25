package com.example.projectend.controller.admin;

import com.example.projectend.entity.BaiViet;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.service.BaiVietService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;

/**
 * ADMIN BAI VIET CONTROLLER - Quản lý bài viết
 */
@Controller
@RequestMapping("/admin/baiviet")
@PreAuthorize("hasAnyRole('Admin', 'Nhân viên')")
public class AdminBaiVietController {

    @Autowired
    private BaiVietService baiVietService;

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    /**
     * Danh sách bài viết với tìm kiếm và phân trang
     */
    @GetMapping
    public String danhSachBaiViet(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) Boolean trangThai,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {

        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "ngayDang"));
        Page<BaiViet> baiVietPage;

        // Tìm kiếm và lọc
        if (search != null && !search.trim().isEmpty()) {
            baiVietPage = baiVietService.searchByTitle(search, pageable); // admin không lọc trạng thái
        } else if (trangThai != null) {
            // lọc theo trạng thái hiển thị nếu truyền vào
            baiVietPage = trangThai ? baiVietService.getAllBaiViet(pageable) : baiVietService.getAllBaiVietAdmin(pageable);
        } else {
            baiVietPage = baiVietService.getAllBaiVietAdmin(pageable);
        }

        model.addAttribute("baiVietPage", baiVietPage);
        model.addAttribute("search", search);
        model.addAttribute("trangThai", trangThai);
        return "admin/posts";
    }

    /**
     * Lưu bài viết (tạo mới hoặc cập nhật)
     */
    @PostMapping("/save")
    public String saveBaiViet(
            @ModelAttribute BaiViet baiViet,
            @AuthenticationPrincipal UserDetails userDetails,
            RedirectAttributes redirectAttributes) {

        try {
            // Lấy tài khoản hiện tại
            String email = userDetails.getUsername();
            TaiKhoan taiKhoan = taiKhoanRepository.findByEmail(email)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản"));

            // Nếu tạo mới, set tài khoản và ngày đăng
            if (baiViet.getMaBV() == null) {
                baiViet.setTaiKhoan(taiKhoan);
                baiViet.setNgayDang(LocalDateTime.now());
                if (baiViet.getTrangThai() == null) baiViet.setTrangThai(true);
            } else {
                // Nếu cập nhật, giữ nguyên tác giả cũ
                BaiViet existing = baiVietService.findById(baiViet.getMaBV())
                        .orElseThrow(() -> new RuntimeException("Không tìm thấy bài viết"));
                baiViet.setTaiKhoan(existing.getTaiKhoan());
                baiViet.setNgayDang(existing.getNgayDang());
                if (baiViet.getTrangThai() == null) baiViet.setTrangThai(existing.getTrangThai());
            }

            baiVietService.save(baiViet);
            redirectAttributes.addFlashAttribute("success",
                    (baiViet.getMaBV() == null ? "Đã tạo bài viết mới thành công!" : "Đã cập nhật bài viết thành công!"));
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }

        return "redirect:/admin/baiviet";
    }

    /**
     * Bật/tắt hiển thị bài viết
     */
    @PostMapping("/{id}/toggle")
    public String toggleStatus(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            baiVietService.toggleStatus(id);
            redirectAttributes.addFlashAttribute("success", "Đã thay đổi trạng thái bài viết!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        return "redirect:/admin/baiviet";
    }

    /**
     * Xóa bài viết
     */
    @PostMapping("/{id}/delete")
    public String deleteBaiViet(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            baiVietService.deleteById(id);
            redirectAttributes.addFlashAttribute("success", "Đã xóa bài viết thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        return "redirect:/admin/baiviet";
    }
}
