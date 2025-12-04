import { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import Header from '../components/Header';

function CategoryPage() {
  const { slug } = useParams();
  const [category, setCategory] = useState(null);
  const [articles, setArticles] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchCategoryAndArticles();
  }, [slug]);

  const fetchCategoryAndArticles = async () => {
    try {
      // Fetch category info
      const { data: categoryData, error: categoryError } = await supabase
        .from('categories')
        .select('*')
        .eq('slug', slug)
        .single();

      if (categoryError) throw categoryError;
      setCategory(categoryData);

      // Fetch articles in this category
      const { data: articlesData, error: articlesError } = await supabase
        .from('articles')
        .select(`
          *,
          author:users(full_name, avatar_url),
          category:categories(name, slug)
        `)
        .eq('category_id', categoryData.id)
        .eq('status', 'published')
        .order('published_at', { ascending: false })
        .limit(20);

      if (articlesError) throw articlesError;
      setArticles(articlesData || []);
    } catch (error) {
      console.error('Error fetching category:', error);
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

  if (!category) {
    return (
      <>
        <Header />
        <div className="max-w-7xl mx-auto px-4 py-8">
          <div className="text-center">
            <h1 className="text-2xl font-bold text-gray-900">Không tìm thấy danh mục</h1>
            <p className="text-gray-600 mt-2">Danh mục bạn tìm kiếm không tồn tại.</p>
          </div>
        </div>
      </>
    );
  }

  return (
    <>
      <Header />
      <div className="max-w-7xl mx-auto px-4 py-8">
        {/* Category Header */}
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-gray-900">{category.name}</h1>
          {category.description && (
            <p className="text-gray-600 mt-2">{category.description}</p>
          )}
          <div className="mt-4 text-sm text-gray-500">
            {articles.length} bài viết
          </div>
        </div>

        {/* Articles Grid */}
        {articles.length > 0 ? (
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
                  {article.is_breaking_news && (
                    <span className="inline-block px-2 py-1 text-xs font-semibold text-white bg-red-600 rounded mb-2">
                      🔥 TIN NÓNG
                    </span>
                  )}
                  {article.is_featured && !article.is_breaking_news && (
                    <span className="inline-block px-2 py-1 text-xs font-semibold text-white bg-primary-600 rounded mb-2">
                      ⭐ NỔI BẬT
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
                    <div className="flex items-center gap-2">
                      {article.author?.avatar_url && (
                        <img
                          src={article.author.avatar_url}
                          alt={article.author.full_name}
                          className="w-6 h-6 rounded-full"
                        />
                      )}
                      <span>{article.author?.full_name || 'Anonymous'}</span>
                    </div>
                    <div className="flex items-center gap-3">
                      <span>👁️ {article.view_count}</span>
                      <span>{new Date(article.published_at).toLocaleDateString('vi-VN')}</span>
                    </div>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        ) : (
          <div className="text-center py-12">
            <p className="text-gray-500 text-lg">Chưa có bài viết nào trong danh mục này</p>
          </div>
        )}
      </div>
    </>
  );
}

export default CategoryPage;
