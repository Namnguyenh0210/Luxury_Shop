package com.example.projectend.service;

import com.example.projectend.entity.*;
import com.example.projectend.repository.*;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
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

    /**
     * TẠO ĐƠN HÀNG MỚI - HOÀN CHỈNH
     */
    @Transactional
    public DonHang createDonHang(TaiKhoan taiKhoan, Long diaChiId, Long phuongThucTTId,
                                  List<GioHangChiTiet> gioHangItems, String ghiChu) {

        // 1. Validate
        if (gioHangItems == null || gioHangItems.isEmpty()) {
            throw new RuntimeException("Giỏ hàng trống!");
        }

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
        donHang.setPhiShip(BigDecimal.ZERO); // Miễn phí ship

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

    /**
     * LẤY TẤT CẢ ĐƠN HÀNG CỦA KHÁCH HÀNG
     */
    public List<DonHang> getDonHangByKhachHang(TaiKhoan taiKhoan) {
        return donHangRepository.findByTaiKhoan_MaTKOrderByNgayDatDesc(taiKhoan.getMaTK());
    }

    /**
     * CẬP NHẬT TRẠNG THÁI ĐƠN HÀNG (CHỈ TIẾN LÊN, KHÔNG LÙI LẠI) + GHI LỊCH SỬ
     */
    @Transactional
    public boolean capNhatTrangThai(Long maDH, Integer trangThaiMoi, String nguoiCapNhat, String ghiChu) {
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

        // Không cho phép cập nhật nếu đã hủy
        if (trangThaiCu == 4) {
            throw new RuntimeException("Đơn hàng đã hủy, không thể cập nhật!");
        }

        // Cập nhật trạng thái
        donHang.setTrangThaiDH(trangThaiMoi);
        donHang.setNgayCapNhat(LocalDateTime.now());

        // Nếu đã giao hàng thì đánh dấu đã thanh toán
        if (trangThaiMoi == 3) {
            donHang.setTrangThaiThanhToan(1);
            donHang.setNgayThanhToan(LocalDateTime.now());
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
        return capNhatTrangThai(orderId, newStatus, updatedBy, null);
    }

    /**
     * LẤY LỊCH SỬ ĐƠN HÀNG
     */
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

        donHang.setTrangThaiDH(4); // Đã hủy
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
            4,
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
     * SEARCH ADMIN (keyword = email khách; trangThai = mã hoặc tên tiếng Việt)
     * Nếu trangThai là tên sẽ convert sang mã.
     */
    public Page<DonHang> searchAdmin(String keyword, String trangThai, Pageable pageable) {
        Integer statusCode = null;
        if (trangThai != null && !trangThai.isBlank()) {
            statusCode = convertStatusToCodeFlexible(trangThai.trim());
        }
        boolean hasKeyword = keyword != null && !keyword.isBlank();
        if (statusCode != null && hasKeyword) {
            return donHangRepository.findByTrangThaiDHAndTaiKhoan_EmailContainingIgnoreCaseOrderByNgayDatDesc(statusCode, keyword.trim(), pageable);
        } else if (statusCode != null) {
            return donHangRepository.findByTrangThaiDHOrderByNgayDatDesc(statusCode, pageable);
        } else if (hasKeyword) {
            return donHangRepository.findByTaiKhoan_EmailContainingIgnoreCaseOrderByNgayDatDesc(keyword.trim(), pageable);
        }
        return donHangRepository.findAllByOrderByNgayDatDesc(pageable);
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
            case "hoàn tất", "đã giao" -> 3;
            case "đã hủy", "hủy" -> 4;
            default -> null;
        };
    }
}
