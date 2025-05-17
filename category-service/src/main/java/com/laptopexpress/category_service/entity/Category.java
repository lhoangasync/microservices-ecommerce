package com.laptopexpress.category_service.entity;

import java.time.Instant;
import java.util.List;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.FieldDefaults;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.MongoId;

@Getter
@Setter
@Builder
@Document(value = "categories")
@FieldDefaults(level = AccessLevel.PRIVATE)
@AllArgsConstructor
@NoArgsConstructor
public class Category {

  @MongoId
  String id;
  String name;
  String description;
  String image;

  String parentId;

  Boolean isParent;

  int level;

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

    if (this.parentId == null) {
      this.isParent = true;
      this.level = 0;
    } else {
      this.isParent = false;

      this.level = 1;
    }
  }
}