-- =====================================================
-- SCRIPT THÊM SẢN PHẨM TEST CHO PAYOS
-- Sản phẩm: Áo Test PayOS - Giá 3,000 VNĐ
-- =====================================================

USE LuxuryFashion_2025;
GO

PRINT N'🔄 Bắt đầu thêm sản phẩm test...';
GO

-- ===== THÊM SẢN PHẨM TEST =====
DECLARE @MaSP BIGINT;
DECLARE @MaLoai BIGINT;
DECLARE @MaTH BIGINT;
DECLARE @MaSize BIGINT;
DECLARE @MaMau BIGINT;

-- 1. Lấy hoặc tạo Loại sản phẩm
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo thun')
BEGIN
    INSERT INTO LoaiSanPham (TenLoai, MoTa) VALUES (N'Áo thun', N'Áo thun cotton');
END
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo thun';

-- 2. Lấy hoặc tạo Thương hiệu
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Test Brand')
BEGIN
    INSERT INTO ThuongHieu (TenTH, MoTa) VALUES (N'Test Brand', N'Thương hiệu test');
END
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Test Brand';

-- 3. Lấy hoặc tạo Size M
IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M')
BEGIN
    INSERT INTO SizeSP (TenSize) VALUES (N'M');
END
SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';

-- 4. Lấy hoặc tạo Màu Trắng
IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng')
BEGIN
    INSERT INTO MauSacSP (TenMau, MaHex) VALUES (N'Trắng', N'#FFFFFF');
END
SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';

-- 5. Kiểm tra xem sản phẩm test đã tồn tại chưa
IF EXISTS (SELECT 1 FROM SanPham WHERE TenSP = N'Áo Test PayOS 3K')
BEGIN
    PRINT N'⚠️ Sản phẩm test đã tồn tại. Xóa và tạo lại...';

    -- Lấy MaSP cũ
    SELECT @MaSP = MaSP FROM SanPham WHERE TenSP = N'Áo Test PayOS 3K';

    -- Xóa chi tiết sản phẩm cũ
    DELETE FROM SanPhamChiTiet WHERE MaSP = @MaSP;

    -- Xóa sản phẩm cũ
    DELETE FROM SanPham WHERE MaSP = @MaSP;
END

-- 6. Thêm sản phẩm mới
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

-- Lấy MaSP vừa tạo
SET @MaSP = SCOPE_IDENTITY();

PRINT N'✅ Đã thêm sản phẩm: Áo Test PayOS 3K (MaSP: ' + CAST(@MaSP AS NVARCHAR(10)) + ')';

-- 7. Thêm biến thể sản phẩm (Size M, Màu Trắng, Giá 3,000 VNĐ)
INSERT INTO SanPhamChiTiet (MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan)
VALUES (
    @MaSP,
    @MaSize,
    @MaMau,
    3000.00,  -- Giá bán: 3,000 VNĐ
    2000.00,  -- Giá nhập: 2,000 VNĐ
    999,      -- Tồn kho: 999 cái
    0         -- Đã bán: 0
);

PRINT N'✅ Đã thêm biến thể: Size M, Màu Trắng, Giá 3.000 VNĐ, Tồn kho: 999';

-- 8. Thêm thêm vài size và màu khác (optional)
-- Size L
IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L')
BEGIN
    INSERT INTO SizeSP (TenSize) VALUES (N'L');
END
SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';

INSERT INTO SanPhamChiTiet (MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan)
VALUES (@MaSP, @MaSize, @MaMau, 3000.00, 2000.00, 999, 0);

PRINT N'✅ Đã thêm biến thể: Size L, Màu Trắng, Giá 3.000 VNĐ';

-- Màu Đen
IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen')
BEGIN
    INSERT INTO MauSacSP (TenMau, MaHex) VALUES (N'Đen', N'#000000');
END
SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';

-- Size M Màu Đen
SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
INSERT INTO SanPhamChiTiet (MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan)
VALUES (@MaSP, @MaSize, @MaMau, 3000.00, 2000.00, 999, 0);

PRINT N'✅ Đã thêm biến thể: Size M, Màu Đen, Giá 3.000 VNĐ';

-- ===== KIỂM TRA KẾT QUẢ =====
PRINT N'';
PRINT N'===== THÔNG TIN SẢN PHẨM VỪA TẠO =====';
GO

SELECT
    sp.MaSP,
    sp.TenSP as [Tên sản phẩm],
    lsp.TenLoai as [Loại],
    th.TenTH as [Thương hiệu],
    COUNT(spct.MaBienThe) as [Số biến thể],
    MIN(spct.GiaBan) as [Giá thấp nhất],
    MAX(spct.GiaBan) as [Giá cao nhất],
    SUM(spct.SoLuongTon) as [Tổng tồn kho]
FROM SanPham sp
LEFT JOIN LoaiSanPham lsp ON sp.MaLoai = lsp.MaLoai
LEFT JOIN ThuongHieu th ON sp.MaTH = th.MaTH
LEFT JOIN SanPhamChiTiet spct ON sp.MaSP = spct.MaSP
WHERE sp.TenSP = N'Áo Test PayOS 3K'
GROUP BY sp.MaSP, sp.TenSP, lsp.TenLoai, th.TenTH;
GO

PRINT N'';
PRINT N'===== CHI TIẾT CÁC BIẾN THỂ =====';
GO

SELECT
    spct.MaBienThe as [Mã biến thể],
    sp.TenSP as [Sản phẩm],
    sz.TenSize as [Size],
    mau.TenMau as [Màu],
    spct.GiaBan as [Giá bán],
    spct.SoLuongTon as [Tồn kho]
FROM SanPhamChiTiet spct
INNER JOIN SanPham sp ON spct.MaSP = sp.MaSP
LEFT JOIN SizeSP sz ON spct.MaSize = sz.MaSize
LEFT JOIN MauSacSP mau ON spct.MaMau = mau.MaMau
WHERE sp.TenSP = N'Áo Test PayOS 3K'
ORDER BY sz.TenSize, mau.TenMau;
GO

PRINT N'';
PRINT N'✅ HOÀN TẤT! Sản phẩm đã sẵn sàng để test PayOS.';
PRINT N'';
PRINT N'📝 HƯỚNG DẪN TEST:';
PRINT N'1. Truy cập: http://localhost:8080';
PRINT N'2. Tìm kiếm "Áo Test PayOS 3K"';
PRINT N'3. Thêm vào giỏ hàng';
PRINT N'4. Checkout → Chọn PayOS → Đặt hàng';
PRINT N'5. Quét QR code để thanh toán 3.000 VNĐ';
PRINT N'';
GO

