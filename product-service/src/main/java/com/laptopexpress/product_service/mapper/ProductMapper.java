package com.laptopexpress.product_service.mapper;

import com.laptopexpress.product_service.dto.request.ProductRequest;
import com.laptopexpress.product_service.dto.response.ProductResponse;
import com.laptopexpress.product_service.entity.Product;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ProductMapper {

  ProductResponse toProductResponse(Product product);
}
