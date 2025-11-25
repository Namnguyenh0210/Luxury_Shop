# 🎯 HƯỚNG DẪN TÍCH HỢP PAYOS PAYMENT GATEWAY

## 📋 TỔNG QUAN

Dự án đã được tích hợp **PayOS** - Cổng thanh toán qua QR Code ngân hàng Việt Nam.

### ✨ Tính năng đã triển khai:

1. ✅ **Tạo đơn hàng** và lưu vào database
2. ✅ **Gọi PayOS API** để tạo link thanh toán và QR code
3. ✅ **Hiển thị QR code** để khách hàng quét và thanh toán
4. ✅ **Nhận webhook** từ PayOS khi có thay đổi trạng thái thanh toán
5. ✅ **Xác thực checksum** để đảm bảo webhook hợp lệ
6. ✅ **Cập nhật trạng thái** đơn hàng tự động (PENDING → PAID)
7. ✅ **Hiển thị trạng thái** thanh toán real-time
8. ✅ **Thanh toán trực tiếp** về tài khoản ngân hàng (không qua trung gian)
9. ✅ **Full comments** giải thích từng bước trong code

---

## 🔧 CÀI ĐẶT

### Bước 1: Cài đặt dependencies

Dependencies đã được thêm vào `pom.xml`:

```xml
<!-- PayOS Java SDK -->
<dependency>
    <groupId>vn.payos</groupId>
    <artifactId>payos</artifactId>
    <version>1.0.4</version>
</dependency>

<!-- HTTP Client -->
<dependency>
    <groupId>com.squareup.okhttp3</groupId>
    <artifactId>okhttp</artifactId>
    <version>4.12.0</version>
</dependency>

<!-- Gson for JSON -->
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
</dependency>

<!-- Apache Commons Codec for HMAC -->
<dependency>
    <groupId>commons-codec</groupId>
    <artifactId>commons-codec</artifactId>
</dependency>
```

Chạy lệnh để tải dependencies:

```bash
mvn clean install
```

### Bước 2: Cập nhật database

Chạy file SQL để thêm phương thức thanh toán PayOS:

```bash
# Kết nối SQL Server và chạy:
sqlcmd -S localhost -U sa -P Aa@123456 -i payos-update.sql
```

Hoặc mở SQL Server Management Studio và chạy file `payos-update.sql`

### Bước 3: Cấu hình PayOS

Thông tin PayOS đã được cấu hình trong `application.properties`:

```properties
# PayOS API Credentials
payos.client-id=47e79a36-f22b-495f-bd43-195cc7c56b00
payos.api-key=948a4a4c-20de-4745-a4be-011c5f20248f
payos.checksum-key=a528602803da1f465a2df8f5daf624f9783796195272652bef398ef0ec3d3d9f

# PayOS URLs
payos.api-url=https://api-merchant.payos.vn
payos.return-url=http://localhost:8080/payment/payos/return
payos.cancel-url=http://localhost:8080/payment/payos/cancel
payos.webhook-url=http://localhost:8080/payment/payos/webhook
```

⚠️ **LƯU Ý**: Để webhook hoạt động, cần:
- Deploy lên server có domain công khai HOẶC
- Sử dụng ngrok để tạo tunnel từ localhost:

```bash
ngrok http 8080
# Sau đó cập nhật webhook-url thành: https://your-ngrok-url/payment/payos/webhook
```

---

## 📂 CẤU TRÚC CODE

### 1. Configuration Layer

**`PayOSConfig.java`** - Quản lý thông tin cấu hình PayOS
- Client ID, API Key, Checksum Key
- URLs (return, cancel, webhook)

### 2. DTO Layer

**`PayOSRequest.java`** - Dữ liệu request tạo thanh toán
**`PayOSResponse.java`** - Phản hồi từ PayOS API
**`PayOSData.java`** - Chi tiết link thanh toán và QR code
**`PayOSItem.java`** - Thông tin sản phẩm trong đơn hàng
**`PayOSWebhookData.java`** - Dữ liệu webhook từ PayOS

### 3. Service Layer

**`PayOSService.java`** - Xử lý logic tích hợp PayOS

Các method chính:
- `createPaymentLink()` - Tạo link thanh toán và QR code
- `verifyWebhookSignature()` - Xác thực chữ ký webhook
- `getPaymentStatus()` - Kiểm tra trạng thái thanh toán
- `cancelPayment()` - Hủy thanh toán

### 4. Controller Layer

**`PayOSController.java`** - Xử lý HTTP requests

Endpoints:
```
POST   /payment/payos/create        - Tạo thanh toán
GET    /payment/payos/return        - Callback sau thanh toán
GET    /payment/payos/cancel        - Callback khi hủy
POST   /payment/payos/webhook       - Nhận thông báo từ PayOS
GET    /payment/payos/check/{id}    - Kiểm tra trạng thái
```

**`CheckoutController.java`** - Đã được cập nhật
- Khi khách chọn phương thức PayOS (ID = 2), redirect đến trang thanh toán

