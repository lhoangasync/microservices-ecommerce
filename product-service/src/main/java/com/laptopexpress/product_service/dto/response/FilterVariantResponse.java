package com.laptopexpress.product_service.dto.response;

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
public class FilterVariantResponse {

  String variantId;
  String variantName;
  String image;
  String description;
  Double price;
  Double salePrice;
  Integer quantity;
  StockStatus stockStatus;
  List<AttributeVariantResponse> attributeVariant;

  @Data
  @Builder
  @NoArgsConstructor
  @AllArgsConstructor
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class AttributeVariantResponse {

    String name;
    String value;
  }
}
