package com.laptopexpress.notification_service.configuration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.laptopexpress.notification_service.dto.ApiResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.oauth2.server.resource.web.BearerTokenAuthenticationEntryPoint;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

@Component
public class CustomAuthenticationEntryPoint implements AuthenticationEntryPoint {

  private final AuthenticationEntryPoint delegate = new BearerTokenAuthenticationEntryPoint();

  @Autowired
  ObjectMapper objectMapper;

  @Override
  public void commence(HttpServletRequest request, HttpServletResponse response,
      AuthenticationException authException) throws IOException, ServletException {
    delegate.commence(request, response, authException);
    response.setContentType("application/json;charset=UTF-8");
    ApiResponse<Object> result = ApiResponse.builder()
        .code(HttpStatus.UNAUTHORIZED.value())
        .error(authException.getMessage())
        .message("Token invalid")
        .build();
    response.getWriter().write(objectMapper.writeValueAsString(result));
    response.flushBuffer();

  }
}
