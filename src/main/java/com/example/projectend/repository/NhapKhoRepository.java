package com.example.projectend.repository;

import com.example.projectend.entity.NhapKho;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface NhapKhoRepository extends JpaRepository<NhapKho, Integer> {

}
