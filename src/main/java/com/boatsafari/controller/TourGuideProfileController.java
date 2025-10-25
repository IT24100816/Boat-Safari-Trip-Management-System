package com.boatsafari.controller;

import com.boatsafari.model.TourGuide;
import com.boatsafari.repository.TourGuideRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.util.Optional;

@Controller
@RequestMapping("/tour-guide/profile")
public class TourGuideProfileController {

    @Autowired
    private TourGuideRepository tourGuideRepository;

    @GetMapping
    public String showProfile(HttpSession session, Model model) {
        // Check if user is logged in and is a tour guide
        TourGuide loggedInUser = (TourGuide) session.getAttribute("user");
        if (loggedInUser == null || !"Tour Guide".equals(loggedInUser.getRole())) {
            return "redirect:/login";
        }

        // Get fresh data from database
        Optional<TourGuide> tourGuide = tourGuideRepository.findById(loggedInUser.getId());
        if (tourGuide.isPresent()) {
            model.addAttribute("tourGuide", tourGuide.get());
            // Update session with latest data
            session.setAttribute("user", tourGuide.get());
        } else {
            return "redirect:/login";
        }

        return "TourGuideProfile";
    }

    @PostMapping("/edit")
    public String updateProfile(@ModelAttribute TourGuide updatedTourGuide,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        try {
            TourGuide loggedInUser = (TourGuide) session.getAttribute("user");
            if (loggedInUser == null || !loggedInUser.getId().equals(updatedTourGuide.getId())) {
                redirectAttributes.addFlashAttribute("error", "Unauthorized access");
                return "redirect:/tour-guide/profile";
            }

            // Get existing tour guide from database
            Optional<TourGuide> existingTourGuideOpt = tourGuideRepository.findById(updatedTourGuide.getId());
            if (existingTourGuideOpt.isPresent()) {
                TourGuide existingTourGuide = existingTourGuideOpt.get();

                // Update fields (preserve password and role)
                existingTourGuide.setFirstName(updatedTourGuide.getFirstName());
                existingTourGuide.setLastName(updatedTourGuide.getLastName());
                existingTourGuide.setEmail(updatedTourGuide.getEmail());
                existingTourGuide.setNic(updatedTourGuide.getNic());
                existingTourGuide.setAge(updatedTourGuide.getAge());
                existingTourGuide.setPhone(updatedTourGuide.getPhone());
                existingTourGuide.setLanguage(updatedTourGuide.getLanguage());

                // Save updated tour guide
                tourGuideRepository.save(existingTourGuide);

                // Update session
                session.setAttribute("user", existingTourGuide);

                redirectAttributes.addFlashAttribute("success", "Profile updated successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Profile not found");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating profile: " + e.getMessage());
        }

        return "redirect:/tour-guide/profile";
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam Long id,
                                 @RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        try {
            TourGuide loggedInUser = (TourGuide) session.getAttribute("user");
            if (loggedInUser == null || !loggedInUser.getId().equals(id)) {
                redirectAttributes.addFlashAttribute("error", "Unauthorized access");
                return "redirect:/tour-guide/profile";
            }

            // Get tour guide from database
            Optional<TourGuide> tourGuideOpt = tourGuideRepository.findById(id);
            if (tourGuideOpt.isPresent()) {
                TourGuide tourGuide = tourGuideOpt.get();

                // Verify current password
                if (!tourGuide.getPassword().equals(currentPassword)) {
                    redirectAttributes.addFlashAttribute("error", "Current password is incorrect");
                    return "redirect:/tour-guide/profile";
                }

                // Update password
                tourGuide.setPassword(newPassword);
                tourGuideRepository.save(tourGuide);

                // Update session
                session.setAttribute("user", tourGuide);

                redirectAttributes.addFlashAttribute("success", "Password changed successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Profile not found");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error changing password: " + e.getMessage());
        }

        return "redirect:/tour-guide/profile";
    }

    @PostMapping("/delete")
    public String deleteProfile(@RequestParam Long id,
                                @RequestParam String password,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        try {
            TourGuide loggedInUser = (TourGuide) session.getAttribute("user");
            if (loggedInUser == null || !loggedInUser.getId().equals(id)) {
                redirectAttributes.addFlashAttribute("error", "Unauthorized access");
                return "redirect:/tour-guide/profile";
            }

            // Get tour guide from database
            Optional<TourGuide> tourGuideOpt = tourGuideRepository.findById(id);
            if (tourGuideOpt.isPresent()) {
                TourGuide tourGuide = tourGuideOpt.get();

                // Verify password
                if (!tourGuide.getPassword().equals(password)) {
                    redirectAttributes.addFlashAttribute("error", "Incorrect password");
                    return "redirect:/tour-guide/profile";
                }

                // Delete tour guide
                tourGuideRepository.deleteById(id);

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

        return "redirect:/tour-guide/profile";
    }
}