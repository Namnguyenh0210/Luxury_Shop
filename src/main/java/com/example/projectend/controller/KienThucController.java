package com.example.projectend.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * KienThucController — redirect về Vue SPA.
 * Blog API đã ở ApiController (/api/blog/...).
 */
@Controller
public class KienThucController {

    @GetMapping("/kienthuc")
    public String kienThuc(HttpServletRequest req) {
        String qs = req.getQueryString();
        String target = "http://localhost:5173/kienthuc";
        if (qs != null && !qs.isEmpty())
            target += "?" + qs;
        return "redirect:" + target;
    }

    @GetMapping("/kienthuc/{id}")
    public String chiTietBaiViet(@PathVariable Long id) {
        return "redirect:http://localhost:5173/kienthuc/" + id;
    }

    @GetMapping("/kienthuc/search")
    public String timKiemBaiViet(@RequestParam(required = false) String keyword,
            HttpServletRequest req) {
        String qs = req.getQueryString();
        String target = "http://localhost:5173/kienthuc";
        if (qs != null && !qs.isEmpty())
            target += "?" + qs;
        return "redirect:" + target;
    }

    // Blog aliases
    @GetMapping("/blog")
    public String blog(HttpServletRequest req) {
        String qs = req.getQueryString();
        String target = "http://localhost:5173/blog";
        if (qs != null && !qs.isEmpty())
            target += "?" + qs;
        return "redirect:" + target;
    }

    @GetMapping("/blog/{id}")
    public String blogDetail(@PathVariable Long id) {
        return "redirect:http://localhost:5173/blog/" + id;
    }
}
