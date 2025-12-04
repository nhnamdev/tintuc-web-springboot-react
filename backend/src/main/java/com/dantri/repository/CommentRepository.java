package com.dantri.repository;

import com.dantri.entity.Comment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

/**
 * Repository cho Comment entity
 */
@Repository
public interface CommentRepository extends JpaRepository<Comment, UUID> {
    
    Page<Comment> findByArticleIdAndIsApprovedTrue(UUID articleId, Pageable pageable);
    
    List<Comment> findByArticleIdAndParentIdIsNullAndIsApprovedTrue(UUID articleId);
    
    List<Comment> findByParentIdAndIsApprovedTrue(UUID parentId);
    
    long countByArticleIdAndIsApprovedTrue(UUID articleId);
}
