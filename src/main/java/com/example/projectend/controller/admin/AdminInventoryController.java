package com.example.projectend.controller.admin;

import com.example.projectend.entity.*;
import com.example.projectend.repository.*;
import com.example.projectend.service.PhieuNhapService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Controller quản lý kho & nhà cung cấp
 */
@Controller
@RequestMapping("/admin/inventory")
@PreAuthorize("hasRole('ADMIN') or hasRole('NHANVIEN')")
public class AdminInventoryController {

    private static final Logger log = LoggerFactory.getLogger(AdminInventoryController.class);

    @Autowired
    private PhieuNhapRepository phieuNhapRepository;

    @Autowired
    private NhapKhoRepository nhapKhoRepository;

    @Autowired
    private NhaCungCapRepository nhaCungCapRepository;

    @Autowired
    private SanPhamRepository sanPhamRepository;

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @Autowired
    private PhieuNhapService phieuNhapService;

    @Autowired
    private LoaiSanPhamRepository loaiSanPhamRepository;

    @Autowired
    private ThuongHieuRepository thuongHieuRepository;

    /**
     * Trang chính quản lý kho
     */
    @GetMapping
    public String inventoryPage(Model model, @AuthenticationPrincipal UserDetails userDetails) {
        // Lấy danh sách phiếu nhập (sắp xếp mới nhất trước)
        List<PhieuNhap> phieuNhaps = phieuNhapRepository.findAll();
        phieuNhaps.sort((a, b) -> b.getNgayNhap().compareTo(a.getNgayNhap()));

        // Thống kê
        long totalItems = nhapKhoRepository.count();
        long supplierCount = nhaCungCapRepository.count();
        long activeProducts = sanPhamRepository.countByTrangThaiSP(1);

        model.addAttribute("phieuNhaps", phieuNhaps);
        model.addAttribute("totalItems", totalItems);
        model.addAttribute("supplierCount", supplierCount);
        model.addAttribute("lowStockCount", activeProducts);
        model.addAttribute("suppliers", nhaCungCapRepository.findAll());
        model.addAttribute("products", sanPhamRepository.findByTrangThaiSP(1));
        model.addAttribute("nhapKhos", nhapKhoRepository.findAll());
        model.addAttribute("categories", loaiSanPhamRepository.findAll());
        model.addAttribute("brands", thuongHieuRepository.findAll());
        model.addAttribute("currentPage", "inventory");
        model.addAttribute("displayPhieuNhapCode", phieuNhapService.generateDisplayCode());
        if (userDetails != null) {
            model.addAttribute("currentUserName", userDetails.getUsername());
        }
        return "admin/inventory";
    }

    /**
     * API endpoint để lấy chi tiết phiếu nhập (cho popup)
     */
    @GetMapping("/api/phieu-nhap/{id}")
    @ResponseBody
    public PhieuNhap getPhieuNhapDetails(@PathVariable Long id) {
        return phieuNhapRepository.findById(id).orElse(null);
    }

    /**
     * API endpoint để lấy mã phiếu nhập tiếp theo
     */
    @GetMapping("/api/next-phieu-code")
    @ResponseBody
    public java.util.Map<String, Object> getNextPhieuCode() {
        List<PhieuNhap> all = phieuNhapRepository.findAll();
        Long nextCode = all.isEmpty() ? 1 : all.stream().mapToLong(PhieuNhap::getMaPN).max().orElse(0) + 1;
        return java.util.Map.of("nextCode", nextCode);
    }

    /**
     * API endpoint để lấy thông tin người dùng hiện tại
     */
    @GetMapping("/api/current-user")
    @ResponseBody
    public java.util.Map<String, Object> getCurrentUser(@AuthenticationPrincipal UserDetails userDetails) {
        TaiKhoan user = taiKhoanRepository.findByEmail(userDetails.getUsername()).orElse(null);
        if (user != null) {
            return java.util.Map.of(
                "hoTen", user.getHoTen(),
                "email", user.getEmail()
            );
        }
        return java.util.Map.of("hoTen", "Unknown", "email", userDetails.getUsername());
    }

    /**
     * Lưu/cập nhật nhà cung cấp (cho cả form chính và quick add)
     */
    @PostMapping("/supplier/save")
    public String saveSupplier(
            @RequestParam(required = false) Long maNCC,
            @RequestParam String tenNCC,
            @RequestParam(required = false) String soDienThoai,
            @RequestParam(required = false) String diaChi,
            RedirectAttributes redirectAttributes) {
        try {
            NhaCungCap ncc;
            if (maNCC != null) {
                // Update existing
                ncc = nhaCungCapRepository.findById(maNCC).orElse(new NhaCungCap());
            } else {
                // Create new
                ncc = new NhaCungCap();
            }

            ncc.setTenNCC(tenNCC);
            ncc.setSoDienThoai(soDienThoai);
            ncc.setDiaChi(diaChi);

            nhaCungCapRepository.save(ncc);
            redirectAttributes.addFlashAttribute("success", "Lưu nhà cung cấp thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi khi lưu nhà cung cấp: " + e.getMessage());
        }
        return "redirect:/admin/inventory";
    }

