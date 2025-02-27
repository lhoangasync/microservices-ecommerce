package com.laptopexpress.product_service.dto.request;

import com.laptopexpress.product_service.enums.StockStatus;
import jakarta.validation.constraints.NotBlank;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ProductUpdateRequest {

  @NotBlank(message = "Product ID cannot be empty!!")
  String id;

  String name;
  String description;
  List<String> image;
  String categoryId;
  String brandId;
  String status;
  List<VariantRequest> variants;

  @Data
  @NoArgsConstructor
  @AllArgsConstructor
  @Builder
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class VariantRequest {

    String variantId;
    String variantName;
    Double price;
    Integer quantity;
    StockStatus stockStatus;
  }
}