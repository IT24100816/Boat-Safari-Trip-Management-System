package com.boatsafari.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "trip_booking")
public class Booking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "trip_id")
    private Long tripId;

    @Column(name = "trip_name")
    private String tripName;

    @Column(name = "user_id")
    private Long userId;

    @Column(name = "username")
    private String username;

    @Column(name = "nic")
    private String nic;

    @Column(name = "booking_date")
    private LocalDate bookingDate;

    @Column(name = "hours")
    private int hours;

    @Column(name = "passengers")
    private int passengers;

    @Column(name = "total_amount")
    private double totalAmount;

    @Column(name = "payment_slip_url")
    private String paymentSlipUrl;

    @Column(name = "booking_status")
    private String bookingStatus;

    @Column(name = "boat_driver_id")
    private Long boatDriverId;

    @Column(name = "boat_driver_name")
    private String boatDriverName;

    @Column(name = "boat_id")
    private Long boatId;

    @Column(name = "created_at")
    private LocalDate createdAt = LocalDate.now();

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getTripId() { return tripId; }
    public void setTripId(Long tripId) { this.tripId = tripId; }
    public String getTripName() { return tripName; }
    public void setTripName(String tripName) { this.tripName = tripName; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getNic() { return nic; }
    public void setNic(String nic) { this.nic = nic; }
    public LocalDate getBookingDate() { return bookingDate; }
    public void setBookingDate(LocalDate bookingDate) { this.bookingDate = bookingDate; }
    public int getHours() { return hours; }
    public void setHours(int hours) { this.hours = hours; }
    public int getPassengers() { return passengers; }
    public void setPassengers(int passengers) { this.passengers = passengers; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public String getPaymentSlipUrl() { return paymentSlipUrl; }
    public void setPaymentSlipUrl(String paymentSlipUrl) { this.paymentSlipUrl = paymentSlipUrl; }
    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }
    public Long getBoatDriverId() { return boatDriverId; }
    public void setBoatDriverId(Long boatDriverId) { this.boatDriverId = boatDriverId; }
    public String getBoatDriverName() { return boatDriverName; }
    public void setBoatDriverName(String boatDriverName) { this.boatDriverName = boatDriverName; }
    public Long getBoatId() { return boatId; }
    public void setBoatId(Long boatId) { this.boatId = boatId; }
    public LocalDate getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDate createdAt) { this.createdAt = createdAt; }
}