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
                                item.getMaGHCT(), // id
                                true, // dbItem
                                spct.getMaBienThe(), // maBienThe
                                spct.getSanPham().getTenSP(), // tenSP
                                spct.getSanPham().getThuongHieu() != null ? spct.getSanPham().getThuongHieu().getTenTH()
                                        : "BRAND",
                                spct.getSizeSP() != null ? spct.getSizeSP().getTenSize() : "",
                                spct.getMauSacSP() != null ? spct.getMauSacSP().getTenMau() : "",
                                item.getSoLuong(),
                                spct.getGiaBan(),
                                thanhTien,
                                anh);
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
                                maBienThe, // id (dùng maBienThe cho session)
                                false, // dbItem
                                maBienThe,
                                spct.getSanPham().getTenSP(),
                                spct.getSanPham().getThuongHieu() != null ? spct.getSanPham().getThuongHieu().getTenTH()
                                        : "BRAND",
                                spct.getSizeSP() != null ? spct.getSizeSP().getTenSize() : "",
                                spct.getMauSacSP() != null ? spct.getMauSacSP().getTenMau() : "",
                                soLuong,
                                spct.getGiaBan(),
                                thanhTien,
                                anh);
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
     * ❌ REMOVED - API endpoints đã được chuyển sang ApiController
     * 
     * Các API endpoint sau đây gây CONFLICT và đã được xóa:
     * - POST /api/cart/add → Dùng ApiController.addProductToCart()
     * - POST /api/cart/update → Dùng ApiController.updateCartItem()
     * - POST /api/cart/remove → Dùng ApiController.removeCartItem()
     * 
     * Controller này chỉ giữ lại route /giohang để render HTML page (legacy).
     * Tất cả API calls từ Vue frontend sẽ đi qua ApiController.
     */
}
