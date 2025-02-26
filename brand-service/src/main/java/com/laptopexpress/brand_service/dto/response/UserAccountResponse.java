package com.laptopexpress.brand_service.dto.response;

import java.util.List;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserAccountResponse {

  private UserData user;

  @Getter
  @Setter
  public static class UserData {

    private String id;
    private String email;
    private String username;
    private RoleData role;
  }

  @Getter
  @Setter
  public static class RoleData {

    private String id;
    private String name;
    private List<PermissionData> permissions;
  }

  @Getter
  @Setter
  public static class PermissionData {

    private String apiPath;
    private String method;
  }
}
