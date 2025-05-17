package com.laptopexpress.product_service.dto.request;

import com.laptopexpress.product_service.enums.StockStatus;
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
public class ProductRequest {

  String name;
  String description;
  Integer quantity;
  List<String> image;
  String categoryId;
  String brandId;
  String status;
  Double price;
  Double salePrice;
  String thumbnail;

  List<ProductAttributeRequest> attributes;
  List<VariantRequest> variants;

  @Data
  @Builder
  @NoArgsConstructor
  @AllArgsConstructor
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class ProductAttributeRequest {

    String name;
    List<String> values;
  }

  @Data
  @Builder
  @NoArgsConstructor
  @AllArgsConstructor
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class VariantRequest {

    String variantName;
    String image;
    String description;
    Double price;
    Double salePrice;
    Integer quantity;
    StockStatus stockStatus;


    List<AttributeValueRequest> attributeVariant;
  }

  @Data
  @Builder
  @NoArgsConstructor
  @AllArgsConstructor
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class AttributeValueRequest {

    String name;
    String value;
  }
}
