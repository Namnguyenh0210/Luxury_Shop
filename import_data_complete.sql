USE LuxuryFashion_2025;
GO

PRINT N'--- 1. PREPARING SCHEMA ---';
-- Ensure image columns can handle long URLs
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('SanPham') AND name = 'AnhChinh')
    ALTER TABLE SanPham ALTER COLUMN AnhChinh NVARCHAR(MAX);
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('SanPhamChiTiet') AND name = 'AnhBienThe')
    ALTER TABLE SanPhamChiTiet ALTER COLUMN AnhBienThe NVARCHAR(MAX);
GO

PRINT N'--- 2. CLEANING UP OLD DATA ---';
-- Clear existing products for key brands to avoid duplicates
DECLARE @TargetBrands TABLE (BrandName NVARCHAR(100));
INSERT INTO @TargetBrands VALUES (N'MLB'), (N'Off White'), (N'Gucci'), (N'Chanel'), (N'Off-White');

DELETE FROM SanPhamChiTiet WHERE MaSP IN (
    SELECT MaSP FROM SanPham WHERE MaTH IN (
        SELECT MaTH FROM ThuongHieu WHERE TenTH IN (SELECT BrandName FROM @TargetBrands)
    )
);
DELETE FROM SanPham WHERE MaTH IN (
    SELECT MaTH FROM ThuongHieu WHERE TenTH IN (SELECT BrandName FROM @TargetBrands)
);
GO

DECLARE @MaTH BIGINT, @MaLoai BIGINT, @MaSP BIGINT, @MaSize BIGINT, @MaMau BIGINT;

PRINT N'--- 3. IMPORTING NEW DATA ---';
-- Product: Áo Polo MLB Monogram Overfit New York Yankees
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'MLB') INSERT INTO ThuongHieu (TenTH) VALUES (N'MLB');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'MLB';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Polo') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Polo');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Polo';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo Polo MLB Monogram Overfit New York Yankees', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp MLB 2025', N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-BLK-S', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-BLK-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-WHT-S', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-WHT-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-BEI-S', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-BEI-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-BLU-S', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-BLU-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-BLK-M', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-BLK-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-WHT-M', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-WHT-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-BEI-M', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-BEI-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-BLU-M', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-BLU-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-BLK-L', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-BLK-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-WHT-L', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-WHT-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-BEI-L', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-BEI-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-BLU-L', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-BLU-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-BLK-XL', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-BLK-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-WHT-XL', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-WHT-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-BEI-XL', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-BEI-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-POLO-BLU-XL', @MaSP, @MaSize, @MaMau, 1800000, 1260000, 10, 0, N'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-POLO-BLU-XL: ' + ERROR_MESSAGE(); END CATCH

-- Product: Váy MLB Monogram Skirt Luxury
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'MLB') INSERT INTO ThuongHieu (TenTH) VALUES (N'MLB');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'MLB';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Váy') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Váy');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Váy';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Váy MLB Monogram Skirt Luxury', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp MLB 2025', N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-BLK-S', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-BLK-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-WHT-S', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-WHT-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-BEI-S', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-BEI-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-BLU-S', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-BLU-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-BLK-M', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-BLK-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-WHT-M', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-WHT-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-BEI-M', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-BEI-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-BLU-M', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-BLU-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-BLK-L', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-BLK-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-WHT-L', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-WHT-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-BEI-L', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-BEI-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-BLU-L', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-BLU-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-BLK-XL', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-BLK-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-WHT-XL', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-WHT-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-BEI-XL', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-BEI-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-DRESS-BLU-XL', @MaSP, @MaSize, @MaMau, 2100000, 1470000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down,onerror=redirect/images/goods/ec/M26S3FSKB076350IVS/thnail/18BD1AD0D8C84EBC99A8837C7D2F07D1.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-DRESS-BLU-XL: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo Thun MLB Basic Logo
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'MLB') INSERT INTO ThuongHieu (TenTH) VALUES (N'MLB');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'MLB';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'T-Shirt') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'T-Shirt');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'T-Shirt';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo Thun MLB Basic Logo', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp MLB 2025', N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-BLK-S', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-BLK-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-WHT-S', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-WHT-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-BEI-S', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-BEI-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-BLU-S', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-BLU-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-BLK-M', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-BLK-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-WHT-M', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-WHT-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-BEI-M', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-BEI-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-BLU-M', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-BLU-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-BLK-L', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-BLK-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-WHT-L', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-WHT-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-BEI-L', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-BEI-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-BLU-L', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-BLU-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-BLK-XL', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-BLK-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-WHT-XL', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-WHT-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-BEI-XL', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-BEI-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-WTS-BLU-XL', @MaSP, @MaSize, @MaMau, 1400000, 979999, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=75,w=842,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M26S3FTSM096350BKS/thnail/3DAA7D6A8F0D4BD8915420711CE30427.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-WTS-BLU-XL: ' + ERROR_MESSAGE(); END CATCH

