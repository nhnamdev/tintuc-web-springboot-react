# Hướng Dẫn Fix Lỗi Kết Nối Database

## ❌ Lỗi Hiện Tại

```
java.net.UnknownHostException: db.psxxzstgcmjkvrylagrg.supabase.co
```

**Nguyên nhân**: Hostname database không tồn tại hoặc sai.

---

## ✅ Cách Kiểm Tra & Fix

### Bước 1: Lấy Connection String Chính Xác

1. Vào **Supabase Dashboard**: https://app.supabase.com
2. Chọn project `dantri-news`
3. Vào **Settings** → **Database**
4. Tìm phần **Connection string**
5. Chọn tab **URI** hoặc **Connection pooling**

### Bước 2: Copy Connection Info

Bạn sẽ thấy thông tin dạng:

**Session mode (Direct connection):**
```
Host: db.xxxxxx.supabase.co
Port: 5432
Database: postgres
User: postgres
Password: [your-password]
```

**HOẶC Transaction mode (Connection pooling):**
```
Host: aws-0-ap-southeast-1.pooler.supabase.com
Port: 6543
Database: postgres
User: postgres.xxxxxx
Password: [your-password]
```

### Bước 3: Cập Nhật application.properties

Mở file `backend/application.properties` và cập nhật:

**Nếu dùng Direct connection:**
```properties
spring.datasource.url=jdbc:postgresql://db.XXXXX.supabase.co:5432/postgres
spring.datasource.username=postgres
spring.datasource.password=YOUR_ACTUAL_PASSWORD
```

**Nếu dùng Connection pooling (Recommended):**
```properties
spring.datasource.url=jdbc:postgresql://aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres
spring.datasource.username=postgres.XXXXX
spring.datasource.password=YOUR_ACTUAL_PASSWORD
```

---

## 🔍 Kiểm Tra Kết Nối

### Test DNS Resolution

```bash
nslookup db.XXXXX.supabase.co
```

Nếu thành công, bạn sẽ thấy IP address.

### Test Ping

```bash
ping db.XXXXX.supabase.co
```

### Test PostgreSQL Connection

```bash
psql "postgresql://postgres:PASSWORD@db.XXXXX.supabase.co:5432/postgres"
```

---

## 📝 Checklist

- [ ] Đã vào Supabase Dashboard
- [ ] Đã copy đúng hostname từ Settings → Database
- [ ] Đã cập nhật `application.properties`
- [ ] Đã thay YOUR_ACTUAL_PASSWORD bằng password thực
- [ ] Đã test nslookup thành công
- [ ] Đã restart Spring Boot application

---

## 🆘 Nếu Vẫn Lỗi

### Thử dùng Connection Pooling

Connection pooling thường ổn định hơn:

```properties
spring.datasource.url=jdbc:postgresql://aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres
spring.datasource.username=postgres.XXXXX
spring.datasource.password=YOUR_PASSWORD
```

### Kiểm tra Firewall/VPN

- Tắt VPN nếu đang bật
- Kiểm tra firewall có block port 5432/6543 không
- Thử đổi mạng (4G/5G)

### Kiểm tra Supabase Project

- Project có đang active không?
- Project có bị pause không?
- Region có đúng không?

---

## 📞 Cần Hỗ Trợ

Vui lòng cung cấp:
1. Screenshot phần Connection string từ Supabase Dashboard
2. Nội dung file `application.properties` (che password)
3. Kết quả lệnh `nslookup` với hostname mới
