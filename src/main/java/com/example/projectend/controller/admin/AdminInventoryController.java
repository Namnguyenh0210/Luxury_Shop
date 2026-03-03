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
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Controller quản lý kho & nhà cung cấp
 */
@RestController
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

    // =========================
    // LẤY DỮ LIỆU INVENTORY
    // =========================
    @GetMapping
    public Map<String, Object> getInventoryData() {

        List<PhieuNhap> phieuNhaps = phieuNhapRepository.findAll();
        phieuNhaps.sort((a, b) -> b.getNgayNhap().compareTo(a.getNgayNhap()));

        return Map.of(
                "phieuNhaps", phieuNhaps,
                "totalItems", nhapKhoRepository.count(),
                "supplierCount", nhaCungCapRepository.count(),
                "activeProducts", sanPhamRepository.countByTrangThaiSP(1),
                "suppliers", nhaCungCapRepository.findAll(),
                "products", sanPhamRepository.findByTrangThaiSP(1)
        );
    }
}