package com.boatsafari.model;

import jakarta.persistence.*;

@Entity
@Table(name = "boats")
public class Boat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "boat_name", nullable = false)
    private String boatName;

    @Column(name = "boat_type", nullable = false)
    private String boatType;

    @Column(name = "capacity", nullable = false)
    private Integer capacity;

    @Column(name = "registration_number", unique = true, nullable = false)
    private String registrationNumber;

    @Column(name = "status", nullable = false)
    private String status = "Available"; // Available, Maintenance, In Use

    @Column(name = "driver_id")
    private Long driverId;

    @Column(name = "driver_name")
    private String driverName;

    @Column(name = "image_url")
    private String imageUrl;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getBoatName() { return boatName; }
    public void setBoatName(String boatName) { this.boatName = boatName; }

    public String getBoatType() { return boatType; }
    public void setBoatType(String boatType) { this.boatType = boatType; }

    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }

    public String getRegistrationNumber() { return registrationNumber; }
    public void setRegistrationNumber(String registrationNumber) { this.registrationNumber = registrationNumber; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Long getDriverId() { return driverId; }
    public void setDriverId(Long driverId) { this.driverId = driverId; }

    public String getDriverName() { return driverName; }
    public void setDriverName(String driverName) { this.driverName = driverName; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}