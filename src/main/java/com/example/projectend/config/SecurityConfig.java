//package com.example.projectend.config;
//
//import com.example.projectend.service.auth.CustomOAuth2UserService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
//import org.springframework.security.config.annotation.web.builders.HttpSecurity;
//import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
//import org.springframework.security.config.http.SessionCreationPolicy;
//import org.springframework.security.crypto.password.NoOpPasswordEncoder;
//import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.security.web.SecurityFilterChain;
//
//@Configuration
//@EnableWebSecurity
//@EnableMethodSecurity
//public class SecurityConfig {
//
//        @Autowired
//        private CustomOAuth2UserService customOAuth2UserService;
//
//        // ⚠️ Chỉ dùng tạm thời cho demo (password plain text "123")
//        @Bean
//        public PasswordEncoder passwordEncoder() {
//                return NoOpPasswordEncoder.getInstance();
//        }
//
//        @Bean
//        public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
//
//                http
//                                // ======================= AUTHORIZE =======================
//                                .authorizeHttpRequests(auth -> auth
//
//                                                // ===== PUBLIC =====
//                                                .requestMatchers(
//                                                                "/", "/home",
//                                                                "/sanpham/**",
//                                                                "/gioithieu", "/kienthuc", "/lienhe",
//                                                                "/login", "/register", "/403",
//                                                                "/css/**", "/js/**", "/img/**",
//                                                                "/images/**", "/static/**",
//                                                                "/error")
//                                                .permitAll()
//
//                                                // ===== STAFF (ADMIN vào được luôn) =====
//                                                .requestMatchers("/staff/**")
//                                                .hasAnyRole("ADMIN", "NHANVIEN")
//
//                                                // ===== ADMIN =====
//                                                .requestMatchers("/admin/**")
//                                                .hasRole("ADMIN")
//
//                                                // ===== CẦN LOGIN =====
//                                                .requestMatchers(
//                                                                "/checkout/**",
//                                                                "/profile/**",
//                                                                "/payment/**")
//                                                .authenticated()
//
//                                                // ===== CÒN LẠI =====
//                                                .anyRequest().permitAll())
//
//                                // ======================= FORM LOGIN =======================
//                                .formLogin(form -> form
//                                                .loginPage("/login")
//                                                .loginProcessingUrl("/login")
//                                                .usernameParameter("username")
//                                                .passwordParameter("password")
//
//                                                .successHandler((request, response, authentication) -> {
//                                                        System.out.println("=== FORM LOGIN SUCCESS ===");
//
//                                                        boolean isAdmin = authentication.getAuthorities().stream()
//                                                                        .anyMatch(a -> a.getAuthority()
//                                                                                        .equals("ROLE_ADMIN"));
//                                                        boolean isStaff = authentication.getAuthorities().stream()
//                                                                        .anyMatch(a -> a.getAuthority()
//                                                                                        .equals("ROLE_NHANVIEN"));
//
//                                                        String redirectPath;
//                                                        if (isAdmin) {
//                                                                redirectPath = "/admin/dashboard";
//                                                        } else if (isStaff) {
//                                                                redirectPath = "/staff/dashboard";
//                                                        } else {
//                                                                redirectPath = "/";
//                                                        }
//
//                                                        // Dev: redirect to Vite frontend
//                                                        String referer = request.getHeader("Referer");
//                                                        String origin = request.getHeader("Origin");
//                                                        boolean isDevMode = (referer != null
//                                                                        && referer.contains("5173"))
//                                                                        || (origin != null && origin.contains("5173"));
//                                                        if (isDevMode) {
//                                                                response.sendRedirect(
//                                                                                "http://localhost:5173" + redirectPath);
//                                                        } else {
//                                                                response.sendRedirect(redirectPath);
//                                                        }
//                                                })
//
//                                                .failureUrl("/login?error=true")
//                                                .permitAll())
//
//                                // ======================= OAUTH2 LOGIN =======================
//                                .oauth2Login(oauth2 -> oauth2
//                                                .loginPage("/login")
//                                                .userInfoEndpoint(userInfo -> userInfo
//                                                                .userService(customOAuth2UserService))
//                                                .successHandler((request, response, authentication) -> {
//                                                        System.out.println("=== GOOGLE OAuth2 LOGIN SUCCESS ===");
//
//                                                        boolean isAdmin = authentication.getAuthorities().stream()
//                                                                        .anyMatch(a -> a.getAuthority()
//                                                                                        .equals("ROLE_ADMIN"));
//                                                        boolean isStaff = authentication.getAuthorities().stream()
//                                                                        .anyMatch(a -> a.getAuthority()
//                                                                                        .equals("ROLE_NHANVIEN"));
//
//                                                        String redirectPath;
//                                                        if (isAdmin) {
//                                                                redirectPath = "/admin/dashboard";
//                                                        } else if (isStaff) {
//                                                                redirectPath = "/staff/dashboard";
//                                                        } else {
//                                                                redirectPath = "/";
//                                                        }
//
//                                                        // Hỗ trợ Vite dev server (:5173)
//                                                        String referer = request.getHeader("Referer");
//                                                        if (referer != null && referer.contains("localhost:5173")) {
//                                                                response.sendRedirect(
//                                                                                "http://localhost:5173" + redirectPath);
//                                                        } else {
//                                                                response.sendRedirect(redirectPath);
//                                                        }
//                                                })
//                                                .failureUrl("/login?error=true"))
//
//                                // ======================= SESSION =======================
//                                .sessionManagement(session -> session
//                                                .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
//                                                .invalidSessionUrl("/login?session=invalid").maximumSessions(1)
//                                                .maxSessionsPreventsLogin(false))
//
//                                // ======================= LOGOUT =======================
//                                .logout(logout -> logout.logoutUrl("/logout").logoutSuccessUrl("/?logout=success")
//                                                .invalidateHttpSession(true).clearAuthentication(true)
//                                                .deleteCookies("JSESSIONID").permitAll())
//
//                                // ======================= EXCEPTION =======================
//                                .exceptionHandling(ex -> ex.accessDeniedPage("/403"))
//
//                                // ======================= CSRF (tạm disable cho ASM) =====
//                                .csrf(csrf -> csrf.disable());
//
//                return http.build();
//        }
//}

