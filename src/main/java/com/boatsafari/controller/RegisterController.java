package com.boatsafari.controller;

import com.boatsafari.model.BoatDriver;
import com.boatsafari.model.TourGuide;
import com.boatsafari.model.Tourist;
import com.boatsafari.repository.BoatDriverRepository;
import com.boatsafari.repository.TourGuideRepository;
import com.boatsafari.repository.TouristRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.servlet.http.HttpSession;

@Controller
public class RegisterController {
    private static final Logger logger = LoggerFactory.getLogger(RegisterController.class);

    @Autowired
    private TouristRepository touristRepository;
    @Autowired
    private BoatDriverRepository boatDriverRepository;
    @Autowired
    private TourGuideRepository tourGuideRepository;

    @GetMapping("/register")
    public String showRegisterPage() {
        return "Login";
    }

    @PostMapping("/register")
    public String processRegistration(
            @RequestParam String firstName,
            @RequestParam String lastName,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            @RequestParam String nic,
            @RequestParam int age,
            @RequestParam String phone,
            @RequestParam String role,
            @RequestParam(required = false) String licenseNumber,
            @RequestParam(required = false) String language,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        logger.info("Registration attempt - Email: {}, Role: {}", email, role);

        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Passwords do not match");
            logger.warn("Password mismatch for email: {}", email);
            return "redirect:/register";
        }

        // Validate role-specific fields
        if ("Boat Driver".equalsIgnoreCase(role)) {
            if (licenseNumber == null || licenseNumber.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "License number is required for Boat Drivers");
                logger.warn("Missing license number for email: {}", email);
                return "redirect:/register";
            }
        } else if ("Tour Guide".equalsIgnoreCase(role)) {
            if (language == null || language.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Language is required for Tour Guides");
                logger.warn("Missing language for email: {}", email);
                return "redirect:/register";
            }
        } else if (!"Tourist".equalsIgnoreCase(role)) {
            redirectAttributes.addFlashAttribute("error", "Invalid role selected: " + role);
            logger.warn("Invalid role selected for email: {}", email);
            return "redirect:/register";
        }

        try {
            if ("Tourist".equalsIgnoreCase(role)) {
                Tourist tourist = new Tourist();
                tourist.setFirstName(firstName);
                tourist.setLastName(lastName);
                tourist.setEmail(email);
                tourist.setPassword(password);
                tourist.setNic(nic);
                tourist.setAge(age);
                tourist.setPhone(phone);
                tourist.setRole(role);
                touristRepository.save(tourist);
                logger.info("Tourist registered successfully: {}", email);
                session.setAttribute("user", tourist);
                return "redirect:/";
            } else if ("Boat Driver".equalsIgnoreCase(role)) {
                BoatDriver boatDriver = new BoatDriver();
                boatDriver.setFirstName(firstName);
                boatDriver.setLastName(lastName);
                boatDriver.setEmail(email);
                boatDriver.setPassword(password);
                boatDriver.setNic(nic);
                boatDriver.setAge(age);
                boatDriver.setPhone(phone);
                boatDriver.setLicenseNumber(licenseNumber);
                boatDriver.setRole(role);
                boatDriverRepository.save(boatDriver);
                logger.info("Boat Driver registered successfully: {}", email);
                session.setAttribute("user", boatDriver);
                return "redirect:/boat-driver/dashboard";
            } else if ("Tour Guide".equalsIgnoreCase(role)) {
                TourGuide tourGuide = new TourGuide();
                tourGuide.setFirstName(firstName);
                tourGuide.setLastName(lastName);
                tourGuide.setEmail(email);
                tourGuide.setPassword(password);
                tourGuide.setNic(nic);
                tourGuide.setAge(age);
                tourGuide.setPhone(phone);
                tourGuide.setRole(role);
                tourGuide.setLanguage(language);
                tourGuideRepository.save(tourGuide);
                logger.info("Tour Guide registered successfully: {}", email);
                session.setAttribute("user", tourGuide);
                return "redirect:/tour-guide/dashboard";
            }
        } catch (Exception e) {
            logger.error("Registration failed for email: {}, role: {}, error: {}", email, role, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "Registration failed: " + e.getMessage());
            return "redirect:/register";
        }

        redirectAttributes.addFlashAttribute("error", "Unexpected error during registration for role: " + role);
        return "redirect:/register";
    }
}