package com.example.projectend.service;

import com.example.projectend.entity.*;
import com.example.projectend.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

/**
 * GIO HANG SERVICE - TỐI ƯU
 * Theo cấu trúc mới: GioHang (container) + GioHangChiTiet (items)
 */
@Service
@Transactional
public class GioHangService {

    private static final Logger log = LoggerFactory.getLogger(GioHangService.class);

    @Autowired
    private GioHangRepository gioHangRepository;

    @Autowired
    private GioHangChiTietRepository gioHangChiTietRepository;

    @Autowired
    private SanPhamChiTietRepository sanPhamChiTietRepository;

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @PersistenceContext
    private EntityManager entityManager;

    /**
     * Lấy hoặc tạo giỏ hàng cho user
     */
    public GioHang getOrCreateGioHang(TaiKhoan taiKhoan) {
        return gioHangRepository.findByTaiKhoan_MaTK(taiKhoan.getMaTK())
                .orElseGet(() -> {
                    GioHang gh = new GioHang(taiKhoan);
                    return gioHangRepository.save(gh);
                });
    }

    /**
     * Thêm sản phẩm vào giỏ hàng
     */
    public void addToCart(TaiKhoan taiKhoan, Long maBienThe, int soLuong) {
        // Để đảm bảo tìm đúng dữ liệu mới nhất trong DB (tránh cache của Hibernate)
        entityManager.flush();
        entityManager.clear();

        GioHang gioHang = getOrCreateGioHang(taiKhoan);

        // Khóa đọc bi quan để đảm bảo không đọc giá trị "bị ghi đè" giữa chừng
        SanPhamChiTiet spct = sanPhamChiTietRepository.findLockedById(maBienThe)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sản phẩm"));

        if (soLuong <= 0) throw new RuntimeException("Số lượng không hợp lệ");

        // Tìm item đã có trong giỏ hàng
        Optional<GioHangChiTiet> existingItem = gioHangChiTietRepository
                .findByGioHang_MaGioHangAndSanPhamChiTiet_MaBienThe(gioHang.getMaGioHang(), maBienThe);

        // Đọc tồn kho mới nhất bằng native
        Integer currentStockNative = sanPhamChiTietRepository.findCurrentStockNative(maBienThe);
        int currentStock = currentStockNative != null ? currentStockNative : (spct.getSoLuongTon() != null ? spct.getSoLuongTon() : 0);
        if (currentStock < 0) currentStock = 0;

        if (existingItem.isPresent()) {
            GioHangChiTiet item = existingItem.get();
            int existingQty = item.getSoLuong();
            int newQty = existingQty + soLuong;
            if (newQty > currentStock) {
                int remainingCanAdd = Math.max(currentStock - existingQty, 0);
                throw new RuntimeException("Hết hàng: tồn kho còn " + currentStock + ", bạn đang có " + existingQty + ", chỉ có thể thêm tối đa " + remainingCanAdd);
            }
            item.setSoLuong(newQty);
            gioHangChiTietRepository.save(item);
            entityManager.flush(); // Đẩy xuống DB ngay lập tức
            log.debug("UPDATE_CART_ITEM_OK => maGHCT={}, oldQty={}, added={}, newQty={}", item.getMaGHCT(), existingQty, soLuong, newQty);
        } else {
            if (soLuong > currentStock) {
                throw new RuntimeException("Hết hàng: tồn kho còn " + currentStock);
            }
            GioHangChiTiet newItem = new GioHangChiTiet(gioHang, spct, soLuong);
            gioHangChiTietRepository.save(newItem);
            entityManager.flush(); // Đẩy xuống DB ngay lập tức
            log.debug("CREATE_CART_ITEM_OK => maGHCT={}, soLuong={}, stockSauKhiThem={}", newItem.getMaGHCT(), soLuong, currentStock);
        }
    }

    /**
     * Cập nhật số lượng sản phẩm trong giỏ
     */
    public void updateQuantity(Long maGHCT, int soLuong) {
        Optional<GioHangChiTiet> item = gioHangChiTietRepository.findById(maGHCT);
        if (item.isPresent()) {
            if (soLuong > 0) {
                item.get().setSoLuong(soLuong);
                gioHangChiTietRepository.save(item.get());
            } else {
                gioHangChiTietRepository.deleteById(maGHCT);
            }
        }
    }

    /**
     * Xóa sản phẩm khỏi giỏ
     */
    public void removeFromCart(Long maGHCT) {
        gioHangChiTietRepository.deleteById(maGHCT);
    }

    /**
     * Lấy tất cả items trong giỏ hàng
     */
    public List<GioHangChiTiet> getCartItems(TaiKhoan taiKhoan) {
        GioHang gioHang = getOrCreateGioHang(taiKhoan);
        return gioHangChiTietRepository.findByGioHang_MaGioHang(gioHang.getMaGioHang());
    }

