# HƯỚNG DẪN CHẠY DỰ ÁN LUXURY FASHION E-COMMERCE

## ⚠️ YÊU CẦU HỆ THỐNG
- **Java 17** trở lên
- **Maven 3.6+**
- **SQL Server 2019+** (hoặc SQL Server Express)
- **IDE**: IntelliJ IDEA / Eclipse / VS Code

---

## 📥 BƯỚC 1: CLONE DỰ ÁN
```bash
git clone https://github.com/Namnguyenh0210/Luxury_Shop.git
cd Luxury_Shop
```

---

## 🗄️ BƯỚC 2: CÀI ĐẶT DATABASE

### 2.1. Tạo Database
Mở SQL Server Management Studio (SSMS) hoặc Azure Data Studio, sau đó chạy file **`db.sql`**

**Cách 1: Dùng SSMS**
- Mở file `db.sql`
- Bấm Execute (F5)

**Cách 2: Dùng Command Line**
```bash
sqlcmd -S localhost -U sa -P YOUR_PASSWORD -i db.sql
```

### 2.2. Kiểm tra Database đã tạo thành công
Database tên: **`LuxuryFashion_2025`**

Các bảng quan trọng:
- `TaiKhoan` (có sẵn tài khoản test)
- `SanPham`, `SanPhamChiTiet`
- `GioHang`, `GioHangChiTiet`
- `DonHang`, `DonHangChiTiet`
- `VaiTro`, `ThuongHieu`, `LoaiSanPham`...

---

## ⚙️ BƯỚC 3: CẤU HÌNH APPLICATION.PROPERTIES

### 3.1. File đã có sẵn trong `src/main/resources/application.properties`

### 3.2. **CẦN SỬA GÌ?**

#### ✅ BẮT BUỘC: Sửa thông tin Database (nếu khác)
```properties
# Dòng 13-15 trong application.properties
spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=LuxuryFashion_2025;encrypt=false;trustServerCertificate=true
spring.datasource.username=sa
spring.datasource.password=Aa@123456    # ← SỬA MẬT KHẨU SQL SERVER CỦA BẠN
```

**Lưu ý:**
- Nếu SQL Server của bạn dùng port khác 1433, sửa trong URL
- Nếu tên database bạn đổi khi chạy db.sql, sửa `databaseName=...`

#### ⚠️ TÙY CHỌN: Google OAuth (KHÔNG BẮT BUỘC)

**Mặc định: Google login đã bị TẮT (đã comment out)**

File `application.properties` dòng 70-82 đã comment out. **Bạn có thể bỏ qua phần này!**

**Nếu muốn BẬT tính năng "Đăng nhập bằng Google":**
1. Vào https://console.cloud.google.com/apis/credentials
2. Tạo OAuth 2.0 Client ID
3. Thêm redirect URI: `http://localhost:8080/login/oauth2/code/google`
4. Lấy Client ID và Client Secret
5. Uncomment và điền vào `application.properties`:

```properties
# Bỏ dấu # ở đầu các dòng này và điền thông tin của bạn
spring.security.oauth2.client.registration.google.client-id=YOUR_CLIENT_ID_HERE
spring.security.oauth2.client.registration.google.client-secret=YOUR_CLIENT_SECRET_HERE
spring.security.oauth2.client.registration.google.scope=profile,email
spring.security.oauth2.client.registration.google.redirect-uri={baseUrl}/login/oauth2/code/{registrationId}
spring.security.oauth2.client.provider.google.authorization-uri=https://accounts.google.com/o/oauth2/v2/auth
spring.security.oauth2.client.provider.google.token-uri=https://oauth2.googleapis.com/token
spring.security.oauth2.client.provider.google.user-info-uri=https://www.googleapis.com/oauth2/v3/userinfo
spring.security.oauth2.client.provider.google.user-name-attribute=sub
```

**QUAN TRỌNG: Nếu không cần Google login, BỎ QUA bước này! App vẫn chạy bình thường.**

---

## 🚀 BƯỚC 4: BUILD VÀ CHẠY DỰ ÁN

### 4.1. Build project
```bash
mvn clean install
```

### 4.2. Chạy ứng dụng

**Cách 1: Dùng Maven**
```bash
mvn spring-boot:run
```

**Cách 2: Dùng file có sẵn**
```bash
# macOS/Linux
./run.sh

# Windows
run.bat
```

**Cách 3: Chạy từ IDE**
- Mở project trong IntelliJ/Eclipse
- Chạy class `ProjectendApplication.java`

