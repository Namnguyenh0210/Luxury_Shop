package com.example.projectend.controller;

import com.example.projectend.entity.*;
import com.example.projectend.service.auth.UserDetailsServiceImpl;
import com.example.projectend.service.GioHangService;
import com.example.projectend.service.SanPhamService;
import com.example.projectend.service.LoaiSanPhamService;
import com.example.projectend.service.DanhGiaService;
import com.example.projectend.repository.ThuongHieuRepository;
import com.example.projectend.repository.SanPhamChiTietRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

/**
 * REST API Controller - TỐI ƯU
 * Cung cấp các endpoint API cho frontend Vue.js
 */
@RestController
@RequestMapping("/api")
public class ApiController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(ApiController.class);

    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    @Autowired
    private GioHangService gioHangService;

    @Autowired
    private SanPhamService sanPhamService;

    @Autowired
    private LoaiSanPhamService loaiSanPhamService;

    @Autowired
    private ThuongHieuRepository thuongHieuRepository;

    @Autowired
    private DanhGiaService danhGiaService;

    @Autowired
    private SanPhamChiTietRepository sanPhamChiTietRepository;

    @Autowired
    private com.example.projectend.repository.TaiKhoanRepository taiKhoanRepository;

    @Autowired
    private com.example.projectend.repository.DiaChiRepository diaChiRepository;

    @Autowired
    private com.example.projectend.repository.PhuongThucThanhToanRepository phuongThucThanhToanRepository;

    @Autowired
    private com.example.projectend.service.DonHangService donHangService;

    @Autowired
    private com.example.projectend.service.EmailService emailService;

    /**
     * API lấy thông tin user hiện tại
     */
    @GetMapping("/auth/current-user")
    public ResponseEntity<Map<String, Object>> getCurrentUser() {
        Map<String, Object> response = new HashMap<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                response.put("authenticated", false);
                return ResponseEntity.ok(response);
            }

            String email = auth.getName();
            TaiKhoan taiKhoan = userDetailsService.getTaiKhoanByEmail(email);

            Set<VaiTro> vaiTros = taiKhoan.getVaiTros();
            java.util.List<String> roleNames = new java.util.ArrayList<>();
            for (VaiTro role : vaiTros) {
                roleNames.add(role.getTenVaiTro());
            }

            response.put("authenticated", true);
            response.put("email", email);
            response.put("hoTen", taiKhoan.getHoTen());
            response.put("soDienThoai", taiKhoan.getSoDienThoai());
            response.put("avatar", taiKhoan.getAvatar());
            response.put("provider", taiKhoan.getNguonTao() != null ? taiKhoan.getNguonTao() : "LOCAL");
            response.put("vaiTros", roleNames);
            response.put("isGoogleUser", "GOOGLE".equals(taiKhoan.getNguonTao()));
            response.put("trangThai", taiKhoan.getTrangThai());
            response.put("ngayTao", taiKhoan.getNgayTao());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("authenticated", false);
            response.put("error", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * API lấy danh sách danh mục (loại sản phẩm)
     */
    @GetMapping("/categories")
    public ResponseEntity<List<LoaiSanPham>> getAllCategories() {
        return ResponseEntity.ok(loaiSanPhamService.findAll());
    }

    /**
     * API lấy danh sách sản phẩm với phân trang và filter
     */
    @GetMapping("/sanpham")
    public ResponseEntity<Map<String, Object>> getProducts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "12") int size,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) Long loai,
            @RequestParam(required = false) Integer gioiTinh,
            @RequestParam(required = false) Long thuongHieu,
            @RequestParam(required = false) BigDecimal minPrice,
            @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(defaultValue = "moi") String sort) {

        Map<String, Object> response = new HashMap<>();

        try {
            PageRequest pageable = PageRequest.of(page, size);
            Page<SanPham> sanPhamPage = sanPhamService.findWithFilters(
                    search, loai, gioiTinh, thuongHieu, minPrice, maxPrice, 1, sort, pageable);

            response.put("success", true);
            response.put("content", sanPhamPage.getContent());
            response.put("priceStockMap", sanPhamService.buildPriceStockMap(sanPhamPage.getContent()));
            response.put("totalElements", sanPhamPage.getTotalElements());
            response.put("totalPages", sanPhamPage.getTotalPages());
            response.put("currentPage", sanPhamPage.getNumber());
            response.put("pageSize", sanPhamPage.getSize());
            response.put("numberOfElements", sanPhamPage.getNumberOfElements());
            response.put("first", sanPhamPage.isFirst());
            response.put("last", sanPhamPage.isLast());
            response.put("categories", loaiSanPhamService.findAll());
            response.put("brands", thuongHieuRepository.findAll());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * API lấy chi tiết sản phẩm theo ID
     */
    @GetMapping("/sanpham/{id}")
    public ResponseEntity<Map<String, Object>> getProductDetail(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();

        try {
            // Lấy thông tin sản phẩm
            java.util.Optional<SanPham> sanPhamOpt = sanPhamService.findById(id);
            if (sanPhamOpt.isEmpty()) {
                response.put("success", false);
                response.put("message", "Sản phẩm không tồn tại");
                return ResponseEntity.ok(response);
            }

            SanPham sanPham = sanPhamOpt.get();

            // Lấy danh sách biến thể (variants)
            java.util.List<SanPhamChiTiet> variants = sanPhamChiTietRepository.findBySanPham_MaSP(id);

            // Lấy giá min/max và tồn kho
            BigDecimal minPrice = sanPhamService.getMinPrice(id);
            BigDecimal maxPrice = sanPhamService.getMaxPrice(id);
            Integer totalStock = sanPhamService.getTotalStock(id);

            // Lấy đánh giá
            java.util.List<DanhGia> danhGiaList = danhGiaService.getDanhGiaBySanPham(id);

            // Lấy sản phẩm liên quan
            java.util.List<SanPham> relatedProducts = new java.util.ArrayList<>();
            if (sanPham.getLoaiSanPham() != null) {
                relatedProducts = sanPhamService.findRelatedProducts(
                        sanPham.getLoaiSanPham().getMaLoai(),
                        sanPham.getMaSP(),
                        4); // Hiển thị 4 sản phẩm cùng danh mục
            }

            response.put("success", true);
            response.put("product", sanPham);
            response.put("variants", variants);
            response.put("minPrice", minPrice);
            response.put("maxPrice", maxPrice);
            response.put("totalStock", totalStock);
            response.put("reviews", danhGiaList);
            response.put("reviewCount", danhGiaList != null ? danhGiaList.size() : 0);
            response.put("relatedProducts", relatedProducts);
            response.put("relatedPriceMap", sanPhamService.buildPriceStockMap(relatedProducts));

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * API lấy số lượng sản phẩm trong giỏ hàng
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
     * API thêm sản phẩm vào giỏ hàng - HỖ TRỢ CHỌN SIZE/MÀU & ANONYMOUS SESSIONS
     */
    @PostMapping("/cart/add-product")
    public ResponseEntity<Map<String, Object>> addProductToCart(
            @RequestParam("productId") Long productId,
            @RequestParam(value = "variantId", required = false) Long variantId,
            @RequestParam(value = "quantity", defaultValue = "1") int quantity,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            // 1. CHƯA ĐĂNG NHẬP - Chặn khách vãng lai (Yêu cầu login)
            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập để thực hiện");
                return ResponseEntity.status(401).body(response);
            }

            // 2. ĐÃ ĐĂNG NHẬP - Lưu vào Database
            String email = auth.getName();
            boolean added = gioHangService.addProductToCart(email, productId, variantId, quantity);

            if (added) {
                int cartCount = gioHangService.getCartItemCount(email);
                response.put("success", true);
                response.put("message", "Đã thêm vào giỏ hàng");
                response.put("cartCount", cartCount);
            } else {
                response.put("success", false);
                response.put("message", "Sản phẩm hoặc kích cỡ này hiện đã hết hàng.");
            }

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi: " + e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * API lấy danh sách sản phẩm trong giỏ hàng
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

    /**
     * API cập nhật số lượng sản phẩm trong giỏ hàng
     */
    @PostMapping("/cart/update")
    public ResponseEntity<Map<String, Object>> updateCartItem(
            @RequestParam("cartItemId") Long cartItemId,
            @RequestParam("quantity") int quantity) {

        Map<String, Object> response = new HashMap<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.ok(response);
            }

            gioHangService.updateQuantity(cartItemId, quantity);

            String email = auth.getName();
            int cartCount = gioHangService.getCartItemCount(email);

            response.put("success", true);
            response.put("message", "Đã cập nhật giỏ hàng");
            response.put("cartCount", cartCount);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi: " + e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * API xóa sản phẩm khỏi giỏ hàng
     */
    @PostMapping("/cart/remove")
    public ResponseEntity<Map<String, Object>> removeCartItem(@RequestParam("cartItemId") Long cartItemId) {
        Map<String, Object> response = new HashMap<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.ok(response);
            }

            gioHangService.removeFromCart(cartItemId);

            String email = auth.getName();
            int cartCount = gioHangService.getCartItemCount(email);

            response.put("success", true);
            response.put("message", "Đã xóa sản phẩm");
            response.put("cartCount", cartCount);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi: " + e.getMessage());
            return ResponseEntity.ok(response);
        }
    }

    /**
     * API đăng nhập (JSON)
     */
    @PostMapping("/auth/login")
    public ResponseEntity<Map<String, Object>> login(
            @RequestParam String username,
            @RequestParam String password,
            jakarta.servlet.http.HttpServletRequest request) {

        Map<String, Object> response = new HashMap<>();

        try {
            // Load user from database
            org.springframework.security.core.userdetails.UserDetails userDetails = userDetailsService
                    .loadUserByUsername(username);

            // Check password (plain text comparison since we use NoOpPasswordEncoder)
            if (!userDetails.getPassword().equals(password)) {
                response.put("success", false);
                response.put("message", "Email hoặc mật khẩu không đúng!");
                return ResponseEntity.status(401).body(response);
            }

            // Create authentication token
            org.springframework.security.authentication.UsernamePasswordAuthenticationToken authToken = new org.springframework.security.authentication.UsernamePasswordAuthenticationToken(
                    userDetails, null, userDetails.getAuthorities());

            // Set authentication in context
            SecurityContextHolder.getContext().setAuthentication(authToken);

            // Create new session to persist authentication
            jakarta.servlet.http.HttpSession session = request.getSession(true);
            session.setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());

            // Get user info
            TaiKhoan taiKhoan = userDetailsService.getTaiKhoanByEmail(username);
            Set<VaiTro> vaiTros = taiKhoan.getVaiTros();
            java.util.List<String> roleNames = new java.util.ArrayList<>();
            for (VaiTro role : vaiTros) {
                roleNames.add(role.getTenVaiTro());
            }

            // Determine redirect URL based on role
            String redirectUrl = "/";
            if (roleNames.contains("ADMIN")) {
                redirectUrl = "/admin/dashboard";
            } else if (roleNames.contains("NHANVIEN")) {
                redirectUrl = "/staff/dashboard";
            }

            response.put("success", true);
            response.put("message", "Đăng nhập thành công");
            response.put("user", Map.of(
                    "email", taiKhoan.getEmail(),
                    "hoTen", taiKhoan.getHoTen(),
                    "vaiTros", roleNames));
            response.put("redirectUrl", redirectUrl);

            return ResponseEntity.ok(response);

        } catch (org.springframework.security.core.userdetails.UsernameNotFoundException e) {
            response.put("success", false);
            response.put("message", "Email hoặc mật khẩu không đúng!");
            return ResponseEntity.status(401).body(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * API đăng xuất
     */
    @RequestMapping(value = "/auth/logout", method = {RequestMethod.GET, RequestMethod.POST})
    public ResponseEntity<Map<String, Object>> logout(
            jakarta.servlet.http.HttpServletRequest request,
            jakarta.servlet.http.HttpServletResponse response) {

        try {
            // 1. Invalidate HTTP session FIRST
            jakarta.servlet.http.HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
                System.out.println("✅ Session invalidated");
            }

            // 2. Clear Spring Security
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null) {
                new org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler()
                        .logout(request, response, auth);
            }
            SecurityContextHolder.clearContext();

            // 3. Clear JSESSIONID cookie
            jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JSESSIONID", null);
            cookie.setPath("/");
            cookie.setMaxAge(0);
            response.addCookie(cookie);

            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Đăng xuất thành công"));
        } catch (Exception e) {
            SecurityContextHolder.clearContext();

            jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JSESSIONID", null);
            cookie.setPath("/");
            cookie.setMaxAge(0);
            response.addCookie(cookie);

            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Đăng xuất thành công"));
        }
    }

    /**
     * API cập nhật thông tin profile (hỗ trợ upload avatar)
     */
    @PostMapping("/profile/update")
    public ResponseEntity<Map<String, Object>> updateProfile(
            @RequestParam String hoTen,
            @RequestParam(required = false) String soDienThoai,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) org.springframework.web.multipart.MultipartFile avatar) {

        Map<String, Object> response = new HashMap<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                response.put("success", false);
                response.put("message", "Bạn cần đăng nhập để thực hiện thao tác này");
                return ResponseEntity.status(401).body(response);
            }

            String currentEmail = auth.getName();
            TaiKhoan taiKhoan = userDetailsService.getTaiKhoanByEmail(currentEmail);

            if (taiKhoan == null) {
                response.put("success", false);
                response.put("message", "Không tìm thấy tài khoản");
                return ResponseEntity.status(404).body(response);
            }

            // Cập nhật họ tên
            if (hoTen != null && !hoTen.trim().isEmpty()) {
                taiKhoan.setHoTen(hoTen.trim());
            }

            // Cập nhật số điện thoại
            if (soDienThoai != null && !soDienThoai.trim().isEmpty()) {
                taiKhoan.setSoDienThoai(soDienThoai.trim());
            }

            // Xử lý upload avatar
            if (avatar != null && !avatar.isEmpty()) {
                String uploadDir = System.getProperty("user.dir") + "/src/main/resources/static/avatars/";
                java.io.File dir = new java.io.File(uploadDir);
                if (!dir.exists())
                    dir.mkdirs();

                String originalName = avatar.getOriginalFilename();
                String ext = originalName != null && originalName.contains(".")
                        ? originalName.substring(originalName.lastIndexOf("."))
                        : ".jpg";
                String fileName = "avatar_" + taiKhoan.getMaTK() + "_" + System.currentTimeMillis() + ext;

                java.nio.file.Path filePath = java.nio.file.Paths.get(uploadDir + fileName);
                java.nio.file.Files.write(filePath, avatar.getBytes());

                taiKhoan.setAvatar("/avatars/" + fileName);
            }

            taiKhoanRepository.save(taiKhoan);

            response.put("success", true);
            response.put("message", "Cập nhật thông tin thành công!");
            response.put("avatar", taiKhoan.getAvatar());
            response.put("hoTen", taiKhoan.getHoTen());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * API đổi mật khẩu
     */
    @PostMapping("/profile/change-password")
    public ResponseEntity<Map<String, Object>> changePassword(
            @RequestParam String oldPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword) {

        Map<String, Object> response = new HashMap<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                response.put("success", false);
                response.put("message", "Bạn cần đăng nhập để thực hiện thao tác này");
                return ResponseEntity.status(401).body(response);
            }

            String email = auth.getName();
            TaiKhoan taiKhoan = userDetailsService.getTaiKhoanByEmail(email);

            if (taiKhoan == null) {
                response.put("success", false);
                response.put("message", "Không tìm thấy tài khoản");
                return ResponseEntity.status(404).body(response);
            }

            // Kiểm tra mật khẩu hiện tại
            if (!taiKhoan.getMatKhau().equals(oldPassword)) {
                response.put("success", false);
                response.put("message", "Mật khẩu hiện tại không đúng!");
                return ResponseEntity.status(400).body(response);
            }

            // Kiểm tra mật khẩu mới khớp
            if (!newPassword.equals(confirmPassword)) {
                response.put("success", false);
                response.put("message", "Mật khẩu mới không khớp!");
                return ResponseEntity.status(400).body(response);
            }

            // Cập nhật mật khẩu mới
            taiKhoan.setMatKhau(newPassword);
            taiKhoanRepository.save(taiKhoan);

            response.put("success", true);
            response.put("message", "Đổi mật khẩu thành công!");

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * API lấy thông tin checkout
     */
    @GetMapping("/checkout")
    public ResponseEntity<Map<String, Object>> getCheckoutData() {
        Map<String, Object> response = new HashMap<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.status(401).body(response);
            }

            String email = auth.getName();
            TaiKhoan tk = userDetailsService.getTaiKhoanByEmail(email);

            // Lấy giỏ hàng
            List<com.example.projectend.entity.GioHangChiTiet> items = gioHangService.getGioHangByTaiKhoan(tk);
            if (items.isEmpty()) {
                response.put("success", false);
                response.put("message", "Giỏ hàng trống");
                response.put("redirectUrl", "/giohang");
                return ResponseEntity.ok(response);
            }

            // Chuyển sang DTO
            List<Map<String, Object>> itemDTOs = new ArrayList<>();
            java.math.BigDecimal tongTien = java.math.BigDecimal.ZERO;

            for (com.example.projectend.entity.GioHangChiTiet item : items) {
                com.example.projectend.entity.SanPhamChiTiet spct = item.getSanPhamChiTiet();
                java.math.BigDecimal thanhTien = spct.getGiaBan()
                        .multiply(java.math.BigDecimal.valueOf(item.getSoLuong()));
                tongTien = tongTien.add(thanhTien);

                String anh = spct.getSanPham().getAnhChinh();
                if (anh == null || anh.isEmpty()) {
                    anh = spct.getAnhBienThe();
                }
                
                // Fallback again if the link is a known dead link and main image is available
                if (spct.getAnhBienThe() != null && spct.getAnhBienThe().contains("media.gucci.com")) {
                     if (spct.getSanPham().getAnhChinh() != null && !spct.getSanPham().getAnhChinh().isEmpty()) {
                         anh = spct.getSanPham().getAnhChinh();
                     } else {
                         anh = "placeholder.png";
                     }
                }

                if (anh == null || anh.isEmpty()) {
                    anh = "placeholder.png";
                }

                Map<String, Object> dto = new HashMap<>();
                dto.put("id", spct.getMaBienThe());
                dto.put("tenSP", spct.getSanPham().getTenSP());
                dto.put("thuongHieu",
                        spct.getSanPham().getThuongHieu() != null ? spct.getSanPham().getThuongHieu().getTenTH()
                                : "BRAND");
                dto.put("size", spct.getSizeSP() != null ? spct.getSizeSP().getTenSize() : "");
                dto.put("mau", spct.getMauSacSP() != null ? spct.getMauSacSP().getTenMau() : "");
                dto.put("soLuong", item.getSoLuong());
                dto.put("donGia", spct.getGiaBan());
                dto.put("thanhTien", thanhTien);
                dto.put("anh", anh);

                itemDTOs.add(dto);
            }

            // Lấy địa chỉ
            List<com.example.projectend.entity.DiaChi> addresses = diaChiRepository.findByTaiKhoan_MaTK(tk.getMaTK());

            // Lấy phương thức thanh toán
            List<com.example.projectend.entity.PhuongThucThanhToan> paymentMethods = phuongThucThanhToanRepository
                    .findByTrangThai(true);

            response.put("success", true);
            response.put("cartItems", itemDTOs);
            response.put("diaChiList", addresses);
            response.put("paymentMethods", paymentMethods);
            response.put("orderSubtotal", tongTien);
            response.put("orderTotal", tongTien);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * API đặt hàng
     */
    @PostMapping("/checkout/place-order")
    public ResponseEntity<Map<String, Object>> placeOrder(
            @RequestParam Long diaChiId,
            @RequestParam Long paymentMethod,
            @RequestParam(required = false) String ghiChu,
            @RequestParam(required = false) Long voucherId) {

        Map<String, Object> response = new HashMap<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.status(401).body(response);
            }

            String email = auth.getName();
            TaiKhoan tk = userDetailsService.getTaiKhoanByEmail(email);

            List<com.example.projectend.entity.GioHangChiTiet> items = gioHangService.getGioHangByTaiKhoan(tk);
            if (items.isEmpty()) {
                response.put("success", false);
                response.put("message", "Giỏ hàng trống");
                return ResponseEntity.ok(response);
            }

            com.example.projectend.entity.DonHang donHang = this.donHangService.createDonHang(tk, diaChiId,
                    paymentMethod,
                    items, ghiChu, voucherId);

            if (donHang == null) {
                response.put("success", false);
                response.put("message", "Đặt hàng thất bại");
                return ResponseEntity.ok(response);
            }

            // Kiểm tra PayOS
            boolean isPayOS = this.phuongThucThanhToanRepository.findById(paymentMethod)
                    .map(pt -> pt.getTenHinhThuc() != null && pt.getTenHinhThuc().toLowerCase().contains("payos"))
                    .orElse(false);

            // ✅ Gửi email xác nhận đơn hàng (async - không chặn)
            try {
                List<com.example.projectend.entity.DonHangChiTiet> chiTietList = donHangService
                        .getOrderDetails(donHang.getMaDH());
                emailService.sendOrderConfirmationEmail(donHang, chiTietList);
            } catch (Exception emailEx) {
                // Email lỗi không được phép hủy đơn hàng
                log.warn("Không gửi được email xác nhận: {}", emailEx.getMessage());
            }

            if (isPayOS) {
                response.put("success", true);
                response.put("message", "Đơn hàng đã được tạo");
                // ✅ Dùng absolute URL → trỏ thẳng về Spring Boot (8080)
                // Spring Boot sẽ gọi PayOS API rồi redirect về Vue /payment?...
                response.put("redirectUrl", "http://localhost:8080/payment/payos/create?orderId=" + donHang.getMaDH());
            } else {
                gioHangService.clearGioHang(tk);
                response.put("success", true);
                response.put("message", "Đặt hàng thành công!");
                response.put("redirectUrl", "/checkout-success?orderId=" + donHang.getMaDH());
            }

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    @GetMapping("/profile/addresses")
    public ResponseEntity<?> getAddresses() {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                return ResponseEntity.status(401).body("Not authenticated");
            }

            String email = auth.getName();
            TaiKhoan tk = userDetailsService.getTaiKhoanByEmail(email);

            List<DiaChi> addresses = diaChiRepository.findByTaiKhoan_MaTK(tk.getMaTK());

            return ResponseEntity.ok(addresses);
        } catch (Exception e) {
            log.error("Error fetching addresses: ", e);
            return ResponseEntity.status(500).body("Server Error: " + e.getMessage());
        }
    }

    @PostMapping("/profile/address/add")
    public ResponseEntity<?> addAddress(
            @RequestParam String hoTenNguoiNhan,
            @RequestParam String soDienThoai,
            @RequestParam String diaChiChiTiet,
            @RequestParam(required = false) String ghiChu) {

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                return ResponseEntity.status(401).body("Not authenticated");
            }

            String email = auth.getName();
            TaiKhoan tk = userDetailsService.getTaiKhoanByEmail(email);

            log.info("Adding address for user: {}, Name: {}, Phone: {}", email, hoTenNguoiNhan, soDienThoai);

            DiaChi dc = new DiaChi();
            dc.setTaiKhoan(tk);
            dc.setHoTenNguoiNhan(hoTenNguoiNhan);
            dc.setSoDienThoai(soDienThoai);
            dc.setDiaChiChiTiet(diaChiChiTiet);
            dc.setGhiChu(ghiChu);
            dc.setLaMacDinh(false);

            DiaChi saved = diaChiRepository.save(dc);
            log.info("Saved address with ID: {}", saved.getMaDiaChi());

            return ResponseEntity.ok("OK");
        } catch (Exception e) {
            log.error("Error adding address: ", e);
            return ResponseEntity.status(500).body("Error adding address: " + e.getMessage());
        }
    }

    @PostMapping("/profile/address/set-default")
    public ResponseEntity<?> setDefaultAddress(@RequestParam Long id) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return ResponseEntity.status(401).body("Not authenticated");
        }

        String email = auth.getName();
        TaiKhoan tk = userDetailsService.getTaiKhoanByEmail(email);

        try {
            // Lấy tất cả địa chỉ của user này
            List<DiaChi> addresses = diaChiRepository.findByTaiKhoan_MaTK(tk.getMaTK());
            for (DiaChi addr : addresses) {
                if (addr.getMaDiaChi() != null && addr.getMaDiaChi().equals(id)) {
                    addr.setLaMacDinh(true);
                } else {
                    addr.setLaMacDinh(false);
                }
            }
            diaChiRepository.saveAll(addresses);
            return ResponseEntity.ok("OK");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error: " + e.getMessage());
        }
    }

    @PostMapping("/profile/address/delete")
    public ResponseEntity<?> deleteAddress(@RequestParam Long id) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return ResponseEntity.status(401).body("Not authenticated");
        }

        String email = auth.getName();
        TaiKhoan tk = userDetailsService.getTaiKhoanByEmail(email);

        try {
            Optional<DiaChi> dcOpt = diaChiRepository.findById(id);
            if (dcOpt.isPresent()) {
                DiaChi dc = dcOpt.get();
                if (dc.getTaiKhoan() != null && dc.getTaiKhoan().getMaTK() != null && tk.getMaTK() != null && 
                    dc.getTaiKhoan().getMaTK().equals(tk.getMaTK())) {
                    diaChiRepository.delete(dc);
                    return ResponseEntity.ok("OK");
                }
                return ResponseEntity.status(403).body("Unauthorized");
            } else {
                return ResponseEntity.status(404).body("Not found");
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error: " + e.getMessage());
        }
    }

    @PostMapping("/upload")
    public ResponseEntity<Map<String, Object>> uploadImage(
            @RequestParam("file") org.springframework.web.multipart.MultipartFile file,
            @RequestParam(value = "type", defaultValue = "products") String type) {
        
        Map<String, Object> response = new HashMap<>();
        try {
            org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                response.put("success", false);
                response.put("message", "Từ chối truy cập");
                return ResponseEntity.status(401).body(response);
            }

            if (file != null && !file.isEmpty()) {
                String uploadDir = System.getProperty("user.dir") + "/uploads/" + type + "/";
                java.io.File dir = new java.io.File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                String originalName = file.getOriginalFilename();
                String ext = originalName != null && originalName.contains(".") ? originalName.substring(originalName.lastIndexOf(".")) : ".jpg";
                String fileName = "up_" + System.currentTimeMillis() + ext;

                java.nio.file.Path filePath = java.nio.file.Paths.get(uploadDir + fileName);
                java.nio.file.Files.write(filePath, file.getBytes());

                response.put("success", true);
                response.put("url", "http://localhost:8080/uploads/" + type + "/" + fileName);
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "File trống");
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi upload: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
}
