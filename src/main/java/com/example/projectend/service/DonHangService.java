package com.example.projectend.service;

import com.example.projectend.entity.*;
import com.example.projectend.repository.*;
import jakarta.transaction.Transactional;
import java.time.LocalDateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

/**
 * SERVICE XỬ LÝ ĐƠN HÀNG - HOÀN CHỈNH
 */
@Service
public class DonHangService {
    private static final Logger log = LoggerFactory.getLogger(DonHangService.class);

    @Autowired
    private DonHangRepository donHangRepository;

    @Autowired
    private DanhGiaRepository danhGiaRepository;

    @Autowired
    private DonHangChiTietRepository donHangChiTietRepository;

    @Autowired
    private DiaChiRepository diaChiRepository;

    @Autowired
    private PhuongThucThanhToanRepository phuongThucThanhToanRepository;

    @Autowired
    private SanPhamChiTietRepository sanPhamChiTietRepository;

    @Autowired
    private LichSuDonHangRepository lichSuDonHangRepository;

    @Autowired
    private ThanhToanRepository thanhToanRepository;

    @Autowired
    private VoucherRepository voucherRepository;

    /**
     * TẠO ĐƠN HÀNG MỚI - HOÀN CHỈNH
     */
    @Transactional
    public DonHang createDonHang(TaiKhoan taiKhoan, Long diaChiId, Long phuongThucTTId,
            List<GioHangChiTiet> gioHangItems, String ghiChu, Long voucherId) {

        // 1. Validate
        if (gioHangItems == null || gioHangItems.isEmpty()) {
            throw new RuntimeException("Giỏ hàng trống!");
        }

        if (diaChiId == null)
            throw new IllegalArgumentException("diaChiId is null");
        if (phuongThucTTId == null)
            throw new IllegalArgumentException("phuongThucTTId is null");

        // 2. Lấy địa chỉ giao hàng
        DiaChi diaChi = diaChiRepository.findById(diaChiId)
                .orElseThrow(() -> new RuntimeException("Địa chỉ không tồn tại!"));

        // 3. Lấy phương thức thanh toán
        PhuongThucThanhToan phuongThuc = phuongThucThanhToanRepository.findById(phuongThucTTId)
                .orElseThrow(() -> new RuntimeException("Phương thức thanh toán không hợp lệ!"));

        // 4. Tạo đơn hàng
        DonHang donHang = new DonHang();
        donHang.setTaiKhoan(taiKhoan);
        donHang.setDiaChiGiao(diaChi);
        donHang.setHinhThucThanhToan(phuongThuc);
        donHang.setGhiChu(ghiChu);

        // Mặc định là Chờ xác nhận (0), nếu là PayOS thì là Chờ thanh toán (7)
        boolean isPayOS = phuongThuc.getTenHinhThuc() != null
                && phuongThuc.getTenHinhThuc().toLowerCase().contains("payos");
        donHang.setTrangThaiDH(isPayOS ? TrangThaiDonHang.CHO_THANH_TOAN : TrangThaiDonHang.CHO_XAC_NHAN);

        // PENDING (0) cho PayOS, COD-Chưa thu (4) cho COD
        donHang.setTrangThaiThanhToan(isPayOS ? 0 : 4);

        donHang.setNgayDat(LocalDateTime.now());
        donHang.setNgayCapNhat(LocalDateTime.now());

        // 5. Tính tổng tiền và tạo chi tiết đơn hàng
        BigDecimal tongTien = BigDecimal.ZERO;

        for (GioHangChiTiet item : gioHangItems) {
            SanPhamChiTiet spct = item.getSanPhamChiTiet();

            // Kiểm tra tồn kho (LUÔN kiểm tra, dù PayOS hay COD)
            if (spct.getSoLuongTon() < item.getSoLuong()) {
                throw new RuntimeException("Sản phẩm " + spct.getSanPham().getTenSP() +
                        " không đủ số lượng trong kho! (Còn " + spct.getSoLuongTon() + ")");
            }

            // Tạo chi tiết đơn hàng
            DonHangChiTiet chiTiet = new DonHangChiTiet();
            chiTiet.setDonHang(donHang);
            chiTiet.setSanPhamChiTiet(spct);
            chiTiet.setSoLuong(item.getSoLuong());
            chiTiet.setDonGia(spct.getGiaBan());

            BigDecimal thanhTien = spct.getGiaBan().multiply(BigDecimal.valueOf(item.getSoLuong()));
            tongTien = tongTien.add(thanhTien);

            donHang.getChiTietList().add(chiTiet);

            // ✅ CHỈ trừ tồn kho ngay với COD, KHÔNG trừ với PayOS
            // PayOS sẽ trừ kho khi webhook/return xác nhận PAID
            if (!isPayOS) {
                spct.setSoLuongTon(spct.getSoLuongTon() - item.getSoLuong());
                sanPhamChiTietRepository.save(spct);
            }
        }

        donHang.setTongTien(tongTien);

        // 5b. Tính phí vận chuyển (Marketing Logic: Mặc định 30k, Free ship từ 2 SP)
        int totalQuantity = gioHangItems.stream().mapToInt(GioHangChiTiet::getSoLuong).sum();
        BigDecimal phiShip = (totalQuantity >= 2) ? BigDecimal.ZERO : new BigDecimal(30000);
        donHang.setPhiShip(phiShip);

        // Cộng phí ship vào tổng tiền trước khi áp voucher
        tongTien = tongTien.add(phiShip);
        donHang.setTongTien(tongTien);

        // 5b. Xử lý Voucher nếu có (Nâng cấp theo thiết kế db.sql)
        if (voucherId != null) {
            Voucher voucher = voucherRepository.findById(voucherId).orElse(null);
            LocalDateTime now = LocalDateTime.now();

            if (voucher != null && Boolean.TRUE.equals(voucher.getTrangThai())
                    && !Boolean.TRUE.equals(voucher.getIsDeleted())) {

                // 1. Kiểm tra thời hạn
                if (voucher.getNgayBatDau() != null && now.isBefore(voucher.getNgayBatDau())) {
                    throw new RuntimeException("Voucher chưa đến thời gian áp dụng");
                }
                if (voucher.getNgayKetThuc() != null && now.isAfter(voucher.getNgayKetThuc())) {
                    throw new RuntimeException("Voucher đã hết hạn");
                }

                // 2. Kiểm tra số lượng
                if (voucher.getSoLuong() != null && voucher.getDaSuDung() >= voucher.getSoLuong()) {
                    throw new RuntimeException("Voucher đã hết lượt sử dụng");
                }

                // 3. Kiểm tra giá trị tối thiểu
                BigDecimal minVal = voucher.getGiaTriToiThieu() != null ? voucher.getGiaTriToiThieu() : BigDecimal.ZERO;
                if (tongTien.compareTo(minVal) < 0) {
                    throw new RuntimeException("Đơn hàng chưa đạt giá trị tối thiểu để dùng voucher này");
                }

                // 4. Kiểm tra điều kiện Thương hiệu / Danh mục (Nếu có)
                boolean matchesCondition = true;
                if ((voucher.getMaLoaiApDung() != null && !voucher.getMaLoaiApDung().isBlank()) ||
                        (voucher.getMaTHApDung() != null && !voucher.getMaTHApDung().isBlank())) {
                    matchesCondition = false;
                    for (GioHangChiTiet item : gioHangItems) {
                        SanPham sp = item.getSanPhamChiTiet().getSanPham();

                        // Kiểm tra danh mục
                        if (voucher.getMaLoaiApDung() != null && !voucher.getMaLoaiApDung().isBlank()) {
                            String[] allowedLoai = voucher.getMaLoaiApDung().split(",");
                            for (String idStr : allowedLoai) {
                                if (sp.getLoaiSanPham() != null
                                        && sp.getLoaiSanPham().getMaLoai().toString().equals(idStr.trim())) {
                                    matchesCondition = true;
                                    break;
                                }
                            }
                        }

                        // Kiểm tra thương hiệu
                        if (voucher.getMaTHApDung() != null && !voucher.getMaTHApDung().isBlank()) {
                            String[] allowedTH = voucher.getMaTHApDung().split(",");
                            for (String idStr : allowedTH) {
                                if (sp.getThuongHieu() != null
                                        && sp.getThuongHieu().getMaTH().toString().equals(idStr.trim())) {
                                    matchesCondition = true;
                                    break;
                                }
                            }
                        }
                        if (matchesCondition)
                            break;
                    }
                }

                if (!matchesCondition) {
                    throw new RuntimeException("Voucher không áp dụng cho các sản phẩm trong giỏ hàng của bạn");
                }

                // 5. Tính toán giảm giá
                BigDecimal discount = BigDecimal.ZERO;
                if (voucher.getLoaiGiamGia() == 0) { // Phần trăm
                    // Use scale 2 and HALF_UP to avoid ArithmeticException on non-terminating
                    // decimals
                    discount = tongTien.multiply(voucher.getGiaTri()).divide(new BigDecimal(100), 2,
                            java.math.RoundingMode.HALF_UP);
                    if (voucher.getGiaTriToiDa() != null && discount.compareTo(voucher.getGiaTriToiDa()) > 0) {
                        discount = voucher.getGiaTriToiDa();
                    }
                } else { // Số tiền cố định
                    discount = voucher.getGiaTri() != null ? voucher.getGiaTri() : BigDecimal.ZERO;
                }

                if (discount.compareTo(tongTien) > 0)
                    discount = tongTien;

                donHang.setVoucher(voucher);
                donHang.setGiamGia(discount);

                // Cập nhật lượt dùng
                voucher.setDaSuDung(voucher.getDaSuDung() + 1);
                voucherRepository.save(voucher);

                // TRỪ GIẢM GIÁ VÀO TỔNG TIỀN CUỐI CÙNG
                donHang.setTongTien(tongTien.subtract(discount));
            }
        }

        // 6. Lưu đơn hàng
        DonHang savedDonHang = donHangRepository.save(donHang);

        // 7. Tạo lịch sử đơn hàng (trạng thái đầu tiên)
        LichSuDonHang lichSu = new LichSuDonHang(
                savedDonHang,
                -1, // Không có trạng thái cũ (đơn mới)
                0, // Chờ xác nhận
                taiKhoan.getHoTen(),
                "Đơn hàng được tạo");
        lichSuDonHangRepository.save(lichSu);

        return savedDonHang;
    }

