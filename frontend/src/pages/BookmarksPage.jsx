import { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import Header from '../components/Header';

function BookmarksPage() {
  const navigate = useNavigate();
  const [user, setUser] = useState(null);
  const [bookmarks, setBookmarks] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    checkUserAndFetchBookmarks();
  }, []);

  const checkUserAndFetchBookmarks = async () => {
    try {
      const { data: { session } } = await supabase.auth.getSession();
      
      if (!session) {
        navigate('/login');
        return;
      }

      setUser(session.user);

      // Fetch bookmarks with article details
      const { data, error } = await supabase
        .from('bookmarks')
        .select(`
          id,
          created_at,
          article:articles(
            id,
            title,
            slug,
            summary,
            thumbnail_url,
            published_at,
            view_count,
            author:users(full_name, avatar_url),
            category:categories(name, slug)
          )
        `)
        .eq('user_id', session.user.id)
        .order('created_at', { ascending: false });

      if (error) throw error;
      setBookmarks(data || []);
    } catch (error) {
      console.error('Error fetching bookmarks:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleRemoveBookmark = async (bookmarkId, articleTitle) => {
    if (!confirm(`Bỏ lưu bài viết "${articleTitle}"?`)) return;

    try {
      const { error } = await supabase
        .from('bookmarks')
        .delete()
        .eq('id', bookmarkId);

      if (error) throw error;

      // Remove from state
      setBookmarks(bookmarks.filter(b => b.id !== bookmarkId));
      alert('Đã bỏ lưu bài viết!');
    } catch (error) {
      console.error('Error removing bookmark:', error);
      alert('Có lỗi xảy ra khi bỏ lưu bài viết');
    }
  };

  if (loading) {
    return (
      <>
        <Header />
        <div className="flex items-center justify-center min-h-screen">
          <div className="text-xl">Đang tải...</div>
        </div>
      </>
    );
  }

  return (
    <>
      <Header />
      <div className="max-w-7xl mx-auto px-4 py-8">
        {/* Page Header */}
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-gray-900">Bài viết đã lưu</h1>
          <p className="text-gray-600 mt-2">
            {bookmarks.length} bài viết
          </p>
        </div>

        {/* Bookmarks List */}
        {bookmarks.length > 0 ? (
          <div className="space-y-6">
            {bookmarks.map((bookmark) => (
              <div
                key={bookmark.id}
                className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow"
              >
                <div className="flex flex-col md:flex-row">
                  {/* Thumbnail */}
                  {bookmark.article.thumbnail_url && (
                    <Link
                      to={`/article/${bookmark.article.slug}`}
                      className="md:w-64 h-48 md:h-auto flex-shrink-0"
                    >
                      <img
                        src={bookmark.article.thumbnail_url}
                        alt={bookmark.article.title}
                        className="w-full h-full object-cover"
                      />
                    </Link>
                  )}

                  {/* Content */}
                  <div className="flex-1 p-6">
                    <div className="flex items-start justify-between">
                      <div className="flex-1">
                        {/* Category */}
                        {bookmark.article.category && (
                          <Link
                            to={`/category/${bookmark.article.category.slug}`}
                            className="text-sm text-primary-600 font-semibold hover:text-primary-700"
                          >
                            {bookmark.article.category.name}
                          </Link>
                        )}

                        {/* Title */}
                        <Link to={`/article/${bookmark.article.slug}`}>
                          <h2 className="text-2xl font-bold mt-2 mb-2 hover:text-primary-600 line-clamp-2">
                            {bookmark.article.title}
                          </h2>
                        </Link>

                        {/* Summary */}
                        {bookmark.article.summary && (
                          <p className="text-gray-600 line-clamp-2 mb-4">
                            {bookmark.article.summary}
                          </p>
                        )}

                        {/* Meta */}
                        <div className="flex items-center gap-4 text-sm text-gray-500">
                          <div className="flex items-center gap-2">
                            {bookmark.article.author?.avatar_url && (
                              <img
                                src={bookmark.article.author.avatar_url}
                                alt={bookmark.article.author.full_name}
                                className="w-6 h-6 rounded-full"
                              />
                            )}
                            <span>{bookmark.article.author?.full_name || 'Anonymous'}</span>
                          </div>
                          <span>•</span>
                          <span>{new Date(bookmark.article.published_at).toLocaleDateString('vi-VN')}</span>
                          <span>•</span>
                          <span>👁️ {bookmark.article.view_count}</span>
                        </div>

                        {/* Saved Date */}
                        <div className="mt-3 text-xs text-gray-400">
                          Đã lưu: {new Date(bookmark.created_at).toLocaleDateString('vi-VN', {
                            year: 'numeric',
                            month: 'long',
                            day: 'numeric',
                            hour: '2-digit',
                            minute: '2-digit',
                          })}
                        </div>
                      </div>

                      {/* Remove Button */}
                      <button
                        onClick={() => handleRemoveBookmark(bookmark.id, bookmark.article.title)}
                        className="ml-4 p-2 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                        title="Bỏ lưu"
                      >
                        <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                        </svg>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        ) : (
          /* Empty State */
          <div className="text-center py-16">
            <div className="text-6xl mb-4">🔖</div>
            <h2 className="text-2xl font-bold text-gray-900 mb-2">
              Chưa có bài viết nào được lưu
            </h2>
            <p className="text-gray-600 mb-6">
              Lưu các bài viết yêu thích để đọc lại sau
            </p>
            <Link
              to="/"
              className="inline-block px-6 py-3 bg-primary-600 text-white rounded-lg hover:bg-primary-700 font-medium"
            >
              Khám phá bài viết
            </Link>
          </div>
        )}
      </div>
    </>
  );
}

export default BookmarksPage;
