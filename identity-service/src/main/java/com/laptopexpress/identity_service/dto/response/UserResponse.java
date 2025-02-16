package com.laptopexpress.identity_service.dto.response;

import com.laptopexpress.identity_service.enums.GenderEnum;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserResponse {

  String id;
  String username;
  String email;
  String phone;
  String address;
  String imageUrl;
  GenderEnum gender;
  boolean verified;
  //    String verificationCode;
  Instant createdAt;
  Instant updatedAt;
  String createdBy;
  String updatedBy;
  RoleUser role;

  @Getter
  @Setter
  @AllArgsConstructor
  @NoArgsConstructor
  @Data
  @Builder
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class RoleUser {

    String id;
    String name;
  }


}