    /**
     * LẤY ĐƠN HÀNG THEO ID VÀ KHÁCH HÀNG
     */
    public Optional<DonHang> findByIdAndKhachHang(Long maDH, TaiKhoan taiKhoan) {
        return donHangRepository.findByMaDHAndTaiKhoan_MaTK(maDH, taiKhoan.getMaTK());
    }

    /**
     * LẤY CHI TIẾT ĐƠN HÀNG
     */
    public List<DonHangChiTiet> getChiTietDonHang(DonHang donHang) {
        return donHangChiTietRepository.findByDonHang_MaDH(donHang.getMaDH());
    }

    /**
     * ✅ ĐỒNG BỘ: Cập nhật thanh toán thành công và trừ tồn kho
     * Chỉ dùng cho PayOS (vì PayOS không trừ khi tạo đơn)
     */
    @Transactional
    public void confirmPaymentAndDeductStock(Long orderId) {
        if (orderId == null)
            return;
        DonHang dh = donHangRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng #" + orderId));

        // 1. Kiểm tra trạng thái thanh toán trước khi xử lý (Phòng ngừa race condition
        // / double callback)
        if (dh.getTrangThaiThanhToan() == 1) { // 1 = PAID
            log.info("⚠️ Đơn hàng #{} đã được xác nhận thanh toán trước đó, bỏ qua.", orderId);
            return;
        }

        // 2. Cập nhật trạng thái thanh toán
        dh.setTrangThaiThanhToan(1); // PAID (1)

        // 3. Cập nhật trạng thái đơn hàng (Chờ thanh toán 7 -> Chờ xác nhận 0)
        if (dh.getTrangThaiDH() == TrangThaiDonHang.CHO_THANH_TOAN ||
                dh.getTrangThaiDH() == TrangThaiDonHang.LOI_THANH_TOAN) {
            dh.setTrangThaiDH(TrangThaiDonHang.CHO_XAC_NHAN);
        }

        dh.setNgayCapNhat(LocalDateTime.now());

        // 4. TRỪ TỒN KHO (Logic đồng bộ: PayOS chỉ trừ ở đây)
        for (DonHangChiTiet ct : dh.getChiTietList()) {
            SanPhamChiTiet spct = ct.getSanPhamChiTiet();
            int newStock = Math.max(0, spct.getSoLuongTon() - ct.getSoLuong());
            spct.setSoLuongTon(newStock);
            sanPhamChiTietRepository.save(spct);
            log.info("✅ Trừ kho PayOS: Đơn #{} - SP {} - Tồn kho còn {}",
                    orderId, spct.getMaBienThe(), newStock);
        }

        donHangRepository.save(dh);

        // ✅ Ghi lại giao dịch thanh toán
        ThanhToan tt = new ThanhToan();
        tt.setDonHang(dh);
        tt.setSoTien(dh.getTongTien());
        tt.setTrangThai("COMPLETED");
        tt.setGateway("PayOS");
        tt.setTransactionID(dh.getMaGiaoDich());
        tt.setNgayTao(LocalDateTime.now());
        thanhToanRepository.save(tt);

        // 5. Ghi lịch sử đơn hàng
        capNhatTrangThai(orderId, dh.getTrangThaiDH(), "PayOS System", "Đã nhận thanh toán từ PayOS");
    }

