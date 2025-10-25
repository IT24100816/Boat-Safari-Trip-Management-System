package com.boatsafari.controller;

import com.boatsafari.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            model.addAttribute("username", user.getFirstName() + " " + user.getLastName());
        }
        return "index"; // Resolves to /WEB-INF/jsp/index.jsp or similar
    }
}