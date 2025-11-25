/*
================================================================================
KỊCH BẢN TẠO CƠ SỞ DỮ LIỆU LUXURY FASHION (BẢN PRODUCTION 2025)
HỆ QUẢN TRỊ: SQL SERVER
MÔ TẢ: Sắp xếp lại cấu trúc gọn gàng (DDL -> DML -> Query).
================================================================================
*/

-- =============================================================================
-- PHẦN 0: KHỞI TẠO DATABASE
-- =============================================================================
USE master;
GO

IF DB_ID('LuxuryFashion_2025') IS NOT NULL
BEGIN
    ALTER DATABASE LuxuryFashion_2025 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LuxuryFashion_2025;
END
GO

CREATE DATABASE LuxuryFashion_2025;
GO

USE LuxuryFashion_2025;
GO
PRINT N'✅ PHẦN 0: TẠO DATABASE THÀNH CÔNG!';
GO

-- =============================================================================
-- PHẦN 1: HỦY CÁC BẢNG CŨ (DROP TABLES)
-- =============================================================================
IF OBJECT_ID('dbo.TinNhan', 'U') IS NOT NULL DROP TABLE dbo.TinNhan;
IF OBJECT_ID('dbo.PhongChat', 'U') IS NOT NULL DROP TABLE dbo.PhongChat;
IF OBJECT_ID('dbo.DangKyThanhVien', 'U') IS NOT NULL DROP TABLE dbo.DangKyThanhVien;
IF OBJECT_ID('dbo.NhapKhoChiTiet', 'U') IS NOT NULL DROP TABLE dbo.NhapKhoChiTiet;
IF OBJECT_ID('dbo.PhieuNhap', 'U') IS NOT NULL DROP TABLE dbo.PhieuNhap;
IF OBJECT_ID('dbo.NhaCungCap', 'U') IS NOT NULL DROP TABLE dbo.NhaCungCap;
IF OBJECT_ID('dbo.GioHangChiTiet', 'U') IS NOT NULL DROP TABLE dbo.GioHangChiTiet;
IF OBJECT_ID('dbo.GioHang', 'U') IS NOT NULL DROP TABLE dbo.GioHang;
IF OBJECT_ID('dbo.BinhLuan', 'U') IS NOT NULL DROP TABLE dbo.BinhLuan;
IF OBJECT_ID('dbo.BaiViet', 'U') IS NOT NULL DROP TABLE dbo.BaiViet;
IF OBJECT_ID('dbo.LoaiBaiViet', 'U') IS NOT NULL DROP TABLE dbo.LoaiBaiViet;
IF OBJECT_ID('dbo.DanhGia', 'U') IS NOT NULL DROP TABLE dbo.DanhGia;
IF OBJECT_ID('dbo.DonHangCT', 'U') IS NOT NULL DROP TABLE dbo.DonHangCT;
IF OBJECT_ID('dbo.LichSuDonHang', 'U') IS NOT NULL DROP TABLE dbo.LichSuDonHang;
IF OBJECT_ID('dbo.DonHang', 'U') IS NOT NULL DROP TABLE dbo.DonHang;
IF OBJECT_ID('dbo.HinhThucThanhToan', 'U') IS NOT NULL DROP TABLE dbo.HinhThucThanhToan;
IF OBJECT_ID('dbo.KhuyenMai_ChiTiet', 'U') IS NOT NULL DROP TABLE dbo.KhuyenMai_ChiTiet;
IF OBJECT_ID('dbo.KhuyenMai', 'U') IS NOT NULL DROP TABLE dbo.KhuyenMai;
IF OBJECT_ID('dbo.GoiThanhVien', 'U') IS NOT NULL DROP TABLE dbo.GoiThanhVien;
IF OBJECT_ID('dbo.HinhAnhSP', 'U') IS NOT NULL DROP TABLE dbo.HinhAnhSP;
IF OBJECT_ID('dbo.SanPhamChiTiet', 'U') IS NOT NULL DROP TABLE dbo.SanPhamChiTiet;
IF OBJECT_ID('dbo.SanPham', 'U') IS NOT NULL DROP TABLE dbo.SanPham;
IF OBJECT_ID('dbo.MauSacSP', 'U') IS NOT NULL DROP TABLE dbo.MauSacSP;
IF OBJECT_ID('dbo.SizeSP', 'U') IS NOT NULL DROP TABLE dbo.SizeSP;
IF OBJECT_ID('dbo.LoaiSanPham', 'U') IS NOT NULL DROP TABLE dbo.LoaiSanPham;
IF OBJECT_ID('dbo.ThuongHieu', 'U') IS NOT NULL DROP TABLE dbo.ThuongHieu;
IF OBJECT_ID('dbo.SoDiaChi', 'U') IS NOT NULL DROP TABLE dbo.SoDiaChi;
IF OBJECT_ID('dbo.TaiKhoan_Role', 'U') IS NOT NULL DROP TABLE dbo.TaiKhoan_Role;
IF OBJECT_ID('dbo.Role', 'U') IS NOT NULL DROP TABLE dbo.Role;
IF OBJECT_ID('dbo.TaiKhoan', 'U') IS NOT NULL DROP TABLE dbo.TaiKhoan;
IF OBJECT_ID('dbo.TrangThaiDonHang', 'U') IS NOT NULL DROP TABLE dbo.TrangThaiDonHang;
IF OBJECT_ID('dbo.ThongKe', 'U') IS NOT NULL DROP TABLE dbo.ThongKe;
IF OBJECT_ID('dbo.NhapKho', 'U') IS NOT NULL DROP TABLE dbo.NhapKho;
GO
PRINT N'✅ PHẦN 1: HỦY BẢNG CŨ THÀNH CÔNG!';
GO

-- =============================================================================
-- PHẦN 2: TẠO CẤU TRÚC BẢNG (CREATE TABLES)
-- =============================================================================

