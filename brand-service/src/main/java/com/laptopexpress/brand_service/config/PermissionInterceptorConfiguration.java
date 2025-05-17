package com.laptopexpress.brand_service.config;

import com.laptopexpress.brand_service.service.PermissionService;
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
        "/brands/get-all",
        "/brands/get-by-id/**",
        "/brands/create"
    };

    registry.addInterceptor(getPermissionInterceptor())
        .excludePathPatterns(PUBLIC_INTERCEPTORS);
  }
}
