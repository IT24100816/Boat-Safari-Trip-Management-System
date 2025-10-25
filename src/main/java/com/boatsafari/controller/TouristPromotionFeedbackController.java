package com.boatsafari.controller;

import com.boatsafari.model.Promotion;
import com.boatsafari.model.PromotionFeedback;
import com.boatsafari.model.Tourist;
import com.boatsafari.repository.PromotionFeedbackRepository;
import com.boatsafari.repository.PromotionRepository;
import com.boatsafari.repository.TouristRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/tourist/feedback")
public class TouristPromotionFeedbackController {

    @Autowired
    private PromotionFeedbackRepository feedbackRepository;

    @Autowired
    private PromotionRepository promotionRepository;

    @Autowired
    private TouristRepository touristRepository;

    @GetMapping
    public String showFeedbackForm(@RequestParam("promotionId") Long promotionId, Model model, HttpSession session) {
        Tourist tourist = (Tourist) session.getAttribute("user");
        if (tourist == null) {
            return "redirect:/login";
        }

        Promotion promotion = promotionRepository.findById(promotionId)
                .orElseThrow(() -> new IllegalArgumentException("Promotion not found"));
        List<PromotionFeedback> feedbacks = feedbackRepository.findByPromotionId(promotionId);

        model.addAttribute("promotion", promotion);
        model.addAttribute("feedbacks", feedbacks);
        return "TouristPromotionFeedback";
    }

    @PostMapping("/add")
    public String addFeedback(@RequestParam("promotionId") Long promotionId,
                              @RequestParam("feedback") String feedbackText,
                              @RequestParam("rating") int rating,
                              HttpSession session, Model model) {
        Tourist tourist = (Tourist) session.getAttribute("user");
        if (tourist == null) {
            return "redirect:/login";
        }

        System.out.println("=== ADD FEEDBACK DEBUG ===");
        System.out.println("Received rating: " + rating);
        System.out.println("Received feedback: " + feedbackText);
        System.out.println("Promotion ID: " + promotionId);

        Promotion promotion = promotionRepository.findById(promotionId)
                .orElseThrow(() -> new IllegalArgumentException("Promotion not found"));

        // Validation
        if (rating < 1 || rating > 5) {
            model.addAttribute("error", "Rating must be between 1 and 5 stars.");
            return loadFeedbackPage(model, promotionId, session);
        }

        if (feedbackText == null || feedbackText.trim().isEmpty()) {
            model.addAttribute("error", "Feedback text is required.");
            return loadFeedbackPage(model, promotionId, session);
        }

        try {
            PromotionFeedback feedback = new PromotionFeedback();
            feedback.setTourist(tourist);
            feedback.setPromotion(promotion);
            feedback.setFeedback(feedbackText.trim());
            feedback.setRating(rating);
            feedback.setTripId(promotion.getTripId() != null ? promotion.getTripId() : 0L);
            feedback.setCreatedAt(LocalDateTime.now());

            PromotionFeedback savedFeedback = feedbackRepository.save(feedback);
            System.out.println("=== FEEDBACK SAVED SUCCESSFULLY ===");
            System.out.println("Feedback ID: " + savedFeedback.getId());
            System.out.println("Rating saved: " + savedFeedback.getRating());
            System.out.println("Feedback text saved: " + savedFeedback.getFeedback());

        } catch (Exception e) {
            System.out.println("=== ERROR SAVING FEEDBACK ===");
            e.printStackTrace();
            model.addAttribute("error", "Failed to save feedback: " + e.getMessage());
            return loadFeedbackPage(model, promotionId, session);
        }

        return "redirect:/tourist/feedback?promotionId=" + promotionId;
    }

    @PostMapping("/update/{feedbackId}")
    public String updateFeedback(@PathVariable Long feedbackId,
                                 @RequestParam("promotionId") Long promotionId,
                                 @RequestParam("feedback") String feedbackText,
                                 @RequestParam("rating") int rating,
                                 HttpSession session) {
        Tourist tourist = (Tourist) session.getAttribute("user");
        if (tourist == null) {
            return "redirect:/login";
        }

        System.out.println("=== UPDATE FEEDBACK DEBUG ===");
        System.out.println("Feedback ID: " + feedbackId);
        System.out.println("Received rating: " + rating);
        System.out.println("Received feedback: " + feedbackText);

        PromotionFeedback feedback = feedbackRepository.findById(feedbackId)
                .orElseThrow(() -> new IllegalArgumentException("Feedback not found"));

        if (!feedback.getTourist().getId().equals(tourist.getId())) {
            return "redirect:/tourist/feedback?promotionId=" + promotionId + "&error=You can only edit your own feedback.";
        }

        if (rating < 1 || rating > 5) {
            return "redirect:/tourist/feedback?promotionId=" + promotionId + "&error=Rating must be between 1 and 5 stars.";
        }

        if (feedbackText == null || feedbackText.trim().isEmpty()) {
            return "redirect:/tourist/feedback?promotionId=" + promotionId + "&error=Feedback text is required.";
        }

        try {
            feedback.setFeedback(feedbackText.trim());
            feedback.setRating(rating);
            PromotionFeedback updatedFeedback = feedbackRepository.save(feedback);

            System.out.println("=== FEEDBACK UPDATED SUCCESSFULLY ===");
            System.out.println("Updated rating: " + updatedFeedback.getRating());
            System.out.println("Updated feedback: " + updatedFeedback.getFeedback());

        } catch (Exception e) {
            System.out.println("=== ERROR UPDATING FEEDBACK ===");
            e.printStackTrace();
            return "redirect:/tourist/feedback?promotionId=" + promotionId + "&error=Failed to update feedback: " + e.getMessage();
        }

        return "redirect:/tourist/feedback?promotionId=" + promotionId;
    }

    @GetMapping("/delete/{feedbackId}")
    public String deleteFeedback(@PathVariable Long feedbackId, @RequestParam("promotionId") Long promotionId,
                                 HttpSession session) {
        Tourist tourist = (Tourist) session.getAttribute("user");
        if (tourist == null) {
            return "redirect:/login";
        }

        PromotionFeedback feedback = feedbackRepository.findById(feedbackId)
                .orElseThrow(() -> new IllegalArgumentException("Feedback not found"));
        if (!feedback.getTourist().getId().equals(tourist.getId())) {
            return "redirect:/tourist/feedback?promotionId=" + promotionId + "&error=You can only delete your own feedback.";
        }

        feedbackRepository.delete(feedback);
        return "redirect:/tourist/feedback?promotionId=" + promotionId;
    }

    // Helper method to load feedback page data
    private String loadFeedbackPage(Model model, Long promotionId, HttpSession session) {
        Tourist tourist = (Tourist) session.getAttribute("user");
        Promotion promotion = promotionRepository.findById(promotionId)
                .orElseThrow(() -> new IllegalArgumentException("Promotion not found"));
        List<PromotionFeedback> feedbacks = feedbackRepository.findByPromotionId(promotionId);

        model.addAttribute("promotion", promotion);
        model.addAttribute("feedbacks", feedbacks);
        return "TouristPromotionFeedback";
    }
}