-- 2.1. Nhóm Tài khoản & Quyền
CREATE TABLE TaiKhoan (
    MaTK BIGINT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    MatKhau VARCHAR(255) NOT NULL,
    SoDienThoai VARCHAR(20),
    DiaChi NVARCHAR(255),
    Avatar NVARCHAR(255),
    LastLogin DATETIME,
    TrangThai BIT NOT NULL DEFAULT 1,
    NgayTao DATETIME DEFAULT GETDATE(),
    NgayCapNhat DATETIME DEFAULT GETDATE()
);

CREATE TABLE Role (
    MaRole BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenRole VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE TaiKhoan_Role (
    MaTK BIGINT NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK),
    MaRole BIGINT NOT NULL FOREIGN KEY REFERENCES Role(MaRole),
    PRIMARY KEY (MaTK, MaRole)
);

CREATE TABLE SoDiaChi (
    MaDiaChi BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaTK BIGINT NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK),
    HoTenNguoiNhan NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(20) NOT NULL,
    DiaChiChiTiet NVARCHAR(500) NOT NULL,
    LaMacDinh BIT DEFAULT 0
);

-- 2.2. Nhóm Sản phẩm & Thuộc tính
CREATE TABLE ThuongHieu (
    MaTH BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenTH NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(255)
);

CREATE TABLE LoaiSanPham (
    MaLoai BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenLoai NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(255)
);

