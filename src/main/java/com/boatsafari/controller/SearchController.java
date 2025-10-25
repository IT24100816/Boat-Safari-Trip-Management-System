package com.boatsafari.controller;

import com.boatsafari.model.Trip;
import com.boatsafari.repository.TripRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
public class SearchController {

    @Autowired
    private TripRepository tripRepository;

    @GetMapping("/search/trips")
    public ResponseEntity<List<Trip>> searchTrips(@RequestParam String query) {
        List<Trip> trips = tripRepository.findAll().stream()
                .filter(trip -> trip.getName().toLowerCase().contains(query.toLowerCase()))
                .collect(Collectors.toList());
        return ResponseEntity.ok(trips);
    }

    @GetMapping("/search/trips/suggestions")
    public ResponseEntity<List<String>> getTripSuggestions(@RequestParam String prefix) {
        List<String> suggestions = tripRepository.findAll().stream()
                .map(Trip::getName)
                .filter(name -> name.toLowerCase().startsWith(prefix.toLowerCase()))
                .collect(Collectors.toList());
        return ResponseEntity.ok(suggestions);
    }
}