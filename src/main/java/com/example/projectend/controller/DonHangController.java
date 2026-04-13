package com.example.projectend.controller;

import com.example.projectend.entity.DonHang;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.DonHangRepository;
import com.example.projectend.service.DonHangService;
import com.example.projectend.service.TaiKhoanService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/orders")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class DonHangController {

    @Autowired
    private DonHangService donHangService;

    @Autowired
    private TaiKhoanService taiKhoanService;

    @Autowired
    private DonHangRepository donHangRepository;

    @GetMapping
    public List<DonHang> getAllOrders() {
        return donHangService.findAll();
    }

    @GetMapping("/my")
    public ResponseEntity<?> getMyOrders(Principal principal) {
        try {
            if (principal == null) {
                return ResponseEntity.status(401).body("Not logged in");
            }

            TaiKhoan tk = taiKhoanService.findByEmail(principal.getName());

            if (tk == null) {
                return ResponseEntity.status(404).body("User not found");
            }

            List<DonHang> orders = donHangService.getDonHangByKhachHang(tk);

            if (orders == null) {
                orders = new ArrayList<>();
            }

            return ResponseEntity.ok(orders);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Orders server error: " + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getOrderById(@PathVariable Long id, Principal principal) {
        try {
            if (principal == null) {
                return ResponseEntity.status(401).body("Not logged in");
            }
            DonHang order = donHangRepository.findById(id).orElse(null);
            if (order == null) {
                return ResponseEntity.status(404).body("Order not found");
            }
            // Verify order belongs to current user
            TaiKhoan tk = taiKhoanService.findByEmail(principal.getName());
            if (tk == null || !order.getTaiKhoan().getMaTK().equals(tk.getMaTK())) {
                return ResponseEntity.status(403).body("Forbidden");
            }

            // Tra ve DTO an toan, khong serialize entity nhu (tranh loi ByteBuddy Hibernate
            // proxy)
            java.util.Map<String, Object> dto = new java.util.HashMap<>();
            dto.put("maDH", order.getMaDH());
            dto.put("ngayDat", order.getNgayDat());
            dto.put("tongTien", order.getTongTien());
            dto.put("phiShip", order.getPhiShip());
            dto.put("giamGia", order.getGiamGia());
            dto.put("ghiChu", order.getGhiChu());
            dto.put("trangThaiDH", order.getTrangThaiDH());
            dto.put("trangThaiThanhToan", order.getTrangThaiThanhToan());
            dto.put("lyDoHuy", order.getLyDoHuy());

            // TaiKhoan (safe)
            if (order.getTaiKhoan() != null) {
                java.util.Map<String, Object> tkDto = new java.util.HashMap<>();
                tkDto.put("hoTen", order.getTaiKhoan().getHoTen());
                tkDto.put("email", order.getTaiKhoan().getEmail());
                tkDto.put("soDienThoai", order.getTaiKhoan().getSoDienThoai());
                dto.put("taiKhoan", tkDto);
            }

            // DiaChiGiao (safe)
            if (order.getDiaChiGiao() != null) {
                java.util.Map<String, Object> dcDto = new java.util.HashMap<>();
                dcDto.put("diaChiChiTiet", order.getDiaChiGiao().getDiaChiChiTiet());
                dcDto.put("hoTenNguoiNhan", order.getDiaChiGiao().getHoTenNguoiNhan());
                dcDto.put("soDienThoai", order.getDiaChiGiao().getSoDienThoai());
                dto.put("diaChiGiao", dcDto);
            }

            // HinhThucThanhToan (EAGER, safe)
            if (order.getHinhThucThanhToan() != null) {
                java.util.Map<String, Object> ptDto = new java.util.HashMap<>();
                ptDto.put("tenHinhThuc", order.getHinhThucThanhToan().getTenHinhThuc());
                dto.put("hinhThucThanhToan", ptDto);
            }

            // Voucher (safe)
            if (order.getVoucher() != null) {
                try {
                    java.util.Map<String, Object> vDto = new java.util.HashMap<>();
                    vDto.put("code", order.getVoucher().getCode());
                    vDto.put("giaTri", order.getVoucher().getGiaTri());
                    vDto.put("loaiGiamGia", order.getVoucher().getLoaiGiamGia());
                    dto.put("voucher", vDto);
                } catch (Exception ignored) {
                }
            }

            // Chi tiet don hang (safe)
            List<com.example.projectend.entity.DonHangChiTiet> chiTietList = donHangService.getOrderDetails(id);
            java.util.List<java.util.Map<String, Object>> chiTietDtos = new java.util.ArrayList<>();
            if (chiTietList != null) {
                for (com.example.projectend.entity.DonHangChiTiet ct : chiTietList) {
                    java.util.Map<String, Object> ctDto = new java.util.HashMap<>();
                    ctDto.put("maCT", ct.getMaCT());
                    ctDto.put("soLuong", ct.getSoLuong());
                    ctDto.put("donGia", ct.getDonGia());
                    com.example.projectend.entity.SanPhamChiTiet spct = ct.getSanPhamChiTiet();
                    if (spct != null) {
                        ctDto.put("maSP", spct.getSanPham() != null ? spct.getSanPham().getMaSP() : null);
                        ctDto.put("tenSP", spct.getSanPham() != null ? spct.getSanPham().getTenSP() : "");
                        String anhChinh = spct.getSanPham() != null ? spct.getSanPham().getAnhChinh() : null;
                        String anhBienThe = spct.getAnhBienThe();
                        String anh = (anhChinh != null && !anhChinh.isEmpty()) ? anhChinh : anhBienThe;
                        if (anh != null && !anh.startsWith("http") && !anh.startsWith("/")) {
                            anh = "/uploads/products/" + anh;
                        }
                        ctDto.put("anh", anh != null ? anh : "/img/placeholder.png");
                        ctDto.put("size", spct.getSizeSP() != null ? spct.getSizeSP().getTenSize() : "");
                        ctDto.put("mau", spct.getMauSacSP() != null ? spct.getMauSacSP().getTenMau() : "");
                        ctDto.put("thuongHieu", spct.getSanPham() != null && spct.getSanPham().getThuongHieu() != null
                                ? spct.getSanPham().getThuongHieu().getTenTH()
                                : "");
                    }
                    chiTietDtos.add(ctDto);
                }
            }
            dto.put("chiTiet", chiTietDtos);

            return ResponseEntity.ok(dto);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error: " + e.getMessage());
        }
    }

    @PutMapping("/update-status/{id}")
    public ResponseEntity<?> updateStatus(
            @PathVariable Long id,
            @RequestParam Integer status,
            @RequestParam(required = false) String reason) {

        donHangService.updateStatus(id, status, reason);

        return ResponseEntity.ok("Updated");
    }

    @PutMapping("/{id}/report-undelivered")
    public ResponseEntity<?> reportUndelivered(
            @PathVariable Long id,
            @RequestParam String reason,
            @RequestParam(required = false) String description) {
        donHangService.reportOrderNotReceived(id, reason, description);
        return ResponseEntity.ok("Đã gửi báo cáo cho Admin");
    }

    @PutMapping("/complete/{id}")
    public ResponseEntity<?> completeOrder(@PathVariable Long id) {

        donHangService.capNhatTrangThai(id, 4, "Khách hàng", "Khách hàng xác nhận đã nhận hàng");

        return ResponseEntity.ok("Đơn hàng đã hoàn tất");
    }

    /**
     * Admin xác nhận đã hoàn tiền thủ công cho đơn hàng
     */
    @PostMapping("/{id}/confirm-refund")
    public ResponseEntity<?> confirmRefund(@PathVariable Long id, @RequestBody java.util.Map<String, String> body) {
        try {
            String ghiChu = body.get("ghiChu");
            donHangService.xacNhanDaHoanTien(id, ghiChu);
            return ResponseEntity.ok(java.util.Map.of("success", true, "message", "Đã xác nhận hoàn tiền thành công"));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(java.util.Map.of("success", false, "message", e.getMessage()));
        }
    }
}