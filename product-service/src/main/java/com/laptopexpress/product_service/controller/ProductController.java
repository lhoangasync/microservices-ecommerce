package com.laptopexpress.product_service.controller;

import com.laptopexpress.product_service.dto.ApiResponse;
import com.laptopexpress.product_service.dto.PageResponse;
import com.laptopexpress.product_service.dto.request.ProductRequest;
import com.laptopexpress.product_service.dto.request.ProductUpdateRequest;
import com.laptopexpress.product_service.dto.response.ProductResponse;
import com.laptopexpress.product_service.exception.IdInvalidException;
import com.laptopexpress.product_service.service.ProductService;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/products")
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

  @PutMapping("/update")
  ApiResponse<ProductResponse> updateProduct(@Valid @RequestBody ProductUpdateRequest request)
      throws IdInvalidException {
    return ApiResponse.<ProductResponse>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Update product successfully!")
        .data(productService.uppdateProduct(request))
        .build();
  }

  @GetMapping("/get-by-id/{id}")
  ApiResponse<ProductResponse> getProductById(@PathVariable String id) throws IdInvalidException {
    return ApiResponse.<ProductResponse>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get product successfully!")
        .data(productService.getProductById(id))
        .build();
  }

  @GetMapping("/get-all")
  ApiResponse<PageResponse<ProductResponse>> getAllProducts(
      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
      @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
    return ApiResponse.<PageResponse<ProductResponse>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get all products successfully!")
        .data(productService.fetchAllProducts(page, size))
        .build();
  }

}
