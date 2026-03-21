package com.example.projectend.controller.admin;

import com.example.projectend.entity.Voucher;
import com.example.projectend.service.VoucherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;
import com.example.projectend.repository.DonHangRepository;

@RestController
@RequestMapping("/api/admin/vouchers")
@PreAuthorize("hasAnyRole('ADMIN')")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class AdminVoucherController {

    @Autowired
    private VoucherService voucherService;

    @Autowired
    private DonHangRepository donHangRepository;

    @GetMapping
    public List<Voucher> getAll() {
        return voucherService.findAll();
    }

    @GetMapping("/{id}")
    public Voucher getById(@PathVariable Long id) {
        return voucherService.findById(id).orElseThrow(() -> new RuntimeException("Không tìm thấy voucher"));
    }

    @PostMapping
    public Voucher save(@RequestBody Voucher voucher) {
        // Normalize code to uppercase
        if (voucher.getCode() != null) {
            voucher.setCode(voucher.getCode().toUpperCase().trim());
        }
        return voucherService.save(voucher);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        voucherService.deleteById(id);
    }

    @GetMapping("/{id}/usage")
    public List<Map<String, Object>> getUsage(@PathVariable Long id) {
        return donHangRepository.findAll().stream()
                .filter(dh -> dh.getVoucher() != null && dh.getVoucher().getMaVoucher().equals(id))
                .map(dh -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("maDH", dh.getMaDH());
                    map.put("ngayDat", dh.getNgayDat());
                    map.put("tongTien", dh.getTongTien());
                    map.put("giamGia", dh.getGiamGia());
                    map.put("khachHang", dh.getTaiKhoan().getHoTen());
                    map.put("email", dh.getTaiKhoan().getEmail());
                    return map;
                }).collect(Collectors.toList());
    }
}
