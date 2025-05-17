package com.laptopexpress.product_service.controller;

import com.laptopexpress.product_service.dto.ApiResponse;
import com.laptopexpress.product_service.dto.PageResponse;
import com.laptopexpress.product_service.dto.request.FilterVariantRequest;
import com.laptopexpress.product_service.dto.request.ProductRequest;
import com.laptopexpress.product_service.dto.request.ProductUpdateRequest;
import com.laptopexpress.product_service.dto.response.FilterVariantResponse;
import com.laptopexpress.product_service.dto.response.ProductResponse;
import com.laptopexpress.product_service.dto.response.ProductResponse.Brand;
import com.laptopexpress.product_service.exception.IdInvalidException;
import com.laptopexpress.product_service.service.ProductService;
import jakarta.validation.Valid;
import java.util.List;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
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
  ApiResponse<ProductResponse> createProduct(@RequestBody ProductRequest productRequest)
      throws IdInvalidException {
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
        .data(productService.updateProduct(request))
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

  @GetMapping("/category/{id}")
  ApiResponse<PageResponse<ProductResponse>> getAllProductsByCategory(
      @PathVariable String id,
      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
      @RequestParam(value = "size", required = false, defaultValue = "10") int size
  ) {
    return ApiResponse.<PageResponse<ProductResponse>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get all products successfully!")
        .data(productService.fetchAllProductsByCategoryId(page, size, id))
        .build();
  }

  @GetMapping("/brand/{id}")
  ApiResponse<PageResponse<ProductResponse>> getAllProductsByBrand(
      @PathVariable String id,
      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
      @RequestParam(value = "size", required = false, defaultValue = "10") int size
  ) {
    return ApiResponse.<PageResponse<ProductResponse>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get all products successfully!")
        .data(productService.fetchAllProductsByBrandId(page, size, id))
        .build();
  }

  @DeleteMapping("/delete/{id}")
  ApiResponse<Void> deleteProduct(@PathVariable String id) throws IdInvalidException {
    productService.deleteProduct(id);
    return ApiResponse.<Void>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Delete product successfully!")
        .data(null)
        .build();
  }

  @PostMapping("/filter-variant")
  public ApiResponse<FilterVariantResponse> filterVariant(@RequestBody FilterVariantRequest request)
      throws IdInvalidException {
    FilterVariantResponse variant = productService.filterVariant(request);
    return ApiResponse.<FilterVariantResponse>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Filter variant successfully!")
        .data(variant)
        .build();
  }

  @GetMapping("/get-by-price-desc")
  ApiResponse<PageResponse<ProductResponse>> getAllProductsByPriceDesc(
      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
      @RequestParam(value = "size", required = false, defaultValue = "10") int size
  ) {
    return ApiResponse.<PageResponse<ProductResponse>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get all products successfully!")
        .data(productService.fetchAllProductsByHigherPrice(page, size))
        .build();
  }

  @GetMapping("/get-by-price-asc")
  ApiResponse<PageResponse<ProductResponse>> getAllProductsByPriceAsc(
      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
      @RequestParam(value = "size", required = false, defaultValue = "10") int size
  ) {
    return ApiResponse.<PageResponse<ProductResponse>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get all products successfully!")
        .data(productService.fetchAllProductsByLowerPrice(page, size))
        .build();
  }

  @GetMapping("/get-by-salePrice")
  ApiResponse<PageResponse<ProductResponse>> getAllProductsBySalePrice(
      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
      @RequestParam(value = "size", required = false, defaultValue = "10") int size
  ) {
    return ApiResponse.<PageResponse<ProductResponse>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get all products successfully!")
        .data(productService.fetchAllProductsBySalePrice(page, size))
        .build();
  }

  @GetMapping("/get-by-name")
  ApiResponse<PageResponse<ProductResponse>> getAllProductsByNameSort(
      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
      @RequestParam(value = "size", required = false, defaultValue = "10") int size
  ) {
    return ApiResponse.<PageResponse<ProductResponse>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get all products successfully!")
        .data(productService.fetchAllProductsByNameAscending(page, size))
        .build();
  }

  @GetMapping("/get-by-newest")
  ApiResponse<PageResponse<ProductResponse>> getAllProductsByNewest(
      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
      @RequestParam(value = "size", required = false, defaultValue = "10") int size
  ) {
    return ApiResponse.<PageResponse<ProductResponse>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get all products successfully!")
        .data(productService.fetchAllProductsByNewest(page, size))
        .build();
  }

  @GetMapping("/brands-in-category/{categoryId}")
  ApiResponse<List<ProductResponse.Brand>> getBrandsByCategory(
      @PathVariable String categoryId
  ) {
    return ApiResponse.<List<ProductResponse.Brand>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get brands by category successfully!")
        .data(productService.getBrandsByCategoryId(categoryId))
        .build();
  }

  @PostMapping("/fetch-by-ids")
  ApiResponse<List<ProductResponse>> fetchProductsByIds(@RequestBody List<String> ids) {
    return ApiResponse.<List<ProductResponse>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get products by ids successfully!")
        .data(productService.fetchProductsByIds(ids))
        .build();
  }
}
