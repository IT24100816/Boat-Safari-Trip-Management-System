package com.boatsafari.controller;

import com.boatsafari.model.BookingManager;
import com.boatsafari.repository.BookingManagerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.util.Optional;

@Controller
@RequestMapping("/booking-manager/profile")
public class BookingManagerProfileController {

    @Autowired
    private BookingManagerRepository bookingManagerRepository;

    @GetMapping
    public String showProfile(HttpSession session, Model model) {
        System.out.println("=== BOOKING MANAGER PROFILE CONTROLLER CALLED ===");

        // Check if user is logged in
        Object userObj = session.getAttribute("user");
        System.out.println("User object from session: " + (userObj != null ? userObj.getClass().getSimpleName() : "NULL"));

        if (userObj == null) {
            System.out.println("ERROR: No user in session - redirecting to login");
            return "redirect:/login";
        }

        // Check if user is a BookingManager
        if (!(userObj instanceof BookingManager)) {
            System.out.println("ERROR: User is not a BookingManager - actual type: " + userObj.getClass().getSimpleName());
            return "redirect:/login";
        }

        BookingManager loggedInUser = (BookingManager) userObj;
        System.out.println("Logged in user: " + loggedInUser.getEmail());
        System.out.println("User role: " + loggedInUser.getRole());

        // Get fresh data from database
        Optional<BookingManager> bookingManager = bookingManagerRepository.findById(loggedInUser.getId());
        if (bookingManager.isPresent()) {
            model.addAttribute("bookingManager", bookingManager.get());
            // Update session with latest data
            session.setAttribute("user", bookingManager.get());
            System.out.println("SUCCESS: Loading BookingManagerProfile.jsp for: " + bookingManager.get().getEmail());
        } else {
            System.out.println("ERROR: Booking Manager not found in database");
            return "redirect:/login";
        }

        return "BookingManagerProfile";
    }

    @PostMapping("/edit")
    public String updateProfile(@ModelAttribute BookingManager updatedBookingManager,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        System.out.println("=== UPDATE PROFILE CALLED ===");
        try {
            BookingManager loggedInUser = (BookingManager) session.getAttribute("user");
            if (loggedInUser == null || !loggedInUser.getId().equals(updatedBookingManager.getId())) {
                redirectAttributes.addFlashAttribute("error", "Unauthorized access");
                return "redirect:/booking-manager/profile";
            }

            // Get existing booking manager from database
            Optional<BookingManager> existingBookingManagerOpt = bookingManagerRepository.findById(updatedBookingManager.getId());
            if (existingBookingManagerOpt.isPresent()) {
                BookingManager existingBookingManager = existingBookingManagerOpt.get();

                // Update fields (preserve password and role)
                existingBookingManager.setFirstName(updatedBookingManager.getFirstName());
                existingBookingManager.setLastName(updatedBookingManager.getLastName());
                existingBookingManager.setEmail(updatedBookingManager.getEmail());
                existingBookingManager.setNic(updatedBookingManager.getNic());
                existingBookingManager.setAge(updatedBookingManager.getAge());
                existingBookingManager.setPhone(updatedBookingManager.getPhone());

                // Save updated booking manager
                bookingManagerRepository.save(existingBookingManager);

                // Update session
                session.setAttribute("user", existingBookingManager);

                redirectAttributes.addFlashAttribute("success", "Profile updated successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Profile not found");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating profile: " + e.getMessage());
        }

        return "redirect:/booking-manager/profile";
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam Long id,
                                 @RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        System.out.println("=== CHANGE PASSWORD CALLED ===");
        try {
            BookingManager loggedInUser = (BookingManager) session.getAttribute("user");
            if (loggedInUser == null || !loggedInUser.getId().equals(id)) {
                redirectAttributes.addFlashAttribute("error", "Unauthorized access");
                return "redirect:/booking-manager/profile";
            }

            // Get booking manager from database
            Optional<BookingManager> bookingManagerOpt = bookingManagerRepository.findById(id);
            if (bookingManagerOpt.isPresent()) {
                BookingManager bookingManager = bookingManagerOpt.get();

                // Verify current password
                if (!bookingManager.getPassword().equals(currentPassword)) {
                    redirectAttributes.addFlashAttribute("error", "Current password is incorrect");
                    return "redirect:/booking-manager/profile";
                }

                // Update password
                bookingManager.setPassword(newPassword);
                bookingManagerRepository.save(bookingManager);

                // Update session
                session.setAttribute("user", bookingManager);

                redirectAttributes.addFlashAttribute("success", "Password changed successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Profile not found");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error changing password: " + e.getMessage());
        }

        return "redirect:/booking-manager/profile";
    }

    @PostMapping("/delete")
    public String deleteProfile(@RequestParam Long id,
                                @RequestParam String password,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        System.out.println("=== DELETE PROFILE CALLED ===");
        try {
            BookingManager loggedInUser = (BookingManager) session.getAttribute("user");
            if (loggedInUser == null || !loggedInUser.getId().equals(id)) {
                redirectAttributes.addFlashAttribute("error", "Unauthorized access");
                return "redirect:/booking-manager/profile";
            }

            // Get booking manager from database
            Optional<BookingManager> bookingManagerOpt = bookingManagerRepository.findById(id);
            if (bookingManagerOpt.isPresent()) {
                BookingManager bookingManager = bookingManagerOpt.get();

                // Verify password
                if (!bookingManager.getPassword().equals(password)) {
                    redirectAttributes.addFlashAttribute("error", "Incorrect password");
                    return "redirect:/booking-manager/profile";
                }

                // Delete booking manager
                bookingManagerRepository.deleteById(id);

                // Invalidate session
                session.invalidate();

                redirectAttributes.addFlashAttribute("success", "Your account has been deleted successfully.");
                return "redirect:/login";
            } else {
                redirectAttributes.addFlashAttribute("error", "Profile not found");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting profile: " + e.getMessage());
        }

        return "redirect:/booking-manager/profile";
    }
}