    @Transactional
    public void handlePaymentExpired(Long orderId) {
        if (orderId == null)
            return;
        DonHang dh = donHangRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng #" + orderId));

        // 1. Kiểm tra trạng thái thanh toán trước khi xử lý (Phòng ngừa race condition
        // / double callback)
        if (dh.getTrangThaiThanhToan() == 1) { // 1 = PAID
            log.info("⚠️ Đơn hàng #{} đã được xác nhận thanh toán trước đó, bỏ qua.", orderId);
            return;
        }

        // 2. Cập nhật trạng thái thanh toán
        dh.setTrangThaiThanhToan(2); // EXPIRED (2)

        // 3. Cập nhật trạng thái đơn hàng (Chờ thanh toán 7 -> Lỗi thanh toán 8)
        if (dh.getTrangThaiDH() == TrangThaiDonHang.CHO_THANH_TOAN) {
            dh.setTrangThaiDH(TrangThaiDonHang.LOI_THANH_TOAN);
            dh.setLyDoHuy("Thanh toán PayOS đã hết hạn hoặc bị hủy");
        }

        dh.setNgayCapNhat(LocalDateTime.now());
        donHangRepository.save(dh);

        // 5. Ghi lịch sử đơn hàng
        capNhatTrangThai(orderId, dh.getTrangThaiDH(), "PayOS System", "Đơn hàng hết hạn thanh toán");
    }

