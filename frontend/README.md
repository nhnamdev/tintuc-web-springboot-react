# Frontend - React Web Application

Frontend cho website tin tức Dân Trí, xây dựng với React + Vite và kết nối trực tiếp với Supabase.

## 🚀 Tech Stack

- **Framework**: React 18
- **Build Tool**: Vite
- **Styling**: TailwindCSS
- **Routing**: React Router v6
- **Database**: Supabase JS Client
- **HTTP Client**: Axios
- **State Management**: Zustand (optional)

## 📁 Cấu Trúc Project

```
frontend/
├── src/
│   ├── components/         # Reusable components (TODO)
│   ├── pages/             # Page components
│   │   ├── HomePage.jsx
│   │   ├── ArticlePage.jsx
│   │   └── CategoryPage.jsx
│   ├── lib/               # Libraries & utilities
│   │   └── supabase.js    # Supabase client
│   ├── services/          # API services (TODO)
│   ├── hooks/             # Custom hooks (TODO)
│   ├── store/             # State management (TODO)
│   ├── App.jsx            # Main app component
│   ├── main.jsx           # Entry point
│   └── index.css          # Global styles
├── public/                # Static assets
├── index.html
├── vite.config.js
├── tailwind.config.js
├── postcss.config.js
├── package.json
└── .env.example
```

## ⚙️ Cấu Hình

### 1. Environment Variables

Copy `.env.example` thành `.env` và điền thông tin:

```bash
cp .env.example .env
```

File `.env`:
```env
VITE_SUPABASE_URL=https://psxxzstgcmjkvrylagrg.supabase.co
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key_here
VITE_API_URL=http://localhost:8080/api
```

## 🔧 Cài Đặt & Chạy

### Prerequisites
- Node.js 18+ 
- npm hoặc yarn

### Bước 1: Cài đặt dependencies
```bash
cd frontend
npm install
```

### Bước 2: Cấu hình .env
Tạo file `.env` từ `.env.example` và điền Supabase credentials

### Bước 3: Chạy development server
```bash
npm run dev
```

App sẽ chạy tại: `http://localhost:3000`

### Build cho production
```bash
npm run build
```

### Preview production build
```bash
npm run preview
```

## 📦 Dependencies Chính

- **react** & **react-dom** - Core React
- **react-router-dom** - Client-side routing
- **@supabase/supabase-js** - Supabase client
- **axios** - HTTP requests
- **zustand** - State management (lightweight)
- **tailwindcss** - Utility-first CSS

## 🎨 Pages Đã Tạo

### 1. HomePage
- Hiển thị danh sách bài viết mới nhất
- Fetch data từ Supabase
- Grid layout responsive

### 2. ArticlePage (TODO)
- Chi tiết bài viết
- Comments section
- Related articles

### 3. CategoryPage (TODO)
- Danh sách bài viết theo category
- Filter và pagination

## 🔌 Supabase Integration

### Fetch Articles
```javascript
import { supabase } from '../lib/supabase';

const { data, error } = await supabase
  .from('articles')
  .select(`
    *,
    author:users(full_name, avatar_url),
    category:categories(name, slug)
  `)
  .eq('status', 'published')
  .order('published_at', { ascending: false });
```

### Upload Image
```javascript
const { data, error } = await supabase.storage
  .from('articles')
  .upload(`${articleId}/${fileName}`, file);
```

## 📝 TODO

### Components
- [ ] Header/Navigation
- [ ] Footer
- [ ] ArticleCard component
- [ ] CommentList component
- [ ] Sidebar
- [ ] Search bar
- [ ] Category menu

### Pages
- [ ] Complete ArticlePage
- [ ] Complete CategoryPage
- [ ] Login/Register pages
- [ ] Admin dashboard
- [ ] User profile page

### Features
- [ ] Authentication (Supabase Auth)
- [ ] Search functionality
- [ ] Comments system
- [ ] Bookmarks
- [ ] Notifications
- [ ] Dark mode
- [ ] Responsive design
- [ ] SEO optimization

### State Management
- [ ] Setup Zustand store
- [ ] Auth state
- [ ] Articles state
- [ ] UI state

## 🎨 Styling Guidelines

- Sử dụng Tailwind utility classes
- Mobile-first responsive design
- Consistent spacing (4, 8, 16, 24, 32px)
- Color palette: primary (blue), gray scale
- Typography: Inter font family

## 🐛 Troubleshooting

### Lỗi "Missing Supabase environment variables"
→ Kiểm tra file `.env` đã tạo và có đúng VITE_ prefix

### Lỗi CORS khi call API
→ Kiểm tra Vite proxy config trong `vite.config.js`

### Tailwind styles không apply
→ Chạy `npm install` lại và restart dev server

## 📞 Support

Liên hệ team nếu cần hỗ trợ.
