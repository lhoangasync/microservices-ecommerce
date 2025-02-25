package com.laptopexpress.product_service.listener;


import com.laptopexpress.event.dto.CategoryDeletedEvent;
import com.laptopexpress.event.dto.CategoryUpdatedEvent;
import com.laptopexpress.product_service.dto.response.ProductResponse.Category;
import com.laptopexpress.product_service.entity.Product;
import com.laptopexpress.product_service.mapper.ProductMapper;
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
public class CategoryUpdateEvent {

  ProductRepository productRepository;
  ProductMapper productMapper;

  @KafkaListener(topics = "category-update-topic")
  public void updateCategoryInProduct(CategoryUpdatedEvent categoryUpdatedEvent) {
    var products = productRepository.findByCategory_Id(categoryUpdatedEvent.getId());

    products.forEach(product -> {
      product.setCategory(Category.builder()
          .id(categoryUpdatedEvent.getId())
          .name(categoryUpdatedEvent.getName())
          .description(categoryUpdatedEvent.getDescription())
          .image(categoryUpdatedEvent.getImage())
          .build());

      productRepository.save(product);
    });
  }

  @KafkaListener(topics = "category-delete-topic")
  public void deleteCategoryInProduct(CategoryDeletedEvent categoryDeletedEvent) {
    productRepository.deleteByCategory_Id(categoryDeletedEvent.getCategoryId());

    System.out.println(">> check event deleted: " + categoryDeletedEvent.getCategoryId());
  }
}
