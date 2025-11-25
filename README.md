#  dự án thương mại điện tử thời trang cao cấp

Dự án này là một trang web thương mại điện tử được xây dựng để bán các mặt hàng thời trang Tết, sử dụng Java Spring Boot và các công nghệ web hiện đại. Tài liệu này cung cấp một hướng dẫn đầy đủ để một nhà phát triển mới có thể hiểu, cài đặt và chạy dự án từ đầu đến cuối.

## 1. Tổng quan dự án

### 1.1. Mục tiêu dự án

Mục tiêu chính của dự án là xây dựng một nền tảng thương mại điện tử đầy đủ chức năng, cho phép người dùng xem, tìm kiếm, thêm vào giỏ hàng và mua các sản phẩm thời trang. Dự án cũng tập trung vào việc cung cấp trải nghiệm người dùng mượt mà và an toàn, đặc biệt là trong quá trình đăng nhập và thanh toán.

### 1.2. Công nghệ sử dụng

- **Backend**:
  - **Ngôn ngữ**: Java 17
  - **Framework**: Spring Boot 3.2.0
  - **Xác thực & Phân quyền**: Spring Security, Google OAuth2
  - **Truy cập dữ liệu**: Spring Data JPA (Hibernate)
  - **Cổng thanh toán**: Tích hợp PayOS API
- **Frontend**:
  - **Template Engine**: Thymeleaf
  - **Styling**: CSS, có thể có sự hỗ trợ của các thư viện như Tailwind CSS (dựa trên cấu hình).
- **Cơ sở dữ liệu**:
  - **Hệ quản trị CSDL**: Microsoft SQL Server
- **Build Tool**:
  - **Quản lý dependency**: Apache Maven

### 1.3. Sơ lược luồng hoạt động

Luồng hoạt động của hệ thống tuân theo mô hình MVC (Model-View-Controller) kết hợp với các dịch vụ bên ngoài:

1.  **Người dùng (Frontend)**: Tương tác với giao diện người dùng được xây dựng bằng Thymeleaf và các file HTML/CSS/JS tĩnh.
2.  **Backend (Spring Boot)**:
    -   `Controller`: Tiếp nhận các yêu cầu HTTP từ frontend.
    -   `Service`: Xử lý logic nghiệp vụ chính (ví dụ: quản lý sản phẩm, giỏ hàng, xác thực).
    -   `Repository`: Tương tác với cơ sở dữ liệu thông qua Spring Data JPA.
    -   `Entity`: Định nghĩa các đối tượng được ánh xạ tới các bảng trong cơ sở dữ liệu.
3.  **Cơ sở dữ liệu (SQL Server)**: Lưu trữ toàn bộ dữ liệu của ứng dụng như thông tin người dùng, sản phẩm, đơn hàng, v.v.
4.  **Dịch vụ bên ngoài**:
    -   **Google OAuth2**: Xử lý đăng nhập thông qua tài khoản Google.
    -   **PayOS**: Xử lý các giao dịch thanh toán khi người dùng đặt hàng.

---

## 2. Cấu trúc dự án chi tiết (Không viết tắt)

Dưới đây là cấu trúc cây thư mục được liệt kê đầy đủ và giải thích chức năng của từng file quan trọng.