package com.example.projectend.config;

import com.example.projectend.service.auth.CustomOAuth2UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    @Autowired
    private CustomOAuth2UserService customOAuth2UserService;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return NoOpPasswordEncoder.getInstance();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http

                // ================= AUTHORIZE =================
                .authorizeHttpRequests(auth -> auth

                        .requestMatchers(
                                "/", "/home",
                                "/sanpham/**",
                                "/gioithieu", "/kienthuc", "/lienhe",
                                "/login", "/register", "/403",
                                "/css/**", "/js/**", "/img/**",
                                "/images/**", "/static/**",
                                "/error")
                        .permitAll()

                        .requestMatchers("/staff/**")
                        .hasAnyRole("ADMIN", "NHANVIEN")

                        .requestMatchers("/admin/**")
                        .hasRole("ADMIN")

                        .requestMatchers(
                                "/checkout/**",
                                "/profile/**",
                                "/payment/**")
                        .authenticated()

                        .anyRequest().permitAll()
                )

                // ================= FORM LOGIN =================
                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        .usernameParameter("username")
                        .passwordParameter("password")
                        .successHandler((request, response, authentication) -> {

                            boolean isAdmin = authentication.getAuthorities().stream()
                                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
                            boolean isStaff = authentication.getAuthorities().stream()
                                    .anyMatch(a -> a.getAuthority().equals("ROLE_NHANVIEN"));

                            String redirectPath;
                            if (isAdmin) {
                                redirectPath = "/admin/dashboard";
                            } else if (isStaff) {
                                redirectPath = "/staff/dashboard";
                            } else {
                                redirectPath = "/";
                            }

                            boolean isDevMode = isFromVue(request);

                            if (isDevMode) {
                                response.sendRedirect("http://localhost:5173" + redirectPath);
                            } else {
                                response.sendRedirect(redirectPath);
                            }
                        })
                        .failureUrl("/login?error=true")
                        .permitAll()
                )

                // ================= OAUTH2 LOGIN =================
                .oauth2Login(oauth2 -> oauth2
                        .loginPage("/login")
                        .userInfoEndpoint(userInfo -> userInfo
                                .userService(customOAuth2UserService))
                        .successHandler((request, response, authentication) -> {

                            boolean isAdmin = authentication.getAuthorities().stream()
                                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
                            boolean isStaff = authentication.getAuthorities().stream()
                                    .anyMatch(a -> a.getAuthority().equals("ROLE_NHANVIEN"));

                            String redirectPath;
                            if (isAdmin) {
                                redirectPath = "/admin/dashboard";
                            } else if (isStaff) {
                                redirectPath = "/staff/dashboard";
                            } else {
                                redirectPath = "/";
                            }

                            boolean isDevMode = isFromVue(request);

                            if (isDevMode) {
                                response.sendRedirect("http://localhost:5173" + redirectPath);
                            } else {
                                response.sendRedirect(redirectPath);
                            }
                        })
                        .failureUrl("/login?error=true")
                )

                // ================= SESSION =================
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
                        .invalidSessionUrl("/login?session=invalid")
                        .maximumSessions(1)
                        .maxSessionsPreventsLogin(false)
                )

                // ================= LOGOUT (ĐÃ FIX CHUẨN) =================
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessHandler((request, response, authentication) -> {

                            boolean isDevMode = isFromVue(request);

                            if (isDevMode) {
                                response.sendRedirect("http://localhost:5173/login?logout=success");
                            } else {
                                response.sendRedirect("/login?logout=success");
                            }
                        })
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .deleteCookies("JSESSIONID")
                        .permitAll()
                )

                // ================= EXCEPTION =================
                .exceptionHandling(ex -> ex.accessDeniedPage("/403"))

                // ================= CSRF =================
                .csrf(csrf -> csrf.disable());

        return http.build();
    }

    // ================= HELPER METHOD =================
    private boolean isFromVue(HttpServletRequest request) {
        String referer = request.getHeader("Referer");
        String origin = request.getHeader("Origin");

        return (referer != null && referer.contains("5173"))
                || (origin != null && origin.contains("5173"));
    }
}