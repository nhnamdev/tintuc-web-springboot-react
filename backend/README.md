# Backend - Spring Boot REST API

Backend API cho website tin tức Dân Trí, xây dựng với Spring Boot và kết nối Supabase PostgreSQL.

## 🚀 Tech Stack

- **Java**: 17+
- **Framework**: Spring Boot 3.2.0
- **Database**: Supabase (PostgreSQL)
- **Security**: Spring Security + JWT
- **ORM**: Spring Data JPA
- **Build Tool**: Maven

## 📁 Cấu Trúc Project

```
backend/
├── src/
│   └── main/
│       └── java/
│           └── com/dantri/
│               ├── DantriApplication.java      # Main application
│               ├── entity/                     # JPA Entities
│               │   ├── User.java
│               │   ├── Category.java
│               │   ├── Article.java
│               │   ├── Tag.java
│               │   └── Comment.java
│               ├── repository/                 # Data repositories
│               │   ├── UserRepository.java
│               │   ├── ArticleRepository.java
│               │   ├── CategoryRepository.java
│               │   └── CommentRepository.java
│               ├── service/                    # Business logic (TODO)
│               ├── controller/                 # REST controllers (TODO)
│               ├── dto/                        # Data Transfer Objects (TODO)
│               ├── config/                     # Configurations (TODO)
│               └── security/                   # Security configs (TODO)
├── pom.xml
└── application.properties
```

## ⚙️ Cấu Hình

### 1. Database Connection

File `application.properties` đã được cấu hình với thông tin Supabase:

```properties
spring.datasource.url=jdbc:postgresql://db.psxxzstgcmjkvrylagrg.supabase.co:5432/postgres
spring.datasource.username=postgres
spring.datasource.password=YOUR_PASSWORD_HERE
```

### 2. Environment Variables

Tạo file `.env` hoặc set environment variables:

```bash
DB_PASSWORD=your_supabase_password
SUPABASE_ANON_KEY=your_supabase_anon_key
JWT_SECRET=your_jwt_secret_key
```

## 🔧 Cài Đặt & Chạy

### Prerequisites
- Java 17 hoặc cao hơn
- Maven 3.6+

### Bước 1: Clone & Navigate
```bash
cd backend
```

### Bước 2: Cập nhật password trong application.properties
Thay `YOUR_PASSWORD_HERE` bằng password Supabase thực tế

### Bước 3: Build project
```bash
mvn clean install
```

### Bước 4: Run application
```bash
mvn spring-boot:run
```

Server sẽ chạy tại: `http://localhost:8080/api`

## 📊 Entities Đã Tạo

### 1. User
- Quản lý người dùng
- Roles: ADMIN, EDITOR, AUTHOR, READER

### 2. Category
- Danh mục tin tức
- Hỗ trợ danh mục con (parent-child)

### 3. Article
- Bài viết
- Status: DRAFT, PUBLISHED, ARCHIVED
- Quan hệ với User (author), Category, Tags

### 4. Tag
- Thẻ tag cho bài viết

### 5. Comment
- Bình luận
- Hỗ trợ reply (parent-child)

## 🔌 API Endpoints (TODO)

Các endpoints sẽ được implement:

### Authentication
- `POST /api/auth/register` - Đăng ký
- `POST /api/auth/login` - Đăng nhập
- `POST /api/auth/logout` - Đăng xuất

### Articles
- `GET /api/articles` - Lấy danh sách bài viết
- `GET /api/articles/{slug}` - Lấy chi tiết bài viết
- `POST /api/articles` - Tạo bài viết mới
- `PUT /api/articles/{id}` - Cập nhật bài viết
- `DELETE /api/articles/{id}` - Xóa bài viết

### Categories
- `GET /api/categories` - Lấy danh sách danh mục
- `GET /api/categories/{slug}` - Lấy chi tiết danh mục

### Comments
- `GET /api/articles/{articleId}/comments` - Lấy comments
- `POST /api/articles/{articleId}/comments` - Tạo comment
- `PUT /api/comments/{id}` - Cập nhật comment
- `DELETE /api/comments/{id}` - Xóa comment

## 📦 Dependencies

- Spring Boot Web
- Spring Boot Data JPA
- Spring Boot Security
- PostgreSQL Driver
- JWT (jjwt)
- Lombok
- MapStruct
- Supabase Java Client

## 🔐 Security

- JWT-based authentication
- Role-based access control (RBAC)
- Password encryption với BCrypt

## 📝 TODO

- [ ] Implement Services layer
- [ ] Implement Controllers
- [ ] Implement DTOs
- [ ] Implement Security configuration
- [ ] Implement JWT utilities
- [ ] Add API documentation (Swagger)
- [ ] Add unit tests
- [ ] Add integration tests

## 🐛 Troubleshooting

### Lỗi kết nối database
→ Kiểm tra password và connection string trong `application.properties`

### Lỗi "Table doesn't exist"
→ Chạy `supabase_schema.sql` trong Supabase Dashboard

### Lỗi Maven dependencies
→ Chạy `mvn clean install -U` để force update dependencies

## 📞 Support

Liên hệ team nếu cần hỗ trợ.
