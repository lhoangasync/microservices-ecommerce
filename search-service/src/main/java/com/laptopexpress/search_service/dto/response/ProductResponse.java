package com.laptopexpress.search_service.dto.response;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

import java.time.Instant;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ProductResponse {

  String id;
  String userId;
  String name;
  String brand;
  String description;
  List<String> image;
  String status;
  Category category;
  List<VariantResponse> variants;
  String createdBy;
  String updatedBy;
  Instant createdAt;
  Instant updatedAt;

  @Data
  @Builder
  @NoArgsConstructor
  @AllArgsConstructor
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class Category {

    String id;
    String name;
  }

  @Data
  @Builder
  @NoArgsConstructor
  @AllArgsConstructor
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class VariantResponse {

    String variantId;
    String variantName;
    Double price;
    Integer quantity;
    String stockStatus;
  }
}