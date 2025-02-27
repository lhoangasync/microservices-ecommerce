package com.laptopexpress.product_service.repository.httpClient;

import com.laptopexpress.product_service.dto.ApiResponse;
import com.laptopexpress.product_service.dto.response.ProductResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "brand-service", url = "http://localhost:8086/brand")
public interface BrandClient {

  @GetMapping("/brands/get-by-id/{id}")
  ApiResponse<ProductResponse.Brand> getBrandById(@PathVariable("id") String id);

}
