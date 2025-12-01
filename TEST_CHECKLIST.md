# ✅ CHECKLIST KIỂM TRA - Tạo Phiếu Nhập Kho

## 📋 Pre-Testing Checklist

### Chuẩn Bị Môi Trường
- [ ] Database đã chạy script `db.sql`
- [ ] `application.properties` có đúng connection string
- [ ] Port 8080 không bị chiếm
- [ ] Maven dependencies đã download xong
- [ ] Project đã compile thành công (`mvn clean compile`)

---

## 🚀 Test Case 1: Khởi Động Hệ Thống

### Steps:
1. [ ] Mở terminal/command prompt
2. [ ] `cd D:\Asm_Java6`
3. [ ] `mvn spring-boot:run`
4. [ ] Đợi message "Started ProjectendApplication"
5. [ ] Mở browser: `http://localhost:8080`
6. [ ] Trang login hiển thị

### Expected Result:
- ✅ Server khởi động không lỗi
- ✅ Truy cập được trang login
- ✅ Không có error 404/500

---

## 🔐 Test Case 2: Đăng Nhập

### Steps:
1. [ ] Nhập email: `admin@luxury.com`
2. [ ] Nhập password: `123`
3. [ ] Click "Đăng nhập"

### Expected Result:
- ✅ Redirect sang `/admin/dashboard` hoặc `/admin/inventory`
- ✅ Hiển thị tên user "Admin Luxury"
- ✅ Menu sidebar hiển thị đầy đủ

---

## 📦 Test Case 3: Truy Cập Trang Inventory

### Steps:
1. [ ] Click menu "Kho & NCC" hoặc truy cập `http://localhost:8080/admin/inventory`
2. [ ] Kiểm tra 2 tabs: "Nhập Kho" và "Nhà Cung Cấp"

### Expected Result:
- ✅ Trang load thành công
- ✅ Tab "Nhập Kho" hiển thị danh sách phiếu (nếu có)
- ✅ Tab "Nhà Cung Cấp" hiển thị bảng NCC
- ✅ 3 cards thống kê hiển thị ở trên

---

## 🏪 Test Case 4: Thêm Nhà Cung Cấp (Nếu Chưa Có)

### Steps:
1. [ ] Click tab "Nhà Cung Cấp"
2. [ ] Click button "Thêm NCC" (màu tím)
3. [ ] Modal hiện lên
4. [ ] Điền thông tin:
   - Tên NCC: `Test Supplier ABC`
   - SĐT: `0901234567`
   - Địa chỉ: `123 Test Street, HCM`
5. [ ] Click "Lưu lại"

### Expected Result:
- ✅ Modal đóng
- ✅ Alert "Lưu nhà cung cấp thành công!"
- ✅ NCC mới xuất hiện trong bảng

---

## 📝 Test Case 5: Tạo Phiếu Nhập - Đơn Giản

### Steps:
1. [ ] Click tab "Nhập Kho"
2. [ ] Click button "Tạo Phiếu Nhập" (màu xanh dương)
3. [ ] Modal "Tạo Phiếu Nhập Kho" hiện lên

### Kiểm Tra Form:
4. [ ] Mã phiếu: "Tự động tạo" (disabled) ✅
5. [ ] Nhân viên: "admin@luxury.com" (disabled) ✅
6. [ ] Ngày nhập: Hiện tại (disabled) ✅
7. [ ] Dropdown NCC: Có danh sách NCC ✅
8. [ ] Textarea ghi chú: Trống ✅
9. [ ] Bảng chi tiết: "Chưa có sản phẩm nào" ✅

### Chọn NCC:
10. [ ] Click dropdown "Nhà Cung Cấp"
11. [ ] Chọn "Test Supplier ABC" (hoặc NCC khác)

### Thêm Sản Phẩm:
12. [ ] Click button "Thêm sản phẩm" (màu xanh lá)
13. [ ] Dòng mới xuất hiện với:
    - [ ] STT: 1
    - [ ] Dropdown Sản phẩm (enabled)
    - [ ] Dropdown Size (disabled)
    - [ ] Dropdown Màu (disabled)
    - [ ] Input Số lượng: 1
    - [ ] Input Đơn giá: 0
    - [ ] Thành tiền: 0₫

