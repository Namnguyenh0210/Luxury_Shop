# 🔧 Hướng Dẫn Debug Popup Không Hiển Thị

## ⚠️ Vấn đề: Click vào tên sản phẩm nhưng popup không hiện

### Bước 1: Mở Developer Tools (F12)

1. Mở trang `/admin/products`
2. Nhấn **F12** để mở Developer Tools
3. Chọn tab **Console**

### Bước 2: Click vào tên sản phẩm

Click vào TÊN BẤT KỲ sản phẩm nào trong bảng.

### Bước 3: Kiểm tra Console Log

Bạn sẽ thấy các log sau nếu code chạy đúng:

```
DOM fully loaded
detailsModal exists: true
detailsLoading exists: true
detailsContent exists: true
showProductDetails called
Product ID: 1
Showing modal...
Fetching product details...
Response status: 200
Product data: {maSP: 1, tenSP: "...", ...}
```

### Bước 4: Kiểm tra từng trường hợp lỗi

#### ❌ Case 1: Không thấy log "showProductDetails called"
**Nguyên nhân:** JavaScript chưa load hoặc function chưa được gán

**Cách fix:**
1. Hard refresh: `Ctrl + Shift + R`
2. Xóa cache browser
3. Kiểm tra xem có lỗi JavaScript trước đó không

**Test:**
Gõ vào Console:
```javascript
console.log(typeof window.showProductDetails);
```
Kết quả mong đợi: `"function"`

---

#### ❌ Case 2: Log "Product ID: undefined"
**Nguyên nhân:** Attribute `data-product-id` không được render đúng

**Cách fix:**
1. View page source (Ctrl + U)
2. Tìm kiếm `data-product-id`
3. Xem có giá trị không

**Ví dụ đúng:**
```html
<button type="button" data-product-id="1" onclick="showProductDetails(this)">
    Áo Polo Gucci Cotton
</button>
```

**Nếu thấy:**
```html
<button type="button" onclick="showProductDetails(this)">
```
→ Thymeleaf chưa render đúng

**Fix:** Đã sửa bằng `th:attr="data-product-id=${p.maSP}"`

---

#### ❌ Case 3: Log "detailsModal exists: false"
**Nguyên nhân:** Modal element không tồn tại trong DOM

**Cách fix:**
1. View page source
2. Tìm kiếm `id="detailsModal"`
3. Kiểm tra modal có trong HTML không

**Test trong Console:**
```javascript
document.getElementById('detailsModal');
```
Kết quả mong đợi: `<div id="detailsModal" ...>`

Nếu null → Modal bị thiếu trong HTML

---

#### ❌ Case 4: Response status: 404
**Nguyên nhân:** API endpoint không tồn tại

**Cách fix:**
1. Kiểm tra server có chạy không
2. Kiểm tra URL đúng: `/admin/products/api/details/1`

**Test trong Console:**
```javascript
fetch('/admin/products/api/details/1')
  .then(r => console.log(r.status));
```
Kết quả mong đợi: `200`

Nếu 404 → Controller chưa có endpoint hoặc server chưa restart

---

#### ❌ Case 5: Response status: 500
**Nguyên nhân:** Lỗi server khi serialize JSON

**Cách fix:**
1. Xem Server log (trong terminal chạy app)
2. Tìm exception: `JsonMappingException` hoặc `StackOverflowError`

**Nguyên nhân phổ biến:**
- Vòng lặp vô hạn khi serialize (SanPham → SanPhamChiTiet → SanPham → ...)

**Fix:** Đã thêm `@JsonIgnoreProperties({"variants"})` trong SanPhamChiTiet.java

---

#### ❌ Case 6: Modal vẫn không hiện dù không có lỗi
**Nguyên nhân:** CSS class `hidden` không được remove hoặc z-index thấp

**Cách fix:**

**Test trong Console:**
```javascript
const modal = document.getElementById('detailsModal');
console.log(modal.classList.contains('hidden')); // Should be false after click
console.log(window.getComputedStyle(modal).display); // Should NOT be 'none'
console.log(window.getComputedStyle(modal).zIndex); // Should be '50'
```

