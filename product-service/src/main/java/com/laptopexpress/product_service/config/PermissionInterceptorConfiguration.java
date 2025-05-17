package com.laptopexpress.product_service.config;

import com.laptopexpress.product_service.service.PermissionService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.context.annotation.Lazy;

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
        "/products/get-by-id/**",
        "/products/get-all",
        "/products/get-by-price-desc",
        "/products/get-by-price-asc",
        "/products/get-by-name",
        "/products/get-by-newest",
        "/products/get-by-salePrice",
        "/products/filter-variant",
        "/products/create",
        "/products/update",
        "/products/brand/**",
        "/products/category/**",
        "/products/brands-in-category/**",
        "/products/fetch-by-ids",
    };

    registry.addInterceptor(getPermissionInterceptor())
        .excludePathPatterns(PUBLIC_INTERCEPTORS);
  }
}
