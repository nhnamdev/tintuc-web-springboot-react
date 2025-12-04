-- =====================================================
-- DỮ LIỆU MẪU CHO WEBSITE TIN TỨC DÂN TRÍ
-- Chạy file này SAU KHI đã chạy supabase_schema.sql
-- =====================================================

-- =====================================================
-- 1. INSERT USERS (10 users)
-- =====================================================
INSERT INTO users (id, email, full_name, avatar_url, role, bio, is_active) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'admin@dantri.com', 'Nguyễn Văn Admin', 'https://i.pravatar.cc/150?img=1', 'admin', 'Quản trị viên hệ thống', true),
('b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'editor@dantri.com', 'Trần Thị Biên Tập', 'https://i.pravatar.cc/150?img=2', 'editor', 'Biên tập viên trưởng', true),
('c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'author1@dantri.com', 'Lê Văn Tác Giả', 'https://i.pravatar.cc/150?img=3', 'author', 'Phóng viên chuyên mục Thời sự', true),
('d3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'author2@dantri.com', 'Phạm Thị Minh', 'https://i.pravatar.cc/150?img=4', 'author', 'Phóng viên chuyên mục Công nghệ', true),
('e4eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'author3@dantri.com', 'Hoàng Văn Nam', 'https://i.pravatar.cc/150?img=5', 'author', 'Phóng viên chuyên mục Thể thao', true),
('f5eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 'author4@dantri.com', 'Đặng Thị Hương', 'https://i.pravatar.cc/150?img=6', 'author', 'Phóng viên chuyên mục Giải trí', true),
('a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', 'reader1@gmail.com', 'Nguyễn Văn Độc Giả', 'https://i.pravatar.cc/150?img=7', 'reader', 'Độc giả thường xuyên', true),
('b7eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', 'reader2@gmail.com', 'Trần Thị Mai', 'https://i.pravatar.cc/150?img=8', 'reader', NULL, true),
('c8eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', 'reader3@gmail.com', 'Lê Văn Bình', 'https://i.pravatar.cc/150?img=9', 'reader', NULL, true),
('d9eebc99-9c0b-4ef8-bb6d-6bb9bd380a20', 'reader4@gmail.com', 'Phạm Thị Lan', 'https://i.pravatar.cc/150?img=10', 'reader', NULL, true);

-- =====================================================
-- 2. CATEGORIES đã có trong schema, bổ sung thêm
-- =====================================================
-- Categories đã được insert trong supabase_schema.sql

-- =====================================================
-- 3. TAGS đã có trong schema, bổ sung thêm
-- =====================================================
INSERT INTO tags (name, slug) VALUES
('Nóng', 'nong'),
('Độc quyền', 'doc-quyen'),
('Điểm tin', 'diem-tin'),
('Ảnh', 'anh'),
('Podcast', 'podcast');

-- =====================================================
-- 4. INSERT ARTICLES (20 bài viết)
-- =====================================================
INSERT INTO articles (id, title, slug, summary, content, thumbnail_url, author_id, category_id, status, is_featured, is_breaking_news, published_at, view_count) VALUES
-- Thời sự
('11111111-1111-1111-1111-111111111111', 
'Thủ tướng chủ trì họp Chính phủ thường kỳ tháng 12', 
'thu-tuong-chu-tri-hop-chinh-phu-thuong-ky-thang-12',
'Chiều 4/12, Thủ tướng Phạm Minh Chính chủ trì phiên họp Chính phủ thường kỳ tháng 12/2024.',
'<p>Chiều 4/12, tại trụ sở Chính phủ, Thủ tướng Phạm Minh Chính chủ trì phiên họp Chính phủ thường kỳ tháng 12/2024.</p><p>Tại phiên họp, Chính phủ nghe các Bộ, ngành báo cáo tình hình kinh tế - xã hội tháng 11 và 11 tháng năm 2024; dự báo tình hình tháng 12 và cả năm 2024.</p><p>Chính phủ cũng thảo luận, cho ý kiến về một số vấn đề quan trọng liên quan đến phát triển kinh tế - xã hội, đảm bảo quốc phòng, an ninh.</p>',
'https://images.unsplash.com/photo-1589829545856-d10d557cf95f?w=800',
'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a13',
(SELECT id FROM categories WHERE slug = 'thoi-su'),
'published', true, true, NOW() - INTERVAL '2 hours', 15420),

('22222222-2222-2222-2222-222222222222',
'Việt Nam và Trung Quốc ký kết 6 văn kiện hợp tác',
'viet-nam-va-trung-quoc-ky-ket-6-van-kien-hop-tac',
'Tổng Bí thư Tô Lâm và Tổng Bí thư, Chủ tịch Trung Quốc Tập Cận Bình chứng kiến lễ ký 6 văn kiện hợp tác.',
'<p>Trong khuôn khổ chuyến thăm cấp Nhà nước tới Trung Quốc, chiều 4/12, Tổng Bí thư Tô Lâm và Tổng Bí thư, Chủ tịch Trung Quốc Tập Cận Bình đã chứng kiến lễ ký kết 6 văn kiện hợp tác giữa hai nước.</p><p>Các văn kiện bao gồm: Biên bản ghi nhớ về hợp tác trong lĩnh vực năng lượng, Thỏa thuận hợp tác về phát triển bền vững, và các văn kiện khác.</p>',
'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a13',
(SELECT id FROM categories WHERE slug = 'thoi-su'),
'published', true, false, NOW() - INTERVAL '5 hours', 8930),

-- Công nghệ
('33333333-3333-3333-3333-333333333333',
'ChatGPT ra mắt tính năng tìm kiếm web mới',
'chatgpt-ra-mat-tinh-nang-tim-kiem-web-moi',
'OpenAI vừa công bố tính năng tìm kiếm web mới cho ChatGPT, cạnh tranh trực tiếp với Google.',
'<p>OpenAI đã chính thức ra mắt tính năng tìm kiếm web cho ChatGPT, cho phép người dùng tìm kiếm thông tin trực tuyến ngay trong giao diện chat.</p><p>Tính năng này sử dụng mô hình AI tiên tiến để tổng hợp thông tin từ nhiều nguồn đáng tin cậy, cung cấp câu trả lời chính xác và cập nhật.</p><p>Đây được xem là bước đi quan trọng của OpenAI trong việc cạnh tranh với Google Search.</p>',
'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800',
'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14',
(SELECT id FROM categories WHERE slug = 'cong-nghe'),
'published', true, false, NOW() - INTERVAL '1 day', 12450),

('44444444-4444-4444-4444-444444444444',
'Apple ra mắt MacBook Pro M4 với hiệu năng vượt trội',
'apple-ra-mat-macbook-pro-m4-voi-hieu-nang-vuot-troi',
'MacBook Pro 2024 với chip M4 mới nhất của Apple hứa hẹn mang đến hiệu năng xử lý và đồ họa vượt trội.',
'<p>Apple đã chính thức giới thiệu dòng MacBook Pro 2024 trang bị chip M4, M4 Pro và M4 Max mới nhất.</p><p>Theo Apple, chip M4 mang lại hiệu năng CPU nhanh hơn 50% và GPU nhanh hơn 40% so với thế hệ M3.</p><p>MacBook Pro M4 cũng được trang bị màn hình Liquid Retina XDR với độ sáng cao hơn, thời lượng pin lên đến 24 giờ.</p>',
'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800',
'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14',
(SELECT id FROM categories WHERE slug = 'cong-nghe'),
'published', false, false, NOW() - INTERVAL '2 days', 9870),

-- Thể thao
('55555555-5555-5555-5555-555555555555',
'Đội tuyển Việt Nam thắng Thái Lan 2-1 tại AFF Cup',
'doi-tuyen-viet-nam-thang-thai-lan-2-1-tai-aff-cup',
'Đội tuyển Việt Nam đã có chiến thắng ấn tượng 2-1 trước Thái Lan trong trận đấu tại AFF Cup 2024.',
'<p>Tối 4/12, đội tuyển Việt Nam đã có trận đấu xuất sắc trước Thái Lan tại vòng bảng AFF Cup 2024.</p><p>Hai bàn thắng của Việt Nam được ghi bởi Nguyễn Tiến Linh (phút 23) và Phan Văn Đức (phút 67).</p><p>Chiến thắng này giúp Việt Nam vững vàng ngôi đầu bảng với 9 điểm sau 3 trận.</p>',
'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800',
'e4eebc99-9c0b-4ef8-bb6d-6bb9bd380a15',
(SELECT id FROM categories WHERE slug = 'the-thao'),
'published', true, true, NOW() - INTERVAL '3 hours', 25680),

('66666666-6666-6666-6666-666666666666',
'Ronaldo lập hat-trick giúp Al Nassr thắng đậm',
'ronaldo-lap-hat-trick-giup-al-nassr-thang-dam',
'Cristiano Ronaldo tiếp tục tỏa sáng với hat-trick trong chiến thắng 5-0 của Al Nassr.',
'<p>Cristiano Ronaldo đã có màn trình diễn xuất sắc với hat-trick trong trận đấu giữa Al Nassr và Al Adalah tại Saudi Pro League.</p><p>Ba bàn thắng của Ronaldo được ghi ở phút 12, 34 và 78, giúp Al Nassr giành chiến thắng đậm 5-0.</p><p>Đây là hat-trick thứ 3 của Ronaldo trong mùa giải này.</p>',
'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=800',
'e4eebc99-9c0b-4ef8-bb6d-6bb9bd380a15',
(SELECT id FROM categories WHERE slug = 'the-thao'),
'published', false, false, NOW() - INTERVAL '1 day', 18920),

-- Giải trí
('77777777-7777-7777-7777-777777777777',
'Sơn Tùng M-TP ra mắt MV mới sau 2 năm vắng bóng',
'son-tung-m-tp-ra-mat-mv-moi-sau-2-nam-vang-bong',
'Ca sĩ Sơn Tùng M-TP chính thức trở lại với MV mới sau 2 năm vắng bóng khỏi showbiz.',
'<p>Sau 2 năm vắng bóng, Sơn Tùng M-TP đã chính thức trở lại với MV "Making My Way" vào 0h ngày 4/12.</p><p>MV được đầu tư hoành tráng với kinh phí lên đến 10 tỷ đồng, quay tại nhiều địa điểm nổi tiếng.</p><p>Chỉ sau 6 giờ ra mắt, MV đã đạt 5 triệu lượt xem trên YouTube.</p>',
'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800',
'f5eebc99-9c0b-4ef8-bb6d-6bb9bd380a16',
(SELECT id FROM categories WHERE slug = 'giai-tri'),
'published', true, false, NOW() - INTERVAL '6 hours', 32150),

('88888888-8888-8888-8888-888888888888',
'Phim "Mai" của Trấn Thành thu về 500 tỷ đồng',
'phim-mai-cua-tran-thanh-thu-ve-500-ty-dong',
'Bộ phim "Mai" do Trấn Thành đạo diễn đã chính thức cán mốc doanh thu 500 tỷ đồng.',
'<p>Sau 30 ngày công chiếu, bộ phim "Mai" của đạo diễn Trấn Thành đã chính thức cán mốc doanh thu 500 tỷ đồng.</p><p>Đây là bộ phim Việt Nam có doanh thu cao nhất mọi thời đại, vượt qua cả "Lật mặt 6".</p><p>Phim kể về câu chuyện cảm động của một người phụ nữ tên Mai và hành trình tìm lại chính mình.</p>',
'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800',
'f5eebc99-9c0b-4ef8-bb6d-6bb9bd380a16',
(SELECT id FROM categories WHERE slug = 'giai-tri'),
'published', false, false, NOW() - INTERVAL '12 hours', 14560),

-- Kinh doanh
('99999999-9999-9999-9999-999999999999',
'VN-Index tăng điểm mạnh, vượt mốc 1.300',
'vn-index-tang-diem-manh-vuot-moc-1300',
'Thị trường chứng khoán Việt Nam ghi nhận phiên tăng điểm mạnh với VN-Index vượt mốc 1.300 điểm.',
'<p>Phiên giao dịch ngày 4/12, VN-Index tăng 15,6 điểm (+1,21%), lên 1.304,8 điểm.</p><p>Thanh khoản đạt gần 20.000 tỷ đồng, cho thấy dòng tiền đang quay trở lại thị trường.</p><p>Các cổ phiếu ngân hàng và bất động sản dẫn dắt đà tăng của thị trường.</p>',
'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=800',
'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a13',
(SELECT id FROM categories WHERE slug = 'kinh-doanh'),
'published', false, false, NOW() - INTERVAL '4 hours', 7890),

('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
'Giá vàng trong nước tăng vọt lên 82 triệu đồng/lượng',
'gia-vang-trong-nuoc-tang-vot-len-82-trieu-dong-luong',
'Giá vàng SJC tăng mạnh, lên mức 82 triệu đồng/lượng trong phiên giao dịch sáng nay.',
'<p>Sáng 4/12, giá vàng SJC tăng 500.000 đồng/lượng so với hôm qua, lên 82 triệu đồng/lượng.</p><p>Giá vàng nhẫn 9999 cũng tăng theo, hiện ở mức 80,5 triệu đồng/lượng.</p><p>Nguyên nhân được cho là do giá vàng thế giới tăng mạnh và USD suy yếu.</p>',
'https://images.unsplash.com/photo-1610375461246-83df859d849d?w=800',
'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a13',
(SELECT id FROM categories WHERE slug = 'kinh-doanh'),
'published', false, false, NOW() - INTERVAL '8 hours', 11230),

-- Giáo dục
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
'Bộ GD&ĐT công bố phương án thi tốt nghiệp THPT 2025',
'bo-gd-dt-cong-bo-phuong-an-thi-tot-nghiep-thpt-2025',
'Bộ Giáo dục và Đào tạo vừa công bố phương án tổ chức kỳ thi tốt nghiệp THPT năm 2025.',
'<p>Bộ GD&ĐT cho biết kỳ thi tốt nghiệp THPT 2025 sẽ được tổ chức vào ngày 26-27/6/2025.</p><p>Thí sinh sẽ thi 4 môn, trong đó có 3 môn bắt buộc và 1 môn tự chọn.</p><p>Đề thi sẽ có độ khó phù hợp, đảm bảo phân loại được học sinh.</p>',
'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800',
'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14',
(SELECT id FROM categories WHERE slug = 'giao-duc'),
'published', false, false, NOW() - INTERVAL '1 day', 6540),

-- Sức khỏe
('cccccccc-cccc-cccc-cccc-cccccccccccc',
'Phát hiện thuốc mới điều trị ung thư hiệu quả',
'phat-hien-thuoc-moi-dieu-tri-ung-thu-hieu-qua',
'Các nhà khoa học Việt Nam vừa phát hiện loại thuốc mới có khả năng điều trị ung thư hiệu quả.',
'<p>Nhóm nghiên cứu tại Viện Hàn lâm Khoa học Việt Nam đã phát hiện hợp chất mới có khả năng tiêu diệt tế bào ung thư.</p><p>Thử nghiệm trên chuột cho kết quả khả quan, khối u giảm 70% sau 3 tháng điều trị.</p><p>Nghiên cứu đang được tiếp tục để chuẩn bị cho thử nghiệm lâm sàng.</p>',
'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800',
'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14',
(SELECT id FROM categories WHERE slug = 'suc-khoe'),
'published', true, false, NOW() - INTERVAL '10 hours', 9870),

-- Đời sống
('dddddddd-dddd-dddd-dddd-dddddddddddd',
'Hà Nội chuẩn bị đón đợt rét đậm, rét hại',
'ha-noi-chuan-bi-don-dot-ret-dam-ret-hai',
'Từ ngày 5/12, Hà Nội và các tỉnh miền Bắc sẽ đón đợt rét đậm, rét hại đầu tiên trong mùa đông này.',
'<p>Theo Trung tâm Dự báo Khí tượng Thủy văn Quốc gia, từ ngày 5/12, không khí lạnh tăng cường mạnh.</p><p>Nhiệt độ tại Hà Nội có thể xuống thấp nhất 8-10 độ C, vùng núi cao dưới 5 độ C.</p><p>Người dân cần chú ý giữ ấm cơ thể, đặc biệt là người cao tuổi và trẻ em.</p>',
'https://images.unsplash.com/photo-1476362555312-ab9e108a0b7e?w=800',
'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a13',
(SELECT id FROM categories WHERE slug = 'doi-song'),
'published', false, false, NOW() - INTERVAL '5 hours', 5430),

-- Thêm các bài draft và archived
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
'Bài viết đang soạn thảo về AI',
'bai-viet-dang-soan-thao-ve-ai',
'Đây là bài viết đang trong quá trình soạn thảo về trí tuệ nhân tạo.',
'<p>Nội dung đang được hoàn thiện...</p>',
NULL,
'd3eebc99-9c0b-4ef8-bb6d-6bb9bd380a14',
(SELECT id FROM categories WHERE slug = 'cong-nghe'),
'draft', false, false, NULL, 0),

('ffffffff-ffff-ffff-ffff-ffffffffffff',
'Bài viết cũ đã lưu trữ',
'bai-viet-cu-da-luu-tru',
'Bài viết này đã được lưu trữ.',
'<p>Nội dung bài viết cũ...</p>',
'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800',
'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a13',
(SELECT id FROM categories WHERE slug = 'thoi-su'),
'archived', false, false, NOW() - INTERVAL '6 months', 1200);

-- =====================================================
-- 5. INSERT ARTICLE_TAGS (Gắn tag cho bài viết)
-- =====================================================
INSERT INTO article_tags (article_id, tag_id) VALUES
-- Bài 1: Thủ tướng họp
('11111111-1111-1111-1111-111111111111', (SELECT id FROM tags WHERE slug = 'tin-nong')),
('11111111-1111-1111-1111-111111111111', (SELECT id FROM tags WHERE slug = 'nong')),

-- Bài 2: Việt Nam - Trung Quốc
('22222222-2222-2222-2222-222222222222', (SELECT id FROM tags WHERE slug = 'tin-nong')),
('22222222-2222-2222-2222-222222222222', (SELECT id FROM tags WHERE slug = 'diem-tin')),

-- Bài 3: ChatGPT
('33333333-3333-3333-3333-333333333333', (SELECT id FROM tags WHERE slug = 'nong')),
('33333333-3333-3333-3333-333333333333', (SELECT id FROM tags WHERE slug = 'chuyen-sau')),

-- Bài 4: MacBook Pro M4
('44444444-4444-4444-4444-444444444444', (SELECT id FROM tags WHERE slug = 'chuyen-sau')),

-- Bài 5: Đội tuyển Việt Nam
('55555555-5555-5555-5555-555555555555', (SELECT id FROM tags WHERE slug = 'tin-nong')),
('55555555-5555-5555-5555-555555555555', (SELECT id FROM tags WHERE slug = 'nong')),
('55555555-5555-5555-5555-555555555555', (SELECT id FROM tags WHERE slug = 'video')),

-- Bài 6: Ronaldo
('66666666-6666-6666-6666-666666666666', (SELECT id FROM tags WHERE slug = 'video')),

-- Bài 7: Sơn Tùng
('77777777-7777-7777-7777-777777777777', (SELECT id FROM tags WHERE slug = 'tin-nong')),
('77777777-7777-7777-7777-777777777777', (SELECT id FROM tags WHERE slug = 'video')),
('77777777-7777-7777-7777-777777777777', (SELECT id FROM tags WHERE slug = 'doc-quyen')),

-- Bài 8: Phim Mai
('88888888-8888-8888-8888-888888888888', (SELECT id FROM tags WHERE slug = 'chuyen-sau')),

-- Bài 9: VN-Index
('99999999-9999-9999-9999-999999999999', (SELECT id FROM tags WHERE slug = 'diem-tin')),

-- Bài 10: Giá vàng
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', (SELECT id FROM tags WHERE slug = 'nong')),

-- Bài 11: Thi THPT
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', (SELECT id FROM tags WHERE slug = 'diem-tin')),

-- Bài 12: Thuốc ung thư
('cccccccc-cccc-cccc-cccc-cccccccccccc', (SELECT id FROM tags WHERE slug = 'nong')),
('cccccccc-cccc-cccc-cccc-cccccccccccc', (SELECT id FROM tags WHERE slug = 'chuyen-sau')),

-- Bài 13: Rét đậm
('dddddddd-dddd-dddd-dddd-dddddddddddd', (SELECT id FROM tags WHERE slug = 'diem-tin'));

-- =====================================================
-- 6. INSERT COMMENTS (30 comments)
-- =====================================================
INSERT INTO comments (id, article_id, user_id, parent_id, content, is_approved) VALUES
-- Comments cho bài Đội tuyển Việt Nam
('c0000001-0000-0000-0000-000000000001', '55555555-5555-5555-5555-555555555555', 'a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', NULL, 'Chiến thắng xứng đáng! Chúc mừng đội tuyển Việt Nam! 🇻🇳', true),
('c0000002-0000-0000-0000-000000000002', '55555555-5555-5555-5555-555555555555', 'b7eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', NULL, 'Tiến Linh và Văn Đức chơi quá hay!', true),
('c0000003-0000-0000-0000-000000000003', '55555555-5555-5555-5555-555555555555', 'c8eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', 'c0000001-0000-0000-0000-000000000001', 'Đúng vậy, các cầu thủ đã cố gắng hết mình!', true),

-- Comments cho bài Sơn Tùng
('c0000004-0000-0000-0000-000000000004', '77777777-7777-7777-7777-777777777777', 'd9eebc99-9c0b-4ef8-bb6d-6bb9bd380a20', NULL, 'MV đỉnh quá! Xứng đáng chờ đợi 2 năm 😍', true),
('c0000005-0000-0000-0000-000000000005', '77777777-7777-7777-7777-777777777777', 'a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', NULL, 'Hình ảnh đẹp, âm nhạc hay, Sơn Tùng không làm fan thất vọng!', true),
('c0000006-0000-0000-0000-000000000006', '77777777-7777-7777-7777-777777777777', 'b7eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', 'c0000004-0000-0000-0000-000000000004', 'Mình cũng nghĩ vậy, MV này quá chất lượng!', true),

-- Comments cho bài ChatGPT
('c0000007-0000-0000-0000-000000000007', '33333333-3333-3333-3333-333333333333', 'c8eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', NULL, 'Tính năng này sẽ thay đổi cách chúng ta tìm kiếm thông tin', true),
('c0000008-0000-0000-0000-000000000008', '33333333-3333-3333-3333-333333333333', 'd9eebc99-9c0b-4ef8-bb6d-6bb9bd380a20', NULL, 'Google cần phải cẩn thận rồi đây', true),

-- Comments cho bài Phim Mai
('c0000009-0000-0000-0000-000000000009', '88888888-8888-8888-8888-888888888888', 'a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', NULL, 'Phim hay, diễn xuất tốt, xứng đáng với doanh thu cao', true),
('c0000010-0000-0000-0000-000000000010', '88888888-8888-8888-8888-888888888888', 'b7eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', NULL, 'Xem xong khóc nức nở luôn 😭', true),

-- Comments chưa được duyệt
('c0000011-0000-0000-0000-000000000011', '55555555-5555-5555-5555-555555555555', 'c8eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', NULL, 'Comment đang chờ duyệt', false);

-- =====================================================
-- 7. INSERT BOOKMARKS (Người dùng lưu bài viết)
-- =====================================================
INSERT INTO bookmarks (user_id, article_id) VALUES
('a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', '55555555-5555-5555-5555-555555555555'),
('a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', '77777777-7777-7777-7777-777777777777'),
('a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', '33333333-3333-3333-3333-333333333333'),
('b7eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', '55555555-5555-5555-5555-555555555555'),
('b7eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', '88888888-8888-8888-8888-888888888888'),
('c8eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', '77777777-7777-7777-7777-777777777777'),
('d9eebc99-9c0b-4ef8-bb6d-6bb9bd380a20', '33333333-3333-3333-3333-333333333333');

-- =====================================================
-- 8. INSERT ARTICLE_VIEWS (Lượt xem chi tiết)
-- =====================================================
INSERT INTO article_views (article_id, user_id, ip_address, user_agent, viewed_at) VALUES
-- Views cho bài Đội tuyển Việt Nam
('55555555-5555-5555-5555-555555555555', 'a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', '192.168.1.100', 'Mozilla/5.0', NOW() - INTERVAL '2 hours'),
('55555555-5555-5555-5555-555555555555', 'b7eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', '192.168.1.101', 'Chrome/120.0', NOW() - INTERVAL '1 hour'),
('55555555-5555-5555-5555-555555555555', NULL, '192.168.1.102', 'Safari/17.0', NOW() - INTERVAL '30 minutes'),

-- Views cho bài Sơn Tùng
('77777777-7777-7777-7777-777777777777', 'c8eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', '192.168.1.103', 'Firefox/120.0', NOW() - INTERVAL '5 hours'),
('77777777-7777-7777-7777-777777777777', 'd9eebc99-9c0b-4ef8-bb6d-6bb9bd380a20', '192.168.1.104', 'Edge/120.0', NOW() - INTERVAL '4 hours'),

-- Views cho bài ChatGPT
('33333333-3333-3333-3333-333333333333', 'a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', '192.168.1.105', 'Chrome/120.0', NOW() - INTERVAL '1 day');

-- =====================================================
-- 9. INSERT MEDIA (Hình ảnh/video trong bài viết)
-- =====================================================
INSERT INTO media (article_id, file_url, file_type, file_size, caption, order_index) VALUES
('55555555-5555-5555-5555-555555555555', 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=1200', 'image', 245678, 'Đội tuyển Việt Nam ăn mừng bàn thắng', 1),
('55555555-5555-5555-5555-555555555555', 'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=1200', 'image', 198234, 'Cầu thủ Tiến Linh ghi bàn', 2),

('77777777-7777-7777-7777-777777777777', 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=1200', 'image', 312456, 'Hậu trường quay MV', 1),

('33333333-3333-3333-3333-333333333333', 'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=1200', 'image', 187654, 'Giao diện ChatGPT mới', 1);

-- =====================================================
-- 10. INSERT NOTIFICATIONS (Thông báo)
-- =====================================================
INSERT INTO notifications (user_id, type, title, message, link, is_read) VALUES
-- Thông báo cho tác giả khi có comment
('e4eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'comment', 'Bình luận mới', 'Nguyễn Văn Độc Giả đã bình luận về bài viết "Đội tuyển Việt Nam thắng Thái Lan 2-1 tại AFF Cup"', '/articles/55555555-5555-5555-5555-555555555555', false),

('f5eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 'comment', 'Bình luận mới', 'Phạm Thị Lan đã bình luận về bài viết "Sơn Tùng M-TP ra mắt MV mới sau 2 năm vắng bóng"', '/articles/77777777-7777-7777-7777-777777777777', false),

-- Thông báo reply
('a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', 'reply', 'Phản hồi mới', 'Lê Văn Bình đã phản hồi bình luận của bạn', '/articles/55555555-5555-5555-5555-555555555555', true),

-- Thông báo hệ thống
('a6eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', 'system', 'Chào mừng', 'Chào mừng bạn đến với Dân Trí!', '/', true),
('b7eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', 'system', 'Chào mừng', 'Chào mừng bạn đến với Dân Trí!', '/', true);

-- =====================================================
-- HOÀN TẤT
-- =====================================================
-- Tổng cộng đã insert:
-- - 10 users
-- - 8 categories (đã có trong schema)
-- - 10 tags (5 đã có + 5 mới)
-- - 15 articles (13 published + 1 draft + 1 archived)
-- - 25+ article_tags
-- - 11 comments (10 approved + 1 pending)
-- - 7 bookmarks
-- - 6 article_views
-- - 4 media files
-- - 5 notifications
