package com.example.projectend.service.auth;

import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.entity.VaiTro;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.repository.VaiTroRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * CUSTOM OAUTH2 USER SERVICE - GOOGLE LOGIN
 * ==========================================
 * Xử lý đăng nhập bằng Google OAuth2
 *
 * LOGIC:
 * 1. Nếu email CHƯA tồn tại → Tạo tài khoản mới với:
 *    - provider = "GOOGLE"
 *    - matKhau = null (không cần password)
 *    - role = KHACHHANG (mặc định)
 *    - avatar lấy từ Google
 *
 * 2. Nếu email ĐÃ tồn tại:
 *    - Cập nhật avatar nếu có thay đổi
 *    - Cập nhật lastLogin
 *    - Cập nhật provider = GOOGLE (nếu trước đó là LOCAL)
 *
 * 3. Trả về CustomOAuth2User với đầy đủ authorities từ database
 */
@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @Autowired
    private VaiTroRepository vaiTroRepository;

    @Override
    @Transactional
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);

        System.out.println("\n╔════════════════════════════════════════════════════════════╗");
        System.out.println("║          🔐 GOOGLE OAUTH2 LOGIN STARTED                    ║");
        System.out.println("╚════════════════════════════════════════════════════════════╝");

        String provider = userRequest.getClientRegistration().getRegistrationId();
        System.out.println("📱 Provider: " + provider.toUpperCase());
        System.out.println("📋 User Attributes: " + oAuth2User.getAttributes());

        // Lấy thông tin từ Google
        String email = oAuth2User.getAttribute("email");
        String name = oAuth2User.getAttribute("name");
        String picture = oAuth2User.getAttribute("picture");
        String googleId = oAuth2User.getAttribute("sub");

        System.out.println("\n📧 Email: " + email);
        System.out.println("👤 Name: " + name);
        System.out.println("🖼️ Picture: " + picture);
        System.out.println("🆔 Google ID: " + googleId);

        // Xử lý user trong database
        TaiKhoan taiKhoan = processOAuthUser(email, name, picture, provider.toUpperCase());

        // Build authorities từ roles trong database
        List<GrantedAuthority> authorities = new ArrayList<>();
        for (VaiTro role : taiKhoan.getRoles()) {
            String roleName = "ROLE_" + role.getTenRole();
            authorities.add(new SimpleGrantedAuthority(roleName));
            System.out.println("✅ Added authority: " + roleName);
        }

        System.out.println("\n╔════════════════════════════════════════════════════════════╗");
        System.out.println("║          ✅ GOOGLE OAUTH2 LOGIN SUCCESS                    ║");
        System.out.println("║   User: " + taiKhoan.getHoTen() + " (ID: " + taiKhoan.getMaTK() + ")");
        System.out.println("║   Provider: " + taiKhoan.getProvider());
        System.out.println("║   Roles: " + authorities.size());
        System.out.println("╚════════════════════════════════════════════════════════════╝\n");

        // Return custom OAuth2User với authorities từ database
        return new CustomOAuth2User(oAuth2User, authorities);
    }

    /**
     * Xử lý tạo hoặc cập nhật tài khoản từ Google OAuth2
     */
    private TaiKhoan processOAuthUser(String email, String name, String picture, String provider) {
        TaiKhoan taiKhoan = taiKhoanRepository.findByEmail(email).orElse(null);

        if (taiKhoan == null) {
            // ============ TẠO TÀI KHOẢN MỚI ============
            System.out.println("\n🆕 Tạo tài khoản mới cho: " + email);

            taiKhoan = new TaiKhoan();
            taiKhoan.setEmail(email);
            taiKhoan.setHoTen(name != null ? name : "Google User");
            taiKhoan.setMatKhau(null);  // ⚠️ Không có password cho Google OAuth2
            taiKhoan.setAvatar(picture);
            taiKhoan.setProvider(provider);  // ✨ Set provider = GOOGLE
            taiKhoan.setTrangThai(true);
            taiKhoan.setNgayTao(LocalDateTime.now());
            taiKhoan.setNgayCapNhat(LocalDateTime.now());
            taiKhoan.setLastLogin(LocalDateTime.now());

            // Gán role KHACHHANG mặc định
            VaiTro roleKhachHang = vaiTroRepository.findByTenRole("KHACHHANG")
                    .orElseGet(() -> {
                        System.out.println("⚠️ Role KHACHHANG không tồn tại, tạo mới...");
                        VaiTro newRole = new VaiTro();
                        newRole.setTenRole("KHACHHANG");
                        return vaiTroRepository.save(newRole);
                    });

            Set<VaiTro> roles = new HashSet<>();
            roles.add(roleKhachHang);
            taiKhoan.setRoles(roles);

            taiKhoanRepository.save(taiKhoan);
            System.out.println("✅ Tạo tài khoản thành công!");
            System.out.println("   - ID: " + taiKhoan.getMaTK());
            System.out.println("   - Email: " + taiKhoan.getEmail());
            System.out.println("   - Provider: " + taiKhoan.getProvider());
            System.out.println("   - Role: KHACHHANG");

        } else {
            // ============ CẬP NHẬT TÀI KHOẢN ĐÃ TỒN TẠI ============
            System.out.println("\n♻️ Cập nhật tài khoản đã tồn tại: " + email);
            System.out.println("   - Provider cũ: " + taiKhoan.getProvider());
            System.out.println("   - Avatar cũ: " + taiKhoan.getAvatar());

            // Cập nhật avatar nếu có thay đổi
            if (picture != null && !picture.equals(taiKhoan.getAvatar())) {
                taiKhoan.setAvatar(picture);
                System.out.println("   ✅ Cập nhật avatar mới");
            }

            // Cập nhật tên nếu có thay đổi
            if (name != null && !name.equals(taiKhoan.getHoTen())) {
                taiKhoan.setHoTen(name);
                System.out.println("   ✅ Cập nhật tên: " + name);
            }

            // Cập nhật provider sang GOOGLE (nếu trước đó là LOCAL)
            if (!"GOOGLE".equals(taiKhoan.getProvider())) {
                taiKhoan.setProvider(provider);
                System.out.println("   ✅ Cập nhật provider: " + provider);
            }

            // Cập nhật lastLogin và ngày cập nhật
            taiKhoan.setLastLogin(LocalDateTime.now());
            taiKhoan.setNgayCapNhat(LocalDateTime.now());

            taiKhoanRepository.save(taiKhoan);
            System.out.println("✅ Cập nhật tài khoản thành công!");
        }

        return taiKhoan;
    }
}