CREATE TABLE SizeSP (
    MaSize BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenSize NVARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE MauSacSP (
    MaMau BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenMau NVARCHAR(50) UNIQUE NOT NULL,
    MaHex VARCHAR(7)
);

CREATE TABLE SanPham (
    MaSP BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenSP NVARCHAR(255) NOT NULL,
    MaLoai BIGINT FOREIGN KEY REFERENCES LoaiSanPham(MaLoai) ON DELETE SET NULL,
    MaTH BIGINT FOREIGN KEY REFERENCES ThuongHieu(MaTH) ON DELETE SET NULL,
    MoTa NVARCHAR(MAX),
    AnhChinh NVARCHAR(255),
    GioiTinh INT NOT NULL DEFAULT 2, -- 0=Nam, 1=Nữ, 2=Unisex
    TrangThaiSP INT NOT NULL DEFAULT 1, -- 1: Đang bán, 0: Ngừng bán
    NgayTao DATETIME DEFAULT GETDATE(),
    NgayCapNhat DATETIME DEFAULT GETDATE()
);

CREATE TABLE SanPhamChiTiet (
    MaBienThe BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaSP BIGINT NOT NULL FOREIGN KEY REFERENCES SanPham(MaSP) ON DELETE CASCADE,
    MaSize BIGINT FOREIGN KEY REFERENCES SizeSP(MaSize) ON DELETE SET NULL,
    MaMau BIGINT FOREIGN KEY REFERENCES MauSacSP(MaMau) ON DELETE SET NULL,
    GiaBan DECIMAL(18, 2) NOT NULL,
    GiaNhap DECIMAL(18, 2) DEFAULT 0,
    SoLuongTon INT DEFAULT 0,
    SoLuongDaBan INT DEFAULT 0,
    AnhBienThe NVARCHAR(255),
    CONSTRAINT UK_SanPham_Variant UNIQUE (MaSP, MaSize, MaMau)
);

CREATE TABLE HinhAnhSP (
    MaAnh BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaSP BIGINT NOT NULL FOREIGN KEY REFERENCES SanPham(MaSP) ON DELETE CASCADE,
    DuongDan NVARCHAR(255)
);

-- 2.3. Nhóm Khuyến mãi & Thành viên
CREATE TABLE GoiThanhVien (
    MaGoi BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenGoi NVARCHAR(100),
    Gia DECIMAL(18, 2),
    ThoiHan INT, -- Số ngày
    UuDai NVARCHAR(255)
);

CREATE TABLE KhuyenMai (
    MaKM BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenKM NVARCHAR(100) NOT NULL,
    MaCode VARCHAR(50) UNIQUE NOT NULL,
    LoaiKM VARCHAR(50),
    LoaiGiaTri INT DEFAULT 0, -- 0: %, 1: VND
    GiaTri DECIMAL(18, 2),
    NgayBatDau DATETIME NOT NULL,
    NgayKetThuc DATETIME,
    MaGoi BIGINT FOREIGN KEY REFERENCES GoiThanhVien(MaGoi) ON DELETE SET NULL,
    TrangThai BIT DEFAULT 1,
    SoLanSuDung INT DEFAULT 0
);

CREATE TABLE KhuyenMai_ChiTiet (
    MaKM BIGINT NOT NULL FOREIGN KEY REFERENCES KhuyenMai(MaKM) ON DELETE CASCADE,
    MaSP BIGINT FOREIGN KEY REFERENCES SanPham(MaSP) ON DELETE NO ACTION,
    MaBienThe BIGINT FOREIGN KEY REFERENCES SanPhamChiTiet(MaBienThe) ON DELETE CASCADE,
    CONSTRAINT UK_KhuyenMai_ChiTiet UNIQUE (MaKM, MaSP, MaBienThe)
);

CREATE TABLE DangKyThanhVien (
    MaDK BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaTK BIGINT NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE CASCADE,
    MaGoi BIGINT NOT NULL FOREIGN KEY REFERENCES GoiThanhVien(MaGoi) ON DELETE CASCADE,
    NgayBatDau DATETIME DEFAULT GETDATE(),
    NgayKetThuc DATETIME,
    TrangThai INT DEFAULT 1
);

-- 2.4. Nhóm Đơn hàng & Thanh toán
CREATE TABLE HinhThucThanhToan (
    MaHinhThucTT BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenHinhThuc NVARCHAR(100) UNIQUE NOT NULL,
    MoTa NVARCHAR(255),
    TrangThai BIT DEFAULT 1
);

CREATE TABLE TrangThaiDonHang (
    MaTTDH INT IDENTITY(0,1) PRIMARY KEY, -- Bắt đầu từ 0
    TenTTDH NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE DonHang (
    MaDH BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaTK BIGINT FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE SET NULL,
    MaNhanVien BIGINT FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE NO ACTION,
    NgayDat DATETIME DEFAULT GETDATE(),
    TongTien DECIMAL(18, 2) DEFAULT 0,
    PhiShip DECIMAL(18, 2) DEFAULT 0,
    MaKM BIGINT FOREIGN KEY REFERENCES KhuyenMai(MaKM) ON DELETE SET NULL,
    MaDiaChiGiao BIGINT FOREIGN KEY REFERENCES SoDiaChi(MaDiaChi) ON DELETE SET NULL,
    MaHinhThucTT BIGINT FOREIGN KEY REFERENCES HinhThucThanhToan(MaHinhThucTT) ON DELETE SET NULL,
    GhiChu NVARCHAR(500),
    LyDoHuy NVARCHAR(255),
    MaGiaoDich VARCHAR(100),
    TrangThaiDH INT NOT NULL DEFAULT 0,
    TrangThaiThanhToan INT NOT NULL DEFAULT 0, -- 0=Chờ, 1=Đã TT, 2=Lỗi, 3=Hoàn tiền
    NgayThanhToan DATETIME NULL,
    NgayCapNhat DATETIME DEFAULT GETDATE()
);

CREATE TABLE DonHangCT (
    MaCT BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaDH BIGINT NOT NULL FOREIGN KEY REFERENCES DonHang(MaDH) ON DELETE CASCADE,
    MaBienThe BIGINT FOREIGN KEY REFERENCES SanPhamChiTiet(MaBienThe) ON DELETE SET NULL,
    SoLuong INT,
    DonGia DECIMAL(18, 2)
);

CREATE TABLE LichSuDonHang (
    MaLichSu BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaDH BIGINT NOT NULL FOREIGN KEY REFERENCES DonHang(MaDH) ON DELETE CASCADE,
    TrangThaiCu INT NOT NULL,
    TrangThaiMoi INT NOT NULL,
    ThoiGian DATETIME DEFAULT GETDATE(),
    GhiChu NVARCHAR(255),
    NguoiCapNhat NVARCHAR(50)
);

CREATE TABLE DanhGia (
    MaDG BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaCT BIGINT UNIQUE NOT NULL FOREIGN KEY REFERENCES DonHangCT(MaCT) ON DELETE CASCADE,
    MaTK BIGINT NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE CASCADE,
    NoiDung NVARCHAR(500),
    Diem INT NOT NULL CHECK (Diem >= 1 AND Diem <= 5),
    HinhAnh NVARCHAR(255),
    NgayDanhGia DATETIME DEFAULT GETDATE(),
    SoLuongLike INT DEFAULT 0,
    SoLuongPhanHoi INT DEFAULT 0
);

-- 2.5. Nhóm Giỏ hàng
CREATE TABLE GioHang (
    MaGioHang BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaTK BIGINT UNIQUE NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE CASCADE
);

CREATE TABLE GioHangChiTiet (
    MaGH_CT BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaGioHang BIGINT NOT NULL FOREIGN KEY REFERENCES GioHang(MaGioHang) ON DELETE CASCADE,
    MaBienThe BIGINT NOT NULL FOREIGN KEY REFERENCES SanPhamChiTiet(MaBienThe) ON DELETE CASCADE,
    SoLuong INT DEFAULT 1,
    NgayThem DATETIME DEFAULT GETDATE(),
    CONSTRAINT UK_GioHang_BienThe UNIQUE (MaGioHang, MaBienThe)
);

-- 2.6. Nhóm Bài viết & Bình luận
CREATE TABLE LoaiBaiViet (
    MaLoaiBV BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenLoaiBV NVARCHAR(100)
);

CREATE TABLE BaiViet (
    MaBV BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaLoaiBV BIGINT FOREIGN KEY REFERENCES LoaiBaiViet(MaLoaiBV) ON DELETE SET NULL,
    MaTK BIGINT FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE SET NULL,
    TieuDe NVARCHAR(255),
    NoiDung NVARCHAR(MAX),
    HinhAnh NVARCHAR(255),
    LuotXem INT DEFAULT 0,
    TrangThai BIT DEFAULT 1,
    Slug VARCHAR(255) UNIQUE,
    NgayDang DATETIME DEFAULT GETDATE()
);

CREATE TABLE BinhLuan (
    MaBL BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaSP BIGINT FOREIGN KEY REFERENCES SanPham(MaSP) ON DELETE CASCADE,
    MaBV BIGINT FOREIGN KEY REFERENCES BaiViet(MaBV) ON DELETE CASCADE,
    MaTK BIGINT NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE CASCADE,
    NoiDung NVARCHAR(500) NOT NULL,
    NgayBinhLuan DATETIME DEFAULT GETDATE(),
    AnDanh BIT DEFAULT 0,
    TrangThai BIT DEFAULT 1,
    SoLuongLike INT DEFAULT 0,
    SoLuongPhanHoi INT DEFAULT 0,
    CONSTRAINT CK_BinhLuan CHECK (MaSP IS NOT NULL OR MaBV IS NOT NULL)
);

-- 2.7. Nhóm Kho hàng & Nhà cung cấp
CREATE TABLE NhaCungCap (
    MaNCC BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenNCC NVARCHAR(100),
    SoDienThoai VARCHAR(20),
    DiaChi NVARCHAR(255)
);

CREATE TABLE PhieuNhap (
    MaPN BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaNV BIGINT NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE NO ACTION,
    MaNCC BIGINT FOREIGN KEY REFERENCES NhaCungCap(MaNCC) ON DELETE SET NULL,
    NgayNhap DATETIME DEFAULT GETDATE(),
    TongTien DECIMAL(18, 2) DEFAULT 0,
    GhiChu NVARCHAR(500)
);

CREATE TABLE NhapKhoChiTiet (
    MaNK_CT BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaPN BIGINT NOT NULL FOREIGN KEY REFERENCES PhieuNhap(MaPN) ON DELETE CASCADE,
    MaBienThe BIGINT NOT NULL FOREIGN KEY REFERENCES SanPhamChiTiet(MaBienThe) ON DELETE CASCADE,
    SoLuong INT,
    DonGiaNhap DECIMAL(18, 2),
    ThanhTien DECIMAL(18, 2)
);

CREATE TABLE NhapKho (
    MaNK INT IDENTITY(1,1) PRIMARY KEY,
    MaSP BIGINT NOT NULL FOREIGN KEY REFERENCES SanPham(MaSP) ON DELETE CASCADE,
    SoLuong INT NOT NULL,
    NgayNhap DATETIME DEFAULT GETDATE()
);

-- 2.8. Nhóm Chat & Thống kê
CREATE TABLE PhongChat (
    MaPhong BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaTK BIGINT UNIQUE NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE CASCADE,
    MaNV BIGINT FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE NO ACTION,
    TrangThai INT DEFAULT 0,
    NgayTao DATETIME DEFAULT GETDATE()
);

CREATE TABLE TinNhan (
    MaTinNhan BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaPhong BIGINT NOT NULL FOREIGN KEY REFERENCES PhongChat(MaPhong) ON DELETE CASCADE,
    MaNguoiGui BIGINT NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK),
    LoaiNguoiGui INT DEFAULT 0, -- 0=Khách, 1=Nhân viên, 2=Bot
    LoaiTinNhan INT DEFAULT 0, -- 0=Text, 1=Image
    NoiDung NVARCHAR(MAX),
    ThoiGianGui DATETIME DEFAULT GETDATE(),
    DaDoc BIT DEFAULT 0
);

CREATE TABLE ThongKe (
    MaThongKe INT IDENTITY(1,1) PRIMARY KEY,
    NgayBaoCao DATE NOT NULL UNIQUE,
    TongDoanhThu DECIMAL(18,2) NOT NULL,
    TongDonHang INT NOT NULL,
    TongSanPhamBanRa INT NOT NULL
);
GO
PRINT N'✅ PHẦN 2: TẠO CẤU TRÚC BẢNG THÀNH CÔNG!';
GO

-- =============================================================================
-- PHẦN 3: CẬP NHẬT CẤU TRÚC (ALTER TABLE - OAUTH2 & PAYOS)
-- =============================================================================

-- 3.1. Cập nhật cho OAuth2 (Google Login)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('TaiKhoan') AND name = 'Provider')
BEGIN
    ALTER TABLE TaiKhoan ADD Provider VARCHAR(20) DEFAULT 'LOCAL';
    PRINT N'✅ Đã thêm cột Provider vào bảng TaiKhoan';
