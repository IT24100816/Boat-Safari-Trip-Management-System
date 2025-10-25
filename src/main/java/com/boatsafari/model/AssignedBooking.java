package com.boatsafari.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "assign_booking")
public class AssignedBooking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "booking_id", nullable = false)
    private Booking booking;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "boat_id", nullable = false)
    private Boat boat;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "boat_driver_id", nullable = false)
    private BoatDriver boatDriver;

    @Column(name = "driver_id", nullable = false)
    private Long driverId;

    @Column(nullable = false)
    private String status;

    @Column(name = "tourist_id")
    private Long touristId;

    @Column(name = "tourist_name")
    private String touristName;

    @Column(name = "tourist_nic")
    private String touristNic;

    @Column(name = "passengers")
    private Integer passengers;

    @Column(name = "hours")
    private Integer hours;

    @Column(name = "total_amount")
    private Double totalAmount;

    @Column(name = "booking_date")
    private LocalDate bookingDate;

    @Column(name = "assigned_date", nullable = false)
    private LocalDate assignedDate;

    @Column(name = "driver_name")
    private String driverName;

    @Column(name = "driver_license_number")
    private String driverLicenseNumber;

    @Column(name = "driver_phone")
    private String driverPhone;

    @Column(name = "boat_name")
    private String boatName;

    @Column(name = "boat_registration_number")
    private String boatRegistrationNumber;

    @Column(name = "boat_capacity")
    private Integer boatCapacity;

    @Column(name = "trip_id")
    private Long tripId;

    @Column(name = "trip_name")
    private String tripName;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Booking getBooking() { return booking; }
    public void setBooking(Booking booking) { this.booking = booking; }

    public Boat getBoat() { return boat; }
    public void setBoat(Boat boat) { this.boat = boat; }

    public BoatDriver getBoatDriver() { return boatDriver; }
    public void setBoatDriver(BoatDriver boatDriver) { this.boatDriver = boatDriver; }

    public Long getDriverId() { return driverId; }
    public void setDriverId(Long driverId) { this.driverId = driverId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Long getTouristId() { return touristId; }
    public void setTouristId(Long touristId) { this.touristId = touristId; }

    public String getTouristName() { return touristName; }
    public void setTouristName(String touristName) { this.touristName = touristName; }

    public String getTouristNic() { return touristNic; }
    public void setTouristNic(String touristNic) { this.touristNic = touristNic; }

    public Integer getPassengers() { return passengers; }
    public void setPassengers(Integer passengers) { this.passengers = passengers; }

    public Integer getHours() { return hours; }
    public void setHours(Integer hours) { this.hours = hours; }

    public Double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(Double totalAmount) { this.totalAmount = totalAmount; }

    public LocalDate getBookingDate() { return bookingDate; }
    public void setBookingDate(LocalDate bookingDate) { this.bookingDate = bookingDate; }

    public LocalDate getAssignedDate() { return assignedDate; }
    public void setAssignedDate(LocalDate assignedDate) { this.assignedDate = assignedDate; }

    public String getDriverName() { return driverName; }
    public void setDriverName(String driverName) { this.driverName = driverName; }

    public String getDriverLicenseNumber() { return driverLicenseNumber; }
    public void setDriverLicenseNumber(String driverLicenseNumber) { this.driverLicenseNumber = driverLicenseNumber; }

    public String getDriverPhone() { return driverPhone; }
    public void setDriverPhone(String driverPhone) { this.driverPhone = driverPhone; }

    public String getBoatName() { return boatName; }
    public void setBoatName(String boatName) { this.boatName = boatName; }

    public String getBoatRegistrationNumber() { return boatRegistrationNumber; }
    public void setBoatRegistrationNumber(String boatRegistrationNumber) { this.boatRegistrationNumber = boatRegistrationNumber; }

    public Integer getBoatCapacity() { return boatCapacity; }
    public void setBoatCapacity(Integer boatCapacity) { this.boatCapacity = boatCapacity; }

    public Long getTripId() { return tripId; }
    public void setTripId(Long tripId) { this.tripId = tripId; }

    public String getTripName() { return tripName; }
    public void setTripName(String tripName) { this.tripName = tripName; }

    public void setBoatId(Long boatId) {
    }
}