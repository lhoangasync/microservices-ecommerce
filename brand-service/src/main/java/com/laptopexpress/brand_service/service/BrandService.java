package com.laptopexpress.brand_service.service;


import com.laptopexpress.brand_service.dto.PageResponse;
import com.laptopexpress.brand_service.dto.request.BrandRequest;
import com.laptopexpress.brand_service.dto.request.BrandUpdateRequest;
import com.laptopexpress.brand_service.dto.response.BrandResponse;
import com.laptopexpress.brand_service.entity.Brand;
import com.laptopexpress.brand_service.exception.IdInvalidException;
import com.laptopexpress.brand_service.mapper.BrandMapper;
import com.laptopexpress.brand_service.repository.BrandRepository;
import java.util.stream.Collectors;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class BrandService {

  BrandRepository brandRepository;
  BrandMapper brandMapper;

  // create a brand
  public BrandResponse createBrand(BrandRequest brandRequest) {
    Brand brand = Brand.builder()
        .name(brandRequest.getName())
        .description(brandRequest.getDescription())
        .image(brandRequest.getImage())
        .build();
    Brand savedBrand = brandRepository.save(brand);
    return brandMapper.toBrandResponse(savedBrand);
  }

  // update a brand
  public BrandResponse updateBrand(BrandUpdateRequest request) throws IdInvalidException {
    Brand brand = brandRepository.findById(request.getId())
        .orElseThrow(
            () -> new IdInvalidException("Brand with this ID = " + request.getId() + " not found"));

    if (request.getName() != null) {
      brand.setName(request.getName());
    }
    if (request.getDescription() != null) {
      brand.setDescription(request.getDescription());
    }
    if (request.getImage() != null) {
      brand.setImage(request.getImage());
    }
    Brand savedBrand = brandRepository.save(brand);
    return brandMapper.toBrandResponse(savedBrand);
  }

  // fetch brand by id
  public BrandResponse fetchBrandById(String id) throws IdInvalidException {
    Brand brand = brandRepository.findById(id)
        .orElseThrow(
            () -> new IdInvalidException("Brand with this ID = " + id + " not found"));

    return brandMapper.toBrandResponse(brand);

  }

  // fetch all brands
  public PageResponse<BrandResponse> fetchAllBrands(int page, int size) {
    Sort sort = Sort.by("createdAt").descending();
    Pageable pageable = PageRequest.of(page - 1, size, sort);

    var pageData = brandRepository.findAll(pageable);

    return PageResponse.<BrandResponse>builder()
        .currentPage(page)
        .pageSize(pageData.getContent().size())
        .totalPages(pageData.getTotalPages())
        .totalElements(pageData.getTotalElements())
        .data(pageData.getContent().stream().map(brandMapper::toBrandResponse).toList())
        .build();
  }

  // delete brand
  public void deleteBrand(String id) throws IdInvalidException {
    Brand brand = brandRepository.findById(id)
        .orElseThrow(
            () -> new IdInvalidException("Brand with this ID = " + id + " not found"));
    
    brandRepository.delete(brand);
  }
}
