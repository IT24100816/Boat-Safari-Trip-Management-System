package com.boatsafari.repository;

import com.boatsafari.model.Promotion;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PromotionRepository extends JpaRepository<Promotion, Long> {
    Promotion findByTripId(Long tripId);
}