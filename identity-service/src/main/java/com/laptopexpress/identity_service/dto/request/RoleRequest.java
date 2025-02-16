package com.laptopexpress.identity_service.dto.request;


import com.laptopexpress.identity_service.entity.Permission;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class RoleRequest {

  String id;
  String name;
  String description;
  boolean active;
  List<Permission> permissions;
}
