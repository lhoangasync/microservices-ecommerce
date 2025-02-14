package com.laptopexpress.identity_service.dto.response;

import com.laptopexpress.identity_service.enums.GenderEnum;
import jakarta.persistence.Column;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserResponse {
    String username;

    String email;

    String password;

    String phone;

    String address;

    String imageUrl;

    GenderEnum gender;

    String refreshToken;

    String verificationCode;

    boolean verified;

    private Instant createdAt;
    private Instant updatedAt;
    private String createdBy;
    private String updatedBy;
}
