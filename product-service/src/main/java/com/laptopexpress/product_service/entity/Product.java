package com.laptopexpress.product_service.entity;

import com.laptopexpress.product_service.enums.StockStatus;
import java.time.Instant;
import java.util.List;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.FieldDefaults;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.MongoId;

@Getter
@Setter
@Builder
@Document(value = "products")
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Product {

  @MongoId
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


  public void preSave(String currentUser) {
    if (this.id == null) {
      this.createdBy = currentUser;
      this.createdAt = Instant.now();
    } else {
      this.updatedBy = currentUser;
      this.updatedAt = Instant.now();
    }
  }
}
