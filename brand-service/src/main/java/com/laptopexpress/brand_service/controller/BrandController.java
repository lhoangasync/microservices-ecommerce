package com.laptopexpress.brand_service.controller;


import com.laptopexpress.brand_service.dto.ApiResponse;
import com.laptopexpress.brand_service.dto.PageResponse;
import com.laptopexpress.brand_service.dto.request.BrandRequest;
import com.laptopexpress.brand_service.dto.request.BrandUpdateRequest;
import com.laptopexpress.brand_service.dto.response.BrandResponse;
import com.laptopexpress.brand_service.exception.IdInvalidException;
import com.laptopexpress.brand_service.service.BrandService;
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
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/brands")
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class BrandController {

  BrandService brandService;

  @PostMapping("/create")
  ApiResponse<BrandResponse> createBrand(@RequestBody BrandRequest brandRequest) {
    return ApiResponse.<BrandResponse>builder()
        .code(HttpStatus.CREATED.value())
        .error(null)
        .message("Generate Brand Successfully")
        .data(brandService.createBrand(brandRequest))
        .build();
  }

  @PutMapping("/update")
  ApiResponse<BrandResponse> updateBrand(@RequestBody BrandUpdateRequest request)
      throws IdInvalidException {
    return ApiResponse.<BrandResponse>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Update Brand Successfully")
        .data(brandService.updateBrand(request))
        .build();
  }

  @GetMapping("/get-by-id/{id}")
  ApiResponse<BrandResponse> getBrandById(@PathVariable String id) throws IdInvalidException {
    return ApiResponse.<BrandResponse>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get Brand Successfully")
        .data(brandService.fetchBrandById(id))
        .build();
  }

  @GetMapping("/get-all")
  ApiResponse<PageResponse<BrandResponse>> getALlBrands(
      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
      @RequestParam(value = "size", required = false, defaultValue = "10") int size
  ) {
    return ApiResponse.<PageResponse<BrandResponse>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get All Brands Successfully")
        .data(brandService.fetchAllBrands(page, size))
        .build();
  }

  @DeleteMapping("/delete/{id}")
  ApiResponse<Void> deleteBrand(@PathVariable String id) throws IdInvalidException {
    brandService.deleteBrand(id);
    return ApiResponse.<Void>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Delete Brand Successfully")
        .data(null)
        .build();
  }

}