    public List<DonHang> findAll() {
        return donHangRepository.findAllByOrderByNgayDatDesc();
    }

    @SuppressWarnings("null")
    public void updateStatus(Long id, Integer status, String reason) {

        DonHang dh = donHangRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn"));

        Integer currentStatus = dh.getTrangThaiDH();

        // Cho phép 8 (Lỗi) -> 4 (Hoàn tất)
        if (currentStatus == 8 && status == 4) {
            // Hợp lệ
        } else if (status < currentStatus) {
            throw new RuntimeException("Không thể quay lại trạng thái cũ");
        }

        dh.setTrangThaiDH(status);
        dh.setNgayCapNhat(LocalDateTime.now());

        if (status == 4) {
            dh.setTrangThaiThanhToan(1);

            // Tạo bản ghi thanh toán nếu chưa có
            ThanhToan tt = new ThanhToan();
            tt.setDonHang(dh);
            tt.setSoTien(dh.getTongTien().add(dh.getPhiShip()));
            tt.setTrangThai("COMPLETED");
            tt.setGateway(dh.getHinhThucThanhToan() != null ? dh.getHinhThucThanhToan().getTenHinhThuc() : "COD");
            tt.setNgayTao(LocalDateTime.now());
            thanhToanRepository.save(tt);
        }

        if (status == 5 || status == 8) {
            dh.setLyDoHuy(reason);
        }

        donHangRepository.save(dh);

    }

    /**
     * KHÁCH BÁO CHƯA NHẬN ĐƯỢC HÀNG
     */
    @Transactional
    public void reportOrderNotReceived(Long id, String reason, String description) {
        if (id == null)
            return;
        DonHang dh = donHangRepository.findById(id).orElse(null);
        if (dh == null)
            return;

        if (dh.getTrangThaiDH() != 3) {
            throw new RuntimeException("Chỉ có thể báo lỗi khi đơn hàng đang ở trạng thái Đã giao");
        }

        dh.setKhachBaoChuaNhan(true);
        dh.setLyDoChuaNhan(reason);
        dh.setMoTaChuaNhan(description);
        dh.setNgayCapNhat(LocalDateTime.now());
        donHangRepository.save(dh);

        // Ghi log
        LichSuDonHang history = new LichSuDonHang();
        history.setDonHang(dh);
        history.setTrangThaiCu(3);
        history.setTrangThaiMoi(3);
        history.setNguoiCapNhat("KHACHHANG");
        history.setGhiChu("Khách báo chưa nhận được hàng: " + reason);
        history.setThoiGian(LocalDateTime.now());
        lichSuDonHangRepository.save(history);
    }

    /**
     * LẤY TẤT CẢ ĐƠN HÀNG CỦA KHÁCH HÀNG
     */
    public List<DonHang> getDonHangByKhachHang(TaiKhoan tk) {
        return donHangRepository.findByTaiKhoan_MaTKOrderByNgayDatDesc(tk.getMaTK());
    }

