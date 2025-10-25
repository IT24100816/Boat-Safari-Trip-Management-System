package com.boatsafari.controller;

import com.boatsafari.model.*;
import com.boatsafari.repository.AdminRepository;
import com.boatsafari.repository.BoatDriverRepository;
import com.boatsafari.repository.BookingManagerRepository;
import com.boatsafari.repository.MarketingCoordinatorRepository;
import com.boatsafari.repository.TourGuideRepository;
import com.boatsafari.repository.TouristRepository;
import com.boatsafari.repository.TripRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

import java.util.List;

@Controller
public class LoginController {

    @Autowired
    private TouristRepository touristRepository;
    @Autowired
    private BoatDriverRepository boatDriverRepository;
    @Autowired
    private TourGuideRepository tourGuideRepository;
    @Autowired
    private AdminRepository adminRepository;
    @Autowired
    private BookingManagerRepository bookingManagerRepository;
    @Autowired
    private MarketingCoordinatorRepository marketingCoordinatorRepository;
    @Autowired
    private TripRepository tripRepository;

    @GetMapping("/login")
    public String showLoginPage(HttpSession session) {
        session.invalidate();
        return "Login";
    }

    @PostMapping("/login")
    public String processLogin(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        System.out.println("Login attempt for email: " + email);

        Tourist tourist = touristRepository.findByEmail(email);
        BoatDriver boatDriver = boatDriverRepository.findByEmail(email);
        TourGuide tourGuide = tourGuideRepository.findByEmail(email);
        Admin admin = adminRepository.findByEmail(email);
        BookingManager bookingManager = bookingManagerRepository.findByEmail(email);
        MarketingCoordinator marketingCoordinator = marketingCoordinatorRepository.findByEmail(email);

        User authenticatedUser = null;
        String userType = null;

        if (tourist != null && tourist.getPassword().equals(password)) {
            authenticatedUser = tourist;
            userType = "Tourist";
        } else if (boatDriver != null && boatDriver.getPassword().equals(password)) {
            authenticatedUser = boatDriver;
            userType = "BoatDriver";
        } else if (tourGuide != null && tourGuide.getPassword().equals(password)) {
            authenticatedUser = tourGuide;
            userType = "TourGuide";
        } else if (admin != null && admin.getPassword().equals(password)) {
            authenticatedUser = admin;
            userType = "Admin";
        } else if (bookingManager != null && bookingManager.getPassword().equals(password)) {
            authenticatedUser = bookingManager;
            userType = "BookingManager";
        } else if (marketingCoordinator != null && marketingCoordinator.getPassword().equals(password)) {
            authenticatedUser = marketingCoordinator;
            userType = "MarketingCoordinator";
        }

        if (authenticatedUser != null) {
            System.out.println("Login successful for: " + email + " Type: " + userType);
            session.setAttribute("user", authenticatedUser);
            session.setAttribute("username", authenticatedUser.getFirstName() + " " + authenticatedUser.getLastName());
            session.setAttribute("userType", userType);

            // Debug logging
            System.out.println("User role from getRole(): " + authenticatedUser.getRole());
            System.out.println("User class: " + authenticatedUser.getClass().getSimpleName());

            switch (userType) {
                case "Admin":
                    return "redirect:/admin/dashboard";
                case "BoatDriver":
                    return "redirect:/boat-driver/dashboard";
                case "BookingManager":
                    return "redirect:/booking-manager/dashboard";
                case "MarketingCoordinator":
                    return "redirect:/marketing-coordinator/dashboard";
                case "TourGuide":
                    return "redirect:/tour-guide/dashboard";
                default:
                    return "redirect:/";
            }
        } else {
            System.out.println("Login failed for: " + email);
            redirectAttributes.addFlashAttribute("error", "Invalid email or password");
            return "redirect:/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    @GetMapping("/admin/dashboard")
    public String showAdminDashboard(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null && user instanceof Admin) {
            return "AdminDashboard";
        } else {
            return "redirect:/login";
        }
    }

    @GetMapping("/booking-manager/dashboard")
    public String showBookingManagerDashboard(HttpSession session) {
        User user = (User) session.getAttribute("user");
        System.out.println("Booking Manager Dashboard - User: " + (user != null ? user.getClass().getSimpleName() : "null"));

        if (user != null && user instanceof BookingManager) {
            return "BookingManager";
        } else {
            System.out.println("Redirecting to login - User is not a BookingManager");
            return "redirect:/login";
        }
    }

    @GetMapping("/marketing-coordinator/dashboard")
    public String showMarketingCoordinatorDashboard(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null && user instanceof MarketingCoordinator) {
            return "MarketingCoordinatorDashboard";
        } else {
            return "redirect:/login";
        }
    }

