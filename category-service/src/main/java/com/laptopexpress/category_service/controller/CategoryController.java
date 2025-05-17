package com.laptopexpress.category_service.controller;

import com.laptopexpress.category_service.dto.ApiResponse;
import com.laptopexpress.category_service.dto.PageResponse;
import com.laptopexpress.category_service.dto.request.CategoryRequest;
import com.laptopexpress.category_service.dto.request.CategoryUpdateRequest;
import com.laptopexpress.category_service.dto.response.CategoryResponse;
import com.laptopexpress.category_service.exception.IdInvalidException;
import com.laptopexpress.category_service.service.CategoryService;
import java.util.List;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/categories")
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class CategoryController {

  CategoryService categoryService;

  @PostMapping("/create")
  ApiResponse<CategoryResponse> createCategory(@RequestBody CategoryRequest categoryRequest) {
    return ApiResponse.<CategoryResponse>builder()
        .code(HttpStatus.CREATED.value())
        .error(null)
        .message("Generate Category Successfully")
        .data(categoryService.createCategory(categoryRequest))
        .build();
  }

  @PutMapping("/update")
  ApiResponse<CategoryResponse> updateCategory(@RequestBody CategoryUpdateRequest request)
      throws IdInvalidException {
    return ApiResponse.<CategoryResponse>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Update Category Successfully")
        .data(categoryService.updateCategory(request))
        .build();
  }

  @GetMapping("/get-by-id/{id}")
  ApiResponse<CategoryResponse> getCategoryById(@PathVariable String id) throws IdInvalidException {
    return ApiResponse.<CategoryResponse>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get Category Successfully")
        .data(categoryService.getCategoryById(id))
        .build();
  }

  @GetMapping("/get-all")
  ApiResponse<PageResponse<CategoryResponse>> getAllProducts(
      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
      @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
    return ApiResponse.<PageResponse<CategoryResponse>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get all categories successfully!")
        .data(categoryService.fetchAllCategories(page, size))
        .build();
  }

  @DeleteMapping("/delete/{id}")
  ApiResponse<Void> deleteCategory(@PathVariable String id) throws IdInvalidException {
    categoryService.deleteCategory(id);
    return ApiResponse.<Void>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Delete category successfully!")
        .data(null)
        .build();
  }

  @GetMapping("/get-sub-categories/{categoryId}")
  ApiResponse<List<CategoryResponse>> getSubCategories(
      @PathVariable String categoryId) throws IdInvalidException {
    return ApiResponse.<List<CategoryResponse>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get subcategories successfully!")
        .data(categoryService.getSubCategories(categoryId))
        .build();
  }

}
