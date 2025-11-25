package com.example.projectend.controller;

import com.example.projectend.entity.SanPham;
import com.example.projectend.entity.SanPhamChiTiet;
import com.example.projectend.entity.DanhGia;
import com.example.projectend.entity.ThuongHieu;
import com.example.projectend.service.LoaiSanPhamService;
import com.example.projectend.service.SanPhamService;
import com.example.projectend.service.DanhGiaService;
import com.example.projectend.repository.SanPhamChiTietRepository;
import com.example.projectend.repository.ThuongHieuRepository;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Controller xử lý hiển thị sản phẩm phía khách hàng
 */
@Controller
public class SanPhamController extends BaseController {

    @Autowired
    private SanPhamService sanPhamService;

    @Autowired
    private LoaiSanPhamService loaiSanPhamService;

    @Autowired
    private SanPhamChiTietRepository sanPhamChiTietRepository;

    @Autowired
    private DanhGiaService danhGiaService;

    @Autowired
    private ThuongHieuRepository thuongHieuRepository;

    /**
     * Hiển thị danh sách sản phẩm với bộ lọc và phân trang
     */
    @GetMapping("/sanpham")
    public String sanPham(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "12") int size,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) Integer loai,
            @RequestParam(required = false) Integer gioiTinh,
            @RequestParam(required = false) Long thuongHieu,
            @RequestParam(required = false) String category, // legacy alias for gioiTinh (nam/nu/unisex)
            @RequestParam(required = false) Long brand,      // legacy alias for thuongHieu
            @RequestParam(required = false) BigDecimal minPrice,
            @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(defaultValue = "moi") String sort,
            Model model) {
        // Map legacy 'category' to gioiTinh if provided and gioiTinh is null
        if (gioiTinh == null && category != null) {
            switch (category.trim().toLowerCase()) {
                case "nam" -> gioiTinh = 0;
                case "nu" -> gioiTinh = 1;
                case "unisex" -> gioiTinh = 2;
            }
        }
        // Map legacy 'brand' to thuongHieu if thuongHieu null
        if (thuongHieu == null && brand != null) {
            thuongHieu = brand;
        }
        model.addAttribute("currentPage", "sanpham");
        model.addAttribute("filterAction", "/sanpham");
        PageRequest pageable = PageRequest.of(page, size);
        Page<SanPham> sanPhamPage = sanPhamService.findWithFilters(search, loai, gioiTinh, thuongHieu, minPrice, maxPrice, sort, pageable);
        model.addAttribute("sanPhamPage", sanPhamPage);
        model.addAttribute("priceStockMap", sanPhamService.buildPriceStockMap(sanPhamPage.getContent()));
        model.addAttribute("categories", loaiSanPhamService.findAll());
        model.addAttribute("brands", thuongHieuRepository.findAll());
        model.addAttribute("search", search);
        model.addAttribute("loai", loai);
        model.addAttribute("gioiTinh", gioiTinh);
        model.addAttribute("thuongHieu", thuongHieu);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("sort", sort);

        // Breadcrumb
        Map<String, String> breadcrumbItem = new HashMap<>();
        breadcrumbItem.put("name", "Sản phẩm");
        breadcrumbItem.put("url", null);
        model.addAttribute("breadcrumbItems", List.of(breadcrumbItem));

        model.addAttribute("pageTitle", "Sản phẩm - LUXE FASHION");
        return "Product";
    }

    /**
     * Hiển thị chi tiết sản phẩm
     */
    @GetMapping("/sanpham/{id}")
    public String chiTietSanPham(@PathVariable Long id, Model model) {

        // Lấy thông tin sản phẩm
        Optional<SanPham> sanPhamOpt = sanPhamService.findById(id);
        if (sanPhamOpt.isEmpty()) {
            return "redirect:/sanpham?error=notfound";
        }

        SanPham sanPham = sanPhamOpt.get();
        model.addAttribute("sanPham", sanPham);

        // Lấy danh sách biến thể sản phẩm (Size, Màu, Giá, Tồn kho)
        List<SanPhamChiTiet> variants = sanPhamChiTietRepository.findBySanPham_MaSP(id);
        model.addAttribute("variants", variants);

        // Lấy giá min/max và tồn kho
        BigDecimal minPrice = sanPhamService.getMinPrice(id);
        BigDecimal maxPrice = sanPhamService.getMaxPrice(id);
        Integer totalStock = sanPhamService.getTotalStock(id);

        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("totalStock", totalStock);

        // Lấy đánh giá của sản phẩm
        List<DanhGia> danhGiaList = danhGiaService.getDanhGiaBySanPham(id);
        model.addAttribute("danhGiaList", danhGiaList);
        model.addAttribute("reviewCount", danhGiaList != null ? danhGiaList.size() : 0);

        // Lấy sản phẩm liên quan cùng danh mục
        if (sanPham.getLoaiSanPham() != null) {
            List<SanPham> relatedProducts = sanPhamService.findRelatedProducts(
                    sanPham.getLoaiSanPham().getMaLoai(),
                    sanPham.getMaSP(),
                    6
            );
            model.addAttribute("relatedProducts", relatedProducts);
        }

        // Breadcrumb
        Map<String, String> breadcrumb1 = new HashMap<>();
        breadcrumb1.put("name", "Sản phẩm");
        breadcrumb1.put("url", "/sanpham");
        Map<String, String> breadcrumb2 = new HashMap<>();
        breadcrumb2.put("name", sanPham.getTenSP());
        breadcrumb2.put("url", null);
        model.addAttribute("breadcrumbItems", List.of(breadcrumb1, breadcrumb2));

        // Change currentPage so we can differentiate in layout template
        model.addAttribute("currentPage", "sanpham-detail");
        model.addAttribute("pageTitle", sanPham.getTenSP() + " - LUXE FASHION");
        return "ProductDetail";
    }

    /**
     * API tìm kiếm nhanh sản phẩm (AJAX autocomplete)
     */
    @GetMapping("/api/sanpham/search")
    @org.springframework.web.bind.annotation.ResponseBody
    public List<SanPham> quickSearch(@RequestParam String q) {
        return sanPhamService.searchByKeyword(q, 10);
    }

    /**
     * API lấy variants của sản phẩm (cho quick add to cart)
     */
    @GetMapping("/api/sanpham/{id}/variants")
    @ResponseBody
    public List<SanPhamChiTiet> getProductVariants(@PathVariable Long id) {
        return sanPhamChiTietRepository.findBySanPham_MaSP(id);
    }

    /**
     * API lấy variant đầu tiên còn hàng của sản phẩm
     */
    @GetMapping("/api/sanpham/{id}/available-variant")
    @ResponseBody
    public ResponseEntity<Map<String,Object>> getFirstAvailableVariant(@PathVariable Long id) {
        Optional<SanPham> spOpt = sanPhamService.findById(id);
        if (spOpt.isEmpty()) {
            return ResponseEntity.ok(Map.of("success", false, "message", "Sản phẩm không tồn tại"));
        }
        Optional<SanPhamChiTiet> variantOpt = sanPhamChiTietRepository.findTop1BySanPham_MaSPAndSoLuongTonGreaterThanOrderBySoLuongTonDesc(id, 0);
        if (variantOpt.isEmpty()) {
            return ResponseEntity.ok(Map.of("success", false, "message", "Sản phẩm tạm hết hàng"));
        }
        SanPhamChiTiet v = variantOpt.get();
        Map<String,Object> data = Map.of(
                "success", true,
                "variant", Map.of(
                        "maBienThe", v.getMaBienThe(),
                        "size", v.getSizeSP()!=null? v.getSizeSP().getTenSize():null,
                        "mau", v.getMauSacSP()!=null? v.getMauSacSP().getTenMau():null,
                        "giaBan", v.getGiaBan(),
                        "soLuongTon", v.getSoLuongTon()
                )
        );
        return ResponseEntity.ok(data);
    }

    /**
     * Hiển thị sản phẩm theo thương hiệu
     */
    @GetMapping("/brand/{id}")
    public String sanPhamTheoThuongHieu(@PathVariable("id") Long maTH,
                                        @RequestParam(defaultValue = "0") int page,
                                        @RequestParam(defaultValue = "12") int size,
                                        @RequestParam(required = false) String search,
                                        @RequestParam(required = false) Integer loai,
                                        @RequestParam(required = false) Integer gioiTinh,
                                        @RequestParam(required = false) BigDecimal minPrice,
                                        @RequestParam(required = false) BigDecimal maxPrice,
                                        @RequestParam(defaultValue = "moi") String sort,
                                        Model model) {
        PageRequest pageable = PageRequest.of(page, size);
        Page<SanPham> sanPhamPage = sanPhamService.findWithFilters(search, loai, gioiTinh, maTH, minPrice, maxPrice, sort, pageable);
        model.addAttribute("sanPhamPage", sanPhamPage);
        model.addAttribute("priceStockMap", sanPhamService.buildPriceStockMap(sanPhamPage.getContent()));
        model.addAttribute("categories", loaiSanPhamService.findAll());
        model.addAttribute("brands", thuongHieuRepository.findAll());
        model.addAttribute("search", search);
        model.addAttribute("loai", loai);
        model.addAttribute("gioiTinh", gioiTinh);
        model.addAttribute("thuongHieu", maTH);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("sort", sort);
        model.addAttribute("currentPage", "sanpham");
        model.addAttribute("filterAction", "/brand/" + maTH);
        ThuongHieu th = thuongHieuRepository.findById(maTH).orElse(null);
        model.addAttribute("pageTitle", (th != null ? th.getTenTH() : "Thương hiệu") + " - LUXE FASHION");
        return "Product";
    }

    /**
     * Hiển thị sản phẩm theo giới tính
     */
    @GetMapping({"/nam", "/nu", "/unisex"})
    public String sanPhamTheoGioiTinh(HttpServletRequest request,
                                      @RequestParam(defaultValue = "0") int page,
                                      @RequestParam(defaultValue = "12") int size,
                                      @RequestParam(required = false) String search,
                                      @RequestParam(required = false) Integer loai,
                                      @RequestParam(required = false) Long thuongHieu,
                                      @RequestParam(required = false) BigDecimal minPrice,
                                      @RequestParam(required = false) BigDecimal maxPrice,
                                      @RequestParam(defaultValue = "moi") String sort,
                                      Model model) {
        String uri = request.getRequestURI();
        Integer gioiTinh = null;
        String titlePrefix = "Sản phẩm";
        if (uri.startsWith("/nam")) { gioiTinh = 0; titlePrefix = "Thời trang Nam"; }
        else if (uri.startsWith("/nu")) { gioiTinh = 1; titlePrefix = "Thời trang Nữ"; }
        else if (uri.startsWith("/unisex")) { gioiTinh = 2; titlePrefix = "Thời trang Unisex"; }
        PageRequest pageable = PageRequest.of(page, size);
        Page<SanPham> sanPhamPage = sanPhamService.findWithFilters(search, loai, gioiTinh, thuongHieu, minPrice, maxPrice, sort, pageable);
        model.addAttribute("sanPhamPage", sanPhamPage);
        model.addAttribute("priceStockMap", sanPhamService.buildPriceStockMap(sanPhamPage.getContent()));
        model.addAttribute("categories", loaiSanPhamService.findAll());
        model.addAttribute("brands", thuongHieuRepository.findAll());
        model.addAttribute("search", search);
        model.addAttribute("loai", loai);
        model.addAttribute("gioiTinh", gioiTinh);
        model.addAttribute("thuongHieu", thuongHieu);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("sort", sort);
        model.addAttribute("currentPage", "sanpham");
        model.addAttribute("filterAction", request.getRequestURI());
        model.addAttribute("pageTitle", titlePrefix + " - LUXE FASHION");
        return "Product";
    }
}
