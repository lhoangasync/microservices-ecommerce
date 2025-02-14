package com.laptopexpress.identity_service.dto.request;

import com.laptopexpress.identity_service.enums.GenderEnum;
import jakarta.persistence.Column;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.validation.constraints.NotBlank;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserCreateRequest {
    @NotBlank(message = "Username cannot be empty!!")
    String username;

    @NotBlank(message = "Email cannot be empty!!")
    String email;

    @NotBlank(message = "Password cannot be empty!!")
    String password;

    @NotBlank(message = "Phone cannot be empty!!")
    String phone;

    String address;

    String imageUrl;

    @Enumerated(EnumType.STRING)
    GenderEnum gender;
}
