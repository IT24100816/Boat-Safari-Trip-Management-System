package com.boatsafari.repository;

import com.boatsafari.model.Review;
import com.boatsafari.model.TourGuide;
import com.boatsafari.model.Trip;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findByTourGuideAndTrip(TourGuide tourGuide, Trip trip);
    List<Review> findByTrip(Trip trip);
}