package com.boatsafari.model;

import jakarta.persistence.*;

@Entity
public class Trip {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String type;
    private String time;
    private int duration;
    private double price;
    private int capacity;
    private String locationName;
    private String googleMapsLink;
    @Column(columnDefinition = "TEXT")
    private String description;
    private String pictureUrl;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tourGuide_id")
    private TourGuide tourGuide;

    // Constructors
    public Trip() {}
    public Trip(String name, String type, String time, int duration, double price, int capacity, String locationName, String googleMapsLink, String description, String pictureUrl) {
        this.name = name;
        this.type = type;
        this.time = time;
        this.duration = duration;
        this.price = price;
        this.capacity = capacity;
        this.locationName = locationName;
        this.googleMapsLink = googleMapsLink;
        this.description = description;
        this.pictureUrl = pictureUrl;
    }

    public Trip(long l, String eveningSunsetTrip, String evening, String time, int i, double v, int i1, String galle, String url, String eveningTripDescription, String s) {
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getTime() { return time; }
    public void setTime(String time) { this.time = time; }
    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    public String getLocationName() { return locationName; }
    public void setLocationName(String locationName) { this.locationName = locationName; }
    public String getGoogleMapsLink() { return googleMapsLink; }
    public void setGoogleMapsLink(String googleMapsLink) { this.googleMapsLink = googleMapsLink; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getPictureUrl() { return pictureUrl; }
    public void setPictureUrl(String pictureUrl) { this.pictureUrl = pictureUrl; }

    public TourGuide getTourGuide() { return tourGuide; }
    public void setTourGuide(TourGuide tourGuide) { this.tourGuide = tourGuide; }
}