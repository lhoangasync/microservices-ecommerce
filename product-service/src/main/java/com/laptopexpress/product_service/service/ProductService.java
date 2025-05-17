package com.laptopexpress.product_service.service;


import com.laptopexpress.product_service.dto.PageResponse;
import com.laptopexpress.product_service.dto.request.FilterVariantRequest;
import com.laptopexpress.product_service.dto.request.ProductRequest;
import com.laptopexpress.product_service.dto.request.ProductUpdateRequest;
import com.laptopexpress.product_service.dto.response.FilterVariantResponse;
import com.laptopexpress.product_service.dto.response.ProductResponse;


import com.laptopexpress.product_service.dto.response.ProductResponse.Brand;
import com.laptopexpress.product_service.entity.Product;


import com.laptopexpress.product_service.exception.IdInvalidException;
import com.laptopexpress.product_service.mapper.ProductMapper;
import com.laptopexpress.product_service.repository.ProductRepository;

import com.laptopexpress.product_service.repository.httpClient.BrandClient;
import com.laptopexpress.product_service.repository.httpClient.CategoryClient;
import com.laptopexpress.product_service.util.SecurityUtil;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;

import org.springframework.data.domain.PageRequest;

import org.springframework.data.domain.Sort;

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
        .quantity(productRequest.getQuantity())
        .image(productRequest.getImage())
        .thumbnail(productRequest.getThumbnail())
        .status(productRequest.getStatus())
        .price(productRequest.getPrice())
        .salePrice(productRequest.getSalePrice())
        .attributes(productRequest.getAttributes().stream()
            .map(attr -> Product.ProductAttribute.builder()
                .name(attr.getName())
                .values(attr.getValues())
                .build())
            .toList())
        .brand(ProductResponse.Brand.builder()
            .id(brand.getId())
            .name(brand.getName())
            .description(brand.getDescription())
            .image(brand.getImage())
            .isFeature(brand.getIsFeature())
            .build())
        .category(ProductResponse.Category.builder()
            .id(category.getId())
            .name(category.getName())
            .description(category.getDescription())
            .parentId(category.getParentId())
            .isParent(category.getIsParent())
            .level(category.getLevel())
            .image(category.getImage())
            .build())
        .variants(productRequest.getVariants().stream()
            .map(v -> Product.Variant.builder()
                .variantId(UUID.randomUUID().toString())
                .variantName(v.getVariantName())
                .description(v.getDescription())
                .image(v.getImage())
                .price(v.getPrice())
                .salePrice(v.getSalePrice())
                .quantity(v.getQuantity())
                .stockStatus(v.getStockStatus())
                .attributeVariant(v.getAttributeVariant().stream()
                    .map(attr -> Product.AttributeValue.builder()
                        .name(attr.getName())
                        .value(attr.getValue())
                        .build())
                    .toList())
                .build())
            .toList())
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
    if (request.getQuantity() != null) {
      product.setQuantity(request.getQuantity());
    }
    if (request.getImage() != null) {
      product.setImage(request.getImage());
    }
    if (request.getThumbnail() != null) {
      product.setThumbnail(request.getThumbnail());
    }
    if (request.getStatus() != null) {
      product.setStatus(request.getStatus());
    }
    if (request.getPrice() != null) {
      product.setPrice(request.getPrice());
    }
    if (request.getSalePrice() != null) {
      product.setSalePrice(request.getSalePrice());
    }

    if (request.getAttributes() != null) {
      product.setAttributes(request.getAttributes().stream()
          .map(attr -> Product.ProductAttribute.builder()
              .name(attr.getName())
              .values(attr.getValues())
              .build())
          .toList());
    }

    if (request.getCategoryId() != null) {
      var category = categoryClient.getCategoryById(request.getCategoryId()).getData();
      if (category == null) {
        throw new IdInvalidException(
            "Category with ID = " + request.getCategoryId() + " not found");
      }
      product.setCategory(ProductResponse.Category.builder()
          .id(category.getId())
          .name(category.getName())
          .description(category.getDescription())
          .parentId(category.getParentId())
          .isParent(category.getIsParent())
          .level(category.getLevel())
          .image(category.getImage())
          .build());
    }

    if (request.getBrandId() != null) {
      var brand = brandClient.getBrandById(request.getBrandId()).getData();
      if (brand == null) {
        throw new IdInvalidException("Brand with ID = " + request.getBrandId() + " not found");
      }
      product.setBrand(ProductResponse.Brand.builder()
          .id(brand.getId())
          .name(brand.getName())
          .description(brand.getDescription())
          .image(brand.getImage())
          .isFeature(brand.getIsFeature())
          .build());
    }

    if (request.getVariants() != null) {
      product.setVariants(request.getVariants().stream()
          .map(v -> Product.Variant.builder()
              .variantId(v.getVariantId() != null ? v.getVariantId() : UUID.randomUUID().toString())
              .variantName(v.getVariantName())
              .description(v.getDescription())
              .image(v.getImage())
              .price(v.getPrice())
              .salePrice(v.getSalePrice())
              .quantity(v.getQuantity())
              .stockStatus(v.getStockStatus())
              .attributeVariant(v.getAttributeVariant().stream()
                  .map(attr -> Product.AttributeValue.builder()
                      .name(attr.getName())
                      .value(attr.getValue())
                      .build())
                  .toList())
              .build())
          .toList());
    }

    product.preSave(SecurityUtil.getCurrentUserId());
    return productMapper.toProductResponse(productRepository.save(product));
  }

  //fetch product by id
  public ProductResponse getProductById(String id) throws IdInvalidException {
    Product product = productRepository.findById(id)
        .orElseThrow(() -> new IdInvalidException("Product with this ID = " + id + " not found"));

    return productMapper.toProductResponse(product);
  }

  // fetch all products
  public PageResponse<ProductResponse> fetchAllProducts(int page, int size) {
    var pageable = PageRequest.of(page - 1, size, Sort.by("createdAt").descending());
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
    var pageable = PageRequest.of(page - 1, size, Sort.by("createdAt").descending());
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


  // fitler product variant by attribute
  public FilterVariantResponse filterVariant(FilterVariantRequest request)
      throws IdInvalidException {
    Product product = productRepository.findById(request.getProductId())
        .orElseThrow(() -> new IdInvalidException("Product not found"));

    return product.getVariants().stream()
        .filter(variant -> {
          if (variant.getAttributeVariant() == null) {
            return false;
          }
          return request.getFilters().stream().allMatch(filter ->
              variant.getAttributeVariant().stream()
                  .anyMatch(attr -> attr.getName().equalsIgnoreCase(filter.getName())
                      && attr.getValue().equalsIgnoreCase(filter.getValue()))
          );
        })
        .findFirst()
        .map(variant -> FilterVariantResponse.builder()
            .variantId(variant.getVariantId())
            .variantName(variant.getVariantName())
            .image(variant.getImage())
            .description(variant.getDescription())
            .price(variant.getPrice())
            .salePrice(variant.getSalePrice())
            .quantity(variant.getQuantity())
            .stockStatus(variant.getStockStatus())
            .attributeVariant(
                variant.getAttributeVariant().stream()
                    .map(attr -> FilterVariantResponse.AttributeVariantResponse.builder()
                        .name(attr.getName())
                        .value(attr.getValue())
                        .build())
                    .collect(Collectors.toList())
            )
            .build())
        .orElseThrow(() -> new IdInvalidException("No matching variant found"));
  }


  // fetch all products by higher price (descending order)
  public PageResponse<ProductResponse> fetchAllProductsByHigherPrice(int page, int size) {
    var pageable = PageRequest.of(page - 1, size, Sort.by("price").descending());
    var pageData = productRepository.findAll(pageable);

    return PageResponse.<ProductResponse>builder()
        .currentPage(page)
        .pageSize(pageData.getSize())
        .totalPages(pageData.getTotalPages())
        .totalElements(pageData.getTotalElements())
        .data(pageData.getContent().stream().map(productMapper::toProductResponse).toList())
        .build();
  }

  // fetch all products by lower price (ascending order)
  public PageResponse<ProductResponse> fetchAllProductsByLowerPrice(int page, int size) {
    var pageable = PageRequest.of(page - 1, size, Sort.by("price").ascending());
    var pageData = productRepository.findAll(pageable);

    return PageResponse.<ProductResponse>builder()
        .currentPage(page)
        .pageSize(pageData.getSize())
        .totalPages(pageData.getTotalPages())
        .totalElements(pageData.getTotalElements())
        .data(pageData.getContent().stream().map(productMapper::toProductResponse).toList())
        .build();
  }

  // fetch all products by lower price (ascending order)
  public PageResponse<ProductResponse> fetchAllProductsBySalePrice(int page, int size) {
    var pageable = PageRequest.of(page - 1, size, Sort.by("salePrice").descending());
    var pageData = productRepository.findAll(pageable);

    return PageResponse.<ProductResponse>builder()
        .currentPage(page)
        .pageSize(pageData.getSize())
        .totalPages(pageData.getTotalPages())
        .totalElements(pageData.getTotalElements())
        .data(pageData.getContent().stream().map(productMapper::toProductResponse).toList())
        .build();
  }

  // fetch all products sorted by name ascending (A-Z)
  public PageResponse<ProductResponse> fetchAllProductsByNameAscending(int page, int size) {
    var pageable = PageRequest.of(page - 1, size, Sort.by("name").ascending());
    var pageData = productRepository.findAll(pageable);

    return PageResponse.<ProductResponse>builder()
        .currentPage(page)
        .pageSize(pageData.getSize())
        .totalPages(pageData.getTotalPages())
        .totalElements(pageData.getTotalElements())
        .data(pageData.getContent().stream().map(productMapper::toProductResponse).toList())
        .build();
  }

  // fetch all products sorted by createdAt descending (newest first)
  public PageResponse<ProductResponse> fetchAllProductsByNewest(int page, int size) {
    var pageable = PageRequest.of(page - 1, size, Sort.by("createdAt").descending());
    var pageData = productRepository.findAll(pageable);

    return PageResponse.<ProductResponse>builder()
        .currentPage(page)
        .pageSize(pageData.getSize())
        .totalPages(pageData.getTotalPages())
        .totalElements(pageData.getTotalElements())
        .data(pageData.getContent().stream().map(productMapper::toProductResponse).toList())
        .build();
  }

  // fetch all products by brand id
  public PageResponse<ProductResponse> fetchAllProductsByBrandId(int page, int size,
      String brandId) {
    var pageable = PageRequest.of(page - 1, size, Sort.by("createdAt").descending());
    var pageData = productRepository.findByBrand_Id(brandId, pageable);

    return PageResponse.<ProductResponse>builder()
        .currentPage(page)
        .pageSize(pageData.getSize())
        .totalPages(pageData.getTotalPages())
        .totalElements(pageData.getTotalElements())
        .data(pageData.getContent().stream().map(productMapper::toProductResponse).toList())
        .build();
  }

  // Get all brands by categoryId
  public List<ProductResponse.Brand> getBrandsByCategoryId(String categoryId) {
    var productsInCategory = productRepository.findByCategory_Id(categoryId);

    Map<String, List<Product>> brandProductsMap = productsInCategory.stream()
        .filter(p -> p.getBrand() != null)
        .collect(Collectors.groupingBy(p -> p.getBrand().getId()));

    List<ProductResponse.Brand> brands = new ArrayList<>();

    for (Map.Entry<String, List<Product>> entry : brandProductsMap.entrySet()) {
      if (!entry.getValue().isEmpty()) {
        Product firstProduct = entry.getValue().get(0);
        ProductResponse.Brand brand = firstProduct.getBrand();

        ProductResponse.Brand brandCopy = ProductResponse.Brand.builder()
            .id(brand.getId())
            .name(brand.getName())
            .description(brand.getDescription())
            .image(brand.getImage())
            .isFeature(brand.getIsFeature())
            .build();

        brands.add(brandCopy);
      }
    }
    return brands;
  }

  // Get products by list string id
  public List<ProductResponse> fetchProductsByIds(List<String> ids) {
    List<Product> products = productRepository.findAllById(ids);

    return products.stream()
        .map(productMapper::toProductResponse)
        .collect(Collectors.toList());
  }
}
