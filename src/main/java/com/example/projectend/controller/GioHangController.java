package com.example.projectend.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.security.Principal;

/**
 * GioHangController — redirect về Vue SPA.
 * Cart API đã ở ApiController (/api/cart/...).
 */
@Controller
public class GioHangController {

    @GetMapping("/giohang")
    public String viewCart(Principal principal) {
        return "redirect:http://localhost:5173/giohang";
    }
}
