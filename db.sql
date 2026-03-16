
/*
KỊCH BẢN TẠO CƠ SỞ DỮ LIỆU LUXURY FASHION (BẢN PRODUCTION 2025)
HỆ QUẢN TRỊ: SQL SERVER
MÔ TẢ: Đã bỏ Trigger, logic sẽ được xử lý trong Spring Boot Service.
*** SỬA LỖI: Đổi INT sang BIGINT để khớp với Java Entity (Long id) ***
================================================================================
*/

-- PHẦN 0: HỦY VÀ TẠO LẠI CƠ SỞ DỮ LIỆU
USE master;
GO
IF DB_ID('LuxuryFashion_2025') IS NOT NULL
BEGIN
    ALTER DATABASE LuxuryFashion_2025 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LuxuryFashion_2025;
END
GO

-- Tạo database mới
CREATE DATABASE LuxuryFashion_2025;
GO

-- Sử dụng database mới
USE LuxuryFashion_2025;
GO
PRINT N'PHẦN 0: TẠO VÀ SỬ DỤNG DATABASE LuxuryFashion_2025 THÀNH CÔNG!';
GO

/*
PHẦN 1: HỦY CÁC BẢNG (DROP TABLES)
Hủy theo thứ tự ngược lại của các ràng buộc khóa ngoại để tránh lỗi.
================================================================================
*/

IF OBJECT_ID('dbo.TinNhan', 'U') IS NOT NULL
DROP TABLE dbo.TinNhan;
IF OBJECT_ID('dbo.CuocTroChuyen', 'U') IS NOT NULL
DROP TABLE dbo.CuocTroChuyen;
IF OBJECT_ID('dbo.ThanhToan', 'U') IS NOT NULL
DROP TABLE dbo.ThanhToan;
IF OBJECT_ID('dbo.SanPhamYeuThich', 'U') IS NOT NULL
DROP TABLE dbo.SanPhamYeuThich;
IF
OBJECT_ID('dbo.GioHangChiTiet', 'U') IS NOT NULL
DROP TABLE dbo.GioHangChiTiet;
IF
OBJECT_ID('dbo.GioHang', 'U') IS NOT NULL
DROP TABLE dbo.GioHang;
IF
OBJECT_ID('dbo.BinhLuan', 'U') IS NOT NULL
DROP TABLE dbo.BinhLuan;
IF
OBJECT_ID('dbo.BaiViet', 'U') IS NOT NULL
DROP TABLE dbo.BaiViet;
IF
OBJECT_ID('dbo.LoaiBaiViet', 'U') IS NOT NULL
DROP TABLE dbo.LoaiBaiViet;
IF
OBJECT_ID('dbo.DanhGia', 'U') IS NOT NULL
DROP TABLE dbo.DanhGia;
IF
OBJECT_ID('dbo.DonHangCT', 'U') IS NOT NULL
DROP TABLE dbo.DonHangCT;
IF
OBJECT_ID('dbo.LichSuDonHang', 'U') IS NOT NULL
DROP TABLE dbo.LichSuDonHang;
IF
OBJECT_ID('dbo.DonHang', 'U') IS NOT NULL
DROP TABLE dbo.DonHang;
IF
OBJECT_ID('dbo.HinhThucThanhToan', 'U') IS NOT NULL
DROP TABLE dbo.HinhThucThanhToan;
IF
OBJECT_ID('dbo.HinhAnhSP', 'U') IS NOT NULL
DROP TABLE dbo.HinhAnhSP;
IF
OBJECT_ID('dbo.SanPhamChiTiet', 'U') IS NOT NULL
DROP TABLE dbo.SanPhamChiTiet;
IF
OBJECT_ID('dbo.SanPham', 'U') IS NOT NULL
DROP TABLE dbo.SanPham;
IF
OBJECT_ID('dbo.MauSacSP', 'U') IS NOT NULL
DROP TABLE dbo.MauSacSP;
IF
OBJECT_ID('dbo.SizeSP', 'U') IS NOT NULL
DROP TABLE dbo.SizeSP;
IF
OBJECT_ID('dbo.LoaiSanPham', 'U') IS NOT NULL
DROP TABLE dbo.LoaiSanPham;
IF
OBJECT_ID('dbo.ThuongHieu', 'U') IS NOT NULL
DROP TABLE dbo.ThuongHieu;
IF OBJECT_ID('dbo.SoDiaChi', 'U') IS NOT NULL
DROP TABLE dbo.SoDiaChi;
IF OBJECT_ID('dbo.TaiKhoan_VaiTro', 'U') IS NOT NULL
DROP TABLE dbo.TaiKhoan_VaiTro;
IF OBJECT_ID('dbo.VaiTro', 'U') IS NOT NULL
DROP TABLE dbo.VaiTro;
IF OBJECT_ID('dbo.TaiKhoan', 'U') IS NOT NULL
DROP TABLE dbo.TaiKhoan;
IF OBJECT_ID('dbo.TrangThaiDonHang', 'U') IS NOT NULL
DROP TABLE dbo.TrangThaiDonHang;
IF OBJECT_ID('dbo.ThongKe', 'U') IS NOT NULL
DROP TABLE dbo.ThongKe;
IF OBJECT_ID('dbo.NhapKhoChiTiet', 'U') IS NOT NULL
DROP TABLE dbo.NhapKhoChiTiet;
IF OBJECT_ID('dbo.PhieuNhap', 'U') IS NOT NULL
DROP TABLE dbo.PhieuNhap;
IF OBJECT_ID('dbo.NhaCungCap', 'U') IS NOT NULL
DROP TABLE dbo.NhaCungCap;
GO

PRINT N'PHẦN 1: HỦY BẢNG CŨ THÀNH CÔNG!';
GO

/*
================================================================================
 PHẦN 2: TẠO CẤU TRÚC BẢNG (CREATE TABLES)
 Đã tối ưu NOT NULL cho các cột trạng thái.
================================================================================
*/

-- Bảng: TaiKhoan
CREATE TABLE TaiKhoan (
    MaTK BIGINT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    MatKhau VARCHAR(255) NOT NULL,
    SoDienThoai VARCHAR(20),
    DiaChi NVARCHAR(255),
    Avatar NVARCHAR(255),
    DangNhapCuoi DATETIME,
    TrangThai BIT NOT NULL DEFAULT 1,
    NgayTao DATETIME DEFAULT GETDATE(),
    NgayCapNhat DATETIME DEFAULT GETDATE(),
    NguonTao VARCHAR(20) DEFAULT 'LOCAL'
);
CREATE INDEX idx_taikhoan_email ON TaiKhoan(Email);


-- Bảng: VaiTro (Phân Quyền)
CREATE TABLE VaiTro (
    MaVaiTro BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenVaiTro VARCHAR(50) UNIQUE NOT NULL
);

-- Bảng: TaiKhoan_VaiTro (Nối Tài Khoản - Quyền)
CREATE TABLE TaiKhoan_VaiTro (
    MaTK BIGINT NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK),
    MaVaiTro BIGINT NOT NULL FOREIGN KEY REFERENCES VaiTro(MaVaiTro),
    PRIMARY KEY (MaTK, MaVaiTro)
);

-- Bảng: SoDiaChi
CREATE TABLE SoDiaChi (
    MaDiaChi BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaTK BIGINT NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK),
    HoTenNguoiNhan NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(20) NOT NULL,
    DiaChiChiTiet NVARCHAR(500) NOT NULL,
    GhiChu NVARCHAR(255),
    LaMacDinh BIT DEFAULT 0
);

-- Bảng: ThuongHieu
CREATE TABLE ThuongHieu (
    MaTH BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenTH NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(255)
);

-- Bảng: LoaiSanPham
CREATE TABLE LoaiSanPham (
    MaLoai BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenLoai NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(255),
    TrangThai INT NOT NULL DEFAULT 1
);

-- Bảng: SizeSP
CREATE TABLE SizeSP (
    MaSize BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenSize NVARCHAR(20) UNIQUE NOT NULL
);
-- Bảng: MauSacSP
CREATE TABLE MauSacSP (
    MaMau BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenMau NVARCHAR(50) UNIQUE NOT NULL,
    MaHex VARCHAR(7)
);

-- Bảng: SanPham
CREATE TABLE SanPham (
    MaSP BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenSP NVARCHAR(255) NOT NULL,
    MaLoai BIGINT FOREIGN KEY REFERENCES LoaiSanPham(MaLoai) ON DELETE SET NULL,
    MaTH BIGINT FOREIGN KEY REFERENCES ThuongHieu(MaTH) ON DELETE SET NULL,
    MoTa NVARCHAR(MAX),
    AnhChinh NVARCHAR(255),
    GioiTinh INT NOT NULL DEFAULT 2, -- 0=Nam, 1=Nữ, 2=Unisex
    TrangThaiSP INT NOT NULL DEFAULT 1,
    NgayTao DATETIME DEFAULT GETDATE(),
    NgayCapNhat DATETIME DEFAULT GETDATE()
);
CREATE INDEX idx_product_category ON SanPham(MaLoai);
CREATE INDEX idx_product_brand ON SanPham(MaTH);


-- Bảng: SanPhamChiTiet (Biến thể SKU)
CREATE TABLE SanPhamChiTiet (
    MaBienThe BIGINT IDENTITY(1,1) PRIMARY KEY,
    SKU VARCHAR(100), -- UNIQUE filtered index sẽ cho phép nhiều NULL
    MaSP BIGINT NOT NULL FOREIGN KEY REFERENCES SanPham(MaSP) ON DELETE CASCADE,
    MaSize BIGINT FOREIGN KEY REFERENCES SizeSP(MaSize) ON DELETE SET NULL,
    MaMau BIGINT FOREIGN KEY REFERENCES MauSacSP(MaMau) ON DELETE SET NULL,
    GiaBan DECIMAL(18, 2) NOT NULL,
    GiaNhap DECIMAL(18, 2) DEFAULT 0,
    SoLuongTon INT DEFAULT 0,
    SoLuongDaBan INT DEFAULT 0,
    AnhBienThe NVARCHAR(255),
    TrangThai BIT NOT NULL DEFAULT 1, -- 1: Đang bán, 0: Ngừng bán/Ẩn
    CONSTRAINT UK_SanPham_Variant UNIQUE (MaSP, MaSize, MaMau)
);

