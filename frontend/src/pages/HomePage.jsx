import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import Header from '../components/Header';

function HomePage() {
  const [articles, setArticles] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchArticles();
  }, []);

  const fetchArticles = async () => {
    try {
      const { data, error } = await supabase
        .from('articles')
        .select(`
          *,
          author:users(full_name, avatar_url),
          category:categories(name, slug)
        `)
        .eq('status', 'published')
        .order('published_at', { ascending: false })
        .limit(10);

      if (error) throw error;
      setArticles(data || []);
    } catch (error) {
      console.error('Error fetching articles:', error);
    } finally {
      setLoading(false);
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
        <header className="mb-8">
          <h1 className="text-4xl font-bold text-gray-900">Dân Trí</h1>
          <p className="text-gray-600 mt-2">Tin tức 24h - Cập nhật liên tục</p>
        </header>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {articles.map((article) => (
            <Link
              key={article.id}
              to={`/article/${article.slug}`}
              className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow block"
            >
              {article.thumbnail_url && (
                <img
                  src={article.thumbnail_url}
                  alt={article.title}
                  className="w-full h-48 object-cover"
                />
              )}
              <div className="p-4">
                {article.category && (
                  <span className="text-sm text-primary-600 font-semibold">
                    {article.category.name}
                  </span>
                )}
                <h2 className="text-xl font-bold mt-2 mb-2 line-clamp-2 hover:text-primary-600">
                  {article.title}
                </h2>
                {article.summary && (
                  <p className="text-gray-600 text-sm line-clamp-3">
                    {article.summary}
                  </p>
                )}
                <div className="mt-4 flex items-center justify-between text-sm text-gray-500">
                  <span>{article.author?.full_name || 'Anonymous'}</span>
                  <span>{new Date(article.published_at).toLocaleDateString('vi-VN')}</span>
                </div>
              </div>
            </Link>
          ))}
        </div>

        {articles.length === 0 && (
          <div className="text-center py-12">
            <p className="text-gray-500 text-lg">Chưa có bài viết nào</p>
          </div>
        )}
      </div>
    </>
  );
}

export default HomePage;
