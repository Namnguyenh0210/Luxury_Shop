package com.example.projectend.controller.admin;

import com.example.projectend.entity.LoaiSanPham;
import com.example.projectend.entity.SanPham;
import com.example.projectend.service.LoaiSanPhamService;
import com.example.projectend.service.SanPhamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/admin/products")
public class AdminSanPhamController {

    private final String UPLOAD_DIR = "src/main/resources/static/images/products/";

    @Autowired
    private SanPhamService sanPhamService;

    @Autowired
    private LoaiSanPhamService loaiSanPhamService;

    @GetMapping
    public String listProducts(Model model) {
        model.addAttribute("products", sanPhamService.findAll());
        model.addAttribute("categories", loaiSanPhamService.findAll());
        model.addAttribute("product", new SanPham());
        model.addAttribute("currentPage", "products");
        return "admin/product-list";
    }

    @PostMapping("/save")
    public String saveProduct(@ModelAttribute("product") SanPham product,
                              @RequestParam("imageFile") MultipartFile file,
                              RedirectAttributes redirectAttributes) {
        try {
            // 1. Xử lý ảnh
            if (!file.isEmpty()) {
                String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
                Path uploadPath = Paths.get(UPLOAD_DIR);
                if (!Files.exists(uploadPath)) Files.createDirectories(uploadPath);
                Files.copy(file.getInputStream(), uploadPath.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
                product.setAnhChinh("/images/products/" + fileName);
            } else if (product.getMaSP() != null) {
                // Giữ ảnh cũ
                SanPham oldProduct = sanPhamService.findById(product.getMaSP()).orElse(null);
                if (oldProduct != null) {
                    product.setAnhChinh(oldProduct.getAnhChinh());
                }
            }

            // 2. Xử lý Logic Thêm/Sửa
            if (product.getMaSP() == null) {
                // --- THÊM MỚI ---
                product.setNgayTao(LocalDateTime.now());
                // Mặc định là Còn hàng (1) nếu null
                if (product.getTrangThaiSP() == null) product.setTrangThaiSP(1);
            } else {
                // --- CẬP NHẬT ---
                product.setNgayCapNhat(LocalDateTime.now());
                SanPham oldProduct = sanPhamService.findById(product.getMaSP()).orElse(null);
                
                if (oldProduct != null) {
                    // Giữ ngày tạo
                    product.setNgayTao(oldProduct.getNgayTao());
                    
                    // QUAN TRỌNG: Nếu form gửi lên null, giữ nguyên trạng thái cũ
                    if (product.getTrangThaiSP() == null) {
                        product.setTrangThaiSP(oldProduct.getTrangThaiSP());
                    }
                }
            }

            sanPhamService.save(product);
            redirectAttributes.addFlashAttribute("success", "Lưu thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/products";
    }

    @GetMapping("/delete/{id}")
    public String deleteProduct(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            sanPhamService.deleteById(id);
            redirectAttributes.addFlashAttribute("success", "Xóa thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa sản phẩm này.");
        }
        return "redirect:/admin/products";
    }
}