package com.laptopexpress.identity_service.entity;

import com.laptopexpress.identity_service.enums.GenderEnum;
import com.laptopexpress.identity_service.service.AuthenticationService;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import java.util.List;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.Instant;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "users")
public class User {

  @Id
  @GeneratedValue(strategy = GenerationType.UUID)
  String id;

  String firstName;

  String lastName;

  String username;

  String email;

  String password;

  String phone;

  String address;

  String imageUrl;

  @Enumerated(EnumType.STRING)
  GenderEnum gender;

  @Column(columnDefinition = "MEDIUMTEXT")
  String refreshToken;

  String verificationCode;

  @Column(name = "otp_expiry")
  Instant otpExpiry;

  boolean verified;

  Instant createdAt;
  Instant updatedAt;
  String createdBy;
  String updatedBy;

  @ManyToOne
  @JoinColumn(name = "role_id")
  Role role;

  @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
  List<Address> addresses;

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
