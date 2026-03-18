package com.example.projectend.controller.admin;

import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.entity.VaiTro;
import com.example.projectend.repository.VaiTroRepository;
import com.example.projectend.service.TaiKhoanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/customers")
@PreAuthorize("hasRole('ADMIN')")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class AdminTaiKhoanController {

    @Autowired private TaiKhoanService taiKhoanService;
    @Autowired private VaiTroRepository vaiTroRepository;
    @Autowired private PasswordEncoder passwordEncoder;

    @GetMapping
    public ResponseEntity<?> getAll() {
        return ResponseEntity.ok(Map.of("customers", taiKhoanService.findAll()));
    }

    @GetMapping("/vaiTros-list")
    public ResponseEntity<?> getRolesList() {
        return ResponseEntity.ok(vaiTroRepository.findAll());
    }

    @PostMapping("/save")
    public ResponseEntity<?> save(@RequestBody TaiKhoan account) {
        try {
            if (account.getMaTK() == null) {
                account.setNgayTao(LocalDateTime.now());
                account.setTrangThai(true);
                account.setNguonTao("LOCAL");
                String pass = (account.getMatKhauMoi() != null && !account.getMatKhauMoi().isEmpty()) 
                              ? account.getMatKhauMoi() : "123456";
                account.setMatKhau(passwordEncoder.encode(pass));
                
                if (account.getVaiTros() == null || account.getVaiTros().isEmpty()) {
                    vaiTroRepository.findAll().stream()
                        .filter(r -> r.getTenVaiTro().contains("USER")).findFirst()
                        .ifPresent(r -> { 
                            account.setVaiTros(new HashSet<>()); 
                            account.addVaiTro(r); 
                        });
                }
            } else {
                TaiKhoan old = taiKhoanService.findById(account.getMaTK()).orElseThrow();
                account.setNgayTao(old.getNgayTao());
                account.setNguonTao(old.getNguonTao());
                if (account.getMatKhauMoi() != null && !account.getMatKhauMoi().isEmpty()) {
                    account.setMatKhau(passwordEncoder.encode(account.getMatKhauMoi()));
                } else {
                    account.setMatKhau(old.getMatKhau());
                }
            }
            account.setNgayCapNhat(LocalDateTime.now());
            return ResponseEntity.ok(taiKhoanService.save(account));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/toggle/{id}")
    public ResponseEntity<?> toggle(@PathVariable Long id) {
        TaiKhoan u = taiKhoanService.findById(id).orElseThrow();
        u.setTrangThai(!u.getTrangThai());
        return ResponseEntity.ok(taiKhoanService.save(u));
    }

    @PostMapping("/delete/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        taiKhoanService.deleteById(id);
        return ResponseEntity.ok().build();
    }
}