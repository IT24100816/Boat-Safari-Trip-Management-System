package com.boatsafari.repository;

import com.boatsafari.model.TourGuide;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TourGuideRepository extends JpaRepository<TourGuide, Long> {
    TourGuide findByEmail(String email);
}