END
GO
-- Cho phép MatKhau NULL
ALTER TABLE TaiKhoan ALTER COLUMN MatKhau VARCHAR(255) NULL;
GO

-- 3.2. Cập nhật cho PayOS
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('DonHang') AND name = 'LyDoHuy')
BEGIN
    ALTER TABLE DonHang ADD LyDoHuy NVARCHAR(255);
    PRINT N'✅ Đã thêm cột LyDoHuy vào bảng DonHang';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('DonHang') AND name = 'MaGiaoDich')
BEGIN
    ALTER TABLE DonHang ADD MaGiaoDich VARCHAR(100);
    PRINT N'✅ Đã thêm cột MaGiaoDich vào bảng DonHang';
END
GO
PRINT N'✅ PHẦN 3: CẬP NHẬT CẤU TRÚC (ALTER) THÀNH CÔNG!';
GO

-- =============================================================================
-- PHẦN 4: CHÈN DỮ LIỆU MẪU (INSERT DATA)
-- =============================================================================

-- 4.1. Dữ liệu Danh mục & Cơ bản
SET IDENTITY_INSERT dbo.Role ON;
INSERT INTO Role (MaRole, TenRole) VALUES (1, 'ADMIN'), (2, 'NHANVIEN'), (3, 'KHACHHANG');
SET IDENTITY_INSERT dbo.Role OFF;
GO

SET IDENTITY_INSERT dbo.TaiKhoan ON;
INSERT INTO TaiKhoan (MaTK, HoTen, Email, MatKhau, SoDienThoai, DiaChi, TrangThai) VALUES
(1, N'Admin Luxury', 'admin@luxury.com', '123', '0900000001', N'123 Đường Admin, Q1, TP.HCM', 1),
(2, N'Nguyễn Thị Bán Hàng', 'nhanvien@luxury.com', '123', '0900000002', N'456 Đường Nhân Viên, Q3, TP.HCM', 1),
(3, N'Lê Văn Khách', 'khachhang@luxury.com', '123', '0900000003', N'789 Đường Khách Hàng, Q.Tân Bình, TP.HCM', 1);
SET IDENTITY_INSERT dbo.TaiKhoan OFF;
GO

-- Cập nhật Provider = LOCAL cho dữ liệu vừa insert
UPDATE TaiKhoan SET Provider = 'LOCAL' WHERE Provider IS NULL;
GO

INSERT INTO TaiKhoan_Role (MaTK, MaRole) VALUES (1, 1), (2, 2), (3, 3);
GO

SET IDENTITY_INSERT dbo.ThuongHieu ON;
INSERT INTO ThuongHieu (MaTH, TenTH, MoTa) VALUES
(1, N'Gucci', N'Thương hiệu thời trang cao cấp của Ý'),
(2, N'Chanel', N'Thương hiệu thời trang cao cấp của Pháp'),
(3, N'MLB', N'Thương hiệu thời trang thể thao Hàn Quốc'),
(4, N'Test Brand', N'Thương hiệu test'); -- Thêm Brand Test
SET IDENTITY_INSERT dbo.ThuongHieu OFF;
GO

SET IDENTITY_INSERT dbo.LoaiSanPham ON;
INSERT INTO LoaiSanPham (MaLoai, TenLoai, MoTa) VALUES
(1, N'Áo Polo', N'Các loại áo polo'),
(2, N'T-Shirt', N'Áo thun nam nữ'),
(3, N'Quần', N'Quần thời trang'),
(4, N'Áo Khoác', N'Áo khoác thời trang'),
(5, N'Áo thun', N'Áo thun cotton'); -- Thêm Loại Test
SET IDENTITY_INSERT dbo.LoaiSanPham OFF;
GO

SET IDENTITY_INSERT dbo.SizeSP ON;
INSERT INTO SizeSP (MaSize, TenSize) VALUES (1, N'S'), (2, N'M'), (3, N'L'), (4, N'XL');
SET IDENTITY_INSERT dbo.SizeSP OFF;
GO

