package com.example.projectend.service;

import com.example.projectend.entity.*;
import com.example.projectend.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.Arrays;

@Service
public class VoucherService {

    @Autowired
    private VoucherRepository voucherRepository;

    @Autowired
    private DonHangRepository donHangRepository; // To count user usage

    public List<Voucher> findAll() {
        return voucherRepository.findAll();
    }

    public List<Voucher> findAllActive() {
        return voucherRepository.findAll().stream()
                .filter(v -> v.getTrangThai() && !v.getIsDeleted()).toList();
    }

    public Optional<Voucher> findById(Long id) {
        return voucherRepository.findById(id);
    }

    public Voucher save(Voucher voucher) {
        return voucherRepository.save(voucher);
    }

    public void deleteById(Long id) {
        // Soft Delete
        voucherRepository.findById(id).ifPresent(v -> {
            v.setIsDeleted(true);
            v.setTrangThai(false);
            voucherRepository.save(v);
        });
    }

    /**
     * KIỂM TRA VOUCHER CHUYÊN NGHIỆP
     * @param code Mã nhập vào
     * @param orderAmount Tổng giá trị
     * @param khachHang Thông tin khách hiện tại
     * @param cartItems Sản phẩm trong giỏ (để check category/brand logic)
     */
    public Voucher validateVoucherAdvanced(String code, BigDecimal orderAmount, TaiKhoan khachHang, List<GioHangChiTiet> cartItems) {
        Voucher voucher = voucherRepository.findByCode(code.toUpperCase().trim())
                .orElseThrow(() -> new RuntimeException("Mã Voucher không tồn tại."));

        if (voucher.getIsDeleted() || !voucher.getTrangThai()) {
            throw new RuntimeException("Voucher đã bị vô hiệu hóa.");
        }

        // 1. Kiểm tra thời gian
        LocalDateTime now = LocalDateTime.now();
        if (voucher.getNgayBatDau() != null && now.isBefore(voucher.getNgayBatDau())) {
            throw new RuntimeException("Voucher chưa đến thời điểm áp dụng.");
        }
        if (voucher.getNgayKetThuc() != null && now.isAfter(voucher.getNgayKetThuc())) {
            throw new RuntimeException("Voucher đã hết hạn.");
        }

        // 2. Kiểm tra tổng lượt dùng hệ thống
        if (voucher.getDaSuDung() >= voucher.getSoLuong()) {
            throw new RuntimeException("Hết lượt sử dụng mã này.");
        }

        // 3. Kiểm tra giới hạn lượt dùng mỗi user
        if (khachHang != null) {
            long usedCount = donHangRepository.countByTaiKhoanAndVoucher(khachHang, voucher);
            if (usedCount >= (voucher.getGioiHanUser() != null ? voucher.getGioiHanUser() : 1)) {
                throw new RuntimeException("Bạn đã dùng hết lượt cho mã giảm giá này.");
            }

            // 4. Kiểm tra đối tượng khách hàng (ApDungCho: ALL, NEW, VIP)
            String target = voucher.getApDungCho();
            if ("NEW".equalsIgnoreCase(target)) {
                long totalOrders = donHangRepository.countByTaiKhoan(khachHang);
                if (totalOrders > 0) throw new RuntimeException("Voucher chỉ dành cho đơn hàng đầu tiên.");
            } else if ("VIP".equalsIgnoreCase(target)) {
                // Logic VIP: dựa trên tổng chi tiền
                BigDecimal totalSpent = donHangRepository.sumTotalByTaiKhoan(khachHang.getMaTK());
                if (totalSpent == null) totalSpent = BigDecimal.ZERO;
                if (totalSpent.compareTo(voucher.getMinTotalSpendingVIP() != null ? voucher.getMinTotalSpendingVIP() : BigDecimal.ZERO) < 0) {
                    throw new RuntimeException("Voucher chỉ dành cho khách hàng VIP.");
                }
            }
        }

        // 5. Kiểm tra giá trị đơn hàng tối thiểu
        if (voucher.getGiaTriToiThieu() != null && orderAmount.compareTo(voucher.getGiaTriToiThieu()) < 0) {
            throw new RuntimeException("Đơn hàng chưa đạt giá trị tối thiểu " + formatPrice(voucher.getGiaTriToiThieu()));
        }

        // 6. Kiểm tra Danh mục / Thương hiệu (Nâng cao)
        // Nếu Voucher giới hạn thì phải có ít nhất 1 sp thuộc list đó
        if (cartItems != null && !cartItems.isEmpty()) {
            if (voucher.getMaLoaiApDung() != null && !voucher.getMaLoaiApDung().isBlank()) {
                List<String> validIds = Arrays.asList(voucher.getMaLoaiApDung().split(","));
                boolean hasValid = cartItems.stream()
                    .anyMatch(i -> validIds.contains(String.valueOf(i.getSanPhamChiTiet().getSanPham().getLoaiSanPham().getMaLoai())));
                if (!hasValid) throw new RuntimeException("Voucher không áp dụng cho danh mục sản phẩm này.");
            }
            // Tương tự cho Brand... (Logic này có thể mở rộng thêm)
        }

        return voucher;
    }

    public List<Voucher> getAvailableForUser(TaiKhoan khachHang, BigDecimal orderAmount) {
        LocalDateTime now = LocalDateTime.now();
        List<Voucher> allVouchers = voucherRepository.findAll();

        return allVouchers.stream()
            .filter(v -> v.getTrangThai() && !v.getIsDeleted())
            .filter(v -> (v.getNgayBatDau() == null || now.isAfter(v.getNgayBatDau())) &&
                         (v.getNgayKetThuc() == null || now.isBefore(v.getNgayKetThuc())))
            .filter(v -> v.getDaSuDung() < v.getSoLuong())
            .filter(v -> v.getGiaTriToiThieu() == null || orderAmount.compareTo(v.getGiaTriToiThieu()) >= 0)
            .filter(v -> {
                if (khachHang == null) {
                    // Đối với khách vãng lai, chỉ hiện voucher cho ALL
                    return "ALL".equalsIgnoreCase(v.getApDungCho());
                }
                
                // Lượt dùng của user
                long usedCount = donHangRepository.countByTaiKhoanAndVoucher(khachHang, v);
                if (usedCount >= (v.getGioiHanUser() != null ? v.getGioiHanUser() : 1)) return false;

                // NEW / VIP
                if ("NEW".equalsIgnoreCase(v.getApDungCho())) {
                    return donHangRepository.countByTaiKhoan(khachHang) == 0;
                }
                if ("VIP".equalsIgnoreCase(v.getApDungCho())) {
                    BigDecimal totalSpent = donHangRepository.sumTotalByTaiKhoan(khachHang.getMaTK());
                    if (totalSpent == null) totalSpent = BigDecimal.ZERO;
                    return totalSpent.compareTo(v.getMinTotalSpendingVIP() != null ? v.getMinTotalSpendingVIP() : BigDecimal.ZERO) >= 0;
                }
                
                return true;
            })
            .toList();
    }

    private String formatPrice(BigDecimal price) {
        return new java.text.DecimalFormat("###,###,###").format(price) + "đ";
    }

    // LEGACY SUPPORT
    public Voucher validateVoucher(String code, BigDecimal amount) {
        return validateVoucherAdvanced(code, amount, null, null);
    }
}
