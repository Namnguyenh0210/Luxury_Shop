
	/*
	KỊCH BẢN TẠO CƠ SỞ DỮ LIỆU LUXURY FASHION (BẢN PRODUCTION 2026)
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


	USE master;
	GO
	IF DB_ID('LuxuryFashion_2026') IS NOT NULL
	BEGIN
		ALTER DATABASE LuxuryFashion_2026 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE LuxuryFashion_2026;
	END
	GO
	-- Tạo database mới
	CREATE DATABASE LuxuryFashion_2026;
	GO

	-- Sử dụng database mới
	USE LuxuryFashion_2026;
	GO
	PRINT N'PHẦN 0: TẠO VÀ SỬ DỤNG DATABASE LuxuryFashion_2026 THÀNH CÔNG!';
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
	IF OBJECT_ID('dbo.PasswordResetToken', 'U') IS NOT NULL
	DROP TABLE dbo.PasswordResetToken;
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
								TrangThai INT NOT NULL DEFAULT 1,
								Logo NVARCHAR(255)
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

	CREATE TABLE PasswordResetToken (
										Id BIGINT IDENTITY(1,1) PRIMARY KEY,
										Email VARCHAR(100) NOT NULL,
										OTP VARCHAR(10) NOT NULL,
										Expiry DATETIME NOT NULL,
										TrangThai BIT DEFAULT 1, -- 1: còn hiệu lực, 0: đã dùng / hết hạn
										NgayTao DATETIME DEFAULT GETDATE(),

										CONSTRAINT FK_PasswordReset_Email
											FOREIGN KEY (Email) REFERENCES TaiKhoan(Email)
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
	USE LuxuryFashion_2026;
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
		(1, N'Nhật Phong', 'admin@luxury.com', '123', '0967328210', N'139 Đường Lê Thái Tông, Q.1, TP.HCM', 1),

		(2, N'Liễu Như Yên', 'nhuyen@luxury.com', '123', '0985278367', N'456 Đường Trường Chinh, Q.Tân Phú, TP.HCM', 1),
		(9, N'Nguyễn Thị Nhân Viên', 'nhanvien@luxury.com', '123', '0985278367', N'456 Đường Trường Chinh, Q.Tân Phú, TP.HCM', 1),
		(3, N'Nguyễn Hải Nam', 'namnguyen@luxury.com', '123', '0937567328', N'456 Đường Trường Chinh, Q.Tân Phú, TP.HCM', 1),

		(4, N'Nguyễn Đình Triệu', 'trieunguyen@gmail.com', '123', '0399777450', N'750 Đường TTH 21, Q.12, TP.HCM', 1),

		(5, N'Vũ Minh Thuận', 'vuminhthuan@gmail.com', '123', '0984164050', N'750 Đường TTH 21, Q.12, TP.HCM', 1),
		(6, N'Nguyễn Thị Phương Uyên', 'phuonguyen160707@gmail.com', '123', '0984165060', N'750 Đường TTH 21, Q.12, TP.HCM', 1),
		(7, N'Lê Văn Khách', 'khachhang@luxury.com', '123', '0984165061', N'750 Đường TTH 21, Q.12, TP.HCM', 1),
		(8, N'Lê Bá Tuấn Vỹ', 'vyle1828@gmail.com', '123', '090245924', N'789 Đường Quang Trung, Q.12, TP.HCM', 1);

	-- Mật khẩu: 123 (plain text)
	SET IDENTITY_INSERT dbo.TaiKhoan OFF;
	GO

	INSERT INTO TaiKhoan_VaiTro
		(MaTK, MaVaiTro)
	VALUES
		(1, 1),

		(2, 2),
 
		(3, 2),
		(4, 3),
		(5, 3),
		(6, 3),
		(7, 3),
	(9, 2),
		(8, 3);

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
		(1, N'Nhà phân phối Gucci VN', '0281841634', N'10 Nguyễn Trãi, Q1, TP.HCM'),
		(2, N'Nhà phân phối chanel VN', '0813285368', N'10 Nguyễn Trãi, Q1, TP.HCM'),
		(3, N'Nhà phân phối MBL VN', '0936142056', N'10 Nguyễn Trãi, Q1, TP.HCM');
	SET IDENTITY_INSERT dbo.NhaCungCap OFF;
	GO



	SET IDENTITY_INSERT dbo.LoaiBaiViet ON;
	INSERT INTO LoaiBaiViet
	(MaLoaiBV, TenLoaiBV)
	VALUES
    (1, N'Xu hướng thời trang'),
    (2, N'Kinh nghiệm phối đồ'),
    (3, N'Tin tức sự kiện'),
    (4, N'Bộ sưu tập mới'),
    (5, N'Bí quyết chăm sóc sản phẩm'),
    (6, N'Lịch sử thương hiệu'),
    (7, N'Đánh giá chuyên sâu'),
    (8, N'Phong cách sống thượng lưu');
	SET IDENTITY_INSERT dbo.LoaiBaiViet OFF;
	GO

	-- 1.5. Chèn Voucher Mẫu
	SET IDENTITY_INSERT dbo.Voucher ON;
	INSERT INTO Voucher 
	(MaVoucher, Code, MoTa, LoaiGiamGia, GiaTri, GiaTriToiThieu, SoLuong, DaSuDung, ApDungCho, NgayBatDau, NgayKetThuc, TrangThai)
	VALUES
		(1, 'LUXURY500', N'Giảm ngay 500k cho đơn hàng từ 10tr', 1, 500000, 10000000, 100, 0, 'ALL', GETDATE(), DATEADD(month, 1, GETDATE()), 1),
		(2, 'VIP10', N'Ưu đãi 10% cho khách hàng VIP (Đã tiêu trên 20tr)', 0, 10, 5000000, 50, 0, 'VIP', GETDATE(), DATEADD(year, 1, GETDATE()), 1),
		(3, 'NEWBIE', N'Giảm 20% cho đơn hàng đầu tiên (Max 2tr)', 0, 20, 1000000, 500, 0, 'NEW', GETDATE(), DATEADD(month, 3, GETDATE()), 1),
		(4, 'SPRING2026', N'Chào xuân 2026 - Giảm 15% cho mọi đơn hàng', 0, 15, 2000000, 200, 0, 'ALL', '2026-01-01', '2026-04-30', 1),
		(5, 'GUCCILOVER', N'Dành riêng cho fan Gucci - Giảm 1tr cho sp Gucci', 1, 1000000, 5000000, 50, 0, 'GUCCI', '2026-03-01', '2026-12-31', 1),
		(6, 'FREESHIP', N'Miễn phí vận chuyển cho đơn hàng từ 2tr', 1, 50000, 2000000, 1000, 0, 'ALL', '2026-01-01', '2026-12-31', 1),
		(7, 'FLASH30', N'Flash Sale - Giảm 30% tối đa 500k', 0, 30, 500000, 300, 0, 'ALL', GETDATE(), DATEADD(day, 2, GETDATE()), 1),
		(8, 'VIP50', N'Siêu voucher VIP - Giảm 50% cho khách tiêu trên 50tr', 0, 50, 10000000, 20, 0, 'VIP', '2026-01-01', '2026-12-31', 1),
		(9, 'WELCOME', N'Voucher chào mừng thành viên mới', 1, 100000, 500000, 500, 0, 'NEW', '2026-01-01', '2026-12-31', 1),
		(10, 'LUXURY20', N'Giảm 20% cho đơn hàng từ 50tr', 0, 20, 50000000, 30, 0, 'ALL', '2026-03-01', '2026-12-31', 1),
		(11, 'FIXED2M', N'Giảm thẳng 2 triệu cho đơn hàng từ 20tr', 1, 2000000, 20000000, 20, 0, 'VIP', '2026-03-01', '2026-12-31', 1),
		(12, 'NEWYEAR', N'Quà tặng năm mới - Giảm 10% tối đa 1tr', 0, 10, 2000000, 500, 0, 'ALL', '2026-01-01', '2026-02-28', 0),
		(13, 'SUMMER26', N'Hè rực rỡ - Giảm 15% cho BST Hè', 0, 15, 3000000, 100, 0, 'ALL', '2026-05-01', '2026-08-31', 1),
		(14, 'BIRTHDAY', N'Mừng sinh nhật khách hàng - Voucher 500k', 1, 500000, 1000000, 1000, 0, 'PRIVATE', '2026-01-01', '2026-12-31', 1),
		(15, 'CHANELLOVE', N'Dành riêng cho fan Chanel - Giảm 5%', 0, 5, 10000000, 100, 0, 'CHANEL', '2026-01-01', '2026-12-31', 1),
		(16, 'FREESHIPPLUS', N'Freeship mọi đơn hàng trên 1tr', 1, 35000, 1000000, 9999, 0, 'ALL', '2026-01-01', '2026-12-31', 1);
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
		(3, 1, 1,
		 N'Đây là khoảnh khắc mà những người hâm mộ thời trang trên khắp thế giới chờ đợi: Bộ sưu tập ra mắt của Demna cho Gucci',
		 N'Buổi ra mắt diễn ra vào thứ Sáu tại trung tâm Milan, trong Palazzo delle Scintille, một công trình kính theo phong cách art nouveau cuối thế kỷ này được xây dựng vào năm 1923. Gần 1.000 khách mời đã đến tham dự. Paris Hilton và em gái Nicky Rothschild có mặt cùng ngôi sao K-pop Lee Know. Donatella Versace ngồi hàng ghế đầu. Alessandro Michele, cựu giám đốc sáng tạo từng tạo nên thời kỳ huy hoàng cho Gucci, cũng có mặt để ủng hộ giai đoạn mới của thương hiệu. Sàn diễn được dàn dựng như một bảo tàng thu nhỏ với những bức tường thời La Mã, gợi nhắc về nguồn gốc của hãng.

		 Trên sàn diễn đó, bộ sưu tập gồm 83 thiết kế dành cho cả nam và nữ. Các người mẫu nữ sải bước với giày cao gót nhọn, quần legging cạp thấp, váy mini, tất in họa tiết hai chữ G, cùng áo khoác giả lông hoặc áo khoác bomber. Người mẫu nam phô diễn cơ bắp dưới lớp áo bó sát, kết hợp áo khoác biker và những đôi giày da đỏ hoặc trắng cỡ lớn. Một số người đeo túi đeo chéo Gucci vốn rất được ưa chuộng. Kate Moss khép lại buổi trình diễn trong chiếc váy dạ hội đen lấp lánh hở lưng, để lộ phần dây nội y với biểu tượng hai chữ G mạ vàng.

		 “Buổi ra mắt của Demna tại Gucci là buổi diễn được soi xét kỹ càng nhất trong mùa này,” Gaya Guiragossian, giám đốc phong cách và nghệ thuật của nền tảng bán lại hàng xa xỉ Vestiaire Collective nhận xét. “Bộ sưu tập gợi lại thời kỳ hào nhoáng của Tom Ford trong thập niên 1990, từ lớp trang điểm mắt khói, áo sơ mi lụa cho tới các chất liệu thật bóng bẩy.”

		 Bộ sưu tập Thu Đông 2026-2027 ra mắt trong bối cảnh ngành xa xỉ trải qua một năm nhiều biến động nhân sự tại các nhà mốt lớn. Ngành này cũng đang tìm cách phục hồi sau giai đoạn nhu cầu suy yếu. Theo ước tính của Bain, khoảng 50 triệu khách hàng đã rời bỏ thị trường sau cơn bùng nổ hậu đại dịch. Giá bán bị đẩy lên quá cao khiến nhiều người mua cảm thấy thất vọng với các thương hiệu cao cấp, trong khi sức hấp dẫn của sản phẩm cũng giảm sút.

		 Trong bối cảnh đó, Demna, người nổi tiếng với phong cách gây tranh cãi và hiện không còn sử dụng họ Gvasalia, từng được xem là một lựa chọn vô cùng mạo hiểm với Gucci. Thương hiệu danh tiếng này được thành lập tại Florence năm 1921 và hiện thuộc tập đoàn xa xỉ Pháp Kering. Demna giữ vai trò giám đốc sáng tạo của Balenciaga, một thương hiệu khác thuộc Kering, trong suốt một thập niên cho đến tháng Bảy năm ngoái. Quãng thời gian đó cũng không thiếu tranh cãi. Năm 2022, một chiến dịch quảng cáo bị chỉ trích vì gợi yếu tố tình dục hóa trẻ em đã gây nên làn sóng phẫn nộ dữ dội, buộc Balenciaga và nhà thiết kế sinh ra tại Georgia phải công khai xin lỗi.

		 Dù vậy, dưới thời Demna, Balenciaga cũng tung ra nhiều thiết kế gây sốt trên mạng xã hội, như đôi sneaker Triple S do ông cùng nhà thiết kế David Tourniaire-Beauciel tham gia thiết kế. Những sản phẩm này thu hút thế hệ khách hàng trẻ, khiến nhiều người bắt đầu gắn liền Balenciaga với phong cách streetwear, đồng thời mang lại thành công thương mại cho thương hiệu. Kering không công bố doanh thu riêng của Balenciaga, nhưng theo ước tính của nhà phân tích Luca Solca tại Bernstein, doanh số hãng vào năm 2022 có thể đạt đỉnh khoảng 2,3 tỷ euro, tương đương 2,7 tỷ USD.

		 Demna cũng hồi sinh dòng haute couture của Balenciaga, phân khúc phục vụ những khách hàng cần váy dạ hội cho các bữa tiệc từ thiện hoặc thảm đỏ. Điều này cho thấy tay nghề của ông với tư cách một nhà thiết kế couture thực thụ. Ông vẫn đưa vào đó những chi tiết lập dị, như chiếc váy giáp làm từ nhựa resin mạ chrome, khiến cộng đồng người hâm mộ bàn tán sôi nổi trên Instagram.

		 Sự phục hồi của Gucci có ý nghĩa rất lớn đối với toàn bộ hệ sinh thái thời trang. Gucci hiện là thương hiệu bán chạy nhất trên Vestiaire Collective. Theo Guiragossian, lượt tìm kiếm túi Jackie đã tăng mạnh sau khi Demna tung ra bộ sưu tập giới hạn tên La Famiglia gồm 37 thiết kế vào tháng 9. Mẫu túi ra mắt năm 1961 và từng là món đồ yêu thích của Jackie Onassis. Bộ sưu tập La Famiglia mang tinh thần Gucci truyền thống hơn với các họa tiết hoa, trong khi bộ sưu tập trình diễn hôm thứ Sáu có phong cách sắc sảo hơn và thể hiện rõ dấu ấn của Demna.

		 “Trong vài tháng tới, thị trường sẽ cho thấy liệu các thiết kế mới của Demna có thu hút thêm sự quan tâm trên nền tảng của chúng tôi hay không, hoặc liệu làn sóng hoài niệm này có khiến người mua quay lại với Gucci thời Tom Ford không,” Guiragossian nói.

		 Nhìn lại lịch sử của thương hiệu, giữa thập niên 1990 phong cách gợi cảm của Tom Ford đã đưa Gucci trở thành tâm điểm của làng mốt. Hai thập niên sau, Alessandro Michele mở ra giai đoạn bohemian rực rỡ từ năm 2015 đến 2022. Phong cách táo bạo của ông, tiêu biểu là đôi mule lông Princetown, giúp doanh thu hằng năm của Gucci vượt mốc 10 tỷ euro trong năm cuối cùng ông giữ vai trò giám đốc sáng tạo. Nhưng sau đó doanh số của thương hiệu đã sụt giảm hơn 40%.

		 “Thành công của Gucci dưới thời Michele thật choáng ngợp, nhưng cú lao dốc sau đó còn choáng ngợp hơn. Điều này cho thấy thị hiếu của người tiêu dùng thời trang biến động rất nhanh,” Serge Carreira, giáo sư liên kết về thời trang và xa xỉ tại Sciences Po ở Paris, nhận định. “Vì vậy, nhiều người kỳ vọng thương hiệu sẽ sớm trở lại thời kỳ hoàng kim, bởi đây là nhãn hàng chủ lực của một trong những tập đoàn xa xỉ lớn nhất thế giới.” Ngoài Gucci, Kering còn sở hữu Yves Saint Laurent và Bottega Veneta.

		 Liệu Gucci có thể phục hồi không? “Nguồn gốc gia đình tại Ý, tay nghề chế tác đồ da và giày cùng lịch sử hơn một thế kỷ là những lợi thế đặc biệt mà thương hiệu có thể khai thác,” Alix Morabito, giám đốc mua hàng toàn cầu của tập đoàn bách hóa Pháp Galeries Lafayette, nhận định.

		 Sau buổi trình diễn, tổng giám đốc Kering Luca de Meo không bình luận về nguồn cảm hứng sáng tạo của bộ sưu tập, nhưng ông ca ngợi sự đa dạng của các dòng sản phẩm. “Chúng tôi đang bắt đầu một hành trình mới và mọi thứ dường như đang đi đúng hướng,” ông nói.

		 Theo Yann Kretz, đối tác cấp cao tại công ty tư vấn Kéa, chìa khóa thành công nằm ở việc Gucci phải tạo ra các món phụ kiện đủ hấp dẫn để thu hút khách hàng trẻ tuổi. “Phụ kiện chiếm phần lớn doanh thu,” ông nói, nhắc đến thắt lưng, giày và các mẫu túi “it bag”. Những đôi mule nổi tiếng xuất hiện thường xuyên trong bộ sưu tập hôm thứ Sáu và được người mẫu nam mang trên sàn diễn.

		 Thông thường, phải mất khoảng nửa năm để các thiết kế trên sàn diễn được đưa ra thị trường. Tuy nhiên, ngay từ hôm thứ Sáu, người mua đã có thể đặt một số phụ kiện mới của bộ sưu tập này trực tuyến hoặc tại một số cửa hàng.

		 Một ngày trước buổi trình diễn, cửa hàng flagship của Gucci trên phố Via Monte Napoleone đã chật kín khách VIC. Đây là những “very important customers” đến chọn trang phục cho sự kiện tại khu mua sắm xa xỉ bậc nhất trung tâm Milan.

		 Nhưng bên ngoài cửa hàng còn có một nhóm thiếu nữ tuổi teen, có người Ý, có người đến từ các nước khác. Họ đọc trên mạng xã hội rằng Lee Know, đại sứ thương hiệu, sẽ xuất hiện.

		 Giulia Amerio, 17 tuổi, đã chờ ngôi sao này suốt hơn 30 phút. Cô biết Demna chuẩn bị ra mắt bộ sưu tập đầu tiên và khá tò mò về nó, nhưng nói rằng mình chỉ sở hữu một chai nước hoa Gucci. “Tôi rất thích thương hiệu này,” cô nói. “Nhưng sự xuất hiện của ngôi sao K-pop khiến mọi thứ trở nên thú vị hơn.”',
		 'https://static.bbw.vn/img/bbw/gucci-he-lo-bo-suu-tap-moi-nhat-tai-milan-hinh-anh-monic-1050x700.webp',
		 1,
		 'gucci-ra-mat-bo-suu-tap-moi'),

		(4, 2, 2,
		 N'Lấy bối cảnh bàn tiệc ấm cúng, chiến dịch "The Gathering" của Gucci ghi lại khoảnh khắc sum vầy của dàn sao đình đám Nghê Ni, Tống Uy Long và vợ chồng Mai Davika.',
		 N'Gucci vừa chính thức trình làng chiến dịch quảng bá mới mang tên “The Gathering”. Với sự góp mặt của dàn đại sứ đình đám gồm Nghê Ni, Tống Uy Long và cặp đôi Davika Hoorne – Chantavit Dhanasevi, chiến dịch không chỉ là lời chào sân cho bộ sưu tập “Gucci: La Famiglia” mà còn là thước phim đầy cảm xúc về sự gắn kết giữa những tâm hồn đồng điệu.

		 Tâm điểm của chiến dịch “The Gathering” chính là sự hội tụ của những tên tuổi hàng đầu làng giải trí Châu Á như đại sứ thương hiệu Davika Hoorne cùng chồng là Chantavit Dhanasevi. Việc đưa một cặp đôi thực thụ vào khung hình đã giúp Gucci truyền tải trọn vẹn sự ấm áp, chân thật của tình thân – giá trị cốt lõi mà chiến dịch này hướng tới.

		 Sự xuất hiện của đại sứ toàn cầu Nghê Ni một lần nữa khẳng định mối nhân duyên bền chặt giữa cô và nhà mốt. Trong các thiết kế mới nhất, Nghê Ni toát lên vẻ sang trọng, điềm tĩnh nhưng đầy sức hút.

		 Đồng hành cùng cô là đại sứ thương hiệu Tống Uy Long, nam diễn viên mang vẻ đẹp lịch lãm, trẻ trung, đại diện cho thế hệ mới đầy năng lượng.

		 Lấy chủ đề tình thân làm điểm tựa, “The Gathering” (tạm dịch: Sự sum vầy) tôn vinh cảm giác thuộc về được hình thành giữa những người thân thiết nhất, những người luôn bên cạnh và khiến trái tim ta cảm thấy được an ủi.

		 Loạt hình ảnh của chiến dịch đặt từng cá nhân trong mối tương quan với tập thể. Ở đó, các nhân vật không đứng riêng lẻ mà hòa mình vào một cộng đồng nhỏ. Trong khoảnh khắc quây quần quanh bàn tiệc, sự hiện diện của mỗi thành viên trở thành một mảnh ghép không thể thiếu, phản chiếu những cách kết nối đa dạng và đa sắc thái của cuộc sống đương đại.

		 Xuyên suốt chiến dịch, dàn ngôi sao khoác lên mình những thiết kế nằm trong bộ sưu tập “Gucci: La Famiglia”. Đây là bộ sưu tập mang dấu ấn sâu sắc về sự gắn kết, ở đó tính thủ công tinh xảo của nhà mốt gặp gỡ những giá trị nhân văn.

		 Dưới sự dẫn dắt của ngôn ngữ hình ảnh giàu cảm xúc, Gucci tiếp tục hành trình khám phá chiều sâu của sự kết nối con người. Chiến dịch ghi lại những khoảnh khắc giản đơn nhưng đắt giá khi con người tìm đến nhau để sẻ chia, để đồng hành và để mọi điều diễn ra trong cuộc sống trở nên thật sự ý nghĩa.',
		 'https://static.elle.vn/img/_qehjJQbT3DNvd1OT-uAPteH6fsfnYUzdTNva2pdrxw/rs:fit:0:0/min-height:300/plain/http://www.elle.vn/app/uploads/2026/01/21/731579/gucci-the-gathering-3.jpg@webp',
		 1,
		 'vo-chong-davika-hoorne-va-dan-sao-chau-a-hoi-ngo-trong-chien-dich-the-gathering-cua-gucci'),

		(5, 3, 3,
		 N'Thương hiệu MLB chính thức chào đón cửa hàng đầu tiên tại TP.HCM với sự góp mặt của đông đảo giới mộ điệu. Đây là thương hiệu được giới trẻ khắp Châu Á yêu mến, và chưa hề có dấu hiệu hạ nhiệt khi đặt chân tới Việt Nam.',
		 N'Xuất xứ từ Hàn Quốc, được truyền cảm hứng bởi bộ môn bóng chày, các thiết kế của MLB mang đậm tinh thần thể thao đường phố và có tính ứng dụng cao. Sự kết hợp giữa bóng chày và thời trang đã tạo ra làn sóng trào lưu mới. MLB đem đến các bộ sưu tập về trang phục và phụ kiện cho nam, nữ qua các sản phẩm đặc trưng như áo phông oversize, mũ lưỡi trai, hay những đôi chunky sneakers đậm chất đường phố với logo của 4 đội bóng chày danh tiếng. Các biểu tượng đặc trưng của thương hiệu như New York Yankees, LA Dodgers, Boston Red Sox và St. Louis Cardinals không còn đơn thuần là logo một đội bóng, đó là văn hóa và thời trang.

		 Sự kiện khai trương MLB Việt Nam đã diễn ra vào 6/11/2019 với nhiều hoạt động thú vị, phần trình diễn thu hút từ ca sĩ Orange, cùng vũ điệu sôi động của vũ đoàn & DJ cực chất. Tại sự kiện còn quy tụ dàn khách mời nổi tiếng như: ca sĩ Osad, fashionista Decao, Lou Hoàng, Phí Phương Anh, Tú Hảo, Quỳnh Anh Shyn, Đồng Ánh Quỳnh, Bùi Linh Chi cùng những stylist có tiếng trong làng thời trang Việt như Kye Nguyễn, Phạm Bảo Luận, Duy Plue… Tất cả đã mang đến một buổi tối đáng nhớ cho người tham dự. MLB Vincom Lê Thánh Tôn hứa hẹn là điểm mua sắm lý tưởng cho các tín đồ thời trang. Công ty Maison tự hào là đơn vị phân phối độc quyền thương hiệu MLB tại Việt Nam.

		 MLB là tên viết tắt của Major League Baseball – tổ chức thể thao chuyên nghiệp của môn bóng chày và luôn được sự quan tâm lớn của hầu hết fan bóng chày trên toàn thế giới. Thương hiệu MLB thuộc tập đoàn F&F, cửa hàng MLB Korea đầu tiên được mở vào năm 1997. Cho đến nay, MLB đã có 250 cửa hàng tại khắp khu vực Châu Á như Hàn Quốc, Hong Kong, Ma Cao, Đài Loan, Trung Quốc và Việt Nam. Thương hiệu chuyên thiết kế và sản xuất trang phục, giày & phụ kiện lấy cảm hứng từ logo của những đội bóng chày danh tiếng.',
		 'https://www.elle.vn/wp-content/uploads/2019/11/08/379362/Hinh-store-main.jpg',
		 1,
		 'mlb-hoanh-trang-ra-mat-cua-hang-dau-tien-tai-viet-nam'),

		(6, 4, 1,
		 N'AESPA rất có duyên với các giải bóng chày khi liên tục biểu diễn tại các buổi thi đấu của bộ môn này',
		 N'Trực thuộc nhà SM Entertainment nhưng ngay từ khi ra mắt, aespa đã không chọn concept nữ tính, đáng yêu thường thấy ở các nhóm nhạc nữ của công ty giải trí này. Thay vào đó, công ty xây dựng cho nhóm concept thực tế ảo, kết hợp công nghệ AI và sự cá tính viễn lai. Vẻ ngoài năng động của aespa cũng vô cùng tương đồng với thể loại âm nhạc có phần sôi nổi mà nhóm theo đuổi. Vậy nên không quá khó hiểu khi thời gian vừa qua, các giải đấu thể thao liên tục lựa chọn aespa tham gia sự kiện, đặc biệt là các giải đấu bóng chày.

		 Sau cơ hội đến Mỹ ném bóng mở màn cho đội bóng chày New York Yankees. Mới đây, aespa tiếp tục “bén duyên” với một sự kiện bóng chày vô cùng quan trọng tại quê hương Hàn Quốc.

		 aespa khuấy động giải đấu MLB World Tour Seoul Series 2024 bằng loạt hit đình đám

		 Giải bóng chày Major League (MLB) là giải bóng chày nhà nghề Mỹ lâu đời nhất. Mỗi mùa giải bắt đầu với giải mùa xuân và mùa giải năm nay đã chính thức diễn ra với tên gọi MLB World Tour Seoul Series 2024. Bởi đây là lần tiên MLB tổ chức thi đấu ở Hàn Quốc.

		 Ngày 20/03 vừa qua, trận khai mạc giữa Los Angeles Dodgers và San Diego Padres đã chính thức diễn ra tại sân vận động Gocheok Sky Dome, Seoul. Với nhiều người dân Hàn Quốc, dù không phải là fan của môn thể thao này, sự kiện này vẫn là một niềm tự hào vì nhiều cầu thủ bóng chày nổi tiếng xứ này hiện đang chơi cho đội Los Angeles Dodgers.

		 Chính vì vậy, việc aespa xác nhận biểu diễn tại trận khai mạc MLB World Tour Seoul Series 2024 đã đánh dấu một cột mốc quan trọng trong sự nghiệp của họ. Không làm người hâm mộ thất vọng, 4 thành viên nhà SM dường như đã biến trận mở màn mùa giải giữa Los Angeles Dodgers và San Diego Padres trông giống Super Bowl với những tiết mục không thể bùng nổ hơn.

		 Nhóm nhạc nữ nhà SM đã chọn 2 bài hát nổi tiếng với giai điệu sôi động là Drama và Next Level để có thể khoe trọn vẹn vũ đạo điêu luyện của mình. Đám đông dưới khán đài đáp trả năng lượng của nhóm khi dành cho bốn cô gái nhiều tràng hò reo cổ vũ.

		 Có thể thấy, nếu nhiệm vụ của aespa là khuấy động không khí một trận đấu thể thao thì họ đã hoàn toàn thành công và biến sân vận động Gocheok Sky Dome thành một lễ hội âm nhạc.

		 Đây không phải là lần đầu tiên aespa gây tiếng vang trong thế giới thể thao. Vào tháng Sáu năm ngoái, nhóm cũng gây chú ý khi họ đến sân vận động Yankee ở New York để ném cú ném đầu tiên trong trận đấu giữa New York Yankees và Chicago White Sox. Các thần tượng của SM đã thể hiện sức ảnh hưởng toàn cầu trong nhiều lĩnh vực, không chỉ có âm nhạc hay thời trang.

		 Ngoài ra, người hâm mộ còn vô cùng bất ngờ khi thành viên Baekhyun (EXO) cũng xuất hiện để thể hiện phần quan trọng không kém trong các trận đấu: Hát quốc ca Hàn Quốc và Mỹ. Ít ai biết rằng, đây đã là lần thứ 3 nam thần tượng được tin tưởng giao trọng trách này. Lần đầu tiên là vào năm 2013, trong trận bóng đá giao hữu quốc tế giữa Hàn Quốc và Peru. Lần thứ 2 là tại buổi họp mặt của Ủy ban Olympic Quốc tế ở Pyeongchang năm 2018.

		 Sôi động không kém sân khấu chính chính là phía khán đài khi chứng kiến cuộc “đổ bộ” của nhiều ngôi sao nổi tiếng khác đến theo dõi trận đấu. G-Dragon và Daesung nhanh chóng trở thành tâm điểm khi ngồi ở khu vực VIP và gặp gỡ Park Chan Ho, người ném cú ném đầu tiên trong ngày khai màn MLB.

		 “Cặp vợ chồng quốc dân” Son Ye Jin và Hyun Bin đã có buổi hẹn hò nhóm cùng hai nam thần của phim Yêu tinh là Gong Yoo và Lee Dong Wook tại sự kiện náo nhiệt này. Khoảnh khắc cả 4 ngôi sao xuất hiện trong một khung hình đã trở thành chủ đề được tìm kiếm nhiều nhất trên MXH hôm nay.

		 Trong khi đó, “mỹ nam” Cha Eun Woo lại gây sốt với vẻ điển trai khi thưởng thức trận đấu. Trong chiếc mũ LA Dodgers, nam thần tượng thoải mái tạo dáng chữ V và nhâm nhi một ly bia.

		 Ngoài những gương mặt kể trên, những cặp đôi khác như Jiyeon và Hwang Jae Gyun, Lee Bo Young và Ji Sung hay Ok Taecyeon, Sean, Kim Young Cheol… cũng không bỏ lỡ cơ hội để đón xem những trận bóng chày vô cùng hấp dẫn này.',
		 'https://bazaarvietnam.vn/wp-content/uploads/2024/03/aespa-bieu-dien-tai-MLB-World-Tour-Seoul-Series-2024.jpg',
		 1,
		 'aespa-lien-tuc-duoc-cac-giai-bong-chay-moi-bieu-dien-lan-nay-la-mlb-world-tour-seoul-series-2024'),

		(7, 5, 2,
		 N'Huỳnh Tú Anh vừa góp mặt trên sàn diễn Chanel Cruise 2025/26, tổ chức tại Singapore vào ngày 4/11 vừa qua. Thành tích này càng ấn tượng hơn khi Tú Anh mới chỉ theo đuổi con đường người mẫu chuyên nghiệp được khoảng vài năm.',
		 N'Trưởng thành từ chương trình thực tế, ngay từ khi bước chân vào sự nghiệp người mẫu, Huỳnh Tú Anh đã nghiêm ngặt quản lý và giữ gìn vóc dáng để theo đuổi đam mê. Nhờ sự kỷ luật đó, cô nhanh chóng trở thành một gương mặt nổi bật với chiều cao 1m78 cùng thần thái cuốn hút và gương mặt đậm chất Á Đông.

		 Năm 2021, Tú Anh chính thức chạm ngõ làng mốt khi chủ động tìm kiếm cơ hội catwalk và chụp hình cho các thương hiệu Việt. Sau giai đoạn miệt mài trau dồi, năm 2023, cô quyết định bước vào một cột mốc quan trọng: tham gia The Face Vietnam 2023 và trở thành Quán quân The Face Vietnam 2023.

		 Những lần ghi dấu trên bản đồ thời trang quốc tế

		 Chiến thắng tại The Face Vietnam 2023 đã mở ra cho Tú Anh nhiều cơ hội quý giá, và cô gái trẻ không bỏ lỡ bất kỳ khoảnh khắc nào để bứt phá.

		 Bước sang năm 2024, với sự hỗ trợ từ BeU Models, Tú Anh tiếp tục khẳng định năng lực của mình và chính thức đầu quân cho Supreme Model Management tại Paris, London, New York, cùng Major Model tại Milan. Quyết định này trở thành bước ngoặt quan trọng, đánh dấu giai đoạn Tú Anh bắt đầu sự nghiệp người mẫu quốc tế với khát vọng mang bản sắc Á Đông tỏa sáng trên các sàn diễn toàn cầu.

		 Tháng 9/2024, cô chính thức có sàn diễn quốc tế đầu tiên cho thương hiệu Calcaterra trong khuôn khổ Tuần lễ thời trang Milan Xuân – Hè 2025. Không dừng lại ở đó, cô tiếp tục xuất hiện trong Paris Fashion Week cùng các nhà mốt Leonard Paris và Hodakova, chứng minh năng lực thích ứng linh hoạt và phong độ ổn định dù là gương mặt mới trên bản đồ thời trang thế giới.

		 Cùng thời điểm này, Tú Anh một lần nữa khiến giới mộ điệu tự hào khi trở thành người mẫu Việt đầu tiên xuất hiện trên bìa chính bản của Vogue Singapore, số tháng 10/2024, bên cạnh các người mẫu đến từ Malaysia, Singapore và Indonesia.

		 Thừa thắng xông lên, Tú Anh ghi dấu với loạt sàn diễn quốc tế trong năm 2025

		 Sau những tiếp xúc đầu tiên, Tú Anh thể hiện rõ mình nhận được sự tin tưởng của các nhà mốt quốc tế, khi một lần nữa, trong tháng thời trang Xuân Hè 2026, cô trở lại kinh đô thời trang Milan để góp mặt trên sàn diễn của năm thương hiệu danh tiếng: Peserico, Sara Wong, Calcaterra, Barbara và Circle Show.

		 Cô còn là gương mặt mẫu Việt duy nhất chụp lookbook cho thương hiệu Diesel và Blauer trong Tuần lễ thời trang Milan Xuân Hè 2026.

		 Tháng 11/2025, Tú Anh khiến giới mộ điệu Việt tự hào khi trở thành người mẫu Việt đầu tiên catwalk cho buổi trình diễn chính thức của Chanel. Trước ống kính truyền thông quốc tế, Tú Anh ghi điểm với thần thái tự tin và những bước catwalk vững vàng, lột tả được tinh thần thương hiệu.

		 Tú Anh cho biết, để có cơ hội trình diễn cho Chanel, cô đã phải trải qua nhiều vòng casting khắt khe và đã thất bại trong lần thử sức đầu tiên, nhưng cô không bỏ cuộc. Cô kiên trì gửi lại hồ sơ và video trình diễn cho đợt tuyển chọn mới và cuối cùng gặt hái được trái ngọt. Để đạt trạng thái tốt khi trình diễn, tỏa sáng trong vài phút ít ỏi, Tú Anh cũng duy trì chế độ tập luyện và ăn uống nghiêm ngặt.

		 Hình ảnh của Tú Anh tại sàn diễn Chanel Cruise 2025/26 là minh chứng cho bước tiến mới của thế hệ người mẫu trẻ Việt Nam. Trong chặng hành trình dấn thân vào nghề tuy chưa dài, cô gái trẻ đã có những thành tích đáng tự hào, thể hiện những phẩm chất cần phát huy của người mẫu Việt: cầu tiến, quyết tâm và biết nắm bắt cơ hội. Thành công hôm nay cũng là minh chứng rõ nét cho khát vọng mà cô từng chia sẻ từ những ngày còn là thí sinh The Face Vietnam 2023: “Mang vẻ đẹp Việt đến với thế giới.”',
		 'https://static.elle.vn/img/B6Yx4-TV284ld0llPYL6mSyvGaRuJhOTcofH1MW9WAk/rs:fit:0:0/min-height:300/plain/http://www.elle.vn/app/uploads/2025/11/06/711736/tu-anh-chanel-cruise-2025.jpg@webp',
		 1,
		 'huynh-tu-anh-tu-quan-quan-the-face-vietnam-2023-den-mau-viet-dau-tien-catwalk-cho-show-chanel-cruise'),

		(8, 6, 3,
		 N'Ngày 4/11, Chanel tổ chức show Cruise 2025/26 tại Singapore, trở thành nơi gặp gỡ của nhiều ngôi sao hàng đầu Tbiz.',
		 N'Sau màn ra mắt tại Villa d’Este, show diễn Cruise 2025/26 của Chanel tiếp tục neo đậu tại Singapore, mở lối cho cuộc hội ngộ của những tài năng Đông Nam Á. Trên sàn diễn, quán quân The Face Vietnam 2023 Huỳnh Tú Anh là mẫu Việt đầu tiên catwalk cho show chính thức của nhà mốt hoa trà. Trên hàng ghế khách mời, hàng loạt ngôi sao Thái có sức ảnh hưởng bậc nhất trong khu vực khuấy đảo truyền thông cho CHANEL.

		 Khoác trên mình trang phục đến từ chính BST Chanel Cruise 2025/26 trình làng lần đầu hồi cuối tháng 4/2025, diện mạo của Becky Armstrong là bài học mẫu mực về phối kết trang phục ton-sur-ton và khả năng thiên biến vạn hoá của sắc đen.

		 Chiếc áo khoác dáng lửng – phom dáng kinh điển của Chanel – trở nên nhẹ nhàng và phóng khoáng hơn nhờ chất liệu ren hoa. Những đường viền trắng mềm mại chạy dọc mép áo và túi tạo hiệu ứng đồ hoạ tinh tế, giúp tổng thể trang phục vừa thanh lịch vừa dễ ứng dụng khi di chuyển. Dưới lớp áo cầu kỳ là áo hai dây tối giản, điểm xuyết bằng khóa vuông, mang lại cảm giác thoải mái nhưng vẫn giữ được vẻ tinh tế đặc trưng của nhà mốt. Becky chọn quần ống loe lưng cao, giúp tôn dáng và tăng sự thoải mái cho những bước đi dài trên phố.

		 Phụ kiện được tiết chế tinh khéo: hoa tai Coco Crush đồng điệu với túi da chần hoạ tiết quả trám, và đồng hồ Première. Đây đều là những món đồ nhỏ gọn nhưng đa dụng, có thể kết hợp linh hoạt với nhiều outfit khác nhau. Chính sự tinh giản và đồng điệu ấy giúp Becky trở thành hình mẫu hoàn hảo cho phong cách du lịch nhẹ nhàng mà vẫn toát lên phong thái thanh lịch, nữ tính.

		 Diện trang phục từ BST đầu tay của GĐST Matthieu Blazy – Chanel Xuân Hè 2026, thay cho tinh thần du ngoạn của BST Cruise như Becky, rung cảm chung từ tạo hình của nam diễn viên, ca sĩ Gemini Norawit vẫn toát lên tinh thần nghỉ dưỡng của giới thượng lưu khi cân bằng hoàn hảo giữa sự thanh lịch và cảm giác thoải mái.

		 Nền tảng của trang phục là chiếc áo polo kéo khoá, một món đồ kinh điển thể hiện tinh thần “quiet luxury” – sang trọng trong sự giản dị. Phần cổ áo mang hơi hướng thể thao cổ điển, đủ thanh lịch để xuất hiện trong sảnh khách sạn nhưng vẫn phù hợp cho khoảnh khắc thư giãn trên boong tàu – gợi nên hình ảnh người đàn ông yêu thích sự thoải mái nhưng không bao giờ lơi là vẻ ngoài.

		 Chiếc quần đóng vai trò cân bằng tổng thể khi mang đến cảm giác hiện đại, vững chãi. Phom dáng relaxed fit đủ gọn để trông chỉn chu, nhưng vẫn giữ được độ rủ tự nhiên, biểu hiện đúng tinh thần ăn vận đẹp không cần gồng gánh.

		 Tương tự như Becky, Gemini cũng là tín đồ của trang sức Coco Crush tối giản và những cỗ máy thời gian thu nhỏ từ CHANEL. Chiếc J12 38mm trên cổ tay nâng tầm toàn bộ bản phối đơn giản bằng sự tinh xảo, vững vàng và lịch thiệp. Tổng thể gợi thông điệp rõ nét về gu thẩm mỹ của Gemini trước sự phù phép của nhà mốt: Không phô trương nhưng luôn toát lên đẳng cấp của một người đàn ông biết tận hưởng, am hiểu phong cách và luôn chọn sự thoải mái trong khuôn khổ của tinh tế.',
		 'https://bazaarvietnam.vn/wp-content/uploads/2025/11/bzvn-thumb-chanel-cruise-2025-26-becky-gemini.jpg',
		 1,
		 'di-show-chanel-becky-armstrong-gemini-norawit-goi-y-phong-cach-thoi-trang-nghi-duong-thuong-luu'),

		(9, 7, 1,
		 N'Với chuỗi 5 năm liên tiếp, Jennie (BLACKPINK) một lần nữa chứng minh sức ảnh hưởng toàn cầu của mình không chỉ trong lĩnh vực âm nhạc mà còn cả thời trang.',
		 N'Trong thế giới thời trang cao cấp, việc một biểu tượng được “giữ streak” suốt nhiều năm liền là minh chứng rõ ràng nhất cho mối quan hệ cộng sinh hoàn hảo giữa cá nhân và nhà mốt. Jennie Kim và Chanel Coco Crush chính là một mối quan hệ như thế: bền bỉ, chiến lược và ngày càng thăng hoa theo thời gian.

		 Suốt 5 năm, Jennie và Chanel Coco Crush vẫn đồng hành

		 Mới đây, Chanel đã chính thức công bố gương mặt đại diện cho chiến dịch toàn cầu Chanel Coco Crush năm 2026. Không nằm ngoài dự đoán, Jennie (BLACKPINK) tiếp tục góp mặt trong chiến dịch lần này. Đồng thời, nàng idol cũng mở khóa chuỗi 5 năm đồng hành cùng các chiến dịch toàn cầu của BST. Chiến dịch sẽ chính thức được ra mắt vào ngày 13/1 phạm vi toàn cầu.

		 Lần trở lại này của Jennie còn đánh dấu một cột mốc đặc biệt khi là năm thứ năm liên tiếp cô giữ vai trò gương mặt đại diện toàn cầu cho dòng trang sức Coco Crush. Trong bối cảnh các nhà mốt xa xỉ ngày càng khắt khe trong việc lựa chọn đại sứ, điều này đã thể hiện sự tin tưởng tuyệt đối mà Chanel dành cho nàng It Girl đến từ Hàn Quốc.

		 Trong loạt hình ảnh vừa được công bố, Jennie xuất hiện với thần thái vừa kiêu kỳ vừa phóng khoáng, khoác lên mình những thiết kế mang ADN đặc trưng của dòng Coco Crush. Đó là vòng cổ choker có thể điều chỉnh linh hoạt, khuyên tai đa năng có thể biến hóa theo nhiều cách đeo khác nhau, và những chiếc nhẫn xếp lớp. Tất cả đều được chế tác từ beige gold trứ danh của Chanel.

		 Jennie khoe khéo Crush ở mọi nơi

		 Việc Chanel “chọn mặt gửi vàng” Jennie suốt 5 năm liền không phải là điều ngẫu nhiên. Ngoài sức hút truyền thông và giá trị thương mại khổng lồ mà cô mang lại, Jennie còn là một trong số ít đại sứ thực sự sống cùng sản phẩm.

		 Một trong những ví dụ điển hình nhất chính là khoảnh khắc tạo trend “nhẫn làm phụ kiện tóc” từng gây bão mạng xã hội. Năm 2024, tại buổi tiệc khai trương pop-up Chanel Coco Crush ở Seoul, Jennie xuất hiện trong diện mạo “dát vàng dát bạc” đúng nghĩa.

		 Chiếc váy dệt kim đen siêu ngắn, vá monogram Chanel, dây chuyền dài mặt đồng hồ và khuyên mũi đã đủ để tạo nên một tổng thể nổi bật. Nhưng điểm nhấn khiến giới mộ điệu không thể rời mắt chính là những chiếc nhẫn Coco Crush được khéo léo luồn vào bím tóc.

		 Cách làm đẹp này vừa xa xỉ, vừa ngẫu hứng, thể hiện rõ tinh thần tự do mà Coco Crush đại diện. Họa tiết quả trám chần bông khi được đặt ở vị trí trung tâm như mái tóc, trở nên sống động và đầy tính thời trang. Trào lưu này nhanh chóng được người hâm mộ và fashionista khắp nơi hưởng ứng, một lần nữa củng cố danh xưng Jensetter của cô nàng.

		 Nguồn cảm hứng bất tận từ Coco Crush

		 Coco Crush mang trong mình một câu chuyện lịch sử kéo dài hơn một thế kỷ. Nguồn cảm hứng của bộ sưu tập bắt nguồn từ năm 1906, khi Gabrielle Chanel lần đầu chú ý đến họa tiết chần bông trên chăn và áo khoác của các kỵ sĩ trong chuồng ngựa của Étienne Balsan. Từ một chi tiết rất đời thường, nay trở thành biểu tượng gắn liền với Chanel, xuất hiện xuyên suốt trong các thiết kế thời trang, túi xách và nội thất từ thập niên 1920.

		 Đến năm 2015, Chanel lần đầu đưa họa tiết chần bông lên trang sức cao cấp với sự ra đời của Coco Crush. Trên bề mặt kim loại quý, các đường khắc hình học được xử lý mềm mại như những đường bo tròn tinh xảo. Mỗi chi tiết đều được tính toán chính xác, tạo nên sự cân bằng hoàn hảo giữa cứng cáp và uyển chuyển, giữa sức mạnh và nét nữ tính, đúng với tinh thần mà Gabrielle Chanel theo đuổi.

		 Một trong những điểm đặc biệt nhất của Coco Crush chính là sắc vàng be (beige gold) độc quyền của Chanel. Beige gắn liền với những dấu mốc đầu tiên trong sự nghiệp của Gabrielle Chanel, từ vải tweed, len dệt cho đến đôi giày hai tông màu huyền thoại. Khi được ứng dụng vào vàng 18K, beige gold mang đến cảm giác mềm mại như nhung trên làn da, tôn lên vẻ đẹp tự nhiên và sang trọng một cách rất kín đáo.

		 Coco Crush nhanh chóng trở thành một trong những dòng trang sức bán chạy nhất của Chanel, với mức giá trải dài từ 1.500 USD đến 60.000 USD. Dưới sức ảnh hưởng mạnh mẽ của Jennie Kim, bộ sưu tập được mở rộng và đặc biệt chinh phục thế hệ khách hàng trẻ, những người tìm kiếm sự xa xỉ mang tính cá nhân hóa, linh hoạt và gắn liền với phong cách sống.

		 Năm thứ 5 liên tiếp đồng hành cùng Coco Crush, Jennie như trở thành một phần không thể tách rời của câu chuyện. Với streak ấn tượng này, có lẽ hành trình câu chuyện giữa Jennie và Chanel vẫn còn rất dài phía trước.',
		 'https://bazaarvietnam.vn/wp-content/uploads/2024/07/jisoo-va-jennie-blackpink-tao-trend-deo-nhan-len-toc-11.jpg',
		 1,
		 'jennie-blackpink-giu-streak-5-nam-quang-ba-trang-suc-chanel-coco-crush'),

		(10, 8, 2,
		 N'Ca sĩ Hồ Ngọc Hà lên đồ thời thượng theo xu hướng monochrome tại show Gucci Thu Đông 2026 thuộc Milan Fashion Week hôm 27/2.',
		 N'Xuất hiện với vai trò Friend of the House của nhà mốt Gucci, Hồ Ngọc Hà mặc trang phục da lộn màu camel đồng điệu, thuộc bộ sưu tập Pre-Fall 2026. Cô là nghệ sĩ Việt Nam duy nhất góp mặt tại show thời trang này.

		 Mỹ nhân 42 tuổi để tóc xoăn sóng bồng bềnh, hoàn thiện phong cách thanh lịch mà không kém phần sành điệu.',
		 'https://i1-ngoisao.vnecdn.net/2026/03/01/2-ho-ngoc-ha-1772303101.jpg?w=1200&h=0&q=100&dpr=2&fit=crop&s=TejWw0HXZdI0B4rB3ctS-g',
		 1,
		 'ho-ngoc-ha-sanh-dieu-di-show-gucci');

	-- Cập nhật lượt xem và ngày đăng ngẫu nhiên cho bài viết (ngẫu nhiên trong 2 tuần qua tính từ 10/04/2026)
	UPDATE BaiViet
	SET LuotXem = ABS(CHECKSUM(NEWID()) % 450) + 50,
	    NgayDang = DATEADD(SECOND, -1 * (ABS(CHECKSUM(NEWID()) % 1209600)), '2026-04-10 23:59:59')
	WHERE MaBV BETWEEN 3 AND 10;

	SET IDENTITY_INSERT dbo.BaiViet OFF;
	GO

	-- 4.2. NHÂN VIÊN (MaTK=2) nhập kho
	INSERT INTO PhieuNhap (MaNV, MaNCC, TongTien, GhiChu, NgayNhap)
	VALUES
	(1, 1, 0, N'Nhập kho đợt 1', '2026-03-01'),
	(1, 1, 0, N'Nhập kho đợt 2', '2026-03-05'),
	(1, 1, 0, N'Nhập kho đợt 3', '2026-03-10');

	-- Phiếu 1
	-- Phiếu 1
	INSERT INTO NhapKhoChiTiet (MaPN, MaBienThe, SoLuong, DonGiaNhap, ThanhTien)
	SELECT 
		1,
		sp.MaBienThe,
		10,
		sp.GiaNhap,
		10 * sp.GiaNhap
	FROM SanPhamChiTiet sp;

	-- Phiếu 2
	INSERT INTO NhapKhoChiTiet (MaPN, MaBienThe, SoLuong, DonGiaNhap, ThanhTien)
	SELECT 
		2,
		sp.MaBienThe,
		15,
		sp.GiaNhap,
		15 * sp.GiaNhap
	FROM SanPhamChiTiet sp;

	-- Phiếu 3
	INSERT INTO NhapKhoChiTiet (MaPN, MaBienThe, SoLuong, DonGiaNhap, ThanhTien)
	SELECT 
		3,
		sp.MaBienThe,
		8,
		sp.GiaNhap,
		8 * sp.GiaNhap
	FROM SanPhamChiTiet sp;

	-- GHI CHÚ QUAN TRỌNG: Logic cập nhật SoLuongTon và GiaNhap trong SanPhamChiTiet
	-- sẽ được xử lý trong Spring Boot Service, KHÔNG dùng Trigger.
	-- Câu lệnh UPDATE dưới đây chỉ để GIẢ LẬP logic đó cho dữ liệu mẫu:
	UPDATE pn
	SET TongTien = (
		SELECT SUM(ct.ThanhTien)
		FROM NhapKhoChiTiet ct
		WHERE ct.MaPN = pn.MaPN
	)
	FROM PhieuNhap pn;

	UPDATE sp
	SET SoLuongTon = sp.SoLuongTon + ct.SoLuong
	FROM SanPhamChiTiet sp
	JOIN NhapKhoChiTiet ct 
		ON sp.MaBienThe = ct.MaBienThe;

	-- 4.3. KHÁCH HÀNG (MaTK=3)
	-- 4.3.1. Địa chỉ của khách
	SET IDENTITY_INSERT dbo.SoDiaChi ON;
	INSERT INTO SoDiaChi
	(MaDiaChi, MaTK, HoTenNguoiNhan, SoDienThoai, DiaChiChiTiet, GhiChu, LaMacDinh)
	VALUES
		(1, 3, N'Nguyễn Hải Nam', '0937567328', N'456 Đường Trường Chinh, Q.Tân Phú, TP.HCM', N'Nhà riêng', 1),
		(2, 3, N'Trần Thị Vợ Khách', '0900000004', N'456 Đường Hậu Giang, Q.6, TP.HCM', N'Cổng sau, lầu 2', 0),
		(3, 1, N'Nhật Phong', '0967328210', N'139 Đường Lê Thái Tông, Q.1, TP.HCM', N'Văn phòng công ty', 1),
		(4, 2, N'Liễu Như Yên', '0985278367', N'10 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh', N'Nhà riêng', 1),
		(5, 4, N'Nguyễn Đình Triệu', '0399777450', N'15 Trần Phú, Quận Hải Châu, Đà Nẵng', N'Nhà riêng', 1),
		(6, 5, N'Vũ Minh Thuận', '0984164050', N'88 Nguyễn Chí Thanh, Quận Đống Đa, Hà Nội', N'Nhà riêng', 1),
		(7, 6, N'Nguyễn Thị Phương Uyên', '0984165060', N'22 Lạch Tray, Quận Ngô Quyền, Hải Phòng', N'Văn phòng', 1),
		(8, 7, N'Lê Văn Khách', '0984165061', N'50 Hùng Vương, Thành phố Cần Thơ', N'Nhà riêng', 1),
		(9, 8, N'Lê Bá Tuấn Vỹ', '090245924', N'12 Phan Bội Châu, Thành phố Huế', N'Nhà riêng', 1),
		(10, 9, N'Nguyễn Thị Nhân Viên', '0985278367', N'300 Thống Nhất, Thành phố Nha Trang', N'Cửa hàng', 1);
	SET IDENTITY_INSERT dbo.SoDiaChi OFF;
	GO

	-- Cập nhật lượt dùng ngẫu nhiên cho Voucher
	UPDATE Voucher SET DaSuDung = ABS(CHECKSUM(NEWID()) % 15) WHERE Code NOT IN ('NEWYEAR', 'SUMMER26');
	UPDATE Voucher SET DaSuDung = 90 WHERE Code = 'NEWYEAR';
	UPDATE Voucher SET DaSuDung = SoLuong WHERE Code = 'SUMMER26';
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
		(5, N'Đã hủy'),
		(6, N'Đã đánh giá'),
		(7, N'Chờ thanh toán'),
		(8, N'Lỗi thanh toán');
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
		 -- 1. Đơn hàng Chờ xác nhận (Trạng thái 0)
	INSERT INTO DonHang (MaDH, MaTK, NgayDat, TongTien, PhiShip, MaDiaChiGiao, MaHinhThucTT, TrangThaiDH, TrangThaiThanhToan, NgayCapNhat)
	VALUES (2, 4, GETDATE(), 15000000.00, 30000.00, 1, 1, 0, 0, GETDATE());

	-- 2. Đơn hàng Đã xác nhận (Trạng thái 1)
	INSERT INTO DonHang (MaDH, MaTK, NgayDat, TongTien, PhiShip, MaDiaChiGiao, MaHinhThucTT, TrangThaiDH, TrangThaiThanhToan, NgayCapNhat)
	VALUES (3, 4, GETDATE() - 1, 2500000.00, 20000.00, 1, 1, 1, 0, GETDATE());

	-- 3. Đơn hàng Đang giao (Trạng thái 2)
	INSERT INTO DonHang (MaDH, MaTK, NgayDat, TongTien, PhiShip, MaDiaChiGiao, MaHinhThucTT, TrangThaiDH, TrangThaiThanhToan, NgayCapNhat)
	VALUES (4, 5, GETDATE() - 2, 5400000.00, 40000.00, 1, 1, 2, 0, GETDATE());

	-- 4. Đơn hàng Đã giao (Trạng thái 3)
	INSERT INTO DonHang (MaDH, MaTK, NgayDat, TongTien, PhiShip, MaDiaChiGiao, MaHinhThucTT, TrangThaiDH, TrangThaiThanhToan, NgayCapNhat)
	VALUES (5, 6, GETDATE() - 5, 1200000.00, 15000.00, 1, 1, 3, 1, GETDATE() - 4);

	-- 5. Đơn hàng Đã hủy (Trạng thái 5)
	INSERT INTO DonHang (MaDH, MaTK, NgayDat, TongTien, PhiShip, MaDiaChiGiao, MaHinhThucTT, TrangThaiDH, TrangThaiThanhToan, NgayCapNhat)
	VALUES (6, 5, GETDATE() - 10, 800000.00, 20000.00, 1, 1, 5, 0, GETDATE() - 10);

	-- 6. Đơn hàng Lỗi thanh toán (Trạng thái 6)
	INSERT INTO DonHang (MaDH, MaTK, NgayDat, TongTien, PhiShip, MaDiaChiGiao, MaHinhThucTT, TrangThaiDH, TrangThaiThanhToan, NgayCapNhat)
	VALUES (7, 2, GETDATE(), 20000000.00, 0.00, 1, 2, 6, 0, GETDATE());

	-- 7. Đơn hàng Chờ thanh toán (Trạng thái 7)
	INSERT INTO DonHang (MaDH, MaTK, NgayDat, TongTien, PhiShip, MaDiaChiGiao, MaHinhThucTT, TrangThaiDH, TrangThaiThanhToan, NgayCapNhat)
	VALUES (8, 2, GETDATE(), 3200000.00, 30000.00, 1, 2, 7, 0, GETDATE());

	-- Chèn thêm 20 đơn hàng mới để tăng tính sinh động (MaDH 9 -> 28)
	INSERT INTO DonHang (MaDH, MaTK, NgayDat, TongTien, PhiShip, MaDiaChiGiao, MaHinhThucTT, TrangThaiDH, TrangThaiThanhToan, NgayCapNhat)
	VALUES 
	(9, 3, GETDATE()-1, 15000000.00, 30000, 1, 1, 4, 1, GETDATE()),
	(10, 4, GETDATE()-2, 12000000.00, 0, 1, 2, 4, 1, GETDATE()),
	(11, 5, GETDATE()-3, 8500000.00, 20000, 1, 1, 4, 1, GETDATE()),
	(12, 6, GETDATE()-4, 21000000.00, 30000, 1, 1, 3, 1, GETDATE()),
	(13, 3, GETDATE()-5, 5500000.00, 20000, 1, 2, 3, 1, GETDATE()),
	(14, 4, GETDATE()-6, 3000000.00, 15000, 1, 1, 4, 1, GETDATE()),
	(15, 5, GETDATE()-7, 42000000.00, 0, 1, 2, 4, 1, GETDATE()),
	(16, 6, GETDATE()-8, 18000000.00, 30000, 1, 1, 3, 1, GETDATE()),
	(17, 3, GETDATE()-9, 12500000.00, 20000, 1, 1, 4, 1, GETDATE()),
	(18, 4, GETDATE()-10, 9000000.00, 0, 1, 2, 4, 1, GETDATE()),
	(19, 5, GETDATE()-11, 3500000.00, 15000, 1, 1, 1, 0, GETDATE()),
	(20, 6, GETDATE()-12, 16000000.00, 30000, 1, 2, 2, 0, GETDATE()),
	(21, 3, GETDATE()-13, 24000000.00, 0, 1, 1, 5, 0, GETDATE()),
	(22, 4, GETDATE()-14, 7800000.00, 20000, 1, 1, 4, 1, GETDATE()),
	(23, 5, GETDATE()-15, 11000000.00, 30000, 1, 1, 4, 1, GETDATE()),
	(24, 6, GETDATE()-16, 29000000.00, 0, 1, 2, 4, 1, GETDATE()),
	(25, 3, GETDATE()-17, 14500000.00, 20000, 1, 1, 4, 1, GETDATE()),
	(26, 4, GETDATE()-18, 52000000.00, 0, 1, 2, 4, 1, GETDATE()),
	(27, 5, GETDATE()-19, 13000000.00, 30000, 1, 1, 4, 1, GETDATE()),
	(28, 6, GETDATE()-20, 8900000.00, 20000, 1, 1, 4, 1, GETDATE());

	SET IDENTITY_INSERT dbo.DonHang OFF;
	GO

	-- 4.3.6. Chi tiết đơn hàng cũ
	SET IDENTITY_INSERT dbo.DonHangCT ON;
	INSERT INTO DonHangCT
	(MaCT, MaDH, MaBienThe, SoLuong, DonGia)
	VALUES
		(1, 1, 13, 1, 35000000.00),
		(2, 2, 10, 1, 15000000.00),
		(3, 3, 11, 2, 1250000.00),
		(4, 4, 12, 1, 5400000.00),
		(5, 5, 13, 1, 1200000.00),
		(6, 6, 10, 1, 800000.00),
		(7, 7, 11, 1, 20000000.00),
		(8, 8, 12, 1, 3200000.00),
		-- Bổ sung thêm để làm Review
		(9, 1, 1, 1, 15000000.00),
		(10, 1, 5, 1, 12000000.00),
		(11, 3, 20, 1, 10000000.00),
		(12, 4, 30, 2, 18000000.00),
		(13, 5, 45, 1, 35000000.00),
		(14, 5, 50, 1, 12000000.00),
		(15, 3, 60, 1, 12000000.00),
		(16, 1, 70, 1, 14000000.00),
		(17, 2, 80, 1, 20000000.00),
		(18, 4, 90, 1, 15000000.00),
		(19, 5, 100, 1, 15000000.00),
		(20, 6, 110, 1, 15000000.00),
		(21, 6, 120, 1, 15000000.00),
		(22, 6, 130, 1, 15000000.00),
		(23, 1, 140, 1, 15000000.00),
		(24, 2, 150, 1, 15000000.00),
		(25, 3, 160, 1, 15000000.00),
		(26, 4, 170, 1, 3500000.00),
		(27, 5, 180, 1, 3500000.00),
		(28, 1, 10, 1, 15000000.00),
		(29, 2, 11, 1, 15000000.00),
		(30, 3, 12, 1, 15000000.00),
		-- MaCT 31+ cho Reviews
		(31, 9, 1, 1, 15000000.00),
		(32, 10, 5, 1, 12000000.00),
		(33, 11, 20, 1, 8500000.00),
		(34, 12, 30, 1, 21000000.00),
		(35, 13, 45, 1, 5500000.00),
		(36, 14, 22, 1, 3000000.00),
		(37, 15, 15, 1, 42000000.00),
		(38, 16, 40, 1, 18000000.00),
		(39, 17, 33, 1, 12500000.00),
		(40, 18, 11, 1, 9000000.00),
		(41, 19, 2, 1, 3500000.00),
		(42, 20, 7, 1, 16000000.00),
		(43, 21, 60, 1, 24000000.00),
		(44, 22, 55, 1, 7800000.00),
		(45, 23, 18, 1, 11000000.00),
		(46, 24, 25, 1, 29000000.00),
		(47, 25, 9, 1, 14500000.00),
		(48, 26, 37, 1, 52000000.00),
		(49, 27, 42, 1, 13000000.00),
		(50, 28, 14, 1, 8900000.00),
		(51, 9, 2, 1, 12000000.00),
		(52, 10, 6, 1, 10000000.00),
		(53, 11, 12, 1, 15000000.00),
		(54, 12, 21, 1, 15000000.00),
		(55, 13, 25, 1, 18000000.00),
		(56, 14, 34, 1, 15000000.00),
		(57, 15, 39, 1, 15000000.00),
		(58, 16, 44, 1, 3500000.00),
		(59, 17, 35, 1, 15000000.00),
		(60, 18, 50, 1, 12000000.00);

	SET IDENTITY_INSERT dbo.DonHangCT OFF;
	GO

	-- 4.3.7. Lịch sử đơn hàng cũ
	INSERT INTO LichSuDonHang
		(MaDH, TrangThaiCu, TrangThaiMoi, GhiChu, NguoiCapNhat)
	VALUES
		(1, 0, 1, N'Nhân viên xác nhận đơn', N'Nguyễn Thị Bán Hàng'),
		(1, 1, 2, N'Đang chuẩn bị hàng', N'Nguyễn Thị Bán Hàng'),
		(1, 2, 3, N'Bàn giao cho đơn vị vận chuyển', N'Hệ thống'),
		-- Đơn 3: Đã xác nhận
		(3, 0, 1, N'Hệ thống xác nhận thanh toán', N'Hệ thống'),
		-- Đơn 4: Đang giao
		(4, 0, 1, N'Nhân viên xác nhận', N'Nguyễn Thị Bán Hàng'),
		(4, 1, 2, N'Đã giao cho bưu tá', N'Kho vận'),
		-- Đơn 5: Đã giao
		(5, 0, 1, N'Xác nhận đơn hàng', N'Nguyễn Thị Bán Hàng'),
		(5, 1, 2, N'Đang vận chuyển', N'Hệ thống'),
		(5, 2, 3, N'Khách đã nhận hàng', N'Shipper'),
		-- Đơn 6: Đã hủy
		(6, 0, 5, N'Khách hàng đổi ý', N'Khách hàng'),
		-- Đơn 7: Lỗi thanh toán
		(7, 7, 6, N'Thanh toán qua thẻ thất bại', N'Cổng thanh toán'),
		(1, 3, 4, N'Giao hàng thành công', N'Hệ thống');
	GO

	-- 4.3.8. Khách đánh giá đơn hàng cũ
	SET IDENTITY_INSERT dbo.DanhGia ON;
	INSERT INTO DanhGia
	(MaDG, MaCT, MaTK, NoiDung, Diem)
	VALUES
		(1, 1, 4, N'Áo khoác rất đẹp, hàng chuẩn auth, giao nhanh.', 5),
		(2, 2, 4, N'Sản phẩm tuyệt vời, đóng gói rất kỹ.', 5),
		(3, 3, 5, N'Chất lượng tốt, màu sắc y hình.', 4),
		(4, 4, 5, N'Giao hàng hơi chậm nhưng bù lại hàng rất ưng.', 4),
		(5, 5, 6, N'Giá hơi cao nhưng xứng đáng đồng tiền bát gạo.', 5),
		(6, 6, 6, N'Mặc rất thoải mái, sẽ ủng hộ shop tiếp.', 5),
		(7, 7, 4, N'Thương hiệu này dùng rất bền, thích lắm.', 5),
		(8, 8, 5, N'Thiết kế sang trọng, rất hợp với mình.', 5),
		(9, 9, 6, N'Đã mua nhiều lần và lần nào cũng hài lòng.', 5),
		(10, 10, 4, N'Sản phẩm đúng như mô tả, tư vấn nhiệt tình.', 5),
		(11, 11, 4, N'Hài lòng về chất vụ CSKH của shop.', 5),
		(12, 12, 4, N'Áo polo Gucci mặc rất sang, form chuẩn.', 5),
		(13, 13, 5, N'Màu be rất đẹp, chất vải len mịn.', 5),
		(14, 14, 5, N'Đơn hàng đóng gói cẩn thận, có bọc xốp.', 5),
		(15, 15, 6, N'Quần MLB sport mặc đi tập rất thích.', 4),
		(16, 16, 6, N'Logo in sắc nét, không bị bong tróc.', 5),
		(17, 17, 5, N'Xứng đáng 5 sao cho chất lượng.', 5),
		(18, 18, 4, N'Vừa vặn, thoải mái, shop tư vấn size rất chuẩn.', 5),
		(19, 19, 4, N'Hàng auth nên khác hẳn hàng chợ, rất xịn.', 5),
		(20, 20, 5, N'Váy Chanel mặc đi tiệc rất sang chảnh.', 5),
		(21, 21, 5, N'Màu đen huyền bí, rất tôn dáng.', 4),
		(22, 22, 6, N'Đồ của shop luôn làm mình hài lòng.', 5),
		(23, 23, 4, N'Vải cotton mát, không bị xù lông.', 5),
		(24, 24, 4, N'Shop là địa chỉ tin cậy của mình.', 5),
		(25, 25, 5, N'Cảm ơn shop đã tư vấn nhiệt tình.', 5),
		(26, 31, 3, N'Áo khoác rất xịn, mang vào ai cũng khen.', 5),
		(27, 32, 4, N'Hàng chính hãng, check hidden tag ok nha.', 5),
		(28, 33, 5, N'Style Hàn Quốc rất hợp với mình.', 5),
		(29, 34, 6, N'Màu sắc tuyệt vời, đúng chất luxury.', 5),
		(30, 35, 3, N'Đã giới thiệu cho bạn bè mua cùng.', 5),
		(31, 36, 4, N'Giao hàng nhanh, đóng gói sang chảnh.', 5),
		(32, 37, 5, N'Sẽ ủng hộ shop dài dài.', 5),
		(33, 38, 6, N'Chất vải sờ vào là thấy xịn rồi.', 5),
		(34, 39, 3, N'Size rất chuẩn, mặc lên form đẹp lắm.', 5),
		(35, 40, 4, N'Shop tư vấn rất có tâm.', 5),
		(36, 41, 5, N'Rất hài lòng với dịch vụ.', 5),
		(37, 42, 6, N'Đẹp từng đường kim mũi chỉ.', 5),
		(38, 43, 3, N'Giá cả tương xứng với chất lượng.', 5),
		(39, 44, 4, N'Chuẩn auth, không có gì để chê.', 5),
		(40, 45, 5, N'Giao hàng hỏa tốc luôn, quá đỉnh.', 5),
		(41, 46, 6, N'Túi tote tặng kèm cũng rất xinh.', 5),
		(42, 47, 3, N'Mặc đi tiệc rất sang luôn.', 5),
		(43, 48, 4, N'Đẳng cấp quốc tế.', 5),
		(44, 49, 5, N'Màu này đang hot, may mà còn size.', 5),
		(45, 50, 6, N'Cảm ơn shop nhiều nhé!', 5),
		(46, 51, 3, N'Sản phẩm quá đẹp, không bõ công chờ đợi.', 5),
		(47, 52, 4, N'Chất lượng 10/10.', 5),
		(48, 53, 5, N'Mặc rất thoải mái, không bí bách.', 4),
		(49, 54, 6, N'Đã nhận được hàng, rất ưng ý.', 5),
		(50, 55, 3, N'Phong cách này rất cá tính.', 5),
		(51, 56, 4, N'Hàng chuẩn, full box đầy đủ.', 5),
		(52, 57, 5, N'Màu trắng phối đồ cực dễ.', 5),
		(53, 58, 6, N'Sẽ mua thêm màu đen nữa.', 5),
		(54, 59, 3, N'Đội ngũ hỗ trợ rất nhiệt tình.', 5),
		(55, 60, 4, N'Luxury Shop luôn là lựa chọn số 1.', 5);
	SET IDENTITY_INSERT dbo.DanhGia OFF;
	GO

	-- (Seed data TrangThaiDonHang đã được dời lên trên)

	-- Seed data mẫu cho ThongKe (ngày hiện tại)
	-- Xóa mẫu cũ để chèn lại cho 30 ngày
	DELETE FROM ThongKe;
	INSERT INTO ThongKe (NgayBaoCao, TongDoanhThu, TongDonHang, TongSanPhamBanRa)
	VALUES 
	(DATEADD(day, -29, GETDATE()), 12500000, 2, 3),
	(DATEADD(day, -28, GETDATE()), 8900000, 1, 1),
	(DATEADD(day, -27, GETDATE()), 0, 0, 0),
	(DATEADD(day, -26, GETDATE()), 21000000, 3, 5),
	(DATEADD(day, -25, GETDATE()), 15000000, 1, 2),
	(DATEADD(day, -24, GETDATE()), 32000000, 4, 7),
	(DATEADD(day, -23, GETDATE()), 45000000, 5, 8),
	(DATEADD(day, -22, GETDATE()), 12000000, 2, 2),
	(DATEADD(day, -21, GETDATE()), 0, 0, 0),
	(DATEADD(day, -20, GETDATE()), 18500000, 2, 4),
	(DATEADD(day, -19, GETDATE()), 25000000, 3, 5),
	(DATEADD(day, -18, GETDATE()), 31000000, 3, 6),
	(DATEADD(day, -17, GETDATE()), 42000000, 4, 9),
	(DATEADD(day, -16, GETDATE()), 55000000, 6, 12),
	(DATEADD(day, -15, GETDATE()), 28000000, 3, 4),
	(DATEADD(day, -14, GETDATE()), 19000000, 2, 3),
	(DATEADD(day, -13, GETDATE()), 15000000, 1, 1),
	(DATEADD(day, -12, GETDATE()), 48000000, 5, 10),
	(DATEADD(day, -11, GETDATE()), 62000000, 7, 15),
	(DATEADD(day, -10, GETDATE()), 33000000, 3, 5),
	(DATEADD(day, -9, GETDATE()), 21000000, 2, 4),
	(DATEADD(day, -8, GETDATE()), 14000000, 1, 2),
	(DATEADD(day, -7, GETDATE()), 52000000, 5, 8),
	(DATEADD(day, -6, GETDATE()), 35000000, 4, 6),
	(DATEADD(day, -5, GETDATE()), 41000000, 4, 7),
	(DATEADD(day, -4, GETDATE()), 29000000, 3, 5),
	(DATEADD(day, -3, GETDATE()), 78000000, 8, 18),
	(DATEADD(day, -2, GETDATE()), 45000000, 5, 9),
	(DATEADD(day, -1, GETDATE()), 38000000, 4, 7),
	(CAST(GETDATE() AS DATE), 25000000, 3, 5);
	GO

	GO

	-- Bổ sung dữ liệu cho BinhLuan
	INSERT INTO BinhLuan (MaSP, MaBV, MaTK, NoiDung, NgayBinhLuan, PhanHoiAdmin, NgayPhanHoiAdmin) VALUES
	-- Bình luận sản phẩm (Gucci)
	(1, NULL, 4, N'Sản phẩm này còn size M màu trắng không shop?', GETDATE(), N'Dạ còn bạn nhé, bạn đặt hàng ngay để shop giữ hàng cho bạn ạ!', GETDATE()),
	(2, NULL, 5, N'Áo này giặt máy có bị giãn không?', GETDATE(), N'Chào bạn, chất liệu cotton piquet cao cấp nên rất bền form, tuy nhiên shop khuyên bạn nên giặt tay hoặc dùng túi giặt để giữ áo bền nhất nhé.', GETDATE()),
	(5, NULL, 6, N'Màu vàng này bên ngoài có đậm hơn hình không?', GETDATE(), N'Dạ màu sắc thực tế giống 95-98% hình ảnh tùy điều kiện ánh sáng ạ.', GETDATE()),
	(10, NULL, 4, N'Shop ơi mình 1m75 nặng 70kg thì mặc size nào?', GETDATE(), N'Dạ với chiều cao cân nặng này bạn mặc size L là đẹp nhất ạ!', GETDATE()),

	-- Bình luận bài viết
	-- Bình luận bài viết
	(NULL, 3, 4, N'Bài viết rất hay, giúp mình hiểu thêm về Demna.', GETDATE(), N'Cảm ơn bạn đã quan tâm đến tin tức của Luxury Shop!', GETDATE()),
	(NULL, 5, 6, N'Hóng store MLB mở thêm ở Hà Nội quá!', GETDATE(), N'Dạ shop cũng đang có kế hoạch mở rộng, bạn chờ tin vui từ shop nhé!', GETDATE()),

	-- Chèn thêm bình luận cho bài viết và sản phẩm (Dòng 7-26)
	(22, NULL, 3, N'Cái này có size cho nam không shop?', GETDATE(), N'Dạ mã này bản Unisex nên nam nữ đều mặc được ạ!', GETDATE()),
	(25, NULL, 4, N'Màu trắng có bị xuyên thấu không ạ?', GETDATE(), N'Chất vải dày dặn nên không lo bị lộ đâu bạn nhé.', GETDATE()),
	(30, NULL, 5, N'Áo khoác này mặc mùa đông Hà Nội ổn không?', GETDATE(), N'Dạ áo này giữ nhiệt cực tốt, phù hợp đại hàn luôn ạ.', GETDATE()),
	(35, NULL, 6, N'Tư vấn giúp mình size áo sơ mi với mình 65kg.', GETDATE(), N'Dạ 65kg bạn mặc size M là vừa in luôn ạ.', GETDATE()),
	(40, NULL, 3, N'Váy này còn màu đỏ không shop?', GETDATE(), N'Dạ mẫu này shop chỉ còn đen và be thôi ạ.', GETDATE()),
	(NULL, 4, 3, N'Bộ sưu tập mới của Gucci đỉnh thật sự!', GETDATE(), N'Đúng vậy ạ, thiết kế lần này rất đột phá.', GETDATE()),
	(NULL, 6, 4, N'Xem MV thấy Aespa mặc đồ MLB đẹp quá trời.', GETDATE(), N'Dạ đồ MLB rất hợp vibe cá tính như Aespa ạ.', GETDATE()),
	(NULL, 7, 5, N'Tự hào người mẫu Việt vươn tầm quốc tế.', GETDATE(), N'Luxury Shop cũng rất tự hào khi được đồng hành cùng xu hướng thế giới ạ.', GETDATE()),
	(NULL, 8, 6, N'Show Chanel ở Singapore hoành tráng quá.', GETDATE(), N'Dạ Chanel luôn biết cách làm giới mộ điệu bất ngờ ạ.', GETDATE()),
	(NULL, 9, 3, N'Jennie mặc cái gì cũng thành trend hết.', GETDATE(), N'Quả thực sức ảnh hưởng của Jennie là không bàn cãi ạ.', GETDATE()),
	(1, NULL, 4, N'Áo polo này co giãn tốt không shop?', GETDATE(), N'Chất vải piquet co giãn 4 chiều cực thoải mái bạn nha.', GETDATE()),
	(3, NULL, 3, N'Ship về Hải Phòng mất bao lâu ạ?', GETDATE(), N'Dạ tầm 2-3 ngày là bạn nhận được hàng ạ.', GETDATE()),
	(5, NULL, 4, N'Shop có cho kiểm tra hàng trước khi thanh toán không?', GETDATE(), N'Dạ có ạ, bạn được đồng kiểm cùng shipper nhé.', GETDATE()),
	(7, NULL, 5, N'Mẫu quần này phối với giày sneaker nào hợp?', GETDATE(), N'Bạn phối với Chunky Sneaker của MLB là bao ngầu luôn ạ.', GETDATE()),
	(12, NULL, 6, N'Áo khoác này có mũ không vậy?', GETDATE(), N'Dạ mẫu này thiết kế cổ đứng không mũ bạn nhé.', GETDATE()),
	(15, NULL, 3, N'Mình muốn mua làm quà tặng shop có hộp không?', GETDATE(), N'Dạ có hộp và túi giấy sang trọng đi kèm bạn nha.', GETDATE()),
	(18, NULL, 4, N'Sơ mi này ủi có khó không ạ?', GETDATE(), N'Vải cotton lụa ít nhăn nên chỉ cần ủi nhẹ là phẳng ạ.', GETDATE()),
	(20, NULL, 5, N'Váy này mặc đi cưới có hợp không shop?', GETDATE(), N'Tiểu thư sang chảnh lắm ạ, bạn chọn màu be là hợp nhất.', GETDATE()),
	(42, NULL, 6, N'Túi này đựng vừa laptop 13 inch không?', GETDATE(), N'Dạ vừa khít luôn bạn nhé, rất tiện đi làm ạ.', GETDATE()),
	(45, NULL, 3, N'Feedback cho shop là hàng rất đẹp, 10 điểm!', GETDATE(), N'Cảm ơn bạn rất nhiều, hy vọng bạn sẽ tiếp tục ủng hộ shop.', GETDATE());

	-- Bổ sung dữ liệu cho ThanhToan (Log giao dịch)
	INSERT INTO ThanhToan (MaDH, SoTien, TrangThai, Gateway, TransactionID, NgayTao) VALUES
	(1, 35030000.00, 'COMPLETED', 'COD', 'COD-123456', GETDATE() - 7),
	(5, 1215000.00, 'COMPLETED', 'PayOS', 'PAYOS-888999', GETDATE() - 5),
	(7, 20000000.00, 'FAILED', 'PayOS', 'PAYOS-ERR-111', GETDATE()),
	(8, 3230000.00, 'PENDING', 'PayOS', 'PAYOS-PEN-222', GETDATE());

	-- Bổ sung dữ liệu cho HinhAnhSP (Gallery ảnh phụ)
	INSERT INTO HinhAnhSP (MaSP, DuongDan) VALUES
	(1, 'https://media.gucci.com/style/DarkGray_Center_0_0_490x490/1685372400/745249_XJF4M_9037_002_100_0000_Light.jpg'),
	(1, 'https://media.gucci.com/style/DarkGray_Center_0_0_490x490/1685372403/745249_XJF4M_9037_003_100_0000_Light.jpg'),
	(2, 'https://media.gucci.com/style/DarkGray_Center_0_0_490x490/1572949803/598949_XJB0Q_9247_002_100_0000_Light.jpg'),
	(3, 'https://media.gucci.com/style/DarkGray_Center_0_0_490x490/1675333503/739954_XKC90_9275_002_100_0000_Light.jpg'),
	(10, 'https://media.gucci.com/style/DarkGray_Center_0_0_490x490/1675333503/737363_XJFG2_2100_002_100_0000_Light.jpg');

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

	USE LuxuryFashion_2026;
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



-- 1. Thêm cột trước
ALTER TABLE Voucher ADD HienThi BIT DEFAULT 1;
GO

-- 2. Cập nhật dữ liệu sau khi cột đã được tạo
UPDATE Voucher SET HienThi = 1;
GO


-- Đảm bảo bảng DonHang có cột GiamGia để tính toán thống kê
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('DonHang') AND name = 'GiamGia')
BEGIN
    ALTER TABLE DonHang ADD GiamGia DECIMAL(18, 2) DEFAULT 0;
END
