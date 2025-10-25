package com.boatsafari.controller;

import com.boatsafari.model.Admin;
import com.boatsafari.model.User;
import com.boatsafari.repository.AdminRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.Optional;

@Controller
public class AdminProfileController {

    @Autowired
    private AdminRepository adminRepository;

    @GetMapping("/admin/profile")
    public String showProfile(HttpSession session, Model model) {
        if (isAdmin(session)) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                Optional<Admin> admin = adminRepository.findById(user.getId());
                model.addAttribute("admin", admin.orElse(null));
            }
            return "AdminProfile";
        } else {
            return "redirect:/login";
        }
    }

    @PostMapping("/admin/profile/edit")
    public String editProfile(@ModelAttribute Admin admin, HttpSession session, Model model) {
        if (isAdmin(session)) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                Optional<Admin> existingAdmin = adminRepository.findById(user.getId());
                if (existingAdmin.isPresent()) {
                    Admin currentAdmin = existingAdmin.get();
                    currentAdmin.setFirstName(admin.getFirstName());
                    currentAdmin.setLastName(admin.getLastName());
                    currentAdmin.setNic(admin.getNic());
                    currentAdmin.setEmail(admin.getEmail());
                    currentAdmin.setPassword(admin.getPassword()); // Update password
                    currentAdmin.setPhone(admin.getPhone());
                    currentAdmin.setAge(admin.getAge());
                    adminRepository.save(currentAdmin);
                    model.addAttribute("successMessage", "Profile updated successfully!");
                }
            }
            return "redirect:/admin/profile";
        } else {
            return "redirect:/login";
        }
    }

    @PostMapping("/admin/profile/delete")
    public String deleteProfile(@RequestParam String confirmPassword, HttpSession session, Model model) {
        if (isAdmin(session)) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                Optional<Admin> admin = adminRepository.findById(user.getId());
                if (admin.isPresent() && admin.get().getPassword().equals(confirmPassword)) {
                    adminRepository.delete(admin.get());
                    session.invalidate(); // Log out the admin
                    return "redirect:/login?message=Account deleted successfully";
                } else {
                    model.addAttribute("errorMessage", "Incorrect password or account not found.");
                    return "redirect:/admin/profile";
                }
            }
        }
        return "redirect:/login";
    }

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "Admin".equalsIgnoreCase(user.getRole());
    }
}