    /**
     * Xóa nhà cung cấp
     */
    @GetMapping("/supplier/delete/{id}")
    public String deleteSupplier(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            nhaCungCapRepository.deleteById(id);
            redirectAttributes.addFlashAttribute("success", "Xóa nhà cung cấp thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa nhà cung cấp này.");
        }
        return "redirect:/admin/inventory";
    }

    /**
     * Lưu phiếu nhập kho với chi tiết sản phẩm (hỗ trợ cả sản phẩm có sẵn và sản phẩm mới)
     */
    @PostMapping("/phieu-nhap/save")
    public String savePhieuNhap(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam Long maNCC,
            @RequestParam(required = false) String ghiChu,
            @RequestParam(required = false) List<String> productTypes,
            @RequestParam(required = false) List<Long> maBienThe,
            @RequestParam(required = false) List<Integer> soLuongs,
            @RequestParam(required = false) List<BigDecimal> donGiaNhaps,
            @RequestParam(required = false) List<String> newProductNames,
            @RequestParam(required = false) List<String> newProductSizes,
            @RequestParam(required = false) List<String> newProductColors,
            @RequestParam(required = false) List<Integer> newProductQtys,
            @RequestParam(required = false) List<BigDecimal> newProductPriceImports,
            @RequestParam(required = false) List<BigDecimal> newProductPriceSells,
            @RequestParam(required = false) List<Long> newProductCategoryIds,
            @RequestParam(required = false) List<Long> newProductBrandIds,
            @RequestParam(required = false) List<Integer> newProductGenders,
            @RequestParam(required = false) BigDecimal tongTien,
            RedirectAttributes redirectAttributes) {
        try {
            if (productTypes == null || productTypes.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng thêm ít nhất một sản phẩm!");
                return "redirect:/admin/inventory";
            }
            TaiKhoan nhanVien = taiKhoanRepository.findByEmail(userDetails.getUsername())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản"));
            NhaCungCap nhaCungCap = nhaCungCapRepository.findById(maNCC)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà cung cấp"));

            List<PhieuNhapService.ExistingItem> existingItems = new ArrayList<>();
            List<PhieuNhapService.NewItem> newItems = new ArrayList<>();
            int existingIndex = 0; int newIndex = 0;
            for (String type : productTypes) {
                if ("existing".equals(type)) {
                    if (maBienThe == null || soLuongs == null || donGiaNhaps == null || existingIndex >= maBienThe.size() || existingIndex >= soLuongs.size() || existingIndex >= donGiaNhaps.size()) {
                        throw new IllegalArgumentException("Dữ liệu sản phẩm có sẵn không hợp lệ (thiếu hoặc sai chỉ số)");
                    }
                    Long id = maBienThe.get(existingIndex);
                    Integer qty = soLuongs.get(existingIndex);
                    BigDecimal priceImport = donGiaNhaps.get(existingIndex);
                    if (qty == null || qty <= 0 || priceImport == null || priceImport.compareTo(BigDecimal.ZERO) <= 0) {
                        throw new IllegalArgumentException("Số lượng hoặc đơn giá nhập sản phẩm có sẵn không hợp lệ");
                    }
                    existingItems.add(new PhieuNhapService.ExistingItem(id, qty, priceImport));
                    existingIndex++;
                } else if ("new".equals(type)) {
                    if (newProductNames == null || newProductSizes == null || newProductColors == null || newProductQtys == null || newProductPriceImports == null || newProductPriceSells == null || newProductCategoryIds == null || newProductBrandIds == null || newProductGenders == null || newIndex >= newProductNames.size() || newIndex >= newProductSizes.size() || newIndex >= newProductColors.size() || newIndex >= newProductQtys.size() || newIndex >= newProductPriceImports.size() || newIndex >= newProductPriceSells.size() || newIndex >= newProductCategoryIds.size() || newIndex >= newProductBrandIds.size() || newIndex >= newProductGenders.size()) {
                        throw new IllegalArgumentException("Dữ liệu sản phẩm mới không hợp lệ (thiếu hoặc sai chỉ số)");
                    }
                    String tenSP = newProductNames.get(newIndex);
                    String size = newProductSizes.get(newIndex);
                    String color = newProductColors.get(newIndex);
                    Integer qty = newProductQtys.get(newIndex);
                    BigDecimal giaNhap = newProductPriceImports.get(newIndex);
                    BigDecimal giaBan = newProductPriceSells.get(newIndex);
                    Long categoryId = newProductCategoryIds.get(newIndex);
                    Long brandId = newProductBrandIds.get(newIndex);
                    Integer gender = newProductGenders.get(newIndex);
                    if (qty == null || qty <= 0 || giaNhap == null || giaNhap.compareTo(BigDecimal.ZERO) <= 0 || giaBan == null || giaBan.compareTo(BigDecimal.ZERO) <= 0) {
                        throw new IllegalArgumentException("Số lượng / giá nhập / giá bán sản phẩm mới không hợp lệ");
                    }
                    newItems.add(new PhieuNhapService.NewItem(tenSP, size, color, qty, giaNhap, giaBan, categoryId, brandId, gender));
                    newIndex++;
                } else {
                    throw new IllegalArgumentException("Loại sản phẩm không hợp lệ: " + type);
                }
            }
            PhieuNhap phieuNhap = phieuNhapService.createPhieuNhap(nhanVien, nhaCungCap, existingItems, newItems, ghiChu);
            if (tongTien != null && tongTien.compareTo(phieuNhap.getTongTien()) != 0) {
                log.warn("Tổng tiền client gửi ({}) khác tổng tiền server tính ({})", tongTien, phieuNhap.getTongTien());
            }
            redirectAttributes.addFlashAttribute("success", "Tạo phiếu nhập thành công! Mã: PN" + phieuNhap.getMaPN());
        } catch (Exception e) {
            log.error("Lỗi tạo phiếu nhập", e);
            redirectAttributes.addFlashAttribute("error", "Lỗi tạo phiếu nhập: " + e.getMessage());
        }
        return "redirect:/admin/inventory";
    }
}
