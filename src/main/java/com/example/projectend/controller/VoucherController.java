package com.example.projectend.controller;

import com.example.projectend.entity.Voucher;
import com.example.projectend.service.VoucherService;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.service.auth.UserDetailsServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/vouchers")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class VoucherController {

    @Autowired
    private VoucherService voucherService;

    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    @GetMapping("/available")
    public ResponseEntity<List<Voucher>> getAvailableVouchers(@RequestParam BigDecimal orderAmount) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        TaiKhoan tk = null;
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
            tk = userDetailsService.getTaiKhoanByEmail(auth.getName());
        }
        
        List<Voucher> vouchers = voucherService.getAvailableForUser(tk, orderAmount);
        return ResponseEntity.ok(vouchers);
    }

    @GetMapping("/check")
    public ResponseEntity<Map<String, Object>> checkVoucher(
            @RequestParam String code,
            @RequestParam BigDecimal orderAmount) {
        
        Map<String, Object> response = new HashMap<>();
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            TaiKhoan tk = null;
            if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
                tk = userDetailsService.getTaiKhoanByEmail(auth.getName());
            }

            Voucher voucher = voucherService.validateVoucherAdvanced(code.toUpperCase().trim(), orderAmount, tk, null);
            
            response.put("success", true);
            response.put("code", voucher.getCode());
            response.put("loaiGiamGia", voucher.getLoaiGiamGia());
            response.put("giaTri", voucher.getGiaTri());
            response.put("giaTriToiDa", voucher.getGiaTriToiDa());
            response.put("maVoucher", voucher.getMaVoucher());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }
}