-- Product: Quần Jogger MLB Sporty
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'MLB') INSERT INTO ThuongHieu (TenTH) VALUES (N'MLB');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'MLB';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Quần') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Quần');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Quần';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Quần Jogger MLB Sporty', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp MLB 2025', N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 0, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-BLK-S', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-BLK-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-WHT-S', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-WHT-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-BEI-S', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-BEI-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-BLU-S', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-BLU-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-BLK-M', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-BLK-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-WHT-M', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-WHT-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-BEI-M', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-BEI-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-BLU-M', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-BLU-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-BLK-L', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-BLK-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-WHT-L', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-WHT-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-BEI-L', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-BEI-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-BLU-L', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-BLU-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-BLK-XL', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-BLK-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-WHT-XL', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-WHT-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-BEI-XL', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-BEI-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('MLB-MPANTS-BLU-XL', @MaSP, @MaSize, @MaMau, 1700000, 1190000, 10, 0, N'https://static-resource.mlb-korea.com/cdn-cgi/image/q=100,w=3840,format=auto,fit=scale-down/onerror=redirect/images/goods/ec/M25F3AWPB045450BKS/thnail/08C4BB98D5FD4376863C51CE3F074A9A.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU MLB-MPANTS-BLU-XL: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo Thun Off-White™ Arrow Logo Streetwear
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Off White') INSERT INTO ThuongHieu (TenTH) VALUES (N'Off White');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Off White';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'T-Shirt') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'T-Shirt');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'T-Shirt';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo Thun Off-White™ Arrow Logo Streetwear', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Off White 2025', N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 0, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-BLK-S', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-BLK-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-WHT-S', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-WHT-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-BEI-S', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-BEI-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-BLU-S', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-BLU-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-BLK-M', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-BLK-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-WHT-M', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-WHT-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-BEI-M', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-BEI-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-BLU-M', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-BLU-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-BLK-L', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-BLK-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-WHT-L', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-WHT-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-BEI-L', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-BEI-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-BLU-L', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-BLU-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-BLK-XL', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-BLK-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-WHT-XL', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-WHT-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-BEI-XL', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-BEI-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-TEE-BLU-XL', @MaSP, @MaSize, @MaMau, 3000000, 2100000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw2789d848/images/zoom/44MAA027S26J001_100_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-TEE-BLU-XL: ' + ERROR_MESSAGE(); END CATCH

