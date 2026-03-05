package com.example.projectend.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * HomeController — chỉ redirect về Vue SPA
 * API data được Vue fetch qua /api/...
 */
@Controller
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "redirect:http://localhost:5173/";
    }

    @GetMapping("/home")
    public String homePage() {
        return "redirect:http://localhost:5173/";
    }
}
