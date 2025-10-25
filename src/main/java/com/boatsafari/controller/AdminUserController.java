package com.boatsafari.controller;

import com.boatsafari.model.BoatDriver;
import com.boatsafari.model.BookingManager;
import com.boatsafari.model.MarketingCoordinator;
import com.boatsafari.model.TourGuide;
import com.boatsafari.model.Tourist;
import com.boatsafari.model.User;
import com.boatsafari.repository.*;
import com.boatsafari.repository.AssignedBookingRepository; // Added
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.util.Optional;

@Controller
public class AdminUserController {

    @Autowired
    private TouristRepository touristRepository;

    @Autowired
    private BoatDriverRepository boatDriverRepository;

    @Autowired
    private TourGuideRepository tourGuideRepository;

    @Autowired
    private BookingManagerRepository bookingManagerRepository;

    @Autowired
    private MarketingCoordinatorRepository marketingCoordinatorRepository;

    @Autowired
    private AssignedBookingRepository assignBookingRepository; // Added

    @GetMapping("/admin/users")
    public String showUserManagement(HttpSession session, Model model) {
        if (isAdmin(session)) {
            model.addAttribute("tourists", touristRepository.findAll());
            model.addAttribute("boatDrivers", boatDriverRepository.findAll());
            model.addAttribute("tourGuides", tourGuideRepository.findAll());
            model.addAttribute("bookingManagers", bookingManagerRepository.findAll());
            model.addAttribute("marketingCoordinators", marketingCoordinatorRepository.findAll());
            return "AdminUserManagement";
        } else {
            return "redirect:/login";
        }
    }

    @PostMapping("/admin/users/add")
    public String addUser(
            @RequestParam String role,
            @RequestParam String firstName,
            @RequestParam String lastName,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String nic,
            @RequestParam int age,
            @RequestParam String phone,
            @RequestParam(required = false) String licenseNumber,
            @RequestParam(required = false) String language,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (isAdmin(session)) {
            try {
                User user = createUserInstance(role, firstName, lastName, email, password, nic, age, phone, licenseNumber, language);
                if (user != null) {
                    if ("Tourist".equals(role)) touristRepository.save((Tourist) user);
                    else if ("BoatDriver".equals(role)) boatDriverRepository.save((BoatDriver) user);
                    else if ("TourGuide".equals(role)) tourGuideRepository.save((TourGuide) user);
                    else if ("BookingManager".equals(role)) bookingManagerRepository.save((BookingManager) user);
                    else if ("MarketingCoordinator".equals(role)) marketingCoordinatorRepository.save((MarketingCoordinator) user);
                    redirectAttributes.addFlashAttribute("successMessage", "User added successfully!");
                } else {
                    redirectAttributes.addFlashAttribute("errorMessage", "Invalid role specified.");
                }
            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("errorMessage", "Error adding user: " + e.getMessage());
            }
            return "redirect:/admin/users";
        } else {
            return "redirect:/login";
        }
    }

    @PostMapping("/admin/users/edit")
    public String editUser(
            @RequestParam Long id,
            @RequestParam String role,
            @RequestParam String firstName,
            @RequestParam String lastName,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String nic,
            @RequestParam int age,
            @RequestParam String phone,
            @RequestParam(required = false) String licenseNumber,
            @RequestParam(required = false) String language,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (isAdmin(session)) {
            try {
                User user = createUserInstance(role, firstName, lastName, email, password, nic, age, phone, licenseNumber, language);
                if (user != null) {
                    user.setId(id);
                    if ("Tourist".equals(role)) touristRepository.save((Tourist) user);
                    else if ("BoatDriver".equals(role)) boatDriverRepository.save((BoatDriver) user);
                    else if ("TourGuide".equals(role)) tourGuideRepository.save((TourGuide) user);
                    else if ("BookingManager".equals(role)) bookingManagerRepository.save((BookingManager) user);
                    else if ("MarketingCoordinator".equals(role)) marketingCoordinatorRepository.save((MarketingCoordinator) user);
                    redirectAttributes.addFlashAttribute("successMessage", "User updated successfully!");
                } else {
                    redirectAttributes.addFlashAttribute("errorMessage", "Invalid role specified.");
                }
            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("errorMessage", "Error updating user: " + e.getMessage());
            }
            return "redirect:/admin/users";
        } else {
            return "redirect:/login";
        }
    }