### Chọn Sản Phẩm:
14. [ ] Click dropdown "Sản Phẩm"
15. [ ] Chọn sản phẩm bất kỳ (ví dụ: "Áo Polo Gucci Xanh Đen")
16. [ ] **Kiểm tra:** 
    - [ ] Dropdown Size được enable
    - [ ] Dropdown Màu được enable
    - [ ] Size dropdown có danh sách (S, M, L, XL, ...)
    - [ ] Màu dropdown có danh sách (Đen, Trắng, ...)

### Chọn Size và Màu:
17. [ ] Click dropdown "Size"
18. [ ] Chọn size (ví dụ: "M")
19. [ ] Click dropdown "Màu"
20. [ ] Chọn màu (ví dụ: "Xanh đen")
21. [ ] **Kiểm tra:**
    - [ ] Đơn giá nhập tự động điền (nếu có giá nhập trước)
    - [ ] Nếu không tự động điền → OK (nhập thủ công)

### Nhập Số Lượng và Giá:
22. [ ] Click ô "Số lượng", nhập: `5`
23. [ ] Click ô "Đơn giá nhập", nhập: `5000000`
24. [ ] **Kiểm tra:**
    - [ ] Thành tiền tự động cập nhật: `25,000,000₫`
    - [ ] Tổng tiền phiếu cập nhật: `25,000,000₫`

### Điền Ghi Chú:
25. [ ] Click textarea "Ghi chú"
26. [ ] Nhập: `Test phiếu nhập đầu tiên`

### Submit:
27. [ ] Click button "Tạo Phiếu Nhập" (màu xanh dương)
28. [ ] **Kiểm tra:**
    - [ ] Redirect về `/admin/inventory`
    - [ ] Alert "Tạo phiếu nhập thành công! Mã phiếu: PNx"
    - [ ] Card phiếu mới xuất hiện ở đầu danh sách

### Expected Result:
- ✅ Phiếu nhập được tạo thành công
- ✅ Alert hiển thị mã phiếu
- ✅ Card phiếu hiển thị đúng thông tin:
  - Mã: PN (số)
  - NCC: Test Supplier ABC
  - Nhân viên: Admin Luxury
  - Ngày: Hôm nay
  - Tổng tiền: 25,000,000₫
  - Ghi chú: Test phiếu nhập đầu tiên

---

## 📝 Test Case 6: Tạo Phiếu Nhập - Nhiều Sản Phẩm

### Steps:
1. [ ] Click "Tạo Phiếu Nhập"
2. [ ] Chọn NCC: "Test Supplier ABC"
3. [ ] Click "Thêm sản phẩm" **3 lần**
4. [ ] Dòng 1:
   - [ ] SP: Áo Polo Gucci
   - [ ] Size: M
   - [ ] Màu: Xanh đen
   - [ ] SL: 10
   - [ ] Giá: 5,000,000
   - [ ] Thành tiền: 50,000,000₫ ✅
5. [ ] Dòng 2:
   - [ ] SP: T-Shirt Chanel
   - [ ] Size: L
   - [ ] Màu: Đen
   - [ ] SL: 5
   - [ ] Giá: 3,500,000
   - [ ] Thành tiền: 17,500,000₫ ✅
6. [ ] Dòng 3:
   - [ ] SP: Áo MLB
   - [ ] Size: S
   - [ ] Màu: Be
   - [ ] SL: 20
   - [ ] Giá: 2,800,000
   - [ ] Thành tiền: 56,000,000₫ ✅
7. [ ] **Kiểm tra Tổng tiền:** `123,500,000₫` ✅
8. [ ] Ghi chú: `Phiếu nhập nhiều sản phẩm`
9. [ ] Click "Tạo Phiếu Nhập"

### Expected Result:
- ✅ Phiếu nhập được tạo
- ✅ Alert "Tạo phiếu nhập thành công!"
- ✅ Card phiếu hiển thị tổng tiền: 123,500,000₫
- ✅ Database: 1 PhieuNhap + 3 NhapKhoChiTiet

---

## 🔍 Test Case 7: Xem Chi Tiết Phiếu Nhập

### Steps:
1. [ ] Click vào card phiếu nhập vừa tạo (bất kỳ vị trí trong card)
2. [ ] Modal "Chi Tiết Phiếu Nhập: PNx" hiện lên