**Manual test - Force show modal:**
```javascript
document.getElementById('detailsModal').classList.remove('hidden');
```
→ Nếu modal hiện → JavaScript logic có vấn đề
→ Nếu vẫn không hiện → CSS có vấn đề

---

### Bước 5: Test thủ công từng bước

#### Test 1: Modal element tồn tại
```javascript
console.log(document.getElementById('detailsModal'));
```

#### Test 2: Function tồn tại
```javascript
console.log(typeof window.showProductDetails);
```

#### Test 3: Gọi function thủ công
```javascript
// Get first product button
const btn = document.querySelector('button[data-product-id]');
console.log(btn);
console.log(btn.getAttribute('data-product-id'));

// Call function
window.showProductDetails(btn);
```

#### Test 4: Check modal visibility
```javascript
const modal = document.getElementById('detailsModal');
console.log('Has hidden class:', modal.classList.contains('hidden'));
console.log('Display:', window.getComputedStyle(modal).display);
console.log('Visibility:', window.getComputedStyle(modal).visibility);
console.log('Z-index:', window.getComputedStyle(modal).zIndex);
```

---

### Bước 6: Quick Fixes

#### Fix 1: Restart server
```bash
# Stop server (Ctrl + C)
# Start again
cd D:\Asm_Java6
mvn clean spring-boot:run
```

#### Fix 2: Clear browser cache
1. Ctrl + Shift + Delete
2. Chọn "Cached images and files"
3. Clear data
4. Hard refresh: Ctrl + Shift + R

#### Fix 3: Test với Chrome Incognito
- Ctrl + Shift + N (Chrome)
- Đăng nhập lại
- Test popup

---

### Bước 7: Kiểm tra Network Tab

1. Mở DevTools → Tab **Network**
2. Click vào tên sản phẩm
3. Tìm request: `/admin/products/api/details/{id}`

**Kiểm tra:**
- ✅ Status Code: 200 OK
- ✅ Response Type: application/json
- ✅ Response có chứa `tenSP`, `variants`, etc.

**Preview response:**
```json
{
  "maSP": 1,
  "tenSP": "Áo Polo Gucci Cotton",
  "loaiSanPham": {
    "maLoai": 1,
    "tenLoai": "Áo Polo"
  },
  "thuongHieu": {
    "maTH": 1,
    "tenTH": "Gucci"
  },
  "variants": [
    {
      "maBienThe": 1,
      "sizeSP": {"tenSize": "S"},
      "mauSacSP": {"tenMau": "Đen"},
      "giaBan": 15000000,
      "soLuongTon": 20
    }
  ]
}
```

---

## ✅ Checklist Debug

- [ ] F12 mở được Developer Tools
- [ ] Console log hiển thị "DOM fully loaded"
- [ ] Console log hiển thị "detailsModal exists: true"
- [ ] Click vào tên sản phẩm
- [ ] Console log hiển thị "showProductDetails called"
- [ ] Console log hiển thị Product ID
- [ ] Console log hiển thị "Showing modal..."
- [ ] Console log hiển thị "Response status: 200"
- [ ] Console log hiển thị Product data
- [ ] Modal xuất hiện trên màn hình
- [ ] Loading spinner hiển thị rồi biến mất
- [ ] Thông tin sản phẩm hiển thị đúng
- [ ] Variants/sizes hiển thị đúng

---

## 🆘 Nếu vẫn không được

Gửi cho tôi:

1. **Screenshot Console logs**
2. **Screenshot Network tab** (request `/admin/products/api/details/1`)
3. **Server logs** (trong terminal)

Hoặc test command nhanh:

```javascript
// Paste vào Console và chạy
(function test() {
  console.log('=== DIAGNOSTIC TEST ===');
  console.log('1. detailsModal:', !!document.getElementById('detailsModal'));
  console.log('2. showProductDetails:', typeof window.showProductDetails);
  
  const btn = document.querySelector('button[data-product-id]');
  console.log('3. First button:', !!btn);
  console.log('4. Button has data-product-id:', btn ? btn.getAttribute('data-product-id') : 'N/A');
  
  fetch('/admin/products/api/details/1')
    .then(r => console.log('5. API status:', r.status))
    .catch(e => console.log('5. API error:', e.message));
})();
```

Copy kết quả và gửi cho tôi!

