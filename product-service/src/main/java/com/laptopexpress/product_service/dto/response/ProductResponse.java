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
  Integer quantity;
  List<String> image;
  String status;
  Double price;
  Double salePrice;
  Category category;
  Brand brand;
  String thumbnail;

  List<ProductAttributeResponse> attributes;
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
    Boolean isFeature;
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
    String parentId;
    Boolean isParent;
    int level;
  }

  @Data
  @Builder
  @NoArgsConstructor
  @AllArgsConstructor
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class ProductAttributeResponse {

    String name;
    List<String> values;
  }

  @Data
  @Builder
  @NoArgsConstructor
  @AllArgsConstructor
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class VariantResponse {

    String variantId;
    String variantName;
    String image;
    String description;
    Double price;
    Double salePrice;
    Integer quantity;
    StockStatus stockStatus;

    List<AttributeValueResponse> attributeVariant;
  }

  @Data
  @Builder
  @NoArgsConstructor
  @AllArgsConstructor
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class AttributeValueResponse {

    String name;
    String value;
  }
}