-- Product: Quần Off-White™ Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Off White') INSERT INTO ThuongHieu (TenTH) VALUES (N'Off White');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Off White';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Quần') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Quần');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Quần';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Quần Off-White™ Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Off White 2025', N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 0, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-BLK-S', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-BLK-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-WHT-S', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-WHT-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-BEI-S', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-BEI-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-BLU-S', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-BLU-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-BLK-M', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-BLK-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-WHT-M', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-WHT-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-BEI-M', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-BEI-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-BLU-M', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-BLU-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-BLK-L', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-BLK-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-WHT-L', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-WHT-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-BEI-L', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-BEI-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-BLU-L', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-BLU-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-BLK-XL', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-BLK-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-WHT-XL', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-WHT-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-BEI-XL', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-BEI-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-PANTS-BLU-XL', @MaSP, @MaSize, @MaMau, 3500000, 2450000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw58268d34/images/zoom/44MCH05AS26F00B_001_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-PANTS-BLU-XL: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo Thun Off-White™ Arrow Logo Streetwear
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Off White') INSERT INTO ThuongHieu (TenTH) VALUES (N'Off White');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Off White';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'T-Shirt') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'T-Shirt');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'T-Shirt';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo Thun Off-White™ Arrow Logo Streetwear', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Off White 2025', N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-BLK-S', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-BLK-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-WHT-S', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-WHT-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-BEI-S', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-BEI-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-BLU-S', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-BLU-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-BLK-M', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-BLK-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-WHT-M', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-WHT-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-BEI-M', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-BEI-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-BLU-M', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-BLU-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-BLK-L', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-BLK-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-WHT-L', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-WHT-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-BEI-L', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-BEI-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-BLU-L', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-BLU-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-BLK-XL', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-BLK-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-WHT-XL', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-WHT-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-BEI-XL', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-BEI-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WTEE-BLU-XL', @MaSP, @MaSize, @MaMau, 2600000, 1820000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dw57efe60f/images/zoom/2AA124S26JER007_W663_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WTEE-BLU-XL: ' + ERROR_MESSAGE(); END CATCH