---

## 🌐 BƯỚC 5: TRUY CẬP WEBSITE

- **Trang chủ**: http://localhost:8080
- **Sản phẩm**: http://localhost:8080/sanpham
- **Giỏ hàng**: http://localhost:8080/giohang
- **Admin**: http://localhost:8080/admin (cần đăng nhập admin)
- **Profile**: http://localhost:8080/profile (cần đăng nhập)

---

## 👤 TÀI KHOẢN MẶC ĐỊNH (xem trong db.sql)

Kiểm tra file `db.sql` để xem các tài khoản test có sẵn, ví dụ:

**Admin:**
- Email: admin@luxury.com
- Password: (xem trong db.sql)

**Khách hàng:**
- Email: customer@luxury.com
- Password: (xem trong db.sql)

**Nhân viên:**
- Email: staff@luxury.com
- Password: (xem trong db.sql)

---

## ✅ CHECKLIST TRƯỚC KHI CHẠY

- [ ] Đã cài Java 17+
- [ ] Đã cài Maven
- [ ] Đã cài SQL Server
- [ ] Đã chạy file `db.sql` thành công
- [ ] Đã sửa password SQL Server trong `application.properties` (nếu cần)
- [ ] Đã chạy `mvn clean install` thành công
- [ ] Đã chạy `mvn spring-boot:run`
- [ ] Vào http://localhost:8080 thấy trang chủ

---

## 🔧 TROUBLESHOOTING

### Lỗi kết nối Database
```
Error: Cannot connect to database
```
**Giải pháp:**
- Kiểm tra SQL Server đã chạy chưa
- Kiểm tra username/password trong `application.properties`
- Kiểm tra database `LuxuryFashion_2025` đã tạo chưa

### Lỗi Port 8080 đã được dùng
```
Error: Port 8080 is already in use
```
**Giải pháp:**
- Tắt ứng dụng đang chạy ở port 8080
- Hoặc đổi port trong `application.properties`: `server.port=8081`

### Lỗi Google OAuth (nếu bật)
```
Error: OAuth2 configuration error
```
**Giải pháp:**
- Nếu không cần Google login, comment out lại các dòng OAuth trong `application.properties`
- Nếu cần, kiểm tra lại Client ID và Client Secret

---

## 📦 CẤU TRÚC DỰ ÁN

```
Luxury_Shop/
├── db.sql                           ← Database script (CHẠY CÁI NÀY TRƯỚC)
├── application.properties.example   ← File mẫu tham khảo
├── HUONG-DAN-CHAY-DU-AN.md         ← File này
├── pom.xml                          ← Maven dependencies
├── src/
│   ├── main/
│   │   ├── java/com/example/projectend/
│   │   │   ├── controller/          ← Controllers
│   │   │   ├── service/             ← Business logic
│   │   │   ├── entity/              ← Database entities
│   │   │   ├── repository/          ← JPA repositories
│   │   │   └── config/              ← Spring config
│   │   └── resources/
│   │       ├── application.properties  ← CẤU HÌNH CHÍNH (SỬA FILE NÀY)
│   │       ├── templates/           ← Thymeleaf HTML
│   │       └── static/              ← CSS, JS, images
```

---

## 🎯 TÍNH NĂNG CHÍNH

✅ **Đã hoàn thành:**
- Xem danh sách sản phẩm (Gucci, Chanel, MLB...)
- Thêm vào giỏ hàng (có session cho khách vãng lai)
- Đăng ký / Đăng nhập bằng email
- Thanh toán qua PayOS (VNPay, MoMo...)
- Quản lý đơn hàng
- Admin: Quản lý sản phẩm, đơn hàng, tài khoản
- Nhân viên: Quản lý đơn hàng, bài viết
- Blog/Tin tức
- Profile khách hàng

---

## 📞 HỖ TRỢ

**Nếu gặp vấn đề:**
- Email: nguyenh0210@gmail.com
- GitHub Issues: https://github.com/Namnguyenh0210/Luxury_Shop/issues

---

## 📝 GHI CHÚ QUAN TRỌNG

1. **Không cần cấu hình Google OAuth** - App chạy bình thường không cần nó
2. **PayOS credentials** đã có sẵn trong file để test thanh toán
3. **Mật khẩu không mã hóa** (dùng plain text) - chỉ phù hợp với demo/học tập
4. **Folder `target/`** sẽ tự tạo khi build, không cần commit vào Git

---

**Chúc bạn chạy dự án thành công! 🎉**
