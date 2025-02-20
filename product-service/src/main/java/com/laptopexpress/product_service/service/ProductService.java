package com.laptopexpress.product_service.service;


import com.laptopexpress.product_service.dto.request.ProductRequest;
import com.laptopexpress.product_service.dto.response.ProductResponse;

import com.laptopexpress.product_service.entity.Product;

import com.laptopexpress.product_service.mapper.ProductMapper;
import com.laptopexpress.product_service.repository.ProductRepository;

import com.laptopexpress.product_service.util.SecurityUtil;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
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


  // create product
  public ProductResponse addProduct(ProductRequest productRequest) {
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    String userId = SecurityUtil.getCurrentUserId();

    System.out.println(authentication.getName());
    Product product = Product.builder()
        .userId(userId)
        .name(productRequest.getName())
        .price(productRequest.getPrice())
        .categoryId(productRequest.getCategoryId())
        .description(productRequest.getDescription())
        .image(productRequest.getImage())
        .status(productRequest.getStatus())
        .stockStatus(productRequest.getStockStatus())
        .quantity(productRequest.getQuantity())
        .build();

    Product savedProduct = productRepository.save(product);
    return productMapper.toProductResponse(savedProduct);
  }
}
