package com.boatsafari.controller;

import com.boatsafari.model.Tourist;
import com.boatsafari.repository.TouristRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.util.Optional;

@Controller
@RequestMapping("/tourist")
public class TouristController {

    @Autowired
    private TouristRepository touristRepository;

    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        Tourist tourist = (Tourist) session.getAttribute("user");
        if (tourist != null) {
            model.addAttribute("tourist", tourist);
            return "TouristProfile";
        } else {
            model.addAttribute("error", "Please log in to view your profile!");
            return "redirect:/login";
        }
    }

    @PostMapping("/profile/edit")
    public String editProfile(
            @RequestParam Long id,
            @RequestParam String firstName,
            @RequestParam String lastName,
            @RequestParam String email,
            @RequestParam String nic,
            @RequestParam int age,
            @RequestParam(required = false) String phone,
            RedirectAttributes redirectAttributes) {

        Optional<Tourist> touristOptional = touristRepository.findById(id);
        if (touristOptional.isPresent()) {
            Tourist tourist = touristOptional.get();
            tourist.setFirstName(firstName);
            tourist.setLastName(lastName);
            tourist.setEmail(email);
            tourist.setNic(nic);
            tourist.setAge(age);
            tourist.setPhone(phone);
            touristRepository.save(tourist);
            redirectAttributes.addFlashAttribute("success", "Profile updated successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Tourist not found!");
        }
        return "redirect:/tourist/profile";
    }

    @PostMapping("/profile/delete")
    public String deleteProfile(
            @RequestParam Long id,
            @RequestParam String confirmPassword,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Optional<Tourist> touristOptional = touristRepository.findById(id);
        if (touristOptional.isPresent()) {
            Tourist tourist = touristOptional.get();
            if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Please enter your password to confirm deletion!");
                return "redirect:/tourist/profile";
            }
            if (tourist.getPassword().equals(confirmPassword)) {
                touristRepository.delete(tourist);
                session.invalidate();
                redirectAttributes.addFlashAttribute("success", "Profile deleted successfully!");
                return "redirect:/";
            } else {
                redirectAttributes.addFlashAttribute("error", "Incorrect password! Profile not deleted.");
                return "redirect:/tourist/profile";
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "Tourist not found!");
            return "redirect:/tourist/profile";
        }
    }

    @GetMapping("/change-password")
    public String showChangePassword(HttpSession session, Model model) {
        Tourist tourist = (Tourist) session.getAttribute("user");
        if (tourist != null) {
            model.addAttribute("tourist", tourist);
            return "TouristChangePassword";
        } else {
            model.addAttribute("error", "Please log in to change your password!");
            return "redirect:/login";
        }
    }

    @PostMapping("/change-password")
    public String changePassword(
            @RequestParam String email,
            @RequestParam String nic,
            @RequestParam String currentPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {

        Tourist tourist = (Tourist) session.getAttribute("user");
        if (tourist != null) {
            if (!tourist.getEmail().equals(email) || !tourist.getNic().equals(nic) || !tourist.getPassword().equals(currentPassword)) {
                redirectAttributes.addFlashAttribute("error", "Email, NIC, or current password is incorrect!");
                return "redirect:/tourist/change-password";
            }
            if (!newPassword.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("error", "New passwords do not match!");
                return "redirect:/tourist/change-password";
            }
            tourist.setPassword(newPassword); // In production, hash the password
            touristRepository.save(tourist);
            redirectAttributes.addFlashAttribute("success", "Password changed successfully!");
            return "redirect:/tourist/change-password";
        } else {
            model.addAttribute("error", "Please log in to change your password!");
            return "redirect:/login";
        }
    }
}