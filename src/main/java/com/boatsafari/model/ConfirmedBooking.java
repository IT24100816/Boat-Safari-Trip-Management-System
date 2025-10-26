package com.boatsafari.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "confirmed_booking")
public class ConfirmedBooking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "booking_id")
    private Booking booking;

    @ManyToOne
    @JoinColumn(name = "boat_id")
    private Boat boat;

    @ManyToOne
    @JoinColumn(name = "driver_id")
    private BoatDriver boatDriver;

    private String touristName;
    private String touristNic;
    private int passengers;
    private int hours;
    private double totalAmount;
    private LocalDate bookingDate;
    private LocalDate completedDate;
    private String driverName;
    private String driverLicenseNumber;
    private String driverPhone;
    private String boatName;
    private String boatRegistrationNumber;
    private int boatCapacity;

    private Long tripId;
    private String tripName;

    // Constructors
    public ConfirmedBooking() {}

    public ConfirmedBooking(AssignedBooking assignment) {
        this.booking = assignment.getBooking();
        this.boat = assignment.getBoat();
        this.boatDriver = assignment.getBoatDriver();
        this.touristName = assignment.getTouristName();
        this.touristNic = assignment.getTouristNic();
        this.passengers = assignment.getPassengers();
        this.hours = assignment.getHours();
        this.totalAmount = assignment.getTotalAmount();
        this.bookingDate = assignment.getBookingDate();
        this.completedDate = LocalDate.now();
        this.driverName = assignment.getDriverName();
        this.driverLicenseNumber = assignment.getDriverLicenseNumber();
        this.driverPhone = assignment.getDriverPhone();
        this.boatName = assignment.getBoatName();
        this.boatRegistrationNumber = assignment.getBoatRegistrationNumber();
        this.boatCapacity = assignment.getBoatCapacity();
        this.tripId = assignment.getTripId();
        this.tripName = assignment.getTripName();
    }

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Booking getBooking() { return booking; }
    public void setBooking(Booking booking) { this.booking = booking; }

    public Boat getBoat() { return boat; }
    public void setBoat(Boat boat) { this.boat = boat; }

    public BoatDriver getBoatDriver() { return boatDriver; }
    public void setBoatDriver(BoatDriver boatDriver) { this.boatDriver = boatDriver; }

    public String getTouristName() { return touristName; }
    public void setTouristName(String touristName) { this.touristName = touristName; }

    public String getTouristNic() { return touristNic; }
    public void setTouristNic(String touristNic) { this.touristNic = touristNic; }

    public int getPassengers() { return passengers; }
    public void setPassengers(int passengers) { this.passengers = passengers; }

    public int getHours() { return hours; }
    public void setHours(int hours) { this.hours = hours; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public LocalDate getBookingDate() { return bookingDate; }
    public void setBookingDate(LocalDate bookingDate) { this.bookingDate = bookingDate; }

    public LocalDate getCompletedDate() { return completedDate; }
    public void setCompletedDate(LocalDate completedDate) { this.completedDate = completedDate; }

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

    public int getBoatCapacity() { return boatCapacity; }
    public void setBoatCapacity(int boatCapacity) { this.boatCapacity = boatCapacity; }

    public Long getTripId() { return tripId; }
    public void setTripId(Long tripId) { this.tripId = tripId; }

    public String getTripName() { return tripName; }
    public void setTripName(String tripName) { this.tripName = tripName; }
}