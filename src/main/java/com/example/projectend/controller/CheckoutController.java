package com.example.projectend.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;

/**
 * CheckoutController — chỉ redirect về Vue SPA
 * Toàn bộ logic checkout đã chuyển sang ApiController (/api/checkout)
 * Vue frontend tự xử lý UI và gọi API.
 */
@Controller
@RequestMapping("/checkout")
public class CheckoutController {

    /**
     * GET /checkout — Vue Router xử lý, redirect về SPA
     */
    @GetMapping("")
    public String checkout(Principal principal) {
        if (principal == null) {
            return "redirect:http://localhost:5173/login";
        }
        return "redirect:http://localhost:5173/checkout";
    }

    /**
     * POST /checkout/place-order — không còn dùng
     * Vue gọi /api/checkout/place-order thay thế
     */
    @PostMapping("/place-order")
    public String processCheckout(Principal principal) {
        if (principal == null) {
            return "redirect:http://localhost:5173/login";
        }
        return "redirect:http://localhost:5173/checkout";
    }

    /**
     * GET /checkout/success — redirect về Vue /checkout-success
     */
    @GetMapping("/success")
    public String checkoutSuccess(@RequestParam(required = false) Long orderId,
            Principal principal) {
        if (principal == null) {
            return "redirect:http://localhost:5173/login";
        }
        String idParam = orderId != null ? "?orderId=" + orderId : "";
        return "redirect:http://localhost:5173/checkout-success" + idParam;
    }
}
