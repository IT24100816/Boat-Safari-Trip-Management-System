package com.boatsafari.controller;

import com.boatsafari.model.Booking;
import com.boatsafari.model.BookingDTO;
import com.boatsafari.model.Promotion;
import com.boatsafari.model.Trip;
import com.boatsafari.repository.BookingRepository;
import com.boatsafari.repository.PromotionRepository;
import com.boatsafari.repository.TripRepository;
import com.boatsafari.pattern.PromotionContext;
import com.boatsafari.pattern.CombinedDiscountStrategy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class BookingHistoryController {

    @Autowired
    private BookingRepository bookingRepository;
    @Autowired
    private TripRepository tripRepository;
    @Autowired
    private PromotionRepository promotionRepository;

    @GetMapping("/booking-history")
    public String showBookingHistory(Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");
        if (username != null) {
            List<Booking> bookings = bookingRepository.findByUsername(username);
            List<BookingDTO> bookingDTOs = new ArrayList<>();
            for (Booking booking : bookings) {
                bookingDTOs.add(new BookingDTO(booking));
            }
            model.addAttribute("bookings", bookingDTOs);
            return "BookingHistory";
        } else {
            return "redirect:/login";
        }
    }

    @GetMapping("/update-booking")
    public String showUpdateForm(@RequestParam Long bookingId, Model model) {
        Booking booking = bookingRepository.findById(bookingId).orElse(null);
        if (booking == null) {
            model.addAttribute("error", "Booking not found");
            return "redirect:/booking-history";
        }
        Trip trip = tripRepository.findById(booking.getTripId()).orElse(null);
        Promotion promotion = trip != null ? promotionRepository.findByTripId(trip.getId()) : null;
        model.addAttribute("booking", new BookingDTO(booking));
        model.addAttribute("trips", tripRepository.findAll());
        model.addAttribute("trip", trip);
        model.addAttribute("promotion", promotion);

        // Add promotion details for all trips
        Map<Long, Map<String, Object>> tripPromotions = new HashMap<>();
        for (Trip t : tripRepository.findAll()) {
            Promotion p = promotionRepository.findByTripId(t.getId());
            Map<String, Object> promoDetails = new HashMap<>();
            promoDetails.put("percentage", p != null ? p.getDiscountPercentage() : 0.0);
            promoDetails.put("passengers", p != null ? p.getPassengers() : 0);
            promoDetails.put("hours", p != null ? p.getHours() : 0);
            tripPromotions.put(t.getId(), promoDetails);
        }
        model.addAttribute("tripPromotions", tripPromotions);
        return "updateBooking";
    }

    @PostMapping("/update-booking")
    public String updateBooking(@RequestParam Long bookingId,
                                @RequestParam String tripName,
                                @RequestParam String username,
                                @RequestParam String nic,
                                @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate bookingDate,
                                @RequestParam(required = false) MultipartFile paymentSlip,
                                @RequestParam int hours,
                                @RequestParam int passengers,
                                @RequestParam double totalAmount,
                                @RequestParam String bookingStatus,
                                Model model,
                                RedirectAttributes redirectAttributes) throws IOException {

        try {
            Booking booking = bookingRepository.findById(bookingId).orElseThrow(() -> new RuntimeException("Booking not found"));
            Trip trip = tripRepository.findById(booking.getTripId()).orElse(null);
            if (trip == null) {
                throw new RuntimeException("Trip not found");
            }
            Promotion promotion = promotionRepository.findByTripId(trip.getId());

            // Calculate base amount
            double baseAmount = trip.getPrice() * hours * passengers;

            // Apply only marketing coordinator discount
            PromotionContext context = new PromotionContext();
            context.setDiscountStrategy(new CombinedDiscountStrategy());
            double marketingDiscountPercent = promotion != null ? promotion.getDiscountPercentage() : 0.0;
            double totalDiscountAmount = baseAmount * (marketingDiscountPercent / 100);
            double finalTotal = baseAmount - totalDiscountAmount;

            // Update booking details
            booking.setTripName(tripName);
            booking.setUsername(username);
            booking.setNic(nic);
            booking.setBookingDate(bookingDate);
            if (paymentSlip != null && !paymentSlip.isEmpty()) {
                String paymentSlipUrl = savePaymentSlip(paymentSlip);
                booking.setPaymentSlipUrl(paymentSlipUrl);
            }
            booking.setHours(hours);
            booking.setPassengers(passengers);
            booking.setTotalAmount(finalTotal);
            booking.setBookingStatus(bookingStatus);
            bookingRepository.save(booking);

            // Redirect to index page with success message
            redirectAttributes.addFlashAttribute("success", "Booking updated successfully!");
            return "redirect:/";

        } catch (Exception e) {
            model.addAttribute("error", "Failed to update booking: " + e.getMessage());
            model.addAttribute("booking", new BookingDTO(bookingRepository.findById(bookingId).orElse(null)));
            model.addAttribute("trips", tripRepository.findAll());
            return "updateBooking";
        }
    }

    @PostMapping("/delete-booking")
    public String deleteBooking(@RequestParam Long bookingId) {
        bookingRepository.deleteById(bookingId);
        return "redirect:/booking-history";
    }

    // Placeholder method to save payment slip (implement file upload logic)
    private String savePaymentSlip(MultipartFile file) {
        // Implement file upload logic (e.g., save to server and return URL)
        // This is a placeholder; replace with actual implementation
        return "/uploads/" + file.getOriginalFilename(); // Example URL
    }
}