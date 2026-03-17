# Hướng dẫn sử dụng Run.sh

## Chạy dự án

Để khởi động cả **Backend** (Spring Boot) và **Frontend** (Vue.js) cùng lúc:

```bash
./run.sh
```

## Tính năng

Script `run.sh` sẽ tự động:

1. ✅ **Kiểm tra dependencies:** Java, Maven, Node.js, npm
2. ✅ **Cài đặt frontend dependencies** (nếu chưa có `node_modules`)
3. ✅ **Chạy Backend** (Spring Boot) trên port `8080`
4. ✅ **Chạy Frontend** (Vite) trên port `5173`
5. ✅ **Hiển thị logs** của cả hai services
6. ✅ **Cleanup tự động** khi nhấn `Ctrl+C`

## URLs

Sau khi khởi động thành công:

- **Frontend:** <http://localhost:5173>
- **Backend:** <http://localhost:8080>
- **API:** <http://localhost:8080/api>

## Dừng dự án

Nhấn `Ctrl+C` trong terminal đang chạy `run.sh` - script sẽ tự động dừng cả backend và frontend.

## Xem logs

Logs được lưu tại:

- `backend.log` - Logs của Spring Boot
- `frontend.log` - Logs của Vite

Xem logs real-time:

```bash
tail -f backend.log
tail -f frontend.log
```

## Troubleshooting

### Port đã được sử dụng

Nếu port 8080 hoặc 5173 đang được sử dụng:

```bash
# Tìm và kill process trên port 8080 (Backend)
lsof -ti:8080 | xargs kill -9

# Tìm và kill process trên port 5173 (Frontend)
lsof -ti:5173 | xargs kill -9
```

### Dependencies thiếu

Script sẽ báo lỗi cụ thể nếu thiếu:

- Java 17+
- Maven
- Node.js 18+
- npm

Cài đặt theo hướng dẫn trong error message.
