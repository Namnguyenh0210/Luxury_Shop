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

    /**
     * ⚡ API TỐI ƯU: Preview danh sách sản phẩm trước khi submit (xử lý ở backend)
     * Frontend chỉ cần gửi dữ liệu đơn giản, backend trả về HTML đã render sẵn
     */
    @PostMapping("/api/preview-products")
    @ResponseBody
    public java.util.Map<String, Object> previewProducts(
            @RequestBody java.util.Map<String, Object> requestData) {
        try {
            @SuppressWarnings("unchecked")
            List<java.util.Map<String, Object>> products = (List<java.util.Map<String, Object>>) requestData.get("products");

            if (products == null || products.isEmpty()) {
                return java.util.Map.of("success", false, "message", "Chưa có sản phẩm nào");
            }

            StringBuilder htmlBuilder = new StringBuilder();
            BigDecimal totalAmount = BigDecimal.ZERO;
            int index = 1;

            for (java.util.Map<String, Object> product : products) {
                String type = (String) product.get("type");
                String tenSP = (String) product.get("tenSP");
                String size = (String) product.get("size");
                String color = (String) product.get("color");
                int soLuong = ((Number) product.get("soLuong")).intValue();
                BigDecimal donGia = new BigDecimal(product.get("donGiaNhap").toString());
                BigDecimal thanhTien = donGia.multiply(new BigDecimal(soLuong));
                totalAmount = totalAmount.add(thanhTien);

                String badgeHtml = "new".equals(type) ?
                    "<span class='text-xs text-green-600 font-medium'>● Sản phẩm mới</span>" : "";

                htmlBuilder.append(String.format(
                    "<tr class='hover:bg-slate-50 dark:hover:bg-slate-700/30' data-index='%d'>" +
                    "<td class='px-4 py-3 text-center'>%d</td>" +
                    "<td class='px-4 py-3'>" +
                    "  <div class='font-medium text-slate-900 dark:text-white'>%s</div>" +
                    "  %s" +
                    "</td>" +
                    "<td class='px-4 py-3'><span class='px-2 py-1 bg-blue-100 text-blue-700 rounded text-xs font-medium'>%s</span></td>" +
                    "<td class='px-4 py-3'><span class='px-2 py-1 bg-purple-100 text-purple-700 rounded text-xs font-medium'>%s</span></td>" +
                    "<td class='px-4 py-3 text-center'>" +
                    "  <input type='number' min='1' value='%d' onchange='updateProductQuantity(%d, this.value)' " +
                    "    class='w-20 rounded border-slate-300 dark:bg-slate-900 text-sm py-1 px-2 text-center'>" +
                    "</td>" +
                    "<td class='px-4 py-3 text-right'>" +
                    "  <input type='number' min='0' step='1000' value='%s' onchange='updateProductPrice(%d, this.value)' " +
                    "    class='w-32 rounded border-slate-300 dark:bg-slate-900 text-sm py-1 px-2 text-right'>" +
                    "</td>" +
                    "<td class='px-4 py-3 text-right font-bold text-green-600'>%,d₫</td>" +
                    "<td class='px-4 py-3 text-center'>" +
                    "  <div class='flex justify-center gap-1'>" +
                    "    <button type='button' onclick='duplicateProduct(%d)' " +
                    "      class='text-blue-600 hover:bg-blue-50 p-1 rounded' title='Sao chép'>" +
                    "      <span class='material-symbols-outlined text-[18px]'>content_copy</span>" +
                    "    </button>" +
                    "    <button type='button' onclick='removeProduct(%d)' " +
                    "      class='text-red-600 hover:bg-red-50 p-1 rounded' title='Xóa'>" +
                    "      <span class='material-symbols-outlined text-[18px]'>delete</span>" +
                    "    </button>" +
                    "  </div>" +
                    "</td>" +
                    "</tr>",
                    index - 1, index, tenSP, badgeHtml, size, color,
                    soLuong, index - 1,
                    donGia.toString(), index - 1,
                    thanhTien.longValue(),
                    index - 1, index - 1
                ));
                index++;
            }

            return java.util.Map.of(
                "success", true,
                "html", htmlBuilder.toString(),
                "totalAmount", totalAmount.toString(),
                "productCount", products.size()
            );
        } catch (Exception e) {
            log.error("Error previewing products", e);
            return java.util.Map.of("success", false, "message", e.getMessage());
        }
    }

    /**
     * ⚡ API TỐI ƯU: Validate và tính toán ngay khi thêm sản phẩm (giảm lag frontend)
     */
    @PostMapping("/api/validate-product")
    @ResponseBody
    public java.util.Map<String, Object> validateProduct(@RequestBody java.util.Map<String, Object> productData) {
        try {
            String type = (String) productData.get("type");

            if ("existing".equals(type)) {
                Long maBienThe = Long.valueOf(productData.get("maBienThe").toString());
                // Validate sản phẩm tồn tại
                // TODO: Add validation logic
                return java.util.Map.of("valid", true, "message", "Sản phẩm hợp lệ");
            } else if ("new".equals(type)) {
                String tenSP = (String) productData.get("tenSP");
                if (tenSP == null || tenSP.trim().isEmpty()) {
                    return java.util.Map.of("valid", false, "message", "Tên sản phẩm không được để trống");
                }
                return java.util.Map.of("valid", true, "message", "Sản phẩm mới hợp lệ");
            }

            return java.util.Map.of("valid", false, "message", "Loại sản phẩm không hợp lệ");
        } catch (Exception e) {
            return java.util.Map.of("valid", false, "message", e.getMessage());
        }
    }

    /**
     * ⚡ API TỐI ƯU: Lấy variants của sản phẩm và trả về HTML dropdown sẵn
     * Frontend chỉ cần set innerHTML, không cần xử lý logic
     */
    @GetMapping("/api/product-variants-html/{maSP}")
    @ResponseBody
    public java.util.Map<String, Object> getProductVariantsAsHtml(@PathVariable Long maSP) {
        try {
            List<SanPhamChiTiet> variants = sanPhamRepository.findById(maSP)
                .map(SanPham::getVariants)
                .orElse(new ArrayList<>());

            if (variants.isEmpty()) {
                return java.util.Map.of(
                    "success", false,
                    "message", "Sản phẩm không có biến thể nào"
                );
            }

            // Build HTML cho size dropdown
            StringBuilder sizeHtml = new StringBuilder("<option value=''>-- Chọn size --</option>");
            java.util.Set<String> addedSizes = new java.util.HashSet<>();

            for (SanPhamChiTiet variant : variants) {
                if (variant.getSizeSP() != null && variant.getSizeSP().getMaSize() != null) {
                    String sizeKey = variant.getSizeSP().getMaSize().toString();
                    if (!addedSizes.contains(sizeKey)) {
                        sizeHtml.append(String.format("<option value='%d'>%s</option>",
                            variant.getSizeSP().getMaSize(),
                            variant.getSizeSP().getTenSize()));
                        addedSizes.add(sizeKey);
                    }
                }
            }

            // Build HTML cho color dropdown
            StringBuilder colorHtml = new StringBuilder("<option value=''>-- Chọn màu --</option>");
            java.util.Set<String> addedColors = new java.util.HashSet<>();

            for (SanPhamChiTiet variant : variants) {
                if (variant.getMauSacSP() != null && variant.getMauSacSP().getMaMau() != null) {
                    String colorKey = variant.getMauSacSP().getMaMau().toString();
                    if (!addedColors.contains(colorKey)) {
                        colorHtml.append(String.format("<option value='%d'>%s</option>",
                            variant.getMauSacSP().getMaMau(),
                            variant.getMauSacSP().getTenMau()));
                        addedColors.add(colorKey);
                    }
                }
            }

            // Trả về JSON với variants gốc để validate
            return java.util.Map.of(
                "success", true,
                "sizeHtml", sizeHtml.toString(),
                "colorHtml", colorHtml.toString(),
                "variants", variants
            );
        } catch (Exception e) {
            log.error("Error loading variants for product: " + maSP, e);
            return java.util.Map.of(
                "success", false,
                "message", "Lỗi tải dữ liệu: " + e.getMessage()
            );
        }
    }

    /**
     * ⚡ API TỐI ƯU: Tìm biến thể cụ thể theo size + màu
     * Frontend chỉ cần gửi size+color ID, backend trả về biến thể đã validate
     */
    @GetMapping("/api/find-variant")
    @ResponseBody
    public java.util.Map<String, Object> findVariant(
            @RequestParam Long maSP,
            @RequestParam Long sizeId,
            @RequestParam Long colorId) {
        try {
            List<SanPhamChiTiet> variants = sanPhamRepository.findById(maSP)
                .map(SanPham::getVariants)
                .orElse(new ArrayList<>());

            SanPhamChiTiet found = variants.stream()
                .filter(v -> v.getSizeSP() != null && v.getMauSacSP() != null)
                .filter(v -> v.getSizeSP().getMaSize().equals(sizeId))
                .filter(v -> v.getMauSacSP().getMaMau().equals(colorId))
                .findFirst()
                .orElse(null);

            if (found == null) {
                return java.util.Map.of(
                    "success", false,
                    "message", "Không tìm thấy biến thể phù hợp"
                );
            }

            return java.util.Map.of(
                "success", true,
                "maBienThe", found.getMaBienThe(),
                "tenSP", found.getSanPham().getTenSP(),
                "size", found.getSizeSP().getTenSize(),
                "color", found.getMauSacSP().getTenMau(),
                "soLuongTon", found.getSoLuongTon()
            );
        } catch (Exception e) {
            log.error("Error finding variant", e);
            return java.util.Map.of(
                "success", false,
                "message", "Lỗi: " + e.getMessage()
            );
        }
    }
}
