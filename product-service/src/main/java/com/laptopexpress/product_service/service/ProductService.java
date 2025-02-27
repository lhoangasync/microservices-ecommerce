package com.laptopexpress.product_service.service;


import com.laptopexpress.product_service.dto.PageResponse;
import com.laptopexpress.product_service.dto.request.ProductRequest;
import com.laptopexpress.product_service.dto.request.ProductUpdateRequest;
import com.laptopexpress.product_service.dto.response.ProductResponse;

import com.laptopexpress.product_service.dto.response.ProductResponse.Brand;
import com.laptopexpress.product_service.dto.response.ProductResponse.Category;
import com.laptopexpress.product_service.entity.Product;

import com.laptopexpress.product_service.entity.Product.Variant;
import com.laptopexpress.product_service.exception.IdInvalidException;
import com.laptopexpress.product_service.mapper.ProductMapper;
import com.laptopexpress.product_service.repository.ProductRepository;

import com.laptopexpress.product_service.repository.httpClient.BrandClient;
import com.laptopexpress.product_service.repository.httpClient.CategoryClient;
import com.laptopexpress.product_service.util.SecurityUtil;

import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class ProductService {

  ProductRepository productRepository;
  ProductMapper productMapper;
  CategoryClient categoryClient;
  BrandClient brandClient;


  // Create product
  public ProductResponse addProduct(ProductRequest productRequest) throws IdInvalidException {
    String userId = SecurityUtil.getCurrentUserId();

    var brandResponse = brandClient.getBrandById(productRequest.getBrandId());
    if (brandResponse == null || brandResponse.getData() == null) {
      throw new IdInvalidException(
          "Brand with this ID = " + productRequest.getBrandId() + " not found");
    }
    var brand = brandResponse.getData();
    System.out.println(">>> check brand: " + brand);

    var categoryResponse = categoryClient.getCategoryById(productRequest.getCategoryId());
    if (categoryResponse == null || categoryResponse.getData() == null) {
      throw new IdInvalidException(
          "Category with ID = " + productRequest.getCategoryId() + " not found");
    }
    var category = categoryResponse.getData();
    System.out.println(">>> check category: " + category);

    Product product = Product.builder()
        .userId(userId)
        .name(productRequest.getName())
        .description(productRequest.getDescription())
        .image(productRequest.getImage())
        .brand(Brand.builder()
            .id(brand.getId())
            .name(brand.getName())
            .description(brand.getDescription())
            .image(brand.getImage())
            .build())
        .category(Category.builder()
            .id(category.getId())
            .name(category.getName())
            .description(category.getDescription())
            .image(category.getImage())
            .build())
        .status(productRequest.getStatus())
        .variants(productRequest.getVariants().stream().map(v -> Variant.builder()
            .variantId(UUID.randomUUID().toString())
            .variantName(v.getVariantName())
            .price(v.getPrice())
            .quantity(v.getQuantity())
            .stockStatus(v.getStockStatus())
            .build()).collect(Collectors.toList()))
        .build();

//    // check
//    if (product.getVariants().size() < 2) {
//      throw new IdInvalidException("Must have more than 2 variants!!");
//    }
//    if (product.getImage().size() < 3) {
//      throw new IdInvalidException("Need at least 3 pictures!!");
//    }

    Product savedProduct = productRepository.save(product);
    return productMapper.toProductResponse(savedProduct);
  }

  // Update product
  public ProductResponse updateProduct(ProductUpdateRequest request) throws IdInvalidException {
    Product product = productRepository.findById(request.getId())
        .orElseThrow(
            () -> new IdInvalidException("Product with ID = " + request.getId() + " not found"));

    if (request.getName() != null) {
      product.setName(request.getName());
    }
    if (request.getDescription() != null) {
      product.setDescription(request.getDescription());
    }
    if (request.getImage() != null) {
      product.setImage(request.getImage());
    }
    if (request.getStatus() != null) {
      product.setStatus(request.getStatus());
    }
    if (request.getCategoryId() != null) {
      var categoryResponse = categoryClient.getCategoryById(request.getCategoryId());
      if (categoryResponse == null || categoryResponse.getData() == null) {
        throw new IdInvalidException(
            "Category with ID = " + request.getCategoryId() + " not found");
      }
      var category = categoryResponse.getData();
      product.setCategory(Category.builder()
          .id(category.getId())
          .name(category.getName())
          .description(category.getDescription())
          .image(category.getImage())
          .build());
    }
    if (request.getBrandId() != null) {
      var brandResponse = brandClient.getBrandById(request.getBrandId());
      if (brandResponse == null || brandResponse.getData() == null) {
        throw new IdInvalidException("Brand with ID = " + request.getBrandId() + " not found");
      }
      var brand = brandResponse.getData();
      product.setBrand(Brand.builder()
          .id(brand.getId())
          .name(brand.getName())
          .description(brand.getDescription())
          .image(brand.getImage())
          .build());
    }

    if (request.getVariants() != null && !request.getVariants().isEmpty()) {
      product.setVariants(request.getVariants().stream().map(v -> Product.Variant.builder()
          .variantId(v.getVariantId() != null ? v.getVariantId() : UUID.randomUUID().toString())
          .variantName(v.getVariantName())
          .price(v.getPrice())
          .quantity(v.getQuantity())
          .stockStatus(v.getStockStatus())
          .build()).collect(Collectors.toList()));
    }

    Product updatedProduct = productRepository.save(product);
    return productMapper.toProductResponse(updatedProduct);
  }

  //fetch product by id
  public ProductResponse getProductById(String id) throws IdInvalidException {
    Product product = productRepository.findById(id)
        .orElseThrow(() -> new IdInvalidException("Product with this ID = " + id + " not found"));

    return productMapper.toProductResponse(product);
  }

  // fetch all products
  public PageResponse<ProductResponse> fetchAllProducts(int page, int size) {
    Sort sort = Sort.by("createdAt").descending();
    Pageable pageable = PageRequest.of(page - 1, size, sort);

    var pageData = productRepository.findAll(pageable);

    return PageResponse.<ProductResponse>builder()
        .currentPage(page)
        .pageSize(pageData.getSize())
        .totalPages(pageData.getTotalPages())
        .totalElements(pageData.getTotalElements())
        .data(pageData.getContent().stream().map(productMapper::toProductResponse).toList())
        .build();
  }

  // fetch all products by category id
  public PageResponse<ProductResponse> fetchAllProductsByCategoryId(int page, int size,
      String categoryId) {
    Sort sort = Sort.by("createdAt").descending();
    Pageable pageable = PageRequest.of(page - 1, size, sort);
    var pageData = productRepository.findByCategory_Id(categoryId, pageable);

    return PageResponse.<ProductResponse>builder()
        .currentPage(page)
        .pageSize(pageData.getSize())
        .totalPages(pageData.getTotalPages())
        .totalElements(pageData.getTotalElements())
        .data(pageData.getContent().stream().map(productMapper::toProductResponse).toList())
        .build();

  }

  // delete product
  public void deleteProduct(String id) throws IdInvalidException {
    Product product = productRepository.findById(id)
        .orElseThrow(() -> new IdInvalidException("Product with this ID = " + id + " not found"));
    productRepository.delete(product);
  }

}
