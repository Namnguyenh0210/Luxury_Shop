# HƯỚNG DẪN SỬ DỤNG - TẠO PHIẾU NHẬP KHO

## Bước 1: Mở form tạo phiếu nhập
1. Vào trang **Quản Lý Kho & NCC** (menu bên trái)
2. Tab **Nhập Kho**
3. Click nút **"Tạo Phiếu Nhập"** (màu xanh dương, góc trên bên phải)

## Bước 2: Kiểm tra thông tin tự động
Form sẽ tự động hiển thị:
- **Mã Phiếu Nhập**: PN1, PN2, PN3... (tăng dần tự động)
- **Nhân Viên Nhập**: Tên và email của bạn
- **Ngày Nhập**: Ngày giờ hiện tại

✅ Các thông tin này **không cần điền**, hệ thống tự động xử lý!

## Bước 3: Chọn nhà cung cấp
1. Chọn **Nhà Cung Cấp** từ dropdown (bắt buộc)
2. Nếu chưa có NCC, click tab **"Nhà Cung Cấp"** để thêm mới
3. Ghi chú (tùy chọn): Nhập thông tin thêm về lô hàng này

## Bước 4: Thêm sản phẩm

### Trường hợp 1: Nhập sản phẩm ĐÃ CÓ trong kho
**Ví dụ**: Nhập thêm áo Gucci đã có sẵn trong hệ thống

1. Click nút **"Nhập sản phẩm có sẵn"** (màu xanh dương)
2. Form màu xanh nhạt sẽ hiện ra
3. Điền thông tin:
   - **Sản Phẩm**: Chọn từ danh sách (VD: Áo Polo Gucci Cotton)
   - **Size**: Tự động load các size có sẵn (VD: M, L, XL)
   - **Màu**: Tự động load các màu có sẵn (VD: Trắng, Đen)
   - **Số Lượng**: Nhập số lượng nhập (VD: 10)
   - **Đơn Giá**: Nhập giá nhập (VD: 500000)
4. Click **"Thêm vào danh sách"**
5. Sản phẩm sẽ xuất hiện trong bảng bên dưới

### Trường hợp 2: Nhập sản phẩm MỚI (chưa có trong kho)
**Ví dụ**: Nhập sản phẩm mới hoàn toàn

1. Click nút **"Thêm sản phẩm mới"** (màu xanh lá)
2. Form màu xanh nhạt sẽ hiện ra
3. Điền **đầy đủ** thông tin:
   - **Tên Sản Phẩm**: VD: Áo Polo Nam Cao Cấp
   - **Loại Sản Phẩm**: Chọn từ danh sách (có thể bỏ qua)
   - **Size**: Nhập size mới (VD: L, XL, XXL...)
   - **Màu**: Nhập màu mới (VD: Xanh Navy, Be, Xám...)
   - **Số Lượng**: VD: 20
   - **Giá Nhập**: VD: 300000
   - **Giá Bán**: VD: 500000
4. Click **"Tạo & Thêm vào danh sách"**
5. Sản phẩm xuất hiện trong bảng với badge **"● Sản phẩm mới"**

💡 **Lưu ý**: Nếu Size hoặc Màu đã tồn tại trong hệ thống, hệ thống sẽ tự động dùng lại!

## Bước 5: Quản lý danh sách sản phẩm
Trong bảng danh sách, bạn có thể:

### Sửa số lượng/giá:
- Click vào ô số lượng hoặc đơn giá
- Nhập giá trị mới
- **Thành tiền** và **Tổng tiền** tự động cập nhật

### Xóa sản phẩm:
- Click icon **thùng rác** ở cột cuối
- Sản phẩm sẽ bị xóa khỏi danh sách

### Thêm nhiều sản phẩm:
- Lặp lại Bước 4 để thêm sản phẩm khác
- Không giới hạn số lượng sản phẩm

## Bước 6: Kiểm tra tổng tiền
- Xem **Tổng Tiền** ở cuối bảng
- Tổng tiền tự động tính = Σ (Số lượng × Đơn giá)
- Định dạng: 80,000,000₫

## Bước 7: Lưu phiếu nhập
1. Kiểm tra lại tất cả thông tin
2. Click nút **"Tạo Phiếu Nhập"** (màu xanh dương, góc dưới bên phải)
3. Đợi hệ thống xử lý

### Kết quả:
- ✅ **Thành công**: Hiển thị thông báo xanh "Tạo phiếu nhập thành công! Mã phiếu: PN..."
- ❌ **Lỗi**: Hiển thị thông báo đỏ với mô tả lỗi

## Sau khi tạo phiếu thành công:
Hệ thống sẽ tự động:
1. ✅ Tạo phiếu nhập với mã PN tự động
2. ✅ Lưu chi tiết sản phẩm
3. ✅ Cập nhật số lượng tồn kho
4. ✅ Cập nhật giá nhập vào biến thể
5. ✅ Tạo sản phẩm mới (nếu có)
6. ✅ Tạo size/màu mới (nếu cần)

## Kiểm tra phiếu nhập đã tạo:
1. Quay lại trang **Kho & NCC**
2. Xem danh sách phiếu nhập (hiển thị dạng card)
3. Click vào card để xem chi tiết
4. Popup sẽ hiện thông tin đầy đủ

---

## 📋 Checklist trước khi Submit

- [ ] Đã chọn Nhà Cung Cấp
- [ ] Đã thêm ít nhất 1 sản phẩm vào danh sách
- [ ] Các sản phẩm có đầy đủ Size, Màu, Số lượng, Giá
- [ ] Đã kiểm tra Tổng tiền
- [ ] Ghi chú (nếu cần)

## ⚠️ Các lỗi thường gặp

### Lỗi: "Vui lòng thêm ít nhất một sản phẩm!"
➡️ **Giải pháp**: Chưa thêm sản phẩm nào. Thực hiện Bước 4.

### Lỗi: "Vui lòng điền đầy đủ thông tin sản phẩm!"
➡️ **Giải pháp**: Kiểm tra lại form, đảm bảo tất cả trường bắt buộc (*) đã điền.

### Lỗi: "Không tìm thấy biến thể phù hợp!"
➡️ **Giải pháp**: Kết hợp Size + Màu không tồn tại. Thử chọn lại hoặc thêm sản phẩm mới.

### Lỗi: "Không tìm thấy nhà cung cấp"
➡️ **Giải pháp**: Chưa chọn NCC. Chọn từ dropdown hoặc thêm NCC mới.

---

## 💡 Mẹo sử dụng

1. **Nhập hàng loạt cùng NCC**: 
   - Thêm tất cả sản phẩm của 1 NCC vào 1 phiếu
   - Dễ quản lý và đối chiếu

2. **Phân biệt lô hàng**:
   - Dùng trường Ghi chú để ghi "Lô tháng 12", "Hàng SS2025"...

3. **Kiểm tra giá**:
   - So sánh với giá nhập lần trước (xem trong chi tiết sản phẩm)

4. **Sản phẩm mới**:
   - Size/Màu đặt tên chuẩn để tái sử dụng
   - VD: "M" thay vì "Size M", "Đỏ" thay vì "Màu đỏ"

5. **Sửa nhanh**:
   - Nếu nhầm số lượng/giá, sửa trực tiếp trong bảng
   - Không cần xóa và thêm lại

---

**Chúc bạn sử dụng hiệu quả! 🚀**

