# Storage Policies cho Supabase - Website Tin Tức Dân Trí

## Mục đích
File này chứa các SQL policies để cấu hình quyền truy cập cho Storage buckets.

---

## 🗂️ Storage Buckets Cần Tạo

### 1. Bucket: `avatars`
- **Mục đích**: Lưu ảnh đại diện người dùng
- **Public**: ✅ Yes
- **File size limit**: 2MB
- **Allowed MIME types**: image/jpeg, image/png, image/webp

### 2. Bucket: `articles`
- **Mục đích**: Lưu hình ảnh cho bài viết
- **Public**: ✅ Yes
- **File size limit**: 5MB
- **Allowed MIME types**: image/jpeg, image/png, image/webp, image/gif

### 3. Bucket: `media`
- **Mục đích**: Lưu video và media khác
- **Public**: ✅ Yes
- **File size limit**: 50MB
- **Allowed MIME types**: video/mp4, video/webm, audio/mpeg, audio/wav

---

## 📝 SQL Policies

Chạy các câu lệnh SQL sau trong Supabase SQL Editor:

```sql
-- =====================================================
-- STORAGE POLICIES CHO BUCKET: avatars
-- =====================================================

-- Cho phép mọi người xem ảnh đại diện
CREATE POLICY "Anyone can view avatars"
ON storage.objects FOR SELECT
USING (bucket_id = 'avatars');

-- Cho phép user đã login upload ảnh đại diện
CREATE POLICY "Authenticated users can upload avatars"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'avatars' 
    AND auth.role() = 'authenticated'
);

-- Cho phép user update ảnh đại diện của mình
CREATE POLICY "Users can update own avatars"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'avatars' 
    AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Cho phép user xóa ảnh đại diện của mình
CREATE POLICY "Users can delete own avatars"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'avatars' 
    AND auth.uid()::text = (storage.foldername(name))[1]
);

-- =====================================================
-- STORAGE POLICIES CHO BUCKET: articles
-- =====================================================

-- Cho phép mọi người xem hình ảnh bài viết
CREATE POLICY "Anyone can view article images"
ON storage.objects FOR SELECT
USING (bucket_id = 'articles');

-- Cho phép Author/Editor/Admin upload hình ảnh bài viết
CREATE POLICY "Authors can upload article images"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'articles' 
    AND auth.role() = 'authenticated'
    AND EXISTS (
        SELECT 1 FROM public.users
        WHERE id = auth.uid()
        AND role IN ('author', 'editor', 'admin')
    )
);

-- Cho phép Author update hình ảnh bài viết của mình
CREATE POLICY "Authors can update own article images"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'articles' 
    AND (
        -- Author của bài viết
        EXISTS (
            SELECT 1 FROM public.articles
            WHERE id::text = (storage.foldername(name))[1]
            AND author_id = auth.uid()
        )
        OR
        -- Hoặc là Editor/Admin
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid()
            AND role IN ('editor', 'admin')
        )
    )
);

-- Cho phép Author xóa hình ảnh bài viết của mình
CREATE POLICY "Authors can delete own article images"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'articles' 
    AND (
        -- Author của bài viết
        EXISTS (
            SELECT 1 FROM public.articles
            WHERE id::text = (storage.foldername(name))[1]
            AND author_id = auth.uid()
        )
        OR
        -- Hoặc là Editor/Admin
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid()
            AND role IN ('editor', 'admin')
        )
    )
);

-- =====================================================
-- STORAGE POLICIES CHO BUCKET: media
-- =====================================================

-- Cho phép mọi người xem media files
CREATE POLICY "Anyone can view media files"
ON storage.objects FOR SELECT
USING (bucket_id = 'media');

-- Cho phép Author/Editor/Admin upload media
CREATE POLICY "Authors can upload media"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'media' 
    AND auth.role() = 'authenticated'
    AND EXISTS (
        SELECT 1 FROM public.users
        WHERE id = auth.uid()
        AND role IN ('author', 'editor', 'admin')
    )
);

-- Cho phép Author update media của bài viết mình
CREATE POLICY "Authors can update own media"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'media' 
    AND (
        EXISTS (
            SELECT 1 FROM public.articles
            WHERE id::text = (storage.foldername(name))[1]
            AND author_id = auth.uid()
        )
        OR
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid()
            AND role IN ('editor', 'admin')
        )
    )
);

-- Cho phép Author xóa media của bài viết mình
CREATE POLICY "Authors can delete own media"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'media' 
    AND (
        EXISTS (
            SELECT 1 FROM public.articles
            WHERE id::text = (storage.foldername(name))[1]
            AND author_id = auth.uid()
        )
        OR
        EXISTS (
            SELECT 1 FROM public.users
            WHERE id = auth.uid()
            AND role IN ('editor', 'admin')
        )
    )
);
```

---

## 🔧 Cấu Hình Bucket Settings

Nếu muốn giới hạn file size và MIME types, chạy:

