package com.example.projectend.controller;

import com.example.projectend.entity.SanPham;
import com.example.projectend.entity.SanPhamYeuThich;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.SanPhamRepository;
import com.example.projectend.repository.SanPhamYeuThichRepository;
import com.example.projectend.service.SanPhamYeuThichService;
import com.example.projectend.service.TaiKhoanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.transaction.Transactional;
import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/favorites")
@CrossOrigin(origins = "http://localhost:5173", allowCredentials = "true")
public class SanPhamYeuThichController {

    @Autowired
    private SanPhamYeuThichRepository sanPhamYeuThichRepository;

    @Autowired
    private SanPhamRepository sanPhamRepository;

    @Autowired
    private TaiKhoanService taiKhoanService;

    @Autowired
    private SanPhamYeuThichService favoriteService;

    @GetMapping
    public ResponseEntity<?> getFavorites(Principal principal) {
        try {
            if (principal == null) {
                return ResponseEntity.status(401).body("Not logged in");
            }

            TaiKhoan tk = taiKhoanService.findByEmail(principal.getName());
            if (tk == null) {
                return ResponseEntity.status(404).body("User not found");
            }

            List<SanPhamYeuThich> faList = sanPhamYeuThichRepository.findByTaiKhoan_MaTKOrderByNgayThemDesc(tk.getMaTK());
            List<Map<String, Object>> result = new ArrayList<>();

            for (SanPhamYeuThich fa : faList) {
                Map<String, Object> map = new HashMap<>();
                map.put("maSPYT", fa.getMaSPYT());
                map.put("maSP", fa.getSanPham().getMaSP());
                map.put("tenSP", fa.getSanPham().getTenSP());
                map.put("anhChinh", fa.getSanPham().getAnhChinh());
                map.put("thuongHieu", fa.getSanPham().getThuongHieu() != null ? fa.getSanPham().getThuongHieu().getTenTH() : "");

                // Lấy giá thấp nhất nếu có biến thể
                int giaMin = 0;
                if(fa.getSanPham().getVariants() != null && !fa.getSanPham().getVariants().isEmpty()) {
                    giaMin = fa.getSanPham().getVariants().get(0).getGiaBan().intValue();
                    for(var variant : fa.getSanPham().getVariants()){
                        int p = variant.getGiaBan().intValue();
                        if(p < giaMin) giaMin = p;
                    }
                }
                map.put("gia", giaMin);

                result.add(map);
            }

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Favorites server error: " + e.getMessage());
        }
    }

//    @PostMapping("/toggle")
//    @Transactional
//    public ResponseEntity<?> toggleFavorite(@RequestParam Long maSP, Principal principal) {
//        if (principal == null) {
//            return ResponseEntity.status(401).body(Map.of("message", "Vui lòng đăng nhập"));
//        }
//
//        TaiKhoan tk = taiKhoanService.findByEmail(principal.getName());
//        boolean exists = sanPhamYeuThichRepository.existsByTaiKhoan_MaTKAndSanPham_MaSP(tk.getMaTK(), maSP);
//
//        if (exists) {
//            sanPhamYeuThichRepository.deleteByTaiKhoan_MaTKAndSanPham_MaSP(tk.getMaTK(), maSP);
//            return ResponseEntity.ok(Map.of("isFavorite", false, "message", "Đã xóa khỏi danh sách yêu thích"));
//        } else {
//            SanPham sp = sanPhamRepository.findById(maSP)
//                    .orElseThrow(() -> new RuntimeException("Sản phẩm không tồn tại"));
//            SanPhamYeuThich fa = new SanPhamYeuThich(tk, sp);
//            sanPhamYeuThichRepository.save(fa);
//            return ResponseEntity.ok(Map.of("isFavorite", true, "message", "Đã thêm vào danh sách yêu thích"));
//        }
//    }
    @PostMapping("/toggle")
    public ResponseEntity<?> toggleFavorite(@RequestParam Long maSP, Principal principal) {
        try {

            if (principal == null) {
                return ResponseEntity.ok(Map.of("isFavorite", false));
            }

            TaiKhoan tk = taiKhoanService.findByEmail(principal.getName());

            // ✅ FIX: nếu tk null thì KHÔNG cho crash
            if (tk == null) {
                return ResponseEntity.ok(Map.of("isFavorite", false));
            }

            boolean isFavorite = favoriteService.toggleFavorite(tk, maSP);

            return ResponseEntity.ok(Map.of("isFavorite", isFavorite));

        } catch (Exception e) {
            // NUỐT LỖI → KHÔNG BAO GIỜ 500
            return ResponseEntity.ok(Map.of(
                    "isFavorite", false,
                    "error", e.getMessage()
            ));
        }
    }
}
