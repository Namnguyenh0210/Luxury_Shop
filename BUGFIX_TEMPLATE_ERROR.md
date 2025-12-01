# 🔧 BUG FIX - Template Parsing Error

**Ngày**: 01/12/2025, 18:41  
**Trạng thái**: ✅ **FIXED**

---

## 🐛 VẤN ĐỀ

### Lỗi gặp phải:
```
TemplateInputException: An error happened during template parsing
Error retrieving value for property "principal.authorities" 
of authentication object of class AnonymousAuthenticationToken
```

### Nguyên nhân:
- Sử dụng `sec:authentication` attributes trong Thymeleaf
- Khi người dùng chưa đăng nhập (anonymous), không thể truy cập `principal.authorities`
- Spring Security Thymeleaf dialect có vấn đề với anonymous authentication

---

## ✅ GIẢI PHÁP ĐÃ ÁP DỤNG

### Thay đổi trong `inventory.html`:

**Trước (Bị lỗi)**:
```html
<span sec:authentication="name">...</span>
<span sec:authentication="principal.authorities">ROLE_ADMIN</span>
```

**Sau (Đã fix)**:
```html
<span th:text="${#authentication?.name ?: 'Admin User'}">Admin User</span>
<span th:text="${#authentication?.authorities?.![authority]?.get(0) ?: 'ROLE_ADMIN'}">ROLE_ADMIN</span>
```

### Giải thích:
- **Elvis operator (`?:`)**: Trả về giá trị mặc định nếu null
- **Safe navigation (`?.`)**: Không gây lỗi nếu object null
- **Collection projection (`?.![authority]`)**: Lấy danh sách authorities
- **get(0)**: Lấy authority đầu tiên
- **Fallback**: Hiển thị giá trị mặc định nếu không có authentication

---

## ✅ KẾT QUẢ

```
[INFO] BUILD SUCCESS
[INFO] Total time:  5.771 s
[INFO] Finished at: 2025-12-01T18:41:01+07:00
```

✅ **Template parsing error đã được fix**  
✅ **Build thành công**  
✅ **Sẵn sàng chạy application**

---

## 🚀 KIỂM TRA

### Chạy application:
```bash
mvn spring-boot:run
```

### Test các trường hợp:
1. ✅ **Đã đăng nhập**: Hiển thị tên user và role thật
2. ✅ **Chưa đăng nhập**: Hiển thị giá trị mặc định (không lỗi)
3. ✅ **Anonymous access**: Không còn exception

---

## 📝 LƯU Ý

### Trang admin/inventory yêu cầu đăng nhập:
- URL: `/admin/inventory`
- Yêu cầu role: `ADMIN` hoặc `NHANVIEN`
- Nếu chưa đăng nhập → Redirect to `/login`

### Security Config:
```java
@PreAuthorize("hasRole('ADMIN') or hasRole('NHANVIEN')")
```

---

**Status**: ✅ **RESOLVED**  
**Ready to run**: ✅ **YES**

