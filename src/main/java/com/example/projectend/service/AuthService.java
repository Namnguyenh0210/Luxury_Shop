package com.example.projectend.service;

import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.TaiKhoanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.Optional;

/**
 * Service xử lý thông tin người dùng đã đăng nhập
 */
@Service
public class AuthService {

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    /**
     * Lấy thông tin tài khoản đang đăng nhập
     * @return TaiKhoan hoặc null nếu chưa đăng nhập
     */
    public TaiKhoan getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated() ||
            authentication.getPrincipal().equals("anonymousUser")) {
            return null;
        }

        String email = authentication.getName();
        Optional<TaiKhoan> taiKhoan = taiKhoanRepository.findByEmail(email);

        return taiKhoan.orElse(null);
    }

    /**
     * Kiểm tra xem user có đăng nhập hay không
     * @return true nếu đã đăng nhập
     */
    public boolean isAuthenticated() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null &&
               authentication.isAuthenticated() &&
               !authentication.getPrincipal().equals("anonymousUser");
    }

    /**
     * Lấy email của user đang đăng nhập
     * @return Email hoặc null
     */
    public String getCurrentUserEmail() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            return authentication.getName();
        }
        return null;
    }

    /**
     * Kiểm tra xem user có role cụ thể hay không
     * @param role Tên role (ví dụ: "ADMIN", "NHANVIEN", "KHACHHANG")
     * @return true nếu có role
     */
    public boolean hasRole(String role) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return false;
        }
        return authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_" + role));
    }

    /**
     * Kiểm tra xem user có phải Admin không
     * @return true nếu là admin
     */
    public boolean isAdmin() {
        return hasRole("ADMIN");
    }

    /**
     * Kiểm tra xem user có phải Nhân viên không
     * @return true nếu là nhân viên
     */
    public boolean isStaff() {
        return hasRole("NHANVIEN");
    }

    /**
     * Kiểm tra xem user có phải Khách hàng không
     * @return true nếu là khách hàng
     */
    public boolean isCustomer() {
        return hasRole("KHACHHANG");
    }
}

