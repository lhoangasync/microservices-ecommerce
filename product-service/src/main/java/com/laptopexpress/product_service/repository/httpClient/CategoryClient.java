package com.laptopexpress.product_service.repository.httpClient;

import com.laptopexpress.product_service.dto.ApiResponse;
import com.laptopexpress.product_service.dto.response.ProductResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "product-service", url = "http://localhost:8084/category")
public interface CategoryClient {

  @GetMapping("/categories/get-by-id/{id}")
  ApiResponse<ProductResponse.Category> getCategoryById(@PathVariable("id") String id);

}