    /**
     * CẬP NHẬT TRẠNG THÁI ĐƠN HÀNG (CHỈ TIẾN LÊN, KHÔNG LÙI LẠI) + GHI LỊCH SỬ
     */
    @Transactional
    public boolean capNhatTrangThai(Long maDH, Integer trangThaiMoi, String nguoiCapNhat, String ghiChu) {
        if (maDH == null)
            return false;

        Optional<DonHang> dhOpt = donHangRepository.findById(maDH);
        if (!dhOpt.isPresent()) {
            return false;
        }

        DonHang donHang = dhOpt.get();
        Integer trangThaiCu = donHang.getTrangThaiDH();

        // Kiểm tra: chỉ cho phép tiến lên, không được lùi lại
        // NGOẠI LỆ: Cho phép từ 7 (Chờ thanh toán) sang các trạng thái khác (0, 8, 5)
        if (trangThaiCu == 7 && (trangThaiMoi == 0 || trangThaiMoi == 8 || trangThaiMoi == 5)) {
            // Hợp lệ
        } else if (trangThaiCu != 7 && trangThaiMoi <= trangThaiCu && trangThaiCu != 0) {
            throw new RuntimeException("Không thể quay lại trạng thái trước đó!");
        }

        // Không cho phép cập nhật nếu đã kết thúc (5: Hủy, 6: Đã đánh giá)
        // NGOẠI LỆ: Cho phép từ 4 (Hoàn tất) sang 6 (Đã đánh giá)
        if (trangThaiCu == 5 || trangThaiCu == 6 || (trangThaiCu == 4 && trangThaiMoi != 6)) {
            throw new RuntimeException("Đơn hàng đã kết thúc, không thể cập nhật!");
        }

        // Cập nhật trạng thái
        donHang.setTrangThaiDH(trangThaiMoi);

        // LOGIC HOÀN TIỀN: Nếu đơn hàng đã THANH TOÁN (1) mà bị HỦY (5)
        if (trangThaiMoi == 5 && donHang.getTrangThaiThanhToan() == 1) {
            donHang.setTrangThaiThanhToan(5); // Chờ hoàn tiền
            log.info("⚠️ Đơn hàng #{} đã thanh toán bị hủy, chuyển sang trạng thái CHỜ HOÀN TIỀN", maDH);
        }

        if (trangThaiMoi == 5 || trangThaiMoi == 8) {
            donHang.setLyDoHuy(ghiChu);
        }
        donHang.setNgayCapNhat(LocalDateTime.now());

        // Nếu đã giao hàng (Hoàn tất) thì đánh dấu đã thanh toán
        if (trangThaiMoi == 4) {
            donHang.setTrangThaiThanhToan(1);

            // Tạo bản ghi thanh toán
            ThanhToan tt = new ThanhToan();
            tt.setDonHang(donHang);
            tt.setSoTien(donHang.getTongTien().add(donHang.getPhiShip()));
            tt.setTrangThai("COMPLETED");
            tt.setGateway(
                    donHang.getHinhThucThanhToan() != null ? donHang.getHinhThucThanhToan().getTenHinhThuc() : "COD");
            tt.setNgayTao(LocalDateTime.now());
            thanhToanRepository.save(tt);
        }

        // LOGIC HOÀN KHO KHI HỦY ĐƠN:
        // 1. Trạng thái mới là Đã hủy (5)
        // 2. Trạng thái cũ < 5 (0, 1, 2, 3) => Chắc chắn đã trừ tồn kho
        // 3. Trạng thái cũ 8, 7 (PayOS lỗi/chờ) => Chưa trừ tồn kho
        if (trangThaiCu == 8 || trangThaiCu == 7) {
            // Không hoàn kho vì chưa trừ
        } else if (trangThaiCu < 5 && trangThaiMoi == TrangThaiDonHang.DA_HUY) {
            for (DonHangChiTiet ct : donHang.getChiTietList()) {
                SanPhamChiTiet spct = ct.getSanPhamChiTiet();
                spct.setSoLuongTon(spct.getSoLuongTon() + ct.getSoLuong());
                sanPhamChiTietRepository.save(spct);
                log.info("✅ Hoàn kho khi hủy đơn #{}: SP {} +{}", donHang.getMaDH(), spct.getMaBienThe(),
                        ct.getSoLuong());
            }
        }

        donHangRepository.save(donHang);

        // Ghi lịch sử thay đổi
        LichSuDonHang lichSu = new LichSuDonHang(
                donHang,
                trangThaiCu,
                trangThaiMoi,
                nguoiCapNhat,
                ghiChu != null ? ghiChu : "Cập nhật trạng thái đơn hàng");
        lichSuDonHangRepository.save(lichSu);

        return true;
    }

