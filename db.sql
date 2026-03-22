
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
    (1, 1, 1, N'Bộ sưu tập Thu-Đông 2025 từ Gucci', N'Gucci vừa cho ra mắt bộ sưu tập Thu-Đông 2025, kết hợp giữa di sản cổ điển và cảm hứng đương đại. Các thiết kế nổi bật với chất liệu cao cấp và họa tiết monogram đặc trưng.', 'https://media.gucci.com/content/DiaryArticleSingle_Standard_1600x1600/1695222013/DiaryArticleSingle_gucci-ancora-fashion-show-2023-01_001_Default.jpg', 1, 'bo-suu-tap-thu-dong-2025-tu-gucci'),
    (2, 1, 1,N'Đây là kho?nh kh?c mà nh?ng ngư?i hâm m? th?i trang trên kh?p th? gi?i ch? đ?i: B? sưu t?p ra m?t c?a Demna cho Gucci', N'Bu?i ra m?t di?n ra vào th? Sáu t?i trung tâm Milan, trong Palazzo delle Scintille, m?t công tr?nh kính theo phong cách art nouveau cu?i th?i k? này đư?c xây d?ng vào năm 1923. G?n 1.000 khách m?i đ? đ?n tham d?. Paris Hilton và em gái Nicky Rothschild có m?t cùng ngôi sao K-pop Lee Know. Donatella Versace ng?i hàng gh? đ?u. Alessandro Michele, c?u giám đ?c sáng t?o t?ng t?o nên th?i k? huy hoàng cho Gucci, c?ng có m?t đ? ?ng h? giai đo?n m?i c?a thương hi?u. Sàn di?n đư?c dàn d?ng như m?t b?o tàng ? thu nh? v?i nh?ng b?c tư?ng th?i La M?, g?i nh?c v? ngu?n g?c c?a h?ng.  Trên sàn di?n đó, b? sưu t?p g?m 83 thi?t k? dành cho c? nam và n?. Các ngư?i m?u n? s?i bư?c v?i giày cao gót nh?n, qu?n legging c?p th?p, váy mini, t?t in h?a ti?t hai ch? G, cùng áo khoác gi? lông ho?c áo khoác bomber. Ngư?i m?u nam phô di?n cơ b?ng dư?i l?p áo bó sát, k?t h?p áo khoác biker và nh?ng đôi giày da đ? ho?c tr?ng c? l?n. M?t s? ngư?i đeo túi đeo chéo Gucci v?n r?t đư?c ưa chu?ng. Kate Moss khép l?i bu?i tr?nh di?n trong chi?c váy d? h?i đen l?p lánh h? lưng, đ? l? ph?n dây n?i y v?i bi?u tư?ng hai ch? G m? vàng.  “Bu?i ra m?t c?a Demna t?i Gucci là bu?i di?n đư?c soi xét k? càng nh?t trong mùa này,” Gaya Guiragossian, giám đ?c phong cách và ngh? thu?t c?a n?n t?ng bán l?i hàng xa x? Vestiaire Collective nh?n xét. “B? sưu t?p g?i l?i th?i k? hào nhoáng c?a Tom Ford trong th?p niên 1990, t? l?p trang đi?m m?t khói, áo sơ mi l?a cho t?i các ch?t li?u th?t bóng b?y.”  B? sưu t?p Thu Đông 2026-2027 ra m?t trong b?i c?nh ngành xa x? tr?i qua m?t năm nhi?u bi?n đ?ng nhân s? t?i các nhà m?t l?n. Ngành này c?ng đang t?m cách ph?c h?i sau giai đo?n nhu c?u suy y?u. Theo ư?c tính c?a Bain, kho?ng 50 tri?u khách hàng đ? r?i b? th? trư?ng sau cơn bùng n? h?u đ?i d?ch. Giá bán b? đ?y lên quá cao khi?n nhi?u ngư?i mua c?m th?y th?t v?ng v?i các thương hi?u cao c?p, trong khi s?c h?p d?n c?a s?n ph?m c?ng gi?m sút.  Trong b?i c?nh đó, Demna, ngư?i n?i ti?ng v?i phong cách gây tranh c?i và hi?n không c?n s? d?ng h? Gvasalia, t?ng đư?c xem là m?t l?a ch?n vô cùng m?o hi?m v?i Gucci. Thương hi?u ? danh ti?ng này đư?c thành l?p t?i Florence năm 1921 và hi?n thu?c t?p đoàn xa x? Pháp Kering. Demna gi? vai tr? giám đ?c sáng t?o c?a Balenciaga, m?t thương hi?u khác thu?c Kering, trong su?t m?t th?p niên cho đ?n tháng B?y năm ngoái. Qu?ng th?i gian đó c?ng không thi?u tranh c?i. Năm 2022, m?t chi?n d?ch qu?ng cáo b? ch? trích v? g?i y?u t? t?nh d?c hóa tr? em đ? gây nên làn sóng ph?n n? d? d?i, bu?c Balenciaga và nhà thi?t k? sinh ra t?i Georgia ph?i công khai xin l?i.  Dù v?y, dư?i th?i Demna, Balenciaga c?ng tung ra nhi?u thi?t k? gây s?t trên m?ng x? h?i, như đôi sneaker Triple S do ông cùng nhà thi?t k? David Tourniaire-Beauciel tham gia thi?t k?. Nh?ng s?n ph?m này thu hút th? h? khách hàng tr?, khi?n nhi?u ngư?i b?t đ?u g?n li?n Balenciaga v?i phong cách streetwear, đ?ng th?i mang l?i thành công thương m?i cho thương hi?u. Kering không công b? doanh thu riêng c?a Balenciaga, nhưng theo ư?c tính c?a nhà phân tích Luca Solca t?i Bernstein, doanh s? h?ng vào năm 2022 có th? đ?t đ?nh kho?ng 2,3 t? euro, tương đương 2,7 t? USD.  Demna c?ng h?i sinh d?ng haute couture c?a Balenciaga, phân khúc ph?c v? nh?ng khách hàng c?n váy d? h?i cho các b?a ti?c t? thi?n ho?c th?m đ?. Đi?u này cho th?y tay ngh? c?a ông v?i tư cách m?t nhà thi?t k? couture th?c th?. Ông v?n đưa vào đó nh?ng chi ti?t l?p d?, như chi?c váy giáp làm t? nh?a resin m? chrome, khi?n c?ng đ?ng ngư?i hâm m? bàn tán sôi n?i trên Instagram.  S? ph?c h?i c?a Gucci có ? ngh?a r?t l?n đ?i v?i toàn b? h? sinh thái th?i trang. Gucci hi?n là thương hi?u bán ch?y nh?t trên Vestiaire Collective. Theo Guiragossian, lư?t t?m ki?m túi Jackie đ? tăng m?nh sau khi Demna tung ra b? sưu t?p gi?i h?n tên La Famiglia g?m 37 thi?t k? vào tháng 9. M?u túi ra m?t năm 1961 và t?ng là món đ? yêu thích c?a Jackie Onassis. B? sưu t?p La Famiglia mang tinh th?n Gucci truy?n th?ng hơn v?i các h?a ti?t hoa, trong khi b? sưu t?p tr?nh di?n hôm th? Sáu có phong cách s?c s?o hơn và th? hi?n r? d?u ?n c?a Demna.  “Trong vài tháng t?i, th? trư?ng s? cho th?y li?u các thi?t k? m?i c?a Demna có thu hút thêm s? quan tâm trên n?n t?ng c?a chúng tôi hay không, ho?c li?u làn sóng hoài ni?m này có khi?n ngư?i mua quay l?i v?i Gucci th?i Tom Ford không,” Guiragossian nói.  Nh?n l?i l?ch s? c?a thương hi?u, gi?a th?p niên 1990 phong cách g?i c?m c?a Tom Ford đ? đưa Gucci tr? thành tâm đi?m c?a làng m?t. Hai th?p niên sau, Alessandro Michele m? ra giai đo?n bohemian r?c r? t? năm 2015 đ?n 2022. Phong cách táo b?o c?a ông, tiêu bi?u là đôi mule lông Princetown, giúp doanh thu h?ng năm c?a Gucci vư?t m?c 10 t? euro trong năm cu?i cùng ông gi? vai tr? giám đ?c sáng t?o. Nhưng sau đó doanh s? c?a thương hi?u đ? s?t gi?m hơn 40%.  “Thành công c?a Gucci dư?i th?i Michele th?t choáng ng?p, nhưng cú lao d?c sau đó c?n choáng ng?p hơn. Đi?u này cho th?y th? hi?u c?a ngư?i tiêu dùng th?i trang bi?n đ?ng r?t nhanh,” Serge Carreira, giáo sư liên k?t v? th?i trang và xa x? t?i Sciences Po ? Paris, nh?n đ?nh. “V? v?y, nhi?u ngư?i k? v?ng thương hi?u s? s?m tr? l?i th?i k? hoàng kim, b?i đây là nh?n hàng ch? l?c c?a m?t trong nh?ng t?p đoàn xa x? l?n nh?t th? gi?i.” Ngoài Gucci, Kering c?n s? h?u Yves Saint Laurent và Bottega Veneta.  Li?u Gucci có th? ph?c h?i không? “Ngu?n g?c gia đ?nh t?i ?, tay ngh? ch? tác đ? da và giày cùng l?ch s? hơn m?t th? k? là nh?ng l?i th? đ?c bi?t mà thương hi?u có th? khai thác,” Alix Morabito, giám đ?c mua hàng toàn c?u c?a t?p đoàn bách hóa Pháp Galeries Lafayette, nh?n đ?nh.  Sau bu?i tr?nh di?n, t?ng giám đ?c Kering Luca de Meo không b?nh lu?n v? ngu?n c?m h?ng sáng t?o c?a b? sưu t?p, nhưng ông ca ng?i s? đa d?ng c?a các d?ng s?n ph?m. “Chúng tôi đang b?t đ?u m?t hành tr?nh m?i và m?i th? dư?ng như đang đi đúng hư?ng,” ông nói.  Theo Yann Kretz, đ?i tác c?p cao t?i công ty tư v?n Kéa, ch?a khóa thành công n?m ? vi?c Gucci ph?i t?o ra các món ph? ki?n đ? h?p d?n đ? thu hút khách hàng tr? tu?i. “Ph? ki?n chi?m ph?n l?n doanh thu,” ông nói, nh?c đ?n th?t lưng, giày và các m?u túi “it bag”. Nh?ng đôi mule n?i ti?ng xu?t hi?n thư?ng xuyên trong b? sưu t?p hôm th? Sáu và đư?c ngư?i m?u nam mang trên sàn di?n.  Thông thư?ng, ph?i m?t kho?ng n?a năm đ? các thi?t k? trên sàn di?n đư?c đưa ra th? trư?ng. Tuy nhiên, ngay t? hôm th? Sáu, ngư?i mua đ? có th? đ?t m?t s? ph? ki?n m?i c?a b? sưu t?p này tr?c tuy?n ho?c t?i m?t s? c?a hàng.  M?t ngày trư?c bu?i tr?nh di?n, c?a hàng flagship c?a Gucci trên ph? Via Monte Napoleone đ? ch?t kín khách VIC. Đây là nh?ng “very important customers” đ?n ch?n trang ph?c cho s? ki?n t?i khu mua s?m xa x? b?c nh?t trung tâm Milan.  Nhưng bên ngoài c?a hàng c?n có m?t nhóm thi?u n? tu?i teen, có ngư?i ?, có ngư?i đ?n t? các nư?c khác. H? đ?c trên m?ng x? h?i r?ng Lee Know, đ?i s? thương hi?u, s? xu?t hi?n.  Giulia Amerio, 17 tu?i, đ? ch? ngôi sao này su?t hơn 30 phút. Cô bi?t Demna chu?n b? ra m?t b? sưu t?p đ?u tiên và khá t? m? v? nó, nhưng nói r?ng m?nh ch? s? h?u m?t chai nư?c hoa Gucci. “Tôi r?t thích thương hi?u này,” cô nói. “Nhưng s? xu?t hi?n c?a ngôi sao K-pop khi?n m?i th? tr? nên thú v? hơn.', 'https://static.bbw.vn/img/bbw/gucci-he-lo-bo-suu-tap-moi-nhat-tai-milan-hinh-anh-monic-1050x700.webp', 1,  'gucci-ra-mat-bo-suu-tap-moi'),
    (4, 1, 1,N'L?y b?i c?nh bàn ti?c ?m cúng, chi?n d?ch "The Gathering" c?a Gucci ghi l?i kho?nh kh?c sum v?y c?a dàn sao đ?nh đám Nghê Ni, T?ng Uy Long và v? ch?ng Mai Davika.', N'Gucci v?a chính th?c tr?nh làng chi?n d?ch qu?ng bá m?i mang tên “The Gathering”. V?i s? góp m?t c?a dàn đ?i s? đ?nh đám g?m Nghê Ni, T?ng Uy Long và c?p đôi Davika Hoorne – Chantavit Dhanasevi, chi?n d?ch không ch? là l?i chào sân cho b? sưu t?p “Gucci: La Famiglia” mà c?n là thư?c phim đ?y c?m xúc v? s? g?n k?t gi?a nh?ng tâm h?n đ?ng đi?u.   Tâm đi?m c?a chi?n d?ch “The Gathering” chính là s? h?i t? c?a nh?ng tên tu?i hàng đ?u làng gi?i trí Châu Á như Đ?i s? thương hi?u Davika Hoorne cùng ch?ng là Chantavit Dhanasevi. Vi?c đưa m?t c?p đôi th?c th? vào khung h?nh đ? giúp Gucci truy?n t?i tr?n v?n s? ?m áp, chân th?c c?a t?nh thân – giá tr? c?t l?i mà chi?n d?ch này hư?ng t?i.   S? xu?t hi?n c?a Đ?i s? toàn c?u Nghê Ni m?t l?n n?a kh?ng đ?nh m?i nhân duyên b?n ch?t gi?a cô và nhà m?t. Trong các thi?t k? m?i nh?t, Nghê Ni toát lên v? sang tr?ng, đi?m t?nh nhưng đ?y s?c hút.   Đ?ng hành cùng cô là Đ?i s? thương hi?u T?ng Uy Long, nam di?n viên mang v? đ?p l?ch l?m, tr? trung, đ?i di?n cho th? h? m?i đ?y năng lư?ng.   L?y ch? đ? t?nh thân làm đi?m t?a, “The Gathering” (t?m d?ch: S? sum v?y)  tôn vinh c?m giác thu?c v? đư?c h?nh thành gi?a nh?ng ngư?i thân thi?t nh?t, nh?ng ngư?i luôn bên c?nh và khi?n trái tim ta c?m th?y đư?c an ?i. Lo?t h?nh ?nh c?a chi?n d?ch đ?t t?ng cá nhân trong m?i tương quan v?i t?p th?. ? đó, các nhân v?t không đ?ng riêng l? mà h?a m?nh vào m?t c?ng đ?ng nh?. Trong kho?nh kh?c quây qu?n quanh bàn ti?c, s? hi?n di?n c?a m?i thành viên tr? thành m?t m?nh ghép không th? thi?u, ph?n chi?u nh?ng cách k?t n?i đa d?ng và đa s?c thái c?a cu?c s?ng đương đ?i.    Xuyên su?t chi?n d?ch, dàn ngôi sao khoác lên m?nh nh?ng thi?t k? n?m trong b? sưu t?p “Gucci: La Famiglia”. Đây là b? sưu t?p mang d?u ?n sâu s?c v? s? g?n k?t, ? đó tính th? công tinh x?o c?a nhà m?t g?p g? nh?ng giá tr? nhân văn.   Dư?i s? d?n d?t c?a ngôn ng? h?nh ?nh giàu c?m xúc, Gucci ti?p t?c hành tr?nh khám phá chi?u sâu c?a s? k?t n?i con ngư?i. Chi?n d?ch ghi l?i nh?ng kho?nh kh?c gi?n đơn nhưng đ?t giá khi con ngư?i t?m đ?n nhau đ? s? chia, đ? đ?ng hành và đ? m?i đi?u di?n ra trong cu?c s?ng tr? nên th?t s? ? ngh?a.', 'https://static.elle.vn/img/_qehjJQbT3DNvd1OT-uAPteH6fsfnYUzdTNva2pdrxw/rs:fit:0:0/min-height:300/plain/http://www.elle.vn/app/uploads/2026/01/21/731579/gucci-the-gathering-3.jpg@webp', 0,  'V? ch?ng Davika Hoorne và dàn sao châu Á h?i ng? trong chi?n d?ch “The Gathering” c?a Gucci'),
    (5, 1, 1,N'Thương hi?u MLB chính th?c chào đón c?a hàng đ?u tiên t?i TP.HCM v?i s? góp m?t c?a đông đ?o gi?i m? đi?u. Đây là thương hi?u đư?c gi?i tr? kh?p Châu Á yêu m?n, và chưa h? có d?u hi?u h? nhi?t khi đ?t chân t?i Vi?t Nam.', N'Xu?t x? t? Hàn Qu?c, đư?c truy?n c?m h?ng b?i b? môn bóng chày, các thi?t k? c?a MLB mang đ?m tinh th?n th? thao đư?ng ph? và có tính ?ng d?ng cao. S? k?t h?p gi?a bóng chày và th?i trang đ? t?o ra làn sóng trào lưu m?i. MLB đem đ?n các b? sưu t?p v? trang ph?c và ph? ki?n cho nam, n? qua các s?n ph?m đ?c trưng như áo phông oversize, m? lư?i trai, hay nh?ng đôi chunky sneakers đ?m ch?t đư?ng ph? v?i logo c?a 4 đ?i bóng chày danh ti?ng. Các bi?u tư?ng đ?c trưng c?a thương hi?u như New York Yankees, LA Dodgers, Boston Red Sox và St. Louis Cardinals không c?n đơn thu?n là logo m?t đ?i bóng, đó là văn hóa và th?i trang.   S? ki?n khai trương MLB Vi?t Nam đ? di?n ra vào 6/11/2019 v?i nhi?u ho?t đ?ng thú v?, ph?n tr?nh di?n thu hút t? ca s? Orange, cùng v? đi?u sôi đ?ng c?a v? đoàn & DJ c?c ch?t. T?i s? ki?n c?n quy t? dàn khách m?i n?i ti?ng như: ca s? Osad, fashionista Decao, Lou Hoàng, Phí Phương Anh, Tú H?o, Qu?nh Anh Shyn, Đ?ng Ánh Qu?nh, Bùi Linh Chi cùng nh?ng stylist có ti?ng trong làng th?i trang Vi?t như Kye Nguy?n, Ph?m B?o Lu?n, Duy Plue…T?t c? đ? mang đ?n m?t bu?i t?i đáng nh? cho ngư?i tham d?. MLB Vincom Lê Thánh Tôn h?a h?n là đi?m mua s?m l? tư?ng cho các tín đ? th?i trang. Công ty Maison t? hào là đơn v? phân ph?i đ?c quy?n thương hi?u MLB t?i Vi?t Nam.    MLB là tên vi?t t?t c?a Major League Baseball – t? ch?c th? thao chuyên nghi?p c?a môn bóng chày và luôn đư?c s? quan tâm l?n c?a h?u h?t fan bóng chày trên toàn th? gi?i. Thương hi?u MLB thu?c t?p đoàn F&F, c?a hàng MLB Korea đ?u tiên đư?c m? vào năm 1997. Cho đ?n nay, MLB đ? có 250 c?a hàng t?i kh?p khu v?c Châu Á như Hàn Qu?c, HongKong, Ma Cao, Đài Loan và Trung Qu?c và Vi?t Nam. Thương hi?u chuyên thi?t k? và s?n xu?t trang ph?c, giày & ph? ki?n l?y c?m h?ng t? logo c?a nh?ng đ?i bóng chày danh ti?ng.', 'https://www.elle.vn/wp-content/uploads/2019/11/08/379362/Hinh-store-main.jpg', 1,  'MLB hoàng tráng ra m?t c?a hàng d?u tiên t?i Vi?t Nam'),
    (6, 1, 1,N'AESPA r?t có duyên v?i các gi?i bóng chày khi liên t?c bi?u di?n t?i các bu?i thi đ?u c?a b? môn này', N'Tr?c thu?c nhà SM Entertainment nhưng ngay t? khi ra m?t, aespa đ? không ch?n concept n? tính, đáng yêu thư?ng th?y ? các nhóm nh?c n? c?a công ty gi?i trí này. Thay vào đó, công ty xây d?ng cho nhóm concept th?c t? ?o, k?t h?p công ngh? AI và s? cá tính v? lai. V? ngoài năng đ?ng c?a aespa c?ng vô cùng tương đ?ng v?i th? lo?i âm nh?c có ph?n sôi n?i mà nhóm theo đu?i. V?y nên không quá khó hi?u khi th?i gian v?a qua, các gi?i đ?u th? thao liên t?c l?a ch?n aespa tham gia s? ki?n, đ?c bi?t là các gi?i đ?u bóng chày.  Sau cơ h?i đ?n M? ném bóng m? màn cho đ?i bóng chày New York Yankees. M?i đây, aespa ti?p t?c “bén duyên” v?i m?t s? ki?n bóng chày vô cùng quan tr?ng t?i quê hương Hàn Qu?c.  aespa khu?y đ?ng gi?i đ?u MLB World Tour Seoul Series 2024 b?ng lo?t hit đ?nh đám  Gi?i bóng chày Major League (MLB) là gi?i bóng chày nhà ngh? M? lâu đ?i nh?t. M?i mùa gi?i b?t đ?u v?i gi?i mùa xuân và mùa gi?i năm nay đ? chính th?c di?n ra v?i tên g?i MLB World Tour Seoul Series 2024. B?i đây là l?n tiên MLB t? ch?c thi đ?u ? Hàn Qu?c.  Ngày 20/03 v?a qua, tr?n khai m?c gi?a Los Angeles Dodgers và San Diego Padre đ? chính th?c di?n ra t?i sân v?n đ?ng Gocheok Sky Dome, Seoul. V?i nhi?u ngư?i dân Hàn Qu?c, dù không ph?i là fan c?a môn th? thao này, s? ki?n này v?n là m?t ni?m t? hào v? nhi?u c?u th? bóng chày n?i ti?ng x? này hi?n đang chơi cho đ?i Los Angeles Dodgers.  Chính v? v?y, vi?c aespa xác nh?n bi?u di?n t?i tr?n khai m?c MLB World Tour Seoul Series 2024 đ? đánh d?u m?t c?t m?c quan tr?ng trong s? nghi?p c?a h?. Không làm ngư?i hâm m? th?t v?ng, 4 thành viên nhà SM dư?ng như đ? bi?n tr?n m? màn mùa gi?a Los Angeles Dodgers và San Diego Padre trông gi?ng Super Bowl v?i nh?ng ti?t m?c không th? bùng n? hơn.  Nhóm nh?c n? nhà SM đ? ch?n 2 bài hát n?i ti?ng v?i giai đi?u sôi đ?ng là Drama và Next Level đ? có th? khoe tr?n v? đ?o điêu luy?n c?a m?nh. Đám đông dư?i khán đài đáp tr? năng lư?ng c?a nhóm khi dành cho b?n cô gái nhi?u tràn h? reo c? v?.  Có th? th?y, n?u nhi?m v? c?a aespa là khu?y đ?ng không khí m?t tr?n đ?u th? thao th? h? đ? hoàn toàn thành công và bi?n sân v?n đ?ng Gocheok Sky Dome thành m?t l? h?i âm nh?c.  Đây không ph?i là l?n đ?u tiên aespa gây ti?ng vang trong th? gi?i th? thao. Vào tháng Sáu năm ngoái, nhóm c?ng gây chú ? khi h? đ?n sân v?n đ?ng Yankee ? New York đ? ném cú ném đ?u tiên trong tr?n đ?u gi?a New York Yankees và Chicago White Sox. Các th?n tư?ng c?a SM đ? th? hi?n s?c ?nh hư?ng toàn c?u trong nhi?u l?nh v?c, không ch? có âm nh?c hay th?i trang.  Ngoài ra, ngư?i hâm m? c?n vô cùng b?t ng? khi thành viên Baekhyun (EXO) c?ng xu?t hi?n đ? th? hi?n ph?n quan tr?ng không kém trong các tr?n đ?u: Hát qu?c ca Hàn Qu?c và M?. Ít ai bi?t r?ng, đây đ? là l?n th? 3 nam th?n tư?ng đư?c tin tư?ng giao tr?ng trách này. L?n đ?u tiên là vào năm 2013, trong tr?n bóng đá giao h?u qu?c t? gi?a Hàn Qu?c và Peru. L?n th? 2 là t?i bu?i h?p m?t c?a ?y ban Olympic Qu?c t? ? Pyeongchang năm 2018.  Sôi đ?ng không kém sân kh?u chính chính là phía khán đài khi ch?ng ki?n cu?c “đ? b?” c?a nhi?u ngôi sao n?i ti?ng khác đ?n theo d?i tr?n đ?u. G-Dragon và Daesung nhanh chóng tr? thành tâm đi?m khi ng?i ? khi v?c VIP và g?p g? Park Chan Ho, ngư?i ném cú ném đ?u tiên trong ngày khai màn MLB.  “C?p v? ch?ng qu?c dân” Son Ye Jin và Hyun Bin đ? có bu?i h?n h? nhóm cùng hai nam th?n c?a phim Yêu tinh là Gong Yoo và Lee Dong Wook t?i s? ki?n náo nhi?t này. Kho?nh kh?c c? 4 ngôi sao xu?t hi?n trong m?t khung h?nh đ? tr? thành ch? đ? đư?c t?m ki?m nhi?u nh?t trên MXH hôm nay.  Trong khi đó, “m? nam” Cha Eun Woo l?i gây s?t v?i v? đi?n trai khi thư?ng th?c tr?n đ?u. Trong chi?c m? LA Dodgers, nam th?n tư?ng tho?i mái t?o dáng ch? V và nh?m nháp m?t ly bia.  Ngoài nh?ng gương m?t k? trên, nh?ng c?p đôi khác như Jiyeon và Hwang Jae Gyun, Lee Bo Young và Ji Sung hay Ok Taecyeon, Sean, Kim Young Cheol… c?ng không b? l? cơ h?i đ? đón xem nh?ng tr?n bóng chày vô cùng h?p d?n này. ', 'https://bazaarvietnam.vn/wp-content/uploads/2024/03/aespa-bieu-dien-tai-MLB-World-Tour-Seoul-Series-2024.jpg', 0,  'AESPA liên t?c du?c các gi?i bóng chày m?i bi?u di?n, l?n này là MLB World Tour Seoul Series 2024'),
    (7, 1, 1,N'Hu?nh Tú Anh v?a góp m?t trên sàn di?n Chanel Cruise 2025/26, t? ch?c t?i Singapore vào ngày 4/11 v?a qua. Thành tích này càng ?n tư?ng hơn khi Tú Anh m?i ch? theo đu?i con đư?ng ngư?i m?u chuyên nghi?p đư?c kho?ng vài năm.', N'Trư?ng thành t? chương tr?nh th?c t?  Ngay t? khi bư?c chân vào s? nghi?p ngư?i m?u, Hu?nh Tú Anh đ? nghiêm ng?t qu?n l? và gi? g?n vóc dáng đ? theo đu?i đam mê. Nh? s? k? lu?t đó, cô nhanh chóng tr? thành m?t gương m?t n?i b?t v?i chi?u cao 1m78 cùng th?n thái cu?n hút và gương m?t đ?m ch?t Á Đông.  Năm 2021, Tú Anh chính th?c ch?m ng? làng m?t khi ch? đ?ng t?m ki?m cơ h?i catwalk và ch?p h?nh cho các thương hi?u Vi?t. Sau giai đo?n mi?t mài trau d?i, năm 2023, cô quy?t đ?nh bư?c vào m?t c?t m?c quan tr?ng: tham gia The Face Vietnam 2023 và tr? thành Quán quân The Face Vietnam 2023.  Nh?ng l?n ghi d?u trên b?n đ? th?i trang qu?c t?  Chi?n th?ng t?i The Face Vietnam 2023 đ? m? ra cho Tú Anh nhi?u cơ h?i qu? giá, và cô gái tr? không b? l? b?t k? kho?nh kh?c nào đ? b?t phá.   Bư?c sang năm 2024, v?i s? h? tr? t? BeU Models, Tú Anh ti?p t?c kh?ng đ?nh năng l?c c?a m?nh và chính th?c đ?u quân cho Supreme Model Management t?i Paris, London, New York, cùng Major Model t?i Milan. Quy?t đ?nh này tr? thành bư?c ngo?t quan tr?ng, đánh d?u giai đo?n Tú Anh b?t đ?u s? nghi?p ngư?i m?u qu?c t? v?i khát v?ng mang b?n s?c Á Đông t?a sáng trên các sàn di?n toàn c?u.  Tháng 9/2024, cô chính th?c có sàn di?n qu?c t? đ?u tiên cho thương hi?u Calcaterra trong khuôn kh? Tu?n l? th?i trang Milan Xuân – Hè 2025. Không d?ng l?i ? đó, cô ti?p t?c xu?t hi?n trong Paris Fashion Week cùng các nhà m?t Leonard Paris và Hodakova, ch?ng minh năng l?c thích ?ng linh ho?t và phong đ? ?n đ?nh dù là gương m?t m?i trên b?n đ? th?i trang th? gi?i.  Cùng th?i đi?m này, Tú Anh m?t l?n n?a khi?n gi?i m? đi?u t? hào khi tr? thành ngư?i m?u Vi?t đ?u tiên xu?t hi?n trên b?a chính b?n c?a Vogue Singapore, s? tháng 10/2024, bên c?nh các ngư?i m?u đ?n t? Malaysia, Singapore và Indonesia.  Th?a th?ng xông lên, Tú Anh ghi d?u v?i LO?T SÀN DI?N QU?C T? TRONG NĂM 2025  Sau nh?ng ti?p xúc đ?u tiên, Tú Anh th? hi?n r? m?nh nh?n đư?c s? tin tư?ng c?a các nhà m?t qu?c t?, khi m?t l?n n?a, trong tháng th?i trang Xuân Hè 2026, cô tr? l?i kinh đô th?i trang Milan đ? góp m?t trên sàn di?n c?a năm thương hi?u danh ti?ng: Peserico, Sara Wong, Calcaterra, Barbara và Circle Show.  Cô c?n là gương m?t m?u Vi?t duy nh?t ch?p lookbook cho thương hi?u Diesel và Blauer trong Tu?n l? th?i trang Milan Xuân Hè 2026.  Tháng 11/2025, Tú Anh khi?n gi?i m? đi?u Vi?t t? hào khi tr? thành ngư?i m?u Vi?t đ?u tiên catwalk cho bu?i tr?nh di?n chính th?c c?a Chanel. Trư?c ?ng kính truy?n thông qu?c t?, Tú Anh ghi đi?m v?i th?n thái t? tin và nh?ng bư?c catwalk v?ng vàng, l?t t? đư?c tinh th?n thương hi?u.   Tú Anh cho bi?t, đ? có cơ h?i tr?nh di?n cho Chanel, cô đ? ph?i tr?i qua nhi?u v?ng casting kh?t khe và đ? th?t b?i trong l?n th? s?c đ?u tiên, nhưng cô không b? cu?c. Cô kiên tr? g?i l?i h? sơ và video tr?nh di?n cho đ?t tuy?n ch?n m?i và cu?i cùng g?t hái đư?c trái ng?t. Đ? đ?t tr?ng thái t?t khi tr?nh di?n, to? sáng trong v?ng vài phút ít ?i, Tú Anh c?ng duy tr? ch? đ? t?p luy?n và ăn u?ng nghiêm ng?t.  H?nh ?nh c?a Tú Anh t?i sàn di?n Chanel Cruise 2025/26 là minh ch?ng cho bư?c ti?n m?i c?a th? h? ngư?i m?u tr? Vi?t Nam. Trong ch?ng hành tr?nh d?n thân vào ngh? tuy chưa dài, cô gái tr? đ? có nh?ng thành tích đáng t? hào, th? hi?n nh?ng ph?m ch?t c?n phát huy c?a ngư?i m?u Vi?t:  c?u ti?n, quy?t tâm và bi?t n?m b?t cơ h?i. Thành công hôm nay c?ng là minh ch?ng r? nét cho khát v?ng mà cô t?ng chia s? t? nh?ng ngày c?n là thí sinh The Face Vietnam 2023: “Mang v? đ?p Vi?t đ?n v?i th? gi?i.”  ', 'https://static.elle.vn/img/B6Yx4-TV284ld0llPYL6mSyvGaRuJhOTcofH1MW9WAk/rs:fit:0:0/min-height:300/plain/http://www.elle.vn/app/uploads/2025/11/06/711736/tu-anh-chanel-cruise-2025.jpg@webp', 0,  'Hu?nh Tú Anh: T? quán quân The Face Vietnam 2023 d?n m?u Vi?t d?u tiên catwalk cho show CHANEL Cruise'),
    (8, 1, 1,N'Ngày 4/11, Chanel t? ch?c show Cruise 2025/26 t?i Singapore, tr? thành nơi g?p g? c?a nhi?u ngôi sao hàng đ?u Tbiz.', N'Sau màn ra m?t t?i Villa d’Este (?), show di?n Cruise 2025/26, Chanel ti?p t?c neo đ?u t?i Singapore, m? l?i cho cu?c h?i ng? c?a nh?ng tài năng Đông Nam Á. Trên sàn di?n, quán quân The Face Vietnam 2023 Hu?nh Tú Anh là m?u Vi?t đ?u tiên catwalk cho show chính th?c c?a nhà m?t hoa trà. Trên hàng gh? khách m?i, hàng lo?t ngôi sao Thái có s?c ?nh hư?ng b?c nh?t trong khu v?c khu?y đ?o truy?n thông cho CHANEL.   Khoác trên m?nh trang ph?c đ?n t? chính BST Chanel Cruise 2025/26 tr?nh làng l?n đ?u h?i cu?i tháng 4/2025, di?n m?o c?a Becky Amstrong là bài h?c m?u m?c v? ph?i k?t trang ph?c ton-sur-ton và kh? năng thiên bi?n v?n hoá c?a s?c đen.     Chi?c áo khoác dáng l?ng – phom dáng kinh đi?n c?a Chanel – tr? nên nh? nhàng và phóng khoáng hơn nh? ch?t li?u ren hoa. Nh?ng đư?ng vi?n tr?ng m?m m?i ch?y d?c mép áo và túi t?o hi?u ?ng đ? h?a tinh t?, giúp t?ng th? trang ph?c v?a thanh l?ch v?a d? ?ng d?ng khi di chuy?n. Dư?i l?p áo c?u k? là áo hai dây t?i gi?n, đi?m xuy?t b?ng khóa vuông, mang l?i c?m giác tho?i mái nhưng v?n gi? đư?c v? tinh t? đ?c trưng c?a nhà m?t. Becky ch?n qu?n ?ng loe lưng cao, giúp tôn dáng và tăng s? tho?i mái cho nh?ng bư?c đi dài trên ph?.  Ph? ki?n đư?c ti?t ch? tinh khéo: hoa tai Coco Crush đ?ng đi?u v?i túi da ch?n h?a ti?t qu? trám, và đ?ng h? Première. Đây đ?u là nh?ng món đ? nh? g?n nhưng đa d?ng, có th? k?t h?p linh ho?t v?i nhi?u outfit khác nhau. Chính s? tinh gi?n và đ?ng đi?u ?y giúp Becky tr? thành h?nh m?u hoàn h?o cho phong cách du l?ch nh? nhàng mà v?n toát lên phong thái thanh l?ch, n? tính.  Di?n trang ph?c t? BST đ?u tay c?a GĐST Matthieu Blazy – Chanel Xuân Hè 2026, thay cho tinh th?n du ngo?n c?a BST Cruise như Becky, rung c?m chung t? t?o h?nh c?a nam di?n viên, ca s? Gemini Norawit v?n toát lên tinh th?n ngh? dư?ng c?a gi?i thư?ng lưu khi cân b?ng hoàn h?o gi?a s? thanh l?ch và c?m giác tho?i mái.  N?n t?ng c?a trang ph?c là chi?c áo polo kéo khoá, m?t món đ? kinh đi?n th? hi?n tinh th?n “quiet luxury” – sang tr?ng trong s? gi?n d?. Ph?n c? áo mang hơi hư?ng th? thao c? đi?n, đ? thanh l?ch đ? xu?t hi?n trong s?nh khách s?n nhưng v?n phù h?p cho kho?nh kh?c thư gi?n trên boong tàu – g?i nên h?nh ?nh ngư?i đàn ông yêu thích s? tho?i mái nhưng không bao gi? lơi là v? ngoài.  Chi?c qu?n đóng vai tr? cân b?ng t?ng th? khi mang đ?n c?m giác hi?n đ?i, v?ng ch?i. Phom dáng relaxed fit đ? g?n đ? trông ch?n chu, nhưng v?n gi? đ? r? t? nhiên, bi?u hi?n đúng tinh th?n ăn v?n đ?p không c?n g?ng gư?ng.  Tương t? như Becky, Gemini c?ng là tín đ? c?a trang s?c Coco Crush t?i gi?n và nh?ng c? máy th?i gian thu nh? t? CHANEL. Chi?c J12 38mm trên c? tay nâng t?m toàn b? b?n ph?i đơn gi?n b?ng s? tinh x?o, v?ng vàng và l?ch thi?p. T?ng th? g?i thông đi?p r? nét v? gu th?m m? c?a Gemini trư?c s? phù phép c?a nhà m?t: Không phô trương nhưng luôn toát lên đ?ng c?p c?a m?t ngư?i đàn ông bi?t t?n hư?ng, am hi?u phong cách và luôn ch?n s? tho?i mái trong khuôn kh? c?a tinh t?.  ', 'https://bazaarvietnam.vn/wp-content/uploads/2025/11/bzvn-thumb-chanel-cruise-2025-26-becky-gemini.jpg', 2,  'D? show Chanel, Becky Amstrong, Gemini Norawit g?i ? phong cách th?i trang ngh? du?ng thu?ng luu'),
    (9, 1, 1,N'V?i chu?i 5 năm liên ti?p, Jennie (BLACKPINK) m?t l?n n?a ch?ng minh s?c ?nh hư?ng toàn c?u c?a m?nh không ch? trong l?nh v?c âm nh?c mà c?n c? th?i trang.', N'Trong th? gi?i th?i trang cao c?p, vi?c m?t bi?u tư?ng đư?c “gi? streak” su?t nhi?u năm li?n là minh ch?ng r? ràng nh?t cho m?i quan h? c?ng sinh hoàn h?o gi?a cá nhân và nhà m?t. Jennie Kim và Chanel Coco Crush chính là m?t m?i quan h? như th?: B?n b?, chi?n lư?c và ngày càng thăng hoa theo th?i gian.  Su?t 5 năm, Jennie và Chanel Coco Crush v?n đ?ng hành  M?i đây, Chanel đ? chính th?c công b? gương m?t đ?i di?n cho chi?n d?ch toàn c?u Chanel Coco Crush năm 2026. Không n?m ngoài d? đoán, Jennie (BLACKPINK) ti?p t?c góp m?t trong chi?n d?ch l?n này. Đ?ng th?i, nàng idol c?ng m? khóa chu?i 5 năm đ?ng hành cùng các chi?n d?ch toàn c?u c?a BST. Chi?n d?ch s? chính th?c đư?c ra m?t vào ngày 13/1 ph?m vi toàn c?u.  L?n tr? l?i này c?a Jennie c?n đánh d?u m?t c?t m?c đ?c bi?t khi là năm th? năm liên ti?p cô gi? vai tr? gương m?t đ?i di?n toàn c?u cho d?ng trang s?c Coco Crush. Trong b?i c?nh các nhà m?t xa x? ngày càng kh?t khe trong vi?c l?a ch?n đ?i s?, đi?u này đ? th? hi?n s? tin tư?ng tuy?t đ?i mà Chanel dành cho nàng It Girl đ?n t? Hàn Qu?c.  Trong lo?t h?nh ?nh v?a đư?c công b?, Jennie xu?t hi?n v?i th?n thái v?a kiêu k? v?a phóng khoáng, khoác lên m?nh nh?ng thi?t k? mang ADN đ?c trưng c?a d?ng Coco Crush. Đó là v?ng c? choker có th? đi?u ch?nh linh ho?t, khuyên tai đa năng có th? bi?n hóa theo nhi?u cách đeo khác nhau, và nh?ng chi?c nh?n x?p l?p. T?t c? đ?u đư?c ch? tác t? beige gold tr? danh c?a Chanel.  Jennie khoe khéo Crush ? m?i nơi  Vi?c Chanel “ch?n m?t g?i vàng” Jennie su?t 5 năm li?n không ph?i là đi?u ng?u nhiên. Ngoài s?c hút truy?n thông và giá tr? thương m?i kh?ng l? mà cô mang l?i, Jennie c?n là m?t trong s? ít đ?i s? th?c s? s?ng cùng s?n ph?m.  M?t trong nh?ng ví d? đi?n h?nh nh?t chính là kho?nh kh?c t?o trend “nh?n làm ph? ki?n tóc” t?ng gây b?o m?ng x? h?i. Năm 2024, t?i bu?i ti?c khai trương pop-up Chanel Coco Crush ? Seoul, Jennie xu?t hi?n trong di?n m?o “dát vàng dát b?c” đúng ngh?a.  Chi?c váy d?t kim đen siêu ng?n, v? monogram Chanel, dây chuy?n dài m?t đ?ng h? và khuyên m?i đ? đ? đ? t?o nên m?t t?ng th? n?i b?t. Nhưng đi?m nh?n khi?n gi?i m? đi?u không th? r?i m?t chính là nh?ng chi?c nh?n Coco Crush đư?c khéo léo lu?n vào bím tóc.  Cách làm đ?p này v?a xa x?, v?a ng?u h?ng, th? hi?n r? tinh th?n t? do mà Coco Crush đ?i di?n. H?a ti?t qu? trám ch?n bông khi đư?c đ?t ? v? trí trung tâm như mái tóc, tr? nên s?ng đ?ng và đ?y tính th?i trang. Trào lưu này nhanh chóng đư?c ngư?i hâm m? và fashionista kh?p nơi hư?ng ?ng, m?t l?n n?a c?ng c? danh xưng Jensetter c?a cô nàng.  Ngu?n c?m h?ng b?t t?n t? Coco Crush  Coco Crush mang trong m?nh m?t câu chuy?n l?ch s? kéo dài hơn m?t th? k?. Ngu?n c?m h?ng c?a b? sưu t?p b?t ngu?n t? năm 1906, khi Gabrielle Chanel l?n đ?u chú ? đ?n h?a ti?t ch?n bông trên chăn và áo khoác c?a các k? s? trong chu?ng ng?a c?a Étienne Balsan. T? m?t chi ti?t r?t đ?i thư?ng, nay tr? thành bi?u tư?ng g?n li?n v?i Chanel, xu?t hi?n xuyên su?t trong các thi?t k? th?i trang, túi xách và n?i th?t t? th?p niên 1920.  Đ?n năm 2015, Chanel l?n đ?u đưa h?a ti?t ch?n bông lên trang s?c cao c?p v?i s? ra đ?i c?a Coco Crush. Trên b? m?t kim lo?i qu?, các đư?ng kh?c h?nh h?c đư?c x? l? m?m m?i nh? nh?ng đư?ng bo tr?n tinh x?o. M?i chi ti?t đ?u đư?c tính toán chính xác, t?o nên s? cân b?ng hoàn h?o gi?a c?ng cáp và uy?n chuy?n, gi?a s?c m?nh và nét n? tính, đúng v?i tinh th?n mà Gabrielle Chanel theo đu?i.  M?t trong nh?ng đi?m đ?c bi?t nh?t c?a Coco Crush chính là s?c vàng be (beige gold) đ?c quy?n c?a Chanel. Beige g?n li?n v?i nh?ng d?u m?c đ?u tiên trong s? nghi?p c?a Gabrielle Chanel, t? v?i tweed, len d?t cho đ?n đôi giày hai tông màu huy?n tho?i. Khi đư?c ?ng d?ng vào vàng 18K, beige gold mang đ?n c?m giác m?m m?i như nhung trên làn da, tôn lên v? đ?p t? nhiên và sang tr?ng m?t cách r?t kín đáo.  Coco Crush nhanh chóng tr? thành m?t trong nh?ng d?ng trang s?c bán ch?y nh?t c?a Chanel, v?i m?c giá tr?i dài t? 1.500 USD đ?n 60.000 USD. Dư?i s?c ?nh hư?ng m?nh m? c?a Jennie Kim, b? sưu t?p đư?c m? r?ng và đ?c bi?t chinh ph?c th? h? khách hàng tr?, nh?ng ngư?i t?m ki?m s? xa x? mang tính cá nhân hóa, linh ho?t và g?n li?n v?i phong cách s?ng.  Năm th? 5 liên ti?p đ?ng hành cùng Coco Crush, Jennie như tr? thành m?t ph?n không th? tách r?i c?a câu chuy?n. V?i streak ?n tư?ng này, có l? hành tr?nh câu chuy?n gi?a Jennie và Chanel v?n c?n r?t dài phía trư?c.', 'https://bazaarvietnam.vn/wp-content/uploads/2024/07/jisoo-va-jennie-blackpink-tao-trend-deo-nhan-len-toc-11.jpg', 0,  'Jennie BLACKPINK gi? streak 5 nam qu?ng bá trang s?c Chanel Coco Crush'),
    (10, 1, 1,N'Ca s? H? Ng?c Hà lên đ? th?i thư?ng theo xu hư?ng monochrome t?i show Gucci Thu Đông 2026 thu?c Milan Fashion Week hôm 27/2.', N'Xu?t hi?n v?i vai tr? Friend of the House c?a nhà m?t Gucci, H? Ng?c Hà m?c trang ph?c da l?n màu camel đ?ng đi?u, thu?c b? sưu t?p Pre-Fall 2026. Cô là ngh? s? Vi?t Nam duy nh?t góp m?t t?i show th?i trang này.   M? nhân 42 tu?i th? tóc xoăn sóng b?ng b?nh, hoàn thi?n phong cách thanh l?ch mà không kém ph?n sành đi?u.', 'https://i1-ngoisao.vnecdn.net/2026/03/01/2-ho-ngoc-ha-1772303101.jpg?w=1200&h=0&q=100&dpr=2&fit=crop&s=TejWw0HXZdI0B4rB3ctS-g', 0,  'H? Ng?c Hà sành di?u d? show Gucci');

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
