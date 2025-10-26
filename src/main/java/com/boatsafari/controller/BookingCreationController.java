package com.boatsafari.controller;

import com.boatsafari.model.AssignedBooking;
import com.boatsafari.model.Boat;
import com.boatsafari.model.BoatDriver;
import com.boatsafari.model.Booking;
import com.boatsafari.model.Tourist;
import com.boatsafari.model.Trip;
import com.boatsafari.model.User;
import com.boatsafari.repository.AssignedBookingRepository;
import com.boatsafari.repository.BookingRepository;
import com.boatsafari.repository.BoatDriverRepository;
import com.boatsafari.repository.BoatRepository;
import com.boatsafari.repository.TouristRepository;
import com.boatsafari.repository.TripRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Controller
public class BookingCreationController {

    private static final Logger logger = LoggerFactory.getLogger(BookingCreationController.class);

    @Autowired
    private AssignedBookingRepository assignedBookingRepository;
    @Autowired
    private TouristRepository touristRepository;
    @Autowired
    private BoatRepository boatRepository;
    @Autowired
    private BoatDriverRepository boatDriverRepository;
    @Autowired
    private TripRepository tripRepository;
    @Autowired
    private BookingRepository bookingRepository;

    @GetMapping("/api/tourists")
    public String getTourists(Model model) {
        model.addAttribute("tourists", touristRepository.findAll());
        return "fragments/tourist-options";
    }

    @GetMapping("/api/boats")
    public String getBoats(Model model) {
        model.addAttribute("boats", boatRepository.findAll());
        return "fragments/boat-options";
    }

    @GetMapping("/api/drivers")
    public String getDrivers(Model model) {
        model.addAttribute("drivers", boatDriverRepository.findAll());
        return "fragments/driver-options";
    }

    @GetMapping("/api/trips")
    public String getTrips(Model model) {
        model.addAttribute("trips", tripRepository.findAll());
        return "fragments/trip-options";
    }

    @GetMapping("/booking-manager")
    public String showBookingManager(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user != null && "BookingManager".equalsIgnoreCase(user.getRole())) {
            return "BookingManager";
        } else {
            return "redirect:/login";
        }
    }

    @PostMapping("/booking-manager/add-booking")
    public String addBooking(
            @RequestParam Long touristId,
            @RequestParam String touristName,
            @RequestParam String touristNic,
            @RequestParam Integer passengers,
            @RequestParam Integer hours,
            @RequestParam Double totalAmount,
            @RequestParam String bookingDate,
            @RequestParam Long boatId,
            @RequestParam String boatName,
            @RequestParam String boatRegistrationNumber,
            @RequestParam Integer boatCapacity,
            @RequestParam Long driverId,
            @RequestParam String driverName,
            @RequestParam String driverLicenseNumber,
            @RequestParam String driverPhone,
            @RequestParam String assignedDate,
            @RequestParam Long tripId,
            @RequestParam String tripName,
            @RequestParam String status,
            HttpSession session,
            Model model) {

        User user = (User) session.getAttribute("user");
        if (user != null && "BookingManager".equalsIgnoreCase(user.getRole())) {
            try {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                LocalDate parsedBookingDate = LocalDate.parse(bookingDate, formatter);
                LocalDate parsedAssignedDate = LocalDate.parse(assignedDate, formatter);

                // Create new Booking in trip_booking
                Booking booking = new Booking();
                booking.setTripId(tripId);
                booking.setTripName(tripName);
                booking.setUserId(touristId); // Assuming userId can be touristId
                booking.setUsername(touristName);
                booking.setNic(touristNic);
                booking.setBookingDate(parsedBookingDate);
                booking.setHours(hours);
                booking.setPassengers(passengers);
                booking.setTotalAmount(totalAmount);
                booking.setPaymentSlipUrl("Paid"); // Set payment_slip_url to "Paid" for Booking Manager
                booking.setBookingStatus(status); // Initial status
                booking.setBoatDriverId(driverId);
                booking.setBoatDriverName(driverName);
                booking.setBoatId(boatId);
                booking = bookingRepository.save(booking); // Save to get generated id
                Long bookingId = booking.getId();

                // Fetch or create related entities if needed
                Boat boat = boatRepository.findById(boatId).orElseGet(() -> {
                    Boat newBoat = new Boat();
                    newBoat.setId(boatId);
                    newBoat.setBoatName(boatName);
                    newBoat.setRegistrationNumber(boatRegistrationNumber);
                    newBoat.setCapacity(boatCapacity);
                    return boatRepository.save(newBoat);
                });

                BoatDriver boatDriver = boatDriverRepository.findById(driverId).orElseGet(() -> {
                    BoatDriver newDriver = new BoatDriver();
                    newDriver.setId(driverId);
                    newDriver.setFirstName(driverName.split(" ")[0]);
                    newDriver.setLastName(driverName.contains(" ") ? driverName.split(" ")[1] : "");
                    newDriver.setLicenseNumber(driverLicenseNumber);
                    newDriver.setPhone(driverPhone);
                    return boatDriverRepository.save(newDriver);
                });

                Tourist tourist = touristRepository.findById(touristId).orElseThrow(() -> new RuntimeException("Tourist not found"));
                Trip trip = tripRepository.findById(tripId).orElseThrow(() -> new RuntimeException("Trip not found"));

                // Create new AssignedBooking with the generated bookingId
                AssignedBooking assignedBooking = new AssignedBooking();
                assignedBooking.setBooking(booking); // Link to the newly created Booking
                assignedBooking.setBoat(boat);
                assignedBooking.setBoatDriver(boatDriver);
                assignedBooking.setDriverId(driverId);
                assignedBooking.setStatus(status);
                assignedBooking.setTouristId(touristId);
                assignedBooking.setTouristName(touristName);
                assignedBooking.setTouristNic(touristNic);
                assignedBooking.setPassengers(passengers);
                assignedBooking.setHours(hours);
                assignedBooking.setTotalAmount(totalAmount);
                assignedBooking.setBookingDate(parsedBookingDate);
                assignedBooking.setAssignedDate(parsedAssignedDate);
                assignedBooking.setDriverName(driverName);
                assignedBooking.setDriverLicenseNumber(driverLicenseNumber);
                assignedBooking.setDriverPhone(driverPhone);
                assignedBooking.setBoatName(boatName);
                assignedBooking.setBoatRegistrationNumber(boatRegistrationNumber);
                assignedBooking.setBoatCapacity(boatCapacity);
                assignedBooking.setTripId(tripId);
                assignedBooking.setTripName(tripName);

                logger.info("Saving AssignedBooking: {}", assignedBooking);
                assignedBookingRepository.save(assignedBooking);

                // Set success message and return the same view
                model.addAttribute("successMessage", "Booking added Successfully!");
                return "BookingManager";
            } catch (Exception e) {
                logger.error("Error adding booking: {}", e.getMessage(), e);
                model.addAttribute("errorMessage", "Error adding booking: " + e.getMessage());
                return "BookingManager";
            }
        } else {
            return "redirect:/login";
        }
    }
}