    /**
     * Tính tổng tiền giỏ hàng
     */
    public BigDecimal calculateTotal(TaiKhoan taiKhoan) {
        List<GioHangChiTiet> items = getCartItems(taiKhoan);
        return items.stream()
                .map(item -> item.getSanPhamChiTiet().getGiaBan()
                        .multiply(BigDecimal.valueOf(item.getSoLuong())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * Đếm số lượng items trong giỏ
     */
    public long countCartItems(TaiKhoan taiKhoan) {
        GioHang gioHang = gioHangRepository.findByTaiKhoan_MaTK(taiKhoan.getMaTK())
                .orElse(null);
        if (gioHang == null) return 0;
        return gioHangChiTietRepository.countByGioHang_MaGioHang(gioHang.getMaGioHang());
    }

    /**
     * Tổng số lượng sản phẩm (cộng dồn qty) trong giỏ hàng
     */
    public long sumQuantity(TaiKhoan taiKhoan) {
        GioHang gioHang = gioHangRepository.findByTaiKhoan_MaTK(taiKhoan.getMaTK()).orElse(null);
        if (gioHang == null) return 0L;
        List<GioHangChiTiet> items = gioHangChiTietRepository.findByGioHang_MaGioHang(gioHang.getMaGioHang());
        return items.stream().mapToLong(i -> i.getSoLuong() != null ? i.getSoLuong() : 0).sum();
    }

    /**
     * Xóa toàn bộ giỏ hàng (sau khi đặt hàng)
     */
    public void clearCart(TaiKhoan taiKhoan) {
        GioHang gioHang = gioHangRepository.findByTaiKhoan_MaTK(taiKhoan.getMaTK())
                .orElse(null);
        if (gioHang != null) {
            gioHangChiTietRepository.deleteByGioHang_MaGioHang(gioHang.getMaGioHang());
        }
    }

    /**
     * Lấy danh sách GioHangChiTiet theo TaiKhoan (cho CheckoutController)
     */
    public List<GioHangChiTiet> getGioHangByTaiKhoan(TaiKhoan taiKhoan) {
        return getCartItems(taiKhoan);
    }

    /**
     * Tính tổng tiền từ danh sách GioHangChiTiet (cho CheckoutController)
     */
    public BigDecimal tinhTongTien(List<GioHangChiTiet> items) {
        return items.stream()
                .map(item -> item.getSanPhamChiTiet().getGiaBan()
                        .multiply(BigDecimal.valueOf(item.getSoLuong())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * Xóa giỏ hàng (alias cho clearCart - cho CheckoutController)
     */
    public void clearGioHang(TaiKhoan taiKhoan) {
        clearCart(taiKhoan);
    }

    /**
     * TỐI ƯU: Lấy số lượng items trong giỏ hàng theo email
     */
    public int getCartItemCount(String email) {
        TaiKhoan taiKhoan = taiKhoanRepository.findByEmail(email).orElse(null);
        if (taiKhoan == null) return 0;

        GioHang gioHang = gioHangRepository.findByTaiKhoan_MaTK(taiKhoan.getMaTK()).orElse(null);
        if (gioHang == null) return 0;

        List<GioHangChiTiet> items = gioHangChiTietRepository.findByGioHang_MaGioHang(gioHang.getMaGioHang());
        return items.stream().mapToInt(item -> item.getSoLuong() != null ? item.getSoLuong() : 0).sum();
    }

    /**
     * TỐI ƯU: Lấy danh sách items theo email (cho API)
     */
    public List<GioHangChiTiet> getCartItems(String email) {
        TaiKhoan taiKhoan = taiKhoanRepository.findByEmail(email).orElse(null);
        if (taiKhoan == null) return List.of();

        return getCartItems(taiKhoan);
    }

    /**
     * TỐI ƯU: Thêm sản phẩm vào giỏ hàng - hỗ trợ chọn đúng Size/Màu qua variantId
     */
    public boolean addProductToCart(String email, Long productId, Long variantId, int quantity) {
        try {
            TaiKhoan taiKhoan = taiKhoanRepository.findByEmail(email)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản"));

            Long maBienTheToUse = variantId;

            // Nếu không gửi variantId, hệ thống tự tìm biến thể còn hàng đầu tiên (để đảm bảo tính tương thích cũ)
            if (maBienTheToUse == null) {
                List<SanPhamChiTiet> variants = sanPhamChiTietRepository.findBySanPham_MaSP(productId);
                maBienTheToUse = variants.stream()
                        .filter(v -> v.getSoLuongTon() != null && v.getSoLuongTon() > 0)
                        .map(SanPhamChiTiet::getMaBienThe)
                        .findFirst()
                        .orElseThrow(() -> new RuntimeException("Sản phẩm đã hết hàng"));
            }

            // Thêm vào giỏ hàng với đúng mã biến thể
            addToCart(taiKhoan, maBienTheToUse, quantity);

            log.info("Added product {} (variant {}) to cart for user {}", productId, maBienTheToUse, email);
            return true;

        } catch (Exception e) {
            log.error("Error adding product to cart: {}", e.getMessage());
            return false;
        }
    }
}
