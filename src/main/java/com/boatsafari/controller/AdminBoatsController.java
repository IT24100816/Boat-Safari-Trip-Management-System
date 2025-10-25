package com.boatsafari.controller;

import com.boatsafari.model.User;
import com.boatsafari.repository.BoatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminBoatsController {

    @Autowired
    private BoatRepository boatRepository;

    @GetMapping("/admin/boats")
    public String showBoats(HttpSession session, Model model) {
        if (isAdmin(session)) {
            model.addAttribute("boats", boatRepository.findAll());
            return "AdminBoats";
        } else {
            return "redirect:/login";
        }
    }

    @PostMapping("/admin/boats/remove")
    public String removeBoat(@RequestParam("id") Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (isAdmin(session)) {
            try {
                boatRepository.deleteById(id);
                redirectAttributes.addFlashAttribute("successMessage", "Boat removed successfully!");
            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("errorMessage", "Error removing boat: " + e.getMessage());
            }
            return "redirect:/admin/boats";
        } else {
            return "redirect:/login";
        }
    }

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "Admin".equalsIgnoreCase(user.getRole());
    }
}