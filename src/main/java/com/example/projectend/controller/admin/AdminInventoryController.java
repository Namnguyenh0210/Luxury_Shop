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
@RequestMapping("/admin/inventory")
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

        Map<String, Object> result = new HashMap<>();
        result.put("phieuNhaps", phieuNhaps);
        result.put("suppliers", nhaCungCapRepository.findAll());
        result.put("products", sanPhamRepository.findByTrangThaiSP(1));
        result.put("categories", loaiSanPhamRepository.findAll());
        result.put("sizes", sizeSPRepository.findAll());
        result.put("colors", mauSacSPRepository.findAll());
        result.put("nhanViens", nhanVienList);
        result.put("totalItems", nhapKhoChiTietRepository.count());
        result.put("supplierCount", nhaCungCapRepository.count());
        result.put("activeProducts", sanPhamRepository.countByTrangThaiSP(1));
        result.put("lowStock", lowStockList);
        return result;
    }

    // API xử lý Lưu Phiếu Nhập từ Vue gửi lên
    @PostMapping("/import")
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
                    existingItems.add(new PhieuNhapService.ExistingItem(maBienThe, qty, price));
                } else {
                    // Sản phẩm mới
                    String tenSP = item.get("tenSP") != null ? item.get("tenSP").toString() : "";
                    String size = item.get("size") != null ? item.get("size").toString() : "";
                    String color = item.get("color") != null ? item.get("color").toString() : "";
                    Integer gender = item.get("gender") != null ? Integer.parseInt(item.get("gender").toString()) : 2;
                    Long categoryId = item.get("categoryId") != null ? Long.parseLong(item.get("categoryId").toString()) : null;
                    BigDecimal giaBan = item.get("giaBan") != null ? new BigDecimal(item.get("giaBan").toString()) : price;
                    newItems.add(new PhieuNhapService.NewItem(tenSP, size, color, qty, price, giaBan, categoryId, null, gender));
                }
            }

            PhieuNhap saved = phieuNhapService.createPhieuNhap(nhanVien, nhaCungCap, existingItems, newItems, ghiChu);

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
}