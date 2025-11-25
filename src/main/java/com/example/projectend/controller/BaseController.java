package com.example.projectend.controller;

import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;

/**
 * Base Controller - Tự động thêm currentUser vào tất cả các view
 * Tất cả controller khác nên extend từ class này
 */
public abstract class BaseController {

    @Autowired
    protected AuthService authService;

    /**
     * Tự động thêm thông tin user vào model cho tất cả request
     */
    @ModelAttribute
    public void addCurrentUserToModel(Model model) {
        TaiKhoan currentUser = authService.getCurrentUser();
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("isAuthenticated", authService.isAuthenticated());
        model.addAttribute("isAdmin", authService.isAdmin());
        model.addAttribute("isStaff", authService.isStaff());
        model.addAttribute("isCustomer", authService.isCustomer());
    }
}

