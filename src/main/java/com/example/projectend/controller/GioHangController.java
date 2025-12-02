package com.example.projectend.controller;

import com.example.projectend.dto.CartItemDTO;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.entity.GioHangChiTiet;
import com.example.projectend.entity.SanPhamChiTiet;
import com.example.projectend.service.GioHangService;
import com.example.projectend.service.TaiKhoanService;
import com.example.projectend.repository.SanPhamChiTietRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.*;

/**
 * Controller quản lý giỏ hàng người dùng
 * HỖ TRỢ: Giỏ hàng không cần đăng nhập (session-based)
 */
@Controller
public class GioHangController extends BaseController {

    @Autowired
    private GioHangService gioHangService;

    @Autowired
    private TaiKhoanService taiKhoanService;

    @Autowired
    private SanPhamChiTietRepository sanPhamChiTietRepository;

    /**
     * Hiển thị giỏ hàng - SỬ DỤNG DTO ĐỂ TRÁNH LAZY INITIALIZATION
     */
    @GetMapping("/giohang")
    public String viewCart(Model model, Principal principal, HttpSession session) {
        try {
            model.addAttribute("currentPage", "giohang");
            model.addAttribute("pageTitle", "Giỏ Hàng");

            List<CartItemDTO> cartItemDTOs = new ArrayList<>();
            BigDecimal total = BigDecimal.ZERO;

            if (principal != null) {
                // Người dùng đã đăng nhập - chuyển entity sang DTO
                TaiKhoan tk = taiKhoanService.findByEmail(principal.getName());
                if (tk != null) {
                    List<GioHangChiTiet> dbItems = gioHangService.getCartItems(tk);

                    for (GioHangChiTiet item : dbItems) {
                        SanPhamChiTiet spct = item.getSanPhamChiTiet();
                        BigDecimal thanhTien = spct.getGiaBan().multiply(BigDecimal.valueOf(item.getSoLuong()));
                        total = total.add(thanhTien);

                        String anh = spct.getAnhBienThe();
                        if (anh == null || anh.isEmpty()) {
                            anh = spct.getSanPham().getAnhChinh();
                        }
                        if (anh == null || anh.isEmpty()) {
                            anh = "placeholder.png";
                        }

                        CartItemDTO dto = new CartItemDTO(
                            item.getMaGHCT(),                    // id
                            true,                                 // dbItem
                            spct.getMaBienThe(),                 // maBienThe
                            spct.getSanPham().getTenSP(),        // tenSP
                            spct.getSanPham().getThuongHieu() != null ? spct.getSanPham().getThuongHieu().getTenTH() : "BRAND",
                            spct.getSizeSP() != null ? spct.getSizeSP().getTenSize() : "",
                            spct.getMauSacSP() != null ? spct.getMauSacSP().getTenMau() : "",
                            item.getSoLuong(),
                            spct.getGiaBan(),
                            thanhTien,
                            anh
                        );
                        cartItemDTOs.add(dto);
                    }
                }
            } else {
                // Người dùng chưa đăng nhập - chuyển session sang DTO
                @SuppressWarnings("unchecked")
                Map<Long, Integer> sessionCart = (Map<Long, Integer>) session.getAttribute("cart");
                if (sessionCart == null) {
                    sessionCart = new HashMap<>();
                    session.setAttribute("cart", sessionCart);
                }

                for (Map.Entry<Long, Integer> entry : sessionCart.entrySet()) {
                    Long maBienThe = entry.getKey();
                    Integer soLuong = entry.getValue();

                    Optional<SanPhamChiTiet> opt = sanPhamChiTietRepository.findById(maBienThe);
                    if (opt.isPresent()) {
                        SanPhamChiTiet spct = opt.get();
                        BigDecimal thanhTien = spct.getGiaBan().multiply(BigDecimal.valueOf(soLuong));
                        total = total.add(thanhTien);

                        String anh = spct.getAnhBienThe();
                        if (anh == null || anh.isEmpty()) {
                            anh = spct.getSanPham().getAnhChinh();
                        }
                        if (anh == null || anh.isEmpty()) {
                            anh = "placeholder.png";
                        }

                        CartItemDTO dto = new CartItemDTO(
                            maBienThe,                           // id (dùng maBienThe cho session)
                            false,                                // dbItem
                            maBienThe,
                            spct.getSanPham().getTenSP(),
                            spct.getSanPham().getThuongHieu() != null ? spct.getSanPham().getThuongHieu().getTenTH() : "BRAND",
                            spct.getSizeSP() != null ? spct.getSizeSP().getTenSize() : "",
                            spct.getMauSacSP() != null ? spct.getMauSacSP().getTenMau() : "",
                            soLuong,
                            spct.getGiaBan(),
                            thanhTien,
                            anh
                        );
                        cartItemDTOs.add(dto);
                    }
                }
            }

            model.addAttribute("cartItems", cartItemDTOs);
            model.addAttribute("total", total);
            model.addAttribute("isEmpty", cartItemDTOs.isEmpty());

            return "Giohang";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("cartItems", new ArrayList<>());
            model.addAttribute("total", BigDecimal.ZERO);
            model.addAttribute("isEmpty", true);
            model.addAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "Giohang";
        }
    }

