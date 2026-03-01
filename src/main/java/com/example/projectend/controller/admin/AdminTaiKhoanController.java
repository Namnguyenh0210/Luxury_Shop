package com.example.projectend.controller.admin;

import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.entity.VaiTro;
import com.example.projectend.repository.VaiTroRepository;
import com.example.projectend.service.TaiKhoanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;

@RestController
@RequestMapping("/admin/customers")
@PreAuthorize("hasRole('ADMIN')")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class AdminTaiKhoanController {

    @Autowired
    private TaiKhoanService taiKhoanService;

    @Autowired
    private VaiTroRepository vaiTroRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // =========================
    // 1. LẤY DANH SÁCH
    // =========================
    @GetMapping
    public List<TaiKhoan> getAllCustomers(
            @RequestParam(required = false) String keyword) {

        // Sau này có thể làm search riêng
        return taiKhoanService.findAll();
    }

    // =========================
    // 2. LẤY CHI TIẾT
    // =========================
    @GetMapping("/{id}")
    public TaiKhoan getCustomer(@PathVariable Long id) {
        return taiKhoanService.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản"));
    }

    // =========================
    // 3. THÊM / CẬP NHẬT
    // =========================
    @PostMapping
    public TaiKhoan saveAccount(
            @RequestBody TaiKhoan account,
            @RequestParam(required = false) String matKhauMoi,
            @RequestParam(required = false) Long vaiTroId) {

        if (account.getMaTK() == null) {
            // THÊM MỚI
            account.setNgayTao(LocalDateTime.now());
            account.setTrangThai(true);

            String rawPass = (matKhauMoi != null && !matKhauMoi.isEmpty())
                    ? matKhauMoi : "123456";

            account.setMatKhau(passwordEncoder.encode(rawPass));
        } else {
            // CẬP NHẬT
            TaiKhoan old = taiKhoanService.findById(account.getMaTK())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản"));

            account.setNgayTao(old.getNgayTao());
            account.setTrangThai(old.getTrangThai());

            if (matKhauMoi != null && !matKhauMoi.isEmpty()) {
                account.setMatKhau(passwordEncoder.encode(matKhauMoi));
            } else {
                account.setMatKhau(old.getMatKhau());
            }

            account.setRoles(old.getRoles());
        }

        // Cập nhật role
        if (vaiTroId != null) {
            VaiTro vaiTro = vaiTroRepository.findById(vaiTroId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy vai trò"));

            account.setRoles(new HashSet<>());
            account.getRoles().add(vaiTro);
        }

        account.setNgayCapNhat(LocalDateTime.now());

        return taiKhoanService.save(account);
    }

    // =========================
    // 4. KHÓA / MỞ KHÓA
    // =========================
    @PutMapping("/{id}/toggle-status")
    public TaiKhoan toggleStatus(@PathVariable Long id) {

        TaiKhoan account = taiKhoanService.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản"));

        account.setTrangThai(!account.getTrangThai());

        return taiKhoanService.save(account);
    }

    // =========================
    // 5. XÓA
    // =========================
    @DeleteMapping("/{id}")
    public void deleteAccount(@PathVariable Long id) {
        taiKhoanService.deleteById(id);
    }
}