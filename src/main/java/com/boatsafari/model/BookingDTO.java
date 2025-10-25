package com.boatsafari.model;

import java.time.ZoneId;
import java.util.Date;

public class BookingDTO {
    private Long id;
    private String tripName;
    private String username;
    private String nic;
    private Date bookingDate;
    private int hours;
    private int passengers;
    private double totalAmount;
    private String paymentSlipUrl;
    private String bookingStatus;
    private String boatDriverName;

    public BookingDTO(Booking booking) {
        this.id = booking.getId();
        this.tripName = booking.getTripName();
        this.username = booking.getUsername();
        this.nic = booking.getNic();
        this.bookingDate = booking.getBookingDate() != null ? Date.from(booking.getBookingDate().atStartOfDay(ZoneId.systemDefault()).toInstant()) : null;
        this.hours = booking.getHours();
        this.passengers = booking.getPassengers();
        this.totalAmount = booking.getTotalAmount();
        this.paymentSlipUrl = booking.getPaymentSlipUrl();
        this.bookingStatus = booking.getBookingStatus();
        this.boatDriverName = booking.getBoatDriverName();
    }

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTripName() { return tripName; }
    public void setTripName(String tripName) { this.tripName = tripName; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getNic() { return nic; }
    public void setNic(String nic) { this.nic = nic; }
    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }
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
    public String getBoatDriverName() { return boatDriverName; }
    public void setBoatDriverName(String boatDriverName) { this.boatDriverName = boatDriverName; }
}