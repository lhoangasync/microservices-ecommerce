package com.laptopexpress.brand_service.repository;

import com.laptopexpress.brand_service.entity.Brand;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface BrandRepository extends MongoRepository<Brand, String> {

}