-- Index lọc cho SKU để cho phép nhiều NULL nhưng vẫn UNIQUE nếu có giá trị
CREATE UNIQUE INDEX UIX_SanPhamChiTiet_SKU ON SanPhamChiTiet(SKU) WHERE SKU IS NOT NULL;
CREATE INDEX idx_variant_product ON SanPhamChiTiet(MaSP);
CREATE INDEX idx_variant_stock ON SanPhamChiTiet(SoLuongTon);


-- Bảng: HinhAnhSP
CREATE TABLE HinhAnhSP
(
    MaAnh BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaSP BIGINT NOT NULL FOREIGN KEY REFERENCES SanPham(MaSP) ON DELETE CASCADE,
    DuongDan NVARCHAR(255)
);


-- Bảng: TrangThaiDonHang (Định nghĩa trước DonHang để làm FK)
IF OBJECT_ID('dbo.TrangThaiDonHang', 'U') IS NOT NULL
DROP TABLE dbo.TrangThaiDonHang;

CREATE TABLE TrangThaiDonHang
(
    MaTTDH INT PRIMARY KEY, -- Khớp trực tiếp mã trạng thái 0,1,2,3,4
    TenTTDH NVARCHAR(50) NOT NULL UNIQUE
);

-- Bảng: HinhThucThanhToan
CREATE TABLE HinhThucThanhToan (
    MaHinhThucTT BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenHinhThuc NVARCHAR(100) UNIQUE NOT NULL,
    MoTa NVARCHAR(255),
    TrangThai BIT DEFAULT 1
);

-- Bảng: DonHang
CREATE TABLE DonHang (
    MaDH BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaTK BIGINT FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE SET NULL,
    MaNhanVien BIGINT FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE NO ACTION,
    NgayDat DATETIME DEFAULT GETDATE(),
    TongTien DECIMAL(18, 2) DEFAULT 0,
    PhiShip DECIMAL(18, 2) DEFAULT 0,
    MaDiaChiGiao BIGINT FOREIGN KEY REFERENCES SoDiaChi(MaDiaChi) ON DELETE SET NULL,
    MaHinhThucTT BIGINT FOREIGN KEY REFERENCES HinhThucThanhToan(MaHinhThucTT) ON DELETE SET NULL,
    GhiChu NVARCHAR(500),
    LyDoHuy NVARCHAR(255),
    MaGiaoDich VARCHAR(100), -- Giữ lại làm Cache cho nhanh nếu cần, hoặc có thể xóa hoàn toàn
    TrangThaiDH INT NOT NULL DEFAULT 0 FOREIGN KEY REFERENCES TrangThaiDonHang(MaTTDH),
    TrangThaiThanhToan INT NOT NULL DEFAULT 0,
    NgayCapNhat DATETIME DEFAULT GETDATE(),
    NgayThanhToan DATETIME NULL,
    KhachBaoChuaNhan BIT DEFAULT 0,
    LyDoChuaNhan NVARCHAR(255),
    MoTaChuaNhan NVARCHAR(1000)
);
CREATE INDEX idx_order_user ON DonHang(MaTK);
CREATE INDEX idx_order_status ON DonHang(TrangThaiDH);



-- Bảng: DonHangCT (Chi tiết đơn hàng)
CREATE TABLE DonHangCT (
    MaCT BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaDH BIGINT NOT NULL FOREIGN KEY REFERENCES DonHang(MaDH) ON DELETE CASCADE,
    MaBienThe BIGINT FOREIGN KEY REFERENCES SanPhamChiTiet(MaBienThe) ON DELETE NO ACTION, -- Đổi từ SET NULL sang NO ACTION để bảo toàn dữ liệu
    SoLuong INT,
    DonGia DECIMAL(18, 2)
);

-- Bảng: ThanhToan (Giao dịch thanh toán)
CREATE TABLE ThanhToan (
    MaThanhToan   BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaDH          BIGINT NOT NULL FOREIGN KEY REFERENCES DonHang(MaDH) ON DELETE CASCADE,
    SoTien        DECIMAL(18, 2) NOT NULL,
    TrangThai     NVARCHAR(20) DEFAULT 'PENDING', -- PENDING, COMPLETED, FAILED, REFUNDED
    Gateway       NVARCHAR(50), -- VNPay, Momo, ZaloPay, COD
    TransactionID VARCHAR(100), -- Mã giao dịch từ đối tác
    NgayTao       DATETIME DEFAULT GETDATE()
);

-- Bảng: LichSuDonHang (Audit Trail - Rất "xịn")
CREATE TABLE LichSuDonHang
(
    MaLichSu BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaDH BIGINT NOT NULL FOREIGN KEY REFERENCES DonHang(MaDH) ON DELETE CASCADE,
    TrangThaiCu INT NOT NULL,
    TrangThaiMoi INT NOT NULL,
    ThoiGian DATETIME DEFAULT GETDATE(),
    GhiChu NVARCHAR(255),
    NguoiCapNhat NVARCHAR(50)
    -- Tên Admin/Nhân viên
);

-- Bảng: DanhGia
CREATE TABLE DanhGia (
    MaDG BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaCT BIGINT UNIQUE NOT NULL FOREIGN KEY REFERENCES DonHangCT(MaCT) ON DELETE CASCADE,
    MaTK BIGINT NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE CASCADE,
    NoiDung NVARCHAR(500),
    Diem INT NOT NULL CHECK (Diem >= 1 AND Diem <= 5),
    NgayDanhGia DATETIME DEFAULT GETDATE(),
    TrangThai INT DEFAULT 1,
    PhanHoi NVARCHAR(1000),
    NgayPhanHoi DATETIME,
    SoLuotBaoCao INT DEFAULT 0
);

-- Bảng: LoaiBaiViet
CREATE TABLE LoaiBaiViet
(
    MaLoaiBV BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenLoaiBV NVARCHAR(100)
);

-- Bảng: BaiViet
CREATE TABLE BaiViet
(
    MaBV      BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaLoaiBV  BIGINT FOREIGN KEY REFERENCES LoaiBaiViet(MaLoaiBV) ON DELETE SET NULL,
    MaTK      BIGINT FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE SET NULL,
    TieuDe    NVARCHAR(255),
    NoiDung   NVARCHAR(MAX),
    HinhAnh   NVARCHAR(255),
    LuotXem   INT      DEFAULT 0,
    TrangThai BIT      DEFAULT 1,  -- 1: Xuất bản, 0: Bản nháp
    Slug      VARCHAR(255) UNIQUE, -- Đường dẫn SEO
    NgayDang  DATETIME DEFAULT GETDATE()
);

-- Bảng: BinhLuan
CREATE TABLE BinhLuan
(
    MaBL           BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaSP           BIGINT FOREIGN KEY REFERENCES SanPham(MaSP) ON DELETE CASCADE,
    MaBV           BIGINT FOREIGN KEY REFERENCES BaiViet(MaBV) ON DELETE CASCADE,
    MaTK           BIGINT NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE CASCADE,
    NoiDung        NVARCHAR(500) NOT NULL,
    NgayBinhLuan   DATETIME DEFAULT GETDATE(),
    AnDanh         BIT      DEFAULT 0,
    TrangThai      BIT      DEFAULT 1,
    SoLuotThich    INT      DEFAULT 0,
    SoLuongPhanHoi INT      DEFAULT 0,
    PhanHoiAdmin   NVARCHAR(1000),
    NgayPhanHoiAdmin DATETIME,
    SoLuotBaoCao    INT      DEFAULT 0,
    MaBLCha         BIGINT   NULL FOREIGN KEY REFERENCES BinhLuan(MaBL),
    CONSTRAINT CK_BinhLuan CHECK (
        (MaSP IS NOT NULL AND MaBV IS NULL)
        OR
        (MaSP IS NULL AND MaBV IS NOT NULL)
    )
);

-- Bảng: GioHang
CREATE TABLE GioHang (
    MaGioHang BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaTK BIGINT UNIQUE NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE CASCADE,
    NgayCapNhat DATETIME DEFAULT GETDATE()
);

-- Bảng: GioHangChiTiet
CREATE TABLE GioHangChiTiet
(
    MaGH_CT BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaGioHang BIGINT NOT NULL FOREIGN KEY REFERENCES GioHang(MaGioHang) ON DELETE CASCADE,
    MaBienThe BIGINT NOT NULL FOREIGN KEY REFERENCES SanPhamChiTiet(MaBienThe) ON DELETE CASCADE,
    SoLuong INT DEFAULT 1,
    NgayThem DATETIME DEFAULT GETDATE(),
    CONSTRAINT UK_GioHang_BienThe UNIQUE (MaGioHang, MaBienThe)
);

-- Bảng: NhaCungCap
CREATE TABLE NhaCungCap
(
    MaNCC BIGINT IDENTITY(1,1) PRIMARY KEY,
    TenNCC NVARCHAR(100),
    SoDienThoai VARCHAR(20),
    DiaChi NVARCHAR(255)
);

