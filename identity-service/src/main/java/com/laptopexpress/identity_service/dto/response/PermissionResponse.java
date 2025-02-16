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
public class PermissionResponse {

  String id;
  String name;
  String apiPath;
  String method;
  String module;
  Instant createdAt;
  Instant updatedAt;
  String createdBy;
  String updatedBy;
}