    @Transactional
    @PostMapping("/admin/users/delete")
    public String deleteUser(
            @RequestParam Long id,
            @RequestParam String role,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (isAdmin(session)) {
            try {
                boolean deleted = false;
                switch (role) {
                    case "Tourist":
                        touristRepository.deleteById(id);
                        deleted = !touristRepository.existsById(id);
                        break;
                    case "BoatDriver":
                        // Delete associated assign_booking records first
                        assignBookingRepository.deleteByBoatDriverId(id);
                        boatDriverRepository.deleteById(id);
                        deleted = !boatDriverRepository.existsById(id);
                        break;
                    case "TourGuide":
                        tourGuideRepository.deleteById(id);
                        deleted = !tourGuideRepository.existsById(id);
                        break;
                    case "BookingManager":
                        bookingManagerRepository.deleteById(id);
                        deleted = !bookingManagerRepository.existsById(id);
                        break;
                    case "MarketingCoordinator":
                        marketingCoordinatorRepository.deleteById(id);
                        deleted = !marketingCoordinatorRepository.existsById(id);
                        break;
                    default:
                        redirectAttributes.addFlashAttribute("errorMessage", "Invalid role specified.");
                        return "redirect:/admin/users";
                }

                if (deleted) {
                    redirectAttributes.addFlashAttribute("successMessage", "User deleted successfully!");
                } else {
                    throw new RuntimeException("Deletion failed: User still exists in database.");
                }
            } catch (Exception e) {
                System.out.println("Error deleting user (ID: " + id + ", Role: " + role + "): " + e.getMessage());
                redirectAttributes.addFlashAttribute("errorMessage", "Error deleting user: " + e.getMessage());
            }
            return "redirect:/admin/users";
        } else {
            return "redirect:/login";
        }
    }

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "Admin".equalsIgnoreCase(user.getRole());
    }

    private User createUserInstance(String role, String firstName, String lastName, String email, String password, String nic, int age, String phone, String licenseNumber, String language) {
        switch (role) {
            case "Tourist":
                Tourist tourist = new Tourist();
                tourist.setFirstName(firstName);
                tourist.setLastName(lastName);
                tourist.setEmail(email);
                tourist.setPassword(password);
                tourist.setNic(nic);
                tourist.setAge(age);
                tourist.setPhone(phone);
                tourist.setRole("Tourist");
                return tourist;
            case "BoatDriver":
                BoatDriver driver = new BoatDriver();
                driver.setFirstName(firstName);
                driver.setLastName(lastName);
                driver.setEmail(email);
                driver.setPassword(password);
                driver.setNic(nic);
                driver.setAge(age);
                driver.setPhone(phone);
                driver.setLicenseNumber(licenseNumber);
                driver.setRole("BoatDriver");
                return driver;
            case "TourGuide":
                TourGuide guide = new TourGuide();
                guide.setFirstName(firstName);
                guide.setLastName(lastName);
                guide.setEmail(email);
                guide.setPassword(password);
                guide.setNic(nic);
                guide.setAge(age);
                guide.setPhone(phone);
                guide.setLanguage(language);
                guide.setRole("TourGuide");
                return guide;
            case "BookingManager":
                BookingManager manager = new BookingManager();
                manager.setFirstName(firstName);
                manager.setLastName(lastName);
                manager.setEmail(email);
                manager.setPassword(password);
                manager.setNic(nic);
                manager.setAge(age);
                manager.setPhone(phone);
                manager.setRole("BookingManager");
                return manager;
            case "MarketingCoordinator":
                MarketingCoordinator coordinator = new MarketingCoordinator();
                coordinator.setFirstName(firstName);
                coordinator.setLastName(lastName);
                coordinator.setEmail(email);
                coordinator.setPassword(password);
                coordinator.setNic(nic);
                coordinator.setAge(age);
                coordinator.setPhone(phone);
                coordinator.setRole("MarketingCoordinator");
                return coordinator;
            default:
                return null;
        }
    }
}