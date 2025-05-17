package com.laptopexpress.identity_service.dto.response;

import java.time.Instant;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class AddressResponse {

  String id;
  String name;
  String phoneNumber;
  String street;
  String city;
  String state;
  String country;
  String userId;
  Boolean selectedAddress;
  Instant createdAt;
  Instant updatedAt;
  String createdBy;
  String updatedBy;
}
