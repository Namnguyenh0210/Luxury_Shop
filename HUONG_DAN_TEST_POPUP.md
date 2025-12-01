# Hướng Dẫn Test Popup Chi Tiết Sản Phẩm

## Cách test tính năng mới

### Bước 1: Khởi động ứng dụng

```bash
# Windows (PowerShell)
cd D:\Asm_Java6
.\run.bat

# Hoặc sử dụng Maven
mvn spring-boot:run
```

### Bước 2: Đăng nhập với tài khoản Admin

1. Truy cập: `http://localhost:8080/login`
2. Đăng nhập với:
   - **Email:** `admin@luxury.com`
   - **Password:** `123`

### Bước 3: Vào trang Quản Lý Sản Phẩm

1. Sau khi đăng nhập, click vào menu **"Sản Phẩm"** trong sidebar
2. Hoặc truy cập trực tiếp: `http://localhost:8080/admin/products`

### Bước 4: Test Popup Chi Tiết

#### Test Case 1: Hiển thị popup
- **Thao tác:** Click vào **TÊN SẢN PHẨM** (cột thứ 3) trong bảng
- **Kết quả mong đợi:**
  - Popup xuất hiện với hiệu ứng fade-in
  - Hiển thị loading spinner ban đầu
  - Sau đó hiển thị thông tin sản phẩm đầy đủ

#### Test Case 2: Thông tin sản phẩm
Kiểm tra popup hiển thị đúng:
- ✅ Hình ảnh sản phẩm
- ✅ Tên sản phẩm
- ✅ Danh mục
- ✅ Thương hiệu
- ✅ Giới tính (Nam/Nữ/Unisex)
- ✅ Trạng thái (Đang bán/Ngừng bán)
- ✅ Mô tả

