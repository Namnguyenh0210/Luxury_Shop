package com.example.projectend.repository;

import com.example.projectend.entity.SizeSP;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SizeSPRepository extends JpaRepository<SizeSP, Long> {
}

