# ⚠️ CÁCH LẤY SUPABASE ANON KEY ĐÚNG

## Bước 1: Vào Supabase Dashboard

1. Truy cập: https://app.supabase.com
2. Đăng nhập
3. Chọn project **dantri-news**

## Bước 2: Lấy API Keys

1. Click **Settings** (icon bánh răng bên trái)
2. Click **API** trong menu Settings
3. Tìm phần **Project API keys**

## Bước 3: Copy Keys

Bạn sẽ thấy 2 keys:

### 1. anon public (Key này cần copy)
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBzeHh6c3RnY21qa3ZyeWxhcXJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMxOTI1MjcsImV4cCI6MjA0ODc2ODUyN30.XXXXXXXXXXXXXXXXXXXXXXXXX
```

**Đặc điểm:**
- Rất dài (khoảng 200-300 ký tự)
- Bắt đầu bằng `eyJ`
- Có 2 dấu chấm `.` ở giữa
- KHÔNG có chữ `sb_publishable`

### 2. service_role (KHÔNG dùng key này cho frontend)
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBzeHh6c3RnY21qa3ZyeWxhcXJnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMzE5MjUyNywiZXhwIjoyMDQ4NzY4NTI3fQ.XXXXXXXXXXXXXXXXXXXXXXXXX
```

## Bước 4: Cập Nhật File .env

Mở file `frontend/.env` và thay thế:

```env
VITE_SUPABASE_URL=https://psxxzstgcmjkvrylaqrg.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGc...PASTE_ANON_KEY_Ở_ĐÂY...
VITE_API_URL=http://localhost:8080/api
```

## Bước 5: Restart Frontend

1. Dừng server: `Ctrl + C`
2. Chạy lại: `npm start`

---

## 🔍 Kiểm Tra Key Đúng Chưa

**Anon key đúng phải:**
- ✅ Dài khoảng 200-300 ký tự
- ✅ Bắt đầu bằng `eyJ`
- ✅ Có đúng 2 dấu chấm `.`
- ✅ Kết thúc bằng một chuỗi ký tự ngẫu nhiên
- ❌ KHÔNG có `sb_publishable`
- ❌ KHÔNG có khoảng trắng

**Ví dụ format đúng:**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBzeHh6c3RnY21qa3ZyeWxhcXJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMxOTI1MjcsImV4cCI6MjA0ODc2ODUyN30.abc123xyz789...
```

---

## 📸 Screenshot Cần Gửi

Nếu vẫn lỗi, hãy gửi screenshot phần **Project API keys** trong Supabase Dashboard (che phần cuối của keys).
