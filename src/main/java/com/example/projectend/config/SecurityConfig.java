package com.example.projectend.config;

import com.example.projectend.service.auth.CustomOAuth2UserService;
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

    // ⚠️ Chỉ dùng tạm thời cho demo (password plain text "123")
    @Bean
    public PasswordEncoder passwordEncoder() {
        return NoOpPasswordEncoder.getInstance();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http
                // ======================= AUTHORIZE =======================
                .authorizeHttpRequests(auth -> auth

                        // ===== PUBLIC =====
                        .requestMatchers(
                                "/", "/home",
                                "/sanpham/**",
                                "/gioithieu", "/kienthuc", "/lienhe",
                                "/login", "/register", "/403",
                                "/css/**", "/js/**", "/img/**",
                                "/images/**", "/static/**",
                                "/error"
                        ).permitAll()

                        // ===== STAFF (ADMIN vào được luôn) =====
                        .requestMatchers("/staff/**")
                        .hasAnyRole("ADMIN", "NHANVIEN")

                        // ===== ADMIN =====
                        .requestMatchers("/admin/**")
                        .hasRole("ADMIN")

                        // ===== CẦN LOGIN =====
                        .requestMatchers(
                                "/checkout/**",
                                "/profile/**",
                                "/payment/**"
                        ).authenticated()

                        // ===== CÒN LẠI =====
                        .anyRequest().permitAll()
                )

                // ======================= FORM LOGIN =======================
                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        .usernameParameter("username")
                        .passwordParameter("password")

                        .successHandler((request, response, authentication) -> {

                            System.out.println("=== LOGIN SUCCESS ===");
                            System.out.println("User: " + authentication.getName());
                            System.out.println("Authorities: " + authentication.getAuthorities());

                            boolean isAdmin = authentication.getAuthorities().stream()
                                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

                            boolean isStaff = authentication.getAuthorities().stream()
                                    .anyMatch(a -> a.getAuthority().equals("ROLE_NHANVIEN"));

                            if (isAdmin) {
                                response.sendRedirect("/admin/dashboard");
                            } else if (isStaff) {
                                response.sendRedirect("/staff/dashboard");
                            } else {
                                response.sendRedirect("/");
                            }
                        })

                        .failureUrl("/login?error=true")
                        .permitAll()
                )

                // ======================= OAUTH2 LOGIN =======================
                .oauth2Login(oauth2 -> oauth2
                        .loginPage("/login")
                        .userInfoEndpoint(userInfo ->
                                userInfo.userService(customOAuth2UserService)
                        )
                        .successHandler((request, response, authentication) -> {
                            // OAuth2 mặc định là KHACHHANG
                            response.sendRedirect("/");
                        })
                        .failureUrl("/login?error=true")
                )

                // ======================= SESSION =======================
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
                        .invalidSessionUrl("/login?session=invalid")
                        .maximumSessions(1)
                        .maxSessionsPreventsLogin(false)
                )

                // ======================= LOGOUT =======================
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/?logout=success")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .deleteCookies("JSESSIONID")
                        .permitAll()
                )

                // ======================= EXCEPTION =======================
                .exceptionHandling(ex -> ex
                        .accessDeniedPage("/403")
                )

                // ======================= CSRF (tạm disable cho ASM) =====
                .csrf(csrf -> csrf.disable());

        return http.build();
    }
}