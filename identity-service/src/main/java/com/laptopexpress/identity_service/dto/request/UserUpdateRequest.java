package com.laptopexpress.identity_service.dto.request;


import com.laptopexpress.identity_service.enums.GenderEnum;
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
public class UserUpdateRequest {
    @NotBlank(message = "User ID cannot be empty!!")
    String id;

    String username;
    String email;
    String phone;
    String address;
    String imageUrl;

    @Enumerated(EnumType.STRING)
    GenderEnum gender;
}

