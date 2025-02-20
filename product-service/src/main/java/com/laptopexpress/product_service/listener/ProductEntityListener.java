package com.laptopexpress.product_service.listener;

import com.laptopexpress.product_service.entity.Product;
import com.laptopexpress.product_service.util.SecurityUtil;
import org.springframework.data.mongodb.core.mapping.event.AbstractMongoEventListener;
import org.springframework.data.mongodb.core.mapping.event.BeforeConvertEvent;
import org.springframework.stereotype.Component;

@Component
public class ProductEntityListener extends AbstractMongoEventListener<Product> {

  @Override
  public void onBeforeConvert(BeforeConvertEvent<Product> event) {
    String currentUser =
        SecurityUtil.getCurrentUserLogin().isPresent() ? SecurityUtil.getCurrentUserLogin().get()
            : "";

    event.getSource().preSave(currentUser);
  }
}
