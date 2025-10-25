package com.boatsafari.repository;

import com.boatsafari.model.Boat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BoatRepository extends JpaRepository<Boat, Long> {
    List<Boat> findByDriverId(Long driverId);
    Optional<Boat> findByRegistrationNumber(String registrationNumber);

    @Query("SELECT b FROM Boat b WHERE b.driverId = :driverId AND b.status = :status")
    List<Boat> findByDriverIdAndStatus(@Param("driverId") Long driverId, @Param("status") String status);

    Boat findByBoatName(String boatName);

    @Modifying
    @Query("UPDATE ConfirmedBooking cb SET cb.boat = NULL WHERE cb.boat.id = :boatId")
    void nullifyBoatIdInConfirmedBookings(@Param("boatId") Long boatId);

    @Modifying
    @Query("UPDATE AssignedBooking ab SET ab.boat = NULL WHERE ab.boat.id = :boatId")
    void nullifyBoatIdInAssignBookings(@Param("boatId") Long boatId);
}