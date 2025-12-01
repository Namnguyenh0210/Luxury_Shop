# Tóm Tắt Thay Đổi - Quản Lý Sản Phẩm Admin

## Ngày: 1 tháng 12, 2025

### Các thay đổi đã thực hiện:

## 1. ✅ Thay đổi trạng thái sản phẩm
**Trước:** Còn hàng / Hết hàng  
**Sau:** Đang bán / Ngừng bán

- Cập nhật labels trong bảng danh sách sản phẩm
- Cập nhật options trong form modal
- Cập nhật JavaScript để xử lý đúng status values (1 = Đang bán, 0 = Ngừng bán)
- Giá trị trong database không thay đổi (TrangThaiSP: 1 = Đang bán, 0 = Ngừng bán)

## 2. ✅ Xóa nút "Thêm Mới"
- Đã xóa button "Thêm Mới" khỏi trang product-list.html
- Modal form vẫn còn để sử dụng cho chức năng chỉnh sửa sản phẩm

## 3. ✅ Thêm bộ lọc sản phẩm
Đã thêm 4 bộ lọc:
- **Tìm kiếm:** Lọc theo tên sản phẩm (keyword search)
- **Danh mục:** Lọc theo loại sản phẩm (categoryId)
- **Thương hiệu:** Lọc theo brand (brandId)
- **Trạng thái:** Lọc theo trạng thái (1 = Đang bán, 0 = Ngừng bán)

### Files đã tạo mới:

1. **ThuongHieuService.java**
   - Location: `src/main/java/com/example/projectend/service/ThuongHieuService.java`
   - Chức năng: Service để lấy danh sách thương hiệu

### Files đã chỉnh sửa:

1. **AdminSanPhamController.java**
   - Location: `src/main/java/com/example/projectend/controller/admin/AdminSanPhamController.java`
   - Thêm autowired ThuongHieuService
   - Cập nhật method listProducts() để hỗ trợ filter theo categoryId, brandId, status, keyword
   - Truyền brands vào model
   - Giữ filter values để hiển thị selected options

2. **product-list.html**
   - Location: `src/main/resources/templates/admin/product-list.html`
   - Xóa nút "Thêm Mới"
   - Thêm Filter Section với 4 filters (keyword, category, brand, status)
   - Thêm cột "Thương Hiệu" vào bảng
   - Cập nhật labels trạng thái: "Đang bán" / "Ngừng bán"
   - Thêm field "Thương hiệu" vào modal form
   - Cập nhật JavaScript để xử lý brandId

### Cấu trúc bộ lọc mới:

```html
<form th:action="@{/admin/products}" method="get">
  - Input: keyword (tìm kiếm tên sản phẩm)
  - Select: categoryId (danh mục)
  - Select: brandId (thương hiệu)
  - Select: status (trạng thái: 1 hoặc 0)
  - Button: Lọc
  - Button: Xóa bộ lọc (reset về /admin/products)
</form>
```

### Cách sử dụng:

1. **Lọc sản phẩm:**
   - Chọn các tiêu chí lọc (danh mục, thương hiệu, trạng thái)
   - Nhập từ khóa tìm kiếm (nếu muốn)
   - Click "Lọc"

2. **Xóa bộ lọc:**
   - Click "Xóa bộ lọc" để hiển thị tất cả sản phẩm

3. **Chỉnh sửa sản phẩm:**
   - Click icon "edit" (bút chì màu xanh)
   - Modal sẽ mở với thông tin sản phẩm
   - Chỉnh sửa thông tin (tên, danh mục, thương hiệu, trạng thái)
   - Click "Lưu lại"

### Trạng thái trong Database:

```sql
-- Bảng SanPham
TrangThaiSP INT NOT NULL DEFAULT 1
-- 1 = Đang bán
-- 0 = Ngừng bán
```

### Ghi chú:
- Tất cả các filter hoạt động với logic AND (tất cả điều kiện phải thỏa mãn)
- Filter values được giữ lại sau khi submit form
- Responsive design cho mobile (grid cols-1 md:cols-4)
- Thương hiệu được hiển thị với badge màu xanh
- Trạng thái "Đang bán" = màu xanh lá, "Ngừng bán" = màu đỏ

