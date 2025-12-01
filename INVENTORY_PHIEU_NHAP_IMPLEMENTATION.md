# ✅ Triển Khai Tính Năng Tạo Phiếu Nhập Kho Chi Tiết

## 📋 Yêu Cầu Đã Hoàn Thành

### 1. ✅ Xóa nút "Thêm NCC" khỏi form tạo phiếu nhập
- **Trước:** Có nút "Thêm NCC" (màu tím) trong form tạo phiếu nhập
- **Sau:** Đã xóa nút, chỉ hiển thị hướng dẫn "Chuyển sang tab 'Nhà Cung Cấp' để thêm NCC mới"
- **Lý do:** NCC nên được quản lý tập trung ở tab "Nhà Cung Cấp"

### 2. ✅ Phần nhập kho chi tiết cho điền đầy đủ thông tin
Mỗi dòng sản phẩm trong phiếu nhập giờ bao gồm:
- **Sản phẩm** (dropdown): Chọn sản phẩm từ danh sách
- **Size** (dropdown): Tự động load các size có sẵn của sản phẩm đã chọn
- **Màu** (dropdown): Tự động load các màu có sẵn của sản phẩm đã chọn
- **Số lượng** (input number): Nhập số lượng nhập kho
- **Đơn giá nhập** (input number): Nhập giá nhập từ nhà cung cấp
- **Thành tiền** (tự động): Tính tự động = Số lượng × Đơn giá

## 🏗️ Cấu Trúc Database

### Bảng PhieuNhap
```sql
CREATE TABLE PhieuNhap (
    MaPN BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaNV BIGINT NOT NULL,           -- Nhân viên nhập
    MaNCC BIGINT,                    -- Nhà cung cấp
    NgayNhap DATETIME DEFAULT GETDATE(),
    TongTien DECIMAL(18, 2) DEFAULT 0,
    GhiChu NVARCHAR(500)
);
```

### Bảng NhapKhoChiTiet
```sql
CREATE TABLE NhapKhoChiTiet (
    MaNK_CT BIGINT IDENTITY(1,1) PRIMARY KEY,
    MaPN BIGINT NOT NULL,            -- Foreign key PhieuNhap
    MaBienThe BIGINT NOT NULL,       -- Biến thể sản phẩm (SP + Size + Màu)
    SoLuong INT,
    DonGiaNhap DECIMAL(18, 2),
    ThanhTien DECIMAL(18, 2)         -- = SoLuong × DonGiaNhap
);
```

## 🔧 Các File Đã Chỉnh Sửa

### 1. **AdminInventoryController.java**
**Đường dẫn:** `src/main/java/com/example/projectend/controller/admin/AdminInventoryController.java`

#### Thêm imports:
```java
import com.example.projectend.entity.*;
import com.example.projectend.repository.*;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import java.math.BigDecimal;
import java.time.LocalDateTime;
```

#### Thêm repositories:
```java
@Autowired
private NhapKhoChiTietRepository nhapKhoChiTietRepository;

@Autowired
private SanPhamChiTietRepository sanPhamChiTietRepository;

@Autowired
private TaiKhoanRepository taiKhoanRepository;
```

#### Thêm endpoint POST `/phieu-nhap/save`:
```java
@PostMapping("/phieu-nhap/save")
public String savePhieuNhap(
        @AuthenticationPrincipal UserDetails userDetails,
        @RequestParam Long maNCC,
        @RequestParam(required = false) String ghiChu,
        @RequestParam List<Long> maBienThe,
        @RequestParam List<Integer> soLuongs,
        @RequestParam List<BigDecimal> donGiaNhaps,
        RedirectAttributes redirectAttributes) {
    // Logic:
    // 1. Lấy thông tin nhân viên từ userDetails
    // 2. Lấy nhà cung cấp từ maNCC
    // 3. Tạo PhieuNhap
    // 4. Lưu PhieuNhap để có ID
    // 5. Loop qua từng chi tiết:
    //    - Tạo NhapKhoChiTiet
    //    - Cập nhật SoLuongTon của SanPhamChiTiet
    //    - Cập nhật GiaNhap
    // 6. Cập nhật TongTien của PhieuNhap
    // 7. Redirect về /admin/inventory
}
```

**Các chức năng:**
- ✅ Lấy tự động thông tin nhân viên đăng nhập
- ✅ Validate nhà cung cấp
- ✅ Tạo phiếu nhập với tất cả chi tiết
- ✅ Cập nhật tồn kho tự động
- ✅ Cập nhật giá nhập vào SanPhamChiTiet
- ✅ Tính tổng tiền tự động

