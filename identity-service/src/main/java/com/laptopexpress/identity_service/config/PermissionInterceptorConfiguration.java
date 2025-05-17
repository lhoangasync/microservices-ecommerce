package com.laptopexpress.identity_service.config;

import com.laptopexpress.identity_service.service.UserService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class PermissionInterceptorConfiguration implements WebMvcConfigurer {

  private final UserService userService;

  public PermissionInterceptorConfiguration(@Lazy UserService userService) {
    this.userService = userService;
  }

  @Bean
  PermissionInterceptor getPermissionInterceptor() {
    return new PermissionInterceptor(userService);
  }


  @Override
  public void addInterceptors(InterceptorRegistry registry) {
    String[] PUBLIC_INTERCEPTORS = {
        "/",
        "/auth/**",
        "/users/**",
        "/addresses/**",
    };
    registry.addInterceptor(getPermissionInterceptor())
        .excludePathPatterns(PUBLIC_INTERCEPTORS);
  }
}
