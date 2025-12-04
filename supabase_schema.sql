-- =====================================================
-- DATABASE SCHEMA CHO WEBSITE TIN TỨC DÂN TRÍ
-- Supabase PostgreSQL Database
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- 1. BẢNG USERS - NGƯỜI DÙNG
-- =====================================================
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    avatar_url TEXT,
    role TEXT NOT NULL DEFAULT 'reader' CHECK (role IN ('admin', 'editor', 'author', 'reader')),
    bio TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 2. BẢNG CATEGORIES - DANH MỤC TIN TỨC
-- =====================================================
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    parent_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    icon_url TEXT,
    order_index INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 3. BẢNG ARTICLES - BÀI VIẾT
-- =====================================================
CREATE TABLE articles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    summary TEXT,
    content TEXT NOT NULL,
    thumbnail_url TEXT,
    author_id UUID REFERENCES users(id) ON DELETE SET NULL,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
    is_featured BOOLEAN DEFAULT false,
    is_breaking_news BOOLEAN DEFAULT false,
    published_at TIMESTAMP WITH TIME ZONE,
    view_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 4. BẢNG TAGS - THẺ TAG
-- =====================================================
CREATE TABLE tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 5. BẢNG ARTICLE_TAGS - QUAN HỆ BÀI VIẾT - TAG
-- =====================================================
CREATE TABLE article_tags (
    article_id UUID REFERENCES articles(id) ON DELETE CASCADE,
    tag_id UUID REFERENCES tags(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (article_id, tag_id)
);

-- =====================================================
-- 6. BẢNG COMMENTS - BÌNH LUẬN
-- =====================================================
CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    article_id UUID REFERENCES articles(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    is_approved BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 7. BẢNG BOOKMARKS - LƯU BÀI VIẾT
-- =====================================================
CREATE TABLE bookmarks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    article_id UUID REFERENCES articles(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, article_id)
);

-- =====================================================
-- 8. BẢNG ARTICLE_VIEWS - LƯỢT XEM
-- =====================================================
CREATE TABLE article_views (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    article_id UUID REFERENCES articles(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    ip_address TEXT,
    user_agent TEXT,
    viewed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 9. BẢNG MEDIA - HÌNH ẢNH, VIDEO
-- =====================================================
CREATE TABLE media (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    article_id UUID REFERENCES articles(id) ON DELETE CASCADE,
    file_url TEXT NOT NULL,
    file_type TEXT NOT NULL CHECK (file_type IN ('image', 'video', 'audio')),
    file_size INTEGER,
    caption TEXT,
    order_index INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 10. BẢNG NOTIFICATIONS - THÔNG BÁO
-- =====================================================
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('comment', 'reply', 'article_published', 'system')),
    title TEXT NOT NULL,
    message TEXT,
    link TEXT,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- INDEXES ĐỂ TỐI ƯU PERFORMANCE
-- =====================================================

-- Articles indexes
CREATE INDEX idx_articles_slug ON articles(slug);
CREATE INDEX idx_articles_category ON articles(category_id);
CREATE INDEX idx_articles_author ON articles(author_id);
CREATE INDEX idx_articles_published ON articles(published_at DESC);
CREATE INDEX idx_articles_status ON articles(status);
CREATE INDEX idx_articles_featured ON articles(is_featured) WHERE is_featured = true;
CREATE INDEX idx_articles_breaking ON articles(is_breaking_news) WHERE is_breaking_news = true;

-- Comments indexes
CREATE INDEX idx_comments_article ON comments(article_id);
CREATE INDEX idx_comments_user ON comments(user_id);
CREATE INDEX idx_comments_parent ON comments(parent_id);

-- Article views indexes
CREATE INDEX idx_views_article ON article_views(article_id);
CREATE INDEX idx_views_date ON article_views(viewed_at DESC);

-- Bookmarks indexes
CREATE INDEX idx_bookmarks_user ON bookmarks(user_id);
CREATE INDEX idx_bookmarks_article ON bookmarks(article_id);

-- Categories indexes
CREATE INDEX idx_categories_slug ON categories(slug);
CREATE INDEX idx_categories_parent ON categories(parent_id);

-- Tags indexes
CREATE INDEX idx_tags_slug ON tags(slug);

-- Notifications indexes
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(is_read) WHERE is_read = false;

-- =====================================================
-- FUNCTIONS & TRIGGERS
-- =====================================================

-- Function: Tự động cập nhật updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger cho bảng users
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger cho bảng categories
CREATE TRIGGER update_categories_updated_at
    BEFORE UPDATE ON categories
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger cho bảng articles
CREATE TRIGGER update_articles_updated_at
    BEFORE UPDATE ON articles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger cho bảng comments
CREATE TRIGGER update_comments_updated_at
    BEFORE UPDATE ON comments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Function: Tự động tăng view_count
CREATE OR REPLACE FUNCTION increment_article_views()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE articles
    SET view_count = view_count + 1
    WHERE id = NEW.article_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger tăng view_count khi có lượt xem mới
CREATE TRIGGER increment_views_on_insert
    AFTER INSERT ON article_views
    FOR EACH ROW
    EXECUTE FUNCTION increment_article_views();

-- Function: Tạo notification khi có comment mới
CREATE OR REPLACE FUNCTION create_comment_notification()
RETURNS TRIGGER AS $$
DECLARE
    article_author_id UUID;
    article_title TEXT;
    commenter_name TEXT;
BEGIN
    -- Lấy thông tin tác giả và tiêu đề bài viết
    SELECT author_id, title INTO article_author_id, article_title
    FROM articles
    WHERE id = NEW.article_id;
    
    -- Lấy tên người comment
    SELECT full_name INTO commenter_name
    FROM users
    WHERE id = NEW.user_id;
    
    -- Tạo notification cho tác giả bài viết (nếu không phải tự comment)
    IF article_author_id IS NOT NULL AND article_author_id != NEW.user_id THEN
        INSERT INTO notifications (user_id, type, title, message, link)
        VALUES (
            article_author_id,
            'comment',
            'Bình luận mới',
            commenter_name || ' đã bình luận về bài viết "' || article_title || '"',
            '/articles/' || NEW.article_id
        );
    END IF;
    
    -- Nếu là reply, tạo notification cho người được reply
    IF NEW.parent_id IS NOT NULL THEN
        DECLARE
            parent_user_id UUID;
        BEGIN
            SELECT user_id INTO parent_user_id
            FROM comments
            WHERE id = NEW.parent_id;
            
            IF parent_user_id IS NOT NULL AND parent_user_id != NEW.user_id THEN
                INSERT INTO notifications (user_id, type, title, message, link)
                VALUES (
                    parent_user_id,
                    'reply',
                    'Phản hồi mới',
                    commenter_name || ' đã phản hồi bình luận của bạn',
                    '/articles/' || NEW.article_id
                );
            END IF;
        END;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger tạo notification khi có comment mới
CREATE TRIGGER create_notification_on_comment
    AFTER INSERT ON comments
    FOR EACH ROW
    EXECUTE FUNCTION create_comment_notification();

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS cho tất cả các bảng
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE article_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookmarks ENABLE ROW LEVEL SECURITY;
ALTER TABLE article_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE media ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- POLICIES CHO BẢNG USERS
-- =====================================================

-- Mọi người có thể xem thông tin user
CREATE POLICY "Users are viewable by everyone"
    ON users FOR SELECT
    USING (true);

-- User chỉ có thể update thông tin của chính mình
CREATE POLICY "Users can update own profile"
    ON users FOR UPDATE
    USING (auth.uid() = id);

-- =====================================================
-- POLICIES CHO BẢNG ARTICLES
-- =====================================================

-- Mọi người có thể xem bài viết đã published
CREATE POLICY "Published articles are viewable by everyone"
    ON articles FOR SELECT
    USING (status = 'published' OR auth.uid() = author_id);

-- Author có thể tạo bài viết
CREATE POLICY "Authors can create articles"
    ON articles FOR INSERT
    WITH CHECK (
        auth.uid() = author_id AND
        EXISTS (
            SELECT 1 FROM users
            WHERE id = auth.uid()
            AND role IN ('author', 'editor', 'admin')
        )
    );

-- Author có thể update bài viết của mình
CREATE POLICY "Authors can update own articles"
    ON articles FOR UPDATE
    USING (
        auth.uid() = author_id OR
        EXISTS (
            SELECT 1 FROM users
            WHERE id = auth.uid()
            AND role IN ('editor', 'admin')
        )
    );

-- Admin/Editor có thể xóa bài viết
CREATE POLICY "Admins can delete articles"
    ON articles FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM users
            WHERE id = auth.uid()
            AND role IN ('editor', 'admin')
        )
    );

-- =====================================================
-- POLICIES CHO BẢNG COMMENTS
-- =====================================================

-- Mọi người có thể xem comment đã approved
CREATE POLICY "Approved comments are viewable by everyone"
    ON comments FOR SELECT
    USING (is_approved = true OR auth.uid() = user_id);

-- User đã login có thể tạo comment
CREATE POLICY "Authenticated users can create comments"
    ON comments FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- User có thể update comment của mình
CREATE POLICY "Users can update own comments"
    ON comments FOR UPDATE
    USING (auth.uid() = user_id);

-- User có thể xóa comment của mình
CREATE POLICY "Users can delete own comments"
    ON comments FOR DELETE
    USING (auth.uid() = user_id);

-- =====================================================
-- POLICIES CHO BẢNG BOOKMARKS
-- =====================================================

-- User chỉ xem được bookmark của mình
CREATE POLICY "Users can view own bookmarks"
    ON bookmarks FOR SELECT
    USING (auth.uid() = user_id);

-- User có thể tạo bookmark
CREATE POLICY "Users can create bookmarks"
    ON bookmarks FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- User có thể xóa bookmark của mình
CREATE POLICY "Users can delete own bookmarks"
    ON bookmarks FOR DELETE
    USING (auth.uid() = user_id);

-- =====================================================
-- POLICIES CHO BẢNG NOTIFICATIONS
-- =====================================================

-- User chỉ xem được notification của mình
CREATE POLICY "Users can view own notifications"
    ON notifications FOR SELECT
    USING (auth.uid() = user_id);

-- User có thể update notification của mình (đánh dấu đã đọc)
CREATE POLICY "Users can update own notifications"
    ON notifications FOR UPDATE
    USING (auth.uid() = user_id);

-- =====================================================
-- POLICIES CHO CÁC BẢNG KHÁC
-- =====================================================

-- Categories: Mọi người có thể xem
CREATE POLICY "Categories are viewable by everyone"
    ON categories FOR SELECT
    USING (is_active = true);

-- Tags: Mọi người có thể xem
CREATE POLICY "Tags are viewable by everyone"
    ON tags FOR SELECT
    USING (true);

-- Article Tags: Mọi người có thể xem
CREATE POLICY "Article tags are viewable by everyone"
    ON article_tags FOR SELECT
    USING (true);

-- Media: Mọi người có thể xem
CREATE POLICY "Media are viewable by everyone"
    ON media FOR SELECT
    USING (true);

-- Article Views: Mọi người có thể tạo view
CREATE POLICY "Anyone can create article views"
    ON article_views FOR INSERT
    WITH CHECK (true);

-- =====================================================
-- DỮ LIỆU MẪU (OPTIONAL)
-- =====================================================

-- Insert sample categories
INSERT INTO categories (name, slug, description, order_index) VALUES
('Thời sự', 'thoi-su', 'Tin tức thời sự trong nước và quốc tế', 1),
('Kinh doanh', 'kinh-doanh', 'Tin tức kinh tế, tài chính, doanh nghiệp', 2),
('Công nghệ', 'cong-nghe', 'Tin tức công nghệ, khoa học, đổi mới', 3),
('Giải trí', 'giai-tri', 'Tin tức giải trí, showbiz, văn hóa', 4),
('Thể thao', 'the-thao', 'Tin tức thể thao trong nước và quốc tế', 5),
('Giáo dục', 'giao-duc', 'Tin tức giáo dục, đào tạo, học đường', 6),
('Sức khỏe', 'suc-khoe', 'Tin tức sức khỏe, y tế, làm đẹp', 7),
('Đời sống', 'doi-song', 'Tin tức đời sống, xã hội, gia đình', 8);

-- Insert sample tags
INSERT INTO tags (name, slug) VALUES
('Tin nóng', 'tin-nong'),
('Video', 'video'),
('Infographic', 'infographic'),
('Phỏng vấn', 'phong-van'),
('Chuyên sâu', 'chuyen-sau');

COMMENT ON TABLE users IS 'Bảng quản lý người dùng hệ thống';
COMMENT ON TABLE categories IS 'Bảng quản lý danh mục tin tức';
COMMENT ON TABLE articles IS 'Bảng quản lý bài viết';
COMMENT ON TABLE tags IS 'Bảng quản lý thẻ tag';
COMMENT ON TABLE comments IS 'Bảng quản lý bình luận';
COMMENT ON TABLE bookmarks IS 'Bảng quản lý bài viết đã lưu';
COMMENT ON TABLE article_views IS 'Bảng theo dõi lượt xem bài viết';
COMMENT ON TABLE media IS 'Bảng quản lý file media';
COMMENT ON TABLE notifications IS 'Bảng quản lý thông báo';
