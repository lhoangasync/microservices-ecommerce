package com.laptopexpress.category_service.config;

import com.laptopexpress.category_service.service.PermissionService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class PermissionInterceptorConfiguration implements WebMvcConfigurer {

  private final PermissionService permissionService;

  public PermissionInterceptorConfiguration(@Lazy PermissionService permissionService) {
    this.permissionService = permissionService;
  }

  @Bean
  PermissionInterceptor getPermissionInterceptor() {
    return new PermissionInterceptor(permissionService);
  }

  @Override
  public void addInterceptors(InterceptorRegistry registry) {
    String[] PUBLIC_INTERCEPTORS = {
        "/",
        "/auth/**",
        "/categories/get-all",
        "/categories/get-by-id/**",
    };

    registry.addInterceptor(getPermissionInterceptor())
        .excludePathPatterns(PUBLIC_INTERCEPTORS);
  }
}
