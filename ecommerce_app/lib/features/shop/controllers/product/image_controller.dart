import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageController extends GetxController {
  static ImageController get instance => Get.find();

  // variables
  RxString selectedProductImage = ''.obs;

  // get all image from product and variations
  List<String> getAllProductImages(ProductModel product) {
    Set<String> images = {};

    // load thumbnail image
    images.add(product.thumbnail);

    // asign thumbnail as selected Image
    selectedProductImage.value = product.thumbnail;

    // get all images from the product model if not null
    // ignore: unnecessary_null_comparison
    if (product.image != null) {
      images.addAll(product.image);
    }

    // get all images from the product variations if not null
    // ignore: unnecessary_null_comparison
    if (product.variants != null || product.variants.isNotEmpty) {
      images.addAll(product.variants.map((variants) => variants.image));
    }

    return images.toList();
  }

  // show image POPUP
  void showEnlargedImage(String image) {
    Get.to(
      fullscreenDialog: true,
      () => Dialog.fullscreen(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TSizes.defaultSpace * 2,
                horizontal: TSizes.defaultSpace,
              ),
              child: CachedNetworkImage(imageUrl: image),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 150,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Close'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
