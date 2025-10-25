package com.boatsafari.controller;

import com.boatsafari.model.MarketingCoordinator;
import com.boatsafari.model.Promotion;
import com.boatsafari.model.PromotionFeedback;
import com.boatsafari.model.Trip;
import com.boatsafari.repository.MarketingCoordinatorRepository;
import com.boatsafari.repository.PromotionRepository;
import com.boatsafari.repository.TripRepository;
import com.boatsafari.repository.PromotionFeedbackRepository;
import com.boatsafari.pattern.PromotionContext;
import com.boatsafari.pattern.CombinedDiscountStrategy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

@Controller
public class MarketingCoordinatorController {

    @Autowired
    private MarketingCoordinatorRepository marketingCoordinatorRepository;
    @Autowired
    private TripRepository tripRepository;
    @Autowired
    private PromotionRepository promotionRepository;
    @Autowired
    private PromotionFeedbackRepository promotionFeedbackRepository;

    @GetMapping("/marketing-trips")
    public String showMarketingTrips(HttpSession session, Model model) {
        if (session.getAttribute("user") != null && session.getAttribute("user") instanceof MarketingCoordinator) {
            model.addAttribute("trips", tripRepository.findAll());
            return "MarketingTrips";
        } else {
            return "redirect:/login";
        }
    }

    @GetMapping("/add-promotion")
    public String showAddPromotion(@RequestParam("tripId") Long tripId, Model model, HttpSession session) {
        if (session.getAttribute("user") != null && session.getAttribute("user") instanceof MarketingCoordinator) {
            Trip trip = tripRepository.findById(tripId).orElse(null);
            if (trip != null) {
                model.addAttribute("trip", trip);
                return "AddPromotion";
            }
            return "redirect:/marketing-trips";
        }
        return "redirect:/login";
    }