### 5. View Layer

**`Pay.html`** - Trang hiển thị QR code thanh toán
- Hiển thị mã QR để quét
- Tự động kiểm tra trạng thái mỗi 5 giây
- Đếm ngược thời gian thanh toán (15 phút)
- Redirect tự động khi thanh toán thành công

### 6. Entity Layer

**`DonHang.java`** - Đã thêm 2 trường mới:
- `lyDoHuy` - Lý do hủy đơn
- `maGiaoDich` - Mã giao dịch PayOS

---

## 🔄 LUỒNG HOẠT ĐỘNG

### 1️⃣ Khách hàng đặt hàng

```
Giỏ hàng → Checkout → Chọn "PayOS" → Đặt hàng
```

**Code xử lý** (`CheckoutController.java`):

```java
// Khi phuongThucId == 2 (PayOS)
if (phuongThucId == 2L) {
    return "redirect:/payment/payos/create?orderId=" + donHang.getMaDH();
}
```

### 2️⃣ Hệ thống tạo link thanh toán

**Request đến** `POST /payment/payos/create?orderId=123`

**PayOSController xử lý**:
1. Lấy thông tin đơn hàng từ database
2. Gọi `PayOSService.createPaymentLink(donHang)`
3. PayOSService gọi API PayOS
4. Nhận về checkout URL và QR code
5. Lưu mã giao dịch vào đơn hàng
6. Hiển thị trang `Pay.html` với QR code

### 3️⃣ Khách hàng thanh toán

```
Khách quét QR → Mở app ngân hàng → Xác nhận chuyển khoản
```

### 4️⃣ PayOS gửi webhook

**PayOS gửi POST request** đến `http://your-domain/payment/payos/webhook`

**PayOSController xử lý**:
1. Nhận webhook data
2. Xác thực chữ ký (HMAC SHA256)
3. Nếu hợp lệ → Cập nhật trạng thái đơn hàng
4. Trả về response cho PayOS

**Code xác thực signature**:

```java
// Tạo chuỗi data theo thứ tự alphabet
String dataStr = String.format(
    "amount=%d&code=%s&description=%s&orderCode=%d",
    webhookData.getAmount(),
    webhookData.getCode(),
    webhookData.getDescription(),
    webhookData.getOrderCode()
);

// Tính HMAC SHA256
String calculatedSignature = hmacSHA256(dataStr, checksumKey);

// So sánh với signature từ PayOS
boolean isValid = calculatedSignature.equals(webhookData.getSignature());
```

### 5️⃣ Cập nhật trạng thái

**Tự động cập nhật**:
- `TrangThaiThanhToan` = 1 (Đã thanh toán)
- `NgayThanhToan` = thời gian hiện tại
- `TrangThaiDH` = 1 (Đã xác nhận) - nếu đang ở trạng thái "Chờ xác nhận"

### 6️⃣ Kiểm tra real-time

JavaScript trong `Pay.html` tự động kiểm tra trạng thái mỗi 5 giây:

```javascript
function checkPaymentStatus() {
    fetch(`/payment/payos/check/${orderCode}`)
        .then(response => response.json())
        .then(data => {
            if (data.status === 'PAID') {
                // Thanh toán thành công
                alert('Thanh toán thành công!');
                window.location.href = `/checkout/success?orderId=${orderCode}`;
            }
        });
}

// Tự động kiểm tra mỗi 5 giây
setInterval(checkPaymentStatus, 5000);
```

---

## 🧪 KIỂM TRA & DEBUG

### 1. Kiểm tra cấu hình

Truy cập: http://localhost:8080/

Đảm bảo server khởi động thành công và không có lỗi trong log.

### 2. Kiểm tra database

```sql
-- Kiểm tra phương thức thanh toán PayOS đã được thêm chưa
SELECT * FROM HinhThucThanhToan WHERE TenHinhThuc = N'PayOS';

-- Kiểm tra các cột mới trong DonHang
SELECT TOP 1 MaDH, MaGiaoDich, LyDoHuy FROM DonHang;
```

### 3. Test flow thanh toán

**Bước 1**: Đăng nhập với tài khoản khách hàng

**Bước 2**: Thêm sản phẩm vào giỏ hàng

**Bước 3**: Checkout → Chọn địa chỉ → Chọn "PayOS" → Đặt hàng

**Bước 4**: Sẽ chuyển đến trang hiển thị QR code

**Bước 5**: Quét QR bằng app ngân hàng (hoặc test với sandbox PayOS)

**Bước 6**: Sau khi thanh toán, trang sẽ tự động cập nhật và chuyển về trang success

### 4. Xem log

```bash
# Xem log trong terminal
tail -f logs/spring.log

# Hoặc xem log trong IDE
```

