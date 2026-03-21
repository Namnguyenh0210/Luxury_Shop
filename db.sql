
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
IF OBJECT_ID('dbo.YeuCauNhapKho', 'U') IS NOT NULL
DROP TABLE dbo.YeuCauNhapKho;
IF OBJECT_ID('dbo.PhieuNhap', 'U') IS NOT NULL
DROP TABLE dbo.PhieuNhap;
IF OBJECT_ID('dbo.Voucher', 'U') IS NOT NULL
DROP TABLE dbo.Voucher;
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
                          Avatar NVARCHAR(MAX),
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
                            MoTa NVARCHAR(255),
                            TrangThai INT NOT NULL DEFAULT 1
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
                         AnhChinh NVARCHAR(MAX),
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
                                AnhBienThe NVARCHAR(MAX),
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
    DuongDan NVARCHAR(MAX)
);


-- Bảng: TrangThaiDonHang (Định nghĩa trước DonHang để làm FK)
IF OBJECT_ID('dbo.TrangThaiDonHang', 'U') IS NOT NULL
DROP TABLE dbo.TrangThaiDonHang;

CREATE TABLE TrangThaiDonHang
(
    MaTTDH INT PRIMARY KEY, -- Khớp trực tiếp mã trạng thái 0,1,2,3,4
    TenTTDH NVARCHAR(50) NOT NULL UNIQUE
);