```
.
├── pom.xml                         // File cấu hình Maven, quản lý tất cả thư viện và cách build dự án.
├── db.sql                          // Script SQL để tạo cấu trúc database (bảng, quan hệ) và dữ liệu mẫu.
├── run.sh                          // Script để chạy dự án trên môi trường Linux/macOS.
├── run.bat                         // Script để chạy dự án trên môi trường Windows.
├── src                             // Thư mục chứa toàn bộ mã nguồn của dự án.
│   ├── main
│   │   ├── java
│   │   │   └── com/example/projectend  // Gói (package) chính của ứng dụng Java.
│   │   │       ├── ProjectendApplication.java    // Điểm khởi đầu, chứa hàm main() để chạy ứng dụng Spring Boot.
│   │   │       │
│   │   │       ├── config                        // Thư mục chứa các lớp cấu hình của Spring.
│   │   │       │   ├── SecurityConfig.java       // Cấu hình bảo mật: form login, phân quyền, Google OAuth2.
│   │   │       │   ├── PayOSConfig.java          // Cấu hình liên quan đến cổng thanh toán PayOS.
│   │   │       │   └── GlobalModelAdvice.java    // Thêm các thuộc tính/model chung cho tất cả các trang.
│   │   │       │
│   │   │       ├── controller                    // Tầng xử lý yêu cầu HTTP từ người dùng và trả về response.
│   │   │       │   ├── admin                     // Các controller dành riêng cho trang quản trị (Admin).
│   │   │       │   │   ├── AdminSanPhamController.java   // Quản lý sản phẩm (Thêm, Sửa, Xóa).
│   │   │       │   │   ├── AdminDonHangController.java   // Quản lý các đơn hàng của khách.
│   │   │       │   │   ├── AdminTaiKhoanController.java  // Quản lý tài khoản người dùng.
│   │   │       │   │   ├── AdminBaiVietController.java   // Quản lý các bài viết, blog.
│   │   │       │   │   ├── AdminThongKeController.java   // Xử lý các chức năng thống kê, báo cáo.
│   │   │       │   │   └── StaffDashboardController.java // Dashboard cho nhân viên.
│   │   │       │   ├── staff                     // Các controller dành cho vai trò nhân viên (Staff).
│   │   │       │   │   ├── StaffBaiVietController.java   // Nhân viên quản lý bài viết.
│   │   │       │   │   └── StaffDonHangController.java   // Nhân viên xử lý đơn hàng.
│   │   │       │   ├── HomeController.java       // Xử lý trang chủ.
│   │   │       │   ├── AuthController.java       // Xử lý các yêu cầu đăng nhập, đăng ký, đăng xuất.
│   │   │       │   ├── SanPhamController.java    // Xử lý hiển thị danh sách và chi tiết sản phẩm cho khách hàng.
│   │   │       │   ├── GioHangController.java    // Xử lý các thao tác với giỏ hàng (thêm, xóa, cập nhật).
│   │   │       │   ├── CheckoutController.java   // Xử lý quá trình đặt hàng và thanh toán.
│   │   │       │   ├── PayOSController.java      // Xử lý các callback (return, cancel, webhook) từ PayOS.
│   │   │       │   ├── ProfileController.java    // Xử lý trang thông tin cá nhân của người dùng.
│   │   │       │   ├── ApiController.java        // Cung cấp các API endpoint cho các tác vụ AJAX.
│   │   │       │   ├── BaseController.java       // Controller cơ sở, có thể chứa các phương thức chung.
│   │   │       │   ├── DashboardController.java  // Controller cho dashboard chung.
│   │   │       │   ├── GioiThieuController.java  // Controller cho trang giới thiệu.
│   │   │       │   ├── KienThucController.java   // Controller cho trang kiến thức, blog.
│   │   │       │   └── LienHeController.java     // Controller cho trang liên hệ.
│   │   │       │
│   │   │       ├── dto                           // Data Transfer Object: Các đối tượng dùng để truyền dữ liệu giữa các tầng.
│   │   │       │   ├── CartItemDTO.java          // Đại diện cho một sản phẩm trong giỏ hàng (view).
│   │   │       │   ├── CheckoutItemDTO.java      // Đại diện cho một sản phẩm ở trang thanh toán.
│   │   │       │   ├── ContactForm.java          // Dữ liệu từ form liên hệ.
│   │   │       │   ├── PayOSData.java            // Dữ liệu giao dịch từ PayOS.
│   │   │       │   ├── PayOSItem.java            // Một sản phẩm trong yêu cầu gửi đến PayOS.
│   │   │       │   ├── PayOSRequest.java         // Dữ liệu để tạo yêu cầu thanh toán gửi đến PayOS.
│   │   │       │   ├── PayOSResponse.java        // Dữ liệu phản hồi từ PayOS.
│   │   │       │   └── PayOSWebhookData.java     // Dữ liệu mà PayOS gửi về qua webhook.
│   │   │       │
│   │   │       ├── entity                        // Các lớp Java ánh xạ tới các bảng trong cơ sở dữ liệu.
│   │   │       │   ├── TaiKhoan.java             // Bảng `TaiKhoan` (th��ng tin người dùng).
│   │   │       │   ├── SanPham.java              // Bảng `SanPham` (thông tin chung của sản phẩm).
│   │   │       │   ├── SanPhamChiTiet.java       // Bảng `SanPhamChiTiet` (biến thể sản phẩm theo màu, size).
│   │   │       │   ├── DonHang.java              // Bảng `DonHang` (thông tin đơn hàng).
│   │   │       │   ├── DonHangChiTiet.java       // Bảng `DonHangChiTiet` (các sản phẩm trong đơn hàng).
│   │   │       │   ├── GioHang.java              // Bảng `GioHang` (giỏ hàng của mỗi tài khoản).
│   │   │       │   ├── GioHangChiTiet.java       // Bảng `GioHangChiTiet` (các sản phẩm trong giỏ hàng).
│   │   │       │   ├── GioHangId.java            // Khóa phức hợp cho `GioHangChiTiet`.
│   │   │       │   ├── VaiTro.java               // Bảng `VaiTro` (ADMIN, NHANVIEN, KHACHHANG).
│   │   │       │   ├── BaiViet.java              // Bảng `BaiViet` (bài viết blog).
│   │   │       │   ├── DanhGia.java              // Bảng `DanhGia` (đánh giá sản phẩm của khách hàng).
│   │   │       │   ├── DiaChi.java               // Bảng `DiaChi` (địa chỉ của khách hàng).
│   │   │       │   ├── KhuyenMai.java            // Bảng `KhuyenMai` (chương trình khuyến mãi).
│   │   │       │   ├── KhuyenMaiChiTiet.java     // Bảng `KhuyenMaiChiTiet` (chi tiết khuyến mãi).
│   │   │       │   ├── LichSuDonHang.java        // Bảng `LichSuDonHang` (lịch sử thay đổi trạng thái đơn hàng).
│   │   │       │   ├── LoaiBaiViet.java          // Bảng `LoaiBaiViet` (phân loại bài viết).
│   │   │       │   ├── LoaiSanPham.java          // Bảng `LoaiSanPham` (áo, quần, váy...).
│   │   │       │   ├── MauSacSP.java             // Bảng `MauSacSP` (danh mục màu sắc).
│   │   │       │   ├── NhapKho.java              // Bảng `NhapKho` (lịch sử nhập kho).
│   │   │       │   ├── PhuongThucThanhToan.java  // Bảng `PhuongThucThanhToan` (COD, PayOS).
│   │   │       │   ├── SizeSP.java               // Bảng `SizeSP` (danh mục size).
│   │   │       │   ├── ThongKe.java              // Entity ảo cho mục đích thống kê.
│   │   │       │   ├── ThuongHieu.java           // Bảng `ThuongHieu` (Gucci, Chanel...).
│   │   │       │   └── TrangThaiDonHang.java     // Bảng `TrangThaiDonHang` (Chờ xử lý, Đang giao...).
│   │   │       │
│   │   │       ├── repository                    // Tầng truy cập dữ liệu (DAO), giao tiếp với database.
│   │   │       │   ├── TaiKhoanRepository.java   // Các hàm để truy vấn bảng `TaiKhoan`.
│   │   │       │   ├── SanPhamRepository.java    // Các hàm để truy vấn bảng `SanPham`.
│   │   │       │   ├── DonHangRepository.java    // Các hàm để truy vấn bảng `DonHang`.
│   │   │       │   ├── BaiVietRepository.java, DanhGiaRepository.java, ... // Và các repository khác tương ứng với mỗi entity.
│   │   │       │
│   │   │       ├── service                       // Tầng chứa logic nghiệp vụ chính của ứng dụng.
│   │   │       │   ├── auth                      // Gói chứa các service liên quan đến xác thực.
│   │   │       │   │   ├── UserDetailsServiceImpl.java   // Tải thông tin user cho Spring Security (form login).
│   │   │       │   │   ├── CustomOAuth2UserService.java  // Xử lý logic sau khi đăng nhập Google thành công.
│   │   │       │   │   └── CustomOAuth2User.java         // Lớp bao bọc user của OAuth2 đ��� thêm vai trò.
│   │   │       │   ├── PayOSService.java         // Logic tạo link thanh toán và xác thực callback từ PayOS.
│   │   │       │   ├── DonHangService.java       // Logic xử lý đơn hàng.
│   │   │       │   ├── GioHangService.java       // Logic xử lý giỏ hàng.
│   │   │       │   ├── SanPhamService.java       // Logic xử lý nghiệp vụ liên quan đến sản phẩm.
│   │   │       │   ├── AuthService.java          // Logic liên quan đến xác thực.
│   │   │       │   ├── BaiVietService.java       // Logic xử lý bài viết.
│   │   │       │   ├── DanhGiaService.java       // Logic xử lý đánh giá.
│   │   │       │   ├── DiaChiService.java        // Logic xử lý địa chỉ.
│   │   │       │   ├── LoaiSanPhamService.java   // Logic xử lý loại sản phẩm.
│   │   │       │   └── PhuongThucThanhToanService.java // Logic xử lý phương thức thanh toán.
│   │   │       │
│   │   │       └── util                          // Thư mục chứa các lớp tiện ích.
│   │   │           └── QRCodeUtil.java           // Tiện ích để tạo mã QR.
│   │   │
│   │   └── resources                     // Thư mục chứa các tài nguyên của ứng dụng.
│   │       ├── application.properties    // **File cấu hình quan trọng nhất**: database, PayOS, Google keys...
│   │       ├── static                    // Chứa các tài nguyên tĩnh không thay đổi.
│   │       │   ├── css/                  // Các file CSS định dạng giao diện.
│   │       │   ├── js/                   // Các file JavaScript xử lý phía client.
│   │       │   └── img/                  // Hình ảnh sử dụng trong giao diện.
│   │       └── templates                 // Chứa các file template (view) được xử lý bởi Thymeleaf.
│   │           ├── layout/layout.html    // Bố cục (template) chung cho các trang người dùng.
│   │           ├── fragments/header.html // Phần đầu trang (header) được tái sử dụng.
│   │           ├── fragments/footer.html // Phần chân trang (footer) được tái sử dụng.
│   │           ├── admin/admin.html      // Bố cục chung cho trang quản trị.
│   │           ├── error/403.html        // Trang hiển thị khi bị từ chối truy cập.
│   │           ├── Home.html, Product.html, Login.html, ... // Các file template cho từng trang cụ thể.
└── target/                           // Thư mục chứa kết quả sau khi build dự án (file .class, .jar).
```

