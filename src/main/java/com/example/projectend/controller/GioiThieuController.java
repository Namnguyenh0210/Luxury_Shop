package com.example.projectend.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * GioiThieuController — redirect về Vue SPA.
 */
@Controller
public class GioiThieuController {

    @GetMapping("/gioithieu")
    public String gioiThieu() {
        return "redirect:http://localhost:5173/gioithieu";
    }

    @GetMapping("/about")
    public String about() {
        return "redirect:http://localhost:5173/gioithieu";
    }
}
