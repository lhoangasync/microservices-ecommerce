package com.laptopexpress.product_service.service;


import com.laptopexpress.product_service.dto.PageResponse;
import com.laptopexpress.product_service.dto.request.ProductRequest;
import com.laptopexpress.product_service.dto.request.ProductUpdateRequest;
import com.laptopexpress.product_service.dto.response.ProductResponse;

import com.laptopexpress.product_service.dto.response.ProductResponse.Category;
import com.laptopexpress.product_service.entity.Product;

import com.laptopexpress.product_service.exception.IdInvalidException;
import com.laptopexpress.product_service.mapper.ProductMapper;
import com.laptopexpress.product_service.repository.ProductRepository;

import com.laptopexpress.product_service.repository.httpClient.CategoryClient;
import com.laptopexpress.product_service.util.SecurityUtil;

import java.util.Optional;
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


  // create product
  public ProductResponse addProduct(ProductRequest productRequest) throws IdInvalidException {
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    String userId = SecurityUtil.getCurrentUserId();

    var categoryResponse = categoryClient.getCategoryById(productRequest.getCategoryId());
    if (categoryResponse == null || categoryResponse.getData() == null) {
      throw new IdInvalidException(
          "Category with this ID = " + productRequest.getCategoryId() + " not found");
    }

    var category = categoryResponse.getData();
    System.out.println(">>> check category: " + category);

    System.out.println(authentication.getName());
    Product product = Product.builder()
        .userId(userId)
        .name(productRequest.getName())
        .price(productRequest.getPrice())
        .description(productRequest.getDescription())
        .category(Category.builder()
            .id(category.getId())
            .name(category.getName())
            .description(category.getDescription())
            .image(category.getImage())
            .build())
        .image(productRequest.getImage())
        .status(productRequest.getStatus())
        .stockStatus(productRequest.getStockStatus())
        .quantity(productRequest.getQuantity())
        .build();

    Product savedProduct = productRepository.save(product);
    return productMapper.toProductResponse(savedProduct);
  }

  // update product
  public ProductResponse uppdateProduct(ProductUpdateRequest request) throws IdInvalidException {
    Product product = productRepository.findById(request.getId())
        .orElseThrow(() -> new IdInvalidException(
            "Product with this ID = " + request.getId() + " not found"));

    var categoryResponse = categoryClient.getCategoryById(request.getCategoryId());
    if (categoryResponse == null || categoryResponse.getData() == null) {
      throw new IdInvalidException(
          "Category with this ID = " + request.getCategoryId() + " not found");
    }

    var category = categoryResponse.getData();
    System.out.println(">>> check category: " + category);

    if (request.getName() != null) {
      product.setName(request.getName());
    }
    if (request.getPrice() != null) {
      product.setPrice(request.getPrice());
    }
    if (request.getCategoryId() != null) {
      product.setCategory(Category.builder()
          .id(category.getId())
          .image(category.getImage())
          .description(category.getDescription())
          .name(category.getName())
          .build());
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
    if (request.getStockStatus() != null) {
      product.setStockStatus(request.getStockStatus());
    }
    if (request.getQuantity() != null) {
      product.setQuantity(request.getQuantity());
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
