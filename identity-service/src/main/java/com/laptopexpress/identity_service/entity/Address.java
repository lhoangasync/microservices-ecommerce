package com.laptopexpress.identity_service.entity;

import com.laptopexpress.identity_service.service.AuthenticationService;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

import java.time.Instant;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "addresses")
public class Address {

  @Id
  @GeneratedValue(strategy = GenerationType.UUID)
  String id;

  String name;

  String phoneNumber;

  String street;

  String city;

  String state;

  String country;


  boolean selectedAddress;

  Instant createdAt;
  Instant updatedAt;
  String createdBy;
  String updatedBy;

  @ManyToOne
  @JoinColumn(name = "user_id", nullable = false)
  User user;

  @PrePersist
  public void handleBeforeCreate() {
    this.createdBy = AuthenticationService.getCurrentUserLogin().isPresent()
        ? AuthenticationService.getCurrentUserLogin().get()
        : "";

    this.createdAt = Instant.now();
  }

  @PreUpdate
  public void handleBeforeUpdate() {
    this.updatedBy = AuthenticationService.getCurrentUserLogin().isPresent()
        ? AuthenticationService.getCurrentUserLogin().get()
        : "";

    this.updatedAt = Instant.now();
  }
}