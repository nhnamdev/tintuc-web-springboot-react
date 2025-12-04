-- =====================================================
-- AUTO-CREATE USER IN DATABASE WHEN SIGN UP
-- Trigger này sẽ tự động tạo record trong bảng users
-- khi có user mới đăng ký qua Supabase Auth
-- =====================================================

-- Function: Tự động tạo user trong bảng users
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name, avatar_url, role, is_active)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    NEW.raw_user_meta_data->>'avatar_url',
    'reader',
    true
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger: Chạy function khi có user mới trong auth.users
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- GIẢI THÍCH
-- =====================================================
-- 1. Khi user đăng ký/đăng nhập lần đầu (Google OAuth hoặc email/password)
--    → Supabase Auth tạo record trong bảng auth.users
-- 
-- 2. Trigger "on_auth_user_created" được kích hoạt
--    → Gọi function handle_new_user()
-- 
-- 3. Function tự động insert vào bảng public.users với:
--    - id: Giống với auth.users.id (UUID)
--    - email: Từ auth.users.email
--    - full_name: Từ Google metadata hoặc lấy từ email
--    - avatar_url: Từ Google metadata (nếu có)
--    - role: Mặc định là 'reader'
--    - is_active: Mặc định là true
-- 
-- 4. User có thể cập nhật thông tin sau trong ProfilePage
-- =====================================================

-- Test: Kiểm tra trigger đã hoạt động chưa
-- SELECT * FROM pg_trigger WHERE tgname = 'on_auth_user_created';
