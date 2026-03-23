package com.example.projectend.repository;

import com.example.projectend.entity.PasswordResetToken;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetToken, Long> {

    Optional<PasswordResetToken> findTopByEmailAndOtpAndTrangThaiTrueOrderByNgayTaoDesc(String email, String otp);

}