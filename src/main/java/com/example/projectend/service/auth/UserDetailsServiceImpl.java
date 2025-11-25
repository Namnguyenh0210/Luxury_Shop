package com.example.projectend.service.auth;

import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.entity.VaiTro;
import com.example.projectend.repository.TaiKhoanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * USER DETAILS SERVICE IMPLEMENTATION
 * ====================================
 * Load user từ SQL Server database cho Form Login (email/password)
 *
 * LƯU Ý: Tài khoản Google OAuth2 (provider=GOOGLE) có matKhau=null
 * nên không thể đăng nhập bằng form thông thường
 */
@Service("userDetailsService")
public class UserDetailsServiceImpl implements UserDetailsService {

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        System.out.println("\n╔════════════════════════════════════════════════════════════╗");
        System.out.println("║          🔐 FORM LOGIN - LOADING USER                      ║");
        System.out.println("╚════════════════════════════════════════════════════════════╝");
        System.out.println("📧 Username/Email: " + username);

        // Tìm user theo email HOẶC số điện thoại
        TaiKhoan taiKhoan = taiKhoanRepository.findByEmail(username)
                .or(() -> taiKhoanRepository.findBySoDienThoai(username))
                .orElseThrow(() -> {
                    System.out.println("❌ Không tìm thấy tài khoản: " + username);
                    return new UsernameNotFoundException("Không tìm thấy tài khoản với email/SĐT: " + username);
                });

        System.out.println("✅ Tìm thấy tài khoản:");
        System.out.println("   - ID: " + taiKhoan.getMaTK());
        System.out.println("   - Tên: " + taiKhoan.getHoTen());
        System.out.println("   - Email: " + taiKhoan.getEmail());
        System.out.println("   - Provider: " + taiKhoan.getProvider());
        System.out.println("   - Trạng thái: " + (taiKhoan.getTrangThai() ? "Active" : "Inactive"));

        // Kiểm tra tài khoản có bị vô hiệu hóa không
        if (!taiKhoan.getTrangThai()) {
            System.out.println("❌ Tài khoản bị vô hiệu hóa!");
            throw new UsernameNotFoundException("Tài khoản đã bị vô hiệu hóa: " + username);
        }

        // ⚠️ QUAN TRỌNG: Kiểm tra nếu là tài khoản Google OAuth2
        if ("GOOGLE".equals(taiKhoan.getProvider()) && taiKhoan.getMatKhau() == null) {
            System.out.println("⚠️ Tài khoản Google OAuth2 không thể đăng nhập bằng form!");
            System.out.println("   → Vui lòng sử dụng nút 'Đăng nhập bằng Google'");
            throw new UsernameNotFoundException(
                    "Tài khoản này đã đăng ký bằng Google. Vui lòng sử dụng nút 'Đăng nhập bằng Google'!"
            );
        }

        // Map roles từ database
        List<GrantedAuthority> authorities = new ArrayList<>();
        Set<VaiTro> roles = taiKhoan.getRoles();

        System.out.println("🔑 Roles:");
        for (VaiTro role : roles) {
            String roleName = "ROLE_" + role.getTenRole();
            authorities.add(new SimpleGrantedAuthority(roleName));
            System.out.println("   - " + roleName);
        }

        // Nếu không có role, gán mặc định KHACHHANG
        if (authorities.isEmpty()) {
            System.out.println("⚠️ Không có role, gán mặc định ROLE_KHACHHANG");
            authorities.add(new SimpleGrantedAuthority("ROLE_KHACHHANG"));
        }

        // Cập nhật lastLogin
        try {
            taiKhoan.setLastLogin(LocalDateTime.now());
            taiKhoanRepository.save(taiKhoan);
            System.out.println("✅ Cập nhật lastLogin thành công");
        } catch (Exception e) {
            System.out.println("⚠️ Không thể cập nhật lastLogin: " + e.getMessage());
        }

        // Return Spring Security User object
        UserDetails userDetails = User.builder()
                .username(taiKhoan.getEmail())
                .password(taiKhoan.getMatKhau() != null ? taiKhoan.getMatKhau() : "OAUTH2_NO_PASSWORD")
                .authorities(authorities)
                .accountExpired(false)
                .accountLocked(false)
                .credentialsExpired(false)
                .disabled(!taiKhoan.getTrangThai())
                .build();

        System.out.println("\n╔════════════════════════════════════════════════════════════╗");
        System.out.println("║          ✅ FORM LOGIN SUCCESS                             ║");
        System.out.println("╚════════════════════════════════════════════════════════════╝\n");

        return userDetails;
    }

    /**
     * Helper method để lấy TaiKhoan entity từ email
     * Dùng cho các service khác cần thông tin user đầy đủ
     */
    public TaiKhoan getTaiKhoanByEmail(String email) {
        return taiKhoanRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Không tìm thấy tài khoản: " + email));
    }
}
