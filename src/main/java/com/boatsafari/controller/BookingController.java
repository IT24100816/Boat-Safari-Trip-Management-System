package com.boatsafari.controller;

import com.boatsafari.model.Booking;
import com.boatsafari.model.Promotion;
import com.boatsafari.model.Trip;
import com.boatsafari.model.User;
import com.boatsafari.repository.BookingRepository;
import com.boatsafari.repository.PromotionRepository;
import com.boatsafari.repository.TripRepository;
import com.boatsafari.pattern.PaymentValidationContext;
import com.boatsafari.pattern.FileTypeValidationStrategy;
import com.boatsafari.pattern.FileSizeValidationStrategy;
import com.boatsafari.pattern.PromotionContext;
import com.boatsafari.pattern.CombinedDiscountStrategy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
import java.util.List;

@Controller
public class BookingController {

    @Autowired
    private TripRepository tripRepository;
    @Autowired
    private BookingRepository bookingRepository;
    @Autowired
    private PromotionRepository promotionRepository;

    @GetMapping("/booking")
    public String showBookingPage(@RequestParam("tripId") Long tripId, Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        Trip trip = tripRepository.findById(tripId).orElse(null);
        if (trip == null) {
            return "redirect:/trips";
        }
        User user = (User) session.getAttribute("user");
        model.addAttribute("trip", trip);
        model.addAttribute("user", user);
        model.addAttribute("username", user.getFirstName() + " " + user.getLastName());

        // Check for promotion
        Promotion promotion = promotionRepository.findByTripId(tripId);
        if (promotion != null) {
            model.addAttribute("promotion", promotion);
        }

        String successMessage = (String) session.getAttribute("bookingSuccess");
        if (successMessage != null) {
            model.addAttribute("success", successMessage);
            session.removeAttribute("bookingSuccess");
        }

        return "Booking";
    }

    @PostMapping("/submit-booking")
    public String submitBooking(
            @RequestParam("tripId") Long tripId,
            @RequestParam("tripName") String tripName,
            @RequestParam("userId") Long userId,
            @RequestParam("username") String username,
            @RequestParam("nic") String nic,
            @RequestParam("bookingDate") String bookingDate,
            @RequestParam("hours") int hours,
            @RequestParam("passengers") int passengers,
            @RequestParam("totalAmount") double totalAmount,
            @RequestParam("paymentSlip") MultipartFile paymentSlip,
            HttpSession session,
            RedirectAttributes redirectAttributes) throws IOException {

        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        if (hours <= 0 || passengers <= 0 || totalAmount <= 0) {
            redirectAttributes.addFlashAttribute("error", "Invalid booking details.");
            return "redirect:/booking?tripId=" + tripId + "&bookingDate=" + bookingDate + "&hours=" + hours + "&passengers=" + passengers;
        }

        // Validate payment slip using Strategy Pattern
        List<String> validationErrors = new ArrayList<>();
        PaymentValidationContext validationContext = new PaymentValidationContext();
        validationContext.setStrategy(new FileTypeValidationStrategy());
        if (!validationContext.validate(paymentSlip, validationErrors)) {
            redirectAttributes.addFlashAttribute("error", String.join(", ", validationErrors));
            return "redirect:/booking?tripId=" + tripId;
        }
        validationContext.setStrategy(new FileSizeValidationStrategy());
        if (!validationContext.validate(paymentSlip, validationErrors)) {
            redirectAttributes.addFlashAttribute("error", String.join(", ", validationErrors));
            return "redirect:/booking?tripId=" + tripId;
        }

        String paymentSlipUrl = null;
        if (!paymentSlip.isEmpty()) {
            try {
                String fileName = System.currentTimeMillis() + "_" + paymentSlip.getOriginalFilename();
                String uploadDir = "src/main/resources/static/uploads/payments/";
                Path uploadPath = Paths.get(uploadDir);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                Path filePath = uploadPath.resolve(fileName);
                Files.copy(paymentSlip.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                paymentSlipUrl = "/uploads/payments/" + fileName;
            } catch (IOException e) {
                redirectAttributes.addFlashAttribute("error", "Failed to upload payment slip: " + e.getMessage());
                return "redirect:/booking?tripId=" + tripId;
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "Payment slip is required.");
            return "redirect:/booking?tripId=" + tripId;
        }

        Trip trip = tripRepository.findById(tripId).orElse(null);
        if (trip == null) {
            redirectAttributes.addFlashAttribute("error", "Trip not found.");
            return "redirect:/trips";
        }
        Promotion promotion = promotionRepository.findByTripId(tripId);

        // Calculate base amount
        double baseAmount = trip.getPrice() * hours * passengers;

        // Apply discount using PromotionContext
        PromotionContext context = new PromotionContext();
        context.setDiscountStrategy(new CombinedDiscountStrategy());
        double finalTotal = baseAmount;
        double marketingDiscountPercent = promotion != null ? promotion.getDiscountPercentage() : 0.0;

        if (promotion != null && passengers >= promotion.getPassengers() && hours >= promotion.getHours()) {
            finalTotal = context.applyDiscount(baseAmount, passengers, hours, trip, marketingDiscountPercent);
        } else {
            double totalDiscount = context.applyDiscount(baseAmount, passengers, hours, trip, 0.0); // No marketing discount if conditions not met
            finalTotal = baseAmount - totalDiscount;
        }

        // Log detailed calculation to console
        System.out.println("Booking Details:");
        System.out.println("Trip Name: " + trip.getName());
        System.out.println("Trip Type: " + trip.getType());
        System.out.println("Trip Type Percent: " +
                ("morning".equalsIgnoreCase(trip.getType()) ? "5%" :
                        "evening".equalsIgnoreCase(trip.getType()) ? "7.5%" :
                                "private".equalsIgnoreCase(trip.getType()) ? "10%" : "0%"));
        double totalDiscountPercentage = context.getTotalDiscountPercentage(marketingDiscountPercent, trip, passengers, hours);
        System.out.println("Total Discount Percentage: " + totalDiscountPercentage + "%");
        System.out.println("Total Discount Amount: $" + (baseAmount - finalTotal));
        System.out.println("Base Amount: $" + baseAmount);
        System.out.println("Total Amount: $" + finalTotal);
        System.out.println();

        Booking booking = new Booking();
        booking.setTripId(tripId);
        booking.setTripName(tripName);
        booking.setUserId(userId);
        booking.setUsername(username);
        booking.setNic(nic);
        booking.setBookingDate(LocalDate.parse(bookingDate));
        booking.setHours(hours);
        booking.setPassengers(passengers);
        booking.setTotalAmount(finalTotal);
        booking.setPaymentSlipUrl(paymentSlipUrl);
        booking.setBookingStatus("Pending");
        bookingRepository.save(booking);

        redirectAttributes.addFlashAttribute("success", "Boat Safari Trip Booked Successfully!");

        return "index";
    }
}