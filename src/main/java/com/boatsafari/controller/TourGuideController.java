package com.boatsafari.controller;

import com.boatsafari.model.Review;
import com.boatsafari.model.TourGuide;
import com.boatsafari.model.Trip;
import com.boatsafari.model.Tourist;
import com.boatsafari.repository.ReviewRepository;
import com.boatsafari.repository.TripRepository;
import com.boatsafari.repository.TouristRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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
import java.time.LocalDate;
import java.util.List;

@Controller
public class TourGuideController {

    @Autowired
    private TripRepository tripRepository;
    @Autowired
    private ReviewRepository reviewRepository;
    @Autowired
    private TouristRepository touristRepository;

    @GetMapping("/tour-guide/add-feedbacks")
    public String showAddFeedbacks(@RequestParam("tripId") Long tripId, Model model, HttpSession session) {
        if (session.getAttribute("user") != null && session.getAttribute("user") instanceof TourGuide) {
            Trip trip = tripRepository.findById(tripId).orElse(null);
            if (trip != null) {
                TourGuide tourGuide = (TourGuide) session.getAttribute("user");
                List<Tourist> tourists = touristRepository.findAll();
                model.addAttribute("trip", trip);
                model.addAttribute("tourGuide", tourGuide);
                model.addAttribute("tourists", tourists);
                return "ReviewManagement";
            } else {
                return "redirect:/tour-guide/dashboard";
            }
        }
        return "redirect:/login";
    }

