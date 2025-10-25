package com.boatsafari.controller;

import com.boatsafari.model.User;
import com.boatsafari.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminBookingsController {

    @Autowired
    private BookingRepository bookingRepository;

    @GetMapping("/admin/bookings")
    public String showBookings(HttpSession session, Model model) {
        if (isAdmin(session)) {
            model.addAttribute("bookings", bookingRepository.findAll());
            return "AdminBookings";
        } else {
            return "redirect:/login";
        }
    }

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "Admin".equalsIgnoreCase(user.getRole());
    }
}