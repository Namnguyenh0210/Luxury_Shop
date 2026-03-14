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
import java.time.LocalDateTime;
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
            return ResponseEntity.ok(order);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error: " + e.getMessage());
        }
    }


    @PutMapping("/update-status/{id}")
    public ResponseEntity<?> updateStatus(
            @PathVariable Long id,
            @RequestParam Integer status){

        donHangService.updateStatus(id, status);

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

        DonHang donHang = donHangRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng"));

        donHang.setTrangThaiDH(4); // 4 = Hoàn tất
        donHang.setNgayCapNhat(LocalDateTime.now());

        donHangRepository.save(donHang);

        return ResponseEntity.ok("Đơn hàng đã hoàn tất");
    }
}