-- Bảng: PhieuNhap
CREATE TABLE PhieuNhap
(
    MaPN BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaNV BIGINT NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE NO ACTION,
    -- Mã Nhân viên
    MaNCC BIGINT FOREIGN KEY REFERENCES NhaCungCap(MaNCC) ON DELETE SET NULL,
    NgayNhap DATETIME DEFAULT GETDATE(),
    TongTien DECIMAL(18, 2) DEFAULT 0,
    GhiChu NVARCHAR(500)
);

-- Bảng: NhapKhoChiTiet
CREATE TABLE NhapKhoChiTiet
(
    MaNK_CT BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaPN BIGINT NOT NULL FOREIGN KEY REFERENCES PhieuNhap(MaPN) ON DELETE CASCADE,
    MaBienThe BIGINT NOT NULL FOREIGN KEY REFERENCES SanPhamChiTiet(MaBienThe) ON DELETE CASCADE, -- Xóa chi tiết nhập khi biến thể bị xóa
    SoLuong INT,
    DonGiaNhap DECIMAL(18, 2),
    ThanhTien DECIMAL(18, 2)
);


-- Bảng: CuocTroChuyen (Cuộc hội thoại)
CREATE TABLE CuocTroChuyen (
    MaCuocTroChuyen BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaTK            BIGINT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK),
    MaNhanVien      BIGINT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK), -- Nhân viên đang xử lý
    TrangThai       NVARCHAR(10) DEFAULT 'AI' NOT NULL, -- AI, PENDING, HUMAN, CLOSED
    NgayTao         DATETIME DEFAULT GETDATE(),
    NgayCapNhat     DATETIME DEFAULT GETDATE()
);
CREATE INDEX idx_chat_user ON CuocTroChuyen(MaTK);
CREATE INDEX idx_chat_staff ON CuocTroChuyen(MaNhanVien);


-- Bảng: TinNhan (Tin nhắn)
CREATE TABLE TinNhan (
    MaTinNhan       BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaCuocTroChuyen BIGINT NOT NULL FOREIGN KEY REFERENCES CuocTroChuyen(MaCuocTroChuyen) ON DELETE CASCADE,
    LoaiNguoiGui    NVARCHAR(10) NOT NULL, -- USER, AI, STAFF
    NoiDung         NVARCHAR(MAX) NOT NULL,
    DaDoc           BIT DEFAULT 0, -- 0: Chưa đọc, 1: Đã đọc
    NgayGui         DATETIME DEFAULT GETDATE()
);
CREATE INDEX idx_chat_message ON TinNhan(MaCuocTroChuyen, NgayGui);


-- Bảng: SanPhamYeuThich
CREATE TABLE SanPhamYeuThich (
    MaSPYT    BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaTK      BIGINT NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK) ON DELETE CASCADE,
    MaSP      BIGINT NOT NULL FOREIGN KEY REFERENCES SanPham(MaSP) ON DELETE CASCADE,
    NgayThem  DATETIME DEFAULT GETDATE(),
    CONSTRAINT UK_SPYT UNIQUE (MaTK, MaSP)
);

-- (Bảng TrangThaiDonHang đã được dời lên trên)

-- Bảng: ThongKe
CREATE TABLE ThongKe
(
    MaThongKe BIGINT IDENTITY(1,1) PRIMARY KEY,
    NgayBaoCao DATE NOT NULL UNIQUE,
    TongDoanhThu DECIMAL(18,2) NOT NULL,
    TongDonHang INT NOT NULL,
    TongSanPhamBanRa INT NOT NULL
);

GO
PRINT N'PHẦN 2: TẠO CẤU TRÚC BẢNG FINAL THÀNH CÔNG!';
GO

/*
================================================================================
 PHẦN 3: CHÈN DỮ LIỆU MẪU (INSERT DATA)
 Chèn theo thứ tự logic để đảm bảo khóa ngoại hợp lệ.
================================================================================
*/
USE LuxuryFashion_2025;
GO

-- 1. Chèn các bảng Danh Mục (Không phụ thuộc)

SET IDENTITY_INSERT dbo.VaiTro ON;
INSERT INTO VaiTro
(MaVaiTro, TenVaiTro)
VALUES
    (1, 'ADMIN'),
    (2, 'NHANVIEN'),
    (3, 'KHACHHANG');
SET IDENTITY_INSERT dbo.VaiTro OFF;
GO

SET IDENTITY_INSERT dbo.TaiKhoan ON;
INSERT INTO TaiKhoan
(MaTK, HoTen, Email, MatKhau, SoDienThoai, DiaChi, TrangThai)
VALUES
    (1, N'Admin Luxury', 'admin@luxury.com', '123', '0900000001', N'123 Đường Admin, Q1, TP.HCM', 1),
    -- Mật khẩu: 123 (plain text)
    (2, N'Nguyễn Thị Bán Hàng', 'nhanvien@luxury.com', '123', '0900000002', N'456 Đường Nhân Viên, Q3, TP.HCM', 1),
    -- Mật khẩu: 123 (plain text)
    (3, N'Lê Văn Khách', 'khachhang@luxury.com', '123', '0900000003', N'789 Đường Khách Hàng, Q.Tân Bình, TP.HCM', 1);
-- Mật khẩu: 123 (plain text)
SET IDENTITY_INSERT dbo.TaiKhoan OFF;
GO

INSERT INTO TaiKhoan_VaiTro
    (MaTK, MaVaiTro)
VALUES
    (1, 1),
    -- Admin Luxury là ADMIN
    (2, 2),
    -- Nguyễn Thị Bán Hàng là NHANVIEN
    (3, 3); -- Lê Văn Khách là KHACHHANG
GO

SET IDENTITY_INSERT dbo.ThuongHieu ON;
INSERT INTO ThuongHieu
(MaTH, TenTH, MoTa)
VALUES
    (1, N'Gucci', N'Thương hiệu thời trang cao cấp của Ý'),
    (2, N'Chanel', N'Thương hiệu thời trang cao cấp của Pháp'),
    (3, N'MLB', N'Thương hiệu thời trang thể thao Hàn Quốc');
SET IDENTITY_INSERT dbo.ThuongHieu OFF;
GO


SET IDENTITY_INSERT dbo.LoaiSanPham ON;
INSERT INTO LoaiSanPham
(MaLoai, TenLoai, MoTa)
VALUES
    (1, N'Áo Polo', N'Các loại áo polo'),
    (2, N'T-Shirt', N'Áo thun nam nữ'),
    (3, N'Quần', N'Quần thời trang'),
    (4, N'Áo Khoác', N'Áo khoác thời trang');
SET IDENTITY_INSERT dbo.LoaiSanPham OFF;
GO


SET IDENTITY_INSERT dbo.SizeSP ON;
INSERT INTO SizeSP
(MaSize, TenSize)
VALUES
    (1, N'S'),
    (2, N'M'),
    (3, N'L'),
    (4, N'XL');
SET IDENTITY_INSERT dbo.SizeSP OFF;
GO


SET IDENTITY_INSERT dbo.MauSacSP ON;
INSERT INTO MauSacSP
(MaMau, TenMau, MaHex)
VALUES
    (1, N'Đen', '#000000'),
    (2, N'Trắng', '#FFFFFF'),
    (3, N'Be', '#F5F5DC'),
    (4, N'Xanh đen', '#0A2342');
SET IDENTITY_INSERT dbo.MauSacSP OFF;
GO


SET IDENTITY_INSERT dbo.HinhThucThanhToan ON;
INSERT INTO HinhThucThanhToan
(MaHinhThucTT, TenHinhThuc, MoTa, TrangThai)
VALUES
    (1, N'Thanh toán khi nhận hàng (COD)', N'Trả tiền mặt khi shipper giao hàng', 1),
    (2, N'Thanh toán qua VNPay', N'Quét mã QR qua cổng VNPay', 1);
SET IDENTITY_INSERT dbo.HinhThucThanhToan OFF;
GO

SET IDENTITY_INSERT dbo.NhaCungCap ON;
INSERT INTO NhaCungCap
(MaNCC, TenNCC, SoDienThoai, DiaChi)
VALUES
    (1, N'Nhà phân phối Gucci VN', '02811112222', N'10 Nguyễn Trãi, Q1, TP.HCM');
SET IDENTITY_INSERT dbo.NhaCungCap OFF;
GO



SET IDENTITY_INSERT dbo.LoaiBaiViet ON;
INSERT INTO LoaiBaiViet
(MaLoaiBV, TenLoaiBV)
VALUES
    (1, N'Xu hướng thời trang');
SET IDENTITY_INSERT dbo.LoaiBaiViet OFF;
GO


-- 2. Chèn Sản Phẩm (Phụ thuộc các bảng trên)

