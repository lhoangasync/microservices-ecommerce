import 'package:ecommerce_app/features/shop/controllers/product/image_controller.dart';
import 'package:ecommerce_app/features/shop/models/product_model.dart';
import 'package:ecommerce_app/features/shop/models/product_variation_model.dart';
import 'package:get/get.dart';

class VariationController extends GetxController {
  static VariationController get instance => Get.find();

  // variables
  RxMap selectedAttributes = {}.obs;
  RxString variationStockStatus = ''.obs;
  Rx<ProductVariationModel> selectedVariation =
      ProductVariationModel.empty().obs;

  // selected attributes, and variation
  void onAttributeSelected(
    ProductModel product,
    attributeName,
    attributeValue,
  ) {
    final selectedAttributes = Map<String, dynamic>.from(
      this.selectedAttributes,
    );
    selectedAttributes[attributeName] = attributeValue;
    this.selectedAttributes[attributeName] = attributeValue;

    final selectedVariation = product.variants.firstWhere((variation) {
      final variationAttributes = {
        for (var attr in variation.attributeVariant) attr.name: attr.value,
      };

      return _isSameAttributeValues(variationAttributes, selectedAttributes);
    }, orElse: () => ProductVariationModel.empty());
    if (selectedVariation.image.isNotEmpty) {
      ImageController.instance.selectedProductImage.value =
          selectedVariation.image;
    }

    // assign selected variation
    this.selectedVariation.value = selectedVariation;

    // update selected product variation status
    getProductVariationStockStatus();
  }

  // check if selected attributes matches any variant attributes
  bool _isSameAttributeValues(
    Map<String, dynamic> variationAttributes,
    Map<String, dynamic> selectedAttributes,
  ) {
    if (variationAttributes.length != selectedAttributes.length) return false;

    for (final key in variationAttributes.keys) {
      if (variationAttributes[key] != selectedAttributes[key]) return false;
    }

    return true;
  }

  // check attribute availability / stock in variation
  Set<String?> getAttributesAvailabilityInVariation(
    List<ProductVariationModel> variations,
    String attributeName,
  ) {
    final availableVariationAttributeValues =
        variations
            .where(
              (variation) => variation.attributeVariant.any(
                (attr) =>
                    attr.name == attributeName &&
                    attr.value.isNotEmpty &&
                    variation.quantity > 0,
              ),
            )
            .map(
              (variation) =>
                  variation.attributeVariant
                      .firstWhere((attr) => attr.name == attributeName)
                      .value,
            )
            .toSet();

    return availableVariationAttributeValues;
  }

  String getVariationPrice() {
    return (selectedVariation.value.salePrice > 0
            ? selectedVariation.value.salePrice
            : selectedVariation.value.price)
        .toString();
  }

  // check product variation stock status
  void getProductVariationStockStatus() {
    variationStockStatus.value =
        selectedVariation.value.quantity > 0 ? 'In Stock' : 'Out of Stock';
  }

  // Reset selected attributes when switching products
  void resetSelectedAttributes() {
    selectedAttributes.clear();
    variationStockStatus.value = '';
    selectedVariation.value = ProductVariationModel.empty();
  }
}