### Giải thích các file và thư mục quan trọng

| Đường dẫn                               | Chức năng                                                                                                                            |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `pom.xml`                               | **File cấu hình Maven quan trọng nhất.** Chứa tất cả các dependency của dự án (Spring Boot, Spring Security, JPA, PayOS, OAuth2...). |
| `db.sql`                                | **File SQL chính.** Chứa script để tạo cấu trúc database (bảng, quan hệ) và có thể chứa dữ liệu mẫu (seed data).                  |
| `src/main/resources/application.properties` | **File cấu hình trung tâm.** Chứa tất cả các cấu hình cho ứng dụng, bao gồm kết nối database, Google OAuth2, và PayOS API keys. |
| `src/main/java/.../ProjectendApplication.java` | **File chạy chính của ứng dụng Spring Boot.** Chứa hàm `main` để khởi động toàn bộ backend.                                     |
| `src/main/java/.../config/SecurityConfig.java` | **Cấu hình bảo mật.** Định nghĩa các quy tắc xác thực và phân quyền, cấu hình form login, Google OAuth2, và các bộ lọc bảo mật. |
| `src/main/java/.../controller/`         | **Tầng Controller.** Chứa các class xử lý request HTTP từ client, gọi các service tương ứng và trả về view hoặc dữ liệu JSON.      |
| `src/main/java/.../service/`            | **Tầng Service.** Chứa logic nghiệp vụ chính của ứng dụng (ví dụ: `GioHangService`, `DonHangService`, `PayOSService`).             |
| `src/main/java/.../service/auth/`       | **Module xác thực.** Chứa các class quan trọng cho việc đăng nhập, đặc biệt là `CustomOAuth2UserService` để xử lý login Google.   |
| `src/main/java/.../repository/`         | **Tầng Repository (DAO).** Giao tiếp với database thông qua Spring Data JPA. Mỗi repository tương ứng với một `Entity`.             |
| `src/main/java/.../entity/`             | **Tầng Entity.** Các class Java được ánh xạ tới các bảng trong database.                                                            |
| `src/main/resources/templates/`         | **Thư mục View.** Chứa các file HTML (Thymeleaf) định nghĩa giao diện người dùng.                                                    |
| `src/main/resources/static/`            | **Tài nguyên tĩnh.** Chứa các file CSS, JavaScript, và hình ảnh.                                                                    |

---

## 3. Cài đặt và chạy dự án

Thực hiện theo các bước dưới đây để cài đặt và chạy dự án trên máy của bạn.

### 3.1. Yêu cầu môi trường

- **Java**: `JDK 17` hoặc cao hơn.
- **Maven**: `3.8.x` hoặc cao hơn.
- **Database**: `Microsoft SQL Server`.
- **IDE**: `IntelliJ IDEA` hoặc một IDE hỗ trợ Maven/Spring Boot khác.

### 3.2. Cài đặt Database

1.  **Mở SQL Server Management Studio (SSMS)** hoặc một công cụ quản lý SQL Server khác.
2.  **Tạo một database mới** với tên `LuxuryFashion_2025`.
3.  **Mở file `db.sql`** trong thư mục gốc của dự án.
4.  **Thực thi toàn bộ script** trong file `db.sql` trên database `LuxuryFashion_2025` vừa tạo. Script này sẽ tạo tất cả các bảng cần thiết cho dự án.

### 3.3. Cấu hình ứng dụng

1.  **Mở file `src/main/resources/application.properties`**.
2.  **Cấu hình kết nối Database**:
    -   Chỉnh sửa các thông số sau để khớp với cấu hình SQL Server của bạn:
        ```properties
        spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=LuxuryFashion_2025;...
        spring.datasource.username=sa
        spring.datasource.password=your_strong_password
        ```
