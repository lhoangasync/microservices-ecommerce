package com.laptopexpress.category_service.service;

import com.laptopexpress.category_service.dto.PageResponse;
import com.laptopexpress.category_service.dto.request.CategoryRequest;
import com.laptopexpress.category_service.dto.request.CategoryUpdateRequest;
import com.laptopexpress.category_service.dto.response.CategoryResponse;
import com.laptopexpress.category_service.entity.Category;
import com.laptopexpress.category_service.exception.IdInvalidException;
import com.laptopexpress.category_service.mapper.CategoryMapper;
import com.laptopexpress.category_service.repository.CategoryRepository;

import com.laptopexpress.event.dto.CategoryDeletedEvent;
import com.laptopexpress.event.dto.CategoryUpdatedEvent;
import java.util.List;
import java.util.stream.Collectors;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class CategoryService {

  CategoryRepository categoryRepository;
  CategoryMapper categoryMapper;
  KafkaTemplate<String, Object> kafkaTemplate;

  //create a category
  public CategoryResponse createCategory(CategoryRequest categoryRequest) {
    Category category = Category.builder()
        .name(categoryRequest.getName())
        .description(categoryRequest.getDescription())
        .image(categoryRequest.getImage())
        .parentId(categoryRequest.getParentId())
        .build();

    Category savedCategory = categoryRepository.save(category);
    return categoryMapper.toCategoryResponse(savedCategory);
  }

  //update a category
  public CategoryResponse updateCategory(CategoryUpdateRequest request) throws IdInvalidException {
    Category category = categoryRepository.findById(request.getId()).orElseThrow(
        () -> new IdInvalidException("Category with this ID = " + request.getId() + " not found"));

    if (request.getName() != null) {
      category.setName(request.getName());
    }
    if (request.getDescription() != null) {
      category.setDescription(request.getDescription());
    }
    if (request.getImage() != null) {
      category.setImage(request.getImage());
    }

    if (request.getParentId() != null) {
      category.setParentId(request.getParentId());
    }

    Category savedCategory = categoryRepository.save(category);
    CategoryUpdatedEvent event = CategoryUpdatedEvent.builder()
        .id(savedCategory.getId())
        .name(savedCategory.getName())
        .description(savedCategory.getDescription())
        .image(savedCategory.getImage())
        .parentId(savedCategory.getParentId())
        .build();

    kafkaTemplate.send("category-update-topic", event);
    return categoryMapper.toCategoryResponse(savedCategory);
  }

  //fetch category by id
  public CategoryResponse getCategoryById(String id) throws IdInvalidException {
    Category category = categoryRepository.findById(id).orElseThrow(
        () -> new IdInvalidException("Category with this ID = " + id + " not found"));

    return categoryMapper.toCategoryResponse(category);
  }

  // fetch all categories
  public PageResponse<CategoryResponse> fetchAllCategories(int page, int size) {
    Sort sort = Sort.by("createdAt").descending();
    Pageable pageable = PageRequest.of(page - 1, size, sort);

    var pageData = categoryRepository.findAll(pageable);

    return PageResponse.<CategoryResponse>builder()
        .currentPage(page)
        .pageSize(pageData.getSize())
        .totalPages(pageData.getTotalPages())
        .totalElements(pageData.getTotalElements())
        .data(pageData.getContent().stream().map(categoryMapper::toCategoryResponse).toList())
        .build();
  }

  // delete category
  public void deleteCategory(String id) throws IdInvalidException {
    Category category = categoryRepository.findById(id)
        .orElseThrow(() -> new IdInvalidException("Category with this ID = " + id + " not found"));

    if (category.getIsParent()) {
      categoryRepository.deleteByParentId(id);
    }
    categoryRepository.delete(category);

    CategoryDeletedEvent event = CategoryDeletedEvent.builder()
        .categoryId(id)
        .build();

    kafkaTemplate.send("category-delete-topic", event);
  }

  public List<CategoryResponse> getSubCategories(String categoryId) throws IdInvalidException {
    if (!categoryRepository.existsById(categoryId)) {
      throw new IdInvalidException("Category with ID = " + categoryId + " not found");
    }

    List<Category> subCategories = categoryRepository.findByParentId(categoryId);
    return subCategories.stream()
        .map(categoryMapper::toCategoryResponse)
        .collect(Collectors.toList());
  }

}
