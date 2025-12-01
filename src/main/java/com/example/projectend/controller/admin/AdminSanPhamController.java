package com.example.projectend.controller.admin;

import com.example.projectend.entity.LoaiSanPham;
import com.example.projectend.entity.SanPham;
import com.example.projectend.service.LoaiSanPhamService;
import com.example.projectend.service.SanPhamService;
import com.example.projectend.service.ThuongHieuService;
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
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/products")
public class AdminSanPhamController {

    private final String UPLOAD_DIR = "src/main/resources/static/images/products/";

    @Autowired
    private SanPhamService sanPhamService;

    @Autowired
    private LoaiSanPhamService loaiSanPhamService;

    @Autowired
    private ThuongHieuService thuongHieuService;

    @GetMapping
    public String listProducts(
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Long brandId,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String keyword,
            Model model) {

        // Get all products first
        List<SanPham> products = sanPhamService.findAll();

        // Apply filters
        if (categoryId != null) {
            products = products.stream()
                    .filter(p -> p.getLoaiSanPham() != null && p.getLoaiSanPham().getMaLoai().equals(categoryId))
                    .collect(Collectors.toList());
        }

        if (brandId != null) {
            products = products.stream()
                    .filter(p -> p.getThuongHieu() != null && p.getThuongHieu().getMaTH().equals(brandId))
                    .collect(Collectors.toList());
        }

        if (status != null) {
            products = products.stream()
                    .filter(p -> p.getTrangThaiSP() != null && p.getTrangThaiSP().equals(status))
                    .collect(Collectors.toList());
        }

        if (keyword != null && !keyword.isEmpty()) {
            String lowerKeyword = keyword.toLowerCase();
            products = products.stream()
                    .filter(p -> p.getTenSP().toLowerCase().contains(lowerKeyword))
                    .collect(Collectors.toList());
        }

        model.addAttribute("products", products);
        model.addAttribute("categories", loaiSanPhamService.findAll());
        model.addAttribute("brands", thuongHieuService.findAll());
        model.addAttribute("product", new SanPham());
        model.addAttribute("currentPage", "products");

        // Keep filter values
        model.addAttribute("selectedCategoryId", categoryId);
        model.addAttribute("selectedBrandId", brandId);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("keyword", keyword);

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

    /**
     * API endpoint to get product details with variants (for AJAX)
     */
    @GetMapping("/api/details/{id}")
    @ResponseBody
    public SanPham getProductDetails(@PathVariable Long id) {
        return sanPhamService.findById(id).orElse(null);
    }

    /**
     * API endpoint to get product variants (for inventory nhap kho)
     */
    @GetMapping("/api/variants/{maSP}")
    @ResponseBody
    public List<com.example.projectend.entity.SanPhamChiTiet> getProductVariants(@PathVariable Long maSP) {
        return sanPhamService.findById(maSP)
                .map(com.example.projectend.entity.SanPham::getVariants)
                .orElse(java.util.Collections.emptyList());
    }
}