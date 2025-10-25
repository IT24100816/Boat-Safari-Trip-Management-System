package com.boatsafari.controller;

import com.boatsafari.model.BoatDriver;
import com.boatsafari.repository.BoatDriverRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.util.Optional;

@Controller
@RequestMapping("/boat-driver/profile")
public class BoatDriverProfileController {

    @Autowired
    private BoatDriverRepository boatDriverRepository;

    @GetMapping
    public String showProfile(HttpSession session, Model model) {
        // Check if user is logged in and is a boat driver
        BoatDriver loggedInUser = (BoatDriver) session.getAttribute("user");
        if (loggedInUser == null || !"Boat Driver".equals(loggedInUser.getRole())) {
            return "redirect:/login";
        }

        // Get fresh data from database
        Optional<BoatDriver> boatDriver = boatDriverRepository.findById(loggedInUser.getId());
        if (boatDriver.isPresent()) {
            model.addAttribute("boatDriver", boatDriver.get());
            // Update session with latest data
            session.setAttribute("user", boatDriver.get());
        } else {
            return "redirect:/login";
        }

        return "BoatDriverProfile";
    }

    @PostMapping("/edit")
    public String updateProfile(@ModelAttribute BoatDriver updatedBoatDriver,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        try {
            BoatDriver loggedInUser = (BoatDriver) session.getAttribute("user");
            if (loggedInUser == null || !loggedInUser.getId().equals(updatedBoatDriver.getId())) {
                redirectAttributes.addFlashAttribute("error", "Unauthorized access");
                return "redirect:/boat-driver/profile";
            }

            // Get existing boat driver from database
            Optional<BoatDriver> existingBoatDriverOpt = boatDriverRepository.findById(updatedBoatDriver.getId());
            if (existingBoatDriverOpt.isPresent()) {
                BoatDriver existingBoatDriver = existingBoatDriverOpt.get();

                // Update fields (preserve password and role)
                existingBoatDriver.setFirstName(updatedBoatDriver.getFirstName());
                existingBoatDriver.setLastName(updatedBoatDriver.getLastName());
                existingBoatDriver.setEmail(updatedBoatDriver.getEmail());
                existingBoatDriver.setNic(updatedBoatDriver.getNic());
                existingBoatDriver.setAge(updatedBoatDriver.getAge());
                existingBoatDriver.setPhone(updatedBoatDriver.getPhone());
                existingBoatDriver.setLicenseNumber(updatedBoatDriver.getLicenseNumber());

                // Save updated boat driver
                boatDriverRepository.save(existingBoatDriver);

                // Update session
                session.setAttribute("user", existingBoatDriver);

                redirectAttributes.addFlashAttribute("success", "Profile updated successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Profile not found");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating profile: " + e.getMessage());
        }

        return "redirect:/boat-driver/profile";
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam Long id,
                                 @RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        try {
            BoatDriver loggedInUser = (BoatDriver) session.getAttribute("user");
            if (loggedInUser == null || !loggedInUser.getId().equals(id)) {
                redirectAttributes.addFlashAttribute("error", "Unauthorized access");
                return "redirect:/boat-driver/profile";
            }

            // Get boat driver from database
            Optional<BoatDriver> boatDriverOpt = boatDriverRepository.findById(id);
            if (boatDriverOpt.isPresent()) {
                BoatDriver boatDriver = boatDriverOpt.get();

                // Verify current password
                if (!boatDriver.getPassword().equals(currentPassword)) {
                    redirectAttributes.addFlashAttribute("error", "Current password is incorrect");
                    return "redirect:/boat-driver/profile";
                }

                // Update password
                boatDriver.setPassword(newPassword);
                boatDriverRepository.save(boatDriver);

                // Update session
                session.setAttribute("user", boatDriver);

                redirectAttributes.addFlashAttribute("success", "Password changed successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Profile not found");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error changing password: " + e.getMessage());
        }

        return "redirect:/boat-driver/profile";
    }

    @PostMapping("/delete")
    public String deleteProfile(@RequestParam Long id,
                                @RequestParam String password,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        try {
            BoatDriver loggedInUser = (BoatDriver) session.getAttribute("user");
            if (loggedInUser == null || !loggedInUser.getId().equals(id)) {
                redirectAttributes.addFlashAttribute("error", "Unauthorized access");
                return "redirect:/boat-driver/profile";
            }

            // Get boat driver from database
            Optional<BoatDriver> boatDriverOpt = boatDriverRepository.findById(id);
            if (boatDriverOpt.isPresent()) {
                BoatDriver boatDriver = boatDriverOpt.get();

                // Verify password
                if (!boatDriver.getPassword().equals(password)) {
                    redirectAttributes.addFlashAttribute("error", "Incorrect password");
                    return "redirect:/boat-driver/profile";
                }

                // Delete boat driver
                boatDriverRepository.deleteById(id);

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

        return "redirect:/boat-driver/profile";
    }
}