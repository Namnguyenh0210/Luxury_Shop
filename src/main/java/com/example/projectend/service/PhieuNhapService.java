package com.example.projectend.service;

import com.example.projectend.entity.*;
import com.example.projectend.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class PhieuNhapService {

    private final PhieuNhapRepository phieuNhapRepository;
    private final SanPhamChiTietRepository sanPhamChiTietRepository;
    private final SanPhamRepository sanPhamRepository;
    private final SizeSPRepository sizeSPRepository;
    private final MauSacSPRepository mauSacSPRepository;
    private final LoaiSanPhamRepository loaiSanPhamRepository;
    private final ThuongHieuRepository thuongHieuRepository;

    public PhieuNhapService(PhieuNhapRepository phieuNhapRepository,
                            SanPhamChiTietRepository sanPhamChiTietRepository,
                            SanPhamRepository sanPhamRepository,
                            SizeSPRepository sizeSPRepository,
                            MauSacSPRepository mauSacSPRepository,
                            LoaiSanPhamRepository loaiSanPhamRepository,
                            ThuongHieuRepository thuongHieuRepository) {
        this.phieuNhapRepository = phieuNhapRepository;
        this.sanPhamChiTietRepository = sanPhamChiTietRepository;
        this.sanPhamRepository = sanPhamRepository;
        this.sizeSPRepository = sizeSPRepository;
        this.mauSacSPRepository = mauSacSPRepository;
        this.loaiSanPhamRepository = loaiSanPhamRepository;
        this.thuongHieuRepository = thuongHieuRepository;
    }

    /**
     * Sinh mã phiếu nhập định dạng: PN-YYYYMM-#### (đếm trong tháng)
     * Lưu ý: Không lưu vào DB, chỉ phục vụ hiển thị. MaPN thật vẫn là identity.
     */
    public String generateDisplayCode() {
        YearMonth ym = YearMonth.now();
        LocalDateTime start = ym.atDay(1).atStartOfDay();
        LocalDateTime end = ym.atEndOfMonth().atTime(23,59,59);
        long countThisMonth = phieuNhapRepository.countByNgayNhapBetween(start, end);
        long nextSeq = countThisMonth + 1; // đơn giản: số lượng + 1
        return "PN-" + ym.format(DateTimeFormatter.ofPattern("yyyyMM")) + "-" + String.format("%04d", nextSeq);
    }

    /**
     * Tạo phiếu nhập từ dữ liệu form đã parse (tách list sản phẩm cũ & mới).
     * @param nhanVien nhân viên hiện tại
     * @param nhaCungCap đối tượng NCC
     * @param existingItems danh sách item sản phẩm có sẵn
     * @param newItems danh sách item tạo mới
     * @param ghiChu ghi chú
     * @return PhieuNhap đã lưu
     */
    @Transactional
    public PhieuNhap createPhieuNhap(TaiKhoan nhanVien,
                                     NhaCungCap nhaCungCap,
                                     List<ExistingItem> existingItems,
                                     List<NewItem> newItems,
                                     String ghiChu) {
        PhieuNhap phieuNhap = new PhieuNhap();
        phieuNhap.setNhanVien(nhanVien);
        phieuNhap.setNhaCungCap(nhaCungCap);
        phieuNhap.setNgayNhap(LocalDateTime.now());
        phieuNhap.setGhiChu(ghiChu);
        phieuNhap = phieuNhapRepository.save(phieuNhap);

        BigDecimal tongTien = BigDecimal.ZERO;

        // Xử lý sản phẩm có sẵn
        for (ExistingItem item : existingItems) {
            SanPhamChiTiet variant = sanPhamChiTietRepository.findById(item.maBienThe())
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy biến thể: " + item.maBienThe()));
            variant.setSoLuongTon(variant.getSoLuongTon() + item.soLuong());
            variant.setGiaNhap(item.donGiaNhap());
            sanPhamChiTietRepository.save(variant);

            NhapKhoChiTiet ct = new NhapKhoChiTiet();
            ct.setPhieuNhap(phieuNhap);
            ct.setSanPhamChiTiet(variant);
            ct.setSoLuong(item.soLuong());
            ct.setDonGiaNhap(item.donGiaNhap());
            ct.setThanhTien(item.donGiaNhap().multiply(BigDecimal.valueOf(item.soLuong())));
            tongTien = tongTien.add(ct.getThanhTien());

            phieuNhap.getChiTiet().add(ct);
        }

        // Xử lý sản phẩm mới
        for (NewItem item : newItems) {
            // Tạo SanPham
            SanPham sp = new SanPham();
            sp.setTenSP(item.tenSP());
            sp.setTrangThaiSP(1);
            sp.setNgayTao(LocalDateTime.now());
            sp.setNgayCapNhat(LocalDateTime.now());
            if (item.gender() != null) {
                sp.setGioiTinh(item.gender());
            }
            if (item.categoryId() != null) {
                LoaiSanPham lsp = loaiSanPhamRepository.findById(item.categoryId().intValue()).orElse(null);
                if (lsp != null) sp.setLoaiSanPham(lsp);
            }
            if (item.brandId() != null) {
                ThuongHieu th = thuongHieuRepository.findById(item.brandId()).orElse(null);
                if (th != null) sp.setThuongHieu(th);
            }
            sp = sanPhamRepository.save(sp);

            // Tìm/ tạo size
            SizeSP size = sizeSPRepository.findByTenSize(item.size())
                    .orElseGet(() -> {
                        SizeSP s = new SizeSP();
                        s.setTenSize(item.size());
                        return sizeSPRepository.save(s);
                    });
            // Tìm/ tạo màu
            MauSacSP mau = mauSacSPRepository.findByTenMau(item.color())
                    .orElseGet(() -> {
                        MauSacSP m = new MauSacSP();
                        m.setTenMau(item.color());
                        return mauSacSPRepository.save(m);
                    });

            SanPhamChiTiet variant = new SanPhamChiTiet();
            variant.setSanPham(sp);
            variant.setSizeSP(size);
            variant.setMauSacSP(mau);
            variant.setGiaBan(item.giaBan());
            variant.setGiaNhap(item.donGiaNhap());
            variant.setSoLuongTon(item.soLuong());
            variant = sanPhamChiTietRepository.save(variant);

            NhapKhoChiTiet ct = new NhapKhoChiTiet();
            ct.setPhieuNhap(phieuNhap);
            ct.setSanPhamChiTiet(variant);
            ct.setSoLuong(item.soLuong());
            ct.setDonGiaNhap(item.donGiaNhap());
            ct.setThanhTien(item.donGiaNhap().multiply(BigDecimal.valueOf(item.soLuong())));
            tongTien = tongTien.add(ct.getThanhTien());

            phieuNhap.getChiTiet().add(ct);
        }

        phieuNhap.setTongTien(tongTien);
        phieuNhapRepository.save(phieuNhap);
        return phieuNhap;
    }

    // Record types cho dữ liệu tạm
    public record ExistingItem(Long maBienThe, Integer soLuong, BigDecimal donGiaNhap) {}
    public record NewItem(String tenSP, String size, String color, Integer soLuong, BigDecimal donGiaNhap, BigDecimal giaBan, Long categoryId, Long brandId, Integer gender) {}
}
