package com.boatsafari.repository;

import com.boatsafari.model.AssignedBooking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface AssignedBookingRepository extends JpaRepository<AssignedBooking, Long> {
    @Query("SELECT ab FROM AssignedBooking ab WHERE ab.booking.id = :bookingId")
    Optional<AssignedBooking> findByBookingId(@Param("bookingId") Long bookingId);

    List<AssignedBooking> findAll();

    @Modifying
    @Transactional
    @Query(value = "DELETE FROM assign_booking WHERE id = :id", nativeQuery = true)
    void deleteAssignmentById(@Param("id") Long id);

    List<AssignedBooking> findByTouristNicAndStatus(String touristNic, String status);
    void deleteByBoatDriverId(Long boatDriverId);
}