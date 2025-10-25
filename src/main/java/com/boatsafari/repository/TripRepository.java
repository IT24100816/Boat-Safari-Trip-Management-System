package com.boatsafari.repository;

import com.boatsafari.model.Trip;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TripRepository extends JpaRepository<Trip, Long> {
    List<Trip> findAll();
    List<Trip> findByType(String type);
    List<Trip> findByNameContainingIgnoreCase(String name);
}
