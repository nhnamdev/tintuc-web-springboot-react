import { Link } from 'react-router-dom';
import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';

function Header() {
  const [user, setUser] = useState(null);
  const [categories, setCategories] = useState([]);
  const [showUserMenu, setShowUserMenu] = useState(false);
  const [showNotifications, setShowNotifications] = useState(false);
  const [notifications, setNotifications] = useState([]);
  const [unreadCount, setUnreadCount] = useState(0);

  useEffect(() => {
    // Check current user
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null);
      if (session?.user) {
        fetchNotifications(session.user.id);
      }
    });

    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null);
      if (session?.user) {
        fetchNotifications(session.user.id);
      } else {
        setNotifications([]);
        setUnreadCount(0);
      }
    });

    // Fetch categories
    fetchCategories();

    return () => subscription.unsubscribe();
  }, []);

  const fetchCategories = async () => {
    const { data, error } = await supabase
      .from('categories')
      .select('*')
      .eq('is_active', true)
      .order('order_index', { ascending: true });

    if (!error) {
      setCategories(data || []);
    }
  };

  const fetchNotifications = async (userId) => {
    try {
      const { data, error } = await supabase
        .from('notifications')
        .select('*')
        .eq('user_id', userId)
        .order('created_at', { ascending: false })
        .limit(10);

      if (!error && data) {
        setNotifications(data);
        setUnreadCount(data.filter(n => !n.is_read).length);
      }
    } catch (error) {
      console.error('Error fetching notifications:', error);
    }
  };

  const handleMarkAsRead = async (notificationId) => {
    try {
      const { error } = await supabase
        .from('notifications')
        .update({ is_read: true })
        .eq('id', notificationId);

      if (!error && user) {
        fetchNotifications(user.id);
      }
    } catch (error) {
      console.error('Error marking notification as read:', error);
    }
  };

  const handleMarkAllAsRead = async () => {
    if (!user) return;

    try {
      const { error } = await supabase
        .from('notifications')
        .update({ is_read: true })
        .eq('user_id', user.id)
        .eq('is_read', false);

      if (!error) {
        fetchNotifications(user.id);
      }
    } catch (error) {
      console.error('Error marking all as read:', error);
    }
  };

  const handleSignOut = async () => {
    await supabase.auth.signOut();
    setShowUserMenu(false);
  };

  return (
    <header className="bg-white shadow-md sticky top-0 z-50">
      {/* Top Bar */}
      <div className="bg-primary-700 text-white">
        <div className="max-w-7xl mx-auto px-4 py-2 flex justify-between items-center text-sm">
          <div className="flex items-center gap-4">
            <span>📅 {new Date().toLocaleDateString('vi-VN', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}</span>
          </div>
          <div className="flex items-center gap-4">
            {user ? (
              <div className="relative">
                <button
                  onClick={() => setShowUserMenu(!showUserMenu)}
                  className="flex items-center gap-2 hover:text-primary-200"
                >
                  <img
                    src={user.user_metadata?.avatar_url || 'https://i.pravatar.cc/40'}
                    alt="Avatar"
                    className="w-6 h-6 rounded-full"
                  />
                  <span>{user.user_metadata?.full_name || user.email}</span>
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                  </svg>
                </button>

                {showUserMenu && (
                  <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-2 text-gray-800">
                    <Link
                      to="/profile"
                      className="block px-4 py-2 hover:bg-gray-100"
                      onClick={() => setShowUserMenu(false)}
                    >
                      👤 Trang cá nhân
                    </Link>
                    <Link
                      to="/bookmarks"
                      className="block px-4 py-2 hover:bg-gray-100"
                      onClick={() => setShowUserMenu(false)}
                    >
                      🔖 Bài viết đã lưu
                    </Link>
                    <button
                      onClick={handleSignOut}
                      className="block w-full text-left px-4 py-2 hover:bg-gray-100 text-red-600"
                    >
                      🚪 Đăng xuất
                    </button>
                  </div>
                )}
              </div>
            ) : (
              <Link to="/login" className="hover:text-primary-200">
                🔐 Đăng nhập
              </Link>
            )}
          </div>
        </div>
      </div>

      {/* Main Header */}
      <div className="max-w-7xl mx-auto px-4 py-4">
        <div className="flex items-center justify-between">
          {/* Logo */}
          <Link to="/" className="flex items-center gap-2">
            <div className="text-3xl font-bold text-primary-700">
              Dân Trí
            </div>
          </Link>

          {/* Search */}
          <div className="flex-1 max-w-xl mx-8">
            <div className="relative">
              <input
                type="text"
                placeholder="Tìm kiếm tin tức..."
                className="w-full px-4 py-2 pr-10 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
              />
              <button className="absolute right-2 top-1/2 -translate-y-1/2 text-gray-400 hover:text-primary-600">
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
              </button>
            </div>
          </div>

          {/* Actions */}
          <div className="flex items-center gap-4">
            {/* Notifications */}
            {user && (
              <div className="relative">
                <button
                  onClick={() => setShowNotifications(!showNotifications)}
                  className="relative text-gray-600 hover:text-primary-600"
                >
                  <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                  </svg>
                  {unreadCount > 0 && (
                    <span className="absolute -top-1 -right-1 bg-red-600 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
                      {unreadCount > 9 ? '9+' : unreadCount}
                    </span>
                  )}
                </button>

                {showNotifications && (
                  <div className="absolute right-0 mt-2 w-96 bg-white rounded-lg shadow-lg py-2 text-gray-800 max-h-96 overflow-y-auto z-50">
                    <div className="px-4 py-2 border-b flex items-center justify-between">
                      <h3 className="font-semibold">Thông báo</h3>
                      {unreadCount > 0 && (
                        <button
                          onClick={handleMarkAllAsRead}
                          className="text-xs text-primary-600 hover:text-primary-700"
                        >
                          Đánh dấu tất cả đã đọc
                        </button>
                      )}
                    </div>

                    {notifications.length > 0 ? (
                      <div>
                        {notifications.map((notification) => (
                          <div
                            key={notification.id}
                            className={`px-4 py-3 hover:bg-gray-50 cursor-pointer border-b ${
                              !notification.is_read ? 'bg-blue-50' : ''
                            }`}
                            onClick={() => {
                              handleMarkAsRead(notification.id);
                              if (notification.link) {
                                window.location.href = notification.link;
                              }
                            }}
                          >
                            <div className="flex items-start gap-3">
                              <div className="flex-shrink-0 mt-1">
                                {notification.type === 'comment' && '💬'}
                                {notification.type === 'reply' && '↩️'}
                                {notification.type === 'article_published' && '📝'}
                                {notification.type === 'system' && '🔔'}
                              </div>
                              <div className="flex-1 min-w-0">
                                <p className="font-semibold text-sm">{notification.title}</p>
                                {notification.message && (
                                  <p className="text-sm text-gray-600 line-clamp-2">
                                    {notification.message}
                                  </p>
                                )}
                                <p className="text-xs text-gray-400 mt-1">
                                  {new Date(notification.created_at).toLocaleDateString('vi-VN', {
                                    month: 'short',
                                    day: 'numeric',
                                    hour: '2-digit',
                                    minute: '2-digit',
                                  })}
                                </p>
                              </div>
                              {!notification.is_read && (
                                <div className="flex-shrink-0">
                                  <div className="w-2 h-2 bg-blue-600 rounded-full"></div>
                                </div>
                              )}
                            </div>
                          </div>
                        ))}
                      </div>
                    ) : (
                      <div className="px-4 py-8 text-center text-gray-500">
                        <div className="text-4xl mb-2">🔔</div>
                        <p>Chưa có thông báo nào</p>
                      </div>
                    )}
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Navigation - Categories */}
      <nav className="bg-gray-50 border-t border-gray-200">
        <div className="max-w-7xl mx-auto px-4">
          <div className="flex items-center gap-1 overflow-x-auto py-2">
            <Link
              to="/"
              className="px-4 py-2 text-sm font-medium text-gray-700 hover:text-primary-600 hover:bg-white rounded-lg whitespace-nowrap transition-colors"
            >
              🏠 Trang chủ
            </Link>
            {categories.map((category) => (
              <Link
                key={category.id}
                to={`/category/${category.slug}`}
                className="px-4 py-2 text-sm font-medium text-gray-700 hover:text-primary-600 hover:bg-white rounded-lg whitespace-nowrap transition-colors"
              >
                {category.name}
              </Link>
            ))}
          </div>
        </div>
      </nav>
    </header>
  );
}

export default Header;
