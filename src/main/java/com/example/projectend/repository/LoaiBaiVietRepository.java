package com.example.projectend.repository;

import com.example.projectend.entity.LoaiBaiViet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Repository cho LoaiBaiViet
 */
@Repository
public interface LoaiBaiVietRepository extends JpaRepository<LoaiBaiViet, Long> {
}

