package com.example.projectend.controller.admin;

import com.example.projectend.entity.*;
import com.example.projectend.repository.*;
import com.example.projectend.service.PhieuNhapService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.*;

@RestController
@RequestMapping("/api/admin/inventory")
@PreAuthorize("hasRole('ADMIN') or hasRole('NHANVIEN')")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class AdminInventoryController {

    @Autowired
    private PhieuNhapRepository phieuNhapRepository;
    @Autowired
    private NhapKhoChiTietRepository nhapKhoChiTietRepository;
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
    private SizeSPRepository sizeSPRepository;
    @Autowired
    private MauSacSPRepository mauSacSPRepository;
    @Autowired
    private SanPhamChiTietRepository sanPhamChiTietRepository;
    @Autowired
    private YeuCauNhapKhoRepository yeuCauNhapKhoRepository;
    @Autowired
    private ThuongHieuRepository thuongHieuRepository;

    // Lấy toàn bộ dữ liệu cho trang Inventory
    @GetMapping
    public Map<String, Object> getInventoryData() {
        List<PhieuNhap> phieuNhaps = phieuNhapRepository.findAll();
        phieuNhaps.sort((a, b) -> b.getNgayNhap().compareTo(a.getNgayNhap()));

        // Lấy nhân viên (tài khoản có role ADMIN hoặc NHANVIEN)
        List<TaiKhoan> allAccounts = taiKhoanRepository.findAll();
        List<Map<String, Object>> nhanVienList = new ArrayList<>();
        for (TaiKhoan tk : allAccounts) {
            boolean isStaff = tk.getVaiTros() != null && tk.getVaiTros().stream()
                    .anyMatch(v -> "ADMIN".equalsIgnoreCase(v.getTenVaiTro()) || "NHANVIEN".equalsIgnoreCase(v.getTenVaiTro()));
            if (isStaff) {
                Map<String, Object> nv = new HashMap<>();
                nv.put("maTK", tk.getMaTK());
                nv.put("hoTen", tk.getHoTen());
                nhanVienList.add(nv);
            }
        }

        // Sản phẩm tồn kho thấp (soLuongTon < 5)
        List<SanPhamChiTiet> allVariants = sanPhamChiTietRepository.findAll();
        List<Map<String, Object>> lowStockList = new ArrayList<>();
        for (SanPhamChiTiet v : allVariants) {
            if (v.getSoLuongTon() != null && v.getSoLuongTon() < 5) {
                Map<String, Object> item = new HashMap<>();
                item.put("maBienThe", v.getMaBienThe());
                item.put("tenSP", v.getSanPham() != null ? v.getSanPham().getTenSP() : "");
                item.put("size", v.getSizeSP() != null ? v.getSizeSP().getTenSize() : "");
                item.put("mau", v.getMauSacSP() != null ? v.getMauSacSP().getTenMau() : "");
                item.put("soLuongTon", v.getSoLuongTon());
                lowStockList.add(item);
            }
        }

        // Danh sách yêu cầu nhập kho (chờ duyệt cho Admin, hoặc lịch sử của staff)
        List<YeuCauNhapKho> requests = yeuCauNhapKhoRepository.findAll();
        requests.sort((a, b) -> b.getNgayYeuCau().compareTo(a.getNgayYeuCau()));

        // Luôn trả về tất cả sản phẩm để có thể nhập hàng cho cả SP đang ẩn
        List<SanPham> allProducts = sanPhamRepository.findAll();
        // Sắp xếp theo tên để dễ tìm kiếm trong dropdown
        allProducts.sort((a, b) -> a.getTenSP().compareToIgnoreCase(b.getTenSP()));
        
        List<Map<String, Object>> noVariantProducts = new ArrayList<>();
        // Eagerly load variants and identify products without any variants
        for (SanPham p : allProducts) {
             if (p.getVariants() == null || p.getVariants().isEmpty()) {
                 Map<String, Object> item = new HashMap<>();
                 item.put("maSP", p.getMaSP());
                 item.put("tenSP", p.getTenSP());
                 item.put("gioiTinh", p.getGioiTinh());
                 item.put("moTa", p.getMoTa());
                 
                 if (p.getLoaiSanPham() != null) {
                     Map<String, Object> lsp = new HashMap<>();
                     lsp.put("maLoai", p.getLoaiSanPham().getMaLoai());
                     lsp.put("tenLoai", p.getLoaiSanPham().getTenLoai());
                     item.put("loaiSanPham", lsp);
                 }
                 
                 if (p.getThuongHieu() != null) {
                     Map<String, Object> th = new HashMap<>();
                     th.put("maTH", p.getThuongHieu().getMaTH());
                     th.put("tenTH", p.getThuongHieu().getTenTH());
                     item.put("thuongHieu", th);
                 }
                 
                 noVariantProducts.add(item);
             }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("phieuNhaps", phieuNhaps);
        result.put("suppliers", nhaCungCapRepository.findAll());
        result.put("products", allProducts);
        result.put("categories", loaiSanPhamRepository.findAll());
        result.put("sizes", sizeSPRepository.findAll());
        result.put("colors", mauSacSPRepository.findAll());
        result.put("nhanViens", nhanVienList);
        result.put("totalItems", nhapKhoChiTietRepository.count());
        result.put("supplierCount", nhaCungCapRepository.count());
        result.put("activeProducts", sanPhamRepository.countByTrangThaiSP(1));
        result.put("lowStock", lowStockList);
        result.put("noVariantProducts", noVariantProducts);
        result.put("stockRequests", requests);
        result.put("brands", thuongHieuRepository.findAll());
        return result;
    }

    // API xử lý Lưu Phiếu Nhập từ Vue gửi lên
    @PostMapping("/import")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> savePhieuNhap(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody Map<String, Object> payload) {
        try {
            String maNCCStr = payload.get("maNCC").toString();
            Long maNCC = Long.parseLong(maNCCStr);
            String ghiChu = (String) payload.get("ghiChu");
            List<Map<String, Object>> items = (List<Map<String, Object>>) payload.get("items");

            if (items == null || items.isEmpty()) {
                return ResponseEntity.badRequest().body("Phải có ít nhất 1 sản phẩm");
            }

            TaiKhoan nhanVien = taiKhoanRepository.findByEmail(userDetails.getUsername())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản"));
            NhaCungCap nhaCungCap = nhaCungCapRepository.findById(maNCC)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà cung cấp"));

            List<PhieuNhapService.ExistingItem> existingItems = new ArrayList<>();
            List<PhieuNhapService.NewItem> newItems = new ArrayList<>();

            for (Map<String, Object> item : items) {
                String itemType = item.get("itemType") != null ? item.get("itemType").toString() : "existing";
                Integer qty = Integer.parseInt(item.get("qty").toString());
                BigDecimal price = new BigDecimal(item.get("price").toString());

                if ("existing".equals(itemType)) {
                    // Sản phẩm đã có (dùng maBienThe)
                    Long maBienThe = Long.parseLong(item.get("maBienThe").toString());
                    BigDecimal giaBan = item.get("giaBan") != null ? new BigDecimal(item.get("giaBan").toString()) : null;
                    existingItems.add(new PhieuNhapService.ExistingItem(maBienThe, qty, price, giaBan));
                } else {
                    // Sản phẩm mới
                    String tenSP = item.get("tenSP") != null ? item.get("tenSP").toString() : "";
                    String size = item.get("size") != null ? item.get("size").toString() : "";
                    String color = item.get("color") != null ? item.get("color").toString() : "";
                    Integer gender = item.get("gender") != null ? Integer.parseInt(item.get("gender").toString()) : 2;
                    Long categoryId = item.get("categoryId") != null ? Long.parseLong(item.get("categoryId").toString()) : null;
                    Long brandId = item.get("brandId") != null ? Long.parseLong(item.get("brandId").toString()) : null;
                    BigDecimal giaBan = item.get("giaBan") != null ? new BigDecimal(item.get("giaBan").toString()) : price;
                    String moTa = item.get("moTa") != null ? item.get("moTa").toString() : "";
                    Long productId = item.get("productId") != null ? Long.parseLong(item.get("productId").toString()) : null;
                    
                    newItems.add(new PhieuNhapService.NewItem(productId, tenSP, size, color, qty, price, giaBan, categoryId, brandId, gender, moTa));
                }
            }

            PhieuNhap saved = phieuNhapService.createPhieuNhap(nhanVien, nhaCungCap, existingItems, newItems, ghiChu);

            // Nếu có mã yêu cầu liên quan, cập nhật trạng thái yêu cầu
            if (payload.get("maYeuCau") != null) {
                Long maYeuCau = Long.parseLong(payload.get("maYeuCau").toString());
                yeuCauNhapKhoRepository.findById(maYeuCau).ifPresent(req -> {
                    req.setTrangThai(1); // Đã duyệt/xử lý
                    yeuCauNhapKhoRepository.save(req);
                });
            }

            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Tạo phiếu thành công!",
                "id", saved.getMaPN()
            ));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("Lỗi hệ thống: " + e.getMessage());
        }
    }

    // API Nhân viên gửi yêu cầu nhập kho
    @PostMapping("/request")
    public ResponseEntity<?> createRequest(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody Map<String, Object> payload) {
        try {
            Long maBienThe = Long.parseLong(payload.get("maBienThe").toString());
            Integer qty = Integer.parseInt(payload.get("qty").toString());
            String ghiChu = (String) payload.get("ghiChu");

            TaiKhoan nv = taiKhoanRepository.findByEmail(userDetails.getUsername()).get();
            SanPhamChiTiet spct = sanPhamChiTietRepository.findById(maBienThe).get();

            YeuCauNhapKho req = new YeuCauNhapKho();
            req.setNhanVien(nv);
            req.setSanPhamChiTiet(spct);
            req.setSoLuongYeuCau(qty);
            req.setGhiChu(ghiChu);
            req.setTrangThai(0);
            yeuCauNhapKhoRepository.save(req);

            return ResponseEntity.ok(Map.of("success", true, "message", "Đã gửi yêu cầu nhập kho cho Admin"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Lỗi: " + e.getMessage());
        }
    }

    @PutMapping("/request/{id}/reject")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> rejectRequest(@PathVariable Long id) {
        if (id == null) return ResponseEntity.badRequest().build();
        Optional<YeuCauNhapKho> reqOpt = yeuCauNhapKhoRepository.findById(id);
        if (reqOpt.isPresent()) {
            YeuCauNhapKho req = reqOpt.get();
            req.setTrangThai(2); // Từ chối
            yeuCauNhapKhoRepository.save(req);
            return ResponseEntity.ok(Map.of("success", true));
        }
        return ResponseEntity.notFound().build();
    }

    // API lấy biến thể của 1 sản phẩm
    @GetMapping("/variants/{maSP}")
    public ResponseEntity<?> getVariantsBySanPham(@PathVariable Long maSP) {
        List<SanPhamChiTiet> variants = sanPhamChiTietRepository.findBySanPham_MaSP(maSP);
        List<Map<String, Object>> result = new ArrayList<>();
        for (SanPhamChiTiet v : variants) {
            Map<String, Object> m = new HashMap<>();
            m.put("maBienThe", v.getMaBienThe());
            m.put("size", v.getSizeSP() != null ? v.getSizeSP().getTenSize() : "");
            m.put("mau", v.getMauSacSP() != null ? v.getMauSacSP().getTenMau() : "");
            m.put("soLuongTon", v.getSoLuongTon());
            m.put("giaNhap", v.getGiaNhap());
            result.add(m);
        }
        return ResponseEntity.ok(result);
    }
    
    
    //thêm nhà cung cấp
    @PostMapping("/supplier")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> createSupplier(@RequestBody NhaCungCap ncc) {
        try {
            NhaCungCap saved = nhaCungCapRepository.save(ncc);
            return ResponseEntity.ok(saved);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Lỗi khi thêm NCC: " + e.getMessage());
        }
    }

    @PutMapping("/supplier/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> updateSupplier(@PathVariable Long id, @RequestBody NhaCungCap ncc) {
        return nhaCungCapRepository.findById(id).map(existing -> {
            existing.setTenNCC(ncc.getTenNCC());
            existing.setSoDienThoai(ncc.getSoDienThoai());
            existing.setDiaChi(ncc.getDiaChi());
            return ResponseEntity.ok(nhaCungCapRepository.save(existing));
        }).orElse(ResponseEntity.notFound().build());
    }
    
    @DeleteMapping("/supplier/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteSupplier(@PathVariable Long id) {
        try {
            if (nhaCungCapRepository.existsById(id)) {
                nhaCungCapRepository.deleteById(id);
                return ResponseEntity.ok(Map.of("success", true, "message", "Xóa thành công"));
            }
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            // Lỗi này thường xảy ra nếu nhà cung cấp đã có phiếu nhập (ràng buộc khóa ngoại)
            return ResponseEntity.internalServerError()
                    .body("Không thể xóa nhà cung cấp này vì đã có dữ liệu liên quan (phiếu nhập).");
        }
    }
}