    @PostMapping("/tour-guide/save-feedback")
    public String saveFeedback(
            @RequestParam("tripId") Long tripId,
            @RequestParam("paragraph1") String paragraph1,
            @RequestParam("paragraph2") String paragraph2,
            @RequestParam("date") String date,
            @RequestParam("rating") int rating,
            @RequestParam("touristName") String touristName,
            @RequestParam("images") MultipartFile[] images,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (session.getAttribute("user") != null && session.getAttribute("user") instanceof TourGuide) {
            TourGuide tourGuide = (TourGuide) session.getAttribute("user");
            Trip trip = tripRepository.findById(tripId).orElse(null);

            if (trip != null) {
                try {
                    StringBuilder imageUrls = new StringBuilder();
                    if (images != null && images.length > 0) {
                        String uploadDir = "src/main/resources/static/uploads/";
                        Path uploadPath = Paths.get(uploadDir);

                        if (!Files.exists(uploadPath)) {
                            Files.createDirectories(uploadPath);
                        }

                        for (MultipartFile image : images) {
                            if (!image.isEmpty()) {
                                String fileName = System.currentTimeMillis() + "_" + image.getOriginalFilename();
                                Path filePath = uploadPath.resolve(fileName);
                                Files.copy(image.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                                if (imageUrls.length() > 0) imageUrls.append(",");
                                imageUrls.append("/uploads/" + fileName);
                            }
                        }
                    }

                    LocalDate reviewDate = LocalDate.parse(date);
                    Review review = new Review(tourGuide, trip, paragraph1, paragraph2, imageUrls.toString(), reviewDate, rating, touristName);
                    reviewRepository.save(review);
                    redirectAttributes.addFlashAttribute("success", "Feedback saved successfully!");
                } catch (IOException e) {
                    e.printStackTrace();
                    redirectAttributes.addFlashAttribute("error", "Failed to save feedback: " + e.getMessage());
                } catch (Exception e) {
                    e.printStackTrace();
                    redirectAttributes.addFlashAttribute("error", "Invalid date format or rating: " + e.getMessage());
                }
            } else {
                redirectAttributes.addFlashAttribute("error", "Trip not found.");
            }
            return "redirect:/tour-guide/dashboard";
        }
        return "redirect:/login";
    }

    @GetMapping("/tour-guide/edit-feedbacks")
    public String showEditFeedbacks(@RequestParam("tripId") Long tripId, Model model, HttpSession session) {
        if (session.getAttribute("user") != null && session.getAttribute("user") instanceof TourGuide) {
            TourGuide tourGuide = (TourGuide) session.getAttribute("user");
            Trip trip = tripRepository.findById(tripId).orElse(null);
            if (trip != null) {
                List<Review> reviews = reviewRepository.findByTourGuideAndTrip(tourGuide, trip);
                List<Tourist> tourists = touristRepository.findAll();
                model.addAttribute("trip", trip);
                model.addAttribute("reviews", reviews);
                model.addAttribute("tourGuide", tourGuide);
                model.addAttribute("tourists", tourists);
                return "EditReview";
            } else {
                return "redirect:/tour-guide/dashboard";
            }
        }
        return "redirect:/login";
    }

    @PostMapping("/tour-guide/update-feedback")
    public String updateFeedback(
            @RequestParam("reviewId") Long reviewId,
            @RequestParam("paragraph1") String paragraph1,
            @RequestParam("paragraph2") String paragraph2,
            @RequestParam("date") String date,
            @RequestParam("rating") int rating,
            @RequestParam("touristName") String touristName,
            @RequestParam("images") MultipartFile[] images,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (session.getAttribute("user") != null && session.getAttribute("user") instanceof TourGuide) {
            TourGuide tourGuide = (TourGuide) session.getAttribute("user");
            Review review = reviewRepository.findById(reviewId).orElse(null);

            if (review != null && review.getTourGuide().getId().equals(tourGuide.getId())) {
                try {
                    StringBuilder imageUrls = new StringBuilder(review.getImageUrls() != null ? review.getImageUrls() : "");
                    if (images != null && images.length > 0) {
                        String uploadDir = "src/main/resources/static/uploads/";
                        Path uploadPath = Paths.get(uploadDir);

                        if (!Files.exists(uploadPath)) {
                            Files.createDirectories(uploadPath);
                        }

                        for (MultipartFile image : images) {
                            if (!image.isEmpty()) {
                                String fileName = System.currentTimeMillis() + "_" + image.getOriginalFilename();
                                Path filePath = uploadPath.resolve(fileName);
                                Files.copy(image.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                                if (imageUrls.length() > 0) imageUrls.append(",");
                                imageUrls.append("/uploads/" + fileName);
                            }
                        }
                    }

                    LocalDate reviewDate = LocalDate.parse(date);
                    review.setParagraph1(paragraph1);
                    review.setParagraph2(paragraph2);
                    review.setDate(reviewDate);
                    review.setRating(rating);
                    review.setTouristName(touristName);
                    if (imageUrls.length() > 0) review.setImageUrls(imageUrls.toString());
                    reviewRepository.save(review);
                    redirectAttributes.addFlashAttribute("success", "Feedback updated successfully!");
                } catch (IOException e) {
                    e.printStackTrace();
                    redirectAttributes.addFlashAttribute("error", "Failed to update feedback: " + e.getMessage());
                } catch (Exception e) {
                    e.printStackTrace();
                    redirectAttributes.addFlashAttribute("error", "Invalid date format or rating: " + e.getMessage());
                }
            } else {
                redirectAttributes.addFlashAttribute("error", "Review not found or unauthorized.");
            }
            return "redirect:/tour-guide/dashboard";
        }
        return "redirect:/login";
    }

    @GetMapping("/tour-guide/delete-feedback")
    public String deleteFeedback(@RequestParam("reviewId") Long reviewId, HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("user") != null && session.getAttribute("user") instanceof TourGuide) {
            TourGuide tourGuide = (TourGuide) session.getAttribute("user");
            Review review = reviewRepository.findById(reviewId).orElse(null);
            if (review != null && review.getTourGuide().getId().equals(tourGuide.getId())) {
                reviewRepository.delete(review);
                redirectAttributes.addFlashAttribute("success", "Feedback deleted successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Review not found or unauthorized.");
            }
        }
        return "redirect:/tour-guide/dashboard";
    }

    @GetMapping("/reviews")
    public String showReviews(Model model, HttpSession session) {
        if (session.getAttribute("user") != null) {
            List<Trip> trips = tripRepository.findAll();
            model.addAttribute("trips", trips);
            return "TouristReviews";
        }
        return "redirect:/login";
    }

    @GetMapping("/view-reviews")
    public String viewReviews(@RequestParam("tripId") Long tripId, Model model, HttpSession session) {
        if (session.getAttribute("user") != null) {
            Trip trip = tripRepository.findById(tripId).orElse(null);
            if (trip != null) {
                TourGuide tourGuide = trip.getTourGuide(); // Fetch TourGuide from Trip
                if (tourGuide == null) {
                    // Fallback: Try to get TourGuide from the first review if available
                    List<Review> reviews = reviewRepository.findByTrip(trip);
                    if (!reviews.isEmpty()) {
                        tourGuide = reviews.get(0).getTourGuide();
                    }
                }
                List<Review> reviews = reviewRepository.findByTrip(trip);
                model.addAttribute("trip", trip);
                model.addAttribute("tourGuide", tourGuide); // Pass tourGuide to JSP
                model.addAttribute("reviews", reviews);
                return "TouristViewReviews";
            } else {
                return "redirect:/reviews";
            }
        }
        return "redirect:/login";
    }
}