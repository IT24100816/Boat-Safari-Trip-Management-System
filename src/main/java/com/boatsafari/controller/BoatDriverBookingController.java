package com.boatsafari.controller;

import com.boatsafari.model.AssignedBooking;
import com.boatsafari.model.Booking;
import com.boatsafari.model.Boat;
import com.boatsafari.model.BoatDriver;
import com.boatsafari.model.User;
import com.boatsafari.repository.AssignedBookingRepository;
import com.boatsafari.repository.BookingRepository;
import com.boatsafari.repository.BoatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class BoatDriverBookingController {

    private static final Logger logger = LoggerFactory.getLogger(BoatDriverBookingController.class);

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private BoatRepository boatRepository;

    @Autowired
    private AssignedBookingRepository assignedBookingRepository;

    @GetMapping("/boat-driver/dashboard")
    @Transactional(readOnly = true)
    public String showBoatDriverDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user != null && user instanceof BoatDriver) {
            BoatDriver boatDriver = (BoatDriver) user;
            logger.info("Loading dashboard for BoatDriver: {}", boatDriver.getEmail());
            List<Booking> pendingBookings = bookingRepository.findByBookingStatus("Pending");
            model.addAttribute("pendingBookings", pendingBookings);
            List<Booking> myAssignedBookings = bookingRepository.findByBoatDriverIdAndBookingStatus(boatDriver.getId(), "Assigned");
            model.addAttribute("myAssignedBookings", myAssignedBookings);
            model.addAttribute("boatDriver", boatDriver);
            return "BoatDriver";
        } else {
            logger.warn("Unauthorized access to /boat-driver/dashboard by user: {}", user != null ? user.getEmail() : "null");
            return "redirect:/login";
        }
    }

    @PostMapping("/boat-driver/assign-booking")
    public String showAssignBoat(@RequestParam Long bookingId, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user != null && user instanceof BoatDriver) {
            BoatDriver boatDriver = (BoatDriver) user;
            Optional<Booking> bookingOptional = bookingRepository.findById(bookingId);
            if (bookingOptional.isPresent() && "Pending".equals(bookingOptional.get().getBookingStatus())) {
                List<Boat> availableBoats = boatRepository.findByDriverIdAndStatus(boatDriver.getId(), "Available");
                model.addAttribute("bookingId", bookingId);
                model.addAttribute("availableBoats", availableBoats);
                return "AssignBoat";
            } else {
                redirectAttributes.addFlashAttribute("error", "Invalid or already assigned booking.");
                return "redirect:/boat-driver/dashboard";
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "You must be logged in as a boat driver to assign bookings.");
            return "redirect:/login";
        }
    }

    @PostMapping("/boat-driver/assign-confirm")
    @Transactional
    public String assignBookingToDriver(
            @RequestParam Long bookingId,
            @RequestParam Long boatId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user != null && user instanceof BoatDriver) {
            BoatDriver boatDriver = (BoatDriver) user;
            logger.info("Attempting to assign booking - bookingId: {}, boatId: {}, driverId: {}", bookingId, boatId, boatDriver.getId());

            try {
                Optional<Booking> bookingOptional = bookingRepository.findById(bookingId);
                Optional<Boat> boatOptional = boatRepository.findById(boatId);

                if (!bookingOptional.isPresent()) {
                    logger.error("Booking not found for ID: {}", bookingId);
                    redirectAttributes.addFlashAttribute("error", "Booking not found.");
                    return "redirect:/boat-driver/dashboard";
                }
                if (!boatOptional.isPresent()) {
                    logger.error("Boat not found for ID: {}", boatId);
                    redirectAttributes.addFlashAttribute("error", "Boat not found.");
                    return "redirect:/boat-driver/dashboard";
                }

                Booking booking = bookingOptional.get();
                Boat boat = boatOptional.get();

                if (!"Pending".equals(booking.getBookingStatus())) {
                    logger.warn("Booking status is not Pending: {}", booking.getBookingStatus());
                    redirectAttributes.addFlashAttribute("error", "Booking is not in Pending status.");
                    return "redirect:/boat-driver/dashboard";
                }
                if (!boat.getDriverId().equals(boatDriver.getId())) {
                    logger.warn("Boat driver mismatch: {} vs {}", boat.getDriverId(), boatDriver.getId());
                    redirectAttributes.addFlashAttribute("error", "You are not the assigned driver for this boat.");
                    return "redirect:/boat-driver/dashboard";
                }
                if (!"Available".equals(boat.getStatus())) {
                    logger.warn("Boat is not Available: {}", boat.getStatus());
                    redirectAttributes.addFlashAttribute("error", "Boat is not available.");
                    return "redirect:/boat-driver/dashboard";
                }

                // Update Booking
                logger.info("Updating Booking: {}", booking.getId());
                booking.setBoatDriverId(boatDriver.getId());
                booking.setBoatDriverName(boatDriver.getFirstName() + " " + boatDriver.getLastName());
                booking.setBoatId(boatId);
                booking.setBookingStatus("Assigned");
                bookingRepository.save(booking);

                // Update Boat
                logger.info("Updating Boat: {}", boat.getId());
                boat.setStatus("In Use");
                boatRepository.save(boat);

                // Create and save AssignedBooking
                logger.info("Creating AssignedBooking for booking: {}", booking.getId());
                AssignedBooking assignedBooking = new AssignedBooking();
                assignedBooking.setBooking(booking);
                assignedBooking.setBoat(boat);
                assignedBooking.setBoatDriver(boatDriver);
                assignedBooking.setDriverId(boatDriver.getId());
                assignedBooking.setStatus("Assigned");
                assignedBooking.setTouristId(booking.getUserId());
                assignedBooking.setTouristName(booking.getUsername());
                assignedBooking.setTouristNic(booking.getNic());
                assignedBooking.setPassengers(booking.getPassengers());
                assignedBooking.setHours(booking.getHours());
                assignedBooking.setTotalAmount(booking.getTotalAmount());
                assignedBooking.setBookingDate(booking.getBookingDate());
                assignedBooking.setAssignedDate(LocalDate.now());
                assignedBooking.setDriverName(boatDriver.getFirstName() + " " + boatDriver.getLastName());
                assignedBooking.setDriverLicenseNumber(boatDriver.getLicenseNumber());
                assignedBooking.setDriverPhone(boatDriver.getPhone());
                assignedBooking.setBoatName(boat.getBoatName());
                assignedBooking.setBoatRegistrationNumber(boat.getRegistrationNumber());
                assignedBooking.setBoatCapacity(boat.getCapacity());
                // Populate trip_id and trip_name from Booking
                assignedBooking.setTripId(booking.getTripId()); // Assuming Booking has tripId
                assignedBooking.setTripName(booking.getTripName()); // Assuming Booking has tripName

                logger.info("Saving AssignedBooking: {}", assignedBooking);
                assignedBookingRepository.save(assignedBooking);
                logger.info("AssignedBooking saved successfully");

                redirectAttributes.addFlashAttribute("success", "Booking assigned successfully!");
            } catch (Exception e) {
                logger.error("Error during assignment: {}", e.getMessage(), e);
                redirectAttributes.addFlashAttribute("error", "An error occurred while assigning the booking. Please check logs or contact support.");
            }
        } else {
            logger.warn("User not authenticated or not a BoatDriver");
            redirectAttributes.addFlashAttribute("error", "You must be logged in as a boat driver to assign bookings.");
        }
        return "redirect:/boat-driver/dashboard";
    }

    @PostMapping("/boat-driver/assign-update")
    @Transactional
    public String updateBooking(
            @RequestParam Long bookingId,
            @RequestParam String bookingStatus,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user != null && user instanceof BoatDriver) {
            BoatDriver boatDriver = (BoatDriver) user;
            Optional<Booking> bookingOptional = bookingRepository.findById(bookingId);
            if (bookingOptional.isPresent() && bookingOptional.get().getBoatDriverId().equals(boatDriver.getId())) {
                Booking booking = bookingOptional.get();
                booking.setBookingStatus(bookingStatus);
                if ("Completed".equals(bookingStatus)) {
                    Optional<Boat> boatOptional = boatRepository.findById(booking.getBoatId());
                    boatOptional.ifPresent(boat -> {
                        boat.setStatus("Available");
                        boatRepository.save(boat);
                    });
                }
                bookingRepository.save(booking);
                Optional<AssignedBooking> assignedBookingOptional = assignedBookingRepository.findByBookingId(bookingId);
                assignedBookingOptional.ifPresent(assignedBooking -> {
                    assignedBooking.setStatus(bookingStatus);
                    // Update trip_id and trip_name if they change (optional)
                    assignedBooking.setTripId(booking.getTripId());
                    assignedBooking.setTripName(booking.getTripName());
                    assignedBookingRepository.save(assignedBooking);
                });
                redirectAttributes.addFlashAttribute("success", "Booking updated successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "You can only update your own bookings!");
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "You must be logged in as a boat driver to update bookings.");
        }
        return "redirect:/boat-driver/dashboard";
    }

    @PostMapping("/boat-driver/assign-leave")
    @Transactional
    public String leaveBooking(
            @RequestParam Long bookingId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user != null && user instanceof BoatDriver) {
            BoatDriver boatDriver = (BoatDriver) user;
            Optional<Booking> bookingOptional = bookingRepository.findById(bookingId);
            if (bookingOptional.isPresent() && bookingOptional.get().getBoatDriverId().equals(boatDriver.getId())) {
                Booking booking = bookingOptional.get();
                Optional<Boat> boatOptional = boatRepository.findById(booking.getBoatId());
                boatOptional.ifPresent(boat -> {
                    boat.setStatus("Available");
                    boatRepository.save(boat);
                });
                booking.setBookingStatus("Pending");
                booking.setBoatDriverId(null);
                booking.setBoatDriverName(null);
                booking.setBoatId(null);
                bookingRepository.save(booking);
                Optional<AssignedBooking> assignedBookingOptional = assignedBookingRepository.findByBookingId(bookingId);
                assignedBookingOptional.ifPresent(assignedBooking -> assignedBookingRepository.delete(assignedBooking));
                redirectAttributes.addFlashAttribute("success", "You have left the booking successfully! It is now available for reassignment.");
            } else {
                redirectAttributes.addFlashAttribute("error", "You can only leave your own bookings!");
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "You must be logged in as a boat driver to leave bookings.");
        }
        return "redirect:/boat-driver/dashboard";
    }
}