### Kiểm Tra Nội Dung:
3. [ ] **Thông tin phiếu:**
   - [ ] Mã phiếu: PNx
   - [ ] Ngày nhập: dd/MM/yyyy HH:mm:ss
   - [ ] Nhà cung cấp: Test Supplier ABC
   - [ ] Nhân viên: Admin Luxury
   - [ ] Ghi chú: (như đã nhập)
4. [ ] **Bảng chi tiết:**
   - [ ] Số dòng = Số sản phẩm đã thêm
   - [ ] Mỗi dòng có: STT, Sản phẩm, Size, Màu, SL, Đơn giá, Thành tiền
   - [ ] Giá trị khớp với lúc nhập
5. [ ] **Tổng tiền:** Hiển thị đúng, format VND

### Expected Result:
- ✅ Modal hiển thị đầy đủ thông tin
- ✅ Bảng chi tiết đầy đủ và chính xác
- ✅ Tổng tiền đúng và format VND

---

## 🗑️ Test Case 8: Xóa Dòng Sản Phẩm

### Steps:
1. [ ] Click "Tạo Phiếu Nhập"
2. [ ] Chọn NCC
3. [ ] Click "Thêm sản phẩm" **3 lần**
4. [ ] Điền thông tin cho 3 dòng
5. [ ] Click icon 🗑️ ở dòng 2
6. [ ] **Kiểm tra:**
   - [ ] Dòng 2 bị xóa
   - [ ] Chỉ còn 2 dòng
   - [ ] Tổng tiền tự động cập nhật
7. [ ] Click icon 🗑️ ở dòng còn lại cho đến khi hết
8. [ ] **Kiểm tra:** Hiển thị "Chưa có sản phẩm nào"

### Expected Result:
- ✅ Xóa dòng thành công
- ✅ Tổng tiền cập nhật đúng
- ✅ Khi xóa hết → Hiển thị empty state

---

## ⚠️ Test Case 9: Validation

### Test 9.1: Không chọn NCC
1. [ ] Click "Tạo Phiếu Nhập"
2. [ ] Không chọn NCC
3. [ ] Thêm sản phẩm và điền đầy đủ
4. [ ] Click "Tạo Phiếu Nhập"
5. [ ] **Expected:** HTML5 error "Vui lòng chọn một mục trong danh sách" ✅

### Test 9.2: Không có sản phẩm
1. [ ] Click "Tạo Phiếu Nhập"
2. [ ] Chọn NCC
3. [ ] Không thêm sản phẩm nào
4. [ ] Click "Tạo Phiếu Nhập"
5. [ ] **Expected:** Có thể submit (phiếu rỗng) hoặc validation error ✅

### Test 9.3: Không chọn Size
1. [ ] Click "Tạo Phiếu Nhập"
2. [ ] Chọn NCC
3. [ ] Thêm sản phẩm
4. [ ] Chọn Sản phẩm
5. [ ] Không chọn Size
6. [ ] Chọn Màu
7. [ ] Click "Tạo Phiếu Nhập"
8. [ ] **Expected:** HTML5 error "Vui lòng điền vào trường này" ✅

### Test 9.4: Số lượng = 0
1. [ ] Click "Tạo Phiếu Nhập"
2. [ ] Thêm sản phẩm, chọn đầy đủ
3. [ ] Nhập số lượng: `0`
4. [ ] Click "Tạo Phiếu Nhập"
5. [ ] **Expected:** HTML5 error "Value must be >= 1" ✅

### Test 9.5: Đơn giá âm
1. [ ] Nhập đơn giá: `-1000`
2. [ ] **Expected:** HTML5 error "Value must be >= 0" ✅

---

## 🔄 Test Case 10: Kiểm Tra Database

### Steps:
1. [ ] Mở SQL Server Management Studio (hoặc tool khác)
2. [ ] Connect database `LuxuryFashion_2025`
3. [ ] Query bảng PhieuNhap:
   ```sql
   SELECT * FROM PhieuNhap ORDER BY NgayNhap DESC
   ```
4. [ ] **Kiểm tra:** Phiếu vừa tạo có trong bảng ✅
5. [ ] Query bảng NhapKhoChiTiet:
   ```sql
   SELECT * FROM NhapKhoChiTiet WHERE MaPN = (SELECT MAX(MaPN) FROM PhieuNhap)
   ```
