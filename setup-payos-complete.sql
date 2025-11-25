-- =====================================================
-- SCRIPT HOÀN CHỈNH TÍCH HỢP PAYOS
-- Chạy script này để cập nhật database đầy đủ
-- =====================================================

USE LuxuryFashion_2025;
GO

PRINT N'';
PRINT N'========================================';
PRINT N'  TÍCH HỢP PAYOS - SCRIPT HOÀN CHỈNH';
PRINT N'========================================';
PRINT N'';
GO

-- ===== BƯỚC 1: THÊM CỘT MỚI VÀO BẢNG DONHANG =====
PRINT N'[1/4] Kiểm tra và thêm cột vào bảng DonHang...';
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('DonHang') AND name = 'LyDoHuy')
BEGIN
    ALTER TABLE DonHang ADD LyDoHuy NVARCHAR(255);
    PRINT N'✅ Đã thêm cột LyDoHuy';
END
ELSE
BEGIN
    PRINT N'⚠️ Cột LyDoHuy đã tồn tại';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('DonHang') AND name = 'MaGiaoDich')
BEGIN
    ALTER TABLE DonHang ADD MaGiaoDich VARCHAR(100);
    PRINT N'✅ Đã thêm cột MaGiaoDich';
END
ELSE
BEGIN
    PRINT N'⚠️ Cột MaGiaoDich đã tồn tại';
END
GO

-- ===== BƯỚC 2: THÊM PHƯƠNG THỨC THANH TOÁN PAYOS =====
PRINT N'';
PRINT N'[2/4] Thêm phương thức thanh toán PayOS...';
GO

IF NOT EXISTS (SELECT 1 FROM HinhThucThanhToan WHERE TenHinhThuc = N'PayOS')
BEGIN
    INSERT INTO HinhThucThanhToan (TenHinhThuc, MoTa, TrangThai)
    VALUES (N'PayOS', N'Thanh toán qua QR Code PayOS (Ngân hàng)', 1);
    PRINT N'✅ Đã thêm phương thức PayOS';
END
ELSE
BEGIN
    PRINT N'⚠️ Phương thức PayOS đã tồn tại';
END
GO

-- ===== BƯỚC 3: THÊM SẢN PHẨM TEST =====
PRINT N'';
PRINT N'[3/4] Thêm sản phẩm test giá 3.000 VNĐ...';
GO

DECLARE @MaSP BIGINT;
DECLARE @MaLoai BIGINT;
DECLARE @MaTH BIGINT;
DECLARE @MaSize BIGINT;
DECLARE @MaMau BIGINT;

-- Lấy hoặc tạo Loại sản phẩm
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo thun')
BEGIN
    INSERT INTO LoaiSanPham (TenLoai, MoTa) VALUES (N'Áo thun', N'Áo thun cotton');
END
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo thun';

-- Lấy hoặc tạo Thương hiệu
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Test Brand')
BEGIN
    INSERT INTO ThuongHieu (TenTH, MoTa) VALUES (N'Test Brand', N'Thương hiệu test');
END
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Test Brand';

-- Lấy hoặc tạo Size M
IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M')
BEGIN
    INSERT INTO SizeSP (TenSize) VALUES (N'M');
END
SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';

-- Lấy hoặc tạo Màu Trắng
IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng')
BEGIN
    INSERT INTO MauSacSP (TenMau, MaHex) VALUES (N'Trắng', N'#FFFFFF');
END
SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';

-- Xóa sản phẩm test cũ nếu có
IF EXISTS (SELECT 1 FROM SanPham WHERE TenSP = N'Áo Test PayOS 3K')
BEGIN
    SELECT @MaSP = MaSP FROM SanPham WHERE TenSP = N'Áo Test PayOS 3K';
    DELETE FROM SanPhamChiTiet WHERE MaSP = @MaSP;
    DELETE FROM SanPham WHERE MaSP = @MaSP;
    PRINT N'⚠️ Đã xóa sản phẩm test cũ';
END

-- Thêm sản phẩm mới
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP, NgayTao, NgayCapNhat)
VALUES (
    N'Áo Test PayOS 3K',
    @MaLoai,
    @MaTH,
    N'Áo test thanh toán PayOS - Giá chỉ 3.000 VNĐ để test payment gateway',
    N'/img/placeholder.png',
    2, -- Unisex
    1, -- Đang bán
    GETDATE(),
    GETDATE()
);

SET @MaSP = SCOPE_IDENTITY();
PRINT N'✅ Đã thêm sản phẩm: Áo Test PayOS 3K (MaSP: ' + CAST(@MaSP AS NVARCHAR(10)) + ')';

-- Thêm biến thể Size M - Màu Trắng
INSERT INTO SanPhamChiTiet (MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan)
VALUES (@MaSP, @MaSize, @MaMau, 3000.00, 2000.00, 999, 0);
PRINT N'✅ Biến thể: Size M, Màu Trắng, Giá 3.000 VNĐ';

-- Thêm Size L
IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L')
BEGIN
    INSERT INTO SizeSP (TenSize) VALUES (N'L');
END
SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
INSERT INTO SanPhamChiTiet (MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan)
VALUES (@MaSP, @MaSize, @MaMau, 3000.00, 2000.00, 999, 0);
PRINT N'✅ Biến thể: Size L, Màu Trắng';

-- Thêm Màu Đen
IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen')
BEGIN
    INSERT INTO MauSacSP (TenMau, MaHex) VALUES (N'Đen', N'#000000');
END
SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
INSERT INTO SanPhamChiTiet (MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan)
VALUES (@MaSP, @MaSize, @MaMau, 3000.00, 2000.00, 999, 0);
PRINT N'✅ Biến thể: Size M, Màu Đen';

GO

-- ===== BƯỚC 4: KIỂM TRA KẾT QUẢ =====
PRINT N'';
PRINT N'[4/4] Kiểm tra kết quả...';
PRINT N'';
GO

PRINT N'===== PHƯƠNG THỨC THANH TOÁN =====';
SELECT
    MaHinhThucTT as [ID],
    TenHinhThuc as [Tên],
    MoTa as [Mô tả],
    CASE WHEN TrangThai = 1 THEN N'Hoạt động' ELSE N'Tắt' END as [Trạng thái]
FROM HinhThucThanhToan
ORDER BY MaHinhThucTT;
GO

PRINT N'';
PRINT N'===== SẢN PHẨM TEST =====';
SELECT
    sp.MaSP,
    sp.TenSP as [Sản phẩm],
    COUNT(spct.MaBienThe) as [Số biến thể],
    MIN(spct.GiaBan) as [Giá],
    SUM(spct.SoLuongTon) as [Tồn kho]
FROM SanPham sp
LEFT JOIN SanPhamChiTiet spct ON sp.MaSP = spct.MaSP
WHERE sp.TenSP = N'Áo Test PayOS 3K'
GROUP BY sp.MaSP, sp.TenSP;
GO

PRINT N'';
PRINT N'========================================';
PRINT N'✅ HOÀN TẤT! Database đã sẵn sàng';
PRINT N'========================================';
PRINT N'';
PRINT N'📝 BƯỚC TIẾP THEO:';
PRINT N'1. Khởi động server: mvn spring-boot:run';
PRINT N'2. Truy cập: http://localhost:8080';
PRINT N'3. Tìm "Áo Test PayOS 3K" → Thêm giỏ hàng';
PRINT N'4. Checkout → Chọn PayOS → Thanh toán';
PRINT N'';
GO

