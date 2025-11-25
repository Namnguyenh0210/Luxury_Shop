package com.example.projectend.repository;

import com.example.projectend.entity.MauSacSP;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MauSacSPRepository extends JpaRepository<MauSacSP, Long> {
}

