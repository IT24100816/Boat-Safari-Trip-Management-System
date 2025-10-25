package com.boatsafari.controller;

import com.boatsafari.model.Trip;
import com.boatsafari.repository.TripRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class TripController {

    @Autowired
    private TripRepository tripRepository;

    @PostMapping("/admin/create-trip")
    public Object createTrip(
            @RequestParam("name") String name,
            @RequestParam("type") String type,
            @RequestParam("time") String time,
            @RequestParam("duration") int duration,
            @RequestParam("price") double price,
            @RequestParam("capacity") int capacity,
            @RequestParam("locationName") String locationName,
            @RequestParam("googleMapsLink") String googleMapsLink,
            @RequestParam("description") String description,
            @RequestParam("tripPicture") MultipartFile tripPicture,
            RedirectAttributes redirectAttributes,
            HttpServletRequest request) {

        try {
            if (description.length() > 1000) {
                throw new IllegalArgumentException("Description is too long. Maximum 1000 characters allowed.");
            }

            String pictureUrl = null;
            if (!tripPicture.isEmpty() && tripPicture.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + tripPicture.getOriginalFilename();
                String uploadDir = "src/main/resources/static/uploads/";
                Path uploadPath = Paths.get(uploadDir);

                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }

                Path filePath = uploadPath.resolve(fileName);
                Files.copy(tripPicture.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                pictureUrl = "/uploads/" + fileName;
            }

            Trip trip = new Trip(name, type, time, duration, price, capacity, locationName, googleMapsLink, description, pictureUrl);
            tripRepository.save(trip);

            String xhr = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(xhr)) {
                Map<String, String> response = new HashMap<>();
                response.put("success", "Trip created successfully!");
                return ResponseEntity.ok(response);
            } else {
                redirectAttributes.addFlashAttribute("success", "Trip created successfully!");
                return "redirect:/admin/trips";
            }
        } catch (Exception e) {
            e.printStackTrace();

            String xhr = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(xhr)) {
                Map<String, String> response = new HashMap<>();
                response.put("error", "Failed to create trip: " + e.getMessage());
                return ResponseEntity.badRequest().body(response);
            } else {
                redirectAttributes.addFlashAttribute("error", "Failed to create trip: " + e.getMessage());
                return "redirect:/admin/dashboard";
            }
        }
    }

    @GetMapping("/admin/trips")
    public String showAdminTrips(Model model) {
        model.addAttribute("trips", tripRepository.findAll());
        return "AdminTripManagement";
    }

    @GetMapping("/trips")
    public String showTrips(@RequestParam(value = "search", required = false) String searchQuery, Model model) {
        List<Trip> allTrips = tripRepository.findAll();

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            // Filter trips based on search query
            List<Trip> filteredTrips = allTrips.stream()
                    .filter(trip -> trip.getName().toLowerCase().contains(searchQuery.toLowerCase()))
                    .collect(Collectors.toList());
            model.addAttribute("trips", filteredTrips);
            model.addAttribute("searchQuery", searchQuery);
        } else {
            model.addAttribute("trips", allTrips);
        }

        return "Trips";
    }

    @GetMapping("/admin/edit-trip")
    public String showEditTrip(@RequestParam("id") Long id, Model model) {
        Trip trip = tripRepository.findById(id).orElse(null);
        if (trip == null) {
            model.addAttribute("error", "Trip not found.");
            return "redirect:/admin/trips";
        }
        model.addAttribute("trip", trip);
        return "AdminTripEdit";
    }

    @PostMapping("/admin/update-trip")
    public String updateTrip(
            @RequestParam("id") Long id,
            @RequestParam("name") String name,
            @RequestParam("type") String type,
            @RequestParam("time") String time,
            @RequestParam("duration") int duration,
            @RequestParam("price") double price,
            @RequestParam("capacity") int capacity,
            @RequestParam("locationName") String locationName,
            @RequestParam("googleMapsLink") String googleMapsLink,
            @RequestParam("description") String description,
            @RequestParam("tripPicture") MultipartFile tripPicture,
            RedirectAttributes redirectAttributes) {

        try {
            if (description.length() > 1000) {
                throw new IllegalArgumentException("Description is too long. Maximum 1000 characters allowed.");
            }

            Trip trip = tripRepository.findById(id).orElse(null);
            if (trip == null) {
                redirectAttributes.addFlashAttribute("error", "Trip not found.");
                return "redirect:/admin/trips";
            }

            trip.setName(name);
            trip.setType(type);
            trip.setTime(time);
            trip.setDuration(duration);
            trip.setPrice(price);
            trip.setCapacity(capacity);
            trip.setLocationName(locationName);
            trip.setGoogleMapsLink(googleMapsLink);
            trip.setDescription(description);

            if (!tripPicture.isEmpty() && tripPicture.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + tripPicture.getOriginalFilename();
                String uploadDir = "src/main/resources/static/uploads/";
                Path uploadPath = Paths.get(uploadDir);

                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }

                Path filePath = uploadPath.resolve(fileName);
                Files.copy(tripPicture.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                trip.setPictureUrl("/uploads/" + fileName);
            }

            tripRepository.save(trip);
            redirectAttributes.addFlashAttribute("success", "Trip updated successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Failed to update trip: " + e.getMessage());
        }

        return "redirect:/admin/trips";
    }

    @GetMapping("/admin/delete-trip")
    public String deleteTrip(@RequestParam("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            Trip trip = tripRepository.findById(id).orElse(null);
            if (trip == null) {
                redirectAttributes.addFlashAttribute("error", "Trip not found.");
            } else {
                tripRepository.delete(trip);
                redirectAttributes.addFlashAttribute("success", "Trip deleted successfully!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Failed to delete trip: " + e.getMessage());
        }
        return "redirect:/admin/trips";
    }
}