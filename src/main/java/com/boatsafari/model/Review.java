package com.boatsafari.model;

import jakarta.persistence.*;

import java.time.LocalDate;

@Entity
public class Review {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "tour_guide_id")
    private TourGuide tourGuide;

    @ManyToOne
    @JoinColumn(name = "trip_id")
    private Trip trip;

    @Column(columnDefinition = "TEXT")
    private String paragraph1;

    @Column(columnDefinition = "TEXT")
    private String paragraph2;

    @Column(length = 1000)
    private String imageUrls; // Comma-separated list of image paths

    private LocalDate date;
    private int rating; // 1 to 5 stars
    private String touristName;

    // Constructors
    public Review() {}

    public Review(TourGuide tourGuide, Trip trip, String paragraph1, String paragraph2, String imageUrls, LocalDate date, int rating, String touristName) {
        this.tourGuide = tourGuide;
        this.trip = trip;
        this.paragraph1 = paragraph1;
        this.paragraph2 = paragraph2;
        this.imageUrls = imageUrls;
        this.date = date;
        this.rating = rating;
        this.touristName = touristName;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public TourGuide getTourGuide() { return tourGuide; }
    public void setTourGuide(TourGuide tourGuide) { this.tourGuide = tourGuide; }
    public Trip getTrip() { return trip; }
    public void setTrip(Trip trip) { this.trip = trip; }
    public String getParagraph1() { return paragraph1; }
    public void setParagraph1(String paragraph1) { this.paragraph1 = paragraph1; }
    public String getParagraph2() { return paragraph2; }
    public void setParagraph2(String paragraph2) { this.paragraph2 = paragraph2; }
    public String getImageUrls() { return imageUrls; }
    public void setImageUrls(String imageUrls) { this.imageUrls = imageUrls; }
    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getTouristName() { return touristName; }
    public void setTouristName(String touristName) { this.touristName = touristName; }
}