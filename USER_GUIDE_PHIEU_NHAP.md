# 📸 Hướng Dẫn Sử Dụng - Tạo Phiếu Nhập Kho

## 🎯 Truy Cập Trang Quản Lý Kho

**URL:** `http://localhost:8080/admin/inventory`

**Login:**
- Email: `admin@luxury.com`
- Password: `123`

---

## 📋 Giao Diện Chính

### Tab 1: Nhập Kho
- **Hiển thị:** Danh sách phiếu nhập dạng cards (3 cột)
- **Thông tin mỗi card:**
  - Mã phiếu (PN1, PN2, ...)
  - Nhà cung cấp
  - Nhân viên nhập
  - Ngày nhập
  - Tổng tiền (màu xanh lá)
  - Ghi chú (nếu có)
- **Button:** "Tạo Phiếu Nhập" (màu xanh dương)
- **Action:** Click vào card → Xem chi tiết popup

### Tab 2: Nhà Cung Cấp
- **Hiển thị:** Bảng danh sách NCC
- **Cột:** ID, Tên NCC, SĐT, Địa Chỉ, Thao Tác
- **Button:** "Thêm NCC" (màu tím)
- **Action:** Sửa/Xóa NCC

---

## ➕ Tạo Phiếu Nhập Mới

### Bước 1: Mở Form
Click button **"Tạo Phiếu Nhập"** → Modal hiện lên

### Bước 2: Điền Thông Tin Phiếu
```
┌─────────────────────────────────────────────┐
│  Tạo Phiếu Nhập Kho                    [X] │
├─────────────────────────────────────────────┤
│                                             │
│  Mã Phiếu Nhập        Nhân Viên Nhập       │
│  Tự động tạo          admin@luxury.com     │
│  (disabled)           (disabled)            │
│                                             │
│  Nhà Cung Cấp *       Ngày Nhập            │
│  [Dropdown NCC]       01/12/2025 17:00     │
│                       (disabled)            │
│                                             │
│  Ghi Chú                                    │
│  [Textarea: Nhập ghi chú...]               │
│                                             │
└─────────────────────────────────────────────┘
```

**Lưu ý:** 
- ⚠️ Nếu chưa có NCC → Chuyển sang **Tab "Nhà Cung Cấp"** → Click "Thêm NCC"
- ✅ Chọn NCC từ dropdown (required)

---

### Bước 3: Thêm Sản Phẩm

Click button **"+ Thêm sản phẩm"** (màu xanh lá)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  📦 Chi Tiết Sản Phẩm Nhập                      [+ Thêm sản phẩm]      │
├─────────────────────────────────────────────────────────────────────────┤
│ STT │ SẢN PHẨM* │ SIZE* │ MÀU* │ SỐ LƯỢNG* │ ĐƠN GIÁ NHẬP* │ THÀNH TIỀN │ XÓA │
├─────┼───────────┼───────┼──────┼───────────┼───────────────┼────────────┼─────┤
│  1  │ [Dropdown]│  ---  │ ---  │     1     │       0       │     0₫     │ [🗑] │
└─────────────────────────────────────────────────────────────────────────┘
                                                      Tổng Tiền:      0₫
