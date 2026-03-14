package com.example.projectend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * Class khởi động ứng dụng Spring Boot
 * Website bán Luxury Fashion
 */
@SpringBootApplication
@EnableAsync
@EnableScheduling
public class ProjectendApplication {

    /**
     * Hàm main khởi chạy ứng dụng
     */
    public static void main(String[] args) {
        SpringApplication.run(ProjectendApplication.class, args);
    }

}
