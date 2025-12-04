# Hướng Dẫn Sử Dụng Database Supabase - Website Tin Tức Dân Trí

## 📋 Tổng Quan

Database này được thiết kế cho website tin tức Dân Trí với đầy đủ tính năng:
- ✅ Quản lý bài viết, danh mục, tags
- ✅ Hệ thống phân quyền (Admin, Editor, Author, Reader)
- ✅ Bình luận và phản hồi
- ✅ Lưu bài viết yêu thích
- ✅ Thống kê lượt xem
- ✅ Thông báo tự động
- ✅ Bảo mật với Row Level Security (RLS)

---

## 🚀 Cách Triển Khai

### Bước 1: Tạo Project trên Supabase

1. Truy cập [https://supabase.com](https://supabase.com)
2. Đăng nhập hoặc tạo tài khoản mới
3. Click **"New Project"**
4. Điền thông tin:
   - **Name**: `dantri-news`
   - **Database Password**: Tạo mật khẩu mạnh
   - **Region**: Chọn `Southeast Asia (Singapore)` để tốc độ tốt nhất cho Việt Nam
5. Click **"Create new project"** và đợi vài phút

### Bước 2: Chạy SQL Schema

1. Trong Supabase Dashboard, vào **SQL Editor** (menu bên trái)
2. Click **"New query"**
3. Copy toàn bộ nội dung file `supabase_schema.sql`
4. Paste vào SQL Editor
5. Click **"Run"** để thực thi

✅ Database của bạn đã sẵn sàng!

### Bước 3: Cấu Hình Storage (Lưu trữ hình ảnh)

1. Vào **Storage** trong menu bên trái
2. Click **"Create a new bucket"**
3. Tạo 3 buckets sau:

#### Bucket 1: avatars (Ảnh đại diện)
```
Name: avatars
Public: ✅ (checked)
File size limit: 2MB
Allowed MIME types: image/jpeg, image/png, image/webp
```

#### Bucket 2: articles (Hình ảnh bài viết)
```
Name: articles
Public: ✅ (checked)
File size limit: 5MB
Allowed MIME types: image/jpeg, image/png, image/webp
```

#### Bucket 3: media (Video và media khác)
```
Name: media
Public: ✅ (checked)
File size limit: 50MB
Allowed MIME types: video/mp4, video/webm, audio/mpeg
```

### Bước 4: Cấu Hình Storage Policies

Chạy SQL sau để cho phép upload file:

```sql
-- Policy cho bucket avatars
CREATE POLICY "Anyone can upload avatars"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'avatars');

CREATE POLICY "Anyone can view avatars"
ON storage.objects FOR SELECT
USING (bucket_id = 'avatars');

-- Policy cho bucket articles
CREATE POLICY "Authenticated users can upload article images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'articles' AND auth.role() = 'authenticated');

CREATE POLICY "Anyone can view article images"
ON storage.objects FOR SELECT
USING (bucket_id = 'articles');

-- Policy cho bucket media
CREATE POLICY "Authenticated users can upload media"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'media' AND auth.role() = 'authenticated');

CREATE POLICY "Anyone can view media"
ON storage.objects FOR SELECT
USING (bucket_id = 'media');
```

---

## 📊 Cấu Trúc Database

### 1. **users** - Người dùng
Quản lý thông tin người dùng và phân quyền.

**Các role:**
- `admin` - Quản trị viên (full quyền)
- `editor` - Biên tập viên (duyệt bài, quản lý)
- `author` - Tác giả (viết bài)
- `reader` - Độc giả (đọc, comment)

### 2. **categories** - Danh mục
Phân loại bài viết theo chủ đề (Thời sự, Kinh doanh, Công nghệ...)

**Tính năng:**
- Hỗ trợ danh mục con (parent_id)
- Sắp xếp thứ tự hiển thị (order_index)
- Có thể ẩn/hiện (is_active)

### 3. **articles** - Bài viết
Lưu trữ toàn bộ bài viết.

**Trạng thái:**
- `draft` - Bản nháp
- `published` - Đã xuất bản
- `archived` - Lưu trữ

**Tính năng đặc biệt:**
- `is_featured` - Bài viết nổi bật
- `is_breaking_news` - Tin nóng
- `view_count` - Đếm lượt xem tự động

### 4. **tags** - Thẻ tag
Gắn tag cho bài viết (VD: #TinNóng, #Video...)

### 5. **article_tags** - Quan hệ bài viết - tag
Liên kết nhiều-nhiều giữa articles và tags.

### 6. **comments** - Bình luận
Hệ thống bình luận có phân cấp (reply).

**Tính năng:**
- Bình luận lồng nhau (parent_id)
- Duyệt bình luận (is_approved)
- Tự động tạo thông báo

### 7. **bookmarks** - Lưu bài viết
User có thể lưu bài viết yêu thích.

### 8. **article_views** - Lượt xem
Theo dõi chi tiết lượt xem (IP, user agent, thời gian).

### 9. **media** - Media files
Quản lý hình ảnh, video trong bài viết.

### 10. **notifications** - Thông báo
Thông báo tự động cho user.

**Loại thông báo:**
- `comment` - Có người comment bài viết
- `reply` - Có người reply comment
- `article_published` - Bài viết được xuất bản
- `system` - Thông báo hệ thống

---

## 🔐 Bảo Mật (Row Level Security)

Database đã được cấu hình RLS policies:

### Quyền đọc (SELECT)
- ✅ Mọi người xem được bài viết `published`
- ✅ Author xem được bài viết `draft` của mình
- ✅ Mọi người xem được comment đã `approved`
- ✅ User chỉ xem được bookmark và notification của mình

### Quyền tạo (INSERT)
- ✅ Author/Editor/Admin tạo bài viết
- ✅ User đã login tạo comment
- ✅ User đã login tạo bookmark

### Quyền sửa (UPDATE)
- ✅ Author sửa bài viết của mình
- ✅ Editor/Admin sửa mọi bài viết
- ✅ User sửa comment của mình

### Quyền xóa (DELETE)
- ✅ Editor/Admin xóa bài viết
- ✅ User xóa comment và bookmark của mình

---

## 🎯 Các Tính Năng Tự Động

### 1. Auto Update Timestamp
Tự động cập nhật `updated_at` khi có thay đổi.

### 2. Auto Increment View Count
Tự động tăng `view_count` khi có lượt xem mới.

### 3. Auto Create Notifications
Tự động tạo thông báo khi:
- Có comment mới trên bài viết của bạn
- Có người reply comment của bạn

---

## 💻 Ví Dụ Sử Dụng API

### 1. Lấy danh sách bài viết mới nhất

```javascript
const { data, error } = await supabase
  .from('articles')
  .select(`
    *,
    author:users(full_name, avatar_url),
    category:categories(name, slug),
    tags:article_tags(tag:tags(name, slug))
  `)
  .eq('status', 'published')
  .order('published_at', { ascending: false })
  .limit(10);
```

### 2. Lấy bài viết theo slug

```javascript
const { data, error } = await supabase
  .from('articles')
  .select(`
    *,
    author:users(full_name, avatar_url, bio),
    category:categories(name, slug),
    tags:article_tags(tag:tags(name, slug)),
    media(*)
  `)
  .eq('slug', 'bai-viet-mau')
  .eq('status', 'published')
  .single();
```

### 3. Tạo bài viết mới

```javascript
const { data, error } = await supabase
  .from('articles')
  .insert({
    title: 'Tiêu đề bài viết',
    slug: 'tieu-de-bai-viet',
    summary: 'Tóm tắt ngắn gọn',
    content: 'Nội dung đầy đủ...',
    thumbnail_url: 'https://...',
    author_id: userId,
    category_id: categoryId,
    status: 'draft'
  })
  .select()
  .single();
```

### 4. Thêm comment

```javascript
const { data, error } = await supabase
  .from('comments')
  .insert({
    article_id: articleId,
    user_id: userId,
    content: 'Nội dung bình luận',
    parent_id: null // hoặc parentCommentId nếu là reply
  });
```

### 5. Lưu bài viết (bookmark)

```javascript
const { data, error } = await supabase
  .from('bookmarks')
  .insert({
    user_id: userId,
    article_id: articleId
  });
```

### 6. Ghi nhận lượt xem

```javascript
const { data, error } = await supabase
  .from('article_views')
  .insert({
    article_id: articleId,
    user_id: userId, // null nếu chưa login
    ip_address: userIp,
    user_agent: navigator.userAgent
  });
```

### 7. Lấy bài viết trending (nhiều view nhất)

```javascript
const { data, error } = await supabase
  .from('articles')
  .select(`
    *,
    author:users(full_name, avatar_url),
    category:categories(name, slug)
  `)
  .eq('status', 'published')
  .order('view_count', { ascending: false })
  .limit(5);
```

### 8. Lấy thông báo chưa đọc

```javascript
const { data, error } = await supabase
  .from('notifications')
  .select('*')
  .eq('user_id', userId)
  .eq('is_read', false)
  .order('created_at', { ascending: false });
```

### 9. Upload hình ảnh

```javascript
// Upload file
const { data, error } = await supabase.storage
  .from('articles')
  .upload(`${articleId}/${fileName}`, file);

// Lấy public URL
const { data: { publicUrl } } = supabase.storage
  .from('articles')
  .getPublicUrl(`${articleId}/${fileName}`);
```

---

## 📈 Tối Ưu Performance

### Indexes đã được tạo sẵn:
- ✅ Articles: slug, category_id, author_id, published_at, status
- ✅ Comments: article_id, user_id, parent_id
- ✅ Article Views: article_id, viewed_at
- ✅ Bookmarks: user_id, article_id

### Gợi ý thêm:
1. **Caching**: Sử dụng Redis/Vercel KV cho bài viết hot
2. **CDN**: Upload media lên CDN (Cloudinary, Cloudflare)
3. **Pagination**: Luôn dùng `.limit()` và `.range()`
4. **Select specific fields**: Chỉ select field cần thiết

---

## 🔧 Bảo Trì

### Xóa dữ liệu cũ (Optional)

```sql
-- Xóa article views cũ hơn 90 ngày
DELETE FROM article_views
WHERE viewed_at < NOW() - INTERVAL '90 days';

-- Xóa notifications đã đọc cũ hơn 30 ngày
DELETE FROM notifications
WHERE is_read = true
AND created_at < NOW() - INTERVAL '30 days';
```

### Backup Database

1. Vào **Database** → **Backups** trong Supabase Dashboard
2. Click **"Download backup"**
3. Hoặc setup auto backup hàng ngày

---

## 📞 Lấy Thông Tin Kết Nối

Trong Supabase Dashboard:
1. Vào **Settings** → **API**
2. Copy:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon public key**: `eyJhbGc...`

### Cấu hình trong code:

```javascript
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'YOUR_SUPABASE_URL';
const supabaseKey = 'YOUR_SUPABASE_ANON_KEY';

export const supabase = createClient(supabaseUrl, supabaseKey);
```

---

## ✅ Checklist Sau Khi Setup

- [ ] Đã chạy `supabase_schema.sql` thành công
- [ ] Đã tạo 3 storage buckets (avatars, articles, media)
- [ ] Đã cấu hình storage policies
- [ ] Đã test tạo user mẫu
- [ ] Đã test tạo bài viết mẫu
- [ ] Đã test upload hình ảnh
- [ ] Đã lấy API keys và lưu an toàn
- [ ] Đã test RLS policies hoạt động đúng

---

## 🎓 Tài Liệu Tham Khảo

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase JavaScript Client](https://supabase.com/docs/reference/javascript/introduction)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [Storage Guide](https://supabase.com/docs/guides/storage)

---

## 🆘 Troubleshooting

### Lỗi: "new row violates row-level security policy"
→ Kiểm tra user đã login và có đúng quyền chưa

### Lỗi: "duplicate key value violates unique constraint"
→ Slug hoặc email đã tồn tại, cần đổi giá trị khác

### Lỗi: Upload file thất bại
→ Kiểm tra storage policies và file size limit

### Performance chậm
→ Kiểm tra indexes, sử dụng `.explain()` để debug query

---

**Chúc bạn triển khai thành công! 🚀**
