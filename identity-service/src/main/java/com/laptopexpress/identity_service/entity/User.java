package com.laptopexpress.identity_service.entity;

import com.laptopexpress.identity_service.enums.GenderEnum;
import com.laptopexpress.identity_service.service.AuthenticationService;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
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

    boolean verified;

    Instant createdAt;
    Instant updatedAt;
    String createdBy;
    String updatedBy;

    @ManyToOne
    @JoinColumn(name = "role_id")
    Role role;

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