-- Bảng: Voucher
CREATE TABLE Voucher (
    MaVoucher BIGINT IDENTITY(1,1) PRIMARY KEY,
    Code VARCHAR(50) UNIQUE NOT NULL,
    MoTa NVARCHAR(1000),
    LoaiGiamGia INT NOT NULL, -- 0: %, 1: VND
    GiaTri DECIMAL(18, 2) NOT NULL,
    GiaTriToiThieu DECIMAL(18, 2) DEFAULT 0,
    GiaTriToiDa DECIMAL(18, 2),
    SoLuong INT DEFAULT 100,
    DaSuDung INT DEFAULT 0,
    GioiHanUser INT DEFAULT 1,
    ApDungCho VARCHAR(50) DEFAULT 'ALL', -- ALL, NEW, VIP, PRIVATE
    MinTotalSpendingVIP DECIMAL(18, 2) DEFAULT 0,
    MaLoaiApDung VARCHAR(255),
    MaTHApDung VARCHAR(255),
    KhongApDungSale BIT DEFAULT 0,
    NgayBatDau DATETIME,
    NgayKetThuc DATETIME,
    TrangThai BIT DEFAULT 1,
    IsDeleted BIT DEFAULT 0
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
                         GiamGia DECIMAL(18, 2) DEFAULT 0,
                         MaVoucher BIGINT FOREIGN KEY REFERENCES Voucher(MaVoucher) ON DELETE SET NULL,
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
                           Gateway       NVARCHAR(50), -- PayOS, Momo, COD...
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
    HinhAnh   NVARCHAR(MAX),
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

-- Bảng: YeuCauNhapKho
CREATE TABLE YeuCauNhapKho
(
    MaYeuCau BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaNV BIGINT NOT NULL FOREIGN KEY REFERENCES TaiKhoan(MaTK),
    MaBienThe BIGINT NOT NULL FOREIGN KEY REFERENCES SanPhamChiTiet(MaBienThe) ON DELETE CASCADE,
    SoLuongYeuCau INT NOT NULL,
    NgayYeuCau DATETIME DEFAULT GETDATE(),
    TrangThai INT DEFAULT 0,
    GhiChu NVARCHAR(500)
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
    (1, N'Admin', 'admin@luxury.com', '123', '0900000001', N'123 Đường Admin, Q1, TP.HCM', 1),
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
(MaTH, TenTH, MoTa, TrangThai)
VALUES
    (1, N'Gucci', N'Thương hiệu thời trang cao cấp của Ý', 1),
    (2, N'Chanel', N'Thương hiệu thời trang cao cấp của Pháp', 1),
    (3, N'MLB', N'Thương hiệu thời trang thể thao Hàn Quốc', 1);
SET IDENTITY_INSERT dbo.ThuongHieu OFF;
GO


SET IDENTITY_INSERT dbo.LoaiSanPham ON;
INSERT INTO LoaiSanPham
(MaLoai, TenLoai, MoTa)
VALUES
    (1, N'Áo Polo', N'Các loại áo polo'),
    (2, N'T-Shirt', N'Áo thun nam nữ'),
    (3, N'Quần', N'Quần thời trang'),
    (4, N'Áo Khoác', N'Áo khoác thời trang'),
    (5, N'Áo Sơ Mi', N'Áo sơ mi nam nữ'),
    (6, N'Áo Len', N'Áo len và sweater'),
    (7, N'Váy', N'Váy và đầm nữ');
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
    (2, N'Thanh toán qua PayOS', N'Quét mã QR qua cổng PayOS an toàn', 1);
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

-- 1.5. Chèn Voucher Mẫu
SET IDENTITY_INSERT dbo.Voucher ON;
INSERT INTO Voucher 
(MaVoucher, Code, MoTa, LoaiGiamGia, GiaTri, GiaTriToiThieu, SoLuong, DaSuDung, ApDungCho, NgayBatDau, NgayKetThuc, TrangThai)
VALUES
    (1, 'LUXURY500', N'Giảm ngay 500k cho đơn hàng từ 10tr', 1, 500000, 10000000, 100, 0, 'ALL', GETDATE(), DATEADD(month, 1, GETDATE()), 1),
    (2, 'VIP10', N'Ưu đãi 10% cho khách hàng VIP (Đã tiêu trên 20tr)', 0, 10, 5000000, 50, 0, 'VIP', GETDATE(), DATEADD(year, 1, GETDATE()), 1),
    (3, 'NEWBIE', N'Giảm 20% cho đơn hàng đầu tiên (Max 2tr)', 0, 20, 1000000, 500, 0, 'NEW', GETDATE(), DATEADD(month, 3, GETDATE()), 1);
SET IDENTITY_INSERT dbo.Voucher OFF;
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
    (22, N'Áo Polo Chanel CC Logo', 1, 2, N'Áo polo cổ bậ, logo CC vàng nổi bật trên nền đen sang trọng', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/562/756/products/vn-11134207-7r98o-lzvvkdx3bgwdda.jpg?v=1745749588853', 2, 1),
    (23, N'Áo Polo Chanel Phối Màu', 1, 2, N'Áo polo Chanel phối dải màu thanh lịch', 'https://hotgirlshop.vn/uploads/picture/28022024/News/20228203922-ao-thun-polo-chanel-phoi-mau.jpg', 2, 1),

    (24, N'T-Shirt Chanel Logo To', 2, 2, N'Áo thun in logo Chanel to nổi bật', 'https://yeli.vn/resources/uploaded/YeliShop/Products/2021/07/14607/order-ao-thun-chanel-logo-to-1-637620631410125837.jpg', 2, 1),
    (25, N'Áo Thun Chanel CC Black', 2, 2, N'Áo thun Chanel màu đen clasíic', 'https://product.hstatic.net/200000866247/product/img_3872_21365311e3bb4ebcb890a65d0485ca66_grande.jpeg', 1, 1),
    (26, N'Áo Thun Chanel CC Trắng', 2, 2, N'Áo thun Chanel logo CC màu trắng', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/ao-thun-chanel-cc-trang.jpg', 1, 1),

    (27, N'Quần Chanel Wide Leg', 3, 2, N'Quần dài ống rộng Chanel thanh lịch dành cho nữ', 'https://static.hotdeal.vn/images/859/859348/400x500/203799-quan-legging-in-hoa-tiet-ca-tinh-203782-vn-2-3.jpg', 2, 1),
    (28, N'Quần Chanel Sườn Jean', 3, 2, N'Quần sườn jean Chanel phong cách', 'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1, 1),
    (29, N'Quần Chanel Dáng Suông', 3, 2, N'Quần chanel dáng suông uyển chuyển', 'https://hotgirlshop.vn/uploads/picture/31052022/News/20531124516-quan-suon-jean-chanel-co-mac-khong.jpg', 1, 1),

    (30, N'Áo Khoác Chanel Tweed Jacket', 4, 2, N'Áo khoác Chanel tweed họa tiết monogram kinh điển', 'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 2, 1),
    (31, N'Áo Khoác Chanel Bomber Nữ', 4, 2, N'Áo bomber Chanel xế túi cá tính dành cho nữ', 'https://hotgirlshop.vn/uploads/picture/25092021/News/20925205735-ao-khoac-nu-chanel.jpg', 2, 1),
    (32, N'Áo Khoác Chanel Chần Bong', 4, 2, N'Áo khoác Chanel dáng chần bong vintage', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVfEwxeWB3ZLcS8QFdKo6aC9Oc99Jx3vOLdU5JXDJKGMgk9dP_8oe2zaGelH6I4h8G2vswiCAlakFNy_BvpbpzqmiDpvpAGs1tDt0r-vm-YwSXgpp4M6-SFTIJWM9W83we2jJ7UzAt6CM/s1024/ao-khoac-chanel-c915465740.jpg', 2, 1),

    (33, N'Áo Sơ Mi Chanel Kiều Vừa', 5, 2, N'Áo sơ mi Chanel kiểu vừa thanh lịch', 'https://hhgs.pro/upload/crawler/ao-somi-chanel-a5180.jpg', 1, 1),
    (34, N'Áo Sơ Mi Chanel Nữ Auth', 5, 2, N'Áo sơ mi Chanel dải rủ cao cấp', 'https://hotgirlshop.vn/uploads/picture/10042022/News/20410161312-ao-chanel-auth.jpg', 2, 1),
    (35, N'Áo Sơ Mi Chanel CC Trắng', 5, 2, N'Áo sơ mi Chanel logo CC màu trắng', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnpAR6vgr8K5_2L3t3pUHh7S4pEiBNBT5CaA&s', 2, 1),

    (36, N'Áo Len Chanel Knit Trắng Kem', 6, 2, N'Áo sweater len Chanel màu kem nhẹ nhàng', 'https://cdn-images.farfetch-contents.com/22/94/38/09/22943809_54949965_1000.jpg', 1, 1),
    (37, N'Áo Sweater Chanel CC Đen', 6, 2, N'Áo sweater dày Chanel logo CC màu đen cổ điển', 'https://treasuresofnewyorkcity.com/cdn/shop/products/image_04e3a66c-3f62-4141-b13f-b2da33dc6efa.jpg?v=1657302411', 2, 1),
    (38, N'Áo Sweater Chanel Vintage', 6, 2, N'Áo len vintage Chanel phong cách', 'https://www.ragsrevived.com/cdn/shop/products/8986330D-0F74-4586-9AA2-B695F7D06485.jpg?v=1644422949', 0, 1),

    (39, N'Váy Đầm Chanel Logo Vàng', 7, 2, N'Váy đầm Chanel họa tiết, logo vàng sang trọng', 'https://hotgirlshop.com/uploads/picture/29052022/News/20529125625-ao-dam-chanel-chinh-hang-new-auth.jpg', 1, 1),
    (40, N'Váy Midi Chanel Đen', 7, 2, N'Váy midi Chanel đen xuất sắc, thanh lịch', 'https://bizweb.dktcdn.net/thumb/1024x1024/100/397/400/products/mix-6403.jpg?v=1675591528383', 1, 1),
    (41, N'Váy Chân Váy Chanel Monogram', 7, 2, N'Chân váy Chanel họa tiết chữ monogram', 'https://hotgirlshop.vn/uploads/products/t_20419181718-vay-dai-dior-chinh-hang.jpg', 1, 1),

    -- MLB (4 sản phẩm)
    (42, N'Áo Polo MLB Monogram', 1, 3, N'Polo MLB', 'https://bizweb.dktcdn.net/100/397/400/products/4-5-b73e0da8-2efd-4fa5-8ba6-611bdac58c8e.jpg?v=1662438941547', 2, 1),
    (43, N'T-Shirt MLB BigLogo', 2, 3, N'Áo thun MLB', 'https://bizweb.dktcdn.net/100/446/974/products/ao-mlb-classic-monogram-big-logo-short-sleeve-t-shirt-new-york-yankees-black-3atsm0233-50bks-3.jpg?v=1686635060437', 2, 1),
    (44, N'Quần MLB Sport', 3, 3, N'Quần MLB', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/10/quan-jogger-mlb-classic-sports-logo-jogger-pants-la-dodgers-3fptg0134-07nys-mau-xanh-navy-652e5465a27ea-17102023163117.jpg', 2, 1),
    (45, N'Áo Khoác MLB Varsity', 4, 3, N'Áo khoác MLB', 'https://cdn.vuahanghieu.com/unsafe/0x900/left/top/smart/filters:quality(90)/https://admin.vuahanghieu.com/upload/product/2023/10/ao-bomber-mlb-wool-basic-varsity-jacket-new-york-yankees-3ajpv0634-50bkl-mau-den-652de78bbbe8d-17102023084651.jpg', 2, 1);
SET IDENTITY_INSERT dbo.SanPham OFF;
GO


-- 3. Chèn Biến Thể Sản Phẩm (SKU)

SET IDENTITY_INSERT dbo.SanPhamChiTiet ON;
INSERT INTO SanPhamChiTiet (MaBienThe, MaSP, MaSize, MaMau, GiaBan, GiaNhap, SoLuongTon, AnhBienThe) VALUES
    (1, 1, 1, 1, 15000000, 8000000, 20, N'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1645054205/658077_XJDIJ_1082_001_100_0000_Light.jpg'),
    (2, 1, 2, 1, 15000000, 8000000, 25, N'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1645054205/658077_XJDIJ_1082_001_100_0000_Light.jpg'),
    (3, 1, 3, 2, 15000000, 8000000, 25, N'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1685372400/745249_XJF4M_9037_001_100_0000_Light.jpg'),
    (4, 1, 4, 2, 15000000, 8000000, 10, N'https://media.gucci.com/style/DarkGray_Center_0_0_800x800/1685372400/745249_XJF4M_9037_001_100_0000_Light.jpg'),
    (5, 2, 1, 1, 12000000, 6000000, 20, NULL),
    (6, 2, 2, 1, 12000000, 6000000, 25, NULL),
    (7, 2, 3, 2, 12000000, 6000000, 10, NULL),
    (8, 2, 4, 2, 12000000, 6000000, 5, NULL),
    (9, 3, 1, 1, 18000000, 9000000, 10, NULL),
    (10, 3, 2, 1, 18000000, 9000000, 12, NULL),
    (11, 3, 3, 1, 18000000, 9000000, 8, NULL),
    (12, 3, 4, 1, 18000000, 9000000, 5, NULL),
    (13, 4, 1, 3, 35000000, 20000000, 6, NULL),
    (14, 4, 2, 3, 35000000, 20000000, 5, NULL),
    (15, 4, 3, 3, 35000000, 20000000, 4, NULL),
    (16, 4, 4, 3, 35000000, 20000000, 3, NULL),
    (17, 5, 1, 2, 10000000, 6000000, 14, NULL),
    (18, 5, 2, 2, 10000000, 6000000, 23, NULL),
    (19, 5, 3, 2, 10000000, 6000000, 13, NULL),
    (20, 5, 4, 2, 10000000, 6000000, 24, NULL),
    (21, 6, 1, 1, 10000000, 6000000, 17, NULL),
    (22, 6, 2, 1, 10000000, 6000000, 19, NULL),
    (23, 6, 3, 1, 10000000, 6000000, 29, NULL),
    (24, 6, 4, 1, 10000000, 6000000, 17, NULL),
    (25, 7, 1, 2, 18000000, 10800000, 9, NULL),
    (26, 7, 2, 2, 18000000, 10800000, 29, NULL),
    (27, 7, 3, 2, 18000000, 10800000, 17, NULL),
    (28, 7, 4, 2, 18000000, 10800000, 8, NULL),
    (29, 8, 1, 1, 18000000, 10800000, 29, NULL),
    (30, 8, 2, 1, 18000000, 10800000, 8, NULL),
    (31, 8, 3, 1, 18000000, 10800000, 26, NULL),
    (32, 8, 4, 1, 18000000, 10800000, 18, NULL),
    (33, 9, 1, 2, 18000000, 10800000, 11, NULL),
    (34, 9, 2, 2, 18000000, 10800000, 8, NULL),
    (35, 9, 3, 2, 18000000, 10800000, 21, NULL),
    (36, 9, 4, 2, 18000000, 10800000, 5, NULL),
    (37, 10, 1, 1, 35000000, 21000000, 10, NULL),
    (38, 10, 2, 1, 35000000, 21000000, 28, NULL),
    (39, 10, 3, 1, 35000000, 21000000, 13, NULL),
    (40, 10, 4, 1, 35000000, 21000000, 9, NULL),
    (41, 11, 1, 2, 35000000, 21000000, 30, NULL),
    (42, 11, 2, 2, 35000000, 21000000, 27, NULL),
    (43, 11, 3, 2, 35000000, 21000000, 26, NULL),
    (44, 11, 4, 2, 35000000, 21000000, 8, NULL),
    (45, 12, 1, 1, 35000000, 21000000, 29, NULL),
    (46, 12, 2, 1, 35000000, 21000000, 30, NULL),
    (47, 12, 3, 1, 35000000, 21000000, 18, NULL),
    (48, 12, 4, 1, 35000000, 21000000, 5, NULL),
    (49, 13, 1, 2, 12000000, 7200000, 20, NULL),
    (50, 13, 2, 2, 12000000, 7200000, 19, NULL),
    (51, 13, 3, 2, 12000000, 7200000, 6, NULL),
    (52, 13, 4, 2, 12000000, 7200000, 22, NULL),
    (53, 14, 1, 1, 12000000, 7200000, 10, NULL),
    (54, 14, 2, 1, 12000000, 7200000, 9, NULL),
    (55, 14, 3, 1, 12000000, 7200000, 29, NULL),
    (56, 14, 4, 1, 12000000, 7200000, 21, NULL),
    (57, 15, 1, 2, 12000000, 7200000, 25, NULL),
    (58, 15, 2, 2, 12000000, 7200000, 25, NULL),
    (59, 15, 3, 2, 12000000, 7200000, 7, NULL),
    (60, 15, 4, 2, 12000000, 7200000, 9, NULL),
    (61, 16, 1, 1, 14000000, 8400000, 28, NULL),
    (62, 16, 2, 1, 14000000, 8400000, 12, NULL),
    (63, 16, 3, 1, 14000000, 8400000, 5, NULL),
    (64, 16, 4, 1, 14000000, 8400000, 26, NULL),
    (65, 17, 1, 2, 14000000, 8400000, 13, NULL),
    (66, 17, 2, 2, 14000000, 8400000, 10, NULL),
    (67, 17, 3, 2, 14000000, 8400000, 15, NULL),
    (68, 17, 4, 2, 14000000, 8400000, 17, NULL),
    (69, 18, 1, 1, 14000000, 8400000, 20, NULL),
    (70, 18, 2, 1, 14000000, 8400000, 9, NULL),
    (71, 18, 3, 1, 14000000, 8400000, 6, NULL),
    (72, 18, 4, 1, 14000000, 8400000, 24, NULL),
    (73, 19, 1, 2, 20000000, 12000000, 15, NULL),
    (74, 19, 2, 2, 20000000, 12000000, 14, NULL),
    (75, 19, 3, 2, 20000000, 12000000, 15, NULL),
    (76, 19, 4, 2, 20000000, 12000000, 20, NULL),
    (77, 20, 1, 1, 20000000, 12000000, 28, NULL),
    (78, 20, 2, 1, 20000000, 12000000, 18, NULL),
    (79, 20, 3, 1, 20000000, 12000000, 15, NULL),
    (80, 20, 4, 1, 20000000, 12000000, 11, NULL),
    (81, 21, 1, 2, 20000000, 12000000, 12, NULL),
    (82, 21, 2, 2, 20000000, 12000000, 9, NULL),
    (83, 21, 3, 2, 20000000, 12000000, 7, NULL),
    (84, 21, 4, 2, 20000000, 12000000, 9, NULL),
    (85, 22, 1, 1, 15000000, 9000000, 24, NULL),
    (86, 22, 2, 1, 15000000, 9000000, 27, NULL),
    (87, 22, 3, 1, 15000000, 9000000, 30, NULL),
    (88, 22, 4, 1, 15000000, 9000000, 19, NULL),
    (89, 23, 1, 2, 15000000, 9000000, 25, NULL),
    (90, 23, 2, 2, 15000000, 9000000, 24, NULL),
    (91, 23, 3, 2, 15000000, 9000000, 12, NULL),
    (92, 23, 4, 2, 15000000, 9000000, 20, NULL),
    (93, 24, 1, 1, 15000000, 9000000, 29, NULL),
    (94, 24, 2, 1, 15000000, 9000000, 24, NULL),
    (95, 24, 3, 1, 15000000, 9000000, 27, NULL),
    (96, 24, 4, 1, 15000000, 9000000, 13, NULL),
    (97, 25, 1, 2, 15000000, 9000000, 15, NULL),
    (98, 25, 2, 2, 15000000, 9000000, 24, NULL),
    (99, 25, 3, 2, 15000000, 9000000, 18, NULL),
    (100, 25, 4, 2, 15000000, 9000000, 11, NULL),
    (101, 26, 1, 1, 15000000, 9000000, 18, NULL),
    (102, 26, 2, 1, 15000000, 9000000, 29, NULL),
    (103, 26, 3, 1, 15000000, 9000000, 23, NULL),
    (104, 26, 4, 1, 15000000, 9000000, 27, NULL),
    (105, 27, 1, 2, 15000000, 9000000, 10, NULL),
    (106, 27, 2, 2, 15000000, 9000000, 15, NULL),
    (107, 27, 3, 2, 15000000, 9000000, 21, NULL),
    (108, 27, 4, 2, 15000000, 9000000, 26, NULL),
    (109, 28, 1, 1, 15000000, 9000000, 25, NULL),
    (110, 28, 2, 1, 15000000, 9000000, 8, NULL),
    (111, 28, 3, 1, 15000000, 9000000, 19, NULL),
    (112, 28, 4, 1, 15000000, 9000000, 30, NULL),
    (113, 29, 1, 2, 15000000, 9000000, 13, NULL),
    (114, 29, 2, 2, 15000000, 9000000, 8, NULL),
    (115, 29, 3, 2, 15000000, 9000000, 23, NULL),
    (116, 29, 4, 2, 15000000, 9000000, 6, NULL),
    (117, 30, 1, 1, 15000000, 9000000, 5, NULL),
    (118, 30, 2, 1, 15000000, 9000000, 19, NULL),
    (119, 30, 3, 1, 15000000, 9000000, 19, NULL),
    (120, 30, 4, 1, 15000000, 9000000, 20, NULL),
    (121, 31, 1, 2, 15000000, 9000000, 15, NULL),
    (122, 31, 2, 2, 15000000, 9000000, 10, NULL),
    (123, 31, 3, 2, 15000000, 9000000, 16, NULL),
    (124, 31, 4, 2, 15000000, 9000000, 23, NULL),
    (125, 32, 1, 1, 15000000, 9000000, 6, NULL),
    (126, 32, 2, 1, 15000000, 9000000, 21, NULL),
    (127, 32, 3, 1, 15000000, 9000000, 17, NULL),
    (128, 32, 4, 1, 15000000, 9000000, 20, NULL),
    (129, 33, 1, 2, 15000000, 9000000, 25, NULL),
    (130, 33, 2, 2, 15000000, 9000000, 5, NULL),
    (131, 33, 3, 2, 15000000, 9000000, 19, NULL),
    (132, 33, 4, 2, 15000000, 9000000, 20, NULL),
    (133, 34, 1, 1, 15000000, 9000000, 11, NULL),
    (134, 34, 2, 1, 15000000, 9000000, 5, NULL),
    (135, 34, 3, 1, 15000000, 9000000, 15, NULL),
    (136, 34, 4, 1, 15000000, 9000000, 18, NULL),
    (137, 35, 1, 2, 15000000, 9000000, 30, NULL),
    (138, 35, 2, 2, 15000000, 9000000, 21, NULL),
    (139, 35, 3, 2, 15000000, 9000000, 27, NULL),
    (140, 35, 4, 2, 15000000, 9000000, 7, NULL),
    (141, 36, 1, 1, 15000000, 9000000, 8, NULL),
    (142, 36, 2, 1, 15000000, 9000000, 10, NULL),
    (143, 36, 3, 1, 15000000, 9000000, 21, NULL),
    (144, 36, 4, 1, 15000000, 9000000, 10, NULL),
    (145, 37, 1, 2, 15000000, 9000000, 15, NULL),
    (146, 37, 2, 2, 15000000, 9000000, 9, NULL),
    (147, 37, 3, 2, 15000000, 9000000, 27, NULL),
    (148, 37, 4, 2, 15000000, 9000000, 11, NULL),
    (149, 38, 1, 1, 15000000, 9000000, 26, NULL),
    (150, 38, 2, 1, 15000000, 9000000, 23, NULL),
    (151, 38, 3, 1, 15000000, 9000000, 19, NULL),
    (152, 38, 4, 1, 15000000, 9000000, 26, NULL),
    (153, 39, 1, 2, 15000000, 9000000, 26, NULL),
    (154, 39, 2, 2, 15000000, 9000000, 9, NULL),
    (155, 39, 3, 2, 15000000, 9000000, 15, NULL),
    (156, 39, 4, 2, 15000000, 9000000, 23, NULL),
    (157, 40, 1, 1, 15000000, 9000000, 22, NULL),
    (158, 40, 2, 1, 15000000, 9000000, 26, NULL),
    (159, 40, 3, 1, 15000000, 9000000, 9, NULL),
    (160, 40, 4, 1, 15000000, 9000000, 28, NULL),
    (161, 41, 1, 2, 15000000, 9000000, 27, NULL),
    (162, 41, 2, 2, 15000000, 9000000, 16, NULL),
    (163, 41, 3, 2, 15000000, 9000000, 11, NULL),
    (164, 41, 4, 2, 15000000, 9000000, 23, NULL),
    (165, 42, 1, 1, 3500000, 2100000, 16, NULL),
    (166, 42, 2, 1, 3500000, 2100000, 29, NULL),
    (167, 42, 3, 1, 3500000, 2100000, 23, NULL),
    (168, 42, 4, 1, 3500000, 2100000, 9, NULL),
    (169, 43, 1, 2, 3500000, 2100000, 17, NULL),
    (170, 43, 2, 2, 3500000, 2100000, 13, NULL),
    (171, 43, 3, 2, 3500000, 2100000, 10, NULL),
    (172, 43, 4, 2, 3500000, 2100000, 26, NULL),
    (173, 44, 1, 1, 3500000, 2100000, 28, NULL),
    (174, 44, 2, 1, 3500000, 2100000, 19, NULL),
    (175, 44, 3, 1, 3500000, 2100000, 10, NULL),
    (176, 44, 4, 1, 3500000, 2100000, 12, NULL),
    (177, 45, 1, 2, 3500000, 2100000, 20, NULL),
    (178, 45, 2, 2, 3500000, 2100000, 21, NULL),
    (179, 45, 3, 2, 3500000, 2100000, 7, NULL),
    (180, 45, 4, 2, 3500000, 2100000, 22, NULL);
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
    (3, 1, N'Admin', '0900000001', N'123 Đường Admin, Q1, TP.HCM', N'Văn phòng công ty', 1);
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

GO
-- ✅ KẾT THÚC SCRIPT (TOÀN BỘ LOGIC VOUCHER CHUYÊN NGHIỆP ĐÃ ĐƯỢC ĐƯA LÊN PHẦN ĐẦU)
