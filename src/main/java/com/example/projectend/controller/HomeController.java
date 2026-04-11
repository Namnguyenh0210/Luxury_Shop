package com.example.projectend.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * HomeController — chỉ redirect về Vue SPA
 * API data được Vue fetch qua /api/...
 */
@Controller
public class HomeController {

    @GetMapping({"/", "/home", "/admin/**", "/staff/**", "/profile/**", "/checkout/**", "/payment/**", "/sanpham/**", "/kienthuc/**", "/blog/**", "/dangky", "/register"})
    public String home(jakarta.servlet.http.HttpServletRequest request) {
        return "redirect:http://localhost:5173" + request.getRequestURI();
    }
}