    @GetMapping("/tour-guide/dashboard")
    public String showTourGuideDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user != null && user instanceof TourGuide) {
            List<Trip> trips = tripRepository.findAll();
            model.addAttribute("trips", trips);
            return "TourGuideDashboard";
        } else {
            return "redirect:/login";
        }
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordPage() {
        return "ForgotPassword";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(
            @RequestParam String firstName,
            @RequestParam String lastName,
            @RequestParam String email,
            @RequestParam String nic,
            @RequestParam String phone,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            RedirectAttributes redirectAttributes) {

        // Find user across all roles
        Tourist tourist = touristRepository.findByEmail(email);
        BoatDriver boatDriver = boatDriverRepository.findByEmail(email);
        TourGuide tourGuide = tourGuideRepository.findByEmail(email);
        Admin admin = adminRepository.findByEmail(email);
        BookingManager bookingManager = bookingManagerRepository.findByEmail(email);
        MarketingCoordinator marketingCoordinator = marketingCoordinatorRepository.findByEmail(email);

        User user = null;
        String userType = null;

        if (tourist != null && tourist.getFirstName().equals(firstName) && tourist.getLastName().equals(lastName) &&
                tourist.getNic().equals(nic) && tourist.getPhone().equals(phone)) {
            user = tourist;
            userType = "Tourist";
        } else if (boatDriver != null && boatDriver.getFirstName().equals(firstName) && boatDriver.getLastName().equals(lastName) &&
                boatDriver.getNic().equals(nic) && boatDriver.getPhone().equals(phone)) {
            user = boatDriver;
            userType = "BoatDriver";
        } else if (tourGuide != null && tourGuide.getFirstName().equals(firstName) && tourGuide.getLastName().equals(lastName) &&
                tourGuide.getNic().equals(nic) && tourGuide.getPhone().equals(phone)) {
            user = tourGuide;
            userType = "TourGuide";
        } else if (admin != null && admin.getFirstName().equals(firstName) && admin.getLastName().equals(lastName) &&
                admin.getNic().equals(nic) && admin.getPhone().equals(phone)) {
            user = admin;
            userType = "Admin";
        } else if (bookingManager != null && bookingManager.getFirstName().equals(firstName) && bookingManager.getLastName().equals(lastName) &&
                bookingManager.getNic().equals(nic) && bookingManager.getPhone().equals(phone)) {
            user = bookingManager;
            userType = "BookingManager";
        } else if (marketingCoordinator != null && marketingCoordinator.getFirstName().equals(firstName) && marketingCoordinator.getLastName().equals(lastName) &&
                marketingCoordinator.getNic().equals(nic) && marketingCoordinator.getPhone().equals(phone)) {
            user = marketingCoordinator;
            userType = "MarketingCoordinator";
        }

        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "No matching user found with the provided details.");
            return "redirect:/forgot-password";
        }

        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "New password and confirmation do not match.");
            return "redirect:/forgot-password";
        }

        // Update the password
        user.setPassword(newPassword);
        if (user instanceof Tourist) touristRepository.save((Tourist) user);
        else if (user instanceof BoatDriver) boatDriverRepository.save((BoatDriver) user);
        else if (user instanceof TourGuide) tourGuideRepository.save((TourGuide) user);
        else if (user instanceof Admin) adminRepository.save((Admin) user);
        else if (user instanceof BookingManager) bookingManagerRepository.save((BookingManager) user);
        else if (user instanceof MarketingCoordinator) marketingCoordinatorRepository.save((MarketingCoordinator) user);

        redirectAttributes.addFlashAttribute("success", "Password reset successfully. Please log in with your new password.");

        // Redirect based on user type
        switch (userType) {
            case "Admin":
                return "redirect:/admin/dashboard";
            case "BoatDriver":
                return "redirect:/boat-driver/dashboard";
            case "BookingManager":
                return "redirect:/booking-manager/dashboard";
            case "MarketingCoordinator":
                return "redirect:/marketing-coordinator/dashboard";
            case "TourGuide":
                return "redirect:/tour-guide/dashboard";
            default:
                return "redirect:/";
        }
    }
}