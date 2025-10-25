package com.boatsafari.controller;

import com.boatsafari.model.Promotion;
import com.boatsafari.model.User;
import com.boatsafari.repository.PromotionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.Optional;

@Controller
public class AdminPromotionsController {

    @Autowired
    private PromotionRepository promotionRepository;

    @GetMapping("/admin/promotions")
    public String showPromotions(HttpSession session, Model model) {
        if (isAdmin(session)) {
            model.addAttribute("promotions", promotionRepository.findAll());
            return "AdminPromotions";
        } else {
            return "redirect:/login";
        }
    }

    @PostMapping("/admin/promotions/remove/{id}")
    public String removePromotion(@PathVariable Long id, HttpSession session, Model model) {
        if (isAdmin(session)) {
            Optional<Promotion> promotion = promotionRepository.findById(id);
            if (promotion.isPresent()) {
                promotionRepository.delete(promotion.get());
                model.addAttribute("successMessage", "Promotion removed successfully!");
            } else {
                model.addAttribute("errorMessage", "Promotion not found.");
            }
            model.addAttribute("promotions", promotionRepository.findAll());
            return "AdminPromotions";
        } else {
            return "redirect:/login";
        }
    }

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "Admin".equalsIgnoreCase(user.getRole());
    }
}