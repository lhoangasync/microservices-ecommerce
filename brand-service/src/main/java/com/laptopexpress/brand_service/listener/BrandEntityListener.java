package com.laptopexpress.brand_service.listener;

import com.laptopexpress.brand_service.entity.Brand;
import com.laptopexpress.brand_service.util.SecurityUtil;
import org.springframework.data.mongodb.core.mapping.event.AbstractMongoEventListener;
import org.springframework.data.mongodb.core.mapping.event.BeforeConvertEvent;
import org.springframework.stereotype.Component;


@Component
public class BrandEntityListener extends AbstractMongoEventListener<Brand> {

  @Override
  public void onBeforeConvert(BeforeConvertEvent<Brand> event) {
    String currentUser =
        SecurityUtil.getCurrentUserLogin().isPresent() ? SecurityUtil.getCurrentUserLogin().get()
            : "";

    event.getSource().preSave(currentUser);
  }

}
