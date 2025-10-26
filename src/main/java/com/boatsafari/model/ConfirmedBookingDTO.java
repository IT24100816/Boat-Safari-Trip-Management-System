package com.boatsafari.model;

import java.time.ZoneId;
import java.util.Date;

public class ConfirmedBookingDTO {
    private Long id;
    private String touristName;
    private String touristNic;
    private String boatName;
    private String driverName;
    private int passengers;
    private int hours;
    private double totalAmount;
    private Date bookingDate;
    private Date completedDate;
    private String imageUrl;

    public ConfirmedBookingDTO(ConfirmedBooking booking, Boat boat) {
        this.id = booking.getId();
        this.touristName = booking.getTouristName();
        this.touristNic = booking.getTouristNic();
        this.boatName = booking.getBoatName();
        this.driverName = booking.getDriverName();
        this.passengers = booking.getPassengers();
        this.hours = booking.getHours();
        this.totalAmount = booking.getTotalAmount();
        if (booking.getBookingDate() != null) {
            this.bookingDate = Date.from(booking.getBookingDate().atStartOfDay(ZoneId.systemDefault()).toInstant());
        }
        if (booking.getCompletedDate() != null) {
            this.completedDate = Date.from(booking.getCompletedDate().atStartOfDay(ZoneId.systemDefault()).toInstant());
        }
        this.imageUrl = (boat != null) ? boat.getImageUrl() : null;
    }

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTouristName() { return touristName; }
    public void setTouristName(String touristName) { this.touristName = touristName; }

    public String getTouristNic() { return touristNic; }
    public void setTouristNic(String touristNic) { this.touristNic = touristNic; }

    public String getBoatName() { return boatName; }
    public void setBoatName(String boatName) { this.boatName = boatName; }

    public String getDriverName() { return driverName; }
    public void setDriverName(String driverName) { this.driverName = driverName; }

    public int getPassengers() { return passengers; }
    public void setPassengers(int passengers) { this.passengers = passengers; }

    public int getHours() { return hours; }
    public void setHours(int hours) { this.hours = hours; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }

    public Date getCompletedDate() { return completedDate; }
    public void setCompletedDate(Date completedDate) { this.completedDate = completedDate; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}