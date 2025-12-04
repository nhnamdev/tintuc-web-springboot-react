import { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import Header from '../components/Header';

function ProfilePage() {
  const navigate = useNavigate();
  const [user, setUser] = useState(null);
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);
  const [editing, setEditing] = useState(false);
  const [formData, setFormData] = useState({
    full_name: '',
    bio: '',
    avatar_url: '',
  });

  useEffect(() => {
    checkUser();
  }, []);

  const checkUser = async () => {
    try {
      const { data: { session } } = await supabase.auth.getSession();
      
      if (!session) {
        navigate('/login');
        return;
      }

      setUser(session.user);

      // Fetch user profile from database
      let { data: profileData, error } = await supabase
        .from('users')
        .select('*')
        .eq('email', session.user.email)
        .single();

      // If user doesn't exist in database, create it
      if (error && error.code === 'PGRST116') {
        const { data: newUser, error: createError } = await supabase
          .from('users')
          .insert({
            email: session.user.email,
            full_name: session.user.user_metadata?.full_name || session.user.email.split('@')[0],
            avatar_url: session.user.user_metadata?.avatar_url || null,
            role: 'reader',
            is_active: true,
          })
          .select()
          .single();

        if (createError) {
          console.error('Error creating user:', createError);
        } else {
          profileData = newUser;
        }
      }

      if (profileData) {
        setProfile(profileData);
        setFormData({
          full_name: profileData.full_name || '',
          bio: profileData.bio || '',
          avatar_url: profileData.avatar_url || '',
        });
      }
    } catch (error) {
      console.error('Error fetching profile:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleUpdateProfile = async (e) => {
    e.preventDefault();
    setLoading(true);

    try {
      const { error } = await supabase
        .from('users')
        .update({
          full_name: formData.full_name,
          bio: formData.bio,
          avatar_url: formData.avatar_url,
        })
        .eq('id', profile.id);

      if (error) throw error;

      alert('Cập nhật thông tin thành công!');
      setEditing(false);
      checkUser();
    } catch (error) {
      console.error('Error updating profile:', error);
      alert('Có lỗi xảy ra khi cập nhật thông tin');
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
      <div className="max-w-4xl mx-auto px-4 py-8">
        <div className="bg-white rounded-lg shadow-md overflow-hidden">
          {/* Cover Image */}
          <div className="h-48 bg-gradient-to-r from-primary-500 to-primary-700"></div>

          {/* Profile Content */}
          <div className="px-8 pb-8">
            {/* Avatar */}
            <div className="relative -mt-16 mb-4">
              <img
                src={profile?.avatar_url || user?.user_metadata?.avatar_url || 'https://i.pravatar.cc/150'}
                alt="Avatar"
                className="w-32 h-32 rounded-full border-4 border-white shadow-lg"
              />
            </div>

            {/* User Info */}
            {!editing ? (
              <div>
                <div className="flex items-center justify-between mb-4">
                  <div>
                    <h1 className="text-3xl font-bold text-gray-900">
                      {profile?.full_name || user?.email}
                    </h1>
                    <p className="text-gray-600">{user?.email}</p>
                    <div className="mt-2 flex items-center gap-2">
                      <span className={`px-3 py-1 rounded-full text-sm font-medium ${
                        profile?.role === 'admin' ? 'bg-red-100 text-red-700' :
                        profile?.role === 'editor' ? 'bg-blue-100 text-blue-700' :
                        profile?.role === 'author' ? 'bg-green-100 text-green-700' :
                        'bg-gray-100 text-gray-700'
                      }`}>
                        {profile?.role === 'admin' ? '👑 Admin' :
                         profile?.role === 'editor' ? '✏️ Biên tập viên' :
                         profile?.role === 'author' ? '📝 Tác giả' :
                         '👤 Độc giả'}
                      </span>
                    </div>
                  </div>
                  <button
                    onClick={() => setEditing(true)}
                    className="px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700"
                  >
                    ✏️ Chỉnh sửa
                  </button>
                </div>

                {profile?.bio && (
                  <div className="mb-6">
                    <h2 className="text-lg font-semibold mb-2">Giới thiệu</h2>
                    <p className="text-gray-700">{profile.bio}</p>
                  </div>
                )}

                <div className="grid grid-cols-2 gap-4 mb-6">
                  <div className="bg-gray-50 p-4 rounded-lg">
                    <div className="text-sm text-gray-600">Ngày tham gia</div>
                    <div className="text-lg font-semibold">
                      {new Date(profile?.created_at || user?.created_at).toLocaleDateString('vi-VN')}
                    </div>
                  </div>
                  <div className="bg-gray-50 p-4 rounded-lg">
                    <div className="text-sm text-gray-600">Trạng thái</div>
                    <div className="text-lg font-semibold">
                      {profile?.is_active ? '✅ Hoạt động' : '❌ Không hoạt động'}
                    </div>
                  </div>
                </div>

                {/* Quick Links */}
                <div className="border-t pt-6">
                  <h2 className="text-lg font-semibold mb-4">Liên kết nhanh</h2>
                  <div className="grid grid-cols-2 gap-4">
                    <Link
                      to="/bookmarks"
                      className="flex items-center gap-3 p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors"
                    >
                      <span className="text-2xl">🔖</span>
                      <div>
                        <div className="font-semibold">Bài viết đã lưu</div>
                        <div className="text-sm text-gray-600">Xem các bài viết yêu thích</div>
                      </div>
                    </Link>
                    {(profile?.role === 'author' || profile?.role === 'editor' || profile?.role === 'admin') && (
                      <Link
                        to="/my-articles"
                        className="flex items-center gap-3 p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors"
                      >
                        <span className="text-2xl">📝</span>
                        <div>
                          <div className="font-semibold">Bài viết của tôi</div>
                          <div className="text-sm text-gray-600">Quản lý bài viết</div>
                        </div>
                      </Link>
                    )}
                  </div>
                </div>
              </div>
            ) : (
              /* Edit Form */
              <form onSubmit={handleUpdateProfile} className="space-y-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Họ và tên
                  </label>
                  <input
                    type="text"
                    value={formData.full_name}
                    onChange={(e) => setFormData({ ...formData, full_name: e.target.value })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                    placeholder="Nhập họ và tên"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Giới thiệu
                  </label>
                  <textarea
                    value={formData.bio}
                    onChange={(e) => setFormData({ ...formData, bio: e.target.value })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 resize-none"
                    rows="4"
                    placeholder="Viết vài dòng về bản thân..."
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    URL Avatar
                  </label>
                  <input
                    type="url"
                    value={formData.avatar_url}
                    onChange={(e) => setFormData({ ...formData, avatar_url: e.target.value })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                    placeholder="https://example.com/avatar.jpg"
                  />
                </div>

                <div className="flex gap-4">
                  <button
                    type="submit"
                    disabled={loading}
                    className="flex-1 bg-primary-600 text-white py-2 px-4 rounded-lg hover:bg-primary-700 disabled:opacity-50"
                  >
                    {loading ? 'Đang lưu...' : '💾 Lưu thay đổi'}
                  </button>
                  <button
                    type="button"
                    onClick={() => setEditing(false)}
                    className="flex-1 bg-gray-200 text-gray-700 py-2 px-4 rounded-lg hover:bg-gray-300"
                  >
                    ❌ Hủy
                  </button>
                </div>
              </form>
            )}
          </div>
        </div>
      </div>
    </>
  );
}

export default ProfilePage;