SET IDENTITY_INSERT dbo.MauSacSP ON;
INSERT INTO MauSacSP (MaMau, TenMau, MaHex) VALUES (1, N'Đen', '#000000'), (2, N'Trắng', '#FFFFFF'), (3, N'Be', '#F5F5DC'), (4, N'Xanh đen', '#0A2342');
SET IDENTITY_INSERT dbo.MauSacSP OFF;
GO

SET IDENTITY_INSERT dbo.HinhThucThanhToan ON;
INSERT INTO HinhThucThanhToan (MaHinhThucTT, TenHinhThuc, MoTa, TrangThai) VALUES
(1, N'Thanh toán khi nhận hàng (COD)', N'Trả tiền mặt khi shipper giao hàng', 1),
(2, N'Thanh toán qua VNPay', N'Quét mã QR qua cổng VNPay', 1),
(3, N'PayOS', N'Thanh toán qua QR Code PayOS (Ngân hàng)', 1); -- Thêm PayOS
SET IDENTITY_INSERT dbo.HinhThucThanhToan OFF;
GO

SET IDENTITY_INSERT dbo.NhaCungCap ON;
INSERT INTO NhaCungCap (MaNCC, TenNCC, SoDienThoai, DiaChi) VALUES
(1, N'Nhà phân phối Gucci VN', '02811112222', N'10 Nguyễn Trãi, Q1, TP.HCM');
SET IDENTITY_INSERT dbo.NhaCungCap OFF;
GO

SET IDENTITY_INSERT dbo.GoiThanhVien ON;
INSERT INTO GoiThanhVien (MaGoi, TenGoi, Gia, ThoiHan, UuDai) VALUES
(1, N'VIP Gold', 5000000, 365, N'Giảm 10% mọi đơn hàng');
SET IDENTITY_INSERT dbo.GoiThanhVien OFF;
GO

SET IDENTITY_INSERT dbo.LoaiBaiViet ON;
INSERT INTO LoaiBaiViet (MaLoaiBV, TenLoaiBV) VALUES (1, N'Xu hướng thời trang');
SET IDENTITY_INSERT dbo.LoaiBaiViet OFF;
GO

SET IDENTITY_INSERT dbo.KhuyenMai ON;
INSERT INTO KhuyenMai (MaKM, TenKM, MaCode, LoaiKM, LoaiGiaTri, GiaTri, NgayBatDau, NgayKetThuc, TrangThai) VALUES
(1, N'Giảm giá 10% toàn cửa hàng', 'HE2025', N'Toàn cửa hàng', 0, 10.00, GETDATE() - 1, GETDATE() + 30, 1);
SET IDENTITY_INSERT dbo.KhuyenMai OFF;
GO

SET IDENTITY_INSERT dbo.TrangThaiDonHang ON;
INSERT INTO TrangThaiDonHang (MaTTDH, TenTTDH) VALUES
(0, N'Chờ xác nhận'), (1, N'Đã xác nhận'), (2, N'Đang giao'), (3, N'Hoàn tất'), (4, N'Đã hủy');
SET IDENTITY_INSERT dbo.TrangThaiDonHang OFF;
GO

