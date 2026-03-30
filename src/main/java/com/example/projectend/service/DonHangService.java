package com.example.projectend.service;

import com.example.projectend.entity.*;
import com.example.projectend.repository.*;
import jakarta.transaction.Transactional;
import java.time.LocalDateTime;
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

    @Autowired
    private DonHangRepository donHangRepository;

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

        if (diaChiId == null) throw new IllegalArgumentException("diaChiId is null");
        if (phuongThucTTId == null) throw new IllegalArgumentException("phuongThucTTId is null");

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
        donHang.setTrangThaiDH(0); // Chờ xác nhận
        donHang.setTrangThaiThanhToan(0); // Chờ thanh toán
        donHang.setNgayDat(LocalDateTime.now());
        donHang.setNgayCapNhat(LocalDateTime.now());

        // 5. Tính tổng tiền và tạo chi tiết đơn hàng
        BigDecimal tongTien = BigDecimal.ZERO;

        for (GioHangChiTiet item : gioHangItems) {
            SanPhamChiTiet spct = item.getSanPhamChiTiet();

            // Kiểm tra tồn kho
            if (spct.getSoLuongTon() < item.getSoLuong()) {
                throw new RuntimeException("Sản phẩm " + spct.getSanPham().getTenSP() +
                        " không đủ số lượng trong kho!");
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

            // Trừ tồn kho
            spct.setSoLuongTon(spct.getSoLuongTon() - item.getSoLuong());
            sanPhamChiTietRepository.save(spct);
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
            
            if (voucher != null && Boolean.TRUE.equals(voucher.getTrangThai()) && !Boolean.TRUE.equals(voucher.getIsDeleted())) {
                
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
                if (tongTien.compareTo(voucher.getGiaTriToiThieu()) < 0) {
                    throw new RuntimeException("Đơn hàng chưa đạt giá trị tối thiểu để dùng voucher này");
                }

                // 4. Kiểm tra điều kiện Thương hiệu / Danh mục (Nếu có)
                boolean matchesCondition = true;
                if (voucher.getMaLoaiApDung() != null || voucher.getMaTHApDung() != null) {
                    matchesCondition = false;
                    for (GioHangChiTiet item : gioHangItems) {
                        SanPham sp = item.getSanPhamChiTiet().getSanPham();
                        
                        // Kiểm tra danh mục
                        if (voucher.getMaLoaiApDung() != null) {
                            String[] allowedLoai = voucher.getMaLoaiApDung().split(",");
                            for (String idStr : allowedLoai) {
                                if (sp.getLoaiSanPham() != null && sp.getLoaiSanPham().getMaLoai().toString().equals(idStr.trim())) {
                                    matchesCondition = true; break;
                                }
                            }
                        }
                        
                        // Kiểm tra thương hiệu
                        if (voucher.getMaTHApDung() != null) {
                            String[] allowedTH = voucher.getMaTHApDung().split(",");
                            for (String idStr : allowedTH) {
                                if (sp.getThuongHieu() != null && sp.getThuongHieu().getMaTH().toString().equals(idStr.trim())) {
                                    matchesCondition = true; break;
                                }
                            }
                        }
                        if (matchesCondition) break;
                    }
                }

                if (!matchesCondition) {
                    throw new RuntimeException("Voucher không áp dụng cho các sản phẩm trong giỏ hàng của bạn");
                }

                // 5. Tính toán giảm giá
                BigDecimal discount = BigDecimal.ZERO;
                if (voucher.getLoaiGiamGia() == 0) { // Phần trăm
                    discount = tongTien.multiply(voucher.getGiaTri()).divide(new BigDecimal(100));
                    if (voucher.getGiaTriToiDa() != null && discount.compareTo(voucher.getGiaTriToiDa()) > 0) {
                        discount = voucher.getGiaTriToiDa();
                    }
                } else { // Số tiền cố định
                    discount = voucher.getGiaTri();
                }
                
                if (discount.compareTo(tongTien) > 0) discount = tongTien;
                
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
            0,  // Chờ xác nhận
            taiKhoan.getHoTen(),
            "Đơn hàng được tạo"
        );
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

    public List<DonHang> findAll() {
        return donHangRepository.findAllByOrderByNgayDatDesc();
    }

    @SuppressWarnings("null")
    public void updateStatus(Long id, Integer status){

        DonHang dh = donHangRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn"));

        Integer currentStatus = dh.getTrangThaiDH();

        // Cho phép 6 (Lỗi) -> 4 (Hoàn tất)
        if (currentStatus == 6 && status == 4) {
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

        donHangRepository.save(dh);

    }

    /**
     * KHÁCH BÁO CHƯA NHẬN ĐƯỢC HÀNG
     */
    @Transactional
    public void reportOrderNotReceived(Long id, String lyDo, String moTa) {
        DonHang dh = donHangRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng"));
        
        if (dh.getTrangThaiDH() != 3) {
            throw new RuntimeException("Chỉ có thể báo lỗi khi đơn hàng đang ở trạng thái Đã giao");
        }

        dh.setKhachBaoChuaNhan(true);
        dh.setLyDoChuaNhan(lyDo);
        dh.setMoTaChuaNhan(moTa);
        dh.setNgayCapNhat(LocalDateTime.now());
        donHangRepository.save(dh);

        // Ghi log
        LichSuDonHang history = new LichSuDonHang();
        history.setDonHang(dh);
        history.setTrangThaiCu(3);
        history.setTrangThaiMoi(3);
        history.setNguoiCapNhat("KHACHHANG");
        history.setGhiChu("Khách báo chưa nhận được hàng: " + lyDo);
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
        if (maDH == null) return false;
        
        Optional<DonHang> dhOpt = donHangRepository.findById(maDH);
        if (!dhOpt.isPresent()) {
            return false;
        }

        DonHang donHang = dhOpt.get();
        Integer trangThaiCu = donHang.getTrangThaiDH();

        // Kiểm tra: chỉ cho phép tiến lên, không được lùi lại
        if (trangThaiMoi <= trangThaiCu && trangThaiCu != 0) {
            throw new RuntimeException("Không thể quay lại trạng thái trước đó!");
        }

        // Không cho phép cập nhật nếu đã kết thúc (4, 5)
        if (trangThaiCu == 4 || trangThaiCu == 5) {
            throw new RuntimeException("Đơn hàng đã kết thúc, không thể cập nhật!");
        }

        // Cập nhật trạng thái
        donHang.setTrangThaiDH(trangThaiMoi);
        donHang.setNgayCapNhat(LocalDateTime.now());

        // Nếu đã giao hàng (Hoàn tất) thì đánh dấu đã thanh toán
        if (trangThaiMoi == 4) {
            donHang.setTrangThaiThanhToan(1);
            
            // Tạo bản ghi thanh toán
            ThanhToan tt = new ThanhToan();
            tt.setDonHang(donHang);
            tt.setSoTien(donHang.getTongTien().add(donHang.getPhiShip()));
            tt.setTrangThai("COMPLETED");
            tt.setGateway(donHang.getHinhThucThanhToan() != null ? donHang.getHinhThucThanhToan().getTenHinhThuc() : "COD");
            tt.setNgayTao(LocalDateTime.now());
            thanhToanRepository.save(tt);
        }

        donHangRepository.save(donHang);

        // Ghi lịch sử thay đổi
        LichSuDonHang lichSu = new LichSuDonHang(
            donHang,
            trangThaiCu,
            trangThaiMoi,
            nguoiCapNhat,
            ghiChu != null ? ghiChu : "Cập nhật trạng thái đơn hàng"
        );
        lichSuDonHangRepository.save(lichSu);

        return true;
    }

    /**
     * CẬP NHẬT TRẠNG THÁI (OVERLOAD - TỰ ĐỘNG LẤY NGƯỜI CẬP NHẬT)
     */
    @Transactional
    public boolean capNhatTrangThai(Long maDH, Integer trangThaiMoi) {
        return capNhatTrangThai(maDH, trangThaiMoi, "Hệ thống", null);
    }

    /**
     * CẬP NHẬT TRẠNG THÁI (ALIAS CHO STAFF CONTROLLER)
     */
    @Transactional
    public boolean updateOrderStatus(Long orderId, Integer newStatus, String updatedBy) {
        if (orderId == null) return false;
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
            "Khách hàng hủy đơn hàng"
        );
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
        if (maDH == null) return Optional.empty();
        return donHangRepository.findById(maDH);
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
     * SEARCH ADMIN (keyword = name/email; trangThai = mã hoặc tên; timeRange = day/week/month/year)
     */
    public Page<DonHang> searchAdmin(String keyword, String trangThai, String timeRange, Pageable pageable) {
        Integer statusCode = null;
        if (trangThai != null && !trangThai.isBlank()) {
            statusCode = convertStatusToCodeFlexible(trangThai.trim());
        }

        LocalDateTime startDate = null;
        LocalDateTime endDate = LocalDateTime.now();

        if (timeRange != null && !timeRange.isBlank()) {
            startDate = switch (timeRange.toLowerCase()) {
                case "day" -> LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
                case "week" -> LocalDateTime.now().minusWeeks(1);
                case "month" -> LocalDateTime.now().minusMonths(1);
                case "year" -> LocalDateTime.now().minusYears(1);
                default -> null;
            };
        }

        String cleanKeyword = (keyword != null && !keyword.isBlank()) ? keyword.trim() : null;

        return donHangRepository.searchAdvanced(cleanKeyword, statusCode, startDate, endDate, pageable);
    }

    /**
     * Lấy đơn hàng đang chờ xác nhận (trangThaiDH = 0) với giới hạn.
     */
    public List<DonHang> getPendingOrders(int limit) {
        List<DonHang> list = donHangRepository.findByTrangThaiDHOrderByNgayDatDesc(0);
        if (list.isEmpty()) return Collections.emptyList();
        if (limit <= 0) limit = 5;
        return list.size() <= limit ? list : list.subList(0, limit);
    }

    public List<DonHang> getRecentOrdersForStaff(int limit) {

        return donHangRepository
                .findTop10ByTrangThaiDHInOrderByNgayDatDesc(List.of(0,1,2));

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
        if (s == null) return null;
        // Nếu là số
        try {
            return Integer.parseInt(s);
        } catch (NumberFormatException ignored) {}
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
}