    @PostMapping("/submit-promotion")
    public String submitPromotion(
            @RequestParam("tripId") Long tripId,
            @RequestParam("tripName") String tripName,
            @RequestParam("passengers") int passengers,
            @RequestParam("hours") int hours,
            @RequestParam("discountPercentage") double discountPercentage,
            @RequestParam("promotionImage") MultipartFile promotionImage,
            HttpSession session,
            RedirectAttributes redirectAttributes) throws IOException {

        if (session.getAttribute("user") != null && session.getAttribute("user") instanceof MarketingCoordinator) {
            String imageUrl = null;
            if (!promotionImage.isEmpty()) {
                try {
                    String fileName = System.currentTimeMillis() + "_" + promotionImage.getOriginalFilename();
                    String uploadDir = "src/main/resources/static/uploads/promotions/";
                    Path uploadPath = Paths.get(uploadDir);
                    if (!Files.exists(uploadPath)) {
                        Files.createDirectories(uploadPath);
                    }
                    Path filePath = uploadPath.resolve(fileName);
                    Files.copy(promotionImage.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                    imageUrl = "/uploads/promotions/" + fileName;
                } catch (IOException e) {
                    redirectAttributes.addFlashAttribute("error", "Failed to upload promotion image: " + e.getMessage());
                    return "redirect:/add-promotion?tripId=" + tripId;
                }
            }

            Promotion promotion = new Promotion();
            promotion.setTripId(tripId);
            promotion.setTripName(tripName);
            promotion.setPassengers(passengers);
            promotion.setHours(hours);

            // Calculate total discount using Strategy Pattern
            Trip trip = tripRepository.findById(tripId).orElse(null);
            if (trip != null) {
                PromotionContext context = new PromotionContext();
                context.setDiscountStrategy(new CombinedDiscountStrategy());
                double totalDiscountPercentage = context.getTotalDiscountPercentage(discountPercentage, trip, passengers, hours);
                promotion.setDiscountPercentage(totalDiscountPercentage);
            } else {
                promotion.setDiscountPercentage(discountPercentage); // Fallback if trip not found
            }

            promotion.setImageUrl(imageUrl);
            promotionRepository.save(promotion);

            redirectAttributes.addFlashAttribute("success", "Promotion added successfully!");
            return "redirect:/marketing-trips";
        }
        return "redirect:/login";
    }

    @GetMapping("/view-promotions")
    public String viewPromotions(HttpSession session, Model model) {
        if (session.getAttribute("user") != null && session.getAttribute("user") instanceof MarketingCoordinator) {
            model.addAttribute("promotions", promotionRepository.findAll());
            return "ViewPromotion";
        }
        return "redirect:/login";
    }

    @PostMapping("/delete-promotion")
    public String deletePromotion(
            @RequestParam("promotionId") Long promotionId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (session.getAttribute("user") != null && session.getAttribute("user") instanceof MarketingCoordinator) {
            Promotion promotion = promotionRepository.findById(promotionId).orElse(null);
            if (promotion != null) {
                promotionRepository.delete(promotion);
                redirectAttributes.addFlashAttribute("success", "Promotion removed successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Promotion not found.");
            }
            return "redirect:/view-promotions";
        }
        return "redirect:/login";
    }

    @GetMapping("/update-promotion")
    public String showUpdatePromotion(@RequestParam("promotionId") Long promotionId, Model model, HttpSession session) {
        if (session.getAttribute("user") != null && session.getAttribute("user") instanceof MarketingCoordinator) {
            Promotion promotion = promotionRepository.findById(promotionId).orElse(null);
            if (promotion != null) {
                model.addAttribute("promotion", promotion);
                return "UpdatePromotion";
            }
            return "redirect:/view-promotions";
        }
        return "redirect:/login";
    }

    @PostMapping("/submit-update-promotion")
    public String submitUpdatePromotion(
            @RequestParam("promotionId") Long promotionId,
            @RequestParam("passengers") int passengers,
            @RequestParam("hours") int hours,
            @RequestParam("discountPercentage") double discountPercentage,
            @RequestParam("promotionImage") MultipartFile promotionImage,
            HttpSession session,
            RedirectAttributes redirectAttributes) throws IOException {

        if (session.getAttribute("user") != null && session.getAttribute("user") instanceof MarketingCoordinator) {
            Promotion promotion = promotionRepository.findById(promotionId).orElse(null);
            if (promotion != null) {
                String imageUrl = promotion.getImageUrl();
                if (!promotionImage.isEmpty()) {
                    try {
                        String fileName = System.currentTimeMillis() + "_" + promotionImage.getOriginalFilename();
                        String uploadDir = "src/main/resources/static/uploads/promotions/";
                        Path uploadPath = Paths.get(uploadDir);
                        if (!Files.exists(uploadPath)) {
                            Files.createDirectories(uploadPath);
                        }
                        Path filePath = uploadPath.resolve(fileName);
                        Files.copy(promotionImage.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                        imageUrl = "/uploads/promotions/" + fileName;
                    } catch (IOException e) {
                        redirectAttributes.addFlashAttribute("error", "Failed to upload promotion image: " + e.getMessage());
                        return "redirect:/update-promotion?promotionId=" + promotionId;
                    }
                }

                promotion.setPassengers(passengers);
                promotion.setHours(hours);

                // Update total discount using Strategy Pattern
                Trip trip = tripRepository.findById(promotion.getTripId()).orElse(null);
                if (trip != null) {
                    PromotionContext context = new PromotionContext();
                    context.setDiscountStrategy(new CombinedDiscountStrategy());
                    double totalDiscountPercentage = context.getTotalDiscountPercentage(discountPercentage, trip, passengers, hours);
                    promotion.setDiscountPercentage(totalDiscountPercentage);
                } else {
                    promotion.setDiscountPercentage(discountPercentage); // Fallback if trip not found
                }

                promotion.setImageUrl(imageUrl);
                promotionRepository.save(promotion);

                redirectAttributes.addFlashAttribute("success", "Promotion updated successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Promotion not found.");
            }
            return "redirect:/view-promotions";
        }
        return "redirect:/login";
    }

    @GetMapping("/tourist-view-promotions")
    public String touristViewPromotions(HttpSession session, Model model) {
        if (session.getAttribute("user") != null) {
            model.addAttribute("promotions", promotionRepository.findAll());
            return "TouristViewPromotion";
        }
        return "redirect:/login";
    }

    @GetMapping("/marketing-feedbacks")
    public String viewAllFeedbacks(HttpSession session, Model model) {
        if (session.getAttribute("user") != null && session.getAttribute("user") instanceof MarketingCoordinator) {
            List<PromotionFeedback> feedbacks = promotionFeedbackRepository.findAllWithTourist();
            model.addAttribute("feedbacks", feedbacks);
            return "MarketingCoordinatorFeedback";
        }
        return "redirect:/login";
    }

    @PostMapping("/delete-feedback")
    public String deleteFeedback(
            @RequestParam("feedbackId") Long feedbackId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (session.getAttribute("user") != null && session.getAttribute("user") instanceof MarketingCoordinator) {
            PromotionFeedback feedback = promotionFeedbackRepository.findById(feedbackId).orElse(null);
            if (feedback != null) {
                promotionFeedbackRepository.delete(feedback);
                redirectAttributes.addFlashAttribute("success", "Feedback deleted successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Feedback not found.");
            }
            return "redirect:/marketing-feedbacks";
        }
        return "redirect:/login";
    }
}