#### Test Case 3: Hiển thị variants (Size)
- **Sản phẩm test:** Click vào "Áo Polo Gucci Cotton" (ID #1)
- **Kết quả mong đợi:**
  - Hiển thị 4 cards cho 4 sizes (S, M, L, XL)
  - Mỗi card hiển thị:
    - Tên size
    - Giá bán (định dạng VNĐ: 15.000.000₫)
    - Badge trạng thái
    - Tổng số lượng tồn
    - Chi tiết tồn kho theo màu

#### Test Case 4: Trạng thái tồn kho
Test với các sản phẩm khác nhau để kiểm tra 3 trạng thái:

**🟢 Còn hàng (Stock > 10):**
- Sản phẩm: "Áo Polo Gucci Cotton" - Size S (tồn: 20)
- Card hiển thị màu xanh lá
- Badge: "Còn hàng"

**🟡 Sắp hết hàng (Stock ≤ 10):**
- Sản phẩm: "Áo Polo Gucci Cotton" - Size XL (tồn: 10)
- Card hiển thị màu vàng
- Badge: "Sắp hết hàng"

**🔴 Hết hàng (Stock = 0):**
- Tìm sản phẩm có size hết hàng trong database
- Card hiển thị màu đỏ
- Badge: "Hết hàng"

#### Test Case 5: Chi tiết màu sắc
- **Thao tác:** Click vào sản phẩm có nhiều màu
- **Kết quả mong đợi:**
  - Hiển thị danh sách màu trong mỗi size
  - Mỗi màu hiển thị số lượng tồn riêng
  - Ví dụ:
    ```
    Đen: 10 sp
    Trắng: 10 sp
    ```

#### Test Case 6: Đóng popup
- **Thao tác 1:** Click vào nút X (close button)
- **Thao tác 2:** Click ra ngoài popup (backdrop)
- **Kết quả mong đợi:** Popup đóng lại

#### Test Case 7: Responsive Design
Test trên các kích thước màn hình:

**Desktop (> 1024px):**
- Variants hiển thị 3 cột

**Tablet (768px - 1024px):**
- Variants hiển thị 2 cột

**Mobile (< 768px):**
- Variants hiển thị 1 cột
- Popup full width với padding nhỏ

### Bước 5: Kiểm tra Console (F12)

Mở Developer Tools (F12) và kiểm tra:

1. **Network Tab:**
   - Khi click vào sản phẩm, phải thấy request:
     - URL: `/admin/products/api/details/{id}`
     - Method: GET
     - Status: 200 OK
   - Response phải là JSON object chứa thông tin sản phẩm và variants

2. **Console Tab:**
   - Không có lỗi JavaScript
   - Không có lỗi 404 hoặc 500

### Các sản phẩm test trong database:

| ID | Tên Sản Phẩm | Số Variants | Note |
|----|--------------|-------------|------|
| 1  | Áo Polo Gucci Cotton | 4 (S,M,L,XL) | Có đủ 3 trạng thái tồn |
| 2  | Áo Thun Gucci Print | 4 | Test sản phẩm T-Shirt |
| 3  | Quần Gucci Trackpant | 4 | Test sản phẩm quần |
| 13 | Áo T-Shirt TEST Giá 3k | 1 | Sản phẩm test PayOS |
| 14 | Áo Test PayOS 3K | 2 | Sản phẩm test PayOS |

### Lỗi thường gặp và cách fix:

#### Lỗi 1: Popup không hiển thị
- **Nguyên nhân:** JavaScript chưa load
- **Cách fix:** Hard refresh (Ctrl + Shift + R)

#### Lỗi 2: API trả về 404
- **Nguyên nhân:** Controller chưa được compile
- **Cách fix:** 
  ```bash
  mvn clean compile
  mvn spring-boot:run
  ```

#### Lỗi 3: JSON serialization error (infinite recursion)
- **Nguyên nhân:** Chưa có @JsonIgnoreProperties
- **Cách fix:** Đã fix trong SanPhamChiTiet.java

#### Lỗi 4: Variants không hiển thị
- **Nguyên nhân:** Fetch policy của variants là LAZY
- **Kiểm tra:** Xem response JSON có chứa variants không
- **Cách fix:** Đã set fetch = FetchType.LAZY trong SanPham entity (OK)

### Screenshot mẫu kết quả đúng:

```
┌─────────────────────────────────────────────────┐
│ Chi Tiết: Áo Polo Gucci Cotton             [X] │
├─────────────────────────────────────────────────┤
│                                                 │
│  [Hình Gucci]    Tên: Áo Polo Gucci Cotton     │
│                  Danh mục: Áo Polo              │
│                  Thương hiệu: Gucci             │
│                  Giới tính: Unisex              │
│                  Trạng thái: [Đang bán]         │
│                  Mô tả: Áo polo Gucci...        │
│                                                 │
├─────────────────────────────────────────────────┤
│ 📦 Các Size & Tồn Kho                          │
│                                                 │
│ ┌─────────────┬─────────────┬─────────────┐   │
│ │ Size S      │ Size M      │ Size L      │   │
│ │ 15,000,000₫ │ 15,000,000₫ │ 15,000,000₫ │   │
│ │ [Còn hàng]  │ [Còn hàng]  │ [Còn hàng]  │   │
│ │ ─────────── │ ─────────── │ ─────────── │   │
│ │ Tồn: 20 sp  │ Tồn: 25 sp  │ Tồn: 15 sp  │   │
│ │ • Đen: 10   │ • Đen: 13   │ • Trắng: 15 │   │
│ │ • Trắng: 10 │ • Trắng: 12 │             │   │
│ └─────────────┴─────────────┴─────────────┘   │
│                                                 │
│ ┌─────────────┐                                │
│ │ Size XL     │                                │
│ │ 15,000,000₫ │                                │
│ │ [Sắp hết]   │                                │
│ │ ─────────── │                                │
│ │ Tồn: 10 sp  │                                │
│ │ • Trắng: 10 │                                │
│ └─────────────┘                                │
└─────────────────────────────────────────────────┘
```

### Kết luận:
Nếu tất cả các test case đều PASS, tính năng đã hoạt động hoàn hảo! ✅

