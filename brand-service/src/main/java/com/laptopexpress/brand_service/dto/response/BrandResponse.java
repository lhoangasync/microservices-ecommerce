package com.laptopexpress.brand_service.dto.response;

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
public class BrandResponse {

  String id;
  String name;
  String description;
  String image;

  String createdBy;
  String updatedBy;
  Instant createdAt;
  Instant updatedAt;
}