    /**
     * CẬP NHẬT TRẠNG THÁI (OVERLOAD - TỰ ĐỘNG LẤY NGƯỜI CẬP NHẬT)
     */
    @Transactional
    /**
     * Kiểm tra và cập nhật trạng thái đơn hàng sang "Đã đánh giá" (6)
     * nếu tất cả các sản phẩm trong đơn hàng đã được đánh giá.
     */
    public void checkAndUpdateOrderStatusAfterReview(Long maDH) {
        if (maDH == null)
            return;
        DonHang donHang = donHangRepository.findById(maDH).orElse(null);
        if (donHang == null)
            return;

        // Nếu trạng thái hiện tại không phải là Hoàn tất (4) hoặc Đã giao (3) thì không
        // làm gì
        // Thường khách sẽ đánh giá ở trạng thái 4
        if (donHang.getTrangThaiDH() != 4 && donHang.getTrangThaiDH() != 3) {
            return;
        }

        boolean allReviewed = true;
        List<DonHangChiTiet> chiTietList = donHang.getChiTietList();

        for (DonHangChiTiet ct : chiTietList) {
            // Kiểm tra xem chi tiết này đã có đánh giá chưa
            // Cần DanhGiaRepository hoặc kiểm tra thông qua chi tiết
            // Giả sử có DanhGiaRepository được @Autowired
            if (!danhGiaRepository.findByDonHangChiTiet(ct).isPresent()) {
                allReviewed = false;
                break;
            }
        }

        if (allReviewed) {
            capNhatTrangThai(maDH, 6, "Hệ thống", "Hệ thống tự động chuyển sang Đã đánh giá");
        }
    }

    public boolean capNhatTrangThai(Long maDH, Integer trangThaiMoi) {
        return capNhatTrangThai(maDH, trangThaiMoi, "Hệ thống", null);
    }

    /**
     * CẬP NHẬT TRẠNG THÁI (ALIAS CHO STAFF CONTROLLER)
     */
    @Transactional
    public boolean updateOrderStatus(Long orderId, Integer newStatus, String updatedBy) {
        if (orderId == null)
            return false;
        return capNhatTrangThai(orderId, newStatus, updatedBy, null);
    }

    /**
     * LẤY LỊCH SỬ ĐƠN HÀNG
     */
    @SuppressWarnings("null")
    public List<LichSuDonHang> getLichSuDonHang(Long maDH) {
        return lichSuDonHangRepository.findByDonHang_MaDHOrderByThoiGianAsc(maDH);
    }

    /**
     * HỦY ĐƠN HÀNG (CHỈ KHI ĐANG CHỜ XÁC NHẬN) + GHI LỊCH SỬ
     */
    @Transactional
    public boolean huyDonHang(Long maDH, TaiKhoan taiKhoan) {
        Optional<DonHang> dhOpt = donHangRepository.findByMaDHAndTaiKhoan_MaTK(maDH, taiKhoan.getMaTK());
        if (!dhOpt.isPresent()) {
            return false;
        }

        DonHang donHang = dhOpt.get();
        Integer trangThaiCu = donHang.getTrangThaiDH();

        // Chỉ cho phép hủy khi đang chờ xác nhận
        if (trangThaiCu != 0) {
            throw new RuntimeException("Chỉ có thể hủy đơn hàng đang chờ xác nhận!");
        }

        donHang.setTrangThaiDH(5); // Đã hủy
        donHang.setNgayCapNhat(LocalDateTime.now());

        // Hoàn lại tồn kho
        for (DonHangChiTiet ct : donHang.getChiTietList()) {
            SanPhamChiTiet spct = ct.getSanPhamChiTiet();
            spct.setSoLuongTon(spct.getSoLuongTon() + ct.getSoLuong());
            sanPhamChiTietRepository.save(spct);
        }

        donHangRepository.save(donHang);

        // Ghi lịch sử hủy đơn
        LichSuDonHang lichSu = new LichSuDonHang(
                donHang,
                trangThaiCu,
                5,
                taiKhoan.getHoTen(),
                "Khách hàng hủy đơn hàng");
        lichSuDonHangRepository.save(lichSu);

        return true;
    }

    /**
     * LẤY TẤT CẢ ĐƠN HÀNG (CHO ADMIN/NHÂN VIÊN)
     */
    public List<DonHang> getAllDonHang() {
        return donHangRepository.findAllByOrderByNgayDatDesc();
    }

