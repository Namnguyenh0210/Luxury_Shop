package com.example.projectend.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SpaController {

    // Bắt các route Vue cụ thể
    @RequestMapping(value = {
            "/login",
            "/register",
            "/dang-ky",
            "/forgot-password",
            "/verify-otp",
            "/reset-password"
    })
    public String redirectToVue() {
        return "forward:/index.html";
    }

    // Bắt tất cả route khác, không phải file tĩnh
    @RequestMapping(value = "/{path:^(?!.*\\..*).*}")
    public String redirectToVueAll() {
        return "forward:/index.html";
    }
}