-- Product: Váy Off-White™ Floral Print Elegance
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Off White') INSERT INTO ThuongHieu (TenTH) VALUES (N'Off White');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Off White';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Váy') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Váy');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Váy';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Váy Off-White™ Floral Print Elegance', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Off White 2025', N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-BLK-S', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-BLK-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-WHT-S', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-WHT-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-BEI-S', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-BEI-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-BLU-S', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-BLU-S: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-BLK-M', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-BLK-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-WHT-M', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-WHT-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-BEI-M', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-BEI-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-BLU-M', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-BLU-M: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-BLK-L', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-BLK-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-WHT-L', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-WHT-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-BEI-L', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-BEI-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-BLU-L', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-BLU-L: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-BLK-XL', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-BLK-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-WHT-XL', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-WHT-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-BEI-XL', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-BEI-XL: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('OW-WDRESS-BLU-XL', @MaSP, @MaSize, @MaMau, 3900000, 2730000, 10, 0, N'https://www.off---white.com/dw/image/v2/BGDG_PRD/on/demandware.static/-/Sites-51/default/dwf3aa6f3f/images/zoom/2CU01NS26FAB002_W002_1.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU OW-WDRESS-BLU-XL: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo polo Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Polo') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Polo');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Polo';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo polo Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-S-Đ', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-S-T', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-S-BEI', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-S-X', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-M-Đ', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-M-T', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-M-BEI', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-M-X', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-L-Đ', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-L-T', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-L-BEI', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-L-X', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-XL-Đ', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-XL-T', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-XL-BEI', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -01-XL-X', @MaSP, @MaSize, @MaMau, 7700000, 5390000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -01-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo polo Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Polo') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Polo');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Polo';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo polo Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 0, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-S-Đ', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-S-T', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-S-BEI', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-S-X', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-M-Đ', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-M-T', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-M-BEI', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-M-X', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-L-Đ', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-L-T', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-L-BEI', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-L-X', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-XL-Đ', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-XL-T', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-XL-BEI', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -02-XL-X', @MaSP, @MaSize, @MaMau, 8500000, 5950000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -02-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo polo Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Polo') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Polo');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Polo';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo polo Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 0, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-S-Đ', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-S-T', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-S-BEI', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-S-X', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-M-Đ', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-M-T', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-M-BEI', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-M-X', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-L-Đ', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-L-T', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-L-BEI', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-L-X', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-XL-Đ', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-XL-T', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-XL-BEI', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -03-XL-X', @MaSP, @MaSize, @MaMau, 8100000, 5670000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -03-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo thun Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'T-Shirt') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'T-Shirt');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'T-Shirt';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo thun Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-S-Đ', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-S-T', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-S-BEI', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-S-X', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-M-Đ', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-M-T', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-M-BEI', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-M-X', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-L-Đ', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-L-T', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-L-BEI', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-L-X', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-XL-Đ', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-XL-T', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-XL-BEI', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -04-XL-X', @MaSP, @MaSize, @MaMau, 11200000, 7839999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -04-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo thun Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'T-Shirt') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'T-Shirt');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'T-Shirt';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo thun Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-S-Đ', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-S-T', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-S-BEI', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-S-X', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-M-Đ', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-M-T', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-M-BEI', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-M-X', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-L-Đ', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-L-T', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-L-BEI', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-L-X', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-XL-Đ', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-XL-T', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-XL-BEI', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -05-XL-X', @MaSP, @MaSize, @MaMau, 9900000, 6930000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -05-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo thun Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'T-Shirt') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'T-Shirt');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'T-Shirt';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo thun Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-S-Đ', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-S-T', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-S-BEI', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-S-X', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-M-Đ', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-M-T', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-M-BEI', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-M-X', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-L-Đ', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-L-T', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-L-BEI', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-L-X', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-XL-Đ', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-XL-T', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-XL-BEI', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -06-XL-X', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -06-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Quần Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Quần') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Quần');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Quần';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Quần Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-S-Đ', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-S-T', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-S-BEI', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-S-X', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-M-Đ', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-M-T', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-M-BEI', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-M-X', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-L-Đ', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-L-T', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-L-BEI', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-L-X', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-XL-Đ', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-XL-T', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-XL-BEI', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-07-XL-X', @MaSP, @MaSize, @MaMau, 10200000, 7140000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-07-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Quần Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Quần') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Quần');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Quần';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Quần Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 0, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-S-Đ', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-S-T', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-S-BEI', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-S-X', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-M-Đ', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-M-T', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-M-BEI', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-M-X', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-L-Đ', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-L-T', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-L-BEI', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-L-X', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-XL-Đ', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-XL-T', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-XL-BEI', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-08-XL-X', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-08-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Quần Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Quần') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Quần');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Quần';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Quần Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 0, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-S-Đ', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-S-T', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-S-BEI', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-S-X', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-M-Đ', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-M-T', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-M-BEI', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-M-X', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-L-Đ', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-L-T', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-L-BEI', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-L-X', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-XL-Đ', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-XL-T', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-XL-BEI', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-QUẦ-09-XL-X', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-QUẦ-09-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo khoác Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Khoác') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Khoác');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Khoác';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo khoác Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-S-Đ', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-S-T', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-S-BEI', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-S-X', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-M-Đ', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-M-T', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-M-BEI', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-M-X', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-L-Đ', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-L-T', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-L-BEI', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-L-X', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-XL-Đ', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-XL-T', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-XL-BEI', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -10-XL-X', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -10-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo khoác Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Khoác') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Khoác');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Khoác';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo khoác Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 0, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-S-Đ', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-S-T', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-S-BEI', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-S-X', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-M-Đ', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-M-T', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-M-BEI', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-M-X', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-L-Đ', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-L-T', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-L-BEI', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-L-X', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-XL-Đ', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-XL-T', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-XL-BEI', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -11-XL-X', @MaSP, @MaSize, @MaMau, 9200000, 6440000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -11-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo khoác Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Khoác') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Khoác');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Khoác';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo khoác Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 0, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-S-Đ', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-S-T', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-S-BEI', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-S-X', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-M-Đ', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-M-T', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-M-BEI', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-M-X', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-L-Đ', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-L-T', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-L-BEI', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-L-X', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-XL-Đ', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-XL-T', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-XL-BEI', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -12-XL-X', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -12-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo sơ mi Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Sơ Mi') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Sơ Mi');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Sơ Mi';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo sơ mi Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-S-Đ', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-S-T', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-S-BEI', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-S-X', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-M-Đ', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-M-T', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-M-BEI', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-M-X', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-L-Đ', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-L-T', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-L-BEI', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-L-X', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-XL-Đ', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-XL-T', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-XL-BEI', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -13-XL-X', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -13-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo sơ mi Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Sơ Mi') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Sơ Mi');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Sơ Mi';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo sơ mi Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 0, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-S-Đ', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-S-T', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-S-BEI', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-S-X', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-M-Đ', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-M-T', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-M-BEI', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-M-X', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-L-Đ', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-L-T', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-L-BEI', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-L-X', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-XL-Đ', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-XL-T', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-XL-BEI', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -14-XL-X', @MaSP, @MaSize, @MaMau, 10800000, 7559999, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -14-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo sơ mi Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Sơ Mi') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Sơ Mi');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Sơ Mi';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo sơ mi Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 0, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-S-Đ', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-S-T', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-S-BEI', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-S-X', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-M-Đ', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-M-T', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-M-BEI', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-M-X', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-L-Đ', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-L-T', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-L-BEI', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-L-X', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-XL-Đ', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-XL-T', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-XL-BEI', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -15-XL-X', @MaSP, @MaSize, @MaMau, 7400000, 5180000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -15-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo len Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Len') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Len');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Len';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo len Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 0, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-S-Đ', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-S-T', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-S-BEI', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-S-X', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-M-Đ', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-M-T', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-M-BEI', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-M-X', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-L-Đ', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-L-T', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-L-BEI', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-L-X', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-XL-Đ', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-XL-T', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-XL-BEI', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -16-XL-X', @MaSP, @MaSize, @MaMau, 7600000, 5320000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -16-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo len Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Len') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Len');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Len';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo len Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-S-Đ', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-S-T', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-S-BEI', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-S-X', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-M-Đ', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-M-T', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-M-BEI', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-M-X', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-L-Đ', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-L-T', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-L-BEI', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-L-X', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-XL-Đ', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-XL-T', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-XL-BEI', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -17-XL-X', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -17-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo len Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Len') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Len');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Len';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo len Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-S-Đ', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-S-T', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-S-BEI', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-S-X', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-M-Đ', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-M-T', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-M-BEI', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-M-X', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-L-Đ', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-L-T', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-L-BEI', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-L-X', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-XL-Đ', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-XL-T', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-XL-BEI', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-ÁO -18-XL-X', @MaSP, @MaSize, @MaMau, 9400000, 6580000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-ÁO -18-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Váy Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Váy') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Váy');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Váy';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Váy Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-S-Đ', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-S-T', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-S-BEI', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-S-X', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-M-Đ', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-M-T', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-M-BEI', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-M-X', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-L-Đ', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-L-T', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-L-BEI', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-L-X', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-XL-Đ', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-XL-T', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-XL-BEI', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-19-XL-X', @MaSP, @MaSize, @MaMau, 10400000, 7280000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-19-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Váy Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Váy') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Váy');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Váy';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Váy Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-S-Đ', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-S-T', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-S-BEI', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-S-X', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-M-Đ', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-M-T', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-M-BEI', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-M-X', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-L-Đ', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-L-T', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-L-BEI', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-L-X', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-XL-Đ', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-XL-T', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-XL-BEI', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-20-XL-X', @MaSP, @MaSize, @MaMau, 6800000, 4760000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-20-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Váy Gucci Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Gucci') INSERT INTO ThuongHieu (TenTH) VALUES (N'Gucci');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Gucci';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Váy') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Váy');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Váy';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Váy Gucci Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Gucci 2025', N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-S-Đ', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-S-T', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-S-BEI', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-S-X', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-M-Đ', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-M-T', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-M-BEI', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-M-X', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-L-Đ', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-L-T', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-L-BEI', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-L-X', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-XL-Đ', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-XL-T', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-XL-BEI', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('GUC-VÁY-21-XL-X', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU GUC-VÁY-21-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo polo Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Polo') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Polo');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Polo';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo polo Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-S-Đ', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-S-T', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-S-BEI', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-S-X', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-M-Đ', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-M-T', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-M-BEI', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-M-X', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-L-Đ', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-L-T', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-L-BEI', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-L-X', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-XL-Đ', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-XL-T', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-XL-BEI', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -01-XL-X', @MaSP, @MaSize, @MaMau, 10300000, 7210000, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -01-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo polo Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Polo') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Polo');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Polo';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo polo Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-S-Đ', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-S-T', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-S-BEI', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-S-X', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-M-Đ', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-M-T', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-M-BEI', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-M-X', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-L-Đ', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-L-T', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-L-BEI', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-L-X', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-XL-Đ', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-XL-T', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-XL-BEI', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -02-XL-X', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -02-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo thun Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'T-Shirt') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'T-Shirt');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'T-Shirt';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo thun Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-S-Đ', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-S-T', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-S-BEI', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-S-X', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-M-Đ', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-M-T', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-M-BEI', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-M-X', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-L-Đ', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-L-T', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-L-BEI', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-L-X', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-XL-Đ', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-XL-T', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-XL-BEI', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -03-XL-X', @MaSP, @MaSize, @MaMau, 8200000, 5740000, 10, 0, N'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -03-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo thun Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'T-Shirt') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'T-Shirt');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'T-Shirt';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo thun Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-S-Đ', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-S-T', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-S-BEI', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-S-X', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-M-Đ', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-M-T', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-M-BEI', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-M-X', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-L-Đ', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-L-T', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-L-BEI', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-L-X', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-XL-Đ', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-XL-T', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-XL-BEI', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -04-XL-X', @MaSP, @MaSize, @MaMau, 6400000, 4480000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -04-XL-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-S-Đ', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-S-T', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-S-BEI', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-S-X', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-M-Đ', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-M-T', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-M-BEI', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-M-X', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-L-Đ', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-L-T', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-L-BEI', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-L-X', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-XL-Đ', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-XL-T', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-XL-BEI', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -05-XL-X', @MaSP, @MaSize, @MaMau, 4400000, 3080000, 10, 0, N'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -05-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Quần Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Quần') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Quần');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Quần';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Quần Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-S-Đ', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-S-T', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-S-BEI', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-S-X', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-M-Đ', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-M-T', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-M-BEI', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-M-X', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-L-Đ', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-L-T', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-L-BEI', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-L-X', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-XL-Đ', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-XL-T', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-XL-BEI', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-06-XL-X', @MaSP, @MaSize, @MaMau, 7100000, 4970000, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-06-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Quần Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Quần') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Quần');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Quần';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Quần Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-S-Đ', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-S-T', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-S-BEI', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-S-X', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-M-Đ', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-M-T', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-M-BEI', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-M-X', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-L-Đ', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-L-T', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-L-BEI', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-L-X', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-XL-Đ', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-XL-T', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-XL-BEI', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-07-XL-X', @MaSP, @MaSize, @MaMau, 10900000, 7629999, 10, 0, N'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-07-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Quần Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Quần') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Quần');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Quần';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Quần Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-S-Đ', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-S-T', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-S-BEI', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-S-X', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-M-Đ', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-M-T', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-M-BEI', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-M-X', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-L-Đ', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-L-T', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-L-BEI', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-L-X', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-XL-Đ', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-XL-T', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-XL-BEI', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-QUẦ-08-XL-X', @MaSP, @MaSize, @MaMau, 4000000, 2800000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-QUẦ-08-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo khoác Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Khoác') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Khoác');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Khoác';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo khoác Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-S-Đ', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-S-T', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-S-BEI', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-S-X', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-M-Đ', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-M-T', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-M-BEI', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-M-X', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-L-Đ', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-L-T', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-L-BEI', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-L-X', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-XL-Đ', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-XL-T', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-XL-BEI', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -09-XL-X', @MaSP, @MaSize, @MaMau, 4300000, 3010000, 10, 0, N'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -09-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo khoác Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Khoác') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Khoác');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Khoác';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo khoác Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-S-Đ', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-S-T', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-S-BEI', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-S-X', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-M-Đ', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-M-T', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-M-BEI', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-M-X', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-L-Đ', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-L-T', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-L-BEI', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-L-X', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-XL-Đ', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-XL-T', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-XL-BEI', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -10-XL-X', @MaSP, @MaSize, @MaMau, 9100000, 6370000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -10-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo khoác Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Khoác') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Khoác');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Khoác';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo khoác Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-S-Đ', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-S-T', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-S-BEI', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-S-X', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-M-Đ', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-M-T', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-M-BEI', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-M-X', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-L-Đ', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-L-T', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-L-BEI', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-L-X', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-XL-Đ', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-XL-T', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-XL-BEI', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -11-XL-X', @MaSP, @MaSize, @MaMau, 9500000, 6650000, 10, 0, N'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -11-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo sơ mi Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Sơ Mi') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Sơ Mi');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Sơ Mi';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo sơ mi Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-S-Đ', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-S-T', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-S-BEI', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-S-X', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-M-Đ', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-M-T', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-M-BEI', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-M-X', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-L-Đ', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-L-T', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-L-BEI', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-L-X', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-XL-Đ', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-XL-T', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-XL-BEI', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -12-XL-X', @MaSP, @MaSize, @MaMau, 7000000, 4900000, 10, 0, N'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -12-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo sơ mi Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Sơ Mi') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Sơ Mi');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Sơ Mi';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo sơ mi Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-S-Đ', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-S-T', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-S-BEI', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-S-X', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-M-Đ', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-M-T', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-M-BEI', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-M-X', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-L-Đ', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-L-T', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-L-BEI', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-L-X', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-XL-Đ', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-XL-T', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-XL-BEI', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -13-XL-X', @MaSP, @MaSize, @MaMau, 5000000, 3500000, 10, 0, N'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -13-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo sơ mi Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Sơ Mi') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Sơ Mi');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Sơ Mi';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo sơ mi Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-S-Đ', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-S-T', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-S-BEI', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-S-X', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-M-Đ', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-M-T', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-M-BEI', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-M-X', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-L-Đ', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-L-T', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-L-BEI', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-L-X', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-XL-Đ', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-XL-T', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-XL-BEI', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -14-XL-X', @MaSP, @MaSize, @MaMau, 11400000, 7979999, 10, 0, N'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -14-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo len Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Len') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Len');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Len';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo len Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-S-Đ', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-S-T', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-S-BEI', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-S-X', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-M-Đ', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-M-T', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-M-BEI', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-M-X', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-L-Đ', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-L-T', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-L-BEI', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-L-X', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-XL-Đ', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-XL-T', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-XL-BEI', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -15-XL-X', @MaSP, @MaSize, @MaMau, 8600000, 6020000, 10, 0, N'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -15-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo len Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Len') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Len');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Len';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo len Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 2, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-S-Đ', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-S-T', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-S-BEI', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-S-X', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-M-Đ', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-M-T', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-M-BEI', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-M-X', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-L-Đ', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-L-T', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-L-BEI', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-L-X', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-XL-Đ', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-XL-T', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-XL-BEI', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -16-XL-X', @MaSP, @MaSize, @MaMau, 5600000, 3919999, 10, 0, N'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -16-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Áo len Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Áo Len') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Áo Len');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo Len';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Áo len Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 0, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-S-Đ', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-S-T', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-S-BEI', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-S-X', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-M-Đ', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-M-T', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-M-BEI', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-M-X', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-L-Đ', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-L-T', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-L-BEI', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-L-X', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-XL-Đ', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-XL-T', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-XL-BEI', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-ÁO -17-XL-X', @MaSP, @MaSize, @MaMau, 4500000, 3150000, 10, 0, N'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-ÁO -17-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Váy Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Váy') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Váy');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Váy';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Váy Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-S-Đ', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-S-T', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-S-BEI', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-S-X', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-M-Đ', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-M-T', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-M-BEI', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-M-X', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-L-Đ', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-L-T', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-L-BEI', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-L-X', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-XL-Đ', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-XL-T', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-XL-BEI', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-18-XL-X', @MaSP, @MaSize, @MaMau, 6200000, 4340000, 10, 0, N'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-18-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Váy Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Váy') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Váy');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Váy';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Váy Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-S-Đ', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-S-T', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-S-BEI', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-S-X', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-M-Đ', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-M-T', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-M-BEI', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-M-X', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-L-Đ', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-L-T', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-L-BEI', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-L-X', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-XL-Đ', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-XL-T', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-XL-BEI', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-19-XL-X', @MaSP, @MaSize, @MaMau, 10500000, 7349999, 10, 0, N'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-19-XL-X: ' + ERROR_MESSAGE(); END CATCH

