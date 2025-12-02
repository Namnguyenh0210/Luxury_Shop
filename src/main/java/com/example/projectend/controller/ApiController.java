package com.example.projectend.controller;

import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.entity.VaiTro;
import com.example.projectend.service.auth.UserDetailsServiceImpl;
import com.example.projectend.service.GioHangService;
import com.example.projectend.service.SanPhamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * REST API Controller - TỐI ƯU
 * Cung cấp các endpoint API cho frontend
 */
@RestController
@RequestMapping("/api")
public class ApiController {

    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    @Autowired
    private GioHangService gioHangService;

    @Autowired
    private SanPhamService sanPhamService;

    /**
     * API lấy thông tin vai trò của người dùng hiện tại
     */
    @GetMapping("/user/role")
    public ResponseEntity<Map<String, String>> getUserRole() {
        Map<String, String> response = new HashMap<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                response.put("role", "Guest");
                return ResponseEntity.ok(response);
            }

            String email = auth.getName();
            TaiKhoan taiKhoan = userDetailsService.getTaiKhoanByEmail(email);

            // Lấy role đầu tiên từ Set
            Set<VaiTro> roles = taiKhoan.getRoles();
            String roleName = roles.isEmpty() ? "KHACHHANG" : roles.iterator().next().getTenRole();

            response.put("role", roleName);
            response.put("email", email);
            response.put("name", taiKhoan.getHoTen());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("role", "Guest");
            response.put("error", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * API lấy số lượng sản phẩm trong giỏ hàng
     * Tối ưu: Trả về count thay vì toàn bộ cart items
     */
    @GetMapping("/cart/count")
    public ResponseEntity<Map<String, Object>> getCartCount() {
        Map<String, Object> response = new HashMap<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                response.put("count", 0);
                response.put("success", true);
                return ResponseEntity.ok(response);
            }

            String email = auth.getName();
            int count = gioHangService.getCartItemCount(email);

            response.put("count", count);
            response.put("success", true);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("count", 0);
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * API thêm sản phẩm vào giỏ hàng - TỐI ƯU
     * Backend tự động tìm biến thể còn hàng
     */
    @PostMapping("/cart/add-product")
    public ResponseEntity<Map<String, Object>> addProductToCart(
            @RequestParam("productId") Long productId,
            @RequestParam(value = "quantity", defaultValue = "1") int quantity) {

        Map<String, Object> response = new HashMap<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng");
                return ResponseEntity.ok(response);
            }

            String email = auth.getName();

            // Backend tự động tìm biến thể còn hàng đầu tiên
            boolean added = gioHangService.addProductToCart(email, productId, quantity);

            if (added) {
                int cartCount = gioHangService.getCartItemCount(email);
                response.put("success", true);
                response.put("message", "Đã thêm sản phẩm vào giỏ hàng");
                response.put("cartCount", cartCount);
            } else {
                response.put("success", false);
                response.put("message", "Không thể thêm sản phẩm. Sản phẩm có thể hết hàng.");
            }

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi: " + e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * API lấy danh sách sản phẩm trong giỏ hàng (cho debug)
     */
    @GetMapping("/cart/items")
    public ResponseEntity<Map<String, Object>> getCartItems() {
        Map<String, Object> response = new HashMap<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                response.put("items", new java.util.ArrayList<>());
                response.put("count", 0);
                response.put("success", true);
                return ResponseEntity.ok(response);
            }

            String email = auth.getName();
            var items = gioHangService.getCartItems(email);

            response.put("items", items);
            response.put("count", items.size());
            response.put("success", true);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("items", new java.util.ArrayList<>());
            response.put("count", 0);
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }
}
