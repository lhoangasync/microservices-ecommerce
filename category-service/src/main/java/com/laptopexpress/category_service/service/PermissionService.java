package com.laptopexpress.category_service.service;

import com.laptopexpress.category_service.dto.ApiResponse;
import com.laptopexpress.category_service.dto.response.UserAccountResponse;
import com.laptopexpress.category_service.exception.PermissionException;
import com.laptopexpress.category_service.repository.httpClient.IdentityClient;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class PermissionService {

  private final IdentityClient identityClient;

  public boolean hasPermission(String apiPath, String method, String token)
      throws PermissionException {
    try {
      ApiResponse<UserAccountResponse> response = identityClient.getMyAccount(token);
      return response.getData().getUser().getRole().getPermissions().stream()
          .anyMatch(p -> p.getApiPath().equals(apiPath) && p.getMethod().equalsIgnoreCase(method));
    } catch (Exception e) {
      throw new PermissionException("Cannot verify permissions");
    }
  }
}
