package com.laptopexpress.product_service.controller;

import com.laptopexpress.product_service.dto.ApiResponse;
import com.laptopexpress.product_service.dto.request.ProductRequest;
import com.laptopexpress.product_service.dto.response.ProductResponse;
import com.laptopexpress.product_service.service.ProductService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class ProductController {

  ProductService productService;

  @PostMapping("/create")
  ApiResponse<ProductResponse> createProduct(@RequestBody ProductRequest productRequest) {
    return ApiResponse.<ProductResponse>builder()
        .code(HttpStatus.CREATED.value())
        .error(null)
        .message("Add product successfully")
        .data(productService.addProduct(productRequest))
        .build();
  }

}
