package com.boatsafari.controller;

import com.boatsafari.model.MarketingCoordinator;
import com.boatsafari.repository.MarketingCoordinatorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.util.Optional;

@Controller
@RequestMapping("/marketing-coordinator/profile")
public class MarketingCoordinatorProfileController {

    @Autowired
    private MarketingCoordinatorRepository marketingCoordinatorRepository;

    @GetMapping
    public String showProfile(HttpSession session, Model model) {
        // Check if user is logged in and is a marketing coordinator
        Object user = session.getAttribute("user");
        if (user == null || !(user instanceof MarketingCoordinator)) {
            System.out.println("Profile access denied - User: " + (user != null ? user.getClass().getSimpleName() : "null"));
            return "redirect:/login";
        }

        MarketingCoordinator loggedInUser = (MarketingCoordinator) user;

        // Debug logging
        System.out.println("=== Profile Access Debug ===");
        System.out.println("Marketing Coordinator: " + loggedInUser.getEmail());
        System.out.println("User ID: " + loggedInUser.getId());
        System.out.println("=== End Debug ===");

        // Get fresh data from database
        Optional<MarketingCoordinator> marketingCoordinator = marketingCoordinatorRepository.findById(loggedInUser.getId());
        if (marketingCoordinator.isPresent()) {
            model.addAttribute("marketingCoordinator", marketingCoordinator.get());
            // Update session with latest data
            session.setAttribute("user", marketingCoordinator.get());
        } else {
            return "redirect:/login";
        }

        return "MarketingCoordinatorProfile";
    }

    @PostMapping("/edit")
    public String updateProfile(@ModelAttribute MarketingCoordinator updatedMarketingCoordinator,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        try {
            Object user = session.getAttribute("user");
            if (user == null || !(user instanceof MarketingCoordinator)) {
                redirectAttributes.addFlashAttribute("error", "Unauthorized access");
                return "redirect:/marketing-coordinator/profile";
            }

            MarketingCoordinator loggedInUser = (MarketingCoordinator) user;
            if (!loggedInUser.getId().equals(updatedMarketingCoordinator.getId())) {
                redirectAttributes.addFlashAttribute("error", "Unauthorized access");
                return "redirect:/marketing-coordinator/profile";
            }

            // Get existing marketing coordinator from database
            Optional<MarketingCoordinator> existingMarketingCoordinatorOpt = marketingCoordinatorRepository.findById(updatedMarketingCoordinator.getId());
            if (existingMarketingCoordinatorOpt.isPresent()) {
                MarketingCoordinator existingMarketingCoordinator = existingMarketingCoordinatorOpt.get();

                // Update fields (preserve password and role)
                existingMarketingCoordinator.setFirstName(updatedMarketingCoordinator.getFirstName());
                existingMarketingCoordinator.setLastName(updatedMarketingCoordinator.getLastName());
                existingMarketingCoordinator.setEmail(updatedMarketingCoordinator.getEmail());
                existingMarketingCoordinator.setNic(updatedMarketingCoordinator.getNic());
                existingMarketingCoordinator.setAge(updatedMarketingCoordinator.getAge());
                existingMarketingCoordinator.setPhone(updatedMarketingCoordinator.getPhone());

                // Save updated marketing coordinator
                marketingCoordinatorRepository.save(existingMarketingCoordinator);

                // Update session
                session.setAttribute("user", existingMarketingCoordinator);

                redirectAttributes.addFlashAttribute("success", "Profile updated successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Profile not found");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating profile: " + e.getMessage());
        }

        return "redirect:/marketing-coordinator/profile";
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam Long id,
                                 @RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        try {
            Object user = session.getAttribute("user");
            if (user == null || !(user instanceof MarketingCoordinator)) {
                redirectAttributes.addFlashAttribute("error", "Unauthorized access");
                return "redirect:/marketing-coordinator/profile";
            }

            MarketingCoordinator loggedInUser = (MarketingCoordinator) user;
            if (!loggedInUser.getId().equals(id)) {
                redirectAttributes.addFlashAttribute("error", "Unauthorized access");
                return "redirect:/marketing-coordinator/profile";
            }

            // Get marketing coordinator from database
            Optional<MarketingCoordinator> marketingCoordinatorOpt = marketingCoordinatorRepository.findById(id);
            if (marketingCoordinatorOpt.isPresent()) {
                MarketingCoordinator marketingCoordinator = marketingCoordinatorOpt.get();

                // Verify current password
                if (!marketingCoordinator.getPassword().equals(currentPassword)) {
                    redirectAttributes.addFlashAttribute("error", "Current password is incorrect");
                    return "redirect:/marketing-coordinator/profile";
                }

                // Update password
                marketingCoordinator.setPassword(newPassword);
                marketingCoordinatorRepository.save(marketingCoordinator);

                // Update session
                session.setAttribute("user", marketingCoordinator);

                redirectAttributes.addFlashAttribute("success", "Password changed successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Profile not found");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error changing password: " + e.getMessage());
        }

        return "redirect:/marketing-coordinator/profile";
    }

    @PostMapping("/delete")
    public String deleteProfile(@RequestParam Long id,
                                @RequestParam String password,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        try {
            Object user = session.getAttribute("user");
            if (user == null || !(user instanceof MarketingCoordinator)) {
                redirectAttributes.addFlashAttribute("error", "Unauthorized access");
                return "redirect:/marketing-coordinator/profile";
            }

            MarketingCoordinator loggedInUser = (MarketingCoordinator) user;
            if (!loggedInUser.getId().equals(id)) {
                redirectAttributes.addFlashAttribute("error", "Unauthorized access");
                return "redirect:/marketing-coordinator/profile";
            }

            // Get marketing coordinator from database
            Optional<MarketingCoordinator> marketingCoordinatorOpt = marketingCoordinatorRepository.findById(id);
            if (marketingCoordinatorOpt.isPresent()) {
                MarketingCoordinator marketingCoordinator = marketingCoordinatorOpt.get();

                // Verify password
                if (!marketingCoordinator.getPassword().equals(password)) {
                    redirectAttributes.addFlashAttribute("error", "Incorrect password");
                    return "redirect:/marketing-coordinator/profile";
                }

                // Delete marketing coordinator
                marketingCoordinatorRepository.deleteById(id);

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

        return "redirect:/marketing-coordinator/profile";
    }
}