3.  **Cấu hình Google OAuth2 (Tùy chọn nhưng khuyến khích)**:
    -   Truy cập [Google Cloud Console](https://console.cloud.google.com/apis/credentials).
    -   Tạo một "OAuth 2.0 Client ID" mới.
    -   Trong file `application.properties`, tìm đến phần `GOOGLE OAUTH2 CONFIGURATION` và điền `client-id` và `client-secret` của bạn.
        ```properties
        spring.security.oauth2.client.registration.google.client-id=YOUR_GOOGLE_CLIENT_ID
        spring.security.oauth2.client.registration.google.client-secret=YOUR_GOOGLE_CLIENT_SECRET
        ```
4.  **Cấu hình PayOS (Quan trọng cho chức năng thanh toán)**:
    -   Đăng ký tài khoản tại [PayOS](https://payos.vn/).
    -   Lấy các thông tin `Client ID`, `Api Key`, và `Checksum Key` từ dashboard của PayOS.
    -   Điền các thông tin này vào file `application.properties`:
        ```properties
        payos.client-id=YOUR_PAYOS_CLIENT_ID
        payos.api-key=YOUR_PAYOS_API_KEY
        payos.checksum-key=YOUR_PAYOS_CHECKSUM_KEY
        ```

### 3.4. Build và Chạy dự án

1.  **Mở Terminal** hoặc Command Prompt tại thư mục gốc của dự án.
2.  **Build dự án** bằng Maven:
    ```shell
    mvn clean install
    ```
3.  **Chạy ứng dụng**:
    -   **Cách 1: Dùng Maven**
        ```shell
        mvn spring-boot:run
        ```
    -   **Cách 2: Chạy từ IDE**
        - Mở file `ProjectendApplication.java`.
        - Click vào nút "Run" màu xanh bên cạnh hàm `main`.

4.  **Truy cập ứng dụng**: Mở trình duyệt và truy cập `http://localhost:8080`.

---

## 4. Mô tả chi tiết các module

### 4.1. Module Xác thực (Authentication)

Module này xử lý việc đăng nhập, đăng ký, và phân quyền người dùng.

#### 4.1.1. Đăng nhập truyền thống (Form Login)

- **Luồng hoạt động**:
    1.  Người dùng nhập email và mật khẩu tại trang `/login`.
    2.  `SecurityConfig.java` cấu hình để bắt request POST tới `/login`.
    3.  `UserDetailsServiceImpl` được gọi để tìm `TaiKhoan` trong database dựa trên email.
    4.  Spring Security so sánh mật khẩu người dùng nhập với mật khẩu đã mã hóa trong database.
    5.  Nếu thành công, người dùng được chuyển hướng đến trang chính.

- **File liên quan**:
    -   `SecurityConfig.java`: Cấu hình form login, trang login, và các URL công khai/yêu cầu xác thực.
    -   `UserDetailsServiceImpl.java`: Tải thông tin người dùng từ database.
    -   `TaiKhoanRepository.java`: Truy vấn thông tin tài khoản.

#### 4.1.2. Đăng nhập với Google (OAuth2) - **CHI TIẾT**

Đây là một trong những tính năng cốt lõi, cho phép người dùng đăng nhập nhanh chóng bằng tài khoản Google.

- **Luồng hoạt động (Step-by-step)**:
    1.  **Request Login (Frontend)**: Người dùng click vào nút "Login with Google" trên trang `/login`. Nút này thực chất là một link `<a>` trỏ đến `/oauth2/authorization/google`.
    2.  **Redirect đến Google (Backend)**: Spring Security OAuth2 client tự động chặn request này, tạo một URL xác thực của Google (với `client_id`, `redirect_uri`, `scope`) và chuyển hướng người dùng đến trang đăng nhập của Google.
    3.  **Xác thực tại Google**: Người dùng đăng nhập và đồng ý cấp quyền cho ứng dụng.
    4.  **Callback về ứng dụng**: Google chuyển hướng người dùng trở lại ứng dụng tại `redirect-uri` đã đăng ký (ví dụ: `http://localhost:8080/login/oauth2/code/google`) kèm theo một `authorization code`.
    5.  **Lấy Access Token**: Spring Security tự động dùng `authorization code` này để gọi đến Google Token Endpoint, nhận về `access token`.
    6.  **Lấy thông tin người dùng**: Spring Security dùng `access token` để gọi đến Google User Info Endpoint, nhận về thông tin người dùng (email, tên, avatar).
    7.  **Xử lý logic tùy chỉnh (`CustomOAuth2UserService`)**:
        -   Đây là **file quan trọng nhất** trong luồng OAuth2 của dự án.
        -   Service này được kích hoạt sau khi lấy được thông tin từ Google.
        -   Nó kiểm tra xem email từ Google đã tồn tại trong bảng `TaiKhoan` hay chưa.
            -   **Nếu đã tồn tại**: Cập nhật thông tin (nếu cần) và tải vai trò (roles) của người dùng từ database.
            -   **Nếu chưa tồn tại**: Tạo một tài khoản mới trong bảng `TaiKhoan` với `provider` là 'GOOGLE', `matKhau` là `null`, và gán vai trò mặc định là `USER`.
    8.  **Tạo phiên đăng nhập**: Spring Security tạo một phiên đăng nhập cho người dùng với thông tin và vai trò đã được xử lý. Người dùng được chuyển hướng đến trang chủ.

- **File cấu hình và code chính**:
    -   `application.properties`: Chứa `client-id` và `client-secret` của Google. **Bảo mật các thông tin này cẩn thận.**
    -   `SecurityConfig.java`: Kích hoạt và cấu hình OAuth2 login.
        ```java
        // ...
        .oauth2Login(oauth2 -> oauth2
            .loginPage("/login")
            .userInfoEndpoint(userInfo -> userInfo
                .userService(customOAuth2UserService) // <-- Gọi service tùy chỉnh
            )
            .successHandler((request, response, authentication) -> {
                // ... xử lý sau khi login thành công
            })
        )
        // ...
        ```
    -   `service/auth/CustomOAuth2UserService.java`: **Logic cốt lõi.** Xử lý việc tìm kiếm hoặc tạo mới người dùng trong database sau khi Google xác thực thành công.
    -   `entity/TaiKhoan.java`: Cần có trường `provider` để phân biệt tài khoản thường và tài khoản Google. Mật khẩu (`matKhau`) có thể là `null` cho tài khoản Google.

- **Sơ đồ luồng dữ liệu Google OAuth2 (Text Diagram)**:
    ```
    Người dùng                     Trang Web (Backend)                 Google
        |                              |                                |
        | 1. Click "Login Google"      |                                |
        |----------------------------->|                                |
        |                              | 2. Redirect đến trang login    |
        |                              |------------------------------->|
        |                              |                                | 3. User đăng nhập & đồng ý
        |                              |                                |
        |                              | 4. Redirect về Callback URL    |
        |<--------------------------------------------------------------|
        |                              | (với authorization_code)       |
        |                              |                                |
        |                              | 5. Gửi code để lấy access_token|
        |                              |------------------------------->|
        |                              |                                | 6. Trả về access_token
        |                              |<-------------------------------|
        |                              |                                |
        |                              | 7. Dùng token lấy user_info    |
        |                              |------------------------------->|
        |                              |                                | 8. Trả về user_info (email, name)
        |                              |<-------------------------------|
        |                              |                                |
        |                              | 9. Xử lý trong CustomOAuth2UserService:
        |                              |    - Tìm email trong DB
        |                              |    - Nếu chưa có -> Tạo user mới
        |                              |    - Nếu có -> Cập nhật
        |                              |                                |
        | 10. Tạo session & đăng nhập  |                                |
        |<-----------------------------|                                |
    ```

### 4.2. Module Thanh toán (PayOS) - **CHI TIẾT**

Module này tích hợp cổng thanh toán PayOS để xử lý các giao dịch mua hàng.

- **Luồng hoạt động (Step-by-step)**:
    1.  **Tạo đơn hàng (Checkout)**:
        -   Người dùng điền thông tin giao hàng và chọn "Thanh toán qua PayOS" tại trang `/checkout`.
        -   Khi submit, `CheckoutController` xử lý request, tạo một đối tượng `DonHang` và các `DonHangChiTiet` tương ứng trong database với trạng thái "Chờ thanh toán".
    2.  **Tạo Link thanh toán (Backend)**:
        -   `PayOSController` hoặc một service liên quan sẽ được gọi.
        -   `PayOSService.java` chịu trách nhiệm chuẩn bị dữ liệu cho PayOS, bao gồm:
            -   `orderCode`: Một mã đơn hàng duy nhất (ví dụ: ID của `DonHang` vừa tạo).
            -   `amount`: Tổng số tiền cần thanh toán.
            -   `description`: Mô tả đơn hàng.
            -   `returnUrl`, `cancelUrl`: Các URL để PayOS chuyển hướng người dùng về sau khi thanh toán thành công hoặc hủy.
        -   Service này gọi đến `PayOS API` để tạo một link thanh toán (`payment link`).
    3.  **Redirect đến PayOS (Frontend/Backend)**:
        -   Backend trả về `payment link` cho frontend.
        -   Frontend sử dụng JavaScript để chuyển hướng người dùng đến trang thanh toán của PayOS.
    4.  **Xử lý thanh toán tại PayOS**: Người dùng thực hiện thanh toán (quét mã QR, nhập thông tin thẻ, v.v.) trên giao diện của PayOS.
    5.  **Callback/Return URL (Quan trọng)**:
        -   **Thành công**: PayOS chuyển hướng người dùng về `returnUrl` (ví dụ: `/payment/payos/return`) kèm theo các tham số trên URL để xác nhận giao dịch.
        -   `PayOSController` bắt request tại `returnUrl`, kiểm tra tính hợp lệ của chữ ký (checksum) do PayOS gửi về để đảm bảo dữ liệu không bị giả mạo.
        -   Nếu hợp lệ, controller cập nhật trạng thái của `DonHang` trong database thành "Đã thanh toán" hoặc "Đang xử lý".
        -   Người dùng được hiển thị trang "Thanh toán thành công".
    6.  **Webhook (Tùy chọn nhưng khuyến khích)**:
        -   PayOS có thể gửi một request server-to-server đến `webhookUrl` của bạn để thông báo trạng thái giao dịch một cách đáng tin cậy hơn, phòng trường hợp người dùng không được chuyển hướng về `returnUrl` (ví dụ: do mất kết nối).
        -   Dự án cần có một endpoint để lắng nghe webhook này và cập nhật trạng thái đơn hàng.

- **File cấu hình và code chính**:
    -   `application.properties`: Chứa `client-id`, `api-key`, và `checksum-key` của PayOS. **Đây là các thông tin cực kỳ nhạy cảm.**
    -   `config/PayOSConfig.java`: Có thể chứa các bean cấu hình cho PayOS SDK (nếu sử dụng).
    -   `service/PayOSService.java`: **Logic cốt lõi.** Chứa các phương thức để tạo link thanh toán, và quan trọng nhất là **xác thực chữ ký (signature/checksum)** từ callback của PayOS.
    -   `controller/PayOSController.java`: Chứa các endpoint cho `returnUrl`, `cancelUrl`, và `webhookUrl`.
    -   `controller/CheckoutController.java`: Bắt đầu luồng thanh toán bằng cách tạo đơn hàng và gọi `PayOSService`.

- **Sơ đồ luồng dữ liệu PayOS (Text Diagram)**:
    ```
    Người dùng (Browser)           Trang Web (Backend)                 PayOS
        |                              |                                |
        | 1. Click "Thanh toán"        |                                |
        |----------------------------->|                                |
        |                              | 2. Tạo `DonHang` (status: PENDING)
        |                              |    Gọi `PayOSService` để tạo link
        |                              |------------------------------->|
        |                              |                                | 3. Trả về `checkoutUrl`
        |                              |<-------------------------------|
        |                              |                                |
        | 4. Redirect đến `checkoutUrl`|                                |
        |-------------------------------------------------------------->|
        |                              |                                | 5. User thực hiện thanh toán
        |                              |                                |    (QR, thẻ, ...)
        |                              |                                |
        | 6. Redirect về `returnUrl`   |                                |
        |<--------------------------------------------------------------|
        | (kèm data & signature)       |                                |
        |                              | 7. `PayOSController` xử lý:    |
        |                              |    - Xác thực `signature`      |
        |                              |    - Cập nhật `DonHang` (status: PAID)
        |                              |                                |
        | 8. Hiển thị trang thành công |                                |
        |<-----------------------------|                                |
        |                              |                                |
        |                              | (Song song) 9. Gửi Webhook     |
        |                              |<-------------------------------|
        |                              | 10. Endpoint Webhook xác thực  |
        |                              |     và cập nhật `DonHang`      |
        |                              |     (đảm bảo giao dịch)        |
    ```

---

## 5. Phân tích sâu về Cấu hình và Dữ liệu

Phần này đi sâu vào "bên trong" của ứng dụng, giải thích các file cấu hình cốt lõi và cấu trúc dữ liệu. Hiểu rõ phần này sẽ giúp bạn biết được "luật chơi" của hệ thống.

### 5.1. File cấu hình `application.properties`

Đây là trái tim của ứng dụng Spring Boot, nơi định nghĩa tất cả các tham số hoạt động.

```properties
# ===== SERVER CONFIGURATION =====
# Cổng mà ứng dụng web sẽ chạy. Truy cập bằng http://localhost:8080
server.port=8080

# ===== SQL SERVER DATABASE CONFIGURATION =====
# Chuỗi kết nối đến SQL Server. Bạn cần thay đổi nếu database của bạn ở địa chỉ khác hoặc tên khác.
spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=LuxuryFashion_2025;encrypt=false;trustServerCertificate=true
# Tài khoản và mật khẩu để truy cập database. **BẮT BUỘC THAY ĐỔI** cho phù hợp với môi trường của bạn.
spring.datasource.username=sa
spring.datasource.password=Aa@123456

# ===== JPA/HIBERNATE CONFIGURATION =====
# Rất quan trọng: `ddl-auto=none` nghĩa là Hibernate sẽ KHÔNG tự động tạo/sửa bảng.
# Toàn bộ cấu trúc database phải được tạo từ file `db.sql`. Điều này đảm bảo tính nhất quán.
spring.jpa.hibernate.ddl-auto=none
# Hiển thị các câu lệnh SQL trong console, rất hữu ích cho việc debug.
spring.jpa.show-sql=true
# Quan trọng: Các thiết lập `naming.physical-strategy` và `implicit-strategy` này giữ cho tên bảng và cột trong database
# khớp với tên class và thuộc tính trong Java Entity (ví dụ: class `SanPhamChiTiet` -> bảng `SanPhamChiTiet`).
# Nếu không có, Hibernate có thể tự đổi thành `san_pham_chi_tiet`.
spring.jpa.hibernate.naming.physical-strategy=org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
spring.jpa.hibernate.naming.implicit-strategy=org.hibernate.boot.model.naming.ImplicitNamingStrategyLegacyJpaImpl

# ===== PAYOS PAYMENT GATEWAY CONFIGURATION =====
# Các khóa bí mật để kết nối đến API của PayOS.
# Bạn phải lấy các khóa này từ dashboard của PayOS và điền vào đây.
payos.client-id=...
payos.api-key=...
payos.checksum-key=...
# URL mà PayOS sẽ gọi về sau khi người dùng thanh toán xong.
payos.return-url=http://localhost:8080/payment/payos/return

# ===== GOOGLE OAUTH2 CONFIGURATION =====
# Các khóa bí mật để kết nối đến Google API cho chức năng đăng nhập.
# Bạn phải lấy các khóa này từ Google Cloud Console và điền vào đây.
spring.security.oauth2.client.registration.google.client-id=...
spring.security.oauth2.client.registration.google.client-secret=...
```

### 5.2. File cấu hình `SecurityConfig.java`

File này định nghĩa toàn bộ "luật" về bảo mật: ai được phép truy cập vào đâu và bằng cách nào.

-   **Mã hóa mật khẩu**:
    ```java
    @Bean
    public PasswordEncoder passwordEncoder() {
        // ⚠️ Chỉ dùng NoOp cho demo — thực tế nên dùng BCryptPasswordEncoder
        return NoOpPasswordEncoder.getInstance();
    }
    ```
    -   Hiện tại, dự án đang không mã hóa mật khẩu (`NoOpPasswordEncoder`) để dễ dàng cho việc demo và debug.
    -   **Trong môi trường thực tế, bắt buộc phải thay thế bằng `BCryptPasswordEncoder`** để mã hóa mật khẩu người dùng một cách an toàn.

-   **Phân quyền truy cập (`authorizeHttpRequests`)**:
    -   `.requestMatchers("/", "/home", "/sanpham/**", "/css/**", ...).permitAll()`: Các đường dẫn này được công khai. Bất kỳ ai, dù đã đăng nhập hay chưa, đều có thể truy cập.
    -   `.requestMatchers("/checkout", "/profile/**").authenticated()`: Các đường dẫn này yêu cầu người dùng **phải đăng nhập**. Không quan trọng vai trò là gì, miễn là đã xác thực.
    -   `.requestMatchers("/staff/**").hasRole("NHANVIEN")`: Yêu cầu người dùng phải có vai trò `ROLE_NHANVIEN`.
    -   `.requestMatchers("/admin/dashboard", ...).hasRole("ADMIN")`: Yêu cầu người dùng phải có vai trò `ROLE_ADMIN`.
    -   `.requestMatchers("/admin/orders/**", ...).hasAnyRole("ADMIN", "NHANVIEN")`: Cho phép cả `ADMIN` và `NHANVIEN` truy cập.
    -   `.exceptionHandling(ex -> ex.accessDeniedPage("/403"))`: Nếu người dùng cố gắng truy cập vào một trang mà họ không có quyền, họ sẽ bị chuyển hướng đến trang `/403`.

-   **Xử lý đăng nhập (`formLogin` và `oauth2Login`)**:
    -   `.loginPage("/login")`: Định nghĩa trang đăng nhập tùy chỉnh của chúng ta là `/login`.
    -   `.successHandler(...)`: Đây là logic quan trọng sau khi đăng nhập thành công.
        -   **Đối với Form Login**: Hệ thống kiểm tra vai trò của người dùng. Nếu là `ADMIN`, chuyển hướng đến `/admin/dashboard`. Nếu là `NHANVIEN`, chuyển hướng đến `/staff/dashboard`. Nếu không, chuyển hướng về trang chủ.
        -   **Đối với Google Login**: Người dùng luôn được coi là khách hàng và được chuyển hướng thẳng về trang chủ.
    -   `.failureUrl("/login?error=true")`: Nếu đăng nhập thất bại (sai mật khẩu), người dùng sẽ bị chuyển hướng lại trang login với một tham số lỗi.

### 5.3. Sơ đồ Database chi tiết

Dưới đây là mô tả chi tiết hơn về các bảng quan trọng và mối quan hệ giữa chúng.

-   **Bảng `TaiKhoan`**: Lưu trữ thông tin người dùng.
    -   `Id` (PK): Khóa chính.
    -   `Email` (UNIQUE): Email dùng để đăng nhập, là duy nhất.
    -   `MatKhau`: Mật khẩu (hiện tại là plain text). Sẽ là `NULL` nếu đăng nhập bằng Google.
    -   `HoTen`: Họ và tên người dùng.
    -   `Provider`: Cho biết tài khoản được tạo từ đâu. Mặc định là `LOCAL`, nếu từ Google sẽ là `GOOGLE`.
    -   `IdVaiTro` (FK): Khóa ngoại, liên kết đến bảng `VaiTro` để xác định quyền hạn (Admin, Nhân viên, Khách hàng).

-   **Bảng `DonHang`**: Lưu trữ thông tin mỗi đơn hàng.
    -   `Id` (PK): Khóa chính.
    -   `IdTaiKhoan` (FK): Liên kết đến người dùng đã đặt hàng.
    -   `TongTien`: Tổng giá trị của đơn hàng.
    -   `IdTrangThai` (FK): Liên kết đến bảng `TrangThaiDonHang` (ví dụ: Chờ thanh toán, Đang giao, Hoàn thành, Đã hủy).
    -   `IdPhuongThucThanhToan` (FK): Liên kết đến bảng `PhuongThucThanhToan` (ví dụ: COD, PayOS).

-   **Bảng `DonHangChiTiet`**: Lưu trữ các sản phẩm trong một đơn hàng.
    -   `Id` (PK): Khóa chính.
    -   `IdDonHang` (FK): Liên kết đến đơn hàng chứa sản phẩm này.
    -   `IdSPCT` (FK): **Liên kết quan trọng** đến bảng `SanPhamChiTiet` để biết chính xác sản phẩm nào (màu sắc, size) đã được mua.
    -   `SoLuong`: Số lượng sản phẩm đã mua.
    -   `Gia`: Giá của sản phẩm tại thời điểm mua.

-   **Bảng `SanPhamChiTiet` (SPCT)**: Bảng quan trọng nhất về sản phẩm, định nghĩa một biến thể cụ thể.
    -   `Id` (PK): Khóa chính.
    -   `IdSanPham` (FK): Liên kết đến sản phẩm gốc (ví dụ: Áo dài Tết 2025).
    -   `IdMauSac` (FK): Liên kết đến màu sắc của sản phẩm (ví dụ: Đỏ).
    -   `IdSize` (FK): Liên kết đến kích thước của sản phẩm (ví dụ: L).
    -   `SoLuong`: Số lượng tồn kho của biến thể này.
    -   `Gia`: Giá bán của biến thể này.

**Mối quan hệ chính (Visualized):**
```
[TaiKhoan] 1--* [DonHang] 1--* [DonHangChiTiet]
   |                                                        |
   |                                                        +--1 [SanPham]
   +--1 [VaiTro]                                            +--1 [MauSacSP]
                                                            +--1 [SizeSP]
```

---

## 6. Chi tiết Code và Dữ liệu

### 6.1. Sơ đồ Database (SQL Schema)

Dựa trên các file `Entity`, các bảng chính trong database bao gồm:

-   `TaiKhoan`: Lưu trữ thông tin người dùng, vai trò, và provider (cho OAuth2).
-   `SanPham`, `SanPhamChiTiet`, `LoaiSanPham`, `MauSacSP`, `SizeSP`: Quản lý thông tin sản phẩm.
-   `GioHang`, `GioHangChiTiet`: Quản lý giỏ hàng của người dùng.
-   `DonHang`, `DonHangChiTiet`: Quản lý đơn hàng đã đặt.
-   `PhuongThucThanhToan`, `TrangThaiDonHang`: Các bảng danh mục.
-   ... và các bảng khác.

Các mối quan hệ chính:
-   `TaiKhoan` (1) - (n) `DonHang`
-   `DonHang` (1) - (n) `DonHangChiTiet`
-   `SanPhamChiTiet` (1) - (1) `DonHangChiTiet`

### 6.2. Dữ liệu mẫu (Seed Data)

File `db.sql` có thể chứa các câu lệnh `INSERT` để thêm dữ liệu ban đầu vào các bảng như `VaiTro` (ví dụ: 'ADMIN', 'USER'), `LoaiSanPham`, hoặc tạo một tài khoản admin mặc định.

---

## 7. API Documentation (Sơ lược)

Dự án chủ yếu theo kiến trúc MVC server-side rendering, nhưng có thể có một số endpoint API cho các tác vụ bất đồng bộ.

| Endpoint              | Method | Chức năng                                     | Controller liên quan   |
| --------------------- | ------ | --------------------------------------------- | ---------------------- |
| `/api/cart/add`       | `POST` | Thêm sản phẩm vào giỏ hàng (AJAX)             | `ApiController` hoặc `GioHangController` |
| `/api/cart/update`    | `POST` | Cập nhật số lượng sản phẩm trong giỏ          | `ApiController` hoặc `GioHangController` |
| `/payment/payos/return` | `GET`  | Xử lý callback sau khi thanh toán PayOS thành công | `PayOSController`      |
| `/payment/payos/webhook`| `POST` | Lắng nghe webhook từ PayOS                  | `PayOSController`      |

---

## 8. Ví dụ minh họa chạy thử

### 8.1. Test đăng nhập Google

1.  **Cấu hình**: Đảm bảo bạn đã điền đúng `client-id` và `client-secret` trong `application.properties`.
2.  **Chạy ứng dụng** và truy cập `http://localhost:8080/login`.
3.  **Click vào nút "Đăng nhập với Google"**.
4.  Bạn sẽ được chuyển hướng đến trang đăng nhập của Google.
5.  Chọn tài khoản và đăng nhập.
6.  Sau khi thành công, bạn sẽ được chuyển hướng về trang chủ của website và trạng thái đã đăng nhập.
7.  **Kiểm tra Database**: Mở bảng `TaiKhoan` và bạn sẽ thấy một record mới với email của bạn và cột `provider` có giá trị là `GOOGLE`.

### 8.2. Test thanh toán PayOS

1.  **Cấu hình**: Đảm bảo bạn đã điền đúng `client-id`, `api-key`, `checksum-key` trong `application.properties`.
2.  **Đăng nhập** vào trang web.
3.  **Thêm một sản phẩm** bất kỳ vào giỏ hàng.
4.  **Tiến hành thanh toán** (`/checkout`).
5.  Điền thông tin và chọn phương thức "Thanh toán qua PayOS".
6.  Bạn sẽ được chuyển hướng đến trang thanh toán của PayOS.
7.  **Sử dụng thông tin thẻ test** do PayOS cung cấp để hoàn tất thanh toán.
8.  Sau khi thành công, bạn sẽ được chuyển hướng về trang "Thanh toán thành công" của website.
9.  **Kiểm tra Database**: Mở bảng `DonHang` và bạn sẽ thấy trạng thái của đơn hàng vừa tạo đã được cập nhật (ví dụ: từ "Chờ thanh toán" thành "Đã thanh toán").

---

## 9. Tips cho Developer mới

-   **Logging**: Dự án đã cấu hình logging trong `application.properties`. Khi debug, hãy chú ý đến các log của `com.example.projectend` và `org.springframework.security`.
-   **DevTools**: Spring Boot DevTools được tích hợp, giúp tự động restart ứng dụng khi có thay đổi về code, tiết kiệm thời gian phát triển.
-   **Lỗi phổ biến**:
    -   **Lỗi kết nối database**: Kiểm tra lại chuỗi kết nối, username, password trong `application.properties` và đảm bảo SQL Server đang chạy.
    -   **Lỗi 403 Forbidden**: Thường do chưa đăng nhập hoặc không có quyền truy cập vào tài nguyên. Kiểm tra `SecurityConfig.java` để xem các quy tắc phân quyền.
    -   **Lỗi OAuth2 `redirect_uri_mismatch`**: Đảm bảo `redirect-uri` trong Google Cloud Console khớp với URI mà ứng dụng của bạn đang chạy.
    -   **Lỗi checksum PayOS**: Kiểm tra lại `checksum-key` và đảm bảo logic tạo và xác thực chữ ký là chính xác.

---

## 10. Dependencies và Build

Dự án được quản lý bởi Maven. File `pom.xml` định nghĩa tất cả các thư viện cần thiết.

### 10.1. Các dependency chính

-   `spring-boot-starter-web`: Xây dựng ứng dụng web, bao gồm RESTful, Spring MVC.
-   `spring-boot-starter-data-jpa`: Tương tác với database thông qua Java Persistence API.
-   `spring-boot-starter-security`: Xác thực và phân quyền.
-   `spring-boot-starter-oauth2-client`: Hỗ trợ đăng nhập qua OAuth2 (Google, Facebook...).
-   `spring-boot-starter-thymeleaf`: Template engine để xây dựng view.
-   `mssql-jdbc`: Driver kết nối đến Microsoft SQL Server.
-   `okhttp`, `gson`, `commons-codec`: Các thư viện phụ trợ cho việc tích hợp API của PayOS.
-   `com.google.zxing`: Thư viện tạo mã QR.

### 10.2. Build và Deploy

-   **Build**: Để tạo file JAR có thể chạy được, sử dụng lệnh:
    ```shell
    mvn clean package
    ```
    File JAR sẽ được tạo trong thư mục `target/`.
-   **Deploy**: Để chạy ứng dụng trên server, bạn chỉ cần thực thi file JAR đã build:
    ```shell
    java -jar target/projectend-0.0.1-SNAPSHOT.jar
    ```
    Lưu ý: Đảm bảo môi trường server đã cài đặt Java 17 và có thể kết nối đến SQL Server.

---

## 11. Luồng dữ liệu chi tiết: Ví dụ chức năng "Thêm vào giỏ hàng"

Để hiểu rõ cách các thành phần trong Spring Boot tương tác với nhau, chúng ta sẽ phân tích một luồng nghiệp vụ hoàn chỉnh: từ lúc người dùng nhấn nút "Thêm vào giỏ hàng" cho đến khi dữ liệu được lưu vào database.

**Bối cảnh**: Người dùng đang xem một trang chi tiết sản phẩm và nhấn nút "Thêm vào giỏ hàng".

**Sơ đồ luồng dữ liệu (Text Diagram):**
```
Người dùng (Browser)      |  Frontend (Thymeleaf/JS)  |  Backend (Spring Boot)                                       | Database (SQL Server)
--------------------------|---------------------------|--------------------------------------------------------------|----------------------
1. Click "Thêm vào giỏ"   |                           |                                                              |
                          | 2. Gửi AJAX request       |                                                              |
                          |    (POST /api/cart/add)   |                                                              |
                          |    với productId & quantity|                                                              |
                          |-------------------------->| 3. @RestController ApiController nhận request                |
                          |                           |    - @PostMapping("/cart/add")                               |
                          |                           |    - Dữ liệu được map vào các @RequestParam                  |
                          |                           |                                                              |
                          |                           | 4. Gọi `gioHangService.addToCart(...)`                        |
                          |                           |    - @Autowired GioHangService                               |
                          |                           |------------------------------------------------------------->|
                          |                           |    5. `GioHangService` xử lý logic:                          |
                          |                           |       - Lấy thông tin user đang đăng nhập.                   |
                          |                           |       - Tìm giỏ hàng của user (`gioHangRepo.findBy...`).     |
                          |                           |       - Nếu sản phẩm đã có -> tăng số lượng.                 |
                          |                           |       - Nếu chưa có -> tạo `GioHangChiTiet` mới.              |
                          |                           |                                                              |
                          |                           |    6. Lưu thay đổi vào DB (`gioHangChiTietRepo.save(...)`)   |
                          |                           |------------------------------------------------------------->| 7. INSERT/UPDATE vào
                          |                           |                                                              |    bảng `GioHangChiTiet`
                          |                           |    8. Trả về kết quả (thành công/thất bại)                   |
                          |                           |<-------------------------------------------------------------|
                          |                           |                                                              |
                          | 9. Trả về JSON Response   |                                                              |
                          |<--------------------------|                                                              |
                          |                           |                                                              |
10. JS nhận response      |                           |                                                              |
    - Cập nhật icon giỏ hàng|                           |                                                              |
    - Hiển thị thông báo    |                           |                                                              |
```

**Giải thích chi tiết từng bước:**

1.  **Frontend (JavaScript)**: Khi người dùng nhấn nút, một đoạn mã JavaScript trong file `ProductDetail.js` (hoặc tương tự) sẽ được kích hoạt. Nó lấy `id` của sản phẩm chi tiết và số lượng, sau đó sử dụng `fetch` hoặc `axios` để gửi một yêu cầu `POST` đến endpoint `/api/cart/add` của backend.

2.  **Controller (`ApiController.java`)**:
    -   Spring Boot sẽ tìm đến `Controller` có thể xử lý yêu cầu này. Annotation `@RestController` cho biết class này chuyên xử lý các request API và trả về dữ liệu (thường là JSON) thay vì một trang HTML.
    -   Phương thức được đánh dấu `@PostMapping("/cart/add")` sẽ được thực thi.
    -   Các annotation `@RequestParam` sẽ tự động lấy dữ liệu từ request (ví dụ: `productId`, `quantity`) và gán vào các biến trong phương thức.

3.  **Service (`GioHangService.java`)**:
    -   Controller không xử lý logic nghiệp vụ trực tiếp. Thay vào đó, nó gọi đến một `Service`. Annotation `@Autowired` được dùng để "tiêm" (inject) một instance của `GioHangService` vào `ApiController`.
    -   Phương thức `addToCart` trong `GioHangService` chứa toàn bộ logic chính:
        -   Lấy thông tin người dùng hiện tại từ `SecurityContextHolder`.
        -   Sử dụng `GioHangRepository` để tìm giỏ hàng tương ứng với người dùng.
        -   Kiểm tra xem sản phẩm đã tồn tại trong `GioHangChiTiet` hay chưa.
        -   Nếu có, cập nhật số lượng. Nếu chưa, tạo một đối tượng `GioHangChiTiet` mới.
    -   Annotation `@Service` đánh dấu đây là một lớp chứa logic nghiệp vụ. `@Transactional` (có thể có) sẽ đảm bảo tất cả các thao tác với database trong phương thức này hoặc thành công toàn bộ, hoặc thất bại toàn bộ.

4.  **Repository (`GioHangChiTietRepository.java`)**:
    -   Service sẽ gọi phương thức `save()` của `Repository`.
    -   `Repository` là một interface kế thừa từ `JpaRepository`. Spring Data JPA sẽ tự động cung cấp các phương thức cơ bản như `save()`, `findById()`, `findAll()`... mà không cần chúng ta viết code SQL.

5.  **Database**: Hibernate (do Spring Data JPA sử dụng) sẽ dịch lệnh `save()` thành một câu lệnh SQL `INSERT` hoặc `UPDATE` tương ứng và thực thi nó trên database, lưu dữ liệu vào bảng `GioHangChiTiet`.

6.  **Response**: Sau khi lưu thành công, luồng sẽ quay trở lại: Repository -> Service -> Controller. Controller sẽ trả về một `ResponseEntity` (thường là JSON) cho trình duyệt, ví dụ: `{"success": true, "message": "Thêm thành công!"}`.

7.  **Cập nhật giao diện**: JavaScript ở frontend nhận được response này và thực hiện các hành động cần thiết như cập nhật số lượng sản phẩm trên icon giỏ hàng, hiển thị một thông báo popup cho người dùng.
