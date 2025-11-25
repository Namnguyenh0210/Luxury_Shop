# HƯỚNG DẪN CHẠY DỰ ÁN LUXURY FASHION E-COMMERCE

## Yêu cầu hệ thống
- Java 17 trở lên
- Maven 3.6+
- SQL Server 2019+
- IDE: IntelliJ IDEA / Eclipse / VS Code

## Các bước cài đặt

### 1. Clone dự án
```bash
git clone https://github.com/Namnguyenh0210/Luxury_Shop.git
cd Luxury_Shop
```

### 2. Cấu hình Database
```bash
# Tạo database trong SQL Server
# Chạy file db.sql để tạo database và import dữ liệu mẫu
sqlcmd -S localhost -U sa -P Aa@123456 -i db.sql
```

### 3. Cấu hình application.properties
```bash
# Copy file mẫu
cp application.properties.example src/main/resources/application.properties

# Chỉnh sửa thông tin kết nối database nếu cần
# Chỉnh sửa Google OAuth credentials nếu muốn dùng tính năng login bằng Google
```

**Lưu ý về Google OAuth:**
- Nếu không cần login bằng Google, có thể để mặc định
- Nếu muốn dùng, lấy credentials tại: https://console.cloud.google.com/apis/credentials

### 4. Build và chạy dự án
```bash
# Build project
mvn clean install

# Chạy ứng dụng
mvn spring-boot:run

# Hoặc dùng file .bat/.sh có sẵn
./run.sh       # macOS/Linux
run.bat        # Windows
```

### 5. Truy cập ứng dụng
- Trang chủ: http://localhost:8080
- Admin: http://localhost:8080/admin
- API docs: http://localhost:8080/api

## Tài khoản mặc định
Xem trong file `db.sql` để biết tài khoản test

## Lưu ý
- File `target/` không được commit vào Git (là build output)
- File `application.properties` chứa thông tin nhạy cảm, không nên push lên Git công khai
- PayOS credentials trong file example có thể dùng để test thanh toán

## Liên hệ
- Email: nguyenh0210@gmail.com
- GitHub: https://github.com/Namnguyenh0210

