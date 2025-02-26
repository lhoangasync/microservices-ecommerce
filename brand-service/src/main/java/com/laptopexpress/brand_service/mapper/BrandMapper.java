package com.laptopexpress.brand_service.mapper;


import com.laptopexpress.brand_service.dto.response.BrandResponse;
import com.laptopexpress.brand_service.entity.Brand;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface BrandMapper {

  BrandResponse toBrandResponse(Brand brand);
}
