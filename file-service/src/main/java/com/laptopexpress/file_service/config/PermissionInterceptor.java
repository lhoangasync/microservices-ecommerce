package com.laptopexpress.file_service.config;

import com.laptopexpress.file_service.exception.PermissionException;
import com.laptopexpress.file_service.service.PermissionService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.HandlerMapping;

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
    String path = (String) request.getAttribute(HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE);

    String requestURI = request.getRequestURI();
    String httpMethod = request.getMethod();
    System.out.println(">>> path : " + path);
    System.out.println(">>> httpMethod : " + httpMethod);
    System.out.println(">>> requestURI : " + requestURI);

    if (!permissionService.hasPermission(path, httpMethod, token)) {
      throw new PermissionException("You don't have permission to access this endpoint !!");
    }

    return true;
  }
}
