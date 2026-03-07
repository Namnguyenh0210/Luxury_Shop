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

@RestController // Chuyển sang RestController để trả về JSON cho Vue
@RequestMapping("/admin/inventory")
@PreAuthorize("hasRole('ADMIN') or hasRole('NHANVIEN')")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class AdminInventoryController {

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

    // Lấy toàn bộ dữ liệu cho trang Inventory
    @GetMapping
    public Map<String, Object> getInventoryData() {
        List<PhieuNhap> phieuNhaps = phieuNhapRepository.findAll();
        phieuNhaps.sort((a, b) -> b.getNgayNhap().compareTo(a.getNgayNhap()));

        return Map.of(
            "phieuNhaps", phieuNhaps,
            "suppliers", nhaCungCapRepository.findAll(),
            "products", sanPhamRepository.findByTrangThaiSP(1),
            "totalItems", nhapKhoRepository.count(),
            "supplierCount", nhaCungCapRepository.count(),
            "activeProducts", sanPhamRepository.countByTrangThaiSP(1)
        );
    }

    // API xử lý Lưu Phiếu Nhập từ Vue gửi lên
    @PostMapping("/import")
    public ResponseEntity<?> savePhieuNhap(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody Map<String, Object> payload) { // Dùng @RequestBody để nhận JSON
        try {
            // 1. Lấy thông tin cơ bản
            String maNCCStr = payload.get("maNCC").toString();
            Long maNCC = Long.parseLong(maNCCStr);
            String ghiChu = (String) payload.get("ghiChu");
            List<Map<String, Object>> items = (List<Map<String, Object>>) payload.get("items");

            if (items == null || items.isEmpty()) {
                return ResponseEntity.badRequest().body("Phải có ít nhất 1 sản phẩm");
            }

            // 2. Lấy thông tin User và NCC
            TaiKhoan nhanVien = taiKhoanRepository.findByEmail(userDetails.getUsername())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản"));
            NhaCungCap nhaCungCap = nhaCungCapRepository.findById(maNCC)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà cung cấp"));

            // 3. Chuyển đổi dữ liệu items từ Vue sang DTO cho Service
            // (Vì Vue gửi mảng objects {productId, qty, price...})
            List<PhieuNhapService.ExistingItem> existingItems = new ArrayList<>();
            
            for (Map<String, Object> item : items) {
                Long productId = Long.parseLong(item.get("productId").toString());
                Integer qty = Integer.parseInt(item.get("qty").toString());
                BigDecimal price = new BigDecimal(item.get("price").toString());
                
                // Ở đây ta giả định các sản phẩm chọn từ dropdown là ExistingItem
                existingItems.add(new PhieuNhapService.ExistingItem(productId, qty, price));
            }

            // 4. Gọi service để thực hiện nghiệp vụ (Lưu phiếu, lưu chi tiết, cộng tồn kho)
            PhieuNhap saved = phieuNhapService.createPhieuNhap(nhanVien, nhaCungCap, existingItems, new ArrayList<>(), ghiChu);

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
}