Log quan trọng:
- `🔄 Bắt đầu tạo link thanh toán PayOS` - Bắt đầu tạo thanh toán
- `✅ Tạo link thanh toán thành công` - Thành công
- `📩 Nhận webhook từ PayOS` - Nhận webhook
- `🔐 Xác thực chữ ký webhook` - Kiểm tra signature
- `✅ Đã cập nhật trạng thái đơn hàng` - Cập nhật thành công

---

## 🐛 XỬ LÝ LỖI THƯỜNG GẶP

### Lỗi 1: Không tạo được link thanh toán

**Nguyên nhân**:
- API Key sai
- Client ID sai
- Network không kết nối được với PayOS API

**Giải pháp**:
- Kiểm tra lại credentials trong `application.properties`
- Kiểm tra kết nối internet
- Xem log chi tiết trong console

### Lỗi 2: Webhook không nhận được

**Nguyên nhân**:
- Webhook URL không public (chạy localhost)
- CSRF protection chặn request

**Giải pháp**:
- Sử dụng ngrok: `ngrok http 8080`
- Cập nhật webhook URL trong PayOS dashboard
- CSRF đã được disable trong SecurityConfig

### Lỗi 3: Signature không hợp lệ

**Nguyên nhân**:
- Checksum Key sai
- Thứ tự các field không đúng

**Giải pháp**:
- Kiểm tra lại checksum-key
- PayOS yêu cầu sort theo alphabet: `amount`, `code`, `description`, `orderCode`

### Lỗi 4: Không cập nhật được database

**Nguyên nhân**:
- Không tìm thấy đơn hàng
- Lỗi transaction

**Giải pháp**:
- Kiểm tra orderCode có tồn tại không
- Xem log exception trong console
- Kiểm tra database connection

---

## 📊 KIỂM TRA TRẠNG THÁI ĐƠN HÀNG

### Trong Admin Panel

```
Admin Dashboard → Quản lý đơn hàng → Xem chi tiết
```

Sẽ hiển thị:
- **Trạng thái đơn hàng**: Chờ xác nhận / Đã xác nhận / Đang giao / Hoàn tất / Đã hủy
- **Trạng thái thanh toán**: Chờ thanh toán / Đã thanh toán
- **Mã giao dịch**: PAYOS_123 (nếu thanh toán qua PayOS)
- **Ngày thanh toán**: Thời gian thanh toán thành công

### Query SQL

```sql
-- Lấy danh sách đơn hàng PayOS
SELECT 
    dh.MaDH as [Mã ĐH],
    dh.MaGiaoDich as [Mã giao dịch],
    dh.TongTien as [Tổng tiền],
    CASE dh.TrangThaiThanhToan
        WHEN 0 THEN N'Chờ thanh toán'
        WHEN 1 THEN N'Đã thanh toán'
    END as [Trạng thái TT],
    dh.NgayThanhToan as [Ngày thanh toán],
    tk.HoTen as [Khách hàng]
FROM DonHang dh
JOIN TaiKhoan tk ON dh.MaTK = tk.MaTK
JOIN HinhThucThanhToan ht ON dh.MaHinhThucTT = ht.MaHinhThucTT
WHERE ht.TenHinhThuc = N'PayOS'
ORDER BY dh.NgayDat DESC;
```

---

## 🚀 TRIỂN KHAI LÊN PRODUCTION

### 1. Cập nhật URLs trong application.properties

```properties
# Production URLs
payos.return-url=https://yourdomain.com/payment/payos/return
payos.cancel-url=https://yourdomain.com/payment/payos/cancel
payos.webhook-url=https://yourdomain.com/payment/payos/webhook
```

### 2. Đăng ký Webhook URL trên PayOS Dashboard

Truy cập PayOS Dashboard → Settings → Webhook URL
Nhập: `https://yourdomain.com/payment/payos/webhook`

### 3. Test trên production

- Tạo đơn hàng test
- Thanh toán với số tiền nhỏ
- Kiểm tra webhook có nhận được không
- Xác nhận đơn hàng cập nhật đúng

---

## 📞 HỖ TRỢ

Nếu gặp vấn đề:

1. **Xem log** trong console/terminal
2. **Kiểm tra database** xem dữ liệu có đúng không
3. **Test API** bằng Postman
4. **Liên hệ PayOS support** nếu vấn đề từ phía họ

---

## ✅ CHECKLIST HOÀN THÀNH

- [x] Thêm dependencies vào pom.xml
- [x] Tạo PayOSConfig với thông tin credentials
- [x] Tạo các DTO classes (Request, Response, Webhook...)
- [x] Tạo PayOSService với đầy đủ chức năng
- [x] Tạo PayOSController với các endpoints
- [x] Cập nhật DonHang entity (thêm MaGiaoDich, LyDoHuy)
- [x] Cập nhật CheckoutController để hỗ trợ PayOS
- [x] Tạo trang Pay.html hiển thị QR code
- [x] Cập nhật SecurityConfig cho phép webhook
- [x] Tạo script SQL cập nhật database
- [x] Thêm comments đầy đủ trong code
- [x] Tạo file hướng dẫn này

**Tất cả đã hoàn thành! 🎉**