    /**
     * TÌM ĐƠN HÀNG THEO ID
     */
    public Optional<DonHang> findById(Long maDH) {
        if (maDH == null)
            return Optional.empty();
        return donHangRepository.findById(maDH);
    }

    /**
     * TÌM ĐƠN HÀNG THEO MÃ GIAO DỊCH PAYOS
     */
    public Optional<DonHang> findByMaGiaoDich(String maGiaoDich) {
        return donHangRepository.findByMaGiaoDich(maGiaoDich);
    }

    /**
     * LƯU ĐƠN HÀNG (dùng cho cập nhật)
     */
    @Transactional
    public DonHang save(DonHang donHang) {
        return donHangRepository.save(donHang);
    }

    /**
     * ĐẾM TẤT CẢ ĐƠN HÀNG
     */
    public long countAll() {
        return donHangRepository.count();
    }

    /**
     * LẤY ĐƠN HÀNG GẦN ĐÂY
     */
    public List<DonHang> getRecentOrders(int limit) {
        PageRequest pageRequest = PageRequest.of(0, limit);
        Page<DonHang> page = donHangRepository.findAllByOrderByNgayDatDesc(pageRequest);
        return page.getContent();
    }

    /**
     * LẤY ĐƠN HÀNG THEO TRẠNG THÁI VỚI PHÂN TRANG
     */
    public Page<DonHang> getDonHangByTrangThai(Integer trangThai, Pageable pageable) {
        if (trangThai == null) {
            return donHangRepository.findAllByOrderByNgayDatDesc(pageable);
        }
        return donHangRepository.findByTrangThaiDHOrderByNgayDatDesc(trangThai, pageable);
    }

    /**
     * LẤY TẤT CẢ ĐƠN HÀNG VỚI PHÂN TRANG
     */
    public Page<DonHang> getAllDonHangPage(Pageable pageable) {
        return donHangRepository.findAllByOrderByNgayDatDesc(pageable);
    }

    /**
     * SEARCH ADMIN (keyword = name/email; trangThai = mã hoặc tên; timeRange =
     * day/week/month/year)
     */
    public Page<DonHang> searchAdmin(String keyword, String trangThai, String startDateStr, String endDateStr,
            Pageable pageable) {
        Integer statusCode = null;
        if (trangThai != null && !trangThai.isBlank()) {
            statusCode = convertStatusToCodeFlexible(trangThai.trim());
        }

        LocalDateTime startDate = null;
        LocalDateTime endDate = null;

        try {
            if (startDateStr != null && !startDateStr.isBlank()) {
                startDate = java.time.LocalDate.parse(startDateStr).atStartOfDay();
            }
            if (endDateStr != null && !endDateStr.isBlank()) {
                endDate = java.time.LocalDate.parse(endDateStr).atTime(23, 59, 59);
            }
        } catch (Exception e) {
            log.error("Lỗi parse ngày: " + e.getMessage());
        }

        String cleanKeyword = (keyword != null && !keyword.isBlank()) ? keyword.trim() : null;

        return donHangRepository.searchAdvanced(cleanKeyword, statusCode, startDate, endDate, pageable);
    }

    /**
     * Lấy đơn hàng đang chờ xác nhận (trangThaiDH = 0) với giới hạn.
     */
    public List<DonHang> getPendingOrders(int limit) {
        List<DonHang> list = donHangRepository.findByTrangThaiDHOrderByNgayDatDesc(0);
        if (list.isEmpty())
            return Collections.emptyList();
        if (limit <= 0)
            limit = 5;
        return list.size() <= limit ? list : list.subList(0, limit);
    }

    public List<DonHang> getRecentOrdersForStaff(int limit) {

        return donHangRepository
                .findTop10ByTrangThaiDHInOrderByNgayDatDesc(List.of(0, 1, 2));

    }

    /**
     * Chi tiết đơn hàng qua ID đơn hàng.
     */
    public List<DonHangChiTiet> getOrderDetails(Long maDH) {
        return donHangChiTietRepository.findByDonHang_MaDH(maDH);
    }

    /**
     * Đếm số đơn hàng pending (badge header.html admin).
     */
    public long countPending() {
        return donHangRepository.countByTrangThaiDH(0);
    }

