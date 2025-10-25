package com.boatsafari.repository;

import com.boatsafari.model.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {
    List<Booking> findByBookingStatus(String status);

    // Find bookings by boat driver ID and status
    @Query("SELECT b FROM Booking b WHERE b.boatDriverId = :driverId AND b.bookingStatus = :status")
    List<Booking> findByBoatDriverIdAndBookingStatus(@Param("driverId") Long driverId, @Param("status") String status);

    // Find pending bookings that are not assigned to any driver
    @Query("SELECT b FROM Booking b WHERE b.bookingStatus = 'Pending'")
    List<Booking> findPendingBookings();

    List<Booking> findByUsername(String username);
}