package com.example.projectend.config;

import com.example.projectend.service.auth.CustomOAuth2UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

/**
 * SECURITY CONFIG - ASM WEB BÁN HÀNG
 * ĐĂNG NHẬP BẰNG EMAIL + MẬT KHẨU PLAIN TEXT + GOOGLE OAUTH2
 * <p>
 * PHÂN QUYỀN (theo SQL):
 * - ROLE_ADMIN: Quản trị viên
 * - ROLE_NHANVIEN: Nhân viên
 * - ROLE_KHACHHANG: Khách hàng
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private CustomOAuth2UserService customOAuth2UserService;

    @Bean
    public PasswordEncoder passwordEncoder() {
        // TẠM THỜI: dùng plain-text để đăng nhập nhanh với mật khẩu "123" trong DB
        // Lưu ý: KHÔNG dùng NoOpPasswordEncoder cho môi trường thật.
        return org.springframework.security.crypto.password.NoOpPasswordEncoder.getInstance();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        // ==================== PUBLIC ====================
                        .requestMatchers("/", "/home", "/sanpham", "/sanpham/**").permitAll()
                        .requestMatchers("/gioithieu", "/kienthuc", "/lienhe").permitAll()
                        .requestMatchers("/login", "/perform-login", "/register", "/403").permitAll()
                        .requestMatchers("/css/**", "/js/**", "/img/**", "/images/**", "/static/**").permitAll()
                        .requestMatchers("/api/public/**").permitAll()
                        .requestMatchers("/api/user/role").authenticated()
                        .requestMatchers("/error").permitAll()
                        .requestMatchers("/brand/**", "/nam", "/nu", "/unisex").permitAll()

                        // ==================== GIỎ HÀNG ====================
                        .requestMatchers("/giohang", "/giohang/**").permitAll()

                        // ==================== PAYOS PAYMENT ====================
                        // Webhook từ PayOS phải public (không cần authentication)
                        .requestMatchers("/payment/payos/webhook").permitAll()
                        // Các endpoint PayOS khác cần đăng nhập
                        .requestMatchers("/payment/payos/**").authenticated()

                        // ==================== PHÂN QUYỀN STAFF (CHỈ NHÂN VIÊN) ====================
                        .requestMatchers("/staff/**").hasRole("NHANVIEN")

                        // ==================== PHÂN QUYỀN ADMIN (CHỈ ADMIN) ====================
                        // Admin Dashboard, Sản phẩm, Tài khoản, Báo cáo - CHỈ ADMIN
                        .requestMatchers("/admin/dashboard", "/admin/sanpham/**", "/admin/accounts/**",
                                "/admin/reports/**")
                        .hasRole("ADMIN")

                        // Đơn hàng và Bài viết - CẢ ADMIN VÀ NHÂN VIÊN đều vào được
                        .requestMatchers("/admin/orders/**", "/admin/baiviet/**").hasAnyRole("ADMIN", "NHANVIEN")

                        // ==================== PHẢI ĐĂNG NHẬP ====================
                        .requestMatchers("/checkout", "/checkout/**").authenticated()
                        .requestMatchers("/profile", "/profile/**").authenticated()

                        // ==================== CÒN LẠI ====================
                        .anyRequest().permitAll())
                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        .usernameParameter("username")
                        .passwordParameter("password")
                        .successHandler((request, response, authentication) -> {
                            // Cập nhật lastLogin
                            String email = authentication.getName();
                            System.out.println("=== LOGIN SUCCESS ===");
                            System.out.println("User: " + email);
                            System.out.println("Authorities: " + authentication.getAuthorities());

                            // Điều hướng theo vai trò sau khi đăng nhập
                            boolean isAdmin = authentication.getAuthorities().stream()
                                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
                            boolean isStaff = authentication.getAuthorities().stream()
                                    .anyMatch(a -> a.getAuthority().equals("ROLE_NHANVIEN"));

                            System.out.println("Is Admin: " + isAdmin);
                            System.out.println("Is Staff: " + isStaff);

                            if (isAdmin) {
                                System.out.println("Redirecting to: /admin/dashboard");
                                response.sendRedirect("/admin/dashboard");
                            } else if (isStaff) {
                                System.out.println("Redirecting to: /staff/dashboard");
                                response.sendRedirect("/staff/dashboard");
                            } else {
                                System.out.println("Redirecting to: /");
                                response.sendRedirect("/");
                            }
                        })
                        .failureUrl("/login?error=true")
                        .permitAll())
                .oauth2Login(oauth2 -> oauth2
                        .loginPage("/login")
                        .userInfoEndpoint(userInfo -> userInfo
                                .userService(customOAuth2UserService))
                        .successHandler((request, response, authentication) -> {
                            // Xử lý sau khi đăng nhập Google thành công
                            System.out.println("=== OAUTH2 LOGIN SUCCESS ===");
                            System.out.println("User: " + authentication.getName());
                            System.out.println("Authorities: " + authentication.getAuthorities());

                            // OAuth2 user luôn là KHACHHANG, redirect về trang chủ
                            response.sendRedirect("/");
                        })
                        .failureUrl("/login?error=true"))
                .sessionManagement(session -> session
                        .sessionCreationPolicy(
                                org.springframework.security.config.http.SessionCreationPolicy.IF_REQUIRED)
                        .invalidSessionUrl("/login?session=invalid")
                        .maximumSessions(1)
                        .maxSessionsPreventsLogin(false))
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/?logout=success")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .deleteCookies("JSESSIONID", "remember-me")
                        .permitAll())
                .csrf(csrf -> csrf.disable())
                .exceptionHandling(ex -> ex
                        .accessDeniedPage("/403"));

        return http.build();
    }
}
