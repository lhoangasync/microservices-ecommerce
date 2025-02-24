package com.laptopexpress.category_service.listener;

import com.laptopexpress.category_service.entity.Category;
import com.laptopexpress.category_service.util.SecurityUtil;
import org.springframework.data.mongodb.core.mapping.event.AbstractMongoEventListener;
import org.springframework.data.mongodb.core.mapping.event.BeforeConvertEvent;
import org.springframework.stereotype.Component;

@Component
public class CategoryEntityListener extends AbstractMongoEventListener<Category> {

  @Override
  public void onBeforeConvert(BeforeConvertEvent<Category> event) {
    String currentUser =
        SecurityUtil.getCurrentUserLogin().isPresent() ? SecurityUtil.getCurrentUserLogin().get()
            : "";

    event.getSource().preSave(currentUser);
  }

}