    /**
     * Convert linh hoạt tên / số trạng thái sang mã.
     */
    private Integer convertStatusToCodeFlexible(String s) {
        if (s == null)
            return null;
        // Nếu là số
        try {
            return Integer.parseInt(s);
        } catch (NumberFormatException ignored) {
        }
        return switch (s.toLowerCase()) {
            case "chờ xác nhận" -> 0;
            case "đã xác nhận" -> 1;
            case "đang giao" -> 2;
            case "đã giao" -> 3;
            case "hoàn tất" -> 4;
            case "đã hủy", "hủy" -> 5;
            default -> null;
        };
    }

    /**
     * Tự động hoàn tất đơn hàng sau 3 ngày nếu khách không xác nhận.
     * Chạy vào lúc 1:00 AM mỗi ngày.
     */
    @Scheduled(cron = "0 0 1 * * ?")
    @Transactional
    public void autoConfirmOrders() {
        LocalDateTime threeDaysAgo = LocalDateTime.now().minusDays(3);
        // Trạng thái 3: Đã giao
        List<DonHang> ordersToComplete = donHangRepository.findByTrangThaiDHAndNgayCapNhatBefore(3, threeDaysAgo);

        for (DonHang donHang : ordersToComplete) {
            donHang.setTrangThaiDH(4); // Hoàn tất
            donHang.setNgayCapNhat(LocalDateTime.now());
            donHangRepository.save(donHang);

            // Ghi log lịch sử
            LichSuDonHang history = new LichSuDonHang();
            history.setDonHang(donHang);
            history.setTrangThaiCu(3); // Đã giao
            history.setTrangThaiMoi(4); // Hoàn tất
            history.setNguoiCapNhat("SYSTEM");
            history.setGhiChu("Hệ thống tự động hoàn tất (Quá 3 ngày)");
            history.setThoiGian(LocalDateTime.now());
            lichSuDonHangRepository.save(history);
        }
    }

    /**
     * Tự động hủy các đơn hàng PayOS "Chờ thanh toán" sau 5 phút.
     * Chạy mỗi phút một lần.
     */
    @Scheduled(cron = "0 * * * * ?") // Chạy mỗi 1 phút một lần
    @Transactional
    public void cancelFailedPayOSOrders() {
        LocalDateTime fiveMinsAgo = LocalDateTime.now().minusMinutes(5);

        // Tìm các đơn Chờ thanh toán (7) quá 5 phút
        List<DonHang> ordersToCancel = donHangRepository.findByTrangThaiDHAndNgayDatBefore(
                TrangThaiDonHang.CHO_THANH_TOAN, fiveMinsAgo);

        for (DonHang dh : ordersToCancel) {
            dh.setTrangThaiDH(TrangThaiDonHang.DA_HUY); // Chuyển sang Đã hủy
            dh.setTrangThaiThanhToan(3); // EXPIRED (3)
            dh.setLyDoHuy("Quá thời gian thanh toán (Hệ thống tự động hủy sau 5 phút)");
            dh.setNgayCapNhat(LocalDateTime.now());

            // ✅ ĐỒNG BỘ: Không hoàn kho vì PayOS chưa từng trừ kho
            donHangRepository.save(dh);

            // Ghi log lịch sử
            LichSuDonHang history = new LichSuDonHang(
                    dh,
                    TrangThaiDonHang.CHO_THANH_TOAN,
                    TrangThaiDonHang.DA_HUY,
                    "SYSTEM",
                    "Thanh toán quá hạn 5 phút (Hệ thống tự động hủy)");
            lichSuDonHangRepository.save(history);
        }
    }

    /**
     * Xác nhận đã hoàn tiền thủ công cho khách hàng
     */
    @Transactional
    public void xacNhanDaHoanTien(Long maDH, String ghiChuAdmin) {
        DonHang dh = donHangRepository.findById(maDH)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng #" + maDH));

        if (dh.getTrangThaiThanhToan() != 5) {
            throw new RuntimeException("Đơn hàng này không ở trong trạng thái chờ hoàn tiền!");
        }

        dh.setTrangThaiThanhToan(6); // Đã hoàn tiền
        dh.setNgayCapNhat(LocalDateTime.now());
        donHangRepository.save(dh);

        // Ghi lịch sử
        LichSuDonHang history = new LichSuDonHang(
                dh,
                dh.getTrangThaiDH(),
                dh.getTrangThaiDH(),
                "ADMIN",
                "Xác nhận đã hoàn tiền thành công: " + (ghiChuAdmin != null ? ghiChuAdmin : "N/A"));
        lichSuDonHangRepository.save(history);

        log.info("✅ Admin đã xác nhận hoàn tiền cho đơn hàng #{}", maDH);
    }
}
