package com.laptopexpress.product_service.repository;

import com.laptopexpress.product_service.entity.Product;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends MongoRepository<Product, String> {

  List<Product> findByCategory_Id(String categoryId);

  Page<Product> findByCategory_Id(String categoryId, Pageable pageable);

  void deleteByCategory_Id(String categoryId);

  List<Product> findByBrand_Id(String brandId);

  Page<Product> findByBrand_Id(String brandId, Pageable pageable);
}