    /**
     * API thêm sản phẩm vào giỏ hàng - HỖ TRỢ KHÔNG CẦN ĐĂNG NHẬP
     */
    @PostMapping("/api/cart/add")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addToCart(@RequestParam(required = false) Long maBienThe,
                                                          @RequestParam(required = false) Long productId,
                                                          @RequestParam(defaultValue = "1") int soLuong,
                                                          Principal principal,
                                                          HttpSession session) {
        try {
            // Legacy support: nếu chỉ gửi productId (main.js) -> lấy biến thể còn hàng đầu tiên
            Long finalMaBienThe = maBienThe;
            if (finalMaBienThe == null && productId != null) {
                Optional<SanPhamChiTiet> spctOpt = sanPhamChiTietRepository
                        .findTop1BySanPham_MaSPAndSoLuongTonGreaterThanOrderBySoLuongTonDesc(productId, 0);
                if (spctOpt.isPresent()) {
                    finalMaBienThe = spctOpt.get().getMaBienThe();
                } else {
                    return ResponseEntity.ok(Map.of("success", false, "message", "❌ Sản phẩm không còn biến thể khả dụng"));
                }
            }
            if (finalMaBienThe == null) {
                return ResponseEntity.ok(Map.of("success", false, "message", "❌ Thiếu mã biến thể"));
            }
            if (principal != null) {
                TaiKhoan tk = taiKhoanService.findByEmail(principal.getName());
                gioHangService.addToCart(tk, finalMaBienThe, soLuong);
                long cartCount = gioHangService.sumQuantity(tk);
                return ResponseEntity.ok(Map.of(
                        "success", true,
                        "message", "✅ Đã thêm vào giỏ hàng",
                        "cartCount", cartCount
                ));
            } else {
                @SuppressWarnings("unchecked") Map<Long, Integer> cart = (Map<Long, Integer>) session.getAttribute("cart");
                if (cart == null) { cart = new HashMap<>(); }
                cart.put(finalMaBienThe, cart.getOrDefault(finalMaBienThe, 0) + soLuong);
                session.setAttribute("cart", cart);
                long cartCount = cart.values().stream().mapToLong(Integer::longValue).sum();
                return ResponseEntity.ok(Map.of(
                        "success", true,
                        "message", "✅ Đã thêm vào giỏ hàng (Đăng nhập để lưu giỏ hàng)",
                        "cartCount", cartCount
                ));
            }
        } catch (Exception e) {
            return ResponseEntity.ok(Map.of("success", false, "message", "❌ " + e.getMessage()));
        }
    }

    /**
     * API cập nhật số lượng - HỖ TRỢ SESSION
     */
    @PostMapping("/api/cart/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateCart(@RequestParam(required = false) Long maGHCT,
                                                           @RequestParam(required = false) Long maBienThe,
                                                           @RequestParam int soLuong,
                                                           Principal principal,
                                                           HttpSession session) {
        try {
            if (principal != null && maGHCT != null) {
                // Cập nhật giỏ hàng DB
                gioHangService.updateQuantity(maGHCT, soLuong);
                TaiKhoan tk = taiKhoanService.findByEmail(principal.getName());
                long cartCount = gioHangService.sumQuantity(tk);

                return ResponseEntity.ok(Map.of("success", true, "message", "✅ Cập nhật thành công", "cartCount", cartCount));
            } else if (maBienThe != null) {
                // Cập nhật giỏ hàng session
                Map<Long, Integer> cart = (Map<Long, Integer>) session.getAttribute("cart");
                if (cart != null) {
                    if (soLuong > 0) { cart.put(maBienThe, soLuong); } else { cart.remove(maBienThe); }
                    session.setAttribute("cart", cart);
                }
                long cartCount = cart != null ? cart.values().stream().mapToLong(Integer::longValue).sum() : 0;

                return ResponseEntity.ok(Map.of("success", true, "message", "✅ Cập nhật thành công", "cartCount", cartCount));
            }
            return ResponseEntity.ok(Map.of("success", true, "message", "✅ Không có thay đổi"));
        } catch (Exception e) {
            return ResponseEntity.ok(Map.of("success", false, "message", "❌ " + e.getMessage()));
        }
    }

    /**
     * API xóa sản phẩm - HỖ TRỢ SESSION
     */
    @PostMapping("/api/cart/remove")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> removeFromCart(@RequestParam(required = false) Long maGHCT,
                                                               @RequestParam(required = false) Long maBienThe,
                                                               Principal principal,
                                                               HttpSession session) {
        try {
            if (principal != null && maGHCT != null) {
                // Xóa từ DB
                gioHangService.removeFromCart(maGHCT);
                TaiKhoan tk = taiKhoanService.findByEmail(principal.getName());
                long cartCount = gioHangService.sumQuantity(tk);

                return ResponseEntity.ok(Map.of("success", true, "message", "✅ Đã xóa khỏi giỏ hàng", "cartCount", cartCount));
            } else if (maBienThe != null) {
                // Xóa từ session
                Map<Long, Integer> cart = (Map<Long, Integer>) session.getAttribute("cart");
                if (cart != null) { cart.remove(maBienThe); session.setAttribute("cart", cart); }
                long cartCount = cart != null ? cart.values().stream().mapToLong(Integer::longValue).sum() : 0;

                return ResponseEntity.ok(Map.of("success", true, "message", "✅ Đã xóa khỏi giỏ hàng", "cartCount", cartCount));
            }
            return ResponseEntity.ok(Map.of("success", true, "message", "✅ Không có thay đổi"));
        } catch (Exception e) {
            return ResponseEntity.ok(Map.of("success", false, "message", "❌ " + e.getMessage()));
        }
    }

    /**
     * ❌ REMOVED - API endpoints đã được chuyển sang ApiController để tối ưu
     * - /api/cart/count -> ApiController.getCartCount()
     * - /api/cart/items -> ApiController.getCartItems()
     */
}