-- Product: Váy Chanel Luxury Collection
IF NOT EXISTS (SELECT 1 FROM ThuongHieu WHERE TenTH = N'Chanel') INSERT INTO ThuongHieu (TenTH) VALUES (N'Chanel');
SELECT @MaTH = MaTH FROM ThuongHieu WHERE TenTH = N'Chanel';
IF NOT EXISTS (SELECT 1 FROM LoaiSanPham WHERE TenLoai = N'Váy') INSERT INTO LoaiSanPham (TenLoai) VALUES (N'Váy');
SELECT @MaLoai = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Váy';
INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) 
VALUES (N'Váy Chanel Luxury Collection', @MaLoai, @MaTH, N'Bộ sưu tập cao cấp Chanel 2025', N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1, 1);
SET @MaSP = SCOPE_IDENTITY();
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-S-Đ', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-S-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-S-T', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-S-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-S-BEI', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-S-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'S') INSERT INTO SizeSP (TenSize) VALUES (N'S');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'S';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-S-X', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-S-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-M-Đ', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-M-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-M-T', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-M-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-M-BEI', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-M-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'M') INSERT INTO SizeSP (TenSize) VALUES (N'M');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'M';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-M-X', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-M-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-L-Đ', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-L-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-L-T', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-L-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-L-BEI', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-L-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'L') INSERT INTO SizeSP (TenSize) VALUES (N'L');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'L';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-L-X', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-L-X: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Đen') INSERT INTO MauSacSP (TenMau) VALUES (N'Đen');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Đen';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-XL-Đ', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-XL-Đ: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Trắng') INSERT INTO MauSacSP (TenMau) VALUES (N'Trắng');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-XL-T', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-XL-T: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Be') INSERT INTO MauSacSP (TenMau) VALUES (N'Be');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Be';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-XL-BEI', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-XL-BEI: ' + ERROR_MESSAGE(); END CATCH
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SizeSP WHERE TenSize = N'XL') INSERT INTO SizeSP (TenSize) VALUES (N'XL');
        IF NOT EXISTS (SELECT 1 FROM MauSacSP WHERE TenMau = N'Xanh') INSERT INTO MauSacSP (TenMau) VALUES (N'Xanh');
        SELECT @MaSize = MaSize FROM SizeSP WHERE TenSize = N'XL';
        SELECT @MaMau = MaMau FROM MauSacSP WHERE TenMau = N'Xanh';
        INSERT INTO SanPhamChiTiet (SKU, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan, AnhBienThe, TrangThai) 
        VALUES ('CHA-VÁY-20-XL-X', @MaSP, @MaSize, @MaMau, 6700000, 4690000, 10, 0, N'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1);
    END TRY BEGIN CATCH PRINT N'Error inserting SKU CHA-VÁY-20-XL-X: ' + ERROR_MESSAGE(); END CATCH

GO
PRINT N'--- DATA SYNC COMPLETED SUCCESSFULLY ---';