---

### 2. **AdminSanPhamController.java**
**Đường dẫn:** `src/main/java/com/example/projectend/controller/admin/AdminSanPhamController.java`

#### Thêm API endpoint:
```java
/**
 * API endpoint to get product variants (for inventory nhap kho)
 */
@GetMapping("/api/variants/{maSP}")
@ResponseBody
public List<SanPhamChiTiet> getProductVariants(@PathVariable Long maSP) {
    return sanPhamService.findById(maSP)
            .map(SanPham::getChiTiet)
            .orElse(Collections.emptyList());
}
```

**Mục đích:** 
- Trả về danh sách tất cả biến thể (Size, Màu) của một sản phẩm
- Dùng cho form nhập kho để load dropdown Size và Màu

---

### 3. **inventory.html**
**Đường dẫn:** `src/main/resources/templates/admin/inventory.html`

#### Thay đổi form action:
```html
<form th:action="@{/admin/inventory/phieu-nhap/save}" method="post">
```

#### Sửa tên parameter NCC:
```html
<select id="nhaCungCapSelect" name="maNCC" required>
```

#### Cập nhật bảng chi tiết sản phẩm:
```html
<table>
    <thead>
        <tr>
            <th>STT</th>
            <th>Sản Phẩm *</th>
            <th>Size *</th>
            <th>Màu *</th>
            <th>Số Lượng *</th>
            <th>Đơn Giá Nhập *</th>
            <th>Thành Tiền</th>
            <th>Xóa</th>
        </tr>
    </thead>
    <tbody id="nhapKhoTableBody">
        <!-- Rows added dynamically -->
    </tbody>
</table>
```

#### JavaScript Functions:

##### `addNhapKhoRow()` - Thêm dòng sản phẩm mới
- Tạo row mới với đầy đủ dropdowns và inputs
- Gán event handlers cho tính toán tự động
- Product dropdown: `name="sanPhamIds"`
- Size dropdown: `name="maSize_{rowId}"` (chỉ để UI, không submit)
- Color dropdown: `name="maMau_{rowId}"` (chỉ để UI, không submit)
- Quantity input: `name="soLuongs"`
- Price input: `name="donGiaNhaps"`
- Hidden input: `name="maBienThe"` (Đây là giá trị thực sự submit)

##### `loadVariants(rowId, maSP)` - Load Size và Màu theo sản phẩm
```javascript
function loadVariants(rowId, maSP) {
    // 1. Fetch /admin/products/api/variants/{maSP}
    // 2. Parse JSON response (array of SanPhamChiTiet)
    // 3. Extract unique sizes: [{id, name}]
    // 4. Extract unique colors: [{id, name}]
    // 5. Populate size dropdown
    // 6. Populate color dropdown
    // 7. Store variants data in row.dataset.variants
    // 8. Enable dropdowns
}
```

**Flow:**
1. User chọn sản phẩm → onChange gọi `loadVariants()`
2. AJAX fetch về danh sách variants
3. Parse ra các size và màu unique
4. Populate vào dropdowns

##### `updateBienTheId(rowId)` - Tìm MaBienThe từ Size + Màu
```javascript
function updateBienTheId(rowId) {
    // 1. Get selected maSP, maSize, maMau
    // 2. Get stored variants from row.dataset.variants
    // 3. Find variant matching (size AND color)
    // 4. Set hidden input "bienThe_{rowId}" = variant.maBienThe
    // 5. Auto-fill price if variant.giaNhap > 0
}
```

**Flow:**
1. User chọn Size → onChange gọi `updateBienTheId()`
2. User chọn Màu → onChange gọi `updateBienTheId()`
3. Tìm variant khớp với (SP + Size + Màu)
4. Lưu MaBienThe vào hidden input
5. Tự động điền giá nhập (nếu có)

##### `calculateRowTotal(rowId)` - Tính thành tiền
```javascript
function calculateRowTotal(rowId) {
    const qty = parseInt($('#qty_' + rowId).value);
    const price = parseFloat($('#price_' + rowId).value);
    const total = qty * price;
    $('#total_' + rowId).textContent = formatCurrency(total);
    calculateTotalAmount();
}
```

##### `calculateTotalAmount()` - Tính tổng tiền phiếu
```javascript
function calculateTotalAmount() {
    let total = 0;
    // Loop through all rows
    // Sum up all row totals
    $('#tongTienDisplay').textContent = formatCurrency(total);
    $('#tongTienInput').value = total;
}
```

---

## 🔄 Flow Hoạt Động

### Flow 1: Tạo Phiếu Nhập Mới

#### Bước 1: Mở form
1. User click "Tạo Phiếu Nhập" → Modal hiện lên
2. Hiển thị:
   - Mã phiếu: "Tự động tạo"
   - Nhân viên: Tự động từ user đăng nhập
   - Ngày nhập: Hiện tại
   - Dropdown NCC (required)
   - Textarea ghi chú (optional)

#### Bước 2: Thêm sản phẩm
1. User click "Thêm sản phẩm"
2. JavaScript gọi `addNhapKhoRow()`
3. Thêm 1 dòng mới vào table với:
   - STT: 1, 2, 3...
   - Dropdown Sản phẩm (enabled)
   - Dropdown Size (disabled)
   - Dropdown Màu (disabled)
   - Input Số lượng = 1
   - Input Đơn giá = 0
   - Thành tiền = 0₫

#### Bước 3: Chọn sản phẩm
1. User chọn "Áo Polo Gucci Xanh Đen" trong dropdown
2. `onChange` trigger `loadVariants(rowId, maSP)`
3. AJAX GET `/admin/products/api/variants/1`
4. Response: 
```json
[
  {
    "maBienThe": 101,
    "sizeSP": {"maSize": 1, "tenSize": "S"},
    "mauSacSP": {"maMau": 4, "tenMau": "Xanh đen"},
    "giaNhap": 5000000,
    "giaBan": 8000000,
    "soLuongTon": 10
  },
  {
    "maBienThe": 102,
    "sizeSP": {"maSize": 2, "tenSize": "M"},
    "mauSacSP": {"maMau": 4, "tenMau": "Xanh đen"},
    "giaNhap": 5000000,
    ...
  }
]
```
5. Parse unique sizes: ["S", "M", "L", "XL"]
6. Parse unique colors: ["Xanh đen"]
7. Populate dropdowns
8. Enable Size và Màu dropdowns

#### Bước 4: Chọn Size và Màu
1. User chọn Size: "M"
2. `onChange` trigger `updateBienTheId(rowId)`
3. User chọn Màu: "Xanh đen"
4. `onChange` trigger `updateBienTheId(rowId)` lại
5. Tìm variant với:
   - `sizeSP.maSize == 2` (M)
   - `mauSacSP.maMau == 4` (Xanh đen)
6. Tìm thấy → `maBienThe = 102`
7. Set hidden input: `<input name="maBienThe" value="102">`
8. Auto-fill price = 5000000

#### Bước 5: Nhập số lượng
1. User nhập số lượng: 5
2. `onChange` trigger `calculateRowTotal(rowId)`
3. Tính: 5 × 5,000,000 = 25,000,000₫
4. Hiển thị thành tiền: "25,000,000₫"
5. Gọi `calculateTotalAmount()` → Cập nhật tổng tiền phiếu

#### Bước 6: Submit form
1. User click "Tạo Phiếu Nhập"
2. Form data:
```
maNCC: 1
ghiChu: "Nhập hàng mùa hè"
maBienThe: [102, 205, 310]
soLuongs: [5, 3, 10]
donGiaNhaps: [5000000, 3500000, 2800000]
```

3. Backend xử lý:
```java
POST /admin/inventory/phieu-nhap/save
{
    "maNCC": 1,
    "ghiChu": "Nhập hàng mùa hè",
    "maBienThe": [102, 205, 310],
    "soLuongs": [5, 3, 10],
    "donGiaNhaps": [5000000, 3500000, 2800000]
}
```

4. Controller:
   - Get TaiKhoan từ UserDetails → MaNV = 1 (admin@luxury.com)
   - Get NhaCungCap(1) → "Nhà phân phối Gucci VN"
   - Create PhieuNhap:
     ```java
     PhieuNhap pn = new PhieuNhap();
     pn.setNhanVien(admin); // MaNV = 1
     pn.setNhaCungCap(gucci); // MaNCC = 1
     pn.setNgayNhap(LocalDateTime.now());
     pn.setGhiChu("Nhập hàng mùa hè");
     pn = phieuNhapRepository.save(pn); // MaPN = 1
     ```
   
   - Loop chi tiết:
     ```java
     for (int i = 0; i < maBienThe.size(); i++) {
         // i=0: maBienThe=102, soLuong=5, donGia=5000000
         SanPhamChiTiet spct = sanPhamChiTietRepository.findById(102);
         
         NhapKhoChiTiet ct = new NhapKhoChiTiet();
         ct.setPhieuNhap(pn);           // MaPN = 1
         ct.setSanPhamChiTiet(spct);    // MaBienThe = 102
         ct.setSoLuong(5);
         ct.setDonGiaNhap(5000000);
         ct.setThanhTien(25000000);     // 5 × 5000000
         nhapKhoChiTietRepository.save(ct);
         
         // Cập nhật tồn kho
         spct.setSoLuongTon(spct.getSoLuongTon() + 5); // 10 + 5 = 15
         spct.setGiaNhap(5000000);
         sanPhamChiTietRepository.save(spct);
         
         tongTien += 25000000;
     }
     ```
   
   - Update PhieuNhap:
     ```java
     pn.setTongTien(tongTien); // 25000000 + 10500000 + 28000000
     phieuNhapRepository.save(pn);
     ```

5. Database state sau khi save:

**Bảng PhieuNhap:**
| MaPN | MaNV | MaNCC | NgayNhap | TongTien | GhiChu |
|------|------|-------|----------|----------|--------|
| 1 | 1 | 1 | 2025-12-01 14:30:00 | 63,500,000 | Nhập hàng mùa hè |

**Bảng NhapKhoChiTiet:**
| MaNK_CT | MaPN | MaBienThe | SoLuong | DonGiaNhap | ThanhTien |
|---------|------|-----------|---------|------------|-----------|
| 1 | 1 | 102 | 5 | 5,000,000 | 25,000,000 |
| 2 | 1 | 205 | 3 | 3,500,000 | 10,500,000 |
| 3 | 1 | 310 | 10 | 2,800,000 | 28,000,000 |

**Bảng SanPhamChiTiet (cập nhật tồn kho):**
| MaBienThe | SoLuongTon (Trước) | SoLuongTon (Sau) | GiaNhap |
|-----------|--------------------|--------------------|----------|
| 102 | 10 | 15 (+5) | 5,000,000 |
| 205 | 8 | 11 (+3) | 3,500,000 |
| 310 | 20 | 30 (+10) | 2,800,000 |

6. Redirect về `/admin/inventory`
7. Flash message: "Tạo phiếu nhập thành công! Mã phiếu: PN1"

---

## 🎯 Các Trường Submit Lên Backend

### Form Parameters:
```
maNCC: Long               // ID nhà cung cấp
ghiChu: String           // Ghi chú phiếu nhập (optional)
maBienThe: List<Long>    // Danh sách ID biến thể [102, 205, 310]
soLuongs: List<Integer>  // Danh sách số lượng [5, 3, 10]
donGiaNhaps: List<BigDecimal> // Danh sách đơn giá [5000000, 3500000, 2800000]
```

### Hidden Fields:
```html
<input type="hidden" name="maBienThe" id="bienThe_1" value="102">
<input type="hidden" name="maBienThe" id="bienThe_2" value="205">
<input type="hidden" name="maBienThe" id="bienThe_3" value="310">
```

**Lưu ý:** 
- Không submit `sanPhamIds`, `maSize`, `maMau` riêng lẻ
- Chỉ submit `maBienThe` - đã chứa thông tin đầy đủ về (Sản phẩm + Size + Màu)
- Backend dùng `maBienThe` để query SanPhamChiTiet và cập nhật tồn kho

---

## ✅ Test Cases

### Test 1: Tạo phiếu nhập đơn giản (1 sản phẩm)
1. Chọn NCC: "Nhà phân phối Gucci VN"
2. Click "Thêm sản phẩm"
3. Chọn sản phẩm: "Áo Polo Gucci Xanh Đen"
4. Chọn Size: "M"
5. Chọn Màu: "Xanh đen"
6. Nhập số lượng: 5
7. Nhập đơn giá: 5,000,000
8. Click "Tạo Phiếu Nhập"

**Expected:**
- ✅ Phiếu nhập được tạo
- ✅ Alert: "Tạo phiếu nhập thành công! Mã phiếu: PNx"
- ✅ Tồn kho SanPhamChiTiet(102) tăng 5
- ✅ Hiển thị card phiếu nhập mới trong tab "Nhập Kho"

### Test 2: Tạo phiếu nhập nhiều sản phẩm
1. Chọn NCC
2. Thêm 3 dòng sản phẩm khác nhau
3. Chọn đầy đủ Size, Màu, Số lượng, Đơn giá cho từng dòng
4. Kiểm tra tổng tiền tự động cập nhật
5. Submit

**Expected:**
- ✅ 3 records trong NhapKhoChiTiet
- ✅ Tổng tiền = sum của 3 thành tiền
- ✅ Tất cả biến thể được cập nhật tồn kho

### Test 3: Validation
- ❌ Submit không chọn NCC → Error
- ❌ Submit không có sản phẩm nào → Error (HTML5 validation)
- ❌ Chọn sản phẩm nhưng không chọn Size → Error
- ❌ Chọn sản phẩm nhưng không chọn Màu → Error
- ❌ Số lượng = 0 → Error (min="1")
- ❌ Đơn giá âm → Error (min="0")

### Test 4: Xem chi tiết phiếu nhập
1. Click vào card phiếu nhập bất kỳ
2. Modal hiện lên với đầy đủ thông tin:
   - Mã phiếu, Ngày nhập
   - NCC, Nhân viên
   - Ghi chú
   - Bảng chi tiết sản phẩm (Sản phẩm, Size, Màu, SL, Đơn giá, Thành tiền)
   - Tổng tiền

**Expected:**
- ✅ API `/admin/inventory/api/phieu-nhap/{id}` trả về JSON
- ✅ Modal hiển thị đúng thông tin
- ✅ Chi tiết sản phẩm hiển thị đầy đủ

---

## 🚀 Cách Test

### 1. Start server:
```bash
mvn spring-boot:run
```

### 2. Truy cập:
```
http://localhost:8080/admin/inventory
```

### 3. Login với admin:
```
Email: admin@luxury.com
Password: 123
```

### 4. Test flow:
1. ✅ Xem tab "Nhập Kho" → Danh sách phiếu nhập (nếu có)
2. ✅ Switch sang tab "Nhà Cung Cấp" → Thêm NCC mới
3. ✅ Về tab "Nhập Kho" → Click "Tạo Phiếu Nhập"
4. ✅ Chọn NCC vừa thêm
5. ✅ Click "Thêm sản phẩm"
6. ✅ Chọn sản phẩm → Kiểm tra Size/Màu load ra
7. ✅ Chọn Size + Màu → Kiểm tra giá tự động điền
8. ✅ Nhập số lượng → Kiểm tra thành tiền tự động tính
9. ✅ Thêm nhiều sản phẩm → Kiểm tra tổng tiền
10. ✅ Submit → Kiểm tra redirect + alert success
11. ✅ Click vào card phiếu nhập → Xem chi tiết popup

---

## 📝 Notes

### Điểm mạnh:
1. ✅ **Tự động hóa cao**: 
   - Nhân viên tự động từ user đăng nhập
   - Size/Màu load tự động theo sản phẩm
   - Giá nhập tự động điền (nếu có)
   - Tính tiền tự động
   - Cập nhật tồn kho tự động

2. ✅ **Validation đầy đủ**:
   - HTML5 validation (required, min, max)
   - Backend validation (NCC, biến thể tồn tại)
   - Alert thông báo lỗi cụ thể

3. ✅ **UX tốt**:
   - Form modal đẹp mắt
   - Thêm/xóa dòng dễ dàng
   - Hiển thị tổng tiền real-time
   - Popup chi tiết phiếu nhập

4. ✅ **Database consistency**:
   - Transaction-safe
   - Foreign key constraints
   - Cascade updates

### Cải tiến có thể:
1. 🔄 Thêm tính năng sửa/xóa phiếu nhập
2. 🔄 Export phiếu nhập ra PDF/Excel
3. 🔄 Lọc/tìm kiếm phiếu nhập
4. 🔄 Pagination cho danh sách phiếu
5. 🔄 Thống kê chi tiết theo NCC, theo sản phẩm

---

## 🎉 Kết Luận

✅ **Đã hoàn thành đầy đủ yêu cầu:**
1. Xóa nút "Thêm NCC" khỏi form tạo phiếu nhập
2. Form nhập kho chi tiết với đầy đủ thông tin (Sản phẩm, Size, Màu, Số lượng, Đơn giá)
3. Tự động load Size/Màu theo sản phẩm
4. Tính toán tự động (thành tiền, tổng tiền)
5. Lưu PhieuNhap + NhapKhoChiTiet vào database
6. Cập nhật tồn kho tự động
7. Hiển thị chi tiết phiếu nhập

**Hệ thống sẵn sàng để nhập hàng!** 🚀

