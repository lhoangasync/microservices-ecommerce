package com.laptopexpress.category_service.mapper;

import com.laptopexpress.category_service.dto.response.CategoryResponse;
import com.laptopexpress.category_service.entity.Category;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface CategoryMapper {

  CategoryResponse toCategoryResponse(Category category);
}