6. [ ] **Kiểm tra:** Số dòng = Số sản phẩm đã thêm ✅
7. [ ] Query tồn kho:
   ```sql
   SELECT MaBienThe, SoLuongTon, GiaNhap 
   FROM SanPhamChiTiet 
   WHERE MaBienThe IN (
       SELECT MaBienThe FROM NhapKhoChiTiet 
       WHERE MaPN = (SELECT MAX(MaPN) FROM PhieuNhap)
   )
   ```
8. [ ] **Kiểm tra:** Tồn kho đã tăng ✅

### Expected Result:
- ✅ PhieuNhap có 1 record mới
- ✅ NhapKhoChiTiet có đúng số records = số sản phẩm
- ✅ SanPhamChiTiet.SoLuongTon đã tăng
- ✅ SanPhamChiTiet.GiaNhap đã cập nhật

---

## 🧪 Test Case 11: Performance & Stress Test

### Test 11.1: Nhiều Sản Phẩm
1. [ ] Tạo phiếu nhập với **10 sản phẩm**
2. [ ] **Expected:** Submit thành công trong < 3 giây ✅

### Test 11.2: Giá Trị Lớn
1. [ ] Nhập số lượng: `9999`
2. [ ] Nhập đơn giá: `999999999`
3. [ ] **Expected:** Tính toán đúng, không overflow ✅

### Test 11.3: Đa Tab
1. [ ] Mở 2 tabs browser
2. [ ] Cùng lúc tạo 2 phiếu nhập
3. [ ] **Expected:** Cả 2 phiếu đều tạo thành công ✅

---

## 🎯 Summary Checklist

### Must Pass:
- [ ] Server khởi động thành công
- [ ] Login thành công
- [ ] Truy cập /admin/inventory thành công
- [ ] Thêm NCC thành công
- [ ] Tạo phiếu nhập 1 SP thành công
- [ ] Tạo phiếu nhập nhiều SP thành công
- [ ] Xem chi tiết phiếu thành công
- [ ] Tồn kho cập nhật đúng
- [ ] Validation hoạt động

### Nice to Have:
- [ ] Auto-load Size/Màu nhanh (< 1s)
- [ ] Auto-fill giá hoạt động
- [ ] UI đẹp, responsive
- [ ] Không có lỗi JavaScript trong Console
- [ ] Không có error 404/500

---

## 📊 Test Result Summary

```
┌────────────────────────────┬────────┬────────┐
│ Test Case                  │ Pass   │ Fail   │
├────────────────────────────┼────────┼────────┤
│ 1. Khởi động hệ thống      │ [ ]    │ [ ]    │
│ 2. Đăng nhập               │ [ ]    │ [ ]    │
│ 3. Truy cập Inventory      │ [ ]    │ [ ]    │
│ 4. Thêm NCC                │ [ ]    │ [ ]    │
│ 5. Tạo phiếu đơn giản      │ [ ]    │ [ ]    │
│ 6. Tạo phiếu nhiều SP      │ [ ]    │ [ ]    │
│ 7. Xem chi tiết            │ [ ]    │ [ ]    │
│ 8. Xóa dòng SP             │ [ ]    │ [ ]    │
│ 9. Validation              │ [ ]    │ [ ]    │
│ 10. Kiểm tra Database      │ [ ]    │ [ ]    │
│ 11. Performance            │ [ ]    │ [ ]    │
└────────────────────────────┴────────┴────────┘

Overall Status: _____________
Tested By: _____________
Date: _____________
```

---

## 🐛 Bug Report Template

Nếu phát hiện lỗi, ghi lại theo format:

```
### Bug #___
**Severity:** [ ] Critical [ ] High [ ] Medium [ ] Low
**Module:** Inventory / Phiếu Nhập
**Description:** _______________________
**Steps to Reproduce:**
1. _______________________
2. _______________________
3. _______________________
**Expected:** _______________________
**Actual:** _______________________
**Screenshot:** (attach if possible)
**Browser:** _______________________
**Date:** _______________________
```

---

## ✅ Kết Luận

Sau khi hoàn thành tất cả test cases:
- [ ] Tất cả test cases PASS
- [ ] Không có bug critical/high
- [ ] Database consistent
- [ ] UI/UX tốt
- [ ] Performance ổn định

**Hệ thống sẵn sàng Production!** ✅

---

**Tester:** _________________
**Date:** _________________
**Status:** [ ] PASS [ ] FAIL [ ] PARTIAL

