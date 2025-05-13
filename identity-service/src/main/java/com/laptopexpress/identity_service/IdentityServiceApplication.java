package com.laptopexpress.identity_service;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;

//@SpringBootApplication(exclude = {
//		org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration.class,
//		org.springframework.boot.actuate.autoconfigure.security.servlet.ManagementWebSecurityAutoConfiguration.class
//})
@SpringBootApplication
@EnableFeignClients
public class IdentityServiceApplication {

  public static void main(String[] args) {
    SpringApplication.run(IdentityServiceApplication.class, args);
  }

}

