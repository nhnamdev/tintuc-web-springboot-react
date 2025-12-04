package com.dantri;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Main Application class cho Dân Trí News Backend
 */
@SpringBootApplication
public class DantriApplication {

    public static void main(String[] args) {
        SpringApplication.run(DantriApplication.class, args);
        System.out.println("=================================");
        System.out.println("Dân Trí Backend API is running!");
        System.out.println("API URL: http://localhost:8080/api");
        System.out.println("=================================");
    }
}
