package com.boatsafari.controller;

import com.boatsafari.model.Boat;
import com.boatsafari.model.ConfirmedBooking;
import com.boatsafari.model.ConfirmedBookingDTO;
import com.boatsafari.model.User;
import com.boatsafari.repository.ConfirmedBookingRepository;
import com.boatsafari.repository.BoatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
public class NotificationController {

    @Autowired
    private ConfirmedBookingRepository confirmedBookingRepository;

    @Autowired
    private BoatRepository boatRepository;

    @GetMapping("/notifications")
    public String showConfirmedBookings(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            String touristName = user.getFirstName() + " " + user.getLastName(); // Proxy for touristName
            List<ConfirmedBooking> confirmedBookings = confirmedBookingRepository.findByTouristName(touristName);

            // Convert to DTO with boat image URL
            List<ConfirmedBookingDTO> dtoBookings = new ArrayList<>();
            for (ConfirmedBooking booking : confirmedBookings) {
                Boat boat = boatRepository.findByBoatName(booking.getBoatName());
                dtoBookings.add(new ConfirmedBookingDTO(booking, boat));
            }

            model.addAttribute("confirmedBookings", dtoBookings);
            return "ConfirmedBookings";
        } else {
            return "redirect:/login";
        }
    }
}