```sql
-- Cấu hình cho bucket avatars
UPDATE storage.buckets
SET 
    file_size_limit = 2097152, -- 2MB
    allowed_mime_types = ARRAY['image/jpeg', 'image/png', 'image/webp']
WHERE id = 'avatars';

-- Cấu hình cho bucket articles
UPDATE storage.buckets
SET 
    file_size_limit = 5242880, -- 5MB
    allowed_mime_types = ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']
WHERE id = 'articles';

-- Cấu hình cho bucket media
UPDATE storage.buckets
SET 
    file_size_limit = 52428800, -- 50MB
    allowed_mime_types = ARRAY['video/mp4', 'video/webm', 'audio/mpeg', 'audio/wav']
WHERE id = 'media';
```

---

## 📂 Cấu Trúc Thư Mục Đề Xuất

### Bucket: avatars
```
avatars/
  ├── {user_id}/
  │   └── avatar.jpg
```

### Bucket: articles
```
articles/
  ├── {article_id}/
  │   ├── thumbnail.jpg
  │   ├── image-1.jpg
  │   ├── image-2.jpg
  │   └── ...
```

### Bucket: media
```
media/
  ├── {article_id}/
  │   ├── video-1.mp4
  │   ├── video-2.webm
  │   └── ...
```

---

## 💻 Ví Dụ Upload File

### 1. Upload Avatar

```javascript
const uploadAvatar = async (userId, file) => {
    const fileExt = file.name.split('.').pop();
    const fileName = `${userId}/avatar.${fileExt}`;
    
    const { data, error } = await supabase.storage
        .from('avatars')
        .upload(fileName, file, {
            upsert: true // Ghi đè nếu đã tồn tại
        });
    
    if (error) throw error;
    
    // Lấy public URL
    const { data: { publicUrl } } = supabase.storage
        .from('avatars')
        .getPublicUrl(fileName);
    
    // Update user avatar_url
    await supabase
        .from('users')
        .update({ avatar_url: publicUrl })
        .eq('id', userId);
    
    return publicUrl;
};
```

### 2. Upload Article Image

```javascript
const uploadArticleImage = async (articleId, file) => {
    const fileExt = file.name.split('.').pop();
    const fileName = `${articleId}/${Date.now()}.${fileExt}`;
    
    const { data, error } = await supabase.storage
        .from('articles')
        .upload(fileName, file);
    
    if (error) throw error;
    
    // Lấy public URL
    const { data: { publicUrl } } = supabase.storage
        .from('articles')
        .getPublicUrl(fileName);
    
    // Lưu vào bảng media
    await supabase
        .from('media')
        .insert({
            article_id: articleId,
            file_url: publicUrl,
            file_type: 'image',
            file_size: file.size
        });
    
    return publicUrl;
};
```

### 3. Upload Video

```javascript
const uploadVideo = async (articleId, file, onProgress) => {
    const fileExt = file.name.split('.').pop();
    const fileName = `${articleId}/${Date.now()}.${fileExt}`;
    
    const { data, error } = await supabase.storage
        .from('media')
        .upload(fileName, file, {
            cacheControl: '3600',
            upsert: false,
            onUploadProgress: (progress) => {
                const percent = (progress.loaded / progress.total) * 100;
                onProgress?.(percent);
            }
        });
    
    if (error) throw error;
    
    const { data: { publicUrl } } = supabase.storage
        .from('media')
        .getPublicUrl(fileName);
    
    await supabase
        .from('media')
        .insert({
            article_id: articleId,
            file_url: publicUrl,
            file_type: 'video',
            file_size: file.size
        });
    
    return publicUrl;
};
```

### 4. Xóa File

```javascript
const deleteFile = async (bucketName, filePath) => {
    const { data, error } = await supabase.storage
        .from(bucketName)
        .remove([filePath]);
    
    if (error) throw error;
    return data;
};

// Ví dụ: Xóa avatar cũ trước khi upload avatar mới
await deleteFile('avatars', `${userId}/avatar.jpg`);
```

---

## ✅ Checklist Setup Storage

- [ ] Đã tạo bucket `avatars` (Public, 2MB limit)
- [ ] Đã tạo bucket `articles` (Public, 5MB limit)
- [ ] Đã tạo bucket `media` (Public, 50MB limit)
- [ ] Đã chạy SQL policies cho cả 3 buckets
- [ ] Đã cấu hình file size limits
- [ ] Đã cấu hình allowed MIME types
- [ ] Đã test upload file thành công
- [ ] Đã test xóa file thành công

---

## 🔍 Troubleshooting

### Lỗi: "new row violates row-level security policy"
→ User chưa login hoặc không có quyền upload

### Lỗi: "The resource already exists"
→ File đã tồn tại, dùng `upsert: true` để ghi đè

### Lỗi: "Payload too large"
→ File vượt quá giới hạn size, cần resize trước khi upload

### Lỗi: "Invalid MIME type"
→ Loại file không được phép, kiểm tra `allowed_mime_types`

---

**Hoàn thành! Storage đã sẵn sàng sử dụng 🎉**
