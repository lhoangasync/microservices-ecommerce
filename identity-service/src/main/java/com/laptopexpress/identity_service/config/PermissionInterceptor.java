package com.laptopexpress.identity_service.config;


import com.laptopexpress.identity_service.entity.Permission;
import com.laptopexpress.identity_service.entity.Role;
import com.laptopexpress.identity_service.entity.User;
import com.laptopexpress.identity_service.exception.PermissionException;
import com.laptopexpress.identity_service.service.AuthenticationService;
import com.laptopexpress.identity_service.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.HandlerMapping;


public class PermissionInterceptor implements HandlerInterceptor {

  private final UserService userService;

  public PermissionInterceptor(UserService userService) {
    this.userService = userService;
  }

  @Override
  @Transactional
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
      Object handler) throws Exception {
    String path = (String) request.getAttribute(HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE);
    String requestURI = request.getRequestURI();
    String httpMethod = request.getMethod();
    System.out.println(">>> RUN preHandle");
    System.out.println(">>> path= " + path);
    System.out.println(">>> httpMethod= " + httpMethod);
    System.out.println(">>> requestURI= " + requestURI);

    //check permission
    String email = AuthenticationService.getCurrentUserLogin().isPresent()
        ? AuthenticationService.getCurrentUserLogin().get() : "";
    if (!email.isEmpty()) {
      User user = userService.handleFindUserByEmail(email);
      if (user != null) {
        Role role = user.getRole();
        if (role != null) {
          List<Permission> permissions = role.getPermissions();
          boolean isAllowed = permissions.stream()
              .anyMatch(data -> data.getApiPath().equals(path)
                  && data.getMethod().equals(httpMethod));
          System.out.println(">>> isAllowed= " + isAllowed);
          if (!isAllowed) {
            throw new PermissionException("You don't have permission to access this endpoint!!...");
          }
        } else {
          throw new PermissionException(
              "You don't have role or permission to access this endpoint!!...");
        }
      }
    }
    return true;
  }

}
