package com.laptopexpress.product_service.config;

import com.laptopexpress.product_service.exception.PermissionException;
import com.laptopexpress.product_service.service.PermissionService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.HandlerInterceptor;

public class PermissionInterceptor implements HandlerInterceptor {

  private final PermissionService permissionService;

  public PermissionInterceptor(PermissionService permissionService) {
    this.permissionService = permissionService;
  }

  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
      throws Exception {
    String token = request.getHeader("Authorization");

    if (token == null || token.isEmpty()) {
      throw new PermissionException("Token is missing or invalid");
    }

    String path = request.getRequestURI();
    String httpMethod = request.getMethod();
    System.out.println(">>> path : " + path);
    System.out.println(">>> httpMethod : " + httpMethod);

    if (!permissionService.hasPermission(path, httpMethod, token)) {
      throw new PermissionException("You don't have permission to access this endpoint !!");
    }

    return true;
  }
}
