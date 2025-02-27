package com.laptopexpress.product_service.dto.response;

import com.laptopexpress.product_service.enums.StockStatus;
import java.time.Instant;
import java.util.List;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ProductResponse {

  String id;
  String userId;
  String name;
  String description;
  List<String> image;
  String status;
  Category category;
  Brand brand;
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
  public static class Brand {

    String id;
    String name;
    String description;
    String image;
  }

  @Data
  @Builder
  @NoArgsConstructor
  @AllArgsConstructor
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class Category {

    String id;
    String name;
    String description;
    String image;
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
    StockStatus stockStatus;
  }
}
