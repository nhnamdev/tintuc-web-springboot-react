# Hướng Dẫn Setup Project - Website Tin Tức Dân Trí

## 📋 Tổng Quan

Project được chia thành 3 phần chính:
1. **Database** - Supabase (PostgreSQL)
2. **Backend** - Spring Boot REST API
3. **Frontend** - React Web App

---

## 🗄️ Bước 1: Setup Database (Supabase)

### 1.1. Tạo Project Supabase

1. Truy cập [https://supabase.com](https://supabase.com)
2. Đăng nhập hoặc tạo tài khoản
3. Click **"New Project"**
4. Điền thông tin:
   - Name: `dantri-news`
   - Database Password: Tạo password mạnh (lưu lại)
   - Region: `Southeast Asia (Singapore)`
5. Click **"Create new project"**

### 1.2. Chạy Database Schema

1. Vào **SQL Editor** trong Supabase Dashboard
2. Click **"New query"**
3. Copy nội dung file `supabase_schema.sql`
4. Paste và click **"Run"**

### 1.3. Setup Storage Buckets

1. Vào **Storage** → **"Create bucket"**
2. Tạo 3 buckets:
   - `avatars` (Public, 2MB limit)
   - `articles` (Public, 5MB limit)
   - `media` (Public, 50MB limit)
3. Chạy file `storage_policies.sql` trong SQL Editor

### 1.4. Lấy Credentials

Vào **Settings** → **API** và copy:
- **Project URL**: `https://psxxzstgcmjkvrylagrg.supabase.co`
- **anon public key**: `eyJhbGc...`
- **Database Password**: (password bạn đã tạo)

---

## 🔧 Bước 2: Setup Backend (Spring Boot)

### 2.1. Prerequisites

- Java 17 hoặc cao hơn
- Maven 3.6+

Kiểm tra:
```bash
java -version
mvn -version
```

### 2.2. Cấu Hình Database Connection

Mở file `backend/application.properties` và cập nhật:

```properties
spring.datasource.password=YOUR_SUPABASE_PASSWORD
```

Thay `YOUR_SUPABASE_PASSWORD` bằng password Supabase thực tế.

### 2.3. Build & Run

```bash
cd backend
mvn clean install
mvn spring-boot:run
```

Backend API sẽ chạy tại: `http://localhost:8080/api`

### 2.4. Verify

Mở browser và truy cập:
- `http://localhost:8080/api` - Nên thấy response hoặc 404 (bình thường vì chưa có endpoints)

---

## ⚛️ Bước 3: Setup Frontend (React)

### 3.1. Prerequisites

- Node.js 18 hoặc cao hơn
- npm hoặc yarn

Kiểm tra:
```bash
node -version
npm -version
```

### 3.2. Cài Đặt Dependencies

```bash
cd frontend
npm install
```

### 3.3. Cấu Hình Environment Variables

1. Copy file `.env.example` thành `.env`:
```bash
cp .env.example .env
```

2. Mở file `.env` và cập nhật:
```env
VITE_SUPABASE_URL=https://psxxzstgcmjkvrylagrg.supabase.co
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key_here
VITE_API_URL=http://localhost:8080/api
```

Thay `your_supabase_anon_key_here` bằng anon key từ Supabase.

### 3.4. Run Development Server

```bash
npm run dev
```

Frontend sẽ chạy tại: `http://localhost:3000`

### 3.5. Verify

Mở browser và truy cập `http://localhost:3000` - Nên thấy trang chủ Dân Trí.

---

## ✅ Checklist Hoàn Thành

### Database
- [ ] Đã tạo Supabase project
- [ ] Đã chạy `supabase_schema.sql`
- [ ] Đã tạo 3 storage buckets
- [ ] Đã chạy `storage_policies.sql`
- [ ] Đã lưu credentials (URL, anon key, password)

### Backend
- [ ] Đã cài Java 17+
- [ ] Đã cài Maven
- [ ] Đã cập nhật `application.properties`
- [ ] Đã chạy `mvn clean install` thành công
- [ ] Backend đang chạy tại port 8080

### Frontend
- [ ] Đã cài Node.js 18+
- [ ] Đã chạy `npm install`
- [ ] Đã tạo file `.env`
- [ ] Đã cập nhật Supabase credentials
- [ ] Frontend đang chạy tại port 3000

---

## 🔗 Kết Nối Giữa Các Phần

```
┌─────────────┐
│   Browser   │
│ localhost:  │
│    3000     │
└──────┬──────┘
       │
       ├─────────────────┐
       │                 │
       ▼                 ▼
┌─────────────┐   ┌─────────────┐
│   React     │   │  Supabase   │
│  Frontend   │   │  (Direct)   │
└──────┬──────┘   └─────────────┘
       │
       │ /api/*
       ▼
┌─────────────┐
│ Spring Boot │
│   Backend   │
│ localhost:  │
│    8080     │
└──────┬──────┘
       │
       │ JDBC
       ▼
┌─────────────┐
│  Supabase   │
│ PostgreSQL  │
└─────────────┘
```

**Lưu ý:**
- Frontend có thể kết nối **trực tiếp** với Supabase (cho read operations)
- Frontend cũng có thể call Backend API (cho business logic phức tạp)
- Backend kết nối với Supabase qua JDBC

---

## 🚀 Workflow Phát Triển

### 1. Chạy Database (Supabase)
→ Luôn online, không cần chạy local

### 2. Chạy Backend
```bash
cd backend
mvn spring-boot:run
```

### 3. Chạy Frontend
```bash
cd frontend
npm run dev
```

### 4. Development
- Frontend: `http://localhost:3000`
- Backend API: `http://localhost:8080/api`
- Supabase Dashboard: `https://app.supabase.com`

---

## 🐛 Troubleshooting

### Backend không kết nối được database
```
Error: Connection refused
```
→ Kiểm tra password trong `application.properties`
→ Kiểm tra network/firewall

### Frontend không fetch được data
```
Error: Missing Supabase environment variables
```
→ Kiểm tra file `.env` đã tạo chưa
→ Kiểm tra VITE_ prefix trong env variables

### CORS errors
```
Access to fetch blocked by CORS policy
```
→ Kiểm tra Vite proxy config trong `vite.config.js`
→ Hoặc thêm CORS config trong Spring Boot

---

## 📚 Tài Liệu Tham Khảo

- [Database Schema](./supabase_schema.sql)
- [Supabase Guide](./HUONG_DAN_SUPABASE.md)
- [Backend README](./backend/README.md)
- [Frontend README](./frontend/README.md)

---

## 🎯 Next Steps

1. **Backend**: Implement Services, Controllers, DTOs
2. **Frontend**: Build components, pages, features
3. **Testing**: Write unit tests và integration tests
4. **Deployment**: Deploy lên production

---

**Chúc bạn code vui vẻ! 🚀**
