package com.boatsafari.controller;

import com.boatsafari.model.AssignedBooking;
import com.boatsafari.model.ConfirmedBooking;
import com.boatsafari.model.BookingManager;
import com.boatsafari.model.User;
import com.boatsafari.repository.AssignedBookingRepository;
import com.boatsafari.repository.ConfirmedBookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import java.util.Optional;

@Controller
public class BookingManagerController {

    @Autowired
    private AssignedBookingRepository assignedBookingRepository;

    @Autowired
    private ConfirmedBookingRepository confirmedBookingRepository;

    @GetMapping("/available-bookings")
    public String showAvailableBookings(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        System.out.println("Available Bookings - User: " + (user != null ? user.getClass().getSimpleName() : "null"));

        if (user != null && user instanceof BookingManager) {
            List<AssignedBooking> assignedBookings = assignedBookingRepository.findAll();
            for (AssignedBooking ab : assignedBookings) {
                if (ab.getBookingDate() != null) {
                    ab.setBookingDate(ab.getBookingDate().atStartOfDay(ZoneId.systemDefault()).toLocalDate());
                }
                if (ab.getAssignedDate() != null) {
                    ab.setAssignedDate(ab.getAssignedDate().atStartOfDay(ZoneId.systemDefault()).toLocalDate());
                }
            }
            model.addAttribute("assignedBookings", assignedBookings);
            return "AvailableBookings";
        } else {
            System.out.println("Redirecting to login - User is not a BookingManager");
            return "redirect:/login";
        }
    }

    @PostMapping("/booking-manager/update-booking")
    public String updateBooking(
            @RequestParam Long id,
            @RequestParam String touristNic,
            @RequestParam int passengers,
            @RequestParam int hours,
            @RequestParam double totalAmount,
            @RequestParam String bookingDate,
            @RequestParam String assignedDate,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user != null && user instanceof BookingManager) {
            try {
                Optional<AssignedBooking> assignmentOptional = assignedBookingRepository.findById(id);
                if (assignmentOptional.isPresent()) {
                    AssignedBooking assignment = assignmentOptional.get();

                    // Update only the specified fields
                    assignment.setTouristNic(touristNic);
                    assignment.setPassengers(passengers);
                    assignment.setHours(hours);
                    assignment.setTotalAmount(totalAmount);
                    if (bookingDate != null && !bookingDate.isEmpty()) {
                        assignment.setBookingDate(LocalDate.parse(bookingDate));
                    }
                    if (assignedDate != null && !assignedDate.isEmpty()) {
                        assignment.setAssignedDate(LocalDate.parse(assignedDate));
                    }

                    // Save the updated assignment
                    assignedBookingRepository.save(assignment);

                    redirectAttributes.addFlashAttribute("successMessage", "Booking updated successfully!");
                } else {
                    redirectAttributes.addFlashAttribute("errorMessage", "Booking not found!");
                }
            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("errorMessage", "Error updating booking: " + e.getMessage());
            }
            return "redirect:/available-bookings";
        } else {
            return "redirect:/login";
        }
    }

    @PostMapping("/booking-manager/delete-booking")
    public String deleteBooking(
            @RequestParam Long id,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user != null && user instanceof BookingManager) {
            try {
                assignedBookingRepository.deleteAssignmentById(id);
                redirectAttributes.addFlashAttribute("successMessage", "Booking deleted successfully!");
            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("errorMessage", "Error deleting booking: " + e.getMessage());
            }
            return "redirect:/available-bookings";
        } else {
            return "redirect:/login";
        }
    }

    @PostMapping("/booking-manager/confirm-booking")
    public String confirmBooking(
            @RequestParam Long id,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user != null && user instanceof BookingManager) {
            try {
                Optional<AssignedBooking> assignmentOptional = assignedBookingRepository.findById(id);
                if (assignmentOptional.isPresent()) {
                    AssignedBooking assignment = assignmentOptional.get();

                    // Create a confirmed booking from the assignment
                    ConfirmedBooking confirmedBooking = new ConfirmedBooking(assignment);
                    confirmedBookingRepository.save(confirmedBooking);

                    // Update the status to "Completed"
                    assignment.setStatus("Completed");
                    assignedBookingRepository.save(assignment);

                    redirectAttributes.addFlashAttribute("successMessage", "Booking confirmed and marked as completed!");
                } else {
                    redirectAttributes.addFlashAttribute("errorMessage", "Booking not found!");
                }
            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("errorMessage", "Error confirming booking: " + e.getMessage());
            }
            return "redirect:/available-bookings";
        } else {
            return "redirect:/login";
        }
    }
}