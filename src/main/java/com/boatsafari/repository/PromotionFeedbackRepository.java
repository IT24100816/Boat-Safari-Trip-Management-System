package com.boatsafari.repository;

import com.boatsafari.model.PromotionFeedback;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PromotionFeedbackRepository extends JpaRepository<PromotionFeedback, Long> {

    List<PromotionFeedback> findByPromotionId(Long promotionId);

    // New method to fetch feedbacks with tourist information
    @Query("SELECT pf FROM PromotionFeedback pf JOIN FETCH pf.tourist t JOIN FETCH pf.promotion p ORDER BY pf.createdAt DESC")
    List<PromotionFeedback> findAllWithTourist();
}