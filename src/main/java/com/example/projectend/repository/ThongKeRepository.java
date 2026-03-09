package com.example.projectend.repository;

import com.example.projectend.entity.ThongKe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface ThongKeRepository extends JpaRepository<ThongKe, Integer> {


}