```

**Các trường:**
- **Sản phẩm:** Dropdown chọn sản phẩm (required)
- **Size:** Dropdown (disabled ban đầu)
- **Màu:** Dropdown (disabled ban đầu)
- **Số lượng:** Input number (default = 1, min = 1)
- **Đơn giá nhập:** Input number (default = 0, min = 0, step = 1000)
- **Thành tiền:** Tự động tính = Số lượng × Đơn giá
- **Xóa:** Button xóa dòng này

---

### Bước 4: Chọn Sản Phẩm

Click dropdown **"Sản Phẩm"** → Chọn sản phẩm

```
┌──────────────────────────────────┐
│ -- Chọn sản phẩm --              │
├──────────────────────────────────┤
│ Áo Polo Gucci Xanh Đen          │ ← Click
│ T-Shirt Chanel Đen               │
│ Áo MLB Trắng Be                  │
│ ...                              │
└──────────────────────────────────┘
```

**Sau khi chọn:**
- ✅ Size dropdown được **enable** và load các size có sẵn
- ✅ Màu dropdown được **enable** và load các màu có sẵn

```
┌─────────────────────────────────────────────────────────────────────────┐
│ STT │ SẢN PHẨM*              │ SIZE*     │ MÀU*        │ SỐ LƯỢNG* │ ... │
├─────┼────────────────────────┼───────────┼─────────────┼───────────┼─────┤
│  1  │ Áo Polo Gucci Xanh Đen │ [S▼M▼L▼] │ [Xanh đen▼]│     1     │ ... │
└─────────────────────────────────────────────────────────────────────────┘
```

---

### Bước 5: Chọn Size và Màu

**Chọn Size:**
```
┌─────────────┐
│ S           │
│ M           │ ← Click
│ L           │
│ XL          │
└─────────────┘
```

**Chọn Màu:**
```
┌─────────────┐
│ Xanh đen    │ ← Click
│ Đen         │
│ Trắng       │
└─────────────┘
```

**Sau khi chọn cả Size và Màu:**
- ✅ Hệ thống tự động tìm `MaBienThe` (ID biến thể)
- ✅ **Đơn giá nhập** tự động điền (nếu có giá nhập trước đó)

```
┌─────────────────────────────────────────────────────────────────────────┐
│ STT │ SẢN PHẨM*              │ SIZE* │ MÀU*      │ SỐ LƯỢNG* │ ĐƠN GIÁ NHẬP* │
├─────┼────────────────────────┼───────┼───────────┼───────────┼───────────────┤
│  1  │ Áo Polo Gucci Xanh Đen │   M   │ Xanh đen  │     1     │   5,000,000   │
│                                                                ↑ Auto-fill
└─────────────────────────────────────────────────────────────────────────┘
```

---

### Bước 6: Nhập Số Lượng và Đơn Giá

**Nhập số lượng:**
- Click vào ô "Số lượng"
- Nhập số (ví dụ: `10`)
- Thành tiền tự động cập nhật

**Chỉnh đơn giá (nếu cần):**
- Click vào ô "Đơn giá nhập"
- Sửa giá (ví dụ: `5500000`)
- Thành tiền tự động cập nhật

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ STT │ SẢN PHẨM*              │ SIZE* │ MÀU*      │ SỐ LƯỢNG* │ ĐƠN GIÁ* │ THÀNH TIỀN │
├─────┼────────────────────────┼───────┼───────────┼───────────┼──────────┼────────────┤
│  1  │ Áo Polo Gucci Xanh Đen │   M   │ Xanh đen  │    10     │5,500,000 │55,000,000₫ │
│                                                      ↑           ↑          ↑
│                                                   nhập      chỉnh giá   tự động
└──────────────────────────────────────────────────────────────────────────────┘
                                                         Tổng Tiền: 55,000,000₫
                                                                        ↑ tự động
```

---

### Bước 7: Thêm Nhiều Sản Phẩm (Optional)

Click **"+ Thêm sản phẩm"** để thêm dòng mới

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ STT │ SẢN PHẨM*              │ SIZE* │ MÀU*      │ SỐ LƯỢNG* │ ĐƠN GIÁ* │ THÀNH TIỀN │
├─────┼────────────────────────┼───────┼───────────┼───────────┼──────────┼────────────┤
│  1  │ Áo Polo Gucci Xanh Đen │   M   │ Xanh đen  │    10     │5,500,000 │55,000,000₫ │
│  2  │ T-Shirt Chanel Đen     │   L   │ Đen       │     5     │3,500,000 │17,500,000₫ │
│  3  │ Áo MLB Trắng Be        │   S   │ Be        │    20     │2,800,000 │56,000,000₫ │
└──────────────────────────────────────────────────────────────────────────────┘
                                                       Tổng Tiền: 128,500,000₫
```

**Lưu ý:**
- ✅ Có thể thêm không giới hạn số dòng
- ✅ Tổng tiền cập nhật real-time
- ✅ Click [🗑] để xóa dòng không cần

---

### Bước 8: Submit

Click button **"💾 Tạo Phiếu Nhập"** (màu xanh dương)

**Validation:**
- ⚠️ Nhà cung cấp: Required
- ⚠️ Ít nhất 1 sản phẩm: Required
- ⚠️ Mỗi dòng phải điền đầy đủ: SP, Size, Màu, Số lượng, Đơn giá

**Nếu hợp lệ:**
```
┌─────────────────────────────────────────┐
│  ✅ Thành công!                         │
│  Tạo phiếu nhập thành công!            │
│  Mã phiếu: PN1                         │
└─────────────────────────────────────────┘
```

- ✅ Redirect về `/admin/inventory`
- ✅ Card phiếu mới hiển thị ở đầu danh sách
- ✅ Tồn kho các biến thể đã được cập nhật

---

## 🔍 Xem Chi Tiết Phiếu Nhập

### Cách 1: Click vào Card
Click vào bất kỳ card phiếu nhập nào trong tab "Nhập Kho"

```
┌─────────────────────────────────┐
│  Phiếu Nhập                    │
│  PN1                           │ ← Click anywhere
│  ────────────────────────────   │
│  🏪 NCC: Gucci VN              │
│  👤 NV: Admin                  │
│  📅 Ngày: 01/12/2025 14:30     │
│  💰 Tổng: 128,500,000₫         │
│  📝 Ghi chú: Nhập hàng...      │
│  ────────────────────────────   │
│  ➡️ Xem chi tiết               │
└─────────────────────────────────┘
```

### Popup Chi Tiết

```
┌─────────────────────────────────────────────────────────────────┐
│  Chi Tiết Phiếu Nhập: PN1                                  [X] │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  MÃ PHIẾU          NGÀY NHẬP                                   │
│  PN1               01/12/2025 14:30:00                         │
│                                                                 │
│  NHÀ CUNG CẤP      NHÂN VIÊN                                   │
│  Gucci VN          Admin Luxury                                │
│                                                                 │
│  GHI CHÚ                                                        │
│  Nhập hàng mùa hè                                              │
│                                                                 │
│  ───────────────────────────────────────────────────────────── │
│  📦 Chi Tiết Sản Phẩm Nhập                                     │
│  ───────────────────────────────────────────────────────────── │
│                                                                 │
│  ┌──┬────────────────┬──────┬─────────┬────┬──────────┬───────┐│
│  │# │ SẢN PHẨM       │ SIZE │ MÀU     │ SL │ ĐƠN GIÁ  │ T.TIỀN││
│  ├──┼────────────────┼──────┼─────────┼────┼──────────┼───────┤│
│  │1 │ Áo Polo Gucci  │  M   │ Xanh đen│ 10 │5,500,000 │55,000k││
│  │2 │ T-Shirt Chanel │  L   │ Đen     │  5 │3,500,000 │17,500k││
│  │3 │ Áo MLB         │  S   │ Be      │ 20 │2,800,000 │56,000k││
│  └──┴────────────────┴──────┴─────────┴────┴──────────┴───────┘│
│                                                                 │
│                       Tổng Tiền Phiếu Nhập:                    │
│                           128,500,000₫                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🏭 Quản Lý Nhà Cung Cấp

