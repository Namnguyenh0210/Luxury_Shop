package com.example.projectend.service.auth;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.core.user.OAuth2User;

import java.util.*;

/**
 * CUSTOM OAUTH2 USER
 * Wrapper cho OAuth2User để thêm vaiTros từ database
 */
public class CustomOAuth2User implements OAuth2User {

    private OAuth2User oauth2User;
    private List<GrantedAuthority> authorities;

    public CustomOAuth2User(OAuth2User oauth2User, List<GrantedAuthority> authorities) {
        this.oauth2User = oauth2User;
        this.authorities = authorities;
    }

    @Override
    public Map<String, Object> getAttributes() {
        return oauth2User.getAttributes();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getName() {
        return oauth2User.getAttribute("email");
    }

    public String getEmail() {
        return oauth2User.getAttribute("email");
    }

    public String getFullName() {
        return oauth2User.getAttribute("name");
    }

    public String getPicture() {
        return oauth2User.getAttribute("picture");
    }
}

