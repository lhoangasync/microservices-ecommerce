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
  List<String> image;
  String categoryId;
  String brandId;
  String status;
  List<VariantRequest> variants;

  @Data
  @Builder
  @NoArgsConstructor
  @AllArgsConstructor
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class VariantRequest {

    String variantName;
    Double price;
    Integer quantity;
    StockStatus stockStatus;
  }
}