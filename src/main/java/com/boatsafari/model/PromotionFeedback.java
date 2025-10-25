package com.boatsafari.model;

import jakarta.persistence.*;

@Entity
@Table(name = "promotion_feedback")
public class PromotionFeedback {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tourist_id", nullable = false)
    private Tourist tourist;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "promotion_id", nullable = false)
    private Promotion promotion;

    @Column(name = "comment", columnDefinition = "TEXT", nullable = true)
    private String feedback;

    @Column(name = "trip_id", nullable = false)
    private Long tripId;

    @Column(name = "rating", nullable = false)
    private int rating; // 1 to 5

    @Column(name = "created_at")
    private java.time.LocalDateTime createdAt = java.time.LocalDateTime.now();

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Tourist getTourist() { return tourist; }
    public void setTourist(Tourist tourist) { this.tourist = tourist; }
    public Promotion getPromotion() { return promotion; }
    public void setPromotion(Promotion promotion) { this.promotion = promotion; }
    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }
    public Long getTripId() { return tripId; }
    public void setTripId(Long tripId) { this.tripId = tripId; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public java.time.LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.time.LocalDateTime createdAt) { this.createdAt = createdAt; }
}