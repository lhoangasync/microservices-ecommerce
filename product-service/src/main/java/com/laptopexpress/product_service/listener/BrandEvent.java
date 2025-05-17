package com.laptopexpress.product_service.listener;

import com.laptopexpress.event.dto.BrandUpdatedEvent;
import com.laptopexpress.product_service.dto.response.ProductResponse.Brand;
import com.laptopexpress.product_service.repository.ProductRepository;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class BrandEvent {

  ProductRepository productRepository;

  @KafkaListener(topics = "brand-update-topic")
  public void updateBrandInProduct(BrandUpdatedEvent event) {
    var products = productRepository.findByBrand_Id(event.getId());

    products.forEach(product -> {
      product.setBrand(Brand.builder()
          .id(event.getId())
          .name(event.getName())
          .isFeature(event.getIsFeature())
          .description(event.getDescription())
          .image(event.getImage())

          .build());

      productRepository.save(product);
    });
  }

}