SET IDENTITY_INSERT dbo.SanPham ON;
INSERT INTO SanPham
(MaSP, TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP)
VALUES
    -- GUCCI (21 sản phẩm)
    (1, N'Áo Polo Gucci Cotton', 1, 1, N'Áo polo Gucci', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/04/ao-polo-nam-gucci-cotton-piquet-polo-with-double-g-752604-mau-trang-kem-size-xs-661e3a9285fbc-16042024154506.jpg', 2, 1),
    (2,N'Áo Polo Gucci Double G',1,1,N'Áo polo Gucci','https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/06/ao-polo-nam-gucci-interlock-double-g-stripe-short-sleeve-shirt-ivory-598949-xjb0q-9247-mau-trang-nga-size-xs-685b513f93aa2-25062025083039.jpg',0,1),
    (3,N'Áo Polo Gucci Stripe',1,1,N'Áo polo Gucci','https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-polo-nam-gucci-sweater-stripe-knitted-with-web-ivory-739954-xkc90-9275-mau-kem-size-s-699e67ee1dd88-25022026100934.jpg',0,1),

    (4,N'Áo Thun Gucci Logo Classic',2,1,N'Áo thun Gucci','https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/03/ao-phong-gucci-white-logo-vintage-printed-717422xje6e9095-mau-trang-641bcc5381367-23032023104939.jpg',2,1),
    (5,N'Áo Thun Gucci Blade Print',2,1,N'Áo thun Gucci','https://cdn.vuahanghieu.com/unsafe/0x500/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/11/ao-phong-nam-gucci-blade-with-logo-print-in-white-tshirt-863004-xjazy-9037-mau-trang-size-s-69267b9a97ed4-26112025110130.jpg',2,1),
    (6, N'Áo Thun Gucci Print', 2, 1, N'Áo thun Gucci', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/06/ao-thun-gucci-with-gucci-blade-print-t-shirt-mau-trang-6492642f01dfc-21062023094503.jpg', 2, 1),

    (7, N'Quần Gucci Trackpant', 3, 1, N'Quần Gucci', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/476/319/products/gucci-black-taped-logo-track-pant.webp?v=1677586605390', 2, 1),
    (8,N'Quần Dài Nam Gucci Wool',3,1,N'Quần Gucci','https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/quan-dai-nam-gucci-wool-mohair-pant-698813-z8a18-4020-mau-xanh-blue-size-44-699d43617b591-24022026132121.jpg',0,1),
    (9,N'Quần Dài Nam Gucci Fluid Drill',3,1,N'Quần Gucci','https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/quan-dai-nam-gucci-fluid-drill-cropped-trouser-blue-690469-z798c-4142-mau-xanh-size-44-69536f71d813e-30122025132137.jpg',0,1),

    (10, N'Áo Khoác Gucci GG', 4, 1, N'Áo khoác Gucci', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2024/12/ao-khoac-nam-gucci-gg-technical-jersey-xip-jacket-737363-mau-nau-size-s-n-dg-676cfc86b54c2-26122024134942.jpg', 2, 1),
    (11, N'Áo Khoác Nam Gucci Technical', 4, 1, N'Áo khoác Gucci', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-khoac-nam-gucci-technical-jersey-gg-print-zipped-jacket-787879-mau-be-size-m-69a0fc462990a-27022026090702.jpg', 0, 1),
    (12, N'Áo Khoác Nam Gucci Jumbo', 4, 1, N'Áo khoác Gucci', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/ao-khoac-nam-gucci-jumbo-gg-canvas-17439318-mau-be-nau-size-44-6938ed6204e87-10122025104746.jpg', 0, 1),

    (13, N'Áo Sơ Mi Gucci Cotton', 5, 1, N'Áo sơ mi Gucci', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2022/02/ao-so-mi-gucci-cotton-shirt-with-symbols-mau-trang-size-s-621060d6ecf5e-19022022101534.jpg', 2, 1),
    (14, N'Áo Sơ Mi Nam Gucci Blue Shirt', 5, 1, N'Áo sơ mi Gucci', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/10/ao-so-mi-nam-gucci-blue-shirt-mau-xanh-blue-size-37-68ef0ce9b4373-15102025095433.png', 0, 1),
    (15, N'Áo Sơ Mi Nam Gucci Maxi GG', 5, 1, N'Áo sơ mi Gucci', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-so-mi-nam-gucci-maxi-gg-canvas-overshirt-in-brown-camel-770426-zaht5-mau-nau-size-44-699e634de9e8d-25022026094949.jpg', 0, 1),

    (16,N'Áo Nỉ Sweater Nam Gucci',6,1,N'Áo len Gucci','https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/12/ao-ni-nam-lacoste-men-s-sweatshirt-7519031-00-291-mau-trang-green-657fe72c0d9af-18122023133108.jpg',0,1),
    (17,N'Áo Len Nữ Gucci Red Knit',6,1,N'Áo len Gucci','https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/ao-len-nu-ralph-lauren-red-knit-kimberly-v-neck-sweater-211888688502-mau-do-size-s-6982d18df28c8-04022026115645.jpg',1,1),
    (18,N'Áo Len Gucci cổ cao',6,1,N'Áo len Gucci','https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/01/ao-len-nam-lacoste-high-neck-zip-up-sweater-ah921e-cca-mau-xam-size-3-697c4e31496eb-30012026132241.jpg',2,1),

    (19,N'Váy Nữ Gucci xám GG',7,1,N'Váy Gucci','https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/03/vay-nu-gucci-grey-with-gg-logo-embroidered-798155-xkcna-1130-mau-xam-69a921decb664-05032026132534.jpg',1,1),
    (20,N'Váy Nữ Gucci xanh navy Denim',7,1,N'Váy Gucci','https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2026/02/vay-nu-gucci-navy-blue-denim-dress-with-gg-pattern-818219-xdc9h-4528-mau-xanh-navy-size-s-69800c1a688ac-02022026092946.jpg',1,1),
    (21,N'Váy Nữ Gucci GG',7,1,N'Váy Gucci','https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2025/12/vay-nu-gucci-gg-knitted-dress-with-flower-brooch-mau-trang-kem-size-s-69539f6bb1af8-30122025164619.jpg',1,1),

    -- CHANEL (20 sản phẩm)
    (22, N'Áo Polo Chanel Logo', 1, 2, N' Áo Polo Chanel', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 2, 1),
    (23,N'Áo Polo Chanel Classic',1,2,N'Áo polo Chanel','https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg',2,1),

    (24, N'T-Shirt Chanel Classic', 2, 2, N'Áo thun Chanel', 'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 2, 1),
    (25, N'Áo thun chanel đen', 2, 2, N'Áo thun Chanel', 'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1, 1),
    (26, N'Áo thun chanel trắng', 2, 2, N'Áo thun Chanel', 'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1, 1),

    (27, N'Quần Chanel Pants', 3, 2, N'Quần Chanel', 'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 2, 1),
    (28, N'Quần chanel leging', 3, 2, N'Quần Chanel', 'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 1, 1),
    (29, N'Quần chanel dáng suông', 3, 2, N'Quần Chanel', 'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1, 1),

    (30, N'Áo Khoác Chanel Jacket', 4, 2, N'Jacket Chanel', 'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 2, 1),
    (31, N'Áo Khoác Chanel bomer', 4, 2, N'Jacket Chanel', 'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 2, 1),
    (32, N'Áo Khoác Chanel nữ', 4, 2, N'Jacket Chanel', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 2, 1),

    (33, N'Áo sơ mi Chanel', 5, 2, N'Áo sơ mi Chanel', 'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1, 1),
    (34, N'Áo sơ mi Chanel cao cấp', 5, 2, N'Áo sơ mi Chanel', 'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 2, 1),
    (35, N'Áo sơ mi Chanel trắng', 5, 2, N'Áo sơ mi Chanel', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 2, 1),

    (36, N'Áo sweater nữ Chanel đen', 6, 2, N'Áo sweater Chanel', 'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1, 1),
    (37, N'Áo sweater Chanel kem', 6, 2, N'Áo sweater Chanel', 'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 2, 1),
    (38, N'Áo sweater nam Chanel ', 6, 2, N'Áo sweater Chanel', 'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 0, 1),

    (39,N'Váy đầm nữ Chanel',7,2,N'Váy Chanel','https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg',1,1),
    (40,N'Váy nữ đen Chanel',7,2,N'Váy Chanel','https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383',1,1),
    (41,N'Giả váy nữ Chanel',7,2,N'Váy Chanel','https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg',1,1),

    -- MLB (4 sản phẩm)
    (9, N'Áo Polo MLB Monogram', 1, 3, N'Polo MLB', 'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 2, 1),
    (10, N'T-Shirt MLB BigLogo', 2, 3, N'Áo thun MLB', 'https://bizweb.dktcdn.net/100/446/974/products/ao-mlb-classic-monogram-big-logo-short-sleeve-t-shirt-new-york-yankees-black-3atsm0233-50bks-3.jpg?v=1686635060437', 2, 1),
    (11, N'Quần MLB Sport', 3, 3, N'Quần MLB', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/10/quan-jogger-mlb-classic-sports-logo-jogger-pants-la-dodgers-3fptg0134-07nys-mau-xanh-navy-652e5465a27ea-17102023163117.jpg', 2, 1),
    (12, N'Áo Khoác MLB Varsity', 4, 3, N'Áo khoác MLB', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/10/ao-bomber-mlb-wool-basic-varsity-jacket-new-york-yankees-3ajpv0634-50bkl-mau-den-652de78bbbe8d-17102023084651.jpg', 2, 1);
SET IDENTITY_INSERT dbo.SanPham OFF;
GO


-- 3. Chèn Biến Thể Sản Phẩm (SKU)

SET IDENTITY_INSERT dbo.SanPhamChiTiet ON;

-- ===================== GUCCI =====================
-- SP1: Áo Polo Gucci Cotton
INSERT INTO SanPhamChiTiet
(MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe)
VALUES
    (1, 1, 1, 1, 15000000, 8000000, 20, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1645054205/658077_XJDIJ_1082_001_100_0000_Light.jpg'),
    (2, 1, 2, 1, 15000000, 8000000, 25, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1645054205/658077_XJDIJ_1082_001_100_0000_Light.jpg'),
    (3, 1, 3, 2, 15000000, 8000000, 15, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1685372400/745249_XJF4M_9037_001_100_0000_Light.jpg'),
    (4, 1, 4, 2, 15000000, 8000000, 10, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1685372400/745249_XJF4M_9037_001_100_0000_Light.jpg');

-- SP2: Áo Thun Gucci Print
INSERT INTO SanPhamChiTiet
(MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe)
VALUES
    (5, 2, 1, 1, 12000000, 6000000, 20, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1684162800/548334_XJDAF_1082_001_100_0000_Light.jpg'),
    (6, 2, 2, 1, 12000000, 6000000, 25, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1684162800/548334_XJDAF_1082_001_100_0000_Light.jpg'),
    (7, 2, 3, 2, 12000000, 6000000, 10, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1684162800/548334_XJDAF_9088_001_100_0000_Light.jpg'),
    (8, 2, 4, 2, 12000000, 6000000, 5, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1684162800/548334_XJDAF_9088_001_100_0000_Light.jpg');

-- SP3: Quần Gucci Trackpant
INSERT INTO SanPhamChiTiet
(MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe)
VALUES
    (9, 3, 1, 1, 18000000, 9000000, 10, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1690218000/751555_XJF23_1082_001_100_0000_Light.jpg'),
    (10, 3, 2, 1, 18000000, 9000000, 12, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1690218000/751555_XJF23_1082_001_100_0000_Light.jpg'),
    (11, 3, 3, 1, 18000000, 9000000, 8, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1690218000/751555_XJF23_1082_001_100_0000_Light.jpg'),
    (12, 3, 4, 1, 18000000, 9000000, 5, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1690218000/751555_XJF23_1082_001_100_0000_Light.jpg');

-- SP4: Áo Khoác Gucci GG
INSERT INTO SanPhamChiTiet
(MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe)
VALUES
    (13, 4, 1, 3, 35000000, 20000000, 6, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1633453207/658077_XJDIJ_2184_001_100_0000_Light.jpg'),
    (14, 4, 2, 3, 35000000, 20000000, 5, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1633453207/658077_XJDIJ_2184_001_100_0000_Light.jpg'),
    (15, 4, 3, 3, 35000000, 20000000, 4, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1633453207/658077_XJDIJ_2184_001_100_0000_Light.jpg'),
    (16, 4, 4, 3, 35000000, 20000000, 3, 'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1633453207/658077_XJDIJ_2184_001_100_0000_Light.jpg');

-- ===================== CHANEL =====================
-- SP5: Áo Polo Chanel Logo
INSERT INTO SanPhamChiTiet
(MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe)
VALUES
    (17, 5, 1, 1, 11000000, 6000000, 20, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1676402323907-23p-p74656-k10703-94305-black-8817332994078.jpg'),
    (18, 5, 2, 1, 11000000, 6000000, 20, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1676402323907-23p-p74656-k10703-94305-black-8817332994078.jpg'),
    (19, 5, 3, 2, 11000000, 6000000, 12, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1676402323907-23p-p74656-k10703-10601-white-8817333026846.jpg'),
    (20, 5, 4, 2, 11000000, 6000000, 8, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1676402323907-23p-p74656-k10703-10601-white-8817333026846.jpg');

-- SP6: T-Shirt Chanel Classic
INSERT INTO SanPhamChiTiet
(MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe)
VALUES
    (21, 6, 1, 1, 10000000, 5000000, 15, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1708596821111-24p-p76388-k10924-94305-black-8847388110878.jpg'),
    (22, 6, 2, 1, 10000000, 5000000, 20, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1708596821111-24p-p76388-k10924-94305-black-8847388110878.jpg'),
    (23, 6, 3, 2, 10000000, 5000000, 10, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1708596821111-24p-p76388-k10924-10601-white-8847388143646.jpg'),
    (24, 6, 4, 2, 10000000, 5000000, 7, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1708596821111-24p-p76388-k10924-10601-white-8847388143646.jpg');

-- SP7: Quần Chanel Pants
INSERT INTO SanPhamChiTiet
(MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe)
VALUES
    (25, 7, 1, 1, 15000000, 8000000, 12, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-black-8835089629214.jpg'),
    (26, 7, 2, 1, 15000000, 8000000, 10, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-black-8835089629214.jpg'),
    (27, 7, 3, 1, 15000000, 8000000, 8, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-black-8835089629214.jpg'),
    (28, 7, 4, 1, 15000000, 8000000, 5, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-black-8835089629214.jpg');

-- SP8: Áo Khoác Chanel Jacket
INSERT INTO SanPhamChiTiet
(MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe)
VALUES
    (29, 8, 1, 1, 20000000, 12000000, 8, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-black-8835089629214.jpg'),
    (30, 8, 2, 1, 20000000, 12000000, 7, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-black-8835089629214.jpg'),
    (31, 8, 3, 2, 20000000, 12000000, 5, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-white-8835089661982.jpg'),
    (32, 8, 4, 2, 20000000, 12000000, 4, 'https://www.chanel.com/images/q_auto,f_auto,fl_lossy,dpr_auto/w_1920/FSH-1692093605823-23k-p75711-v67492-94305-white-8835089661982.jpg');

-- ===================== MLB =====================
-- SP9: Áo Polo MLB Monogram
INSERT INTO SanPhamChiTiet
(MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe)
VALUES
    (33, 9, 1, 1, 3500000, 1800000, 20, 'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_0a5e8a7e8a3c424b9c3c8a7e8a3c424b_grande.jpg'),
    (34, 9, 2, 1, 3500000, 1800000, 22, 'https://product.hstatic.net/1000284478/product/3ampr014n-50bks-ao-polo-mlb-monogram-overfit-new-york-yankees-1_0a5e8a7e8a3c424b9c3c8a7e8a3c424b_grande.jpg'),
    (35, 9, 3, 3, 3500000, 1800000, 15, 'https://product.hstatic.net/1000284478/product/3ampr014n-43bgs-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg'),
    (36, 9, 4, 3, 3500000, 1800000, 10, 'https://product.hstatic.net/1000284478/product/3ampr014n-43bgs-ao-polo-mlb-monogram-overfit-new-york-yankees-1_grande.jpg');

-- SP10: T-Shirt MLB BigLogo
INSERT INTO SanPhamChiTiet
(MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe)
VALUES
    (37, 10, 1, 1, 2500000, 1300000, 30, 'https://product.hstatic.net/1000284478/product/3atsm0233-50bks-ao-thun-mlb-classic-monogram-big-logo-new-york-yankees-1_grande.jpg'),
    (38, 10, 2, 1, 2500000, 1300000, 25, 'https://product.hstatic.net/1000284478/product/3atsm0233-50bks-ao-thun-mlb-classic-monogram-big-logo-new-york-yankees-1_grande.jpg'),
    (39, 10, 3, 2, 2500000, 1300000, 20, 'https://product.hstatic.net/1000284478/product/3atsm0233-50whs-ao-thun-mlb-classic-monogram-big-logo-new-york-yankees-1_grande.jpg'),
    (40, 10, 4, 2, 2500000, 1300000, 15, 'https://product.hstatic.net/1000284478/product/3atsm0233-50whs-ao-thun-mlb-classic-monogram-big-logo-new-york-yankees-1_grande.jpg');

-- SP11: Quần MLB Sport
INSERT INTO SanPhamChiTiet
(MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe)
VALUES
    (41, 11, 1, 4, 2900000, 1500000, 12, 'https://product.hstatic.net/1000284478/product/3fptg0134-07nys-quan-jogger-mlb-classic-sports-logo-la-dodgers-1_grande.jpg'),
    (42, 11, 2, 4, 2900000, 1500000, 10, 'https://product.hstatic.net/1000284478/product/3fptg0134-07nys-quan-jogger-mlb-classic-sports-logo-la-dodgers-1_grande.jpg'),
    (43, 11, 3, 4, 2900000, 1500000, 8, 'https://product.hstatic.net/1000284478/product/3fptg0134-07nys-quan-jogger-mlb-classic-sports-logo-la-dodgers-1_grande.jpg'),
    (44, 11, 4, 4, 2900000, 1500000, 5, 'https://product.hstatic.net/1000284478/product/3fptg0134-07nys-quan-jogger-mlb-classic-sports-logo-la-dodgers-1_grande.jpg');

-- SP12: Áo Khoác MLB Varsity
INSERT INTO SanPhamChiTiet
(MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe)
VALUES
    (45, 12, 1, 1, 4500000, 2500000, 10, 'https://product.hstatic.net/1000284478/product/3ajpv0634-50bkl-ao-khoac-mlb-wool-basic-varsity-new-york-yankees-1_grande.jpg'),
    (46, 12, 2, 1, 4500000, 2500000, 8, 'https://product.hstatic.net/1000284478/product/3ajpv0634-50bkl-ao-khoac-mlb-wool-basic-varsity-new-york-yankees-1_grande.jpg'),
    (47, 12, 3, 1, 4500000, 2500000, 6, 'https://product.hstatic.net/1000284478/product/3ajpv0634-50bkl-ao-khoac-mlb-wool-basic-varsity-new-york-yankees-1_grande.jpg'),
    (48, 12, 4, 1, 4500000, 2500000, 5, 'https://product.hstatic.net/1000284478/product/3ajpv0634-50bkl-ao-khoac-mlb-wool-basic-varsity-new-york-yankees-1_grande.jpg');
SET IDENTITY_INSERT dbo.SanPhamChiTiet OFF;
GO

-- 4. Chèn dữ liệu nghiệp vụ (Logic)
-- 4.1. ADMIN (MaTK=1) đăng bài
SET IDENTITY_INSERT dbo.BaiViet ON;
INSERT INTO BaiViet
(MaBV, MaLoaiBV, MaTK, TieuDe, NoiDung, HinhAnh, TrangThai, Slug)
VALUES
    (1, 1, 1, N'Bộ sưu tập Thu-Đông 2025 từ Gucci', N'Gucci vừa cho ra mắt bộ sưu tập Thu-Đông 2025, kết hợp giữa di sản cổ điển và cảm hứng đương đại. Các thiết kế nổi bật với chất liệu cao cấp và họa tiết monogram đặc trưng.', 'https://media.gucci.com/content/DiaryArticleSingle_Standard_1600x1600/1695222013/DiaryArticleSingle_gucci-ancora-fashion-show-2023-01_001_Default.jpg', 1, 'bo-suu-tap-thu-dong-2025-tu-gucci');
SET IDENTITY_INSERT dbo.BaiViet OFF;
GO

-- 4.2. NHÂN VIÊN (MaTK=2) nhập kho
SET IDENTITY_INSERT dbo.PhieuNhap ON;
INSERT INTO PhieuNhap
(MaPN, MaNV, MaNCC, TongTien, GhiChu)
VALUES
    (1, 2, 1, 80000000.00, N'Nhập 10 áo Polo Gucci Cotton size M, màu trắng');
SET IDENTITY_INSERT dbo.PhieuNhap OFF;
GO

INSERT INTO NhapKhoChiTiet
    (MaPN, MaBienThe, SoLuong, DonGiaNhap, ThanhTien)
VALUES
    (1, 3, 10, 8000000.00, 80000000.00); -- Nhập 10 áo Polo Gucci Cotton M Trắng (MaBienThe=3)
GO

-- GHI CHÚ QUAN TRỌNG: Logic cập nhật SoLuongTon và GiaNhap trong SanPhamChiTiet
-- sẽ được xử lý trong Spring Boot Service, KHÔNG dùng Trigger.
-- Câu lệnh UPDATE dưới đây chỉ để GIẢ LẬP logic đó cho dữ liệu mẫu:
UPDATE SanPhamChiTiet
SET SoLuongTon = SoLuongTon + 10
WHERE MaBienThe = 3;
GO

-- GIẢ LẬP CẬP NHẬT SỐ LƯỢNG ĐÃ BÁN
UPDATE SanPhamChiTiet
SET SoLuongDaBan = SoLuongDaBan + 1
WHERE MaBienThe = 13;
GO


-- 4.3. KHÁCH HÀNG (MaTK=3)
-- 4.3.1. Địa chỉ của khách
SET IDENTITY_INSERT dbo.SoDiaChi ON;
INSERT INTO SoDiaChi
(MaDiaChi, MaTK, HoTenNguoiNhan, SoDienThoai, DiaChiChiTiet, GhiChu, LaMacDinh)
VALUES
    (1, 3, N'Lê Văn Khách', '0900000003', N'789 Đường Khách Hàng, P.1, Q.Tân Bình, TP.HCM', N'Nhà riêng', 1),
    (2, 3, N'Trần Thị Vợ Khách', '0900000004', N'456 Đường Hậu Giang, Q6, TP.HCM', N'Cổng sau, lầu 2', 0),
    (3, 1, N'Admin Luxury', '0900000001', N'123 Đường Admin, Q1, TP.HCM', N'Văn phòng công ty', 1);
SET IDENTITY_INSERT dbo.SoDiaChi OFF;
GO

-- 4.3.2. Giỏ hàng của khách
SET IDENTITY_INSERT dbo.GioHang ON;
INSERT INTO GioHang
(MaGioHang, MaTK)
VALUES
    (1, 3);
SET IDENTITY_INSERT dbo.GioHang OFF;
GO

-- 4.3.3. (Trống - Đã xóa hàng mẫu trong giỏ)

-- 4.3.4. Khách chat với CSKH
-- 4.3.4. Khách chat với CSKH (Dùng hệ thống mới CuocTroChuyen/TinNhan)
INSERT INTO CuocTroChuyen (MaTK, TrangThai) VALUES (3, 'HUMAN'); -- MaCuocTroChuyen = 1
INSERT INTO TinNhan (MaCuocTroChuyen, LoaiNguoiGui, NoiDung)
VALUES (1, 'USER', N'Chào shop, tôi cần tư vấn về sản phẩm cao cấp');
GO

-- Seed data cho TrangThaiDonHang để khớp với chi tiết trong Java (0-5)
-- Phải chèn trước DonHang để thỏa mãn FK TrangThaiDH
INSERT INTO TrangThaiDonHang (MaTTDH, TenTTDH) VALUES
    (0, N'Chờ xác nhận'),
    (1, N'Đã xác nhận'),
    (2, N'Đang giao'),
    (3, N'Đã giao'),
    (4, N'Hoàn tất'),
    (5, N'Đã hủy');
GO

-- 4.3.5. Đơn hàng cũ (ĐÃ GIAO) của khách
SET IDENTITY_INSERT dbo.DonHang ON;
INSERT INTO DonHang
(MaDH, MaTK, NgayDat, TongTien, PhiShip, MaDiaChiGiao, MaHinhThucTT, TrangThaiDH, TrangThaiThanhToan, NgayThanhToan, NgayCapNhat)
VALUES
    (1, 3, GETDATE() - 7, 35030000.00, 30000.00, 1, 1, -- MaDiaChiGiao=1, MaHinhThucTT=1 (COD)
     4, -- TrangThaiDH = 4 (Đã giao)
     1, -- TrangThaiThanhToan = 1 (Đã thanh toán)
     GETDATE() - 6, -- NgayThanhToan
     GETDATE() - 6);
SET IDENTITY_INSERT dbo.DonHang OFF;
GO

-- 4.3.6. Chi tiết đơn hàng cũ
SET IDENTITY_INSERT dbo.DonHangCT ON;
INSERT INTO DonHangCT
(MaCT, MaDH, MaBienThe, SoLuong, DonGia)
VALUES
    (1, 1, 13, 1, 35000000.00);
-- Đã mua 1 Áo Khoác Gucci GG (MaBienThe=13)
SET IDENTITY_INSERT dbo.DonHangCT OFF;
GO

-- 4.3.7. Lịch sử đơn hàng cũ
INSERT INTO LichSuDonHang
    (MaDH, TrangThaiCu, TrangThaiMoi, GhiChu, NguoiCapNhat)
VALUES
    (1, 0, 1, N'Nhân viên xác nhận đơn', N'Nguyễn Thị Bán Hàng'),
    (1, 1, 2, N'Đang chuẩn bị hàng', N'Nguyễn Thị Bán Hàng'),
    (1, 2, 3, N'Bàn giao cho đơn vị vận chuyển', N'Hệ thống'),
    (1, 3, 4, N'Giao hàng thành công', N'Hệ thống');
GO

-- 4.3.8. Khách đánh giá đơn hàng cũ
SET IDENTITY_INSERT dbo.DanhGia ON;
INSERT INTO DanhGia
(MaDG, MaCT, MaTK, NoiDung, Diem)
VALUES
    (1, 1, 3, N'Áo khoác rất đẹp, hàng chuẩn auth, giao nhanh.', 5);
-- Đánh giá cho MaCT=1 (Áo Khoác Gucci)
SET IDENTITY_INSERT dbo.DanhGia OFF;
GO

-- (Seed data TrangThaiDonHang đã được dời lên trên)

-- Seed data mẫu cho ThongKe (ngày hiện tại)
SET IDENTITY_INSERT dbo.ThongKe ON;
INSERT INTO ThongKe (MaThongKe, NgayBaoCao, TongDoanhThu, TongDonHang, TongSanPhamBanRa)
VALUES (1, CAST(GETDATE() AS DATE), 35030000.00, 1, 1);
SET IDENTITY_INSERT dbo.ThongKe OFF;
GO

GO

PRINT N'PHẦN 3: CHÈN DỮ LIỆU MẪU THÀNH CÔNG!';
GO

-- PHẦN 4: KIỂM TRA DỮ LIỆU
PRINT N'========================================';
PRINT N'PHẦN 4: KIỂM TRA DỮ LIỆU';
PRINT N'========================================';
GO

-- 1. Tổng quan số lượng
SELECT (SELECT COUNT(*)
        FROM TaiKhoan) AS TongTaiKhoan,
       (SELECT COUNT(*)
        FROM SanPham) AS TongSanPham,
       (SELECT COUNT(*)
        FROM SanPhamChiTiet) AS TongBienThe,
       (SELECT COUNT(*)
        FROM DonHang) AS TongDonHang;
GO

-- 2. Kiểm tra sản phẩm có TrangThaiSP = 1 (đang bán)
SELECT MaSP, TenSP, GioiTinh, TrangThaiSP, MaTH, MaLoai
FROM SanPham
WHERE TrangThaiSP = 1;
GO

-- 3. Kiểm tra biến thể của một sản phẩm cụ thể (ví dụ MaSP = 1)
SELECT spct.MaBienThe, sp.TenSP, s.TenSize, m.TenMau, spct.GiaBan, spct.SoLuongTon, spct.SoLuongDaBan
FROM SanPhamChiTiet spct
         INNER JOIN SanPham sp ON spct.MaSP = sp.MaSP
         LEFT JOIN SizeSP s ON spct.MaSize = s.MaSize
         LEFT JOIN MauSacSP m ON spct.MaMau = m.MaMau
WHERE spct.MaSP = 1
ORDER BY spct.MaBienThe;
GO

-- 4. Kiểm tra đơn hàng và chi tiết đơn hàng
SELECT dh.MaDH, tk.HoTen, dh.TongTien, dh.TrangThaiDH, httt.TenHinhThuc
FROM DonHang dh
         LEFT JOIN TaiKhoan tk ON dh.MaTK = tk.MaTK
         LEFT JOIN HinhThucThanhToan httt ON dh.MaHinhThucTT = httt.MaHinhThucTT;

SELECT ct.MaDH, sp.TenSP, s.TenSize, m.TenMau, ct.SoLuong, ct.DonGia
FROM DonHangCT ct
         JOIN SanPhamChiTiet spct ON ct.MaBienThe = spct.MaBienThe
         JOIN SanPham sp ON spct.MaSP = sp.MaSP
         LEFT JOIN SizeSP s ON spct.MaSize = s.MaSize
         LEFT JOIN MauSacSP m ON spct.MaMau = m.MaMau
WHERE ct.MaDH = 1;
GO

-- 5. Kiểm tra giỏ hàng của khách hàng
SELECT tk.HoTen, sp.TenSP, s.TenSize, m.TenMau, ghct.SoLuong
FROM GioHangChiTiet ghct
         JOIN GioHang gh ON ghct.MaGioHang = gh.MaGioHang
         JOIN TaiKhoan tk ON gh.MaTK = tk.MaTK
         JOIN SanPhamChiTiet spct ON ghct.MaBienThe = spct.MaBienThe
         JOIN SanPham sp ON spct.MaSP = sp.MaSP
         LEFT JOIN SizeSP s ON spct.MaSize = s.MaSize
         LEFT JOIN MauSacSP m ON spct.MaMau = m.MaMau
WHERE tk.MaTK = 3;
GO


/*
================================================================================
SCRIPT SELECT TẤT CẢ DỮ LIỆU TỪ TẤT CẢ CÁC BẢNG
Database: LuxuryFashion_2025
================================================================================
*/

PRINT N'========================================';
PRINT N'1. BẢNG TÀI KHOẢN VÀ PHÂN QUYỀN';
PRINT N'========================================';

-- Bảng VaiTro
SELECT '=== VAI TRO ===' AS [Table];
SELECT *
FROM VaiTro;
GO

-- Bảng TaiKhoan
SELECT '=== TAI KHOAN ===' AS [Table];
SELECT *
FROM TaiKhoan;
GO

-- Bảng TaiKhoan_VaiTro
SELECT '=== TAI KHOAN - VAI TRO ===' AS [Table];
SELECT *
FROM TaiKhoan_VaiTro;
GO

-- Bảng SoDiaChi
SELECT '=== SO DIA CHI ===' AS [Table];
SELECT *
FROM SoDiaChi;
GO

PRINT N'========================================';
PRINT N'2. BẢNG SẢN PHẨM';
PRINT N'========================================';

-- Bảng ThuongHieu
SELECT '=== THUONG HIEU ===' AS [Table];
SELECT *
FROM ThuongHieu;
GO

-- Bảng LoaiSanPham
SELECT '=== LOAI SAN PHAM ===' AS [Table];
SELECT *
FROM LoaiSanPham;
GO

-- Bảng SizeSP
SELECT '=== SIZE SP ===' AS [Table];
SELECT *
FROM SizeSP;
GO

-- Bảng MauSacSP
SELECT '=== MAU SAC SP ===' AS [Table];
SELECT *
FROM MauSacSP;
GO

-- Bảng SanPham
SELECT '=== SAN PHAM ===' AS [Table];
SELECT *
FROM SanPham;
GO

-- Bảng SanPhamChiTiet
SELECT '=== SAN PHAM CHI TIET ===' AS [Table];
SELECT *
FROM SanPhamChiTiet;
GO

-- Bảng HinhAnhSP
SELECT '=== HINH ANH SP ===' AS [Table];
SELECT *
FROM HinhAnhSP;
GO

PRINT N'========================================';
PRINT N'3. BẢNG KHUYẾN MÃI';
PRINT N'========================================';


PRINT N'========================================';
PRINT N'4. BẢNG ĐỠN HÀNG';
PRINT N'========================================';

-- Bảng HinhThucThanhToan
SELECT '=== HINH THUC THANH TOAN ===' AS [Table];
SELECT *
FROM HinhThucThanhToan;
GO

-- Bảng DonHang
SELECT '=== DON HANG ===' AS [Table];
SELECT *
FROM DonHang;
GO

-- Bảng DonHangCT
SELECT '=== DON HANG CHI TIET ===' AS [Table];
SELECT *
FROM DonHangCT;
GO

-- Bảng LichSuDonHang
SELECT '=== LICH SU DON HANG ===' AS [Table];
SELECT *
FROM LichSuDonHang;
GO

-- Bảng DanhGia
SELECT '=== DANH GIA ===' AS [Table];
SELECT *
FROM DanhGia;
GO

PRINT N'========================================';
PRINT N'5. BẢNG GIỎ HÀNG';
PRINT N'========================================';

-- Bảng GioHang
SELECT '=== GIO HANG ===' AS [Table];
SELECT *
FROM GioHang;
GO

-- Bảng GioHangChiTiet
SELECT '=== GIO HANG CHI TIET ===' AS [Table];
SELECT *
FROM GioHangChiTiet;
GO

PRINT N'========================================';
PRINT N'6. BẢNG BÀI VIẾT';
PRINT N'========================================';

-- Bảng LoaiBaiViet
SELECT '=== LOAI BAI VIET ===' AS [Table];
SELECT *
FROM LoaiBaiViet;
GO

-- Bảng BaiViet
SELECT '=== BAI VIET ===' AS [Table];
SELECT *
FROM BaiViet;
GO

-- Bảng BinhLuan
SELECT '=== BINH LUAN ===' AS [Table];
SELECT *
FROM BinhLuan;
GO

PRINT N'========================================';
PRINT N'7. BẢNG KHO HÀNG';
PRINT N'========================================';

-- Bảng NhaCungCap
SELECT '=== NHA CUNG CAP ===' AS [Table];
SELECT *
FROM NhaCungCap;
GO

-- Bảng PhieuNhap
SELECT '=== PHIEU NHAP ===' AS [Table];
SELECT *
FROM PhieuNhap;
GO

-- Bảng NhapKhoChiTiet
SELECT '=== NHAP KHO CHI TIET ===' AS [Table];
SELECT *
FROM NhapKhoChiTiet;
GO

PRINT N'========================================';
PRINT N'8. BẢNG THÀNH VIÊN';
PRINT N'========================================';


PRINT N'========================================';
PRINT N'9. BẢNG CHAT';
PRINT N'========================================';

-- Bảng CuocTroChuyen
SELECT '=== CUOC TRO CHUYEN ===' AS [Table];
SELECT *
FROM CuocTroChuyen;
GO

-- Bảng TinNhan
SELECT '=== TIN NHAN ===' AS [Table];
SELECT *
FROM TinNhan;
GO

PRINT N'========================================';
PRINT N'10. THỐNG KÊ TỔNG QUAN';
PRINT N'========================================';

SELECT
    'TaiKhoan' AS TableName,
    COUNT(*) AS TotalRecords
FROM TaiKhoan
UNION ALL
SELECT 'SanPham', COUNT(*)
FROM SanPham
UNION ALL
SELECT 'SanPhamChiTiet', COUNT(*)
FROM SanPhamChiTiet
UNION ALL
SELECT 'DonHang', COUNT(*)
FROM DonHang
UNION ALL
SELECT 'DonHangCT', COUNT(*)
FROM DonHangCT
UNION ALL
SELECT 'GioHang', COUNT(*)
FROM GioHang
UNION ALL
SELECT 'GioHangChiTiet', COUNT(*)
FROM GioHangChiTiet
UNION ALL
SELECT 'BaiViet', COUNT(*)
FROM BaiViet
UNION ALL

SELECT 'PhieuNhap', COUNT(*)
FROM PhieuNhap
ORDER BY TableName;
GO

PRINT N'========================================';
PRINT N'✅ ĐÃ SELECT TẤT CẢ CÁC BẢNG!';
PRINT N'========================================';

PRINT N'========================================';
PRINT N'BẢNG TRẠNG THÁI ĐƠN HÀNG (BỔ SUNG)';
PRINT N'========================================';
SELECT '=== TRANG THAI DON HANG ===' AS [Table];
SELECT * FROM TrangThaiDonHang;
GO

PRINT N'========================================';
PRINT N'BẢNG THỐNG KÊ (BỔ SUNG)';
PRINT N'========================================';
SELECT '=== THONG KE ===' AS [Table];
SELECT * FROM ThongKe;
GO

PRINT N'========================================';
PRINT N'BẢNG NHẬP KHO (BỔ SUNG)';
PRINT N'========================================';
GO



PRINT N'========================================';
PRINT N'SCRIPTS 1: TỔNG QUAN ĐƠN HÀNG VÀ TRẠNG THÁI';
PRINT N'========================================';
GO

SELECT
    DH.MaDH,
    TK.HoTen AS N'Người Đặt Hàng',
    TK.Email,
    DH.NgayDat,
    TTDH.TenTTDH AS N'Trạng Thái Đơn Hàng',
    DH.TongTien,
    DH.TrangThaiThanhToan
-- 0=Chờ, 1=Đã TT, 2=Lỗi, 3=Hoàn tiền
FROM
    dbo.DonHang DH
        INNER JOIN
    dbo.TaiKhoan TK ON DH.MaTK = TK.MaTK
        LEFT JOIN
    dbo.TrangThaiDonHang TTDH ON DH.TrangThaiDH = TTDH.MaTTDH
ORDER BY
    DH.NgayDat DESC;
GO






PRINT N'========================================';
PRINT N'SCRIPTS KIỂM TRA BẢNG TRẠNG THÁI ĐƠN HÀNG';
PRINT N'========================================';
GO-- 1. HIỂN THỊ TẤT CẢ CÁC TRẠNG THÁI ĐƠN HÀNG
SELECT
    MaTTDH AS N'Mã Trạng Thái (Key)',
    TenTTDH AS N'Tên Trạng Thái'
FROM
    dbo.TrangThaiDonHang
ORDER BY
    MaTTDH;
GO

-- 2. ĐẾN TỔNG SỐ LƯỢNG BẢNG TRẠNG THÁI (Records)
SELECT
    COUNT(*) AS N'Tổng Số Lượng Trạng Thái Đơn Hàng'
FROM
    dbo.TrangThaiDonHang;
GO

PRINT N'========================================';
PRINT N'✅ ĐÃ KIỂM TRA BẢNG TRẠNG THÁI ĐƠN HÀNG.';
PRINT N'========================================';




/*
================================================================================
CẬP NHẬT DATABASE CHO GOOGLE OAUTH2 LOGIN
Thêm cột Provider vào bảng TaiKhoan để phân biệt LOCAL và GOOGLE
================================================================================
*/

USE LuxuryFashion_2025;
GO

-- Thêm cột Provider vào bảng TaiKhoan
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('TaiKhoan') AND name = 'Provider')
BEGIN
ALTER TABLE TaiKhoan
    ADD Provider VARCHAR(20) DEFAULT 'LOCAL';

PRINT N'✅ Đã thêm cột Provider vào bảng TaiKhoan';
END
ELSE
BEGIN
    PRINT N'⚠️ Cột Provider đã tồn tại';
END
GO

-- Cập nhật các tài khoản hiện tại thành LOCAL
-- Cho phép MatKhau có thể NULL (vì Google OAuth không có password)
ALTER TABLE TaiKhoan
ALTER COLUMN MatKhau VARCHAR(255) NULL;
GO

PRINT N'✅ Hoàn tất cập nhật database cho OAuth2!';
PRINT N'✅ Bảng TaiKhoan giờ có cột Provider: LOCAL hoặc GOOGLE';
GO







-- =====================================================
-- SCRIPT CẬP NHẬT DATABASE CHO PAYOS PAYMENT INTEGRATION
-- Thực hiện sau khi chạy db.sql chính
-- =====================================================

USE LuxuryFashion_2025;
GO

PRINT N'Bắt đầu cập nhật database cho PayOS...';
GO

-- ===== THÊM PHƯƠNG THỨC THANH TOÁN PAYOS =====
-- Kiểm tra xem đã có PayOS chưa
IF NOT EXISTS (SELECT 1 FROM HinhThucThanhToan WHERE TenHinhThuc = N'PayOS')
BEGIN
INSERT INTO HinhThucThanhToan (TenHinhThuc, MoTa, TrangThai)
VALUES (N'PayOS', N'Thanh toán qua QR Code PayOS (Ngân hàng)', 1);
PRINT N'✅ Đã thêm phương thức thanh toán PayOS';
END
ELSE
BEGIN
    PRINT N'⚠️ Phương thức PayOS đã tồn tại';
END
GO

-- ===== CẬP NHẬT CỘT MaGiaoDich VÀ LyDoHuy NẾU CHƯA CÓ =====
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('DonHang') AND name = 'LyDoHuy')
BEGIN
ALTER TABLE DonHang ADD LyDoHuy NVARCHAR(255);
PRINT N'✅ Đã thêm cột LyDoHuy vào bảng DonHang';
END
ELSE
BEGIN
    PRINT N'⚠️ Cột LyDoHuy đã tồn tại';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('DonHang') AND name = 'MaGiaoDich')
BEGIN
ALTER TABLE DonHang ADD MaGiaoDich VARCHAR(100);
PRINT N'✅ Đã thêm cột MaGiaoDich vào bảng DonHang';
END
ELSE
BEGIN
    PRINT N'⚠️ Cột MaGiaoDich đã tồn tại';
END
GO

-- ===== CẬP NHẬT CỘT BÁO CHƯA NHẬN HÀNG =====
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('DonHang') AND name = 'KhachBaoChuaNhan')
BEGIN
    ALTER TABLE DonHang ADD KhachBaoChuaNhan BIT DEFAULT 0;
    ALTER TABLE DonHang ADD LyDoChuaNhan NVARCHAR(255);
    ALTER TABLE DonHang ADD MoTaChuaNhan NVARCHAR(1000);
    PRINT N'✅ Đã thêm các cột báo cáo chưa nhận hàng vào bảng DonHang';
END
GO

-- ===== KIỂM TRA KẾT QUẢ =====
PRINT N'';
PRINT N'===== DANH SÁCH PHƯƠNG THỨC THANH TOÁN =====';
SELECT
    MaHinhThucTT as [ID],
    TenHinhThuc as [Tên phương thức],
    MoTa as [Mô tả],
    CASE WHEN TrangThai = 1 THEN N'Hoạt động' ELSE N'Không hoạt động' END as [Trạng thái]
FROM HinhThucThanhToan
ORDER BY MaHinhThucTT;
GO

PRINT N'';
PRINT N'✅ Hoàn tất cập nhật database cho PayOS!';
PRINT N'';
PRINT N'📝 GHI CHÚ:';
PRINT N'- Phương thức PayOS đã được thêm vào hệ thống';
PRINT N'- Khách hàng có thể chọn PayOS khi checkout';
PRINT N'- Hệ thống sẽ tạo QR code tự động';
PRINT N'- Webhook sẽ tự động cập nhật trạng thái thanh toán';
GO



/*
================================================================================
SCRIPT THÊM SẢN PHẨM TEST VỚI GIÁ 3000 VND CHO MỤC ĐÍCH KIỂM TRA THANH TOÁN
================================================================================
*/
USE LuxuryFashion_2025;
GO

PRINT N'Bắt đầu thêm sản phẩm TEST (Áo 3k)...';
GO

-- 1. Thêm Sản Phẩm Mới (MaSP=13)
SET IDENTITY_INSERT dbo.SanPham ON;
INSERT INTO SanPham
(MaSP, TenSP, MaLoai, MaTH, MoTa, AnhChinh, GioiTinh, TrangThaiSP)
VALUES
    (13, N'Áo T-Shirt TEST Giá 3k', 2, 3, N'Sản phẩm dùng để test cổng thanh toán PayOS/VNPay. Không dùng để bán.', 'https://fakeimg.pl/250x250/?text=3000VND_TEST', 2, 1);
SET IDENTITY_INSERT dbo.SanPham OFF;
GO

-- 2. Thêm Biến Thể Sản Phẩm (SKU) với giá 3.000 VND (MaBienThe=49)
-- Giả định MaBienThe tiếp theo là 49 (Sau MaBienThe=48)
SET IDENTITY_INSERT dbo.SanPhamChiTiet ON;
INSERT INTO SanPhamChiTiet
(MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe)
VALUES
    (49, 13, 1, 1, 3000.00, 1000.00, 50, 'https://fakeimg.pl/250x250/?text=3000VND_TEST');
SET IDENTITY_INSERT dbo.SanPhamChiTiet OFF;
GO

PRINT N'✅ Đã thêm sản phẩm TEST (Áo T-Shirt TEST Giá 3k) thành công!';
GO

-- 3. KIỂM TRA SẢN PHẨM VỪA TẠO
PRINT N'========================================';
PRINT N'KIỂM TRA SẢN PHẨM TEST (Áo T-Shirt TEST Giá 3k)';
PRINT N'========================================';

SELECT
    SP.MaSP,
    SP.TenSP,
    TH.TenTH AS N'Thương Hiệu',
    LSP.TenLoai AS N'Loại Sản Phẩm',
    SPCT.MaBienThe,
    SS.TenSize AS N'Size',
    MS.TenMau AS N'Màu',
    SPCT.GiaBan,
    SPCT.SoLuongTon
FROM
    dbo.SanPham SP
        INNER JOIN
    dbo.SanPhamChiTiet SPCT ON SP.MaSP = SPCT.MaSP
        LEFT JOIN
    dbo.ThuongHieu TH ON SP.MaTH = TH.MaTH
        LEFT JOIN
    dbo.LoaiSanPham LSP ON SP.MaLoai = LSP.MaLoai
        LEFT JOIN
    dbo.SizeSP SS ON SPCT.MaSize = SS.MaSize
        LEFT JOIN
    dbo.MauSacSP MS ON SPCT.MaMau = MS.MaMau
WHERE
    SP.MaSP = 13;
GO

PRINT N'========================================';
PRINT N'✅ HOÀN TẤT THÊM SẢN PHẨM TEST.';
PRINT N'========================================';














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
GO

PRINT N'✅ HOÀN TẤT TOÀN BỘ KỊCH BẢN THIẾT LẬP DB!';
GO


-- ✅ PHẦN 4: TRIGGERS AUTO-UPDATE NgayCapNhat
-- =====================================================
GO

CREATE TRIGGER trg_UpdateTaiKhoan_NgayCapNhat ON TaiKhoan AFTER UPDATE AS
BEGIN UPDATE TaiKhoan SET NgayCapNhat = GETDATE() FROM TaiKhoan INNER JOIN inserted ON TaiKhoan.MaTK = inserted.MaTK END;
GO

CREATE TRIGGER trg_UpdateSanPham_NgayCapNhat ON SanPham AFTER UPDATE AS
BEGIN UPDATE SanPham SET NgayCapNhat = GETDATE() FROM SanPham INNER JOIN inserted ON SanPham.MaSP = inserted.MaSP END;
GO

CREATE TRIGGER trg_UpdateDonHang_NgayCapNhat ON DonHang AFTER UPDATE AS
BEGIN UPDATE DonHang SET NgayCapNhat = GETDATE() FROM DonHang INNER JOIN inserted ON DonHang.MaDH = inserted.MaDH END;
GO

CREATE TRIGGER trg_UpdateCuocTroChuyen_NgayCapNhat ON CuocTroChuyen AFTER UPDATE AS
BEGIN UPDATE CuocTroChuyen SET NgayCapNhat = GETDATE() FROM CuocTroChuyen INNER JOIN inserted ON CuocTroChuyen.MaCuocTroChuyen = inserted.MaCuocTroChuyen END;
GO

CREATE TRIGGER trg_UpdateGioHang_NgayCapNhat ON GioHang AFTER UPDATE AS
BEGIN UPDATE GioHang SET NgayCapNhat = GETDATE() FROM GioHang INNER JOIN inserted ON GioHang.MaGioHang = inserted.MaGioHang END;
GO


-- ✅ HOÀN TẤT TOÀN BỘ KỊCH BẢN!
GO
