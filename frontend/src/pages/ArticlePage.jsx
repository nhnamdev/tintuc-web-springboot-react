import { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import Header from '../components/Header';

function ArticlePage() {
  const { slug } = useParams();
  const [article, setArticle] = useState(null);
  const [relatedArticles, setRelatedArticles] = useState([]);
  const [comments, setComments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [user, setUser] = useState(null);
  const [newComment, setNewComment] = useState('');
  const [isBookmarked, setIsBookmarked] = useState(false);

  useEffect(() => {
    // Check current user
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null);
    });

    fetchArticle();
  }, [slug]);

  const fetchArticle = async () => {
    try {
      // Fetch article
      const { data: articleData, error: articleError } = await supabase
        .from('articles')
        .select(`
          *,
          author:users(id, full_name, avatar_url, bio),
          category:categories(name, slug),
          tags:article_tags(tag:tags(name, slug))
        `)
        .eq('slug', slug)
        .single();

      if (articleError) throw articleError;
      setArticle(articleData);

      // Record view
      await supabase.from('article_views').insert({
        article_id: articleData.id,
        user_id: user?.id || null,
      });

      // Fetch related articles
      const { data: relatedData } = await supabase
        .from('articles')
        .select('id, title, slug, thumbnail_url, published_at')
        .eq('category_id', articleData.category_id)
        .eq('status', 'published')
        .neq('id', articleData.id)
        .limit(5);

      setRelatedArticles(relatedData || []);

      // Fetch comments
      const { data: commentsData } = await supabase
        .from('comments')
        .select(`
          *,
          user:users(full_name, avatar_url)
        `)
        .eq('article_id', articleData.id)
        .eq('is_approved', true)
        .is('parent_id', null)
        .order('created_at', { ascending: false });

      setComments(commentsData || []);

      // Check if bookmarked
      if (user) {
        const { data: bookmarkData } = await supabase
          .from('bookmarks')
          .select('id')
          .eq('user_id', user.id)
          .eq('article_id', articleData.id)
          .single();

        setIsBookmarked(!!bookmarkData);
      }
    } catch (error) {
      console.error('Error fetching article:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleBookmark = async () => {
    if (!user) {
      alert('Vui lòng đăng nhập để lưu bài viết');
      return;
    }

    try {
      if (isBookmarked) {
        await supabase
          .from('bookmarks')
          .delete()
          .eq('user_id', user.id)
          .eq('article_id', article.id);
        setIsBookmarked(false);
      } else {
        await supabase.from('bookmarks').insert({
          user_id: user.id,
          article_id: article.id,
        });
        setIsBookmarked(true);
      }
    } catch (error) {
      console.error('Error toggling bookmark:', error);
    }
  };

  const handleSubmitComment = async (e) => {
    e.preventDefault();
    if (!user) {
      alert('Vui lòng đăng nhập để bình luận');
      return;
    }

    if (!newComment.trim()) return;

    try {
      const { data, error } = await supabase
        .from('comments')
        .insert({
          article_id: article.id,
          user_id: user.id,
          content: newComment,
        })
        .select(`
          *,
          user:users(full_name, avatar_url)
        `)
        .single();

      if (error) throw error;

      setComments([data, ...comments]);
      setNewComment('');
      alert('Bình luận của bạn đang chờ duyệt');
    } catch (error) {
      console.error('Error submitting comment:', error);
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

  if (!article) {
    return (
      <>
        <Header />
        <div className="max-w-4xl mx-auto px-4 py-8">
          <div className="text-center">
            <h1 className="text-2xl font-bold text-gray-900">Không tìm thấy bài viết</h1>
            <p className="text-gray-600 mt-2">Bài viết bạn tìm kiếm không tồn tại.</p>
            <Link to="/" className="text-primary-600 hover:text-primary-700 mt-4 inline-block">
              ← Quay lại trang chủ
            </Link>
          </div>
        </div>
      </>
    );
  }

  return (
    <>
      <Header />
      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Main Content */}
          <div className="lg:col-span-2">
            <article className="bg-white rounded-lg shadow-md p-8">
              {/* Breadcrumb */}
              <div className="text-sm text-gray-500 mb-4">
                <Link to="/" className="hover:text-primary-600">Trang chủ</Link>
                <span className="mx-2">›</span>
                <Link to={`/category/${article.category.slug}`} className="hover:text-primary-600">
                  {article.category.name}
                </Link>
              </div>

              {/* Title */}
              <h1 className="text-4xl font-bold text-gray-900 mb-4">
                {article.title}
              </h1>

              {/* Meta */}
              <div className="flex items-center gap-4 mb-6 pb-6 border-b">
                <img
                  src={article.author.avatar_url || 'https://i.pravatar.cc/40'}
                  alt={article.author.full_name}
                  className="w-12 h-12 rounded-full"
                />
                <div className="flex-1">
                  <div className="font-semibold text-gray-900">{article.author.full_name}</div>
                  <div className="text-sm text-gray-500">
                    {new Date(article.published_at).toLocaleDateString('vi-VN', {
                      weekday: 'long',
                      year: 'numeric',
                      month: 'long',
                      day: 'numeric',
                      hour: '2-digit',
                      minute: '2-digit',
                    })}
                  </div>
                </div>
                <div className="flex items-center gap-4">
                  <button
                    onClick={handleBookmark}
                    className={`flex items-center gap-2 px-4 py-2 rounded-lg border ${
                      isBookmarked
                        ? 'bg-primary-50 border-primary-600 text-primary-600'
                        : 'border-gray-300 text-gray-600 hover:bg-gray-50'
                    }`}
                  >
                    <span>{isBookmarked ? '🔖' : '📑'}</span>
                    <span>{isBookmarked ? 'Đã lưu' : 'Lưu'}</span>
                  </button>
                  <div className="text-sm text-gray-500">
                    👁️ {article.view_count + 1}
                  </div>
                </div>
              </div>

              {/* Summary */}
              {article.summary && (
                <div className="text-lg text-gray-700 font-semibold mb-6 p-4 bg-gray-50 rounded-lg border-l-4 border-primary-600">
                  {article.summary}
                </div>
              )}

              {/* Thumbnail */}
              {article.thumbnail_url && (
                <img
                  src={article.thumbnail_url}
                  alt={article.title}
                  className="w-full rounded-lg mb-6"
                />
              )}

              {/* Content */}
              <div
                className="prose prose-lg max-w-none mb-8"
                dangerouslySetInnerHTML={{ __html: article.content }}
              />

              {/* Tags */}
              {article.tags && article.tags.length > 0 && (
                <div className="flex flex-wrap gap-2 mb-6">
                  {article.tags.map((item) => (
                    <Link
                      key={item.tag.slug}
                      to={`/tag/${item.tag.slug}`}
                      className="px-3 py-1 bg-gray-100 text-gray-700 rounded-full text-sm hover:bg-primary-100 hover:text-primary-700"
                    >
                      #{item.tag.name}
                    </Link>
                  ))}
                </div>
              )}

              {/* Author Bio */}
              {article.author.bio && (
                <div className="bg-gray-50 rounded-lg p-6 mb-8">
                  <div className="flex items-start gap-4">
                    <img
                      src={article.author.avatar_url || 'https://i.pravatar.cc/60'}
                      alt={article.author.full_name}
                      className="w-16 h-16 rounded-full"
                    />
                    <div>
                      <div className="font-semibold text-lg mb-1">{article.author.full_name}</div>
                      <div className="text-gray-600 text-sm">{article.author.bio}</div>
                    </div>
                  </div>
                </div>
              )}

              {/* Comments Section */}
              <div className="border-t pt-8">
                <h2 className="text-2xl font-bold mb-6">
                  Bình luận ({comments.length})
                </h2>

                {/* Comment Form */}
                {user ? (
                  <form onSubmit={handleSubmitComment} className="mb-8">
                    <textarea
                      value={newComment}
                      onChange={(e) => setNewComment(e.target.value)}
                      placeholder="Viết bình luận của bạn..."
                      className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 resize-none"
                      rows="4"
                    />
                    <div className="mt-2 flex justify-end">
                      <button
                        type="submit"
                        className="px-6 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700"
                      >
                        Gửi bình luận
                      </button>
                    </div>
                  </form>
                ) : (
                  <div className="mb-8 p-4 bg-gray-50 rounded-lg text-center">
                    <Link to="/login" className="text-primary-600 hover:text-primary-700">
                      Đăng nhập
                    </Link>
                    <span className="text-gray-600"> để bình luận</span>
                  </div>
                )}

                {/* Comments List */}
                <div className="space-y-6">
                  {comments.map((comment) => (
                    <div key={comment.id} className="flex gap-4">
                      <img
                        src={comment.user.avatar_url || 'https://i.pravatar.cc/40'}
                        alt={comment.user.full_name}
                        className="w-10 h-10 rounded-full"
                      />
                      <div className="flex-1">
                        <div className="bg-gray-50 rounded-lg p-4">
                          <div className="font-semibold text-gray-900 mb-1">
                            {comment.user.full_name}
                          </div>
                          <div className="text-gray-700">{comment.content}</div>
                        </div>
                        <div className="text-sm text-gray-500 mt-2">
                          {new Date(comment.created_at).toLocaleDateString('vi-VN', {
                            year: 'numeric',
                            month: 'long',
                            day: 'numeric',
                            hour: '2-digit',
                            minute: '2-digit',
                          })}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </article>
          </div>

          {/* Sidebar */}
          <div className="lg:col-span-1">
            {/* Related Articles */}
            {relatedArticles.length > 0 && (
              <div className="bg-white rounded-lg shadow-md p-6 sticky top-24">
                <h3 className="text-xl font-bold mb-4">Bài viết liên quan</h3>
                <div className="space-y-4">
                  {relatedArticles.map((related) => (
                    <Link
                      key={related.id}
                      to={`/article/${related.slug}`}
                      className="flex gap-3 group"
                    >
                      {related.thumbnail_url && (
                        <img
                          src={related.thumbnail_url}
                          alt={related.title}
                          className="w-20 h-20 object-cover rounded"
                        />
                      )}
                      <div className="flex-1">
                        <h4 className="font-semibold text-sm line-clamp-2 group-hover:text-primary-600">
                          {related.title}
                        </h4>
                        <p className="text-xs text-gray-500 mt-1">
                          {new Date(related.published_at).toLocaleDateString('vi-VN')}
                        </p>
                      </div>
                    </Link>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </>
  );
}

export default ArticlePage;
