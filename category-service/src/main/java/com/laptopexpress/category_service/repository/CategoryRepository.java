package com.laptopexpress.category_service.repository;

import com.laptopexpress.category_service.entity.Category;
import java.util.List;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoryRepository extends MongoRepository<Category, String> {

  void deleteByParentId(String parentId);

  List<Category> findByParentId(String parentId);
}
