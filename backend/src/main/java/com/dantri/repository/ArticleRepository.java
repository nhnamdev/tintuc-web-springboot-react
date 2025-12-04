package com.dantri.repository;

import com.dantri.entity.Article;
import com.dantri.entity.Article.ArticleStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

/**
 * Repository cho Article entity
 */
@Repository
public interface ArticleRepository extends JpaRepository<Article, UUID> {
    
    Optional<Article> findBySlug(String slug);
    
    Page<Article> findByStatus(ArticleStatus status, Pageable pageable);
    
    Page<Article> findByCategoryIdAndStatus(UUID categoryId, ArticleStatus status, Pageable pageable);
    
    Page<Article> findByAuthorIdAndStatus(UUID authorId, ArticleStatus status, Pageable pageable);
    
    @Query("SELECT a FROM Article a WHERE a.status = :status AND a.isFeatured = true ORDER BY a.publishedAt DESC")
    Page<Article> findFeaturedArticles(@Param("status") ArticleStatus status, Pageable pageable);
    
    @Query("SELECT a FROM Article a WHERE a.status = :status AND a.isBreakingNews = true ORDER BY a.publishedAt DESC")
    Page<Article> findBreakingNews(@Param("status") ArticleStatus status, Pageable pageable);
    
    @Query("SELECT a FROM Article a WHERE a.status = :status ORDER BY a.viewCount DESC")
    Page<Article> findTrendingArticles(@Param("status") ArticleStatus status, Pageable pageable);
    
    @Query("SELECT a FROM Article a WHERE a.status = 'PUBLISHED' AND " +
           "(LOWER(a.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(a.content) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<Article> searchArticles(@Param("keyword") String keyword, Pageable pageable);
}