-- 4.2. Chèn Sản Phẩm Chính (Luxury)
SET IDENTITY_INSERT dbo.SanPham ON;
INSERT INTO SanPham (MaSP, TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) VALUES
(1, N'Áo Polo Gucci Cotton', 1, 1, N'Áo polo Gucci', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 2, 1),
(2, N'Áo Thun Gucci Print', 2, 1, N'Áo thun Gucci', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 2, 1),
(3, N'Quần Gucci Trackpant', 3, 1, N'Quần Gucci', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 2, 1),
(4, N'Áo Khoác Gucci GG', 4, 1, N'Áo khoác Gucci', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 2, 1),
(5, N'Áo Polo Chanel Logo', 1, 2, N'Polo Chanel', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 2, 1),
(6, N'T-Shirt Chanel Classic', 2, 2, N'Áo thun Chanel', 'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 2, 1),
(7, N'Quần Chanel Pants', 3, 2, N'Quần Chanel', 'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 2, 1),
(8, N'Áo Khoác Chanel Jacket', 4, 2, N'Jacket Chanel', 'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 2, 1),
(9, N'Áo Polo MLB Monogram', 1, 3, N'Polo MLB', 'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 2, 1),
(10, N'T-Shirt MLB BigLogo', 2, 3, N'Áo thun MLB', 'https://bizweb.dktcdn.net/100/446/974/products/ao-mlb-classic-monogram-big-logo-short-sleeve-t-shirt-new-york-yankees-black-3atsm0233-50bks-3.jpg?v=1686635060437', 2, 1),
(11, N'Quần MLB Sport', 3, 3, N'Quần MLB', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/10/quan-jogger-mlb-classic-sports-logo-jogger-pants-la-dodgers-3fptg0134-07nys-mau-xanh-navy-652e5465a27ea-17102023163117.jpg', 2, 1),
(12, N'Áo Khoác MLB Varsity', 4, 3, N'Áo khoác MLB', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/10/ao-bomber-mlb-wool-basic-varsity-jacket-new-york-yankees-3ajpv0634-50bkl-mau-den-652de78bbbe8d-17102023084651.jpg', 2, 1);
SET IDENTITY_INSERT dbo.SanPham OFF;
GO

-- 4.3. Chèn Biến thể (SKU)
SET IDENTITY_INSERT dbo.SanPhamChiTiet ON;
-- GUCCI
INSERT INTO SanPhamChiTiet (MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe) VALUES
(1, 1, 1, 1, 15000000, 8000000, 20, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1645054205/658077_XJDIJ_1082_001_100_0000_Light.jpg'),
(2, 1, 2, 1, 15000000, 8000000, 25, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1645054205/658077_XJDIJ_1082_001_100_0000_Light.jpg'),
(3, 1, 3, 2, 15000000, 8000000, 15, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1685372400/745249_XJF4M_9037_001_100_0000_Light.jpg'),
(4, 1, 4, 2, 15000000, 8000000, 10, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1685372400/745249_XJF4M_9037_001_100_0000_Light.jpg'),
(5, 2, 1, 1, 12000000, 6000000, 20, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1684162800/548334_XJDAF_1082_001_100_0000_Light.jpg'),
(6, 2, 2, 1, 12000000, 6000000, 25, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1684162800/548334_XJDAF_1082_001_100_0000_Light.jpg'),
(7, 2, 3, 2, 12000000, 6000000, 10, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1684162800/548334_XJDAF_9088_001_100_0000_Light.jpg'),
(8, 2, 4, 2, 12000000, 6000000, 5, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1684162800/548334_XJDAF_9088_001_100_0000_Light.jpg'),
(9, 3, 1, 1, 18000000, 9000000, 10, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1690218000/751555_XJF23_1082_001_100_0000_Light.jpg'),
(10, 3, 2, 1, 18000000, 9000000, 12, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1690218000/751555_XJF23_1082_001_100_0000_Light.jpg'),
(11, 3, 3, 1, 18000000, 9000000, 8, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1690218000/751555_XJF23_1082_001_100_0000_Light.jpg'),
(12, 3, 4, 1, 18000000, 9000000, 5, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1690218000/751555_XJF23_1082_001_100_0000_Light.jpg'),
(13, 4, 1, 3, 35000000, 20000000, 6, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1633453207/658077_XJDIJ_2184_001_100_0000_Light.jpg'),
(14, 4, 2, 3, 35000000, 20000000, 5, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1633453207/658077_XJDIJ_2184_001_100_0000_Light.jpg'),
(15, 4, 3, 3, 35000000, 20000000, 4, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1633453207/658077_XJDIJ_2184_001_100_0000_Light.jpg'),
(16, 4, 4, 3, 35000000, 20000000, 3, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1633453207/658077_XJDIJ_2184_001_100_0000_Light.jpg');
-- CHANEL
INSERT INTO SanPhamChiTiet (MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe) VALUES
(17, 5, 1, 1, 11000000, 6000000, 20, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1676402323907-23p-p74656-k10703-94305-black-8817332994078.jpg'),
(18, 5, 2, 1, 11000000, 6000000, 20, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1676402323907-23p-p74656-k10703-94305-black-8817332994078.jpg'),
(19, 5, 3, 2, 11000000, 6000000, 12, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1676402323907-23p-p74656-k10703-10601-white-8817333026846.jpg'),
(20, 5, 4, 2, 11000000, 6000000, 8, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1676402323907-23p-p74656-k10703-10601-white-8817333026846.jpg'),
(21, 6, 1, 1, 10000000, 5000000, 15, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1708596821111-24p-p76388-k10924-94305-black-8847388110878.jpg'),
(22, 6, 2, 1, 10000000, 5000000, 20, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1708596821111-24p-p76388-k10924-94305-black-8847388110878.jpg'),
(23, 6, 3, 2, 10000000, 5000000, 10, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1708596821111-24p-p76388-k10924-10601-white-8847388143646.jpg'),
(24, 6, 4, 2, 10000000, 5000000, 7, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1708596821111-24p-p76388-k10924-10601-white-8847388143646.jpg'),
(25, 7, 1, 1, 15000000, 8000000, 12, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-black-8835089629214.jpg'),
(26, 7, 2, 1, 15000000, 8000000, 10, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-black-8835089629214.jpg'),
(27, 7, 3, 1, 15000000, 8000000, 8, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-black-8835089629214.jpg'),
(28, 7, 4, 1, 15000000, 8000000, 5, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-black-8835089629214.jpg'),
(29, 8, 1, 1, 20000000, 12000000, 8, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-black-8835089629214.jpg'),
(30, 8, 2, 1, 20000000, 12000000, 7, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-black-8835089629214.jpg'),
(31, 8, 3, 2, 20000000, 12000000, 5, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-white-8835089661982.jpg'),
(32, 8, 4, 2, 20000000, 12000000, 4, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-white-8835089661982.jpg');
-- MLB
INSERT INTO SanPhamChiTiet (MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe) VALUES
(33, 9, 1, 1, 3500000, 1800000, 20, 'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_0a5e8a7e8a3c424b9c3c8a7e8a3c424b_grande.jpg'),
(34, 9, 2, 1, 3500000, 1800000, 22, 'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_0a5e8a7e8a3c424b9c3c8a7e8a3c424b_grande.jpg'),
(35, 9, 3, 3, 3500000, 1800000, 15, 'https://product.hstatic.net/1000284478/product/3ampr014n-43bgs-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg'),
(36, 9, 4, 3, 3500000, 1800000, 10, 'https://product.hstatic.net/1000284478/product/3ampr014n-43bgs-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg'),
(37, 10, 1, 1, 2500000, 1300000, 30, 'https://product.hstatic.net/1000284478/product/3atsm0233-50bks-ao-thun-mlb-classic-monogram-big-logo-new-york-yankees-1_grande.jpg'),
(38, 10, 2, 1, 2500000, 1300000, 25, 'https://product.hstatic.net/1000284478/product/3atsm0233-50bks-ao-thun-mlb-classic-monogram-big-logo-new-york-yankees-1_grande.jpg'),
(39, 10, 3, 2, 2500000, 1300000, 20, 'https://product.hstatic.net/1000284478/product/3atsm0233-50whs-ao-thun-mlb-classic-monogram-big-logo-new-york-yankees-1_grande.jpg'),
(40, 10, 4, 2, 2500000, 1300000, 15, 'https://product.hstatic.net/1000284478/product/3atsm0233-50whs-ao-thun-mlb-classic-monogram-big-logo-new-york-yankees-1_grande.jpg'),
(41, 11, 1, 4, 2900000, 1500000, 12, 'https://product.hstatic.net/1000284478/product/3fptg0134-07nys-quan-jogger-mlb-classic-sports-logo-la-dodgers-1_grande.jpg'),
(42, 11, 2, 4, 2900000, 1500000, 10, 'https://product.hstatic.net/1000284478/product/3fptg0134-07nys-quan-jogger-mlb-classic-sports-logo-la-dodgers-1_grande.jpg'),
(43, 11, 3, 4, 2900000, 1500000, 8, 'https://product.hstatic.net/1000284478/product/3fptg0134-07nys-quan-jogger-mlb-classic-sports-logo-la-dodgers-1_grande.jpg'),
(44, 11, 4, 4, 2900000, 1500000, 5, 'https://product.hstatic.net/1000284478/product/3fptg0134-07nys-quan-jogger-mlb-classic-sports-logo-la-dodgers-1_grande.jpg'),
(45, 12, 1, 1, 4500000, 2500000, 10, 'https://product.hstatic.net/1000284478/product/3ajpv0634-50bkl-ao-khoac-mlb-wool-basic-varsity-new-york-yankees-1_grande.jpg'),
(46, 12, 2, 1, 4500000, 2500000, 8, 'https://product.hstatic.net/1000284478/product/3ajpv0634-50bkl-ao-khoac-mlb-wool-basic-varsity-new-york-yankees-1_grande.jpg'),
(47, 12, 3, 1, 4500000, 2500000, 6, 'https://product.hstatic.net/1000284478/product/3ajpv0634-50bkl-ao-khoac-mlb-wool-basic-varsity-new-york-yankees-1_grande.jpg'),
(48, 12, 4, 1, 4500000, 2500000, 5, 'https://product.hstatic.net/1000284478/product/3ajpv0634-50bkl-ao-khoac-mlb-wool-basic-varsity-new-york-yankees-1_grande.jpg');
SET IDENTITY_INSERT dbo.SanPhamChiTiet OFF;
GO

-- 4.4. Dữ liệu Nghiệp vụ (Bài viết, Kho, Khách hàng)
SET IDENTITY_INSERT dbo.BaiViet ON;
INSERT INTO BaiViet (MaBV, MaLoaiBV, MaTK, TieuDe, NoiDung, HinhAnh, TrangThai, Slug) VALUES
(1, 1, 1, N'Bộ sưu tập Thu-Đông 2025 từ Gucci', N'Gucci vừa cho ra mắt bộ sưu tập Thu-Đông 2025, kết hợp giữa di sản cổ điển và cảm hứng đương đại.', 'https://media.gucci.com/content/DiaryArticleSingle_Standard_1600x1600/1695222013/DiaryArticleSingle_gucci-ancora-fashion-show-2023-01_001_Default.jpg', 1, 'bo-suu-tap-thu-dong-2025-tu-gucci');
SET IDENTITY_INSERT dbo.BaiViet OFF;
GO

SET IDENTITY_INSERT dbo.PhieuNhap ON;
INSERT INTO PhieuNhap (MaPN, MaNV, MaNCC, TongTien, GhiChu) VALUES (1, 2, 1, 80000000.00, N'Nhập 10 áo Polo Gucci Cotton size M, màu trắng');
SET IDENTITY_INSERT dbo.PhieuNhap OFF;
GO

INSERT INTO NhapKhoChiTiet (MaPN, MaBienThe, SoLuong, DonGiaNhap, ThanhTien) VALUES (1, 3, 10, 8000000.00, 80000000.00);
GO
UPDATE SanPhamChiTiet SET SoLuongTon = SoLuongTon + 10 WHERE MaBienThe = 3;
GO
UPDATE SanPhamChiTiet SET SoLuongDaBan = SoLuongDaBan + 1 WHERE MaBienThe = 13;
GO

SET IDENTITY_INSERT dbo.SoDiaChi ON;
INSERT INTO SoDiaChi (MaDiaChi, MaTK, HoTenNguoiNhan, SoDienThoai, DiaChiChiTiet, LaMacDinh) VALUES
(1, 3, N'Lê Văn Khách', '0900000003', N'789 Đường Khách Hàng, P.1, Q.Tân Bình, TP.HCM', 1);
SET IDENTITY_INSERT dbo.SoDiaChi OFF;
GO

SET IDENTITY_INSERT dbo.GioHang ON;
INSERT INTO GioHang (MaGioHang, MaTK) VALUES (1, 3);
SET IDENTITY_INSERT dbo.GioHang OFF;
GO

INSERT INTO GioHangChiTiet (MaGioHang, MaBienThe, SoLuong) VALUES (1, 1, 2);
GO

INSERT INTO DangKyThanhVien (MaTK, MaGoi, NgayBatDau, NgayKetThuc, TrangThai) VALUES
(3, 1, GETDATE(), DATEADD(day, 365, GETDATE()), 1);
GO

SET IDENTITY_INSERT dbo.PhongChat ON;
INSERT INTO PhongChat (MaPhong, MaTK, MaNV, TrangThai) VALUES (1, 3, 2, 1);
SET IDENTITY_INSERT dbo.PhongChat OFF;
GO

INSERT INTO TinNhan (MaPhong, MaNguoiGui, LoaiNguoiGui, LoaiTinNhan, NoiDung) VALUES
(1, 3, 0, 0, N'Chào shop, tôi cần tư vấn về áo Polo');
GO

SET IDENTITY_INSERT dbo.DonHang ON;
INSERT INTO DonHang (MaDH, MaTK, NgayDat, TongTien, PhiShip, MaDiaChiGiao, MaHinhThucTT, TrangThaiDH, TrangThaiThanhToan, NgayThanhToan, NgayCapNhat) VALUES
(1, 3, GETDATE() - 7, 35030000.00, 30000.00, 1, 1, 4, 1, GETDATE() - 6, GETDATE() - 6);
SET IDENTITY_INSERT dbo.DonHang OFF;
GO

SET IDENTITY_INSERT dbo.DonHangCT ON;
INSERT INTO DonHangCT (MaCT, MaDH, MaBienThe, SoLuong, DonGia) VALUES (1, 1, 13, 1, 35000000.00);
SET IDENTITY_INSERT dbo.DonHangCT OFF;
GO

INSERT INTO LichSuDonHang (MaDH, TrangThaiCu, TrangThaiMoi, GhiChu, NguoiCapNhat) VALUES
(1, 0, 1, N'Nhân viên xác nhận đơn', N'Nguyễn Thị Bán Hàng'),
(1, 1, 2, N'Đang chuẩn bị hàng', N'Nguyễn Thị Bán Hàng'),
(1, 2, 3, N'Bàn giao cho đơn vị vận chuyển', N'Hệ thống'),
(1, 3, 4, N'Giao hàng thành công', N'Hệ thống');
GO

SET IDENTITY_INSERT dbo.DanhGia ON;
INSERT INTO DanhGia (MaDG, MaCT, MaTK, NoiDung, Diem) VALUES (1, 1, 3, N'Áo khoác rất đẹp, hàng chuẩn auth, giao nhanh.', 5);
SET IDENTITY_INSERT dbo.DanhGia OFF;
GO

SET IDENTITY_INSERT dbo.ThongKe ON;
INSERT INTO ThongKe (MaThongKe, NgayBaoCao, TongDoanhThu, TongDonHang, TongSanPhamBanRa) VALUES (1, CAST(GETDATE() AS DATE), 35030000.00, 1, 1);
SET IDENTITY_INSERT dbo.ThongKe OFF;
GO

SET IDENTITY_INSERT dbo.NhapKho ON;
INSERT INTO NhapKho (MaNK, MaSP, SoLuong, NgayNhap) VALUES (1, 1, 10, GETDATE()-1);
SET IDENTITY_INSERT dbo.NhapKho OFF;
GO

-- 4.5. Chèn Sản Phẩm Test (Cách 1: Insert tĩnh)
SET IDENTITY_INSERT dbo.SanPham ON;
INSERT INTO SanPham (MaSP, TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP) VALUES
(13, N'Áo T-Shirt TEST Giá 3k', 2, 3, N'Sản phẩm dùng để test cổng thanh toán PayOS/VNPay. Không dùng để bán.', 'https://fakeimg.pl/250x250/?text=3000VND_TEST', 2, 1);
SET IDENTITY_INSERT dbo.SanPham OFF;
GO

SET IDENTITY_INSERT dbo.SanPhamChiTiet ON;
INSERT INTO SanPhamChiTiet (MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe) VALUES
(49, 13, 1, 1, 3000.00, 1000.00, 50, 'https://fakeimg.pl/250x250/?text=3000VND_TEST');
SET IDENTITY_INSERT dbo.SanPhamChiTiet OFF;
GO

-- 4.6. Chèn Sản Phẩm Test (Cách 2: Insert động cho PayOS Test)
DECLARE @MaSP_Test BIGINT;
DECLARE @MaLoai_Test BIGINT;
DECLARE @MaTH_Test BIGINT;
DECLARE @MaSize_Test BIGINT;
DECLARE @MaMau_Test BIGINT;

SELECT @MaLoai_Test = MaLoai FROM LoaiSanPham WHERE TenLoai = N'Áo thun';
SELECT @MaTH_Test = MaTH FROM ThuongHieu WHERE TenTH = N'Test Brand';
SELECT @MaSize_Test = MaSize FROM SizeSP WHERE TenSize = N'M';
SELECT @MaMau_Test = MaMau FROM MauSacSP WHERE TenMau = N'Trắng';

IF EXISTS (SELECT 1 FROM SanPham WHERE TenSP = N'Áo Test PayOS 3K')
BEGIN
    SELECT @MaSP_Test = MaSP FROM SanPham WHERE TenSP = N'Áo Test PayOS 3K';
    DELETE FROM SanPhamChiTiet WHERE MaSP = @MaSP_Test;
    DELETE FROM SanPham WHERE MaSP = @MaSP_Test;
END

INSERT INTO SanPham (TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP, NgayTao, NgayCapNhat) VALUES
(N'Áo Test PayOS 3K', @MaLoai_Test, @MaTH_Test, N'Áo test thanh toán PayOS - Giá chỉ 3.000 VNĐ', N'/img/placeholder.png', 2, 1, GETDATE(), GETDATE());
SET @MaSP_Test = SCOPE_IDENTITY();

INSERT INTO SanPhamChiTiet (MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan) VALUES
(@MaSP_Test, @MaSize_Test, @MaMau_Test, 3000.00, 2000.00, 999, 0);

SELECT @MaSize_Test = MaSize FROM SizeSP WHERE TenSize = N'L';
INSERT INTO SanPhamChiTiet (MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, SoLuongDaBan) VALUES
(@MaSP_Test, @MaSize_Test, @MaMau_Test, 3000.00, 2000.00, 999, 0);
GO
PRINT N'✅ PHẦN 4: CHÈN DỮ LIỆU MẪU THÀNH CÔNG!';
GO

-- =============================================================================
-- PHẦN 5: KIỂM TRA DỮ LIỆU (VERIFY)
-- =============================================================================
PRINT N'========================================';
PRINT N'10. THỐNG KÊ TỔNG QUAN';
PRINT N'========================================';
SELECT 'TaiKhoan' AS TableName, COUNT(*) AS TotalRecords FROM TaiKhoan
UNION ALL SELECT 'SanPham', COUNT(*) FROM SanPham
UNION ALL SELECT 'SanPhamChiTiet', COUNT(*) FROM SanPhamChiTiet
UNION ALL SELECT 'DonHang', COUNT(*) FROM DonHang
UNION ALL SELECT 'HinhThucThanhToan', COUNT(*) FROM HinhThucThanhToan
UNION ALL SELECT 'TrangThaiDonHang', COUNT(*) FROM TrangThaiDonHang;
GO

PRINT N'========================================';
PRINT N'DANH SÁCH PHƯƠNG THỨC THANH TOÁN';
PRINT N'========================================';
SELECT MaHinhThucTT, TenHinhThuc, TrangThai FROM HinhThucThanhToan;
GO

PRINT N'========================================';
PRINT N'KIỂM TRA SẢN PHẨM TEST';
PRINT N'========================================';
SELECT MaSP, TenSP, GiaBan FROM SanPham s JOIN SanPhamChiTiet ct ON s.MaSP = ct.MaSP WHERE GiaBan = 3000;
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