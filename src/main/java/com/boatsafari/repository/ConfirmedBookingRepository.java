package com.boatsafari.repository;

import com.boatsafari.model.ConfirmedBooking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ConfirmedBookingRepository extends JpaRepository<ConfirmedBooking, Long> {
    List<ConfirmedBooking> findByTouristNic(String touristNic);

    List<ConfirmedBooking> findByTouristName(String touristName);
}