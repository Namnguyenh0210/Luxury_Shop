# CẬP NHẬT TÍNH NĂNG PHIẾU NHẬP KHO

## Ngày cập nhật: 01/12/2025

## Tổng quan
Đã cập nhật hoàn toàn giao diện và chức năng tạo phiếu nhập kho với các tính năng mới:

## ✅ Các tính năng đã triển khai

### 1. Hiển thị dữ liệu tự động
- **Mã Phiếu Nhập (PN)**: Hiển thị tự động mã phiếu nhập tiếp theo (PN1, PN2, PN3...)
- **Người nhập**: Tự động lấy thông tin người dùng đang đăng nhập (Họ tên + Email)
- **Ngày nhập**: Hiển thị ngày giờ hiện tại
- Các trường này được tô màu nổi bật để dễ nhận biết

### 2. Form nhập liệu thay vì List/Table
**Thay đổi lớn**: Không còn dùng table động với nhiều dòng, thay bằng 2 form riêng biệt:

#### 2.1. Form nhập sản phẩm có sẵn (Màu xanh dương)
- Chọn sản phẩm từ danh sách có sẵn
- Tự động load Size và Màu theo sản phẩm đã chọn
- Nhập số lượng và giá nhập
- Click "Thêm vào danh sách"

#### 2.2. Form thêm sản phẩm mới (Màu xanh lá)
- Nhập tên sản phẩm mới
- Chọn loại sản phẩm (nếu có)
- Nhập Size (ví dụ: M, L, XL)
- Nhập Màu (ví dụ: Đỏ, Xanh, Trắng)
- Nhập số lượng
- Nhập giá nhập
- Nhập giá bán
- Click "Tạo & Thêm vào danh sách"

### 3. Danh sách sản phẩm đã thêm
- Hiển thị tất cả sản phẩm đã thêm trong bảng
- Phân biệt sản phẩm mới bằng badge "● Sản phẩm mới"
- Có thể chỉnh sửa số lượng và giá trực tiếp trong bảng
- Có thể xóa từng sản phẩm
- Tính toán tự động thành tiền cho từng dòng

### 4. Tính toán tự động
- **Thành tiền mỗi sản phẩm**: Số lượng × Đơn giá
- **Tổng tiền phiếu nhập**: Tự động cộng tổng khi thêm/sửa/xóa sản phẩm
- Hiển thị định dạng tiền tệ Việt Nam (VD: 80,000,000₫)

### 5. Tự động tạo Size và Màu mới
- Khi thêm sản phẩm mới, nếu Size hoặc Màu chưa có trong hệ thống
- Hệ thống sẽ tự động tạo Size/Màu mới
- Các sản phẩm sau có thể tái sử dụng Size/Màu này

## 📁 Các file đã chỉnh sửa

### 1. Backend - Controller
**File**: `AdminInventoryController.java`

**Thêm mới**:
- `getNextPhieuCode()`: API lấy mã phiếu nhập tiếp theo
- `getCurrentUser()`: API lấy thông tin người dùng hiện tại
- 2 Repository mới: `SizeSPRepository`, `MauSacSPRepository`

**Cập nhật**:
- `savePhieuNhap()`: Hỗ trợ cả sản phẩm có sẵn và sản phẩm mới
  - Nhận thêm tham số cho sản phẩm mới
  - Tạo sản phẩm, size, màu, biến thể mới tự động
  - Xử lý riêng biệt cho từng loại sản phẩm

### 2. Backend - Repository
**File**: `SizeSPRepository.java`
- Thêm: `findByTenSize(String tenSize)` - Tìm size theo tên

**File**: `MauSacSPRepository.java`
- Thêm: `findByTenMau(String tenMau)` - Tìm màu theo tên

### 3. Frontend - HTML
**File**: `inventory.html`

**Phần form**:
- Đổi màu nền cho field Mã PN (màu xanh) và Nhân viên (màu xanh lá)
- 2 nút: "Nhập sản phẩm có sẵn" và "Thêm sản phẩm mới"
- Form nhập sản phẩm có sẵn (ẩn/hiện)
- Form thêm sản phẩm mới (ẩn/hiện)
- Bảng hiển thị sản phẩm đã thêm với input để chỉnh sửa

**JavaScript**:
- `loadPhieuNhapInfo()`: Load mã PN và thông tin nhân viên
- `showExistingProductForm()`: Hiện form sản phẩm có sẵn
- `hideExistingProductForm()`: Ẩn form sản phẩm có sẵn
- `showNewProductForm()`: Hiện form sản phẩm mới
- `hideNewProductForm()`: Ẩn form sản phẩm mới
- `loadExistingVariants()`: Load size/màu của sản phẩm đã chọn
- `addExistingProduct()`: Thêm sản phẩm có sẵn vào danh sách
- `addNewProduct()`: Thêm sản phẩm mới vào danh sách
- `updateProductTable()`: Cập nhật bảng hiển thị
- `updateProductQuantity()`: Cập nhật số lượng sản phẩm
- `updateProductPrice()`: Cập nhật giá sản phẩm
- `removeProduct()`: Xóa sản phẩm khỏi danh sách
- `updateTotalAmount()`: Tính tổng tiền
- `updateHiddenInputs()`: Tạo hidden inputs để gửi form

## 🔄 Luồng hoạt động

### Khi mở modal tạo phiếu nhập:
1. Gọi API lấy mã PN tiếp theo → Hiển thị
2. Gọi API lấy thông tin user → Hiển thị
3. Reset danh sách sản phẩm

### Khi thêm sản phẩm có sẵn:
1. Click nút "Nhập sản phẩm có sẵn"
2. Chọn sản phẩm → Load size/màu
3. Điền thông tin → Click "Thêm vào danh sách"
4. Sản phẩm được thêm vào bảng
5. Tổng tiền tự động cập nhật

### Khi thêm sản phẩm mới:
1. Click nút "Thêm sản phẩm mới"
2. Điền tất cả thông tin sản phẩm
3. Click "Tạo & Thêm vào danh sách"
4. Sản phẩm được đánh dấu "● Sản phẩm mới"
5. Tổng tiền tự động cập nhật

### Khi submit form:
1. Tạo hidden inputs cho mỗi sản phẩm
2. Phân biệt sản phẩm có sẵn (gửi `maBienThe`) và sản phẩm mới (gửi thông tin đầy đủ)
3. Backend xử lý:
   - Sản phẩm có sẵn: Cập nhật tồn kho
   - Sản phẩm mới: Tạo sản phẩm → Tạo/Lấy size → Tạo/Lấy màu → Tạo biến thể → Thêm vào chi tiết nhập
4. Tính tổng tiền phiếu nhập
5. Lưu vào database

## 📊 Cấu trúc dữ liệu gửi lên server

### Cho sản phẩm có sẵn:
```
productTypes: ["existing"]
maBienThe: [123]
soLuongs: [10]
donGiaNhaps: [500000]
```

### Cho sản phẩm mới:
```
productTypes: ["new"]
newProductNames: ["Áo Polo Nam"]
newProductSizes: ["L"]
newProductColors: ["Xanh Navy"]
newProductQtys: [20]
newProductPriceImports: [300000]
newProductPriceSells: [500000]
```

### Cho nhiều sản phẩm:
```
productTypes: ["existing", "new", "existing"]
maBienThe: [123, null, 456]
soLuongs: [10, null, 5]
donGiaNhaps: [500000, null, 600000]
newProductNames: [null, "Áo Polo Nam", null]
newProductSizes: [null, "L", null]
...
```

## 🎨 Giao diện

### Màu sắc:
- **Xanh dương**: Sản phẩm có sẵn, Mã PN
- **Xanh lá**: Sản phẩm mới, Nhân viên
- **Xanh lá nhạt**: Badge "Sản phẩm mới"
- **Tím**: Badge màu sắc
- **Xanh da trời**: Badge size
- **Xanh đậm**: Số tiền

### Responsive:
- Desktop: Form 5 cột, bảng đầy đủ
- Tablet/Mobile: Form responsive, có thể scroll ngang

## ⚠️ Lưu ý khi sử dụng

1. **Phải chọn nhà cung cấp** trước khi submit
2. **Phải thêm ít nhất 1 sản phẩm** vào danh sách
3. Với sản phẩm có sẵn: **Phải chọn đủ Sản phẩm, Size, Màu**
4. Với sản phẩm mới: **Phải điền đầy đủ tất cả thông tin**
5. Số lượng và giá phải > 0
6. Size/Màu mới sẽ tự động tạo nếu chưa tồn tại

## 🐛 Xử lý lỗi

- Nếu không chọn đủ thông tin → Alert cảnh báo
- Nếu không tìm thấy biến thể → Alert thông báo
- Nếu có lỗi server → Hiển thị thông báo lỗi màu đỏ
- Thành công → Hiển thị thông báo xanh với mã phiếu

## 🚀 Cải tiến trong tương lai (tùy chọn)

1. Upload ảnh sản phẩm khi tạo mới
2. Thêm mô tả cho sản phẩm mới
3. Chọn thương hiệu cho sản phẩm mới
4. Import Excel để nhập hàng loạt
5. Scan barcode để thêm sản phẩm nhanh
6. Lịch sử chỉnh sửa phiếu nhập
7. In phiếu nhập PDF
8. Gửi email thông báo cho nhà cung cấp

## 📝 Testing checklist

- [x] Hiển thị mã PN tự động
- [x] Hiển thị người nhập tự động
- [x] Thêm sản phẩm có sẵn
- [x] Thêm sản phẩm mới
- [x] Xóa sản phẩm khỏi danh sách
- [x] Sửa số lượng trong bảng
- [x] Sửa giá trong bảng
- [x] Tính tổng tiền tự động
- [x] Tạo size mới tự động
- [x] Tạo màu mới tự động
- [x] Submit form thành công
- [x] Cập nhật tồn kho
- [x] Hiển thị thông báo lỗi/thành công

---

**Người thực hiện**: GitHub Copilot AI  
**Ngày hoàn thành**: 01/12/2025  
**Trạng thái**: ✅ Hoàn thành

