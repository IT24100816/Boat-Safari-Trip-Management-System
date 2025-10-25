package com.boatsafari.controller;

import com.boatsafari.model.Boat;
import com.boatsafari.model.BoatDriver;
import com.boatsafari.model.User;
import com.boatsafari.repository.BoatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/boat-driver")
public class BoatController {

    @Autowired
    private BoatRepository boatRepository;

    @GetMapping("/boats")
    public String showBoatsPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user != null && user instanceof BoatDriver) {
            BoatDriver boatDriver = (BoatDriver) user;

            List<Boat> boats = boatRepository.findAll();
            model.addAttribute("boats", boats);
            model.addAttribute("boatDriver", boatDriver);
            if (model.containsAttribute("success")) {
                model.addAttribute("successMessage", model.asMap().get("success"));
            }

            return "Boats";
        } else {
            return "redirect:/login";
        }
    }

    @PostMapping("/boats/add")
    public String addBoat(
            @RequestParam String boatName,
            @RequestParam String boatType,
            @RequestParam Integer capacity,
            @RequestParam String registrationNumber,
            @RequestParam String status,
            @RequestParam("boatImage") MultipartFile boatImage,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user != null && user instanceof BoatDriver) {
            BoatDriver boatDriver = (BoatDriver) user;

            Optional<Boat> existingBoat = boatRepository.findByRegistrationNumber(registrationNumber);
            if (existingBoat.isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Boat with this registration number already exists!");
                return "redirect:/boat-driver/boats";
            }

            String imageUrl = null;
            if (!boatImage.isEmpty()) {
                try {
                    String fileName = System.currentTimeMillis() + "_" + boatImage.getOriginalFilename();
                    String uploadDir = "src/main/resources/static/uploads/boats/";
                    Path uploadPath = Paths.get(uploadDir);
                    if (!Files.exists(uploadPath)) {
                        Files.createDirectories(uploadPath);
                    }
                    Path filePath = uploadPath.resolve(fileName);
                    Files.copy(boatImage.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                    imageUrl = "/uploads/boats/" + fileName;
                } catch (IOException e) {
                    redirectAttributes.addFlashAttribute("error", "Failed to upload boat image: " + e.getMessage());
                    return "redirect:/boat-driver/boats";
                }
            } else {
                redirectAttributes.addFlashAttribute("error", "Boat image is required.");
                return "redirect:/boat-driver/boats";
            }

            Boat boat = new Boat();
            boat.setBoatName(boatName);
            boat.setBoatType(boatType);
            boat.setCapacity(capacity);
            boat.setRegistrationNumber(registrationNumber);
            boat.setStatus(status);
            boat.setDriverId(boatDriver.getId());
            boat.setDriverName(boatDriver.getFirstName() + " " + boatDriver.getLastName());
            boat.setImageUrl(imageUrl);

            boatRepository.save(boat);

            redirectAttributes.addFlashAttribute("success", "Boat added successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "You must be logged in as a boat driver to add boats.");
        }

        return "redirect:/boat-driver/boats";
    }

    @PostMapping("/boats/update")
    public String updateBoat(
            @RequestParam Long boatId,
            @RequestParam String boatName,
            @RequestParam String boatType,
            @RequestParam Integer capacity,
            @RequestParam String registrationNumber,
            @RequestParam String status,
            @RequestParam("boatImage") MultipartFile boatImage,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user != null && user instanceof BoatDriver) {
            BoatDriver boatDriver = (BoatDriver) user;

            Optional<Boat> boatOptional = boatRepository.findById(boatId);
            if (boatOptional.isPresent()) {
                Boat boat = boatOptional.get();

                if (!boatDriver.getId().equals(boat.getDriverId())) {
                    redirectAttributes.addFlashAttribute("error", "You can only update your own boats!");
                    return "redirect:/boat-driver/boats";
                }

                Optional<Boat> existingBoat = boatRepository.findByRegistrationNumber(registrationNumber);
                if (existingBoat.isPresent() && !existingBoat.get().getId().equals(boatId)) {
                    redirectAttributes.addFlashAttribute("error", "Another boat with this registration number already exists!");
                    return "redirect:/boat-driver/boats";
                }

                if (!boatImage.isEmpty()) {
                    try {
                        String fileName = System.currentTimeMillis() + "_" + boatImage.getOriginalFilename();
                        String uploadDir = "src/main/resources/static/uploads/boats/";
                        Path uploadPath = Paths.get(uploadDir);
                        if (!Files.exists(uploadPath)) {
                            Files.createDirectories(uploadPath);
                        }
                        Path filePath = uploadPath.resolve(fileName);
                        Files.copy(boatImage.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                        boat.setImageUrl("/uploads/boats/" + fileName);
                    } catch (IOException e) {
                        redirectAttributes.addFlashAttribute("error", "Failed to upload boat image: " + e.getMessage());
                        return "redirect:/boat-driver/boats";
                    }
                }

                boat.setBoatName(boatName);
                boat.setBoatType(boatType);
                boat.setCapacity(capacity);
                boat.setRegistrationNumber(registrationNumber);
                boat.setStatus(status);

                boatRepository.save(boat);

                redirectAttributes.addFlashAttribute("success", "Boat updated successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Boat not found!");
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "You must be logged in as a boat driver to update boats.");
        }

        return "redirect:/boat-driver/boats";
    }

    @PostMapping("/boats/delete")
    @Transactional
    public String deleteBoat(
            @RequestParam Long boatId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user != null && user instanceof BoatDriver) {
            BoatDriver boatDriver = (BoatDriver) user;

            Optional<Boat> boatOptional = boatRepository.findById(boatId);
            if (boatOptional.isPresent()) {
                Boat boat = boatOptional.get();

                if (!boatDriver.getId().equals(boat.getDriverId())) {
                    redirectAttributes.addFlashAttribute("error", "You can only delete your own boats!");
                    return "redirect:/boat-driver/boats";
                }

                // Nullify boat_id in confirmed_booking and assign_booking
                boatRepository.nullifyBoatIdInConfirmedBookings(boatId);
                boatRepository.nullifyBoatIdInAssignBookings(boatId);

                // Delete the boat
                boatRepository.delete(boat);
                redirectAttributes.addFlashAttribute("success", "Successfully Deleted");
            } else {
                redirectAttributes.addFlashAttribute("error", "Boat not found!");
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "You must be logged in as a boat driver to delete boats.");
        }

        return "redirect:/boat-driver/boats";
    }
}