### Thêm NCC Mới

1. Click tab **"Nhà Cung Cấp"**
2. Click button **"+ Thêm NCC"** (màu tím)
3. Popup hiện lên:

```
┌───────────────────────────────┐
│  Thêm Nhà Cung Cấp       [X] │
├───────────────────────────────┤
│                               │
│  Tên Nhà Cung Cấp *          │
│  [________________]           │
│                               │
│  Số Điện Thoại               │
│  [________________]           │
│                               │
│  Địa Chỉ                     │
│  [________________]           │
│                               │
│  ─────────────────────────   │
│          [Hủy]  [Lưu lại]    │
└───────────────────────────────┘
```

4. Điền thông tin
5. Click **"Lưu lại"**
6. NCC mới xuất hiện trong bảng

### Sửa NCC

1. Click icon **✏️** (Edit) trong cột "Thao Tác"
2. Popup "Cập Nhật Nhà Cung Cấp" hiện lên (tương tự form thêm)
3. Sửa thông tin
4. Click "Lưu lại"

### Xóa NCC

1. Click icon **🗑️** (Delete) trong cột "Thao Tác"
2. Confirm: "Xóa nhà cung cấp này?"
3. Click OK → NCC bị xóa

**⚠️ Lưu ý:** Không thể xóa NCC đang có phiếu nhập

---

## 📊 Thống Kê Trang Chủ

Ở đầu trang hiển thị 3 cards thống kê:

```
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│ Tổng số lượng    │  │ Sản phẩm đang    │  │ Nhà cung cấp     │
│ nhập             │  │ bán              │  │                  │
│                  │  │                  │  │                  │
│      1,234       │  │       156        │  │        12        │
└──────────────────┘  └──────────────────┘  └──────────────────┘
```

---

## 💡 Tips & Tricks

### ✅ Nên làm:
1. **Thêm NCC trước** khi tạo phiếu nhập
2. **Kiểm tra giá tự động điền** - có thể là giá nhập lần trước
3. **Thêm ghi chú** để dễ tra cứu sau này
4. **Double-check số lượng** trước khi submit

### ⚠️ Lưu ý:
1. **Size + Màu** phải khớp với biến thể có sẵn trong hệ thống
2. **Không thể sửa/xóa** phiếu nhập sau khi tạo (tính năng này sẽ thêm sau)
3. **Tồn kho tự động cập nhật** - không cần cập nhật thủ công

### 🐛 Troubleshooting:
- **Dropdown Size/Màu không hiện?** → Sản phẩm chưa có biến thể, cần thêm trong "Quản Lý Sản Phẩm"
- **Giá tự động = 0?** → Biến thể chưa có giá nhập, nhập thủ công
- **Không submit được?** → Kiểm tra validation: NCC, ít nhất 1 SP, đầy đủ thông tin

---

## 🎯 Kết Luận

### Quy trình chuẩn:
1. ✅ Tab "Nhà Cung Cấp" → Thêm NCC (nếu chưa có)
2. ✅ Tab "Nhập Kho" → Click "Tạo Phiếu Nhập"
3. ✅ Chọn NCC, điền ghi chú
4. ✅ Thêm sản phẩm → Chọn SP, Size, Màu
5. ✅ Nhập số lượng, đơn giá
6. ✅ Kiểm tra tổng tiền
7. ✅ Submit → Done!

**Chúc bạn sử dụng hiệu quả!** 🎉

