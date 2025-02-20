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
  String categoryId;
  Double price;
  Integer quantity;
  String status;

  StockStatus stockStatus;


  String createdBy;
  String updatedBy;
  Instant createdAt;
  Instant updatedAt;
}
