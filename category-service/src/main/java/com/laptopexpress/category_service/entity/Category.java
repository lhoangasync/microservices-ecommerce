package com.laptopexpress.category_service.entity;

import java.time.Instant;
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
@Document(value = "categories")
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Category {

  @MongoId
  String id;
  String name;
  String description;
  String image;

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
