package com.laptopexpress.product_service.entity;

import com.laptopexpress.product_service.dto.response.ProductResponse.Brand;
import com.laptopexpress.product_service.dto.response.ProductResponse.Category;
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
  Integer quantity;
  List<String> image;
  String status;
  Double price;
  Double salePrice;
  Category category;
  Brand brand;
  String thumbnail;

  List<ProductAttribute> attributes;
  List<Variant> variants;

  String createdBy;
  String updatedBy;
  Instant createdAt;
  Instant updatedAt;

  @Getter
  @Setter
  @Builder
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class ProductAttribute {

    String name;
    List<String> values;
  }


  @Getter
  @Setter
  @Builder
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class Variant {

    String variantId;
    String image;
    Double price;
    Double salePrice;
    String variantName;
    String description;
    Integer quantity;
    StockStatus stockStatus;
    List<AttributeValue> attributeVariant;
  }

  @Getter
  @Setter
  @Builder
  @FieldDefaults(level = AccessLevel.PRIVATE)
  public static class AttributeValue {

